import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../application/calendar_sync_controller.dart';
import '../domain/calendar_sync_change.dart';

class CalendarSyncPanel extends StatelessWidget {
  const CalendarSyncPanel({required this.controller, super.key});

  final CalendarSyncController controller;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) => Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.l10n.googleCalendarSync,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(context.l10n.googleCalendarSyncDescription),
            const SizedBox(height: 12),
            DropdownButtonFormField(
              initialValue: controller.selectedEmployee,
              decoration: InputDecoration(
                labelText: context.l10n.calendarEmployee,
              ),
              items: [
                for (final employee in controller.employees)
                  DropdownMenuItem(
                    value: employee,
                    child: Text(employee.displayName),
                  ),
              ],
              onChanged: controller.selectEmployee,
            ),
            if (controller.loading) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
            ],
            if (controller.error != null) ...[
              const SizedBox(height: 12),
              Text(
                controller.error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (controller.changes.isNotEmpty) ...[
              const SizedBox(height: 16),
              for (final change in controller.changes)
                ListTile(
                  dense: true,
                  leading: Icon(_icon(change.action)),
                  title: Text(change.title),
                  subtitle: Text(_action(context, change.action)),
                ),
            ],
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed:
                      controller.selectedEmployee == null || controller.loading
                      ? null
                      : controller.preview,
                  icon: const Icon(Icons.preview_outlined),
                  label: Text(context.l10n.previewCalendarSync),
                ),
                FilledButton.icon(
                  onPressed: controller.changes.isEmpty || controller.loading
                      ? null
                      : controller.sync,
                  icon: const Icon(Icons.sync),
                  label: Text(context.l10n.syncCalendar),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  IconData _icon(CalendarSyncAction value) => switch (value) {
    CalendarSyncAction.create => Icons.add_circle_outline,
    CalendarSyncAction.update => Icons.edit_calendar_outlined,
    CalendarSyncAction.delete => Icons.delete_outline,
    CalendarSyncAction.unchanged => Icons.check_circle_outline,
  };

  String _action(BuildContext context, CalendarSyncAction value) =>
      switch (value) {
        CalendarSyncAction.create => context.l10n.calendarCreate,
        CalendarSyncAction.update => context.l10n.calendarUpdate,
        CalendarSyncAction.delete => context.l10n.calendarDelete,
        CalendarSyncAction.unchanged => context.l10n.calendarUnchanged,
      };
}
