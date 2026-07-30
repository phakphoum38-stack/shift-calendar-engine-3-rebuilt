import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/l10n.dart';
import '../../../l10n/localized_date_format.dart';
import '../application/drive_roster_source_controller.dart';
import '../domain/drive_roster_source.dart';
import 'google_login_button.dart';

/// Dedicated Google Sheets import screen.
///
/// This page only reads spreadsheet sources that already exist in Google Drive.
/// It does not offer local-file attachment or upload, so personal files are not
/// included in the GitHub code merge workflow.
class GoogleSheetImportPage extends StatelessWidget {
  const GoogleSheetImportPage({
    required this.controller,
    super.key,
  });

  final DriveRosterSourceController controller;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListenableBuilder(
      listenable: Listenable.merge([controller, controller.auth]),
      builder: (context, _) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Google Sheets Import',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          _Header(controller: controller),
          if (controller.loading) ...[
            const SizedBox(height: 16),
            const LinearProgressIndicator(),
          ],
          if (controller.errorCode != null) ...[
            const SizedBox(height: 12),
            Text(
              controller.errorCode == 'google_drive_not_configured'
                  ? context.l10n.googleDriveNotConfigured
                  : context.l10n.googleDriveLoadFailed,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 20),
          Text(
            context.l10n.sheetReadMode,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          SegmentedButton<SheetReadMode>(
            segments: [
              ButtonSegment(
                value: SheetReadMode.configured,
                icon: const Icon(Icons.tune),
                label: Text(context.l10n.configuredSheetRead),
              ),
              ButtonSegment(
                value: SheetReadMode.standard,
                icon: const Icon(Icons.table_view_outlined),
                label: Text(context.l10n.standardSheetRead),
              ),
            ],
            selected: {controller.readMode},
            onSelectionChanged: controller.loading
                ? null
                : (selection) => controller.selectReadMode(selection.single),
          ),
          const SizedBox(height: 20),
          Text(
            context.l10n.recentlyModified,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (controller.recentSources.isEmpty)
            Text(context.l10n.noDriveRosterFiles)
          else
            for (final source in controller.recentSources)
              RadioListTile<String>(
                value: source.id,
                groupValue: controller.selectedSource?.id,
                onChanged: controller.loading
                    ? null
                    : (_) => controller.select(source),
                title: Text(source.name),
                subtitle: Text(_sourceDetails(context, source)),
                secondary: const Icon(Icons.table_chart_outlined),
              ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed:
                controller.selectedSource == null || controller.loading
                ? null
                : () => _importSelected(context),
            icon: const Icon(Icons.download_outlined),
            label: Text(context.l10n.loadCurrentSource),
          ),
          const SizedBox(height: 8),
          Text(
            'นำเข้าเฉพาะ Google Sheets ที่เลือกเท่านั้น ไม่แนบหรืออัปโหลดไฟล์ส่วนตัวเข้า GitHub',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    ),
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

  Future<void> _importSelected(BuildContext context) async {
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
}

class _Header extends StatelessWidget {
  const _Header({required this.controller});

  final DriveRosterSourceController controller;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 12,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.googleDrive,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(context.l10n.googleDriveDescription),
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
                  label: Text(context.l10n.signOutGoogle),
                ),
                FilledButton.icon(
                  onPressed: controller.loading ? null : controller.refresh,
                  icon: const Icon(Icons.refresh),
                  label: Text(context.l10n.openGoogleDrive),
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
              label: Text(context.l10n.signInWithGoogle),
            ),
        ],
      ),
    ),
  );
}
