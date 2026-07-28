import 'package:flutter_test/flutter_test.dart';
import 'package:shift_calendar_engine/domain/entities/department.dart';
import 'package:shift_calendar_engine/domain/entities/employee.dart';
import 'package:shift_calendar_engine/domain/entities/schedule.dart';
import 'package:shift_calendar_engine/domain/entities/schedule_day.dart';
import 'package:shift_calendar_engine/domain/entities/schedule_month.dart';
import 'package:shift_calendar_engine/domain/entities/shift_assignment.dart';
import 'package:shift_calendar_engine/domain/entities/shift_template.dart';
import 'package:shift_calendar_engine/features/calendar_sync/application/calendar_sync_controller.dart';
import 'package:shift_calendar_engine/features/calendar_sync/application/calendar_sync_gateway.dart';
import 'package:shift_calendar_engine/features/calendar_sync/domain/calendar_sync_change.dart';

void main() {
  const department = Department(id: 'd', code: 'ER', name: 'Emergency');
  const employee = Employee(
    id: 'e1',
    employeeCode: 'E001',
    firstName: 'Test',
    lastName: 'Nurse',
    department: department,
    position: 'Nurse',
  );
  const shift = ShiftTemplate(
    id: 'day',
    code: 'D',
    name: 'Day',
    startTime: Duration(hours: 8),
    endTime: Duration(hours: 16),
    colorValue: 0xFF0000FF,
    workingHours: 8,
  );
  const assignment = ShiftAssignment(
    id: 'a1',
    employee: employee,
    shift: shift,
  );
  final date = DateTime(2027, 6, 1);
  final schedule = Schedule(
    id: 's',
    name: 'Roster',
    months: [
      ScheduleMonth(
        month: date,
        days: [
          ScheduleDay(date: date, assignments: const [assignment]),
        ],
      ),
    ],
  );

  test('previews, applies, then refreshes to an unchanged state', () async {
    final gateway = _Gateway();
    final controller = CalendarSyncController(
      gateway: gateway,
      schedule: schedule,
    );
    addTearDown(controller.dispose);

    controller.selectEmployee(employee);
    expect(await controller.preview(), isTrue);
    expect(controller.changes.single.action, CalendarSyncAction.create);

    expect(await controller.sync(), isTrue);
    expect(gateway.applyCount, 1);
    expect(controller.changes.single.action, CalendarSyncAction.unchanged);
  });
}

class _Gateway implements CalendarSyncGateway {
  bool applied = false;
  int applyCount = 0;

  @override
  Future<List<CalendarSyncChange>> preview(
    Schedule schedule,
    Employee employee,
  ) async => [
    CalendarSyncChange(
      action: applied
          ? CalendarSyncAction.unchanged
          : CalendarSyncAction.create,
      assignmentId: schedule.assignments.single.id,
      title: 'D — Day',
      assignment: schedule.assignments.single,
      eventId: applied ? 'event-1' : null,
    ),
  ];

  @override
  Future<void> apply(
    Schedule schedule,
    Employee employee,
    List<CalendarSyncChange> changes,
  ) async {
    applyCount += 1;
    applied = true;
  }
}
