/// Metadata required to choose and display a roster source from Google Drive.
class DriveRosterSource {
  const DriveRosterSource({
    required this.id,
    required this.name,
    required this.modifiedTime,
    required this.rosterMonth,
    this.createdTime,
    this.ownerNames = const [],
  });

  final String id;
  final String name;
  final DateTime modifiedTime;
  final DateTime rosterMonth;
  final DateTime? createdTime;
  final List<String> ownerNames;
}

/// Controls how a Google Sheets roster is interpreted.
enum SheetReadMode {
  /// Uses the application's configured column mapping and shift definitions.
  configured,

  /// Reads the sheet using the standard, uncustomized roster layout.
  standard,
}

/// Current values from the first worksheet, paired with the Drive creation
/// timestamp that represents the file's first timeline.
class SheetTimelineData {
  SheetTimelineData({
    required this.source,
    required this.sheetTitle,
    required List<List<String>> rows,
  }) : rows = List.unmodifiable(
         rows.map((row) => List<String>.unmodifiable(row)),
       );

  final DriveRosterSource source;
  final String sheetTitle;
  final List<List<String>> rows;

  List<String> headersAt(int rowIndex) {
    if (rowIndex < 0 || rowIndex >= rows.length) return const [];
    return List.unmodifiable([
      for (final (index, value) in rows[rowIndex].indexed)
        value.trim().isEmpty ? 'Column ${index + 1}' : value.trim(),
    ]);
  }
}

enum ExchangeSheetField { giver, receiver, date, shift, type, reason, remark }

class ExchangeTimelineRow {
  const ExchangeTimelineRow({required this.rowNumber, required this.values});

  final int rowNumber;
  final Map<ExchangeSheetField, String> values;

  String value(ExchangeSheetField field) => values[field]?.trim() ?? '';
}

class TimelineExchangeImportResult {
  const TimelineExchangeImportResult({
    required this.created,
    required this.skipped,
  });

  final int created;
  final int skipped;
}

class LocalRosterAttachment {
  LocalRosterAttachment({
    required this.name,
    required this.size,
    required this.sha256,
    required List<List<String>> rows,
  }) : rows = List.unmodifiable(
         rows.map((row) => List<String>.unmodifiable(row)),
       );

  final String name;
  final int size;
  final String sha256;
  final List<List<String>> rows;
}

class RosterSourceComparison {
  const RosterSourceComparison({
    required this.matchingCells,
    required this.differentCells,
    required this.localOnlyRows,
    required this.remoteOnlyRows,
  });

  final int matchingCells;
  final int differentCells;
  final int localOnlyRows;
  final int remoteOnlyRows;

  bool get exactMatch =>
      differentCells == 0 && localOnlyRows == 0 && remoteOnlyRows == 0;
}

/// Keeps one deterministic source per month.
///
/// When Drive contains several files for the same month, the earliest modified
/// file is the canonical source. Results are ordered by most recently modified
/// first for the "Recently modified" section.
class DriveRosterSourceSelector {
  const DriveRosterSourceSelector();

  List<DriveRosterSource> selectMonthlySources(
    Iterable<DriveRosterSource> sources,
  ) {
    final byMonth = <({int year, int month}), DriveRosterSource>{};
    for (final source in sources) {
      final key = (
        year: source.rosterMonth.year,
        month: source.rosterMonth.month,
      );
      final current = byMonth[key];
      if (current == null ||
          source.modifiedTime.isBefore(current.modifiedTime) ||
          (source.modifiedTime.isAtSameMomentAs(current.modifiedTime) &&
              source.name.compareTo(current.name) < 0)) {
        byMonth[key] = source;
      }
    }

    return byMonth.values.toList()..sort((a, b) {
      final byModified = b.modifiedTime.compareTo(a.modifiedTime);
      return byModified != 0 ? byModified : a.name.compareTo(b.name);
    });
  }
}
