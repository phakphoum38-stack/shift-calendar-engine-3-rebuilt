class RosterPolicy {
  const RosterPolicy({
    this.minimumRestHours = 8,
    this.maximumContinuousHours = 16,
    this.maximumShiftsPerDay = 2,
    this.maximumShiftsPerWeek = 7,
    this.maximumShiftsPerMonth = 31,
    this.blockOverlappingShifts = true,
    this.requireExchangeApproval = true,
    this.overtimeThresholdHours = 8,
    this.overtimeMultiplier = 1.5,
    this.holidayRateMultiplier = 1.5,
  });

  final int minimumRestHours;
  final int maximumContinuousHours;
  final int maximumShiftsPerDay;
  final int maximumShiftsPerWeek;
  final int maximumShiftsPerMonth;
  final bool blockOverlappingShifts;
  final bool requireExchangeApproval;
  final double overtimeThresholdHours;
  final double overtimeMultiplier;
  final double holidayRateMultiplier;

  RosterPolicy copyWith({
    int? minimumRestHours,
    int? maximumContinuousHours,
    int? maximumShiftsPerDay,
    int? maximumShiftsPerWeek,
    int? maximumShiftsPerMonth,
    bool? blockOverlappingShifts,
    bool? requireExchangeApproval,
    double? overtimeThresholdHours,
    double? overtimeMultiplier,
    double? holidayRateMultiplier,
  }) {
    return RosterPolicy(
      minimumRestHours: minimumRestHours ?? this.minimumRestHours,
      maximumContinuousHours:
          maximumContinuousHours ?? this.maximumContinuousHours,
      maximumShiftsPerDay: maximumShiftsPerDay ?? this.maximumShiftsPerDay,
      maximumShiftsPerWeek: maximumShiftsPerWeek ?? this.maximumShiftsPerWeek,
      maximumShiftsPerMonth:
          maximumShiftsPerMonth ?? this.maximumShiftsPerMonth,
      blockOverlappingShifts:
          blockOverlappingShifts ?? this.blockOverlappingShifts,
      requireExchangeApproval:
          requireExchangeApproval ?? this.requireExchangeApproval,
      overtimeThresholdHours:
          overtimeThresholdHours ?? this.overtimeThresholdHours,
      overtimeMultiplier: overtimeMultiplier ?? this.overtimeMultiplier,
      holidayRateMultiplier:
          holidayRateMultiplier ?? this.holidayRateMultiplier,
    );
  }
}
