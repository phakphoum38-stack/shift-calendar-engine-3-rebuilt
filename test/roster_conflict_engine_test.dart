import 'package:flutter_test/flutter_test.dart';
import 'package:shift_calendar_engine/domain/entities/roster_policy.dart';
import 'package:shift_calendar_engine/domain/entities/schedule.dart';
import 'package:shift_calendar_engine/domain/entities/schedule_day.dart';
import 'package:shift_calendar_engine/domain/entities/schedule_month.dart';
import 'package:shift_calendar_engine/domain/entities/shift_assignment.dart';
import 'package:shift_calendar_engine/features/rules/application/roster_conflict_engine.dart';

import 'support/fixtures.dart';

void main() {
  test('detects duplicate, overlap, daily limit, and continuous hours', () {
    final fixture = canonicalScheduleFixture();
    final assignment = fixture.assignments.single;
    final date = fixture.days.single.date;
    final schedule = Schedule(
      id: 'rules',
      name: 'Rules',
      months: [
        ScheduleMonth(
          month: date,
          days: [
            ScheduleDay(
              date: date,
              assignments: [
                assignment,
                ShiftAssignment(
                  id: 'duplicate',
                  employee: assignment.employee,
                  shift: assignment.shift,
                ),
              ],
            ),
          ],
        ),
      ],
    );

    final conflicts = const RosterConflictEngine().evaluate(
      schedule,
      const RosterPolicy(maximumContinuousHours: 10, maximumShiftsPerDay: 1),
    );
    final codes = conflicts.map((value) => value.code);

    expect(codes, contains('duplicate_shift'));
    expect(codes, contains('continuous_hours'));
    expect(codes, contains('daily_shift_limit'));
    expect(codes, contains('overlapping_shift'));
  });
}
