import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:dart_graphics/src/typography/io/byte_order_swapping_reader.dart';
import 'package:dart_graphics/src/typography/openfont/tables/variations/item_variation_store.dart';

void main() {
  group('ItemVariationStore', () {
    test('reads basic structure with one region and one data subtable', () {
      final builder = BytesBuilder();

      // ItemVariationStore Header (at position 0)
      // format(2) + regionListOffset(4) + dataCount(2) + dataOffsets[1](4) = 12 bytes header
      builder.add([0x00, 0x01]); // format: 1  (offset 0-1)
      builder.add([0x00, 0x00, 0x00, 0x0C]); // variationRegionListOffset: 12 (offset 2-5)
      builder.add([0x00, 0x01]); // itemVariationDataCount: 1 (offset 6-7)
      builder.add([0x00, 0x00, 0x00, 0x22]); // itemVariationDataOffsets[0]: 34 (offset 8-11)

      // VariationRegionList at offset 12
      // axisCount(2) + regionCount(2) + 1 region * 2 axes * 6 bytes = 4 + 12 = 16 bytes
      builder.add([0x00, 0x02]); // axisCount: 2 (offset 12-13)
      builder.add([0x00, 0x01]); // regionCount: 1 (offset 14-15)

      // VariationRegion (2 axes * 3 F2DOT14 each = 12 bytes) (offset 16-27)
      // Axis 0: start=-1.0, peak=1.0, end=1.0
      builder.add([0xC0, 0x00]); // startCoord: -1.0
      builder.add([0x40, 0x00]); // peakCoord: 1.0
      builder.add([0x40, 0x00]); // endCoord: 1.0

      // Axis 1: start=0.0, peak=0.5, end=1.0
      builder.add([0x00, 0x00]); // startCoord: 0.0
      builder.add([0x20, 0x00]); // peakCoord: 0.5
      builder.add([0x40, 0x00]); // endCoord: 1.0

      // Padding to reach offset 34 (current: 28, need 6 more bytes)
      builder.add([0x00, 0x00, 0x00, 0x00, 0x00, 0x00]);

      // ItemVariationData at offset 34
      // itemCount(2) + shortDeltaCount(2) + regionIndexCount(2) + indices[1](2) + deltas = 8 + deltas
      builder.add([0x00, 0x02]); // itemCount: 2 (offset 34-35)
      builder.add([0x00, 0x01]); // shortDeltaCount: 1 (offset 36-37)
      builder.add([0x00, 0x01]); // regionIndexCount: 1 (offset 38-39)
      builder.add([0x00, 0x00]); // regionIndices[0]: 0 (offset 40-41)

      // Delta set 0: [100] (int16) (offset 42-43)
      builder.add([0x00, 0x64]); // 100 as int16

      // Delta set 1: [50] (int16) (offset 44-45)
      builder.add([0x00, 0x32]); // 50 as int16

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final store = ItemVariationStore();
      store.readContent(reader);

      // Verify VariationRegionList
      expect(store.variationRegionList, isNotNull);
      expect(store.variationRegionList!.axisCount, equals(2));
      expect(store.variationRegionList!.regionCount, equals(1));
      expect(store.variationRegionList!.variationRegions!.length, equals(1));

      // Verify region axes
      final region = store.variationRegionList!.variationRegions![0];
      expect(region.regionAxes!.length, equals(2));

      // Axis 0
      expect(region.regionAxes![0].startCoord, closeTo(-1.0, 0.01));
      expect(region.regionAxes![0].peakCoord, closeTo(1.0, 0.01));
      expect(region.regionAxes![0].endCoord, closeTo(1.0, 0.01));

      // Axis 1
      expect(region.regionAxes![1].startCoord, closeTo(0.0, 0.01));
      expect(region.regionAxes![1].peakCoord, closeTo(0.5, 0.01));
      expect(region.regionAxes![1].endCoord, closeTo(1.0, 0.01));

      // Verify ItemVariationData
      expect(store.itemVariationData, isNotNull);
      expect(store.itemVariationData!.length, equals(1));

      final itemData = store.itemVariationData![0];
      expect(itemData.itemCount, equals(2));
      expect(itemData.shortDeltaCount, equals(1));
      expect(itemData.regionIndexCount, equals(1));
      expect(itemData.regionIndices, equals([0]));

      // Verify delta sets
      expect(itemData.getDeltaSet(0), equals([100]));
      expect(itemData.getDeltaSet(1), equals([50]));
    });

    test('reads mixed short and byte deltas', () {
      final builder = BytesBuilder();

      // Header (12 bytes)
      builder.add([0x00, 0x01]); // format: 1
      builder.add([0x00, 0x00, 0x00, 0x0C]); // variationRegionListOffset: 12
      builder.add([0x00, 0x01]); // itemVariationDataCount: 1
      builder.add([0x00, 0x00, 0x00, 0x16]); // itemVariationDataOffsets[0]: 22

      // VariationRegionList at offset 12 (10 bytes: 4 header + 6 region data)
      builder.add([0x00, 0x01]); // axisCount: 1
      builder.add([0x00, 0x01]); // regionCount: 1

      // VariationRegion (1 axis * 3 F2DOT14 = 6 bytes)
      builder.add([0x00, 0x00]); // startCoord: 0.0
      builder.add([0x40, 0x00]); // peakCoord: 1.0
      builder.add([0x40, 0x00]); // endCoord: 1.0

      // ItemVariationData at offset 22
      builder.add([0x00, 0x02]); // itemCount: 2
      builder.add([0x00, 0x01]); // shortDeltaCount: 1 (first region is int16)
      builder.add([0x00, 0x02]); // regionIndexCount: 2
      builder.add([0x00, 0x00]); // regionIndices[0]: 0
      builder.add([0x00, 0x00]); // regionIndices[1]: 0 (same region)

      // Delta set 0: [200, 10] - first is int16, second is int8
      builder.add([0x00, 0xC8]); // 200 as int16
      builder.add([0x0A]); // 10 as int8

      // Delta set 1: [-100, -5]
      builder.add([0xFF, 0x9C]); // -100 as int16
      builder.add([0xFB]); // -5 as int8 (signed)

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final store = ItemVariationStore();
      store.readContent(reader);

      final itemData = store.itemVariationData![0];
      expect(itemData.shortDeltaCount, equals(1));
      expect(itemData.regionIndexCount, equals(2));

      // Delta set 0
      final deltas0 = itemData.getDeltaSet(0);
      expect(deltas0[0], equals(200));
      expect(deltas0[1], equals(10));

      // Delta set 1
      final deltas1 = itemData.getDeltaSet(1);
      expect(deltas1[0], equals(-100));
      expect(deltas1[1], equals(-5));
    });

    test('handles zero item variation data count', () {
      final builder = BytesBuilder();

      // Header (8 bytes: format + offset + count, no offsets array)
      builder.add([0x00, 0x01]); // format: 1
      builder.add([0x00, 0x00, 0x00, 0x08]); // variationRegionListOffset: 8
      builder.add([0x00, 0x00]); // itemVariationDataCount: 0

      // VariationRegionList at offset 8
      builder.add([0x00, 0x01]); // axisCount: 1
      builder.add([0x00, 0x00]); // regionCount: 0

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final store = ItemVariationStore();
      store.readContent(reader);

      expect(store.variationRegionList!.regionCount, equals(0));
      expect(store.itemVariationData!.length, equals(0));
    });

    test('getDeltaSet returns empty list for invalid index', () {
      final itemData = ItemVariationData();
      itemData.deltaSets = [[1, 2], [3, 4]];

      expect(itemData.getDeltaSet(-1), isEmpty);
      expect(itemData.getDeltaSet(5), isEmpty);
      expect(itemData.getDeltaSet(0), equals([1, 2]));
      expect(itemData.getDeltaSet(1), equals([3, 4]));
    });
  });

  group('VariationRegionList', () {
    test('reads multiple regions', () {
      final builder = BytesBuilder();

      builder.add([0x00, 0x02]); // axisCount: 2
      builder.add([0x00, 0x02]); // regionCount: 2

      // Region 0
      builder.add([0xC0, 0x00]); // axis0 start: -1.0
      builder.add([0xC0, 0x00]); // axis0 peak: -1.0
      builder.add([0x00, 0x00]); // axis0 end: 0.0
      builder.add([0x00, 0x00]); // axis1 start: 0.0
      builder.add([0x00, 0x00]); // axis1 peak: 0.0
      builder.add([0x00, 0x00]); // axis1 end: 0.0

      // Region 1
      builder.add([0x00, 0x00]); // axis0 start: 0.0
      builder.add([0x40, 0x00]); // axis0 peak: 1.0
      builder.add([0x40, 0x00]); // axis0 end: 1.0
      builder.add([0x00, 0x00]); // axis1 start: 0.0
      builder.add([0x40, 0x00]); // axis1 peak: 1.0
      builder.add([0x40, 0x00]); // axis1 end: 1.0

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final regionList = VariationRegionList();
      regionList.readContent(reader);

      expect(regionList.axisCount, equals(2));
      expect(regionList.regionCount, equals(2));
      expect(regionList.variationRegions!.length, equals(2));

      // Region 0 axis 0
      expect(regionList.variationRegions![0].regionAxes![0].startCoord,
          closeTo(-1.0, 0.01));
      expect(regionList.variationRegions![0].regionAxes![0].peakCoord,
          closeTo(-1.0, 0.01));

      // Region 1 axis 1
      expect(regionList.variationRegions![1].regionAxes![1].peakCoord,
          closeTo(1.0, 0.01));
    });
  });

  group('VariationAxis', () {
    test('reads F2DOT14 coordinates correctly', () {
      final builder = BytesBuilder();

      // F2DOT14: 2 bits integer, 14 bits fraction
      // 0x4000 = 1.0, 0x2000 = 0.5, 0xC000 = -1.0, 0xE000 = -0.5, 0x0000 = 0.0

      builder.add([0xE0, 0x00]); // startCoord: -0.5
      builder.add([0x00, 0x00]); // peakCoord: 0.0
      builder.add([0x20, 0x00]); // endCoord: 0.5

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final axis = VariationAxis();
      axis.readContent(reader);

      expect(axis.startCoord, closeTo(-0.5, 0.01));
      expect(axis.peakCoord, closeTo(0.0, 0.01));
      expect(axis.endCoord, closeTo(0.5, 0.01));
    });
  });
}
