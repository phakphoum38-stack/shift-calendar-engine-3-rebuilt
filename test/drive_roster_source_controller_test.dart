import 'package:flutter_test/flutter_test.dart';
import 'package:shift_calendar_engine/features/roster/application/drive_roster_source_controller.dart';
import 'package:shift_calendar_engine/features/roster/application/drive_roster_source_gateway.dart';
import 'package:shift_calendar_engine/features/roster/domain/drive_roster_source.dart';
import 'package:shift_calendar_engine/features/roster/infrastructure/google_auth_controller.dart';
import 'package:shift_calendar_engine/features/exchange/application/exchange_controller.dart';
import 'package:shift_calendar_engine/core/result/result.dart';
import 'package:shift_calendar_engine/domain/entities/department.dart';
import 'package:shift_calendar_engine/domain/entities/employee.dart';
import 'package:shift_calendar_engine/domain/entities/exchange_request.dart';
import 'package:shift_calendar_engine/domain/entities/schedule.dart';
import 'package:shift_calendar_engine/domain/entities/schedule_day.dart';
import 'package:shift_calendar_engine/domain/entities/schedule_month.dart';
import 'package:shift_calendar_engine/domain/entities/shift_assignment.dart';
import 'package:shift_calendar_engine/domain/entities/shift_template.dart';
import 'package:shift_calendar_engine/domain/repositories/employee_repository.dart';
import 'package:shift_calendar_engine/domain/repositories/exchange_repository.dart';
import 'package:shift_calendar_engine/domain/repositories/schedule_repository.dart';

void main() {
  test('loads the selected sheet with the selected read mode', () async {
    final gateway = _RecordingGateway();
    final controller = DriveRosterSourceController(
      gateway: gateway,
      auth: GoogleAuthController(),
    );

    await controller.refresh();
    controller.select(controller.recentSources.single);
    controller.selectReadMode(SheetReadMode.standard);

    expect(await controller.loadCurrentSource(), isTrue);
    expect(gateway.loadedSource, same(controller.selectedSource));
    expect(gateway.loadedMode, SheetReadMode.standard);
    expect(controller.lastImported, same(controller.selectedSource));
  });

  test('loads first timeline and suggests exchange column mapping', () async {
    final gateway = _RecordingGateway();
    final controller = DriveRosterSourceController(
      gateway: gateway,
      auth: GoogleAuthController(),
    );

    await controller.refresh();
    controller.select(controller.recentSources.single);

    expect(await controller.loadFirstTimeline(), isTrue);
    expect(controller.timeline!.source.createdTime, DateTime(2026, 6, 1));
    expect(controller.columnMapping[ExchangeSheetField.giver], 0);
    expect(controller.columnMapping[ExchangeSheetField.receiver], 1);
    expect(
      controller.mappedTimelineRows.single.value(ExchangeSheetField.giver),
      'สมชาย',
    );
    expect(
      controller.mappedTimelineRows.single.value(ExchangeSheetField.receiver),
      'สมหญิง',
    );
  });

  test('creates cover request from a mapped timeline row', () async {
    const department = Department(id: 'd', code: 'D', name: 'Department');
    const giver = Employee(
      id: 'giver',
      employeeCode: 'E001',
      firstName: 'สมชาย',
      lastName: '',
      department: department,
      position: 'Nurse',
    );
    const receiver = Employee(
      id: 'receiver',
      employeeCode: 'E002',
      firstName: 'สมหญิง',
      lastName: '',
      department: department,
      position: 'Nurse',
    );
    const shift = ShiftTemplate(
      id: 'night',
      code: 'N',
      name: 'Night',
      startTime: Duration(hours: 20),
      endTime: Duration(hours: 8),
      colorValue: 0xFF000000,
      workingHours: 12,
    );
    final date = DateTime(2026, 7, 10);
    final schedule = Schedule(
      id: 's',
      name: 'Roster',
      months: [
        ScheduleMonth(
          month: date,
          days: [
            ScheduleDay(
              date: date,
              assignments: const [
                ShiftAssignment(
                  id: 'assignment',
                  employee: giver,
                  shift: shift,
                ),
              ],
            ),
          ],
        ),
      ],
    );
    final driveController = DriveRosterSourceController(
      gateway: _RecordingGateway(),
      auth: GoogleAuthController(),
    );
    final exchangeRepository = _ExchangeRepository();
    final exchangeController = ExchangeController(
      exchangeRepository: exchangeRepository,
      employeeRepository: _EmployeeRepository([giver, receiver]),
      scheduleRepository: _ScheduleRepository(),
      schedule: schedule,
    );

    await driveController.refresh();
    driveController.select(driveController.recentSources.single);
    await driveController.loadFirstTimeline();
    final result = await driveController.createCoverRequests(
      exchangeController,
    );

    expect(result.created, 1);
    expect(result.skipped, 0);
    expect(exchangeRepository.values.single.recipient, receiver);
    expect(exchangeRepository.values.single.sourceAssignmentId, 'assignment');
  });
}

class _ExchangeRepository implements ExchangeRepository {
  final values = <ExchangeRequest>[];

  @override
  Future<Result<List<ExchangeRequest>>> findAll() async => Success(values);

  @override
  Future<Result<ExchangeRequest>> save(ExchangeRequest request) async {
    values.add(request);
    return Success(request);
  }
}

class _EmployeeRepository implements EmployeeRepository {
  _EmployeeRepository(this.values);
  final List<Employee> values;

  @override
  Future<Result<void>> delete(String id) async => const Success(null);

  @override
  Future<Result<List<Employee>>> findAll({bool activeOnly = true}) async =>
      Success(values);

  @override
  Future<Result<Employee>> save(Employee employee) async => Success(employee);
}

class _ScheduleRepository implements ScheduleRepository {
  @override
  Future<Result<Schedule?>> loadActive() async => const Success(null);

  @override
  Future<Result<Schedule>> save(Schedule schedule) async => Success(schedule);
}

class _RecordingGateway implements DriveRosterSourceGateway {
  final source = DriveRosterSource(
    id: 'sheet-1',
    name: 'Roster July',
    modifiedTime: DateTime(2026, 7, 1),
    rosterMonth: DateTime(2026, 7),
    createdTime: DateTime(2026, 6, 1),
  );

  DriveRosterSource? loadedSource;
  SheetReadMode? loadedMode;

  @override
  Future<SheetTimelineData> loadFirstTimeline(DriveRosterSource source) async =>
      SheetTimelineData(
        source: source,
        sheetTitle: 'July',
        rows: const [
          ['ผู้ยกเวร', 'ผู้รับเวร', 'วันที่', 'รหัสเวร', 'เหตุผล'],
          ['สมชาย', 'สมหญิง', '2026-07-10', 'N', 'ธุระ'],
        ],
      );

  @override
  Future<List<DriveRosterSource>> listRecentlyModified() async => [source];

  @override
  Future<DriveRosterSource?> loadLastImported() async => null;

  @override
  Future<void> loadSource(
    DriveRosterSource source, {
    required SheetReadMode mode,
  }) async {
    loadedSource = source;
    loadedMode = mode;
  }
}
