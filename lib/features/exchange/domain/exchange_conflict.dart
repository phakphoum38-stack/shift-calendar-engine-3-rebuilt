enum ExchangeConflictSeverity { error, warning, information }

class ExchangeConflict {
  const ExchangeConflict({
    required this.code,
    required this.severity,
    required this.message,
  });

  final String code;
  final ExchangeConflictSeverity severity;
  final String message;

  bool get blocksApproval => severity == ExchangeConflictSeverity.error;
}
