import '../../../domain/entities/employee.dart';

class EmployeePayrollSummary {
  const EmployeePayrollSummary({
    required this.employee,
    required this.shiftCount,
    required this.workingHours,
    required this.basePay,
    required this.overtimePay,
    required this.holidayPay,
  });

  final Employee employee;
  final int shiftCount;
  final double workingHours;
  final double basePay;
  final double overtimePay;
  final double holidayPay;

  double get totalPay => basePay + overtimePay + holidayPay;
}

class PayrollSummary {
  const PayrollSummary({required this.employees});

  final List<EmployeePayrollSummary> employees;

  double get basePay =>
      employees.fold(0, (total, value) => total + value.basePay);
  double get overtimePay =>
      employees.fold(0, (total, value) => total + value.overtimePay);
  double get holidayPay =>
      employees.fold(0, (total, value) => total + value.holidayPay);
  double get totalPay =>
      employees.fold(0, (total, value) => total + value.totalPay);
}
