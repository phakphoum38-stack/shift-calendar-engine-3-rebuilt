import '../../../domain/entities/roster_policy.dart';
import '../../../domain/entities/schedule.dart';
import '../../../domain/entities/shift_assignment.dart';
import '../domain/roster_conflict.dart';

class RosterConflictEngine {
  const RosterConflictEngine();

  List<RosterConflict> evaluate(Schedule schedule, RosterPolicy policy) {
    final conflicts = <RosterConflict>[];
    final byEmployee = <String, List<_DatedAssignment>>{};
    for (final day in schedule.days) {
      final logicalKeys = <String>{};
      final dailyCounts = <String, int>{};
      for (final assignment in day.assignments) {
        byEmployee
            .putIfAbsent(assignment.employee.id, () => [])
            .add(_DatedAssignment(day.date, assignment));
        dailyCounts.update(
          assignment.employee.id,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
        final key = '${assignment.employee.id}:${assignment.shift.id}';
        if (!logicalKeys.add(key)) {
          conflicts.add(
            RosterConflict(
              code: 'duplicate_shift',
              severity: RosterConflictSeverity.error,
              message:
                  '${assignment.employee.displayName} has duplicate '
                  '${assignment.shift.code} shifts on ${_date(day.date)}.',
              assignmentIds: [assignment.id],
            ),
          );
        }
        if (assignment.shift.workingHours <= 0 ||
            assignment.shift.workingHours > 24) {
          conflicts.add(
            RosterConflict(
              code: 'invalid_working_hours',
              severity: RosterConflictSeverity.error,
              message: '${assignment.shift.code} has invalid working hours.',
              assignmentIds: [assignment.id],
            ),
          );
        }
        if (assignment.shift.workingHours > policy.maximumContinuousHours) {
          conflicts.add(
            RosterConflict(
              code: 'continuous_hours',
              severity: RosterConflictSeverity.error,
              message:
                  '${assignment.employee.displayName} works '
                  '${assignment.shift.workingHours} continuous hours.',
              assignmentIds: [assignment.id],
            ),
          );
        }
        if (assignment.shift.rate < 0) {
          conflicts.add(
            RosterConflict(
              code: 'invalid_rate',
              severity: RosterConflictSeverity.error,
              message: '${assignment.shift.code} has an invalid rate.',
              assignmentIds: [assignment.id],
            ),
          );
        }
      }
      for (final entry in dailyCounts.entries) {
        if (entry.value > policy.maximumShiftsPerDay) {
          conflicts.add(
            RosterConflict(
              code: 'daily_shift_limit',
              severity: RosterConflictSeverity.error,
              message:
                  'Employee ${entry.key} has ${entry.value} shifts on '
                  '${_date(day.date)}.',
            ),
          );
        }
      }
    }

    for (final assignments in byEmployee.values) {
      assignments.sort((a, b) => a.start.compareTo(b.start));
      final monthCounts = <String, int>{};
      final weekCounts = <String, int>{};
      for (final (index, current) in assignments.indexed) {
        final monthKey = '${current.date.year}-${current.date.month}';
        monthCounts.update(monthKey, (value) => value + 1, ifAbsent: () => 1);
        final weekStart = current.date.subtract(
          Duration(days: current.date.weekday - 1),
        );
        final weekKey = _date(weekStart);
        weekCounts.update(weekKey, (value) => value + 1, ifAbsent: () => 1);
        if (index == 0) continue;
        final previous = assignments[index - 1];
        if (current.start.isBefore(previous.end)) {
          conflicts.add(
            RosterConflict(
              code:
                  current.assignment.location != previous.assignment.location &&
                      current.assignment.location != null &&
                      previous.assignment.location != null
                  ? 'multiple_locations'
                  : 'overlapping_shift',
              severity: policy.blockOverlappingShifts
                  ? RosterConflictSeverity.error
                  : RosterConflictSeverity.warning,
              message:
                  '${current.assignment.employee.displayName} has '
                  'overlapping shifts.',
              assignmentIds: [previous.assignment.id, current.assignment.id],
            ),
          );
        } else {
          final rest = current.start.difference(previous.end);
          if (rest < Duration(hours: policy.minimumRestHours)) {
            conflicts.add(
              RosterConflict(
                code: 'insufficient_rest',
                severity: RosterConflictSeverity.warning,
                message:
                    '${current.assignment.employee.displayName} has only '
                    '${rest.inHours} rest hours.',
                assignmentIds: [previous.assignment.id, current.assignment.id],
              ),
            );
          }
        }
      }
      for (final count in monthCounts.entries) {
        if (count.value > policy.maximumShiftsPerMonth) {
          conflicts.add(
            RosterConflict(
              code: 'monthly_shift_limit',
              severity: RosterConflictSeverity.error,
              message: '${count.value} shifts exceed the monthly limit.',
            ),
          );
        }
      }
      for (final count in weekCounts.entries) {
        if (count.value > policy.maximumShiftsPerWeek) {
          conflicts.add(
            RosterConflict(
              code: 'weekly_shift_limit',
              severity: RosterConflictSeverity.error,
              message: '${count.value} shifts exceed the weekly limit.',
            ),
          );
        }
      }
    }
    return List.unmodifiable(conflicts);
  }

  static String _date(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-'
      '${value.month.toString().padLeft(2, '0')}-'
      '${value.day.toString().padLeft(2, '0')}';
}

class _DatedAssignment {
  const _DatedAssignment(this.date, this.assignment);

  final DateTime date;
  final ShiftAssignment assignment;

  DateTime get start =>
      DateTime(date.year, date.month, date.day).add(assignment.shift.startTime);

  DateTime get end {
    var value = DateTime(
      date.year,
      date.month,
      date.day,
    ).add(assignment.shift.endTime);
    if (assignment.shift.overnight) value = value.add(const Duration(days: 1));
    return value;
  }
}
