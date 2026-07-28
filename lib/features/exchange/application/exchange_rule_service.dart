import '../../../domain/entities/employee.dart';
import '../../../domain/entities/schedule.dart';
import '../../../domain/entities/shift_assignment.dart';
import '../domain/exchange_conflict.dart';

class ExchangeRuleService {
  const ExchangeRuleService({this.minimumRest = const Duration(hours: 8)});

  final Duration minimumRest;

  List<ExchangeConflict> validateTransfer({
    required Schedule schedule,
    required DateTime assignmentDate,
    required ShiftAssignment assignment,
    required Employee recipient,
    String? ignoredAssignmentId,
  }) {
    final conflicts = <ExchangeConflict>[];
    if (!recipient.active) {
      conflicts.add(
        const ExchangeConflict(
          code: 'inactive_recipient',
          severity: ExchangeConflictSeverity.error,
          message: 'The receiving employee is inactive.',
        ),
      );
    }
    if (recipient.id == assignment.employee.id) {
      conflicts.add(
        const ExchangeConflict(
          code: 'same_employee',
          severity: ExchangeConflictSeverity.error,
          message: 'The assignment is already owned by this employee.',
        ),
      );
    }

    final candidate = _interval(assignmentDate, assignment);
    for (final entry in _assignments(schedule)) {
      if (entry.assignment.id == assignment.id ||
          entry.assignment.id == ignoredAssignmentId ||
          entry.assignment.employee.id != recipient.id) {
        continue;
      }
      final existing = _interval(entry.date, entry.assignment);
      if (candidate.start.isBefore(existing.end) &&
          existing.start.isBefore(candidate.end)) {
        conflicts.add(
          ExchangeConflict(
            code: 'overlap',
            severity: ExchangeConflictSeverity.error,
            message:
                'Overlaps ${entry.assignment.shift.code} on '
                '${_date(entry.date)}.',
          ),
        );
        continue;
      }
      final rest = candidate.start.isAfter(existing.end)
          ? candidate.start.difference(existing.end)
          : existing.start.difference(candidate.end);
      if (!rest.isNegative && rest < minimumRest) {
        conflicts.add(
          ExchangeConflict(
            code: 'insufficient_rest',
            severity: ExchangeConflictSeverity.warning,
            message:
                'Rest between shifts is only ${rest.inHours} hours '
                '(minimum ${minimumRest.inHours}).',
          ),
        );
      }
    }
    return List.unmodifiable(conflicts);
  }

  Iterable<({DateTime date, ShiftAssignment assignment})> _assignments(
    Schedule schedule,
  ) sync* {
    for (final day in schedule.days) {
      for (final assignment in day.assignments) {
        yield (date: day.date, assignment: assignment);
      }
    }
  }

  ({DateTime start, DateTime end}) _interval(
    DateTime date,
    ShiftAssignment assignment,
  ) {
    final start = DateTime(
      date.year,
      date.month,
      date.day,
    ).add(assignment.shift.startTime);
    var end = DateTime(
      date.year,
      date.month,
      date.day,
    ).add(assignment.shift.endTime);
    if (assignment.shift.overnight) end = end.add(const Duration(days: 1));
    return (start: start, end: end);
  }

  String _date(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-'
      '${value.month.toString().padLeft(2, '0')}-'
      '${value.day.toString().padLeft(2, '0')}';
}
