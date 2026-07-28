import 'package:flutter_test/flutter_test.dart';
import 'package:shift_calendar_engine/domain/entities/schedule.dart';
import 'package:shift_calendar_engine/domain/entities/schedule_day.dart';
import 'package:shift_calendar_engine/domain/entities/schedule_month.dart';
import 'package:shift_calendar_engine/domain/entities/shift_assignment.dart';
import 'package:shift_calendar_engine/features/roster/application/schedule_merge_service.dart';

import 'support/fixtures.dart';

void main() {
  const service = ScheduleMergeService();

  test('synchronizing the same schedule twice does not create duplicates', () {
    final incoming = canonicalScheduleFixture();
    final empty = Schedule(id: incoming.id, name: incoming.name);

    final first = service.merge(empty, incoming);
    final second = service.merge(first, incoming);

    expect(first.assignments, hasLength(1));
    expect(second.assignments, hasLength(1));
    expect(second.assignments.single.id, incoming.assignments.single.id);
  });

  test('logically identical assignments with new source IDs stay unique', () {
    final incoming = canonicalScheduleFixture();
    final original = incoming.assignments.single;
    final duplicate = ShiftAssignment(
      id: 'provider-regenerated-id',
      employee: original.employee,
      shift: original.shift,
      location: original.location,
      remark: original.remark,
      approved: original.approved,
    );
    final duplicateSchedule = Schedule(
      id: incoming.id,
      name: incoming.name,
      months: [
        ScheduleMonth(
          month: incoming.months.single.month,
          days: [
            ScheduleDay(
              date: incoming.months.single.days.single.date,
              assignments: [duplicate],
            ),
          ],
        ),
      ],
    );

    final merged = service.merge(incoming, duplicateSchedule);

    expect(merged.assignments, hasLength(1));
    expect(merged.assignments.single.id, original.id);
  });
}
