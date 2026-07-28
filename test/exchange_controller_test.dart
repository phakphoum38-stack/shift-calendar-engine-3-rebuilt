import 'package:flutter_test/flutter_test.dart';
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
import 'package:shift_calendar_engine/features/exchange/application/exchange_controller.dart';
import 'package:shift_calendar_engine/features/exchange/application/exchange_rule_service.dart';

void main() {
  const department = Department(id: 'd', code: 'ER', name: 'Emergency');
  const owner = Employee(
    id: 'owner',
    employeeCode: 'E001',
    firstName: 'Owner',
    lastName: 'One',
    department: department,
    position: 'Nurse',
  );
  const recipient = Employee(
    id: 'recipient',
    employeeCode: 'E002',
    firstName: 'Receiver',
    lastName: 'Two',
    department: department,
    position: 'Nurse',
  );
  const dayShift = ShiftTemplate(
    id: 'day',
    code: 'D',
    name: 'Day',
    startTime: Duration(hours: 8),
    endTime: Duration(hours: 16),
    colorValue: 0xFF0000FF,
    workingHours: 8,
  );

  test(
    'accepted cover request transfers canonical assignment on approval',
    () async {
      final date = DateTime(2027, 6, 1);
      const assignment = ShiftAssignment(
        id: 'a1',
        employee: owner,
        shift: dayShift,
      );
      final schedule = _schedule(date, [assignment]);
      final exchangeRepository = _ExchangeRepository();
      final scheduleRepository = _ScheduleRepository();
      final controller = ExchangeController(
        exchangeRepository: exchangeRepository,
        employeeRepository: _EmployeeRepository([owner, recipient]),
        scheduleRepository: scheduleRepository,
        schedule: schedule,
        clock: () => DateTime(2027, 5, 1, 10),
      );
      addTearDown(controller.dispose);

      await controller.load();
      expect(
        await controller.create(
          type: ExchangeType.cover,
          sourceDate: date,
          source: assignment,
          recipient: recipient,
          reason: 'Personal appointment',
        ),
        isTrue,
      );
      final request = controller.requests.single;
      expect(await controller.accept(request.id), isTrue);
      expect(await controller.approve(request.id, 'Head nurse'), isTrue);

      expect(controller.requests.single.status, ExchangeStatus.approved);
      expect(
        controller.schedule.month(date)!.day(date)!.assignments.single.employee,
        recipient,
      );
      expect(scheduleRepository.saved, hasLength(1));
    },
  );

  test('overlapping recipient assignment blocks approval', () async {
    final date = DateTime(2027, 6, 1);
    const source = ShiftAssignment(id: 'a1', employee: owner, shift: dayShift);
    const existing = ShiftAssignment(
      id: 'a2',
      employee: recipient,
      shift: dayShift,
    );
    final schedule = _schedule(date, [source, existing]);
    final exchangeRepository = _ExchangeRepository();
    final controller = ExchangeController(
      exchangeRepository: exchangeRepository,
      employeeRepository: _EmployeeRepository([owner, recipient]),
      scheduleRepository: _ScheduleRepository(),
      schedule: schedule,
      rules: const ExchangeRuleService(),
      clock: () => DateTime(2027, 5, 1, 10),
    );
    addTearDown(controller.dispose);

    await controller.load();
    await controller.create(
      type: ExchangeType.cover,
      sourceDate: date,
      source: source,
      recipient: recipient,
      reason: 'Cover',
    );
    final request = controller.requests.single;
    await controller.accept(request.id);

    expect(
      controller.preview(controller.requests.single).map((value) => value.code),
      contains('overlap'),
    );
    expect(await controller.approve(request.id, 'Head nurse'), isFalse);
    expect(
      controller.schedule.month(date)!.day(date)!.assignments.first.employee,
      owner,
    );
  });
}

Schedule _schedule(DateTime date, List<ShiftAssignment> assignments) =>
    Schedule(
      id: 's',
      name: 'Roster',
      months: [
        ScheduleMonth(
          month: date,
          days: [ScheduleDay(date: date, assignments: assignments)],
        ),
      ],
    );

class _ExchangeRepository implements ExchangeRepository {
  final values = <ExchangeRequest>[];

  @override
  Future<Result<List<ExchangeRequest>>> findAll() async => Success(values);

  @override
  Future<Result<ExchangeRequest>> save(ExchangeRequest request) async {
    final index = values.indexWhere((value) => value.id == request.id);
    if (index == -1) {
      values.add(request);
    } else {
      values[index] = request;
    }
    return Success(request);
  }
}

class _ScheduleRepository implements ScheduleRepository {
  final saved = <Schedule>[];

  @override
  Future<Result<Schedule?>> loadActive() async => const Success(null);

  @override
  Future<Result<Schedule>> save(Schedule schedule) async {
    saved.add(schedule);
    return Success(schedule);
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
