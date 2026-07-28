import '../../../domain/entities/employee.dart';
import '../../../domain/entities/schedule.dart';
import '../domain/calendar_sync_change.dart';

abstract interface class CalendarSyncGateway {
  Future<List<CalendarSyncChange>> preview(
    Schedule schedule,
    Employee employee,
  );

  Future<void> apply(
    Schedule schedule,
    Employee employee,
    List<CalendarSyncChange> changes,
  );
}
