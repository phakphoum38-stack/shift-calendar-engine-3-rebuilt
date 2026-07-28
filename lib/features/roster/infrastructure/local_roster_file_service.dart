import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:xml/xml.dart';

import '../domain/drive_roster_source.dart';

abstract interface class LocalRosterFilePicker {
  Future<({String name, Uint8List bytes})?> pick();
}

class DeviceRosterFilePicker implements LocalRosterFilePicker {
  const DeviceRosterFilePicker();

  @override
  Future<({String name, Uint8List bytes})?> pick() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['csv', 'tsv', 'xlsx'],
      withData: true,
      allowMultiple: false,
    );
    final file = result?.files.single;
    final bytes = file?.bytes;
    if (file == null || bytes == null) return null;
    return (name: file.name, bytes: bytes);
  }
}

class LocalRosterFileService {
  const LocalRosterFileService({this.picker = const DeviceRosterFilePicker()});

  final LocalRosterFilePicker picker;

  Future<LocalRosterAttachment?> pickAndRead() async {
    final picked = await picker.pick();
    if (picked == null) return null;
    final extension = picked.name.split('.').last.toLowerCase();
    final rows = switch (extension) {
      'csv' => _delimited(picked.bytes, ','),
      'tsv' => _delimited(picked.bytes, '\t'),
      'xlsx' => _xlsx(picked.bytes),
      _ => throw const FormatException('Unsupported roster file type.'),
    };
    return LocalRosterAttachment(
      name: picked.name,
      size: picked.bytes.length,
      sha256: sha256.convert(picked.bytes).toString(),
      rows: rows,
    );
  }

  RosterSourceComparison compare(
    LocalRosterAttachment local,
    SheetTimelineData remote,
  ) {
    final sharedRows = local.rows.length < remote.rows.length
        ? local.rows.length
        : remote.rows.length;
    var matching = 0;
    var different = 0;
    for (var row = 0; row < sharedRows; row++) {
      final maxColumns = local.rows[row].length > remote.rows[row].length
          ? local.rows[row].length
          : remote.rows[row].length;
      for (var column = 0; column < maxColumns; column++) {
        final left = column < local.rows[row].length
            ? local.rows[row][column].trim()
            : '';
        final right = column < remote.rows[row].length
            ? remote.rows[row][column].trim()
            : '';
        if (left == right) {
          matching++;
        } else {
          different++;
        }
      }
    }
    return RosterSourceComparison(
      matchingCells: matching,
      differentCells: different,
      localOnlyRows: local.rows.length > sharedRows
          ? local.rows.length - sharedRows
          : 0,
      remoteOnlyRows: remote.rows.length > sharedRows
          ? remote.rows.length - sharedRows
          : 0,
    );
  }

  List<List<String>> _delimited(Uint8List bytes, String delimiter) {
    final source = utf8.decode(bytes, allowMalformed: true);
    final rows = <List<String>>[];
    var row = <String>[];
    var field = StringBuffer();
    var quoted = false;
    for (var index = 0; index < source.length; index++) {
      final character = source[index];
      if (character == '"') {
        if (quoted && index + 1 < source.length && source[index + 1] == '"') {
          field.write('"');
          index++;
        } else {
          quoted = !quoted;
        }
      } else if (!quoted && character == delimiter) {
        row.add(field.toString());
        field = StringBuffer();
      } else if (!quoted && (character == '\n' || character == '\r')) {
        if (character == '\r' &&
            index + 1 < source.length &&
            source[index + 1] == '\n') {
          index++;
        }
        row.add(field.toString());
        field = StringBuffer();
        if (row.any((value) => value.isNotEmpty)) rows.add(row);
        row = <String>[];
      } else {
        field.write(character);
      }
    }
    row.add(field.toString());
    if (row.any((value) => value.isNotEmpty)) rows.add(row);
    return rows;
  }

  List<List<String>> _xlsx(Uint8List bytes) {
    final archive = ZipDecoder().decodeBytes(bytes);
    XmlDocument xml(String path) {
      final file = archive.findFile(path);
      if (file == null) throw FormatException('Missing XLSX entry: $path');
      return XmlDocument.parse(utf8.decode(file.content as List<int>));
    }

    final sharedStringsFile = archive.findFile('xl/sharedStrings.xml');
    final sharedStrings = sharedStringsFile == null
        ? const <String>[]
        : [
            for (final item in XmlDocument.parse(
              utf8.decode(sharedStringsFile.content as List<int>),
            ).findAllElements('si'))
              item.findAllElements('t').map((value) => value.innerText).join(),
          ];
    final workbook = xml('xl/workbook.xml');
    final firstSheet = workbook.findAllElements('sheet').firstOrNull;
    if (firstSheet == null) {
      throw const FormatException('The XLSX workbook has no worksheets.');
    }
    final relationshipId = firstSheet.attributes
        .where((value) => value.name.local == 'id')
        .firstOrNull
        ?.value;
    final relationships = xml('xl/_rels/workbook.xml.rels');
    final relationship = relationships
        .findAllElements('Relationship')
        .where((value) => value.getAttribute('Id') == relationshipId)
        .firstOrNull;
    var target =
        relationship?.getAttribute('Target') ?? 'worksheets/sheet1.xml';
    if (target.startsWith('/')) {
      target = target.substring(1);
    } else if (!target.startsWith('xl/')) {
      target = 'xl/$target';
    }
    final worksheet = xml(target);
    final result = <List<String>>[];
    for (final rowElement in worksheet.findAllElements('row')) {
      final rowIndex =
          int.tryParse(rowElement.getAttribute('r') ?? '') ?? result.length + 1;
      while (result.length < rowIndex) {
        result.add(<String>[]);
      }
      final row = result[rowIndex - 1];
      for (final cell in rowElement.findElements('c')) {
        final reference = cell.getAttribute('r') ?? '';
        final columnIndex = _columnIndex(reference);
        while (row.length <= columnIndex) {
          row.add('');
        }
        final type = cell.getAttribute('t');
        final raw = cell.findElements('v').firstOrNull?.innerText ?? '';
        if (type == 's') {
          final sharedIndex = int.tryParse(raw);
          row[columnIndex] =
              sharedIndex != null &&
                  sharedIndex >= 0 &&
                  sharedIndex < sharedStrings.length
              ? sharedStrings[sharedIndex]
              : raw;
        } else if (type == 'inlineStr') {
          row[columnIndex] = cell
              .findAllElements('t')
              .map((value) => value.innerText)
              .join();
        } else {
          row[columnIndex] = raw;
        }
      }
    }
    while (result.isNotEmpty && result.last.every((value) => value.isEmpty)) {
      result.removeLast();
    }
    return result;
  }

  int _columnIndex(String reference) {
    var value = 0;
    for (final unit in reference.codeUnits) {
      if (unit < 65 || unit > 90) break;
      value = value * 26 + unit - 64;
    }
    return value == 0 ? 0 : value - 1;
  }
}
