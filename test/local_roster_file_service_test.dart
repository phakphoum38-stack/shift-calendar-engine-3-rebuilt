import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:archive/archive.dart';
import 'package:shift_calendar_engine/features/roster/domain/drive_roster_source.dart';
import 'package:shift_calendar_engine/features/roster/infrastructure/local_roster_file_service.dart';

void main() {
  test('reads quoted CSV and computes a stable fingerprint', () async {
    final bytes = Uint8List.fromList(
      utf8.encode(
        'ผู้ยกเวร,ผู้รับเวร,เหตุผล\r\n'
        'สมชาย,สมหญิง,"ธุระ, ส่วนตัว"\r\n',
      ),
    );
    final service = LocalRosterFileService(
      picker: _Picker(name: 'original.csv', bytes: bytes),
    );

    final attachment = await service.pickAndRead();

    expect(attachment!.name, 'original.csv');
    expect(attachment.rows, hasLength(2));
    expect(attachment.rows[1][2], 'ธุระ, ส่วนตัว');
    expect(attachment.sha256, hasLength(64));
  });

  test('compares local and selected Sheet rows cell by cell', () async {
    final bytes = Uint8List.fromList(utf8.encode('name,shift\nA,D\nB,N\n'));
    final service = LocalRosterFileService(
      picker: _Picker(name: 'original.csv', bytes: bytes),
    );
    final local = (await service.pickAndRead())!;
    final source = DriveRosterSource(
      id: 'sheet',
      name: 'Roster',
      modifiedTime: DateTime(2026, 1, 2),
      rosterMonth: DateTime(2026, 1),
    );
    final remote = SheetTimelineData(
      source: source,
      sheetTitle: 'Sheet1',
      rows: const [
        ['name', 'shift'],
        ['A', 'D'],
        ['B', 'E'],
        ['C', 'N'],
      ],
    );

    final result = service.compare(local, remote);

    expect(result.matchingCells, 5);
    expect(result.differentCells, 1);
    expect(result.localOnlyRows, 0);
    expect(result.remoteOnlyRows, 1);
    expect(result.exactMatch, isFalse);
  });

  test('reads the first worksheet from XLSX', () async {
    final archive = Archive()
      ..add(
        ArchiveFile.string(
          'xl/workbook.xml',
          '<workbook xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">'
              '<sheets><sheet name="Roster" sheetId="1" r:id="rId1"/></sheets>'
              '</workbook>',
        ),
      )
      ..add(
        ArchiveFile.string(
          'xl/_rels/workbook.xml.rels',
          '<Relationships>'
              '<Relationship Id="rId1" Target="worksheets/sheet1.xml"/>'
              '</Relationships>',
        ),
      )
      ..add(
        ArchiveFile.string(
          'xl/sharedStrings.xml',
          '<sst><si><t>Name</t></si><si><t>สมชาย</t></si></sst>',
        ),
      )
      ..add(
        ArchiveFile.string(
          'xl/worksheets/sheet1.xml',
          '<worksheet><sheetData>'
              '<row r="1"><c r="A1" t="s"><v>0</v></c></row>'
              '<row r="2"><c r="A2" t="s"><v>1</v></c>'
              '<c r="B2" t="inlineStr"><is><t>N</t></is></c></row>'
              '</sheetData></worksheet>',
        ),
      );
    final bytes = ZipEncoder().encodeBytes(archive);
    final service = LocalRosterFileService(
      picker: _Picker(name: 'original.xlsx', bytes: bytes),
    );

    final attachment = await service.pickAndRead();

    expect(attachment!.rows[0][0], 'Name');
    expect(attachment.rows[1], ['สมชาย', 'N']);
  });
}

class _Picker implements LocalRosterFilePicker {
  const _Picker({required this.name, required this.bytes});

  final String name;
  final Uint8List bytes;

  @override
  Future<({Uint8List bytes, String name})?> pick() async =>
      (name: name, bytes: bytes);
}
