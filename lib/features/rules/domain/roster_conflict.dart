enum RosterConflictSeverity { error, warning, information }

class RosterConflict {
  const RosterConflict({
    required this.code,
    required this.severity,
    required this.message,
    this.assignmentIds = const [],
  });

  final String code;
  final RosterConflictSeverity severity;
  final String message;
  final List<String> assignmentIds;

  bool get blocksSave => severity == RosterConflictSeverity.error;
}
