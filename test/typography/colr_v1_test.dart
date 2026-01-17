import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:dart_graphics/src/typography/io/byte_order_swapping_reader.dart';
import 'package:dart_graphics/src/typography/openfont/tables/colr.dart';

void main() {
  group('COLR v1', () {
    test('reads v1 header with BaseGlyphList', () {
      final builder = BytesBuilder();

      // COLR v1 header (34 bytes total)
      builder.add([0x00, 0x01]); // version: 1
      builder.add([0x00, 0x00]); // numBaseGlyphRecords: 0 (v0 data)
      builder.add([0x00, 0x00, 0x00, 0x00]); // baseGlyphRecordsOffset: 0
      builder.add([0x00, 0x00, 0x00, 0x00]); // layerRecordsOffset: 0
      builder.add([0x00, 0x00]); // numLayerRecords: 0

      // v1 extension offsets (20 bytes)
      builder.add([0x00, 0x00, 0x00, 0x22]); // baseGlyphListOffset: 34
      builder.add([0x00, 0x00, 0x00, 0x00]); // layerListOffset: 0
      builder.add([0x00, 0x00, 0x00, 0x00]); // clipListOffset: 0
      builder.add([0x00, 0x00, 0x00, 0x00]); // varIdxMapOffset: 0
      builder.add([0x00, 0x00, 0x00, 0x00]); // itemVariationStoreOffset: 0

      // BaseGlyphList at offset 34
      builder.add([0x00, 0x00, 0x00, 0x01]); // numBaseGlyphPaintRecords: 1

      // BaseGlyphPaintRecord: glyph 100, paint offset 10
      builder.add([0x00, 0x64]); // glyphId: 100
      builder.add([0x00, 0x00, 0x00, 0x0A]); // paintOffset: 10

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final colr = COLR();
      colr.readContentFrom(reader);

      expect(colr.version, equals(1));
      expect(colr.baseGlyphList, isNotNull);
      expect(colr.baseGlyphList!.numBaseGlyphPaintRecords, equals(1));
      expect(colr.baseGlyphList!.records[0].glyphId, equals(100));
      expect(colr.baseGlyphList!.records[0].paintOffset, equals(10));
    });

    test('reads v1 with LayerList', () {
      final builder = BytesBuilder();

      // COLR v1 header
      builder.add([0x00, 0x01]); // version: 1
      builder.add([0x00, 0x00]); // numBaseGlyphRecords: 0
      builder.add([0x00, 0x00, 0x00, 0x00]); // baseGlyphRecordsOffset: 0
      builder.add([0x00, 0x00, 0x00, 0x00]); // layerRecordsOffset: 0
      builder.add([0x00, 0x00]); // numLayerRecords: 0

      // v1 extension offsets
      builder.add([0x00, 0x00, 0x00, 0x00]); // baseGlyphListOffset: 0
      builder.add([0x00, 0x00, 0x00, 0x22]); // layerListOffset: 34
      builder.add([0x00, 0x00, 0x00, 0x00]); // clipListOffset: 0
      builder.add([0x00, 0x00, 0x00, 0x00]); // varIdxMapOffset: 0
      builder.add([0x00, 0x00, 0x00, 0x00]); // itemVariationStoreOffset: 0

      // LayerList at offset 34
      builder.add([0x00, 0x00, 0x00, 0x03]); // numLayers: 3
      builder.add([0x00, 0x00, 0x00, 0x10]); // paintOffset[0]: 16
      builder.add([0x00, 0x00, 0x00, 0x20]); // paintOffset[1]: 32
      builder.add([0x00, 0x00, 0x00, 0x30]); // paintOffset[2]: 48

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final colr = COLR();
      colr.readContentFrom(reader);

      expect(colr.version, equals(1));
      expect(colr.layerList, isNotNull);
      expect(colr.layerList!.numLayers, equals(3));
      expect(colr.layerList!.paintOffsets, equals([16, 32, 48]));
    });

    test('reads v1 with ClipList', () {
      final builder = BytesBuilder();

      // COLR v1 header
      builder.add([0x00, 0x01]); // version: 1
      builder.add([0x00, 0x00]); // numBaseGlyphRecords: 0
      builder.add([0x00, 0x00, 0x00, 0x00]); // baseGlyphRecordsOffset: 0
      builder.add([0x00, 0x00, 0x00, 0x00]); // layerRecordsOffset: 0
      builder.add([0x00, 0x00]); // numLayerRecords: 0

      // v1 extension offsets
      builder.add([0x00, 0x00, 0x00, 0x00]); // baseGlyphListOffset: 0
      builder.add([0x00, 0x00, 0x00, 0x00]); // layerListOffset: 0
      builder.add([0x00, 0x00, 0x00, 0x22]); // clipListOffset: 34
      builder.add([0x00, 0x00, 0x00, 0x00]); // varIdxMapOffset: 0
      builder.add([0x00, 0x00, 0x00, 0x00]); // itemVariationStoreOffset: 0

      // ClipList at offset 34
      builder.add([0x01]); // format: 1
      builder.add([0x00, 0x00, 0x00, 0x02]); // numClips: 2

      // ClipRecord 0: glyphs 10-20, clipBox at offset 100
      builder.add([0x00, 0x0A]); // startGlyphId: 10
      builder.add([0x00, 0x14]); // endGlyphId: 20
      builder.add([0x00, 0x00, 0x64]); // clipBoxOffset: 100 (24-bit)

      // ClipRecord 1: glyphs 30-40, clipBox at offset 200
      builder.add([0x00, 0x1E]); // startGlyphId: 30
      builder.add([0x00, 0x28]); // endGlyphId: 40
      builder.add([0x00, 0x00, 0xC8]); // clipBoxOffset: 200 (24-bit)

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final colr = COLR();
      colr.readContentFrom(reader);

      expect(colr.version, equals(1));
      expect(colr.clipList, isNotNull);
      expect(colr.clipList!.format, equals(1));
      expect(colr.clipList!.numClips, equals(2));

      expect(colr.clipList!.clips[0].startGlyphId, equals(10));
      expect(colr.clipList!.clips[0].endGlyphId, equals(20));
      expect(colr.clipList!.clips[0].clipBoxOffset, equals(100));

      expect(colr.clipList!.clips[1].startGlyphId, equals(30));
      expect(colr.clipList!.clips[1].endGlyphId, equals(40));
      expect(colr.clipList!.clips[1].clipBoxOffset, equals(200));
    });

    test('reads v1 with mixed v0 and v1 data', () {
      final builder = BytesBuilder();

      // COLR v1 header with v0 data
      builder.add([0x00, 0x01]); // version: 1
      builder.add([0x00, 0x01]); // numBaseGlyphRecords: 1
      builder.add([0x00, 0x00, 0x00, 0x22]); // baseGlyphRecordsOffset: 34
      builder.add([0x00, 0x00, 0x00, 0x28]); // layerRecordsOffset: 40
      builder.add([0x00, 0x02]); // numLayerRecords: 2

      // v1 extension offsets
      builder.add([0x00, 0x00, 0x00, 0x30]); // baseGlyphListOffset: 48
      builder.add([0x00, 0x00, 0x00, 0x00]); // layerListOffset: 0
      builder.add([0x00, 0x00, 0x00, 0x00]); // clipListOffset: 0
      builder.add([0x00, 0x00, 0x00, 0x00]); // varIdxMapOffset: 0
      builder.add([0x00, 0x00, 0x00, 0x00]); // itemVariationStoreOffset: 0

      // v0 BaseGlyphRecord at offset 34
      builder.add([0x00, 0x05]); // glyphID: 5
      builder.add([0x00, 0x00]); // firstLayerIndex: 0
      builder.add([0x00, 0x02]); // numLayers: 2

      // v0 LayerRecords at offset 40
      builder.add([0x00, 0x0A]); // glyphID: 10
      builder.add([0x00, 0x00]); // paletteIndex: 0
      builder.add([0x00, 0x0B]); // glyphID: 11
      builder.add([0x00, 0x01]); // paletteIndex: 1

      // v1 BaseGlyphList at offset 48
      builder.add([0x00, 0x00, 0x00, 0x01]); // numBaseGlyphPaintRecords: 1
      builder.add([0x00, 0xC8]); // glyphId: 200
      builder.add([0x00, 0x00, 0x00, 0x14]); // paintOffset: 20

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final colr = COLR();
      colr.readContentFrom(reader);

      expect(colr.version, equals(1));

      // Check v0 data
      expect(colr.hasV0Layers(5), isTrue);
      expect(colr.layerIndices[5], equals(0));
      expect(colr.layerCounts[5], equals(2));
      expect(colr.glyphLayers, equals([10, 11]));
      expect(colr.glyphPalettes, equals([0, 1]));

      // Check v1 data
      expect(colr.hasV1Paint(200), isTrue);
      expect(colr.baseGlyphList!.records[0].glyphId, equals(200));
    });
  });

  group('PaintFormat enum', () {
    test('has correct values', () {
      expect(PaintFormat.colrLayers.value, equals(1));
      expect(PaintFormat.solidPalette.value, equals(2));
      expect(PaintFormat.solidPaletteVar.value, equals(3));
      expect(PaintFormat.linearGradient.value, equals(4));
      expect(PaintFormat.radialGradient.value, equals(6));
      expect(PaintFormat.sweepGradient.value, equals(8));
      expect(PaintFormat.glyph.value, equals(10));
      expect(PaintFormat.colrGlyph.value, equals(11));
      expect(PaintFormat.composite.value, equals(32));
    });

    test('fromValue returns correct format', () {
      expect(PaintFormat.fromValue(1), equals(PaintFormat.colrLayers));
      expect(PaintFormat.fromValue(2), equals(PaintFormat.solidPalette));
      expect(PaintFormat.fromValue(32), equals(PaintFormat.composite));
      expect(PaintFormat.fromValue(99), isNull);
    });
  });

  group('CompositeMode enum', () {
    test('has correct values', () {
      expect(CompositeMode.clear.value, equals(0));
      expect(CompositeMode.srcOver.value, equals(3));
      expect(CompositeMode.multiply.value, equals(23));
      expect(CompositeMode.hslLuminosity.value, equals(27));
    });

    test('fromValue returns correct mode', () {
      expect(CompositeMode.fromValue(0), equals(CompositeMode.clear));
      expect(CompositeMode.fromValue(3), equals(CompositeMode.srcOver));
      expect(CompositeMode.fromValue(99), isNull);
    });
  });

  group('ExtendMode enum', () {
    test('has correct values', () {
      expect(ExtendMode.pad.value, equals(0));
      expect(ExtendMode.repeat.value, equals(1));
      expect(ExtendMode.reflect.value, equals(2));
    });

    test('fromValue returns correct mode', () {
      expect(ExtendMode.fromValue(0), equals(ExtendMode.pad));
      expect(ExtendMode.fromValue(1), equals(ExtendMode.repeat));
      expect(ExtendMode.fromValue(2), equals(ExtendMode.reflect));
      expect(ExtendMode.fromValue(99), equals(ExtendMode.pad)); // default
    });
  });

  group('DeltaSetIndexMap', () {
    test('reads format 0 with 16-bit map count', () {
      final builder = BytesBuilder();

      builder.add([0x00]); // format: 0
      builder.add([0x21]); // entryFormat: innerBits=2, outerBits=3
      builder.add([0x00, 0x03]); // mapCount: 3

      // Entry size = ceil((2 + 3) / 8) = 1 byte
      builder.add([0x05]); // entry[0]: outer=0, inner=5
      builder.add([0x09]); // entry[1]: outer=2, inner=1
      builder.add([0x0C]); // entry[2]: outer=3, inner=0

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final map = DeltaSetIndexMap();
      map.readFrom(reader);

      expect(map.format, equals(0));
      expect(map.mapCount, equals(3));

      // innerBits = 2, so innerMask = 0x03
      final (outer0, inner0) = map.getIndices(0);
      expect(outer0, equals(1)); // 0x05 >> 2 = 1
      expect(inner0, equals(1)); // 0x05 & 0x03 = 1

      final (outer1, inner1) = map.getIndices(1);
      expect(outer1, equals(2)); // 0x09 >> 2 = 2
      expect(inner1, equals(1)); // 0x09 & 0x03 = 1

      final (outer2, inner2) = map.getIndices(2);
      expect(outer2, equals(3)); // 0x0C >> 2 = 3
      expect(inner2, equals(0)); // 0x0C & 0x03 = 0
    });

    test('getIndices returns (0, 0) for out of range index', () {
      final map = DeltaSetIndexMap();
      map.mapCount = 2;
      map.mapData = [0x10, 0x20];
      map.entryFormat = 0x10; // innerBits=1, outerBits=2

      final (outer, inner) = map.getIndices(5); // out of range
      expect(outer, equals(0));
      expect(inner, equals(0));
    });
  });

  group('ClipBox', () {
    test('reads format 1 (non-variable)', () {
      final builder = BytesBuilder();

      builder.add([0x01]); // format: 1
      builder.add([0xFF, 0xF6]); // xMin: -10
      builder.add([0x00, 0x14]); // yMin: 20
      builder.add([0x01, 0xF4]); // xMax: 500
      builder.add([0x02, 0xBC]); // yMax: 700

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final clipBox = ClipBox();
      clipBox.readFrom(reader);

      expect(clipBox.format, equals(1));
      expect(clipBox.xMin, equals(-10));
      expect(clipBox.yMin, equals(20));
      expect(clipBox.xMax, equals(500));
      expect(clipBox.yMax, equals(700));
    });

    test('reads format 2 (variable)', () {
      final builder = BytesBuilder();

      builder.add([0x02]); // format: 2
      builder.add([0x00, 0x00]); // xMin: 0
      builder.add([0x00, 0x00]); // yMin: 0
      builder.add([0x03, 0xE8]); // xMax: 1000
      builder.add([0x03, 0xE8]); // yMax: 1000
      builder.add([0x00, 0x00, 0x00, 0x05]); // varIndexBase: 5

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final clipBox = ClipBox();
      clipBox.readFrom(reader);

      expect(clipBox.format, equals(2));
      expect(clipBox.xMin, equals(0));
      expect(clipBox.xMax, equals(1000));
      expect(clipBox.yMax, equals(1000));
      expect(clipBox.varIndexBase, equals(5));
    });
  });
}
