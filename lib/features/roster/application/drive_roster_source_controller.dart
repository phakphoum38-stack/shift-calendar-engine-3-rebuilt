import 'package:flutter/foundation.dart';

import '../domain/drive_roster_source.dart';
import '../infrastructure/google_auth_controller.dart';
import '../../exchange/application/exchange_controller.dart';
import '../../../domain/entities/exchange_request.dart';
import '../../../domain/entities/employee.dart';
import '../../../domain/entities/shift_assignment.dart';
import 'drive_roster_source_gateway.dart';

class DriveRosterSourceController extends ChangeNotifier {
  DriveRosterSourceController({
    required this.gateway,
    required this.auth,
    this.selector = const DriveRosterSourceSelector(),
  });

  final DriveRosterSourceGateway gateway;
  final GoogleAuthController auth;
  final DriveRosterSourceSelector selector;

  List<DriveRosterSource> _recentSources = const [];
  DriveRosterSource? _lastImported;
  DriveRosterSource? _selectedSource;
  SheetReadMode _readMode = SheetReadMode.configured;
  SheetTimelineData? _timeline;
  int _headerRowIndex = 0;
  Map<ExchangeSheetField, int?> _columnMapping = const {};
  bool _loading = false;
  String? _errorCode;

  List<DriveRosterSource> get recentSources => _recentSources;
  DriveRosterSource? get lastImported => _lastImported;
  DriveRosterSource? get selectedSource => _selectedSource;
  SheetReadMode get readMode => _readMode;
  SheetTimelineData? get timeline => _timeline;
  int get headerRowIndex => _headerRowIndex;
  Map<ExchangeSheetField, int?> get columnMapping => _columnMapping;
  List<String> get timelineHeaders =>
      _timeline?.headersAt(_headerRowIndex) ?? const [];
  List<ExchangeTimelineRow> get mappedTimelineRows {
    final value = _timeline;
    if (value == null) return const [];
    final result = <ExchangeTimelineRow>[];
    for (
      var rowIndex = _headerRowIndex + 1;
      rowIndex < value.rows.length;
      rowIndex++
    ) {
      final mapped = _mappedRow(value.rows[rowIndex], rowIndex + 1);
      if (mapped.values.values.any((cell) => cell.trim().isNotEmpty)) {
        result.add(mapped);
      }
    }
    return List.unmodifiable(result);
  }

  bool get loading => _loading;
  String? get errorCode => _errorCode;

  Future<void> initializeGoogle(String webClientId) =>
      auth.initialize(webClientId);

