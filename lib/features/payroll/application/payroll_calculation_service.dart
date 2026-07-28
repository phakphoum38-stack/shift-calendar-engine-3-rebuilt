import '../../../domain/entities/employee.dart';
import '../../../domain/entities/roster_policy.dart';
import '../../../domain/entities/schedule.dart';
import '../../../domain/entities/schedule_day.dart';
import '../domain/payroll_summary.dart';

class PayrollCalculationService {
  const PayrollCalculationService();

  PayrollSummary calculate(
    Schedule schedule,
    DateTime month,
    RosterPolicy policy,
  ) {
    final values = <String, _MutablePayroll>{};
    final scheduleMonth = schedule.month(month);
    for (final day in scheduleMonth?.days ?? const <ScheduleDay>[]) {
      for (final assignment in day.assignments.where(
        (value) => value.approved,
      )) {
        final employee = values.putIfAbsent(
          assignment.employee.id,
          () => _MutablePayroll(assignment.employee),
        );
        employee.shiftCount++;
        employee.workingHours += assignment.shift.workingHours;
        employee.basePay += assignment.shift.rate;
        final overtimeHours =
            assignment.shift.workingHours - policy.overtimeThresholdHours;
        if (overtimeHours > 0 && assignment.shift.workingHours > 0) {
          final hourlyRate =
              assignment.shift.rate / assignment.shift.workingHours;
          employee.overtimePay +=
              overtimeHours * hourlyRate * policy.overtimeMultiplier;
        }
        if (day.holidayName != null) {
          employee.holidayPay +=
              assignment.shift.rate * (policy.holidayRateMultiplier - 1);
        }
      }
    }
    final result = [
      for (final value in values.values)
        EmployeePayrollSummary(
          employee: value.employee,
          shiftCount: value.shiftCount,
          workingHours: value.workingHours,
          basePay: value.basePay,
          overtimePay: value.overtimePay,
          holidayPay: value.holidayPay,
        ),
    ]..sort((a, b) => a.employee.displayName.compareTo(b.employee.displayName));
    return PayrollSummary(employees: List.unmodifiable(result));
  }
}

class _MutablePayroll {
  _MutablePayroll(this.employee);

  final Employee employee;
  int shiftCount = 0;
  double workingHours = 0;
  double basePay = 0;
  double overtimePay = 0;
  double holidayPay = 0;
}
