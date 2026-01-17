import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:dart_graphics/src/typography/io/byte_order_swapping_reader.dart';
import 'package:dart_graphics/src/typography/openfont/tables/variations/hvar.dart';
import 'package:dart_graphics/src/typography/openfont/tables/variations/vvar.dart';

void main() {
  group('HVar', () {
    test('reads horizontal metrics variations table header', () {
      final builder = BytesBuilder();

      // HVAR header (20 bytes)
      builder.add([0x00, 0x01]); // majorVersion: 1
      builder.add([0x00, 0x00]); // minorVersion: 0
      builder.add([0x00, 0x00, 0x00, 0x14]); // itemVariationStoreOffset: 20
      builder.add([0x00, 0x00, 0x00, 0x00]); // advanceWidthMappingOffset: NULL
      builder.add([0x00, 0x00, 0x00, 0x00]); // lsbMappingOffset: NULL
      builder.add([0x00, 0x00, 0x00, 0x00]); // rsbMappingOffset: NULL

      // ItemVariationStore at offset 20
      builder.add([0x00, 0x01]); // format: 1
      builder.add([0x00, 0x00, 0x00, 0x08]); // variationRegionListOffset: 8
      builder.add([0x00, 0x00]); // itemVariationDataCount: 0

      // VariationRegionList
      builder.add([0x00, 0x01]); // axisCount: 1
      builder.add([0x00, 0x00]); // regionCount: 0

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final hvar = HVar();
      hvar.readContentFrom(reader);

      expect(hvar.majorVersion, equals(1));
      expect(hvar.minorVersion, equals(0));
      expect(hvar.itemVariationStoreOffset, equals(20));
      expect(hvar.advanceWidthMappingOffset, equals(0));
      expect(hvar.itemVariationStore, isNotNull);
    });

    test('reads HVAR with item variation store data', () {
      final builder = BytesBuilder();

      // HVAR header (20 bytes)
      builder.add([0x00, 0x01]); // majorVersion: 1
      builder.add([0x00, 0x00]); // minorVersion: 0
      builder.add([0x00, 0x00, 0x00, 0x14]); // itemVariationStoreOffset: 20
      builder.add([0x00, 0x00, 0x00, 0x00]); // advanceWidthMappingOffset: NULL
      builder.add([0x00, 0x00, 0x00, 0x00]); // lsbMappingOffset: NULL
      builder.add([0x00, 0x00, 0x00, 0x00]); // rsbMappingOffset: NULL

      // ItemVariationStore at offset 20 (header 12 bytes)
      builder.add([0x00, 0x01]); // format: 1
      builder.add([0x00, 0x00, 0x00, 0x0C]); // variationRegionListOffset: 12
      builder.add([0x00, 0x01]); // itemVariationDataCount: 1
      builder.add([0x00, 0x00, 0x00, 0x16]); // itemVariationDataOffsets[0]: 22

      // VariationRegionList at IVS+12 = offset 32 (10 bytes)
      builder.add([0x00, 0x01]); // axisCount: 1
      builder.add([0x00, 0x01]); // regionCount: 1

      // VariationRegion (6 bytes)
      builder.add([0x00, 0x00]); // startCoord: 0.0
      builder.add([0x40, 0x00]); // peakCoord: 1.0
      builder.add([0x40, 0x00]); // endCoord: 1.0

      // ItemVariationData at IVS+22 = offset 42
      builder.add([0x00, 0x01]); // itemCount: 1
      builder.add([0x00, 0x01]); // shortDeltaCount: 1
      builder.add([0x00, 0x01]); // regionIndexCount: 1
      builder.add([0x00, 0x00]); // regionIndices[0]: 0

      // Delta set: [50]
      builder.add([0x00, 0x32]); // 50 as int16

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final hvar = HVar();
      hvar.readContentFrom(reader);

      expect(hvar.itemVariationStore, isNotNull);
      expect(hvar.itemVariationStore!.variationRegionList!.axisCount, equals(1));
      expect(hvar.itemVariationStore!.variationRegionList!.regionCount, equals(1));
      expect(hvar.itemVariationStore!.itemVariationData!.length, equals(1));

      final deltas = hvar.itemVariationStore!.itemVariationData![0].getDeltaSet(0);
      expect(deltas, equals([50]));
    });

    test('handles HVAR with no item variation store', () {
      final builder = BytesBuilder();

      // HVAR header with offset 0 (no ItemVariationStore)
      builder.add([0x00, 0x01]); // majorVersion: 1
      builder.add([0x00, 0x00]); // minorVersion: 0
      builder.add([0x00, 0x00, 0x00, 0x00]); // itemVariationStoreOffset: 0
      builder.add([0x00, 0x00, 0x00, 0x00]); // advanceWidthMappingOffset
      builder.add([0x00, 0x00, 0x00, 0x00]); // lsbMappingOffset
      builder.add([0x00, 0x00, 0x00, 0x00]); // rsbMappingOffset

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final hvar = HVar();
      hvar.readContentFrom(reader);

      expect(hvar.majorVersion, equals(1));
      expect(hvar.itemVariationStoreOffset, equals(0));
      expect(hvar.itemVariationStore, isNull);
    });
  });

  group('VVar', () {
    test('reads vertical metrics variations table header', () {
      final builder = BytesBuilder();

      // VVAR header (24 bytes)
      builder.add([0x00, 0x01]); // majorVersion: 1
      builder.add([0x00, 0x00]); // minorVersion: 0
      builder.add([0x00, 0x00, 0x00, 0x18]); // itemVariationStoreOffset: 24
      builder.add([0x00, 0x00, 0x00, 0x00]); // advanceHeightMappingOffset: NULL
      builder.add([0x00, 0x00, 0x00, 0x00]); // tsbMappingOffset: NULL
      builder.add([0x00, 0x00, 0x00, 0x00]); // bsbMappingOffset: NULL
      builder.add([0x00, 0x00, 0x00, 0x00]); // vorgMappingOffset: NULL

      // ItemVariationStore at offset 24
      builder.add([0x00, 0x01]); // format: 1
      builder.add([0x00, 0x00, 0x00, 0x08]); // variationRegionListOffset: 8
      builder.add([0x00, 0x00]); // itemVariationDataCount: 0

      // VariationRegionList
      builder.add([0x00, 0x01]); // axisCount: 1
      builder.add([0x00, 0x00]); // regionCount: 0

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final vvar = VVar();
      vvar.readContentFrom(reader);

      expect(vvar.majorVersion, equals(1));
      expect(vvar.minorVersion, equals(0));
      expect(vvar.itemVariationStoreOffset, equals(24));
      expect(vvar.advanceHeightMappingOffset, equals(0));
      expect(vvar.tsbMappingOffset, equals(0));
      expect(vvar.bsbMappingOffset, equals(0));
      expect(vvar.vorgMappingOffset, equals(0));
      expect(vvar.itemVariationStore, isNotNull);
    });

    test('reads VVAR with item variation store data', () {
      final builder = BytesBuilder();

      // VVAR header (24 bytes)
      builder.add([0x00, 0x01]); // majorVersion: 1
      builder.add([0x00, 0x00]); // minorVersion: 0
      builder.add([0x00, 0x00, 0x00, 0x18]); // itemVariationStoreOffset: 24
      builder.add([0x00, 0x00, 0x00, 0x00]); // advanceHeightMappingOffset
      builder.add([0x00, 0x00, 0x00, 0x00]); // tsbMappingOffset
      builder.add([0x00, 0x00, 0x00, 0x00]); // bsbMappingOffset
      builder.add([0x00, 0x00, 0x00, 0x00]); // vorgMappingOffset

      // ItemVariationStore at offset 24 (header 12 bytes)
      builder.add([0x00, 0x01]); // format: 1
      builder.add([0x00, 0x00, 0x00, 0x0C]); // variationRegionListOffset: 12
      builder.add([0x00, 0x01]); // itemVariationDataCount: 1
      builder.add([0x00, 0x00, 0x00, 0x16]); // itemVariationDataOffsets[0]: 22

      // VariationRegionList at IVS+12 (10 bytes)
      builder.add([0x00, 0x01]); // axisCount: 1
      builder.add([0x00, 0x01]); // regionCount: 1

      // VariationRegion (6 bytes)
      builder.add([0xC0, 0x00]); // startCoord: -1.0
      builder.add([0x40, 0x00]); // peakCoord: 1.0
      builder.add([0x40, 0x00]); // endCoord: 1.0

      // ItemVariationData at IVS+22
      builder.add([0x00, 0x02]); // itemCount: 2
      builder.add([0x00, 0x01]); // shortDeltaCount: 1
      builder.add([0x00, 0x01]); // regionIndexCount: 1
      builder.add([0x00, 0x00]); // regionIndices[0]: 0

      // Delta sets
      builder.add([0x00, 0x64]); // delta[0]: 100
      builder.add([0xFF, 0x9C]); // delta[1]: -100

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final vvar = VVar();
      vvar.readContentFrom(reader);

      expect(vvar.itemVariationStore, isNotNull);
      expect(vvar.itemVariationStore!.itemVariationData!.length, equals(1));

      final data0 = vvar.itemVariationStore!.itemVariationData![0];
      expect(data0.getDeltaSet(0), equals([100]));
      expect(data0.getDeltaSet(1), equals([-100]));
    });

    test('handles VVAR with no item variation store', () {
      final builder = BytesBuilder();

      // VVAR header with offset 0
      builder.add([0x00, 0x01]); // majorVersion: 1
      builder.add([0x00, 0x00]); // minorVersion: 0
      builder.add([0x00, 0x00, 0x00, 0x00]); // itemVariationStoreOffset: 0
      builder.add([0x00, 0x00, 0x00, 0x00]); // advanceHeightMappingOffset
      builder.add([0x00, 0x00, 0x00, 0x00]); // tsbMappingOffset
      builder.add([0x00, 0x00, 0x00, 0x00]); // bsbMappingOffset
      builder.add([0x00, 0x00, 0x00, 0x00]); // vorgMappingOffset

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final vvar = VVar();
      vvar.readContentFrom(reader);

      expect(vvar.majorVersion, equals(1));
      expect(vvar.itemVariationStoreOffset, equals(0));
      expect(vvar.itemVariationStore, isNull);
    });
  });
}
