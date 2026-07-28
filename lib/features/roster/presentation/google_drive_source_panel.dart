import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/l10n.dart';
import '../../../l10n/localized_date_format.dart';
import '../application/drive_roster_source_controller.dart';
import '../domain/drive_roster_source.dart';
import '../../exchange/application/exchange_controller.dart';
import 'google_login_button.dart';

class GoogleDriveSourcePanel extends StatelessWidget {
  const GoogleDriveSourcePanel({
    required this.controller,
    required this.exchangeController,
    super.key,
  });

  final DriveRosterSourceController controller;
  final ExchangeController exchangeController;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Listenable.merge([controller, controller.auth]),
    builder: (context, _) {
      final l10n = context.l10n;
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.googleDrive,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(l10n.googleDriveDescription),
                    ],
                  ),
                  if (controller.auth.signedIn)
                    Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(controller.auth.account?.email ?? ''),
                        OutlinedButton.icon(
                          onPressed: controller.auth.signOut,
                          icon: const Icon(Icons.logout),
                          label: Text(l10n.signOutGoogle),
                        ),
                        FilledButton.icon(
                          onPressed: controller.loading
                              ? null
                              : controller.refresh,
                          icon: const Icon(Icons.add_to_drive_outlined),
                          label: Text(l10n.openGoogleDrive),
                        ),
                      ],
                    )
                  else if (controller.auth.pluginReady)
                    GoogleLoginButton(
                      enabled: !controller.loading,
                      onPressed: controller.auth.signIn,
                    )
                  else
                    OutlinedButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.key_off_outlined),
                      label: Text(l10n.signInWithGoogle),
                    ),
                ],
              ),
              if (controller.auth.error != null) ...[
                const SizedBox(height: 12),
                Text(
                  controller.auth.error == 'google_drive_not_configured'
                      ? l10n.googleDriveNotConfigured
                      : controller.auth.error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              if (controller.loading) ...[
                const SizedBox(height: 16),
                const LinearProgressIndicator(),
              ],
              if (controller.errorCode != null) ...[
                const SizedBox(height: 16),
                Text(
                  controller.errorCode == 'google_drive_not_configured'
                      ? l10n.googleDriveNotConfigured
                      : l10n.googleDriveLoadFailed,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 20),
              Text(
                l10n.sheetReadMode,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SegmentedButton<SheetReadMode>(
                segments: [
                  ButtonSegment(
                    value: SheetReadMode.configured,
                    icon: const Icon(Icons.tune),
                    label: Text(l10n.configuredSheetRead),
                  ),
                  ButtonSegment(
                    value: SheetReadMode.standard,
                    icon: const Icon(Icons.table_view_outlined),
                    label: Text(l10n.standardSheetRead),
                  ),
                ],
                selected: {controller.readMode},
                onSelectionChanged: controller.loading
                    ? null
                    : (selection) =>
                          controller.selectReadMode(selection.single),
              ),
              const SizedBox(height: 8),
              Text(
                controller.readMode == SheetReadMode.configured
                    ? l10n.configuredSheetReadDescription
                    : l10n.standardSheetReadDescription,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 20),
              Text(
                l10n.recentlyModified,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (controller.recentSources.isEmpty)
                Text(l10n.noDriveRosterFiles)
              else
                for (final source in controller.recentSources)
                  CheckboxListTile(
                    value: controller.selectedSource?.id == source.id,
                    onChanged: (selected) =>
                        controller.select(selected == true ? source : null),
                    title: Text(source.name),
                    subtitle: Text(_sourceDetails(context, source)),
                    secondary: const Icon(Icons.description_outlined),
                  ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.tonalIcon(
                  onPressed:
                      controller.selectedSource == null || controller.loading
                      ? null
                      : () => _loadTimeline(context),
                  icon: const Icon(Icons.history_outlined),
                  label: Text(l10n.loadFirstTimeline),
                ),
              ),
              if (controller.timeline case final timeline?) ...[
                const SizedBox(height: 16),
                _TimelineMappingCard(
                  controller: controller,
                  timeline: timeline,
                  exchangeController: exchangeController,
                ),
              ],
              const Divider(height: 32),
              Text(
                l10n.lastImported,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (controller.lastImported case final source?)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.history),
                  title: Text(source.name),
                  subtitle: Text(_sourceDetails(context, source)),
                )
              else
                Text(l10n.noLastImportedSource),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed:
                      controller.selectedSource == null || controller.loading
                      ? null
                      : () => _loadSelected(context),
                  icon: const Icon(Icons.download_outlined),
                  label: Text(l10n.loadCurrentSource),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  String _sourceDetails(BuildContext context, DriveRosterSource source) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final rosterMonth = formatLocalizedDate(
      DateFormat.yMMMM(locale),
      source.rosterMonth,
      locale: locale,
    );
    final modifiedTime = formatLocalizedDate(
      DateFormat.yMMMd(locale).add_Hm(),
      source.modifiedTime,
      locale: locale,
    );
    return '$rosterMonth • $modifiedTime';
  }

  Future<void> _loadSelected(BuildContext context) async {
    final loaded = await controller.loadCurrentSource();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          loaded
              ? context.l10n.driveSourceLoaded
              : context.l10n.googleDriveLoadFailed,
        ),
      ),
    );
  }

  Future<void> _loadTimeline(BuildContext context) async {
    final loaded = await controller.loadFirstTimeline();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          loaded
              ? context.l10n.timelineLoaded
              : context.l10n.timelineLoadFailed,
        ),
      ),
    );
  }
}

