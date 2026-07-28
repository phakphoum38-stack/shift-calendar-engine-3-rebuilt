import 'package:flutter_test/flutter_test.dart';
import 'package:shift_calendar_engine/domain/entities/roster_policy.dart';
import 'package:shift_calendar_engine/features/payroll/application/payroll_calculation_service.dart';

import 'support/fixtures.dart';

void main() {
  test('calculates base, overtime, and holiday pay from approved work', () {
    final schedule = canonicalScheduleFixture();
    final month = schedule.months.single;
    final holidaySchedule = schedule.replaceMonth(
      month.replaceDay(month.days.single.copyWith(holidayName: 'Holiday')),
    );

    final result = const PayrollCalculationService().calculate(
      holidaySchedule,
      month.month,
      const RosterPolicy(
        overtimeThresholdHours: 8,
        overtimeMultiplier: 1.5,
        holidayRateMultiplier: 2,
      ),
    );

    expect(result.basePay, 900);
    expect(result.overtimePay, 450);
    expect(result.holidayPay, 900);
    expect(result.totalPay, 2250);
  });
}
