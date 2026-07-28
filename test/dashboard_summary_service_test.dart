import 'package:flutter_test/flutter_test.dart';
import 'package:shift_calendar_engine/domain/entities/schedule.dart';
import 'package:shift_calendar_engine/domain/entities/schedule_day.dart';
import 'package:shift_calendar_engine/domain/entities/schedule_month.dart';
import 'package:shift_calendar_engine/features/dashboard/application/dashboard_summary_service.dart';
import 'package:shift_calendar_engine/features/foundation/application/demo_schedule_factory.dart';

import 'support/fixtures.dart';

void main() {
  test('dashboard summary is derived without mutating schedule', () {
    final now = DateTime(2027, 4, 12, 10);
    final schedule = const DemoScheduleFactory().create(now);
    final before = schedule.assignments.toList();

    final summary = const DashboardSummaryService().build(schedule, now);

    expect(summary.todayAssignments, hasLength(1));
    expect(summary.tomorrowAssignments, isEmpty);
    expect(summary.monthlyAssignmentCount, 1);
    expect(summary.estimatedIncome, 600);
    expect(summary.estimatedOvertime, 0);
    expect(schedule.assignments, before);
  });

  test('tomorrow reads from the next month at a month boundary', () {
    final fixture = canonicalScheduleFixture();
    final assignment = fixture.assignments.single;
    final schedule = Schedule(
      id: 'boundary',
      name: 'Boundary roster',
      months: [
        ScheduleMonth(
          month: DateTime(2027, 4),
          days: [
            ScheduleDay(date: DateTime(2027, 4, 30), assignments: [assignment]),
          ],
        ),
        ScheduleMonth(
          month: DateTime(2027, 5),
          days: [
            ScheduleDay(date: DateTime(2027, 5), assignments: [assignment]),
          ],
        ),
      ],
    );

    final summary = const DashboardSummaryService().build(
      schedule,
      DateTime(2027, 4, 30, 23),
    );

    expect(summary.todayAssignments, hasLength(1));
    expect(summary.tomorrowAssignments, hasLength(1));
    expect(summary.monthlyAssignmentCount, 1);
    expect(summary.estimatedIncome, 1350);
    expect(summary.estimatedOvertime, 450);
  });
}
