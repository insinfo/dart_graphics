import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:agg/src/typography/io/byte_order_swapping_reader.dart';
import 'package:agg/src/typography/openfont/tables/hdmx.dart';
import 'package:agg/src/typography/openfont/tables/vdmx.dart';
import 'package:agg/src/typography/openfont/tables/ltsh.dart';

void main() {
  group('HorizontalDeviceMetrics (hdmx)', () {
    test('reads header correctly', () {
      final bytes = ByteData(8);
      int offset = 0;

      bytes.setUint16(offset, 0, Endian.big); // version
      offset += 2;
      bytes.setInt16(offset, 2, Endian.big); // numRecords
      offset += 2;
      bytes.setInt32(offset, 8, Endian.big); // sizeDeviceRecord

      final reader = ByteOrderSwappingBinaryReader(bytes.buffer.asUint8List());
      final hdmx = HorizontalDeviceMetrics();
      hdmx.readContentFrom(reader);

      expect(hdmx.version, 0);
      expect(hdmx.numRecords, 2);
      expect(hdmx.sizeDeviceRecord, 8);
      expect(hdmx.name, 'hdmx');
    });

    test('reads full table with glyph count', () {
      // Table with 2 records, 4 glyphs each
      // Header: 8 bytes
      // Each record: pixelSize(1) + maxWidth(1) + widths(4) + padding(2) = 8 bytes
      final bytes = ByteData(8 + 2 * 8);
      int offset = 0;

      // Header
      bytes.setUint16(offset, 0, Endian.big);
      offset += 2;
      bytes.setInt16(offset, 2, Endian.big);
      offset += 2;
      bytes.setInt32(offset, 8, Endian.big);
      offset += 4;

      // Record 1: 12 ppem
      bytes.setUint8(offset++, 12); // pixelSize
      bytes.setUint8(offset++, 10); // maxWidth
      bytes.setUint8(offset++, 5);  // width[0]
      bytes.setUint8(offset++, 6);  // width[1]
      bytes.setUint8(offset++, 7);  // width[2]
      bytes.setUint8(offset++, 8);  // width[3]
      bytes.setUint8(offset++, 0);  // padding
      bytes.setUint8(offset++, 0);  // padding

      // Record 2: 24 ppem
      bytes.setUint8(offset++, 24); // pixelSize
      bytes.setUint8(offset++, 20); // maxWidth
      bytes.setUint8(offset++, 10); // width[0]
      bytes.setUint8(offset++, 12); // width[1]
      bytes.setUint8(offset++, 14); // width[2]
      bytes.setUint8(offset++, 16); // width[3]

      final reader = ByteOrderSwappingBinaryReader(bytes.buffer.asUint8List());
      final hdmx = HorizontalDeviceMetrics();
      hdmx.readContentWithGlyphCount(reader, 4);

      expect(hdmx.records.length, 2);
      expect(hdmx.records[0].pixelSize, 12);
      expect(hdmx.records[0].maxWidth, 10);
      expect(hdmx.records[0].widths, [5, 6, 7, 8]);
      expect(hdmx.records[1].pixelSize, 24);
      expect(hdmx.records[1].widths, [10, 12, 14, 16]);
    });

    test('getWidth returns correct width', () {
      final hdmx = HorizontalDeviceMetrics();
      hdmx.records = [
        DeviceRecord()
          ..pixelSize = 12
          ..maxWidth = 10
          ..widths = [5, 6, 7, 8],
        DeviceRecord()
          ..pixelSize = 24
          ..maxWidth = 20
          ..widths = [10, 12, 14, 16],
      ];

      expect(hdmx.getWidth(12, 0), 5);
      expect(hdmx.getWidth(12, 3), 8);
      expect(hdmx.getWidth(24, 1), 12);
      expect(hdmx.getWidth(16, 0), isNull); // No record for 16 ppem
      expect(hdmx.getWidth(12, 10), isNull); // Glyph out of range
    });
  });

  group('VerticalDeviceMetrics (VDMX)', () {
    test('reads header and ratio ranges', () {
      // Minimal VDMX table
      final bytes = ByteData(6 + 4 + 2 + 10); // header + 1 ratio + 1 offset + group
      int offset = 0;

      // Header
      bytes.setUint16(offset, 0, Endian.big); // version
      offset += 2;
      bytes.setUint16(offset, 1, Endian.big); // numRecs
      offset += 2;
      bytes.setUint16(offset, 1, Endian.big); // numRatios
      offset += 2;

      // RatioRange
      bytes.setUint8(offset++, 0);  // bCharSet
      bytes.setUint8(offset++, 1);  // xRatio
      bytes.setUint8(offset++, 1);  // yStartRatio
      bytes.setUint8(offset++, 1);  // yEndRatio

      // Offset to group (at byte 12)
      bytes.setUint16(offset, 12, Endian.big);
      offset += 2;

      // VDMX Group
      bytes.setUint16(offset, 1, Endian.big); // recs
      offset += 2;
      bytes.setUint8(offset++, 8);  // startsz
      bytes.setUint8(offset++, 72); // endsz

      // vTable record
      bytes.setUint16(offset, 12, Endian.big); // yPelHeight
      offset += 2;
      bytes.setInt16(offset, 10, Endian.big); // yMax
      offset += 2;
      bytes.setInt16(offset, -2, Endian.big); // yMin

      final reader = ByteOrderSwappingBinaryReader(bytes.buffer.asUint8List());
      final vdmx = VerticalDeviceMetrics();
      vdmx.readContentFrom(reader);

      expect(vdmx.version, 0);
      expect(vdmx.numRecs, 1);
      expect(vdmx.numRatios, 1);
      expect(vdmx.name, 'VDMX');
      expect(vdmx.ratioRanges.length, 1);
      expect(vdmx.ratioRanges[0].xRatio, 1);
    });

    test('VdmxGroup reads records correctly', () {
      final bytes = ByteData(10);
      int offset = 0;

      bytes.setUint16(offset, 1, Endian.big); // recs
      offset += 2;
      bytes.setUint8(offset++, 8);  // startsz
      bytes.setUint8(offset++, 72); // endsz

      // vTable record
      bytes.setUint16(offset, 12, Endian.big); // yPelHeight
      offset += 2;
      bytes.setInt16(offset, 10, Endian.big); // yMax
      offset += 2;
      bytes.setInt16(offset, -2, Endian.big); // yMin

      final reader = ByteOrderSwappingBinaryReader(bytes.buffer.asUint8List());
      final group = VdmxGroup.readFrom(reader);

      expect(group.recs, 1);
      expect(group.startsz, 8);
      expect(group.endsz, 72);
      expect(group.records.length, 1);
      expect(group.records[0].yPelHeight, 12);
      expect(group.records[0].yMax, 10);
      expect(group.records[0].yMin, -2);
    });

    test('VdmxGroup.findRecord returns correct record', () {
      final group = VdmxGroup()
        ..recs = 2
        ..records = [
          VdmxRecord(yPelHeight: 12, yMax: 10, yMin: -2),
          VdmxRecord(yPelHeight: 24, yMax: 20, yMin: -4),
        ];

      expect(group.findRecord(12)?.yMax, 10);
      expect(group.findRecord(24)?.yMax, 20);
      expect(group.findRecord(16), isNull);
    });
  });

  group('LinearThreshold (LTSH)', () {
    test('reads table correctly', () {
      final bytes = ByteData(4 + 5); // header + 5 glyphs
      int offset = 0;

      bytes.setUint16(offset, 0, Endian.big); // version
      offset += 2;
      bytes.setUint16(offset, 5, Endian.big); // numGlyphs
      offset += 2;

      // yPels values
      bytes.setUint8(offset++, 12);
      bytes.setUint8(offset++, 16);
      bytes.setUint8(offset++, 20);
      bytes.setUint8(offset++, 8);
      bytes.setUint8(offset++, 0);  // 0 = always linear

      final reader = ByteOrderSwappingBinaryReader(bytes.buffer.asUint8List());
      final ltsh = LinearThreshold();
      ltsh.readContentFrom(reader);

      expect(ltsh.version, 0);
      expect(ltsh.numGlyphs, 5);
      expect(ltsh.yPels.length, 5);
      expect(ltsh.name, 'LTSH');
    });

    test('getThreshold returns correct values', () {
      final ltsh = LinearThreshold()
        ..numGlyphs = 3
        ..yPels = [12, 16, 20];

      expect(ltsh.getThreshold(0), 12);
      expect(ltsh.getThreshold(1), 16);
      expect(ltsh.getThreshold(2), 20);
      expect(ltsh.getThreshold(-1), isNull);
      expect(ltsh.getThreshold(10), isNull);
    });

    test('isLinearAt checks threshold correctly', () {
      final ltsh = LinearThreshold()
        ..numGlyphs = 2
        ..yPels = [12, 20];

      // Glyph 0 is linear at 12 ppem and above
      expect(ltsh.isLinearAt(0, 10), isFalse);
      expect(ltsh.isLinearAt(0, 12), isTrue);
      expect(ltsh.isLinearAt(0, 24), isTrue);

      // Glyph 1 is linear at 20 ppem and above
      expect(ltsh.isLinearAt(1, 16), isFalse);
      expect(ltsh.isLinearAt(1, 20), isTrue);
      expect(ltsh.isLinearAt(1, 24), isTrue);

      // Invalid glyph
      expect(ltsh.isLinearAt(10, 20), isFalse);
    });
  });
}
