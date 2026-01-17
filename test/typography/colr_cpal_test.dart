import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:dart_graphics/src/typography/io/byte_order_swapping_reader.dart';
import 'package:dart_graphics/src/typography/openfont/tables/colr.dart';
import 'package:dart_graphics/src/typography/openfont/tables/cpal.dart';

void main() {
  group('COLR', () {
    test('reads color layers table v0', () {
      final builder = BytesBuilder();

      // COLR header
      builder.add([0x00, 0x00]); // version: 0
      builder.add([0x00, 0x02]); // numBaseGlyphRecords: 2
      builder.add([0x00, 0x00, 0x00, 0x0E]); // baseGlyphRecordsOffset: 14
      builder.add([0x00, 0x00, 0x00, 0x1A]); // layerRecordsOffset: 26
      builder.add([0x00, 0x04]); // numLayerRecords: 4

      // BaseGlyphRecords at offset 14 (2 records * 6 bytes = 12 bytes)
      // Record 0: glyph 10, layer index 0, layer count 2
      builder.add([0x00, 0x0A]); // glyphID: 10
      builder.add([0x00, 0x00]); // firstLayerIndex: 0
      builder.add([0x00, 0x02]); // numLayers: 2

      // Record 1: glyph 20, layer index 2, layer count 2
      builder.add([0x00, 0x14]); // glyphID: 20
      builder.add([0x00, 0x02]); // firstLayerIndex: 2
      builder.add([0x00, 0x02]); // numLayers: 2

      // LayerRecords at offset 26 (4 records * 4 bytes = 16 bytes)
      // Layer 0: glyph 100, palette index 0
      builder.add([0x00, 0x64]); // glyphID: 100
      builder.add([0x00, 0x00]); // paletteIndex: 0

      // Layer 1: glyph 101, palette index 1
      builder.add([0x00, 0x65]); // glyphID: 101
      builder.add([0x00, 0x01]); // paletteIndex: 1

      // Layer 2: glyph 102, palette index 2
      builder.add([0x00, 0x66]); // glyphID: 102
      builder.add([0x00, 0x02]); // paletteIndex: 2

      // Layer 3: glyph 103, palette index 0
      builder.add([0x00, 0x67]); // glyphID: 103
      builder.add([0x00, 0x00]); // paletteIndex: 0

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final colr = COLR();
      colr.readContentFrom(reader);

      // Check layer indices for glyphs
      expect(colr.layerIndices[10], equals(0));
      expect(colr.layerCounts[10], equals(2));

      expect(colr.layerIndices[20], equals(2));
      expect(colr.layerCounts[20], equals(2));

      // Check layer data
      expect(colr.glyphLayers.length, equals(4));
      expect(colr.glyphLayers[0], equals(100));
      expect(colr.glyphLayers[1], equals(101));
      expect(colr.glyphLayers[2], equals(102));
      expect(colr.glyphLayers[3], equals(103));

      expect(colr.glyphPalettes[0], equals(0));
      expect(colr.glyphPalettes[1], equals(1));
      expect(colr.glyphPalettes[2], equals(2));
      expect(colr.glyphPalettes[3], equals(0));
    });

    test('handles empty COLR table', () {
      final builder = BytesBuilder();

      // COLR header with no glyphs
      builder.add([0x00, 0x00]); // version: 0
      builder.add([0x00, 0x00]); // numBaseGlyphRecords: 0
      builder.add([0x00, 0x00, 0x00, 0x0E]); // baseGlyphRecordsOffset: 14
      builder.add([0x00, 0x00, 0x00, 0x0E]); // layerRecordsOffset: 14
      builder.add([0x00, 0x00]); // numLayerRecords: 0

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final colr = COLR();
      colr.readContentFrom(reader);

      expect(colr.layerIndices, isEmpty);
      expect(colr.layerCounts, isEmpty);
      expect(colr.glyphLayers, isEmpty);
      expect(colr.glyphPalettes, isEmpty);
    });

    test('reads single glyph with multiple layers', () {
      final builder = BytesBuilder();

      // COLR header
      builder.add([0x00, 0x00]); // version: 0
      builder.add([0x00, 0x01]); // numBaseGlyphRecords: 1
      builder.add([0x00, 0x00, 0x00, 0x0E]); // baseGlyphRecordsOffset: 14
      builder.add([0x00, 0x00, 0x00, 0x14]); // layerRecordsOffset: 20
      builder.add([0x00, 0x05]); // numLayerRecords: 5

      // BaseGlyphRecord: glyph 42, layer index 0, layer count 5
      builder.add([0x00, 0x2A]); // glyphID: 42
      builder.add([0x00, 0x00]); // firstLayerIndex: 0
      builder.add([0x00, 0x05]); // numLayers: 5

      // 5 LayerRecords (skin, eyes, mouth, hair, outline)
      builder.add([0x00, 0xC8]); // glyphID: 200 (skin)
      builder.add([0x00, 0x00]); // paletteIndex: 0 (skin color)

      builder.add([0x00, 0xC9]); // glyphID: 201 (eyes)
      builder.add([0x00, 0x01]); // paletteIndex: 1 (eye color)

      builder.add([0x00, 0xCA]); // glyphID: 202 (mouth)
      builder.add([0x00, 0x02]); // paletteIndex: 2 (mouth color)

      builder.add([0x00, 0xCB]); // glyphID: 203 (hair)
      builder.add([0x00, 0x03]); // paletteIndex: 3 (hair color)

      builder.add([0x00, 0xCC]); // glyphID: 204 (outline)
      builder.add([0x00, 0x04]); // paletteIndex: 4 (outline color)

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final colr = COLR();
      colr.readContentFrom(reader);

      expect(colr.layerIndices[42], equals(0));
      expect(colr.layerCounts[42], equals(5));
      expect(colr.glyphLayers.length, equals(5));
      expect(colr.glyphLayers, equals([200, 201, 202, 203, 204]));
      expect(colr.glyphPalettes, equals([0, 1, 2, 3, 4]));
    });
  });

  group('CPAL', () {
    test('reads color palette table', () {
      final builder = BytesBuilder();

      // CPAL header
      builder.add([0x00, 0x00]); // version: 0
      builder.add([0x00, 0x04]); // numPaletteEntries: 4 colors per palette
      builder.add([0x00, 0x02]); // numPalettes: 2
      builder.add([0x00, 0x08]); // numColorRecords: 8 (2 palettes * 4 colors)
      builder.add([0x00, 0x00, 0x00, 0x10]); // colorRecordsArrayOffset: 16

      // Palette indices (2 palettes)
      builder.add([0x00, 0x00]); // palette 0 starts at color index 0
      builder.add([0x00, 0x04]); // palette 1 starts at color index 4

      // Color records (8 colors in BGRA format)
      // Palette 0:
      builder.add([0xFF, 0x00, 0x00, 0xFF]); // Color 0: Blue (B=255, G=0, R=0, A=255)
      builder.add([0x00, 0xFF, 0x00, 0xFF]); // Color 1: Green (B=0, G=255, R=0, A=255)
      builder.add([0x00, 0x00, 0xFF, 0xFF]); // Color 2: Red (B=0, G=0, R=255, A=255)
      builder.add([0xFF, 0xFF, 0xFF, 0xFF]); // Color 3: White (B=255, G=255, R=255, A=255)

      // Palette 1 (dark theme):
      builder.add([0x80, 0x00, 0x00, 0xFF]); // Color 4: Dark Blue
      builder.add([0x00, 0x80, 0x00, 0xFF]); // Color 5: Dark Green
      builder.add([0x00, 0x00, 0x80, 0xFF]); // Color 6: Dark Red
      builder.add([0x00, 0x00, 0x00, 0xFF]); // Color 7: Black

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final cpal = CPAL();
      cpal.readContentFrom(reader);

      expect(cpal.palettes.length, equals(2));
      expect(cpal.palettes[0], equals(0));
      expect(cpal.palettes[1], equals(4));
      expect(cpal.colorCount, equals(8));

      // Check colors (returned as RGBA)
      // Color 0: Blue
      expect(cpal.getColor(0), equals([0, 0, 255, 255])); // R, G, B, A

      // Color 1: Green
      expect(cpal.getColor(1), equals([0, 255, 0, 255]));

      // Color 2: Red
      expect(cpal.getColor(2), equals([255, 0, 0, 255]));

      // Color 3: White
      expect(cpal.getColor(3), equals([255, 255, 255, 255]));
    });

    test('reads single palette', () {
      final builder = BytesBuilder();

      // CPAL header
      builder.add([0x00, 0x00]); // version: 0
      builder.add([0x00, 0x03]); // numPaletteEntries: 3
      builder.add([0x00, 0x01]); // numPalettes: 1
      builder.add([0x00, 0x03]); // numColorRecords: 3
      builder.add([0x00, 0x00, 0x00, 0x0E]); // colorRecordsArrayOffset: 14

      // Palette indices
      builder.add([0x00, 0x00]); // palette 0 starts at color index 0

      // Color records (BGRA)
      builder.add([0x00, 0x00, 0x00, 0xFF]); // Black
      builder.add([0x80, 0x80, 0x80, 0xFF]); // Gray
      builder.add([0xFF, 0xFF, 0xFF, 0xFF]); // White

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final cpal = CPAL();
      cpal.readContentFrom(reader);

      expect(cpal.palettes.length, equals(1));
      expect(cpal.colorCount, equals(3));

      // Black
      expect(cpal.getColor(0), equals([0, 0, 0, 255]));

      // Gray
      expect(cpal.getColor(1), equals([128, 128, 128, 255]));

      // White
      expect(cpal.getColor(2), equals([255, 255, 255, 255]));
    });

    test('reads colors with transparency', () {
      final builder = BytesBuilder();

      // CPAL header
      builder.add([0x00, 0x00]); // version: 0
      builder.add([0x00, 0x02]); // numPaletteEntries: 2
      builder.add([0x00, 0x01]); // numPalettes: 1
      builder.add([0x00, 0x02]); // numColorRecords: 2
      builder.add([0x00, 0x00, 0x00, 0x0E]); // colorRecordsArrayOffset: 14

      // Palette indices
      builder.add([0x00, 0x00]); // palette 0 starts at color index 0

      // Color records with alpha (BGRA)
      builder.add([0xFF, 0x00, 0x00, 0x80]); // Semi-transparent blue (alpha=128)
      builder.add([0x00, 0x00, 0xFF, 0x40]); // Quarter-transparent red (alpha=64)

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final cpal = CPAL();
      cpal.readContentFrom(reader);

      // Check colors with transparency (R, G, B, A)
      expect(cpal.getColor(0), equals([0, 0, 255, 128])); // Semi-transparent blue
      expect(cpal.getColor(1), equals([255, 0, 0, 64])); // Quarter-transparent red
    });
  });

  group('COLR + CPAL Integration', () {
    test('maps glyph layers to palette colors', () {
      // Create COLR table
      final colrBuilder = BytesBuilder();

      colrBuilder.add([0x00, 0x00]); // version: 0
      colrBuilder.add([0x00, 0x01]); // numBaseGlyphRecords: 1
      colrBuilder.add([0x00, 0x00, 0x00, 0x0E]); // baseGlyphRecordsOffset: 14
      colrBuilder.add([0x00, 0x00, 0x00, 0x14]); // layerRecordsOffset: 20
      colrBuilder.add([0x00, 0x02]); // numLayerRecords: 2

      // BaseGlyphRecord: emoji glyph 128512 (would be scaled to glyph ID)
      colrBuilder.add([0x01, 0x00]); // glyphID: 256
      colrBuilder.add([0x00, 0x00]); // firstLayerIndex: 0
      colrBuilder.add([0x00, 0x02]); // numLayers: 2

      // LayerRecords
      colrBuilder.add([0x01, 0x01]); // layer 0: glyphID 257 (face)
      colrBuilder.add([0x00, 0x00]); // paletteIndex: 0 (yellow)

      colrBuilder.add([0x01, 0x02]); // layer 1: glyphID 258 (eyes/mouth)
      colrBuilder.add([0x00, 0x01]); // paletteIndex: 1 (black)

      final colrData = colrBuilder.toBytes();
      final colrReader = ByteOrderSwappingBinaryReader(colrData);
      final colr = COLR();
      colr.readContentFrom(colrReader);

      // Create CPAL table
      final cpalBuilder = BytesBuilder();

      cpalBuilder.add([0x00, 0x00]); // version: 0
      cpalBuilder.add([0x00, 0x02]); // numPaletteEntries: 2
      cpalBuilder.add([0x00, 0x01]); // numPalettes: 1
      cpalBuilder.add([0x00, 0x02]); // numColorRecords: 2
      cpalBuilder.add([0x00, 0x00, 0x00, 0x0E]); // colorRecordsArrayOffset: 14

      cpalBuilder.add([0x00, 0x00]); // palette 0 starts at 0

      // Colors (BGRA)
      cpalBuilder.add([0x00, 0xD4, 0xFF, 0xFF]); // Yellow (B=0, G=212, R=255, A=255)
      cpalBuilder.add([0x00, 0x00, 0x00, 0xFF]); // Black

      final cpalData = cpalBuilder.toBytes();
      final cpalReader = ByteOrderSwappingBinaryReader(cpalData);
      final cpal = CPAL();
      cpal.readContentFrom(cpalReader);

      // Verify integration: glyph 256 has 2 layers
      final layerIndex = colr.layerIndices[256]!;
      final layerCount = colr.layerCounts[256]!;

      expect(layerCount, equals(2));

      // Get layer colors
      for (int i = 0; i < layerCount; i++) {
        final paletteIndex = colr.glyphPalettes[layerIndex + i];
        final color = cpal.getColor(paletteIndex);

        if (i == 0) {
          // First layer: yellow face
          expect(color, equals([255, 212, 0, 255])); // R, G, B, A
        } else {
          // Second layer: black eyes/mouth
          expect(color, equals([0, 0, 0, 255]));
        }
      }
    });
  });
}
