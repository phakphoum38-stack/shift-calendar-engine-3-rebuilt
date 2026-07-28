import '../../../domain/entities/schedule.dart';
import '../domain/dashboard_summary.dart';

/// Derives immutable dashboard values from the canonical schedule.
class DashboardSummaryService {
  const DashboardSummaryService();

  DashboardSummary build(Schedule schedule, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final currentMonth = schedule.month(today);
    final tomorrowMonth = schedule.month(tomorrow);
    final todayAssignments = currentMonth?.day(today)?.assignments ?? const [];
    final tomorrowAssignments =
        tomorrowMonth?.day(tomorrow)?.assignments ?? const [];
    final assignments =
        currentMonth?.days.expand((day) => day.assignments) ?? const [];
    return DashboardSummary(
      todayAssignments: List.unmodifiable(todayAssignments),
      tomorrowAssignments: List.unmodifiable(tomorrowAssignments),
      monthlyAssignmentCount: assignments.length,
      estimatedIncome: assignments.fold(
        0,
        (total, assignment) => total + assignment.shift.rate,
      ),
    );
  }
}
