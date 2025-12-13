import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:agg/src/typography/io/byte_order_swapping_reader.dart';
import 'package:agg/src/typography/openfont/tables/variations/mvar.dart';

void main() {
  group('MVar', () {
    test('reads metrics variations table header', () {
      final builder = BytesBuilder();

      // MVAR header (12 bytes)
      builder.add([0x00, 0x01]); // majorVersion: 1
      builder.add([0x00, 0x00]); // minorVersion: 0
      builder.add([0x00, 0x00]); // reserved: 0
      builder.add([0x00, 0x08]); // valueRecordSize: 8
      builder.add([0x00, 0x00]); // valueRecordCount: 0
      builder.add([0x00, 0x00]); // itemVariationStoreOffset: 0

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final mvar = MVar();
      mvar.readContentFrom(reader);

      expect(mvar.valueRecords, isNotNull);
      expect(mvar.valueRecords!.length, equals(0));
      expect(mvar.itemVariationStore, isNull);
    });

    test('reads MVAR with value records', () {
      final builder = BytesBuilder();

      // MVAR header (12 bytes)
      builder.add([0x00, 0x01]); // majorVersion: 1
      builder.add([0x00, 0x00]); // minorVersion: 0
      builder.add([0x00, 0x00]); // reserved: 0
      builder.add([0x00, 0x08]); // valueRecordSize: 8 bytes
      builder.add([0x00, 0x02]); // valueRecordCount: 2
      builder.add([0x00, 0x1C]); // itemVariationStoreOffset: 28 (12 header + 16 records)

      // ValueRecord 0 (8 bytes): "hasc" - horizontal ascender
      builder.add([0x68, 0x61, 0x73, 0x63]); // valueTag: 'hasc'
      builder.add([0x00, 0x00]); // deltaSetOuterIndex: 0
      builder.add([0x00, 0x00]); // deltaSetInnerIndex: 0

      // ValueRecord 1 (8 bytes): "hdsc" - horizontal descender
      builder.add([0x68, 0x64, 0x73, 0x63]); // valueTag: 'hdsc'
      builder.add([0x00, 0x00]); // deltaSetOuterIndex: 0
      builder.add([0x00, 0x01]); // deltaSetInnerIndex: 1

      // ItemVariationStore at offset 28
      builder.add([0x00, 0x01]); // format: 1
      builder.add([0x00, 0x00, 0x00, 0x0C]); // variationRegionListOffset: 12
      builder.add([0x00, 0x01]); // itemVariationDataCount: 1
      builder.add([0x00, 0x00, 0x00, 0x16]); // itemVariationDataOffsets[0]: 22

      // VariationRegionList (10 bytes)
      builder.add([0x00, 0x01]); // axisCount: 1
      builder.add([0x00, 0x01]); // regionCount: 1

      // VariationRegion (6 bytes)
      builder.add([0x00, 0x00]); // startCoord: 0.0
      builder.add([0x40, 0x00]); // peakCoord: 1.0
      builder.add([0x40, 0x00]); // endCoord: 1.0

      // ItemVariationData
      builder.add([0x00, 0x02]); // itemCount: 2
      builder.add([0x00, 0x01]); // shortDeltaCount: 1
      builder.add([0x00, 0x01]); // regionIndexCount: 1
      builder.add([0x00, 0x00]); // regionIndices[0]: 0

      // Deltas
      builder.add([0x00, 0x14]); // delta[0]: 20 (for hasc)
      builder.add([0xFF, 0xEC]); // delta[1]: -20 (for hdsc)

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final mvar = MVar();
      mvar.readContentFrom(reader);

      expect(mvar.valueRecords, isNotNull);
      expect(mvar.valueRecords!.length, equals(2));

      // Check first value record (hasc)
      expect(mvar.valueRecords![0].translatedTag, equals('hasc'));
      expect(mvar.valueRecords![0].deltaSetOuterIndex, equals(0));
      expect(mvar.valueRecords![0].deltaSetInnerIndex, equals(0));

      // Check second value record (hdsc)
      expect(mvar.valueRecords![1].translatedTag, equals('hdsc'));
      expect(mvar.valueRecords![1].deltaSetOuterIndex, equals(0));
      expect(mvar.valueRecords![1].deltaSetInnerIndex, equals(1));

      // Check ItemVariationStore
      expect(mvar.itemVariationStore, isNotNull);
      final deltas0 = mvar.itemVariationStore!.itemVariationData![0].getDeltaSet(0);
      expect(deltas0, equals([20]));
      final deltas1 = mvar.itemVariationStore!.itemVariationData![0].getDeltaSet(1);
      expect(deltas1, equals([-20]));
    });

    test('reads multiple value record tags', () {
      final builder = BytesBuilder();

      // MVAR header (12 bytes)
      builder.add([0x00, 0x01]); // majorVersion: 1
      builder.add([0x00, 0x00]); // minorVersion: 0
      builder.add([0x00, 0x00]); // reserved: 0
      builder.add([0x00, 0x08]); // valueRecordSize: 8 bytes
      builder.add([0x00, 0x04]); // valueRecordCount: 4
      builder.add([0x00, 0x00]); // itemVariationStoreOffset: 0 (no IVS)

      // ValueRecord 0: "cpht" - cap height
      builder.add([0x63, 0x70, 0x68, 0x74]); // valueTag: 'cpht'
      builder.add([0x00, 0x00]); // deltaSetOuterIndex: 0
      builder.add([0x00, 0x00]); // deltaSetInnerIndex: 0

      // ValueRecord 1: "sbxo" - subscript x offset
      builder.add([0x73, 0x62, 0x78, 0x6F]); // valueTag: 'sbxo'
      builder.add([0x00, 0x01]); // deltaSetOuterIndex: 1
      builder.add([0x00, 0x02]); // deltaSetInnerIndex: 2

      // ValueRecord 2: "xhgt" - x height
      builder.add([0x78, 0x68, 0x67, 0x74]); // valueTag: 'xhgt'
      builder.add([0x00, 0x02]); // deltaSetOuterIndex: 2
      builder.add([0x00, 0x03]); // deltaSetInnerIndex: 3

      // ValueRecord 3: "undo" - underline offset
      builder.add([0x75, 0x6E, 0x64, 0x6F]); // valueTag: 'undo'
      builder.add([0x00, 0x03]); // deltaSetOuterIndex: 3
      builder.add([0x00, 0x04]); // deltaSetInnerIndex: 4

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final mvar = MVar();
      mvar.readContentFrom(reader);

      expect(mvar.valueRecords!.length, equals(4));

      expect(mvar.valueRecords![0].translatedTag, equals('cpht'));
      expect(mvar.valueRecords![1].translatedTag, equals('sbxo'));
      expect(mvar.valueRecords![2].translatedTag, equals('xhgt'));
      expect(mvar.valueRecords![3].translatedTag, equals('undo'));

      expect(mvar.valueRecords![1].deltaSetOuterIndex, equals(1));
      expect(mvar.valueRecords![1].deltaSetInnerIndex, equals(2));
    });
  });

  group('ValueRecord', () {
    test('toString returns formatted string', () {
      // 'wght' = 0x77676874
      final record = ValueRecord(0x77676874, 1, 2);
      expect(record.toString(), equals('wght, outer:1, inner:2'));
    });
  });
}
