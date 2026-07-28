import '../../../domain/entities/schedule.dart';
import '../domain/dashboard_summary.dart';
import '../../../domain/entities/roster_policy.dart';
import '../../payroll/application/payroll_calculation_service.dart';

/// Derives immutable dashboard values from the canonical schedule.
class DashboardSummaryService {
  const DashboardSummaryService({
    this.payrollService = const PayrollCalculationService(),
  });

  final PayrollCalculationService payrollService;

  DashboardSummary build(
    Schedule schedule,
    DateTime now, {
    RosterPolicy policy = const RosterPolicy(),
  }) {
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final currentMonth = schedule.month(today);
    final tomorrowMonth = schedule.month(tomorrow);
    final todayAssignments = currentMonth?.day(today)?.assignments ?? const [];
    final tomorrowAssignments =
        tomorrowMonth?.day(tomorrow)?.assignments ?? const [];
    final monthlyAssignmentCount =
        currentMonth?.days.fold<int>(
          0,
          (total, day) => total + day.assignments.length,
        ) ??
        0;
    final payroll = payrollService.calculate(schedule, today, policy);
    return DashboardSummary(
      todayAssignments: List.unmodifiable(todayAssignments),
      tomorrowAssignments: List.unmodifiable(tomorrowAssignments),
      monthlyAssignmentCount: monthlyAssignmentCount,
      estimatedIncome: payroll.totalPay,
      estimatedOvertime: payroll.overtimePay,
    );
  }
}