  Future<void> refresh() async {
    if (_loading) return;
    _loading = true;
    _errorCode = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        gateway.listRecentlyModified(),
        gateway.loadLastImported(),
      ]);
      _recentSources = selector.selectMonthlySources(
        results[0] as List<DriveRosterSource>,
      );
      _lastImported = results[1] as DriveRosterSource?;
      if (_selectedSource != null &&
          !_recentSources.any((source) => source.id == _selectedSource!.id)) {
        _selectedSource = null;
        _clearTimeline();
      }
    } on DriveRosterSourceException catch (error) {
      _errorCode = error.code;
    } catch (_) {
      _errorCode = 'google_drive_load_failed';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void select(DriveRosterSource? source) {
    if (identical(source, _selectedSource)) return;
    _selectedSource = source;
    _clearTimeline();
    _errorCode = null;
    notifyListeners();
  }

  Future<bool> loadFirstTimeline() async {
    final source = _selectedSource;
    if (source == null || _loading) return false;
    _loading = true;
    _errorCode = null;
    notifyListeners();
    try {
      _timeline = await gateway.loadFirstTimeline(source);
      _headerRowIndex = 0;
      _columnMapping = _suggestMapping(timelineHeaders);
      return true;
    } on DriveRosterSourceException catch (error) {
      _errorCode = error.code;
      return false;
    } catch (_) {
      _errorCode = 'sheet_timeline_load_failed';
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void selectHeaderRow(int index) {
    final value = _timeline;
    if (value == null || index < 0 || index >= value.rows.length) return;
    _headerRowIndex = index;
    _columnMapping = _suggestMapping(timelineHeaders);
    notifyListeners();
  }

  void mapColumn(ExchangeSheetField field, int? columnIndex) {
    _columnMapping = {..._columnMapping, field: columnIndex};
    notifyListeners();
  }

  Future<TimelineExchangeImportResult> createCoverRequests(
    ExchangeController exchangeController,
  ) async {
    if (_loading) {
      return const TimelineExchangeImportResult(created: 0, skipped: 0);
    }
    _loading = true;
    _errorCode = null;
    notifyListeners();
    var created = 0;
    var skipped = 0;
    try {
      await exchangeController.load();
      for (final row in mappedTimelineRows) {
        final giver = _findEmployee(
          exchangeController,
          row.value(ExchangeSheetField.giver),
        );
        final receiver = _findEmployee(
          exchangeController,
          row.value(ExchangeSheetField.receiver),
        );
        final date = _parseDate(row.value(ExchangeSheetField.date));
        final type = row.value(ExchangeSheetField.type).toLowerCase();
        if (giver == null ||
            receiver == null ||
            date == null ||
            type.contains('swap') ||
            type.contains('แลก')) {
          skipped++;
          continue;
        }
        final shiftCode = row
            .value(ExchangeSheetField.shift)
            .trim()
            .toLowerCase();
        final day = exchangeController.schedule.month(date)?.day(date);
        final matches = (day?.assignments ?? const <ShiftAssignment>[])
            .where(
              (assignment) =>
                  assignment.employee.id == giver.id &&
                  (shiftCode.isEmpty ||
                      assignment.shift.code.toLowerCase() == shiftCode),
            )
            .toList();
        if (matches.length != 1) {
          skipped++;
          continue;
        }
        final reason = [
          row.value(ExchangeSheetField.reason),
          row.value(ExchangeSheetField.remark),
          'Sheet row ${row.rowNumber}',
        ].where((value) => value.trim().isNotEmpty).join(' • ');
        final saved = await exchangeController.create(
          type: ExchangeType.cover,
          sourceDate: date,
          source: matches.single,
          recipient: receiver,
          reason: reason,
        );
        if (saved) {
          created++;
        } else {
          skipped++;
        }
      }
      return TimelineExchangeImportResult(created: created, skipped: skipped);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void selectReadMode(SheetReadMode mode) {
    if (mode == _readMode) return;
    _readMode = mode;
    _errorCode = null;
    notifyListeners();
  }

  Future<bool> loadCurrentSource() async {
    final source = _selectedSource;
    if (source == null || _loading) return false;
    _loading = true;
    _errorCode = null;
    notifyListeners();
    try {
      await gateway.loadSource(source, mode: _readMode);
      _lastImported = source;
      return true;
    } on DriveRosterSourceException catch (error) {
      _errorCode = error.code;
      return false;
    } catch (_) {
      _errorCode = 'google_drive_load_failed';
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  ExchangeTimelineRow _mappedRow(List<String> row, int rowNumber) {
    return ExchangeTimelineRow(
      rowNumber: rowNumber,
      values: {
        for (final field in ExchangeSheetField.values)
          field: switch (_columnMapping[field]) {
            final index? when index >= 0 && index < row.length => row[index],
            _ => '',
          },
      },
    );
  }

  Map<ExchangeSheetField, int?> _suggestMapping(List<String> headers) {
    final normalized = [
      for (final value in headers)
        value.toLowerCase().replaceAll(RegExp(r'[\s_\-/]'), ''),
    ];
    int? find(List<String> terms) {
      for (final (index, value) in normalized.indexed) {
        if (terms.any(value.contains)) return index;
      }
      return null;
    }

    return {
      ExchangeSheetField.giver: find([
        'ผู้ยกเวร',
        'ผู้แลกเวร',
        'เจ้าของเวร',
        'giver',
        'requester',
        'owner',
      ]),
      ExchangeSheetField.receiver: find([
        'ผู้รับเวร',
        'ผู้รับ',
        'receiver',
        'recipient',
      ]),
      ExchangeSheetField.date: find(['วันที่', 'date']),
      ExchangeSheetField.shift: find(['รหัสเวร', 'ประเภทเวร', 'shift']),
      ExchangeSheetField.type: find(['รูปแบบ', 'ชนิด', 'type']),
      ExchangeSheetField.reason: find(['เหตุผล', 'reason']),
      ExchangeSheetField.remark: find([
        'หมายเหตุ',
        'comment',
        'remark',
        'note',
      ]),
    };
  }

  Employee? _findEmployee(ExchangeController controller, String identity) {
    final normalized = identity.trim().toLowerCase();
    if (normalized.isEmpty) return null;
    final matches = controller.employees.where((employee) {
      final values = [
        employee.id,
        employee.employeeCode,
        employee.fullName,
        employee.displayName,
        employee.nickname,
      ].map((value) => value.trim().toLowerCase());
      return values.contains(normalized);
    }).toList();
    return matches.length == 1 ? matches.single : null;
  }

  DateTime? _parseDate(String source) {
    final value = source.trim();
    if (value.isEmpty) return null;
    final iso = DateTime.tryParse(value);
    if (iso != null) return DateTime(iso.year, iso.month, iso.day);
    final match = RegExp(
      r'^(\d{1,2})[/-](\d{1,2})[/-](\d{4})$',
    ).firstMatch(value);
    if (match == null) return null;
    var year = int.parse(match.group(3)!);
    if (year >= 2400) year -= 543;
    final day = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    if (month < 1 || month > 12 || day < 1 || day > 31) return null;
    return DateTime(year, month, day);
  }

  void _clearTimeline() {
    _timeline = null;
    _headerRowIndex = 0;
    _columnMapping = const {};
  }
}
