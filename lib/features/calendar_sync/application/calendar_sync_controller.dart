import 'package:flutter/foundation.dart';

import '../../../domain/entities/employee.dart';
import '../../../domain/entities/schedule.dart';
import '../domain/calendar_sync_change.dart';
import 'calendar_sync_gateway.dart';

class CalendarSyncController extends ChangeNotifier {
  CalendarSyncController({required this.gateway, required this.schedule});

  final CalendarSyncGateway gateway;
  Schedule schedule;
  Employee? selectedEmployee;
  List<CalendarSyncChange> changes = const [];
  bool loading = false;
  String? error;

  List<Employee> get employees {
    final byId = <String, Employee>{
      for (final assignment in schedule.assignments)
        assignment.employee.id: assignment.employee,
    };
    return List.unmodifiable(
      byId.values.toList()
        ..sort((a, b) => a.displayName.compareTo(b.displayName)),
    );
  }

  void selectEmployee(Employee? value) {
    selectedEmployee = value;
    changes = const [];
    error = null;
    notifyListeners();
  }

  void updateSchedule(Schedule value) {
    schedule = value;
    changes = const [];
    notifyListeners();
  }

  Future<bool> preview() async {
    final employee = selectedEmployee;
    if (employee == null || loading) return false;
    loading = true;
    error = null;
    notifyListeners();
    try {
      changes = await gateway.preview(schedule, employee);
      return true;
    } on Object catch (value) {
      error = value.toString();
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> sync() async {
    final employee = selectedEmployee;
    if (employee == null || changes.isEmpty || loading) return false;
    loading = true;
    error = null;
    notifyListeners();
    try {
      await gateway.apply(schedule, employee, changes);
      changes = await gateway.preview(schedule, employee);
      return true;
    } on Object catch (value) {
      error = value.toString();
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
