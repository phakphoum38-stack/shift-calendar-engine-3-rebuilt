import 'package:googleapis/calendar/v3.dart' as calendar;

import '../../../domain/entities/employee.dart';
import '../../../domain/entities/schedule.dart';
import '../../../domain/entities/shift_assignment.dart';
import '../../roster/infrastructure/google_auth_controller.dart';
import '../application/calendar_sync_gateway.dart';
import '../domain/calendar_sync_change.dart';

class GoogleCalendarSyncGateway implements CalendarSyncGateway {
  GoogleCalendarSyncGateway(this.auth);

  final GoogleAuthController auth;

  @override
  Future<List<CalendarSyncChange>> preview(
    Schedule schedule,
    Employee employee,
  ) async {
    final client = await auth.authorizedClient();
    try {
      final api = calendar.CalendarApi(client);
      final response = await api.events.list(
        'primary',
        privateExtendedProperty: [
          'sceScheduleId=${schedule.id}',
          'sceEmployeeId=${employee.id}',
        ],
        singleEvents: true,
        showDeleted: false,
        maxResults: 2500,
      );
      final existing = <String, calendar.Event>{};
      for (final event in response.items ?? const <calendar.Event>[]) {
        final assignmentId =
            event.extendedProperties?.private?['sceAssignmentId'];
        if (assignmentId != null) existing[assignmentId] = event;
      }
      final desired = <String, ({DateTime date, ShiftAssignment assignment})>{};
      for (final day in schedule.days) {
        for (final assignment in day.assignments) {
          if (assignment.employee.id == employee.id && assignment.approved) {
            desired[assignment.id] = (date: day.date, assignment: assignment);
          }
        }
      }
      final changes = <CalendarSyncChange>[];
      for (final entry in desired.entries) {
        final event = existing.remove(entry.key);
        final expected = _event(
          schedule,
          entry.value.date,
          entry.value.assignment,
        );
        changes.add(
          CalendarSyncChange(
            action: event == null
                ? CalendarSyncAction.create
                : _equivalent(event, expected)
                ? CalendarSyncAction.unchanged
                : CalendarSyncAction.update,
            assignmentId: entry.key,
            title: expected.summary ?? entry.key,
            assignment: entry.value.assignment,
            eventId: event?.id,
          ),
        );
      }
      for (final entry in existing.entries) {
        changes.add(
          CalendarSyncChange(
            action: CalendarSyncAction.delete,
            assignmentId: entry.key,
            title: entry.value.summary ?? entry.key,
            eventId: entry.value.id,
          ),
        );
      }
      return List.unmodifiable(changes);
    } finally {
      client.close();
    }
  }

  @override
  Future<void> apply(
    Schedule schedule,
    Employee employee,
    List<CalendarSyncChange> changes,
  ) async {
    final byId = <String, ({DateTime date, ShiftAssignment assignment})>{};
    for (final day in schedule.days) {
      for (final assignment in day.assignments) {
        byId[assignment.id] = (date: day.date, assignment: assignment);
      }
    }
    final client = await auth.authorizedClient();
    try {
      final api = calendar.CalendarApi(client);
      for (final change in changes) {
        switch (change.action) {
          case CalendarSyncAction.create:
            final value = byId[change.assignmentId]!;
            await api.events.insert(
              _event(schedule, value.date, value.assignment),
              'primary',
            );
          case CalendarSyncAction.update:
            final value = byId[change.assignmentId]!;
            await api.events.update(
              _event(schedule, value.date, value.assignment),
              'primary',
              change.eventId!,
            );
          case CalendarSyncAction.delete:
            if (change.eventId != null) {
              await api.events.delete('primary', change.eventId!);
            }
          case CalendarSyncAction.unchanged:
            break;
        }
      }
    } finally {
      client.close();
    }
  }

  calendar.Event _event(
    Schedule schedule,
    DateTime date,
    ShiftAssignment assignment,
  ) {
    DateTime instant(Duration time, {bool nextDay = false}) => DateTime.utc(
      date.year,
      date.month,
      date.day + (nextDay ? 1 : 0),
    ).add(time).subtract(const Duration(hours: 7));
    final start = instant(assignment.shift.startTime);
    final end = instant(
      assignment.shift.endTime,
      nextDay: assignment.shift.overnight,
    );
    return calendar.Event(
      summary: '${assignment.shift.code} — ${assignment.shift.name}',
      description: [
        assignment.employee.displayName,
        assignment.location,
        assignment.remark,
      ].whereType<String>().join(' • '),
      start: calendar.EventDateTime(dateTime: start, timeZone: 'Asia/Bangkok'),
      end: calendar.EventDateTime(dateTime: end, timeZone: 'Asia/Bangkok'),
      extendedProperties: calendar.EventExtendedProperties(
        private: {
          'sceScheduleId': schedule.id,
          'sceEmployeeId': assignment.employee.id,
          'sceAssignmentId': assignment.id,
        },
      ),
    );
  }

  bool _equivalent(calendar.Event first, calendar.Event second) =>
      first.summary == second.summary &&
      first.description == second.description &&
      first.start?.dateTime == second.start?.dateTime &&
      first.end?.dateTime == second.end?.dateTime;
}
