import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis/sheets/v4.dart' as sheets;

import '../application/drive_roster_source_gateway.dart';
import '../domain/drive_roster_source.dart';
import 'google_auth_controller.dart';

class GoogleDriveRosterSourceGateway implements DriveRosterSourceGateway {
  GoogleDriveRosterSourceGateway(this.auth);

  final GoogleAuthController auth;
  DriveRosterSource? _lastImported;

  @override
  Future<List<DriveRosterSource>> listRecentlyModified() async {
    if (!auth.signedIn) {
      throw const DriveRosterSourceException('google_sign_in_required');
    }
    final client = await auth.authorizedClient();
    try {
      final response = await drive.DriveApi(client).files.list(
        q:
            "mimeType='application/vnd.google-apps.spreadsheet' "
            'and trashed=false',
        spaces: 'drive',
        orderBy: 'modifiedTime desc',
        pageSize: 100,
        $fields: 'files(id,name,createdTime,modifiedTime,owners(displayName))',
      );
      return [
        for (final file in response.files ?? const <drive.File>[])
          if (file.id != null && file.name != null)
            DriveRosterSource(
              id: file.id!,
              name: file.name!,
              modifiedTime: file.modifiedTime ?? DateTime.now().toUtc(),
              rosterMonth: _rosterMonth(
                file.name!,
                file.modifiedTime ?? DateTime.now(),
              ),
              createdTime: file.createdTime,
              ownerNames: [
                for (final owner in file.owners ?? const <drive.User>[])
                  if (owner.displayName?.trim().isNotEmpty == true)
                    owner.displayName!.trim(),
              ],
            ),
      ];
    } finally {
      client.close();
    }
  }

  @override
  Future<SheetTimelineData> loadFirstTimeline(DriveRosterSource source) async {
    if (!auth.signedIn) {
      throw const DriveRosterSourceException('google_sign_in_required');
    }
    final client = await auth.authorizedClient();
    try {
      final api = sheets.SheetsApi(client);
      final spreadsheet = await api.spreadsheets.get(
        source.id,
        includeGridData: false,
        $fields: 'sheets(properties(sheetId,title,index))',
      );
      final worksheets =
          List<sheets.Sheet>.of(
            spreadsheet.sheets ?? const <sheets.Sheet>[],
          )..sort(
            (a, b) =>
                (a.properties?.index ?? 0).compareTo(b.properties?.index ?? 0),
          );
      final title = worksheets.firstOrNull?.properties?.title;
      if (title == null || title.trim().isEmpty) {
        throw const DriveRosterSourceException('sheet_has_no_worksheets');
      }
      final escapedTitle = title.replaceAll("'", "''");
      final values = await api.spreadsheets.values.get(
        source.id,
        "'$escapedTitle'!1:200",
        majorDimension: 'ROWS',
      );
      return SheetTimelineData(
        source: source,
        sheetTitle: title,
        rows: [
          for (final row in values.values ?? const <List<Object?>>[])
            [for (final value in row) value?.toString() ?? ''],
        ],
      );
    } on DriveRosterSourceException {
      rethrow;
    } catch (error) {
      throw DriveRosterSourceException('sheet_timeline_load_failed:$error');
    } finally {
      client.close();
    }
  }

  @override
  Future<DriveRosterSource?> loadLastImported() async => _lastImported;

  @override
  Future<void> loadSource(
    DriveRosterSource source, {
    required SheetReadMode mode,
  }) async {
    if (!auth.signedIn) {
      throw const DriveRosterSourceException('google_sign_in_required');
    }
    final client = await auth.authorizedClient();
    try {
      await sheets.SheetsApi(
        client,
      ).spreadsheets.get(source.id, includeGridData: false);
      _lastImported = source;
    } finally {
      client.close();
    }
  }

  DateTime _rosterMonth(String name, DateTime fallback) {
    final match = RegExp(
      r'(20\d{2})\D{0,3}(0?[1-9]|1[0-2])|'
      r'(0?[1-9]|1[0-2])\D{0,3}(20\d{2})',
    ).firstMatch(name);
    if (match == null) return DateTime(fallback.year, fallback.month);
    final year = int.parse(match.group(1) ?? match.group(4)!);
    final month = int.parse(match.group(2) ?? match.group(3)!);
    return DateTime(year, month);
  }
}
