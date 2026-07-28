import '../../../domain/entities/shift_assignment.dart';

enum CalendarSyncAction { create, update, delete, unchanged }

class CalendarSyncChange {
  const CalendarSyncChange({
    required this.action,
    required this.assignmentId,
    required this.title,
    this.assignment,
    this.eventId,
  });

  final CalendarSyncAction action;
  final String assignmentId;
  final String title;
  final ShiftAssignment? assignment;
  final String? eventId;
}
