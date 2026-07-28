import 'employee.dart';

enum ExchangeType { cover, swap }

enum ExchangeStatus { submitted, accepted, approved, rejected, cancelled }

/// Persistent request to transfer one assignment or swap two assignments.
class ExchangeRequest {
  const ExchangeRequest({
    required this.id,
    required this.type,
    required this.sourceAssignmentId,
    required this.sourceDate,
    required this.requester,
    required this.recipient,
    required this.reason,
    required this.status,
    required this.createdAt,
    this.offeredAssignmentId,
    this.offeredDate,
    this.respondedAt,
    this.approvedAt,
    this.approverName,
    this.rejectionReason,
  });

  final String id;
  final ExchangeType type;
  final String sourceAssignmentId;
  final DateTime sourceDate;
  final Employee requester;
  final Employee recipient;
  final String reason;
  final ExchangeStatus status;
  final DateTime createdAt;
  final String? offeredAssignmentId;
  final DateTime? offeredDate;
  final DateTime? respondedAt;
  final DateTime? approvedAt;
  final String? approverName;
  final String? rejectionReason;

  ExchangeRequest copyWith({
    ExchangeStatus? status,
    DateTime? respondedAt,
    DateTime? approvedAt,
    String? approverName,
    String? rejectionReason,
  }) {
    return ExchangeRequest(
      id: id,
      type: type,
      sourceAssignmentId: sourceAssignmentId,
      sourceDate: sourceDate,
      requester: requester,
      recipient: recipient,
      reason: reason,
      status: status ?? this.status,
      createdAt: createdAt,
      offeredAssignmentId: offeredAssignmentId,
      offeredDate: offeredDate,
      respondedAt: respondedAt ?? this.respondedAt,
      approvedAt: approvedAt ?? this.approvedAt,
      approverName: approverName ?? this.approverName,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}
