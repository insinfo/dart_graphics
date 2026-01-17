import 'dart:io';
import 'package:dart_graphics/src/dart_graphics/graphics2D.dart';
import 'package:dart_graphics/src/dart_graphics/image/image_buffer.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';
import 'package:dart_graphics/src/typography/openfont/open_font_reader.dart';
import 'package:test/test.dart';

void main() {
  const variableDir = 'resources/fonts/Satoshi_Complete/Fonts/TTF';
  const otfDir = 'resources/fonts/Satoshi_Complete/Fonts/OTF';
  const webDir = 'resources/fonts/Satoshi_Complete/Fonts/WEB/fonts';

  final regularOtfPath = '$otfDir/Satoshi-Regular.otf';
  final woffPath = '$webDir/Satoshi-Regular.woff';
  final woff2Path = '$webDir/Satoshi-Regular.woff2';
  final variablePath = '$variableDir/Satoshi-Variable.ttf';

  group('Satoshi font containers', () {
    test('OTF face loads glyph data correctly', () {
      final data = File(regularOtfPath).readAsBytesSync();
      final typeface = OpenFontReader().read(data);

      expect(typeface, isNotNull, reason: 'Expected a valid typeface from OTF');
      expect(typeface!.name, contains('Satoshi'));
      expect(typeface.glyphCount, greaterThan(150));
      expect(typeface.unitsPerEm, inInclusiveRange(500, 4096));

      final glyphIndex = typeface.getGlyphIndex('A'.codeUnitAt(0));
      expect(glyphIndex, greaterThan(0));
        final glyph = typeface.getGlyph(glyphIndex);
        final hasOutline = (glyph.glyphPoints != null && glyph.glyphPoints!.isNotEmpty) ||
          glyph.cffGlyphData != null;
        expect(hasOutline, isTrue,
          reason: 'Glyph data should be populated for regular Latin letters');
    });

    test('WOFF face loads glyph data correctly', () {
      final data = File(woffPath).readAsBytesSync();
      final typeface = OpenFontReader().read(data);

      expect(typeface, isNotNull, reason: 'Expected a valid typeface from WOFF');
      expect(typeface!.glyphCount, greaterThan(150));
      expect(typeface.cmapTable, isNotNull);
      expect(typeface.postTable, isNotNull);
    });

    test('WOFF2 face loads glyph data correctly', () {
      final data = File(woff2Path).readAsBytesSync();
      final typeface = OpenFontReader().read(data);

      expect(typeface, isNotNull, reason: 'Expected a valid typeface from WOFF2');
      expect(typeface!.glyphCount, greaterThan(150));
      expect(typeface.cmapTable, isNotNull);
    });

    test('Variable TTF face integrates with rasterizer pipeline', () {
      final data = File(variablePath).readAsBytesSync();
      final typeface = OpenFontReader().read(data);

      expect(typeface, isNotNull, reason: 'Expected a valid typeface from TTF');
      expect(typeface!.cmapTable, isNotNull, reason: 'Unicode map required for layout');

      final buffer = ImageBuffer(320, 160);
      final graphics = buffer.newGraphics2D() as BasicGraphics2D;
      graphics.clear(Color.white);

      graphics.drawText('DartGraphics Raster', typeface, 72, Color.black, x: 24, y: 16);

      final pixels = buffer.getBuffer();
      var nonWhite = 0;
      for (var i = 0; i < pixels.length; i += 4) {
        final r = pixels[i];
        final g = pixels[i + 1];
        final b = pixels[i + 2];
        final a = pixels[i + 3];
        if (!(r == 255 && g == 255 && b == 255 && a == 255)) {
          nonWhite++;
        }
      }

      expect(nonWhite, greaterThan(6000),
          reason: 'Rendered glyphs should affect thousands of pixels');
    });
  });
}