class _TimelineMappingCard extends StatelessWidget {
  const _TimelineMappingCard({
    required this.controller,
    required this.timeline,
    required this.exchangeController,
  });

  final DriveRosterSourceController controller;
  final SheetTimelineData timeline;
  final ExchangeController exchangeController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final source = timeline.source;
    final created = source.createdTime == null
        ? l10n.unknownCreatedTime
        : DateFormat.yMMMd(
            Localizations.localeOf(context).toLanguageTag(),
          ).add_Hm().format(source.createdTime!.toLocal());
    final headerCandidates = timeline.rows.take(10).toList(growable: false);
    final preview = controller.mappedTimelineRows.take(20);
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.firstFileTimeline,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('${l10n.fileCreatedTime}: $created'),
            Text('${l10n.firstWorksheet}: ${timeline.sheetTitle}'),
            if (source.ownerNames.isNotEmpty)
              Text('${l10n.fileOwners}: ${source.ownerNames.join(', ')}'),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: controller.headerRowIndex,
              decoration: InputDecoration(labelText: l10n.headerRow),
              items: [
                for (final (index, row) in headerCandidates.indexed)
                  DropdownMenuItem(
                    value: index,
                    child: Text(
                      '${l10n.rowNumber(index + 1)} — '
                      '${row.take(3).join(' | ')}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (value) {
                if (value != null) controller.selectHeaderRow(value);
              },
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final field in ExchangeSheetField.values)
                  SizedBox(
                    width: 230,
                    child: DropdownButtonFormField<int?>(
                      initialValue: controller.columnMapping[field],
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: _fieldLabel(context, field),
                      ),
                      items: [
                        DropdownMenuItem<int?>(
                          value: null,
                          child: Text(l10n.notMapped),
                        ),
                        for (final (index, header)
                            in controller.timelineHeaders.indexed)
                          DropdownMenuItem<int?>(
                            value: index,
                            child: Text(
                              header,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: (value) => controller.mapColumn(field, value),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.exchangeDataPreview,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            if (preview.isEmpty)
              Text(l10n.noTimelineRows)
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text(l10n.row)),
                    DataColumn(label: Text(l10n.exchangeGiver)),
                    DataColumn(label: Text(l10n.exchangeReceiver)),
                    DataColumn(label: Text(l10n.date)),
                    DataColumn(label: Text(l10n.shift)),
                    DataColumn(label: Text(l10n.reason)),
                  ],
                  rows: [
                    for (final value in preview)
                      DataRow(
                        cells: [
                          DataCell(Text('${value.rowNumber}')),
                          DataCell(Text(value.value(ExchangeSheetField.giver))),
                          DataCell(
                            Text(value.value(ExchangeSheetField.receiver)),
                          ),
                          DataCell(Text(value.value(ExchangeSheetField.date))),
                          DataCell(Text(value.value(ExchangeSheetField.shift))),
                          DataCell(
                            Text(value.value(ExchangeSheetField.reason)),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            Text(
              l10n.currentSheetValuesNotice,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed:
                    controller.columnMapping[ExchangeSheetField.giver] ==
                            null ||
                        controller.columnMapping[ExchangeSheetField.receiver] ==
                            null ||
                        controller.columnMapping[ExchangeSheetField.date] ==
                            null
                    ? null
                    : () => _createRequests(context),
                icon: const Icon(Icons.swap_horiz),
                label: Text(l10n.createCoverRequests),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fieldLabel(BuildContext context, ExchangeSheetField field) =>
      switch (field) {
        ExchangeSheetField.giver => context.l10n.exchangeGiver,
        ExchangeSheetField.receiver => context.l10n.exchangeReceiver,
        ExchangeSheetField.date => context.l10n.date,
        ExchangeSheetField.shift => context.l10n.shift,
        ExchangeSheetField.type => context.l10n.exchangeType,
        ExchangeSheetField.reason => context.l10n.reason,
        ExchangeSheetField.remark => context.l10n.remark,
      };

  Future<void> _createRequests(BuildContext context) async {
    final result = await controller.createCoverRequests(exchangeController);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.l10n.timelineImportResult(result.created, result.skipped),
        ),
      ),
    );
  }
}
