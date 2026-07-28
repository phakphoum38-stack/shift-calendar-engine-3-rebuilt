import 'package:flutter_test/flutter_test.dart';
import 'package:shift_calendar_engine/core/result/result.dart';
import 'package:shift_calendar_engine/domain/entities/employee.dart';
import 'package:shift_calendar_engine/domain/entities/schedule.dart';
import 'package:shift_calendar_engine/domain/entities/shift_assignment.dart';
import 'package:shift_calendar_engine/domain/entities/shift_template.dart';
import 'package:shift_calendar_engine/domain/repositories/employee_repository.dart';
import 'package:shift_calendar_engine/domain/repositories/schedule_repository.dart';
import 'package:shift_calendar_engine/domain/repositories/shift_template_repository.dart';
import 'package:shift_calendar_engine/features/roster/application/roster_editor_controller.dart';

import 'support/fixtures.dart';

void main() {
  test(
    'manual mutations update and persist canonical schedule first',
    () async {
      final fixture = canonicalScheduleFixture();
      final employee = fixture.assignments.first.employee;
      final shift = fixture.assignments.first.shift;
      final scheduleRepository = _ScheduleRepository();
      final controller = RosterEditorController(
        scheduleRepository: scheduleRepository,
        employeeRepository: _EmployeeRepository(employee),
        shiftTemplateRepository: _ShiftRepository(shift),
        schedule: Schedule(id: 'manual', name: 'Manual roster'),
      );
      addTearDown(controller.dispose);

      await controller.loadCatalogs();
      final date = DateTime(2027, 5, 10);
      controller.addAssignment(
        date,
        ShiftAssignment(
          id: 'manual-assignment',
          employee: employee,
          shift: shift,
        ),
      );
      controller.addAssignment(
        date,
        ShiftAssignment(
          id: 'duplicate-provider-id',
          employee: employee,
          shift: shift,
        ),
      );

      expect(
        controller.schedule.month(date)!.day(date)!.assignments,
        hasLength(1),
      );
      expect(await controller.save(), isTrue);
      expect(scheduleRepository.saved, hasLength(1));

      final movedDate = DateTime(2027, 5, 11);
      controller.updateAssignment(
        originalDate: date,
        updatedDate: movedDate,
        assignment: ShiftAssignment(
          id: 'manual-assignment',
          employee: employee,
          shift: shift,
          location: 'ER',
          remark: 'Updated',
        ),
      );
      expect(controller.schedule.month(date)!.day(date)!.assignments, isEmpty);
      final updated = controller.schedule
          .month(movedDate)!
          .day(movedDate)!
          .assignments;
      expect(updated, hasLength(1));
      expect(updated.single.location, 'ER');
      expect(updated.single.remark, 'Updated');

      controller.deleteAssignment(movedDate, 'manual-assignment');
      expect(
        controller.schedule.month(movedDate)!.day(movedDate)!.assignments,
        isEmpty,
      );
    },
  );
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
  _EmployeeRepository(this.employee);

  final Employee employee;

  @override
  Future<Result<void>> delete(String id) async => const Success(null);

  @override
  Future<Result<List<Employee>>> findAll({bool activeOnly = true}) async =>
      Success([employee]);

  @override
  Future<Result<Employee>> save(Employee employee) async => Success(employee);
}

class _ShiftRepository implements ShiftTemplateRepository {
  _ShiftRepository(this.shift);

  final ShiftTemplate shift;

  @override
  Future<Result<void>> delete(String id) async => const Success(null);

  @override
  Future<Result<List<ShiftTemplate>>> findAll({bool activeOnly = true}) async =>
      Success([shift]);

  @override
  Future<Result<ShiftTemplate>> save(ShiftTemplate template) async =>
      Success(template);
}
