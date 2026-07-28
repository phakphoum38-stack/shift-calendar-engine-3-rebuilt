import '../../../domain/entities/schedule.dart';
import '../../../domain/entities/schedule_day.dart';
import '../../../domain/entities/schedule_month.dart';
import '../../../domain/entities/shift_assignment.dart';

/// Idempotently merges imported assignments into the canonical schedule.
///
/// Stable source IDs update an existing assignment. Exact logical matches are
/// also retained only once, protecting against providers that regenerate IDs
/// when the same sheet or calendar data is synchronized again.
class ScheduleMergeService {
  const ScheduleMergeService();

  Schedule merge(Schedule current, Schedule incoming) {
    var result = current;
    for (final incomingMonth in incoming.months) {
      var mergedMonth =
          result.month(incomingMonth.month) ??
          ScheduleMonth(month: incomingMonth.month);
      for (final incomingDay in incomingMonth.days) {
        final currentDay =
            mergedMonth.day(incomingDay.date) ??
            ScheduleDay(date: incomingDay.date);
        final assignments = List<ShiftAssignment>.of(currentDay.assignments);
        for (final assignment in incomingDay.assignments) {
          final idIndex = assignments.indexWhere(
            (existing) => existing.id == assignment.id,
          );
          if (idIndex != -1) {
            assignments[idIndex] = assignment;
            continue;
          }
          if (assignments.any(
            (existing) => areLogicallyEquivalent(existing, assignment),
          )) {
            continue;
          }
          assignments.add(assignment);
        }
        mergedMonth = mergedMonth.replaceDay(
          ScheduleDay(
            date: currentDay.date,
            assignments: assignments,
            holidayName: incomingDay.holidayName ?? currentDay.holidayName,
          ),
        );
      }
      result = result.replaceMonth(mergedMonth);
    }
    return result;
  }

  bool areLogicallyEquivalent(ShiftAssignment first, ShiftAssignment second) {
    return first.employee.id == second.employee.id &&
        first.shift.id == second.shift.id &&
        _normalized(first.location) == _normalized(second.location) &&
        _normalized(first.remark) == _normalized(second.remark) &&
        first.approved == second.approved;
  }

  String _normalized(String? value) => value?.trim().toLowerCase() ?? '';
}
