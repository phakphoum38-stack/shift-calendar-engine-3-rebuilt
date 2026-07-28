import 'package:flutter_test/flutter_test.dart';
import 'package:shift_calendar_engine/features/roster/application/drive_roster_source_controller.dart';
import 'package:shift_calendar_engine/features/roster/application/drive_roster_source_gateway.dart';
import 'package:shift_calendar_engine/features/roster/domain/drive_roster_source.dart';
import 'package:shift_calendar_engine/features/roster/infrastructure/google_auth_controller.dart';

void main() {
  test('loads the selected sheet with the selected read mode', () async {
    final gateway = _RecordingGateway();
    final controller = DriveRosterSourceController(
      gateway: gateway,
      auth: GoogleAuthController(),
    );

    await controller.refresh();
    controller.select(controller.recentSources.single);
    controller.selectReadMode(SheetReadMode.standard);

    expect(await controller.loadCurrentSource(), isTrue);
    expect(gateway.loadedSource, same(controller.selectedSource));
    expect(gateway.loadedMode, SheetReadMode.standard);
    expect(controller.lastImported, same(controller.selectedSource));
  });
}

class _RecordingGateway implements DriveRosterSourceGateway {
  final source = DriveRosterSource(
    id: 'sheet-1',
    name: 'Roster July',
    modifiedTime: DateTime(2026, 7, 1),
    rosterMonth: DateTime(2026, 7),
  );

  DriveRosterSource? loadedSource;
  SheetReadMode? loadedMode;

  @override
  Future<List<DriveRosterSource>> listRecentlyModified() async => [source];

  @override
  Future<DriveRosterSource?> loadLastImported() async => null;

  @override
  Future<void> loadSource(
    DriveRosterSource source, {
    required SheetReadMode mode,
  }) async {
    loadedSource = source;
    loadedMode = mode;
  }
}
