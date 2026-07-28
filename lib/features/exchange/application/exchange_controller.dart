import 'package:flutter/foundation.dart';

import '../../../core/result/result.dart';
import '../../../domain/entities/employee.dart';
import '../../../domain/entities/exchange_request.dart';
import '../../../domain/entities/schedule.dart';
import '../../../domain/entities/shift_assignment.dart';
import '../../../domain/repositories/exchange_repository.dart';
import '../../../domain/repositories/employee_repository.dart';
import '../../../domain/repositories/schedule_repository.dart';
import '../domain/exchange_conflict.dart';
import 'exchange_rule_service.dart';

class ExchangeController extends ChangeNotifier {
  ExchangeController({
    required this.exchangeRepository,
    required this.employeeRepository,
    required this.scheduleRepository,
    required this.schedule,
    this.rules = const ExchangeRuleService(),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final ExchangeRepository exchangeRepository;
  final EmployeeRepository employeeRepository;
  final ScheduleRepository scheduleRepository;
  final ExchangeRuleService rules;
  final DateTime Function() _clock;

  Schedule schedule;
  List<ExchangeRequest> _requests = const [];
  List<Employee> _employees = const [];
  bool _loading = false;
  String? _error;

  List<ExchangeRequest> get requests => _requests;
  List<Employee> get employees => _employees;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> load() async {
    if (_loading) return;
    _setLoading();
    final result = await exchangeRepository.findAll();
    final employeeResult = await employeeRepository.findAll();
    switch (result) {
      case Success<List<ExchangeRequest>>(value: final values):
        _requests = values;
      case Failure<List<ExchangeRequest>>():
        _error = result.message;
    }
    switch (employeeResult) {
      case Success<List<Employee>>(value: final values):
        final byId = <String, Employee>{
          for (final day in schedule.days)
            for (final assignment in day.assignments)
              assignment.employee.id: assignment.employee,
          for (final value in values) value.id: value,
        };
        _employees = List.unmodifiable(
          byId.values.where((value) => value.active).toList()
            ..sort((a, b) => a.displayName.compareTo(b.displayName)),
        );
      case Failure<List<Employee>>():
        _error ??= employeeResult.message;
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> create({
    required ExchangeType type,
    required DateTime sourceDate,
    required ShiftAssignment source,
    required Employee recipient,
    required String reason,
    DateTime? offeredDate,
    ShiftAssignment? offered,
  }) async {
    if (reason.trim().isEmpty ||
        (type == ExchangeType.swap && offered == null) ||
        (type == ExchangeType.swap && offeredDate == null) ||
        (type == ExchangeType.swap && offered?.employee.id != recipient.id)) {
      _error = 'Exchange request data is incomplete.';
      notifyListeners();
      return false;
    }
    if (_requests.any(
      (value) =>
          value.sourceAssignmentId == source.id &&
          value.status != ExchangeStatus.rejected &&
          value.status != ExchangeStatus.cancelled,
    )) {
      _error = 'This assignment already has an active exchange request.';
      notifyListeners();
      return false;
    }
    final now = _clock();
    final request = ExchangeRequest(
      id: 'exchange-${now.microsecondsSinceEpoch}',
      type: type,
      sourceAssignmentId: source.id,
      sourceDate: sourceDate,
      requester: source.employee,
      recipient: recipient,
      reason: reason.trim(),
      status: ExchangeStatus.submitted,
      createdAt: now,
      offeredAssignmentId: offered?.id,
      offeredDate: offeredDate,
    );
    return _persist(request);
  }

  List<ExchangeConflict> preview(ExchangeRequest request) {
    final source = _assignment(request.sourceDate, request.sourceAssignmentId);
    if (source == null) {
      return const [
        ExchangeConflict(
          code: 'source_missing',
          severity: ExchangeConflictSeverity.error,
          message: 'The original assignment no longer exists.',
        ),
      ];
    }
    final result = <ExchangeConflict>[
      ...rules.validateTransfer(
        schedule: schedule,
        assignmentDate: request.sourceDate,
        assignment: source,
        recipient: request.recipient,
        ignoredAssignmentId: request.offeredAssignmentId,
      ),
    ];
    if (request.type == ExchangeType.swap) {
      final offeredDate = request.offeredDate;
      final offered = offeredDate == null
          ? null
          : _assignment(offeredDate, request.offeredAssignmentId ?? '');
      if (offered == null || offeredDate == null) {
        result.add(
          const ExchangeConflict(
            code: 'offered_missing',
            severity: ExchangeConflictSeverity.error,
            message: 'The offered assignment no longer exists.',
          ),
        );
      } else {
        result.addAll(
          rules.validateTransfer(
            schedule: schedule,
            assignmentDate: offeredDate,
            assignment: offered,
            recipient: request.requester,
            ignoredAssignmentId: request.sourceAssignmentId,
          ),
        );
      }
    }
    return List.unmodifiable(result);
  }

  Future<bool> accept(String id) => _changeStatus(
    id,
    allowed: const [ExchangeStatus.submitted],
    update: (value) =>
        value.copyWith(status: ExchangeStatus.accepted, respondedAt: _clock()),
  );

  Future<bool> reject(String id, String reason) => _changeStatus(
    id,
    allowed: const [ExchangeStatus.submitted, ExchangeStatus.accepted],
    update: (value) => value.copyWith(
      status: ExchangeStatus.rejected,
      respondedAt: _clock(),
      rejectionReason: reason.trim(),
    ),
  );

  Future<bool> cancel(String id) => _changeStatus(
    id,
    allowed: const [ExchangeStatus.submitted, ExchangeStatus.accepted],
    update: (value) => value.copyWith(status: ExchangeStatus.cancelled),
  );

  Future<bool> approve(String id, String approverName) async {
    final request = _find(id);
    if (request == null || request.status != ExchangeStatus.accepted) {
      _error = 'Only accepted requests can be approved.';
      notifyListeners();
      return false;
    }
    final conflicts = preview(request);
    if (conflicts.any((value) => value.blocksApproval)) {
      _error = 'The exchange is blocked by roster conflicts.';
      notifyListeners();
      return false;
    }
    final original = schedule;
    final updated = _apply(request);
    if (updated == null) {
      _error = 'The assignments could not be updated.';
      notifyListeners();
      return false;
    }
    _setLoading();
    final scheduleResult = await scheduleRepository.save(updated);
    if (scheduleResult case Failure<Schedule>()) {
      _error = scheduleResult.message;
      _loading = false;
      notifyListeners();
      return false;
    }
    schedule = (scheduleResult as Success<Schedule>).value;
    final approved = request.copyWith(
      status: ExchangeStatus.approved,
      approvedAt: _clock(),
      approverName: approverName.trim().isEmpty
          ? 'Administrator'
          : approverName.trim(),
    );
    final saved = await exchangeRepository.save(approved);
    if (saved case Failure<ExchangeRequest>()) {
      await scheduleRepository.save(original);
      schedule = original;
      _error = saved.message;
      _loading = false;
      notifyListeners();
      return false;
    }
    _replace((saved as Success<ExchangeRequest>).value);
    _loading = false;
    notifyListeners();
    return true;
  }

  Future<bool> _changeStatus(
    String id, {
    required List<ExchangeStatus> allowed,
    required ExchangeRequest Function(ExchangeRequest) update,
  }) async {
    final request = _find(id);
    if (request == null || !allowed.contains(request.status)) {
      _error = 'This request cannot change to that status.';
      notifyListeners();
      return false;
    }
    return _persist(update(request));
  }

  Future<bool> _persist(ExchangeRequest request) async {
    _setLoading();
    final result = await exchangeRepository.save(request);
    if (result case Success<ExchangeRequest>(value: final value)) {
      _replace(value);
    } else if (result case Failure<ExchangeRequest>()) {
      _error = result.message;
    }
    _loading = false;
    notifyListeners();
    return result.isSuccess;
  }

  Schedule? _apply(ExchangeRequest request) {
    final source = _assignment(request.sourceDate, request.sourceAssignmentId);
    if (source == null) return null;
    var result = _replaceAssignment(
      schedule,
      request.sourceDate,
      source.copyWithEmployee(
        request.recipient,
        remark: _exchangeRemark(source.remark, request.id),
      ),
    );
    if (request.type == ExchangeType.swap) {
      final offeredDate = request.offeredDate;
      final offered = offeredDate == null
          ? null
          : _assignment(offeredDate, request.offeredAssignmentId ?? '');
      if (offered == null || offeredDate == null) return null;
      result = _replaceAssignment(
        result,
        offeredDate,
        offered.copyWithEmployee(
          request.requester,
          remark: _exchangeRemark(offered.remark, request.id),
        ),
      );
    }
    return result;
  }

  Schedule _replaceAssignment(
    Schedule value,
    DateTime date,
    ShiftAssignment assignment,
  ) {
    final month = value.month(date)!;
    final day = month.day(date)!;
    return value.replaceMonth(
      month.replaceDay(
        day.copyWith(
          assignments: [
            for (final existing in day.assignments)
              if (existing.id == assignment.id) assignment else existing,
          ],
        ),
      ),
    );
  }

  ShiftAssignment? _assignment(DateTime date, String id) {
    final day = schedule.month(date)?.day(date);
    for (final value in day?.assignments ?? const <ShiftAssignment>[]) {
      if (value.id == id) return value;
    }
    return null;
  }

  ExchangeRequest? _find(String id) {
    for (final value in _requests) {
      if (value.id == id) return value;
    }
    return null;
  }

  void _replace(ExchangeRequest request) {
    final values = List<ExchangeRequest>.of(_requests);
    final index = values.indexWhere((value) => value.id == request.id);
    if (index == -1) {
      values.add(request);
    } else {
      values[index] = request;
    }
    values.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _requests = List.unmodifiable(values);
  }

  String _exchangeRemark(String? current, String requestId) => [
    if (current?.trim().isNotEmpty == true) current!.trim(),
    'Exchange $requestId',
  ].join(' • ');

  void _setLoading() {
    _loading = true;
    _error = null;
    notifyListeners();
  }
}

extension on ShiftAssignment {
  ShiftAssignment copyWithEmployee(Employee employee, {String? remark}) {
    return ShiftAssignment(
      id: id,
      employee: employee,
      shift: shift,
      location: location,
      remark: remark ?? this.remark,
      approved: approved,
    );
  }
}
