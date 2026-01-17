

import 'dart:io';
import 'package:test/test.dart';
import 'package:dart_graphics/src/agg/agg_gamma_functions.dart';
import 'package:dart_graphics/src/agg/image/png_encoder.dart';
import 'package:dart_graphics/src/agg/transform/affine.dart';
import 'package:dart_graphics/src/agg/vertex_source/apply_transform.dart';
import 'package:dart_graphics/src/agg/vertex_source/glyph_vertex_source.dart';
import 'package:dart_graphics/src/agg/primitives/color.dart';
import 'package:dart_graphics/src/agg/scanline_renderer.dart';
import 'package:dart_graphics/src/agg/scanline_packed8.dart';
import 'package:dart_graphics/src/agg/scanline_rasterizer.dart';
import 'package:dart_graphics/src/agg/image/image_buffer.dart';
import 'package:dart_graphics/src/typography/text_layout/glyph_layout.dart';
import 'package:dart_graphics/src/typography/openfont/open_font_reader.dart';
import 'package:dart_graphics/src/typography/openfont/typeface.dart';
import 'package:dart_graphics/src/agg/vertex_source/stroke.dart';

void main() {
  late Typeface sansFace;
  late Typeface serifFace;
  late Typeface monoFace;

  setUpAll(() async {
    // Load fonts
    sansFace = await _loadFont('resources/fonts/liberation-fonts-ttf-1.07.0/LiberationSans-Regular.ttf');
    serifFace = await _loadFont('resources/fonts/liberation-fonts-ttf-1.07.0/LiberationSerif-Regular.ttf');
    monoFace = await _loadFont('resources/fonts/liberation-fonts-ttf-1.07.0/LiberationMono-Regular.ttf');

    Directory('test/tmp').createSync(recursive: true);
  });

  group('Text Rendering', () {
    test('Hello World basic rendering', () {
      final buffer = ImageBuffer(400, 100);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      _renderText(buffer, sansFace, 'Hello World!', 20, 60, 48, Color(0, 0, 0, 255));

      PngEncoder.saveImage(buffer, 'test/tmp/text_hello_world.png');
      expect(File('test/tmp/text_hello_world.png').existsSync(), isTrue);

      // Verify some pixels are drawn (not all white)
      bool hasDrawing = false;
      for (var y = 0; y < buffer.height && !hasDrawing; y++) {
        for (var x = 0; x < buffer.width && !hasDrawing; x++) {
          final c = buffer.getPixel(x, y);
          if (c.red < 255 || c.green < 255 || c.blue < 255) {
            hasDrawing = true;
          }
        }
      }
      expect(hasDrawing, isTrue, reason: 'Text should be rendered');
    });

    test('Multiple lines rendering', () {
      final buffer = ImageBuffer(500, 200);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      _renderText(buffer, sansFace, 'Line 1: Sans-Serif', 20, 50, 32, Color(0, 0, 0, 255));
      _renderText(buffer, serifFace, 'Line 2: Serif', 20, 100, 32, Color(128, 0, 0, 255));
      _renderText(buffer, monoFace, 'Line 3: Monospace', 20, 150, 32, Color(0, 0, 128, 255));

      PngEncoder.saveImage(buffer, 'test/tmp/text_multiline.png');
      expect(File('test/tmp/text_multiline.png').existsSync(), isTrue);
    });

    test('Font sizes rendering', () {
      final buffer = ImageBuffer(600, 250);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      _renderText(buffer, sansFace, 'Size 12', 20, 30, 12, Color(0, 0, 0, 255));
      _renderText(buffer, sansFace, 'Size 18', 20, 60, 18, Color(0, 0, 0, 255));
      _renderText(buffer, sansFace, 'Size 24', 20, 100, 24, Color(0, 0, 0, 255));
      _renderText(buffer, sansFace, 'Size 36', 20, 150, 36, Color(0, 0, 0, 255));
      _renderText(buffer, sansFace, 'Size 48', 20, 210, 48, Color(0, 0, 0, 255));

      PngEncoder.saveImage(buffer, 'test/tmp/text_sizes.png');
      expect(File('test/tmp/text_sizes.png').existsSync(), isTrue);
    });

    test('Special characters and numbers', () {
      final buffer = ImageBuffer(500, 150);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      _renderText(buffer, sansFace, '0123456789', 20, 40, 32, Color(0, 0, 0, 255));
      _renderText(buffer, sansFace, '!@#\$%^&*()_+-=', 20, 80, 24, Color(0, 0, 128, 255));
      _renderText(buffer, sansFace, '<>[]{}|\\;:\'",./?', 20, 120, 24, Color(128, 0, 0, 255));

      PngEncoder.saveImage(buffer, 'test/tmp/text_special_chars.png');
      expect(File('test/tmp/text_special_chars.png').existsSync(), isTrue);
    });

    test('Outlined text rendering', () {
      final buffer = ImageBuffer(400, 100);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      _renderTextOutlined(buffer, sansFace, 'Outlined', 20, 70, 48, Color(0, 0, 255, 255), 2.0);

      PngEncoder.saveImage(buffer, 'test/tmp/text_outlined.png');
      expect(File('test/tmp/text_outlined.png').existsSync(), isTrue);
    });

    test('Mixed text styles', () {
      final buffer = ImageBuffer(700, 300);
      _clearBuffer(buffer, Color(245, 245, 245, 255));

      // Header
      _renderText(buffer, serifFace, 'Typography Test', 20, 60, 36, Color(0, 0, 0, 255));

      // Body text
      _renderText(buffer, sansFace, 'The quick brown fox jumps over the lazy dog.', 20, 120, 18, Color(50, 50, 50, 255));
      _renderText(buffer, sansFace, 'Pack my box with five dozen liquor jugs.', 20, 150, 18, Color(50, 50, 50, 255));

      // Code sample
      _renderText(buffer, monoFace, 'void main() { print("Hello"); }', 20, 200, 14, Color(0, 100, 0, 255));

      // Footer
      _renderText(buffer, sansFace, 'AGG Typography Port - Dart', 20, 260, 12, Color(128, 128, 128, 255));

      PngEncoder.saveImage(buffer, 'test/tmp/text_mixed_styles.png');
      expect(File('test/tmp/text_mixed_styles.png').existsSync(), isTrue);
    });

    test('Transformed text (rotation)', () {
      final buffer = ImageBuffer(400, 400);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      _renderTextWithTransform(
        buffer,
        sansFace,
        'Rotated',
        200,
        200,
        32,
        Color(0, 128, 0, 255),
        rotation: 0.5, // ~30 degrees
      );

      PngEncoder.saveImage(buffer, 'test/tmp/text_rotated.png');
      expect(File('test/tmp/text_rotated.png').existsSync(), isTrue);
    });

    test('Gamma corrected text', () {
      final buffer = ImageBuffer(400, 200);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      _renderTextWithGamma(buffer, sansFace, 'Gamma 1.0', 20, 50, 24, Color(0, 0, 0, 255), 1.0);
      _renderTextWithGamma(buffer, sansFace, 'Gamma 1.5', 20, 100, 24, Color(0, 0, 0, 255), 1.5);
      _renderTextWithGamma(buffer, sansFace, 'Gamma 2.2', 20, 150, 24, Color(0, 0, 0, 255), 2.2);

      PngEncoder.saveImage(buffer, 'test/tmp/text_gamma.png');
      expect(File('test/tmp/text_gamma.png').existsSync(), isTrue);
    });

    test('Unicode text rendering', () {
      final buffer = ImageBuffer(500, 150);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      // Note: Liberation fonts may not have all Unicode glyphs
      // Test what's available
      _renderText(buffer, sansFace, 'ASCII: AaBbCc', 20, 40, 24, Color(0, 0, 0, 255));
      _renderText(buffer, sansFace, 'Accents: éàüöñ', 20, 80, 24, Color(0, 0, 128, 255));
      _renderText(buffer, sansFace, 'Symbols: © ® ™', 20, 120, 24, Color(128, 0, 0, 255));

      PngEncoder.saveImage(buffer, 'test/tmp/text_unicode.png');
      expect(File('test/tmp/text_unicode.png').existsSync(), isTrue);
    });
  });

  group('Glyph Layout', () {
    test('Layout generates correct glyph count', () {
      final layout = GlyphLayout();
      layout.typeface = sansFace;

      final text = 'Hello';
      layout.layout(text);

      final scale = sansFace.calculateScaleToPixel(24);
      final plans = layout.generateGlyphPlans(scale);

      expect(plans.count, equals(5), reason: '"Hello" should have 5 glyphs');
    });

    test('Layout handles spaces', () {
      final layout = GlyphLayout();
      layout.typeface = sansFace;

      final text = 'A B C';
      layout.layout(text);

      final scale = sansFace.calculateScaleToPixel(24);
      final plans = layout.generateGlyphPlans(scale);

      // A, space, B, space, C = 5 glyphs
      expect(plans.count, equals(5));
    });

    test('Advance widths accumulate correctly', () {
      final layout = GlyphLayout();
      layout.typeface = sansFace;

      layout.layout('ABC');

      final scale = sansFace.calculateScaleToPixel(24);
      final plans = layout.generateGlyphPlans(scale);

      expect(plans.count, equals(3));

      // Each glyph should be positioned after the previous
      expect(plans[0].x, lessThan(plans[1].x));
      expect(plans[1].x, lessThan(plans[2].x));
    });

    test('Empty string produces no glyphs', () {
      final layout = GlyphLayout();
      layout.typeface = sansFace;

      layout.layout('');

      final scale = sansFace.calculateScaleToPixel(24);
      final plans = layout.generateGlyphPlans(scale);

      expect(plans.count, equals(0));
    });
  });

  group('Typeface Properties', () {
    test('Font has valid metrics', () {
      expect(sansFace.unitsPerEm, greaterThan(0));
      expect(sansFace.ascender, greaterThan(0));
      expect(sansFace.descender, lessThan(0)); // Descender is negative
    });

    test('Scale calculation is correct', () {
      final fontSize = 24.0;
      final scale = sansFace.calculateScaleToPixel(fontSize);

      // Scale = fontSize / unitsPerEm
      final expected = fontSize / sansFace.unitsPerEm;
      expect(scale, closeTo(expected, 0.0001));
    });

    test('Glyph lookup returns valid glyphs', () {
      // Get glyph for 'A' (0x41)
      final glyphIndex = sansFace.getGlyphIndex('A'.codeUnitAt(0));
      expect(glyphIndex, greaterThan(0));

      final glyph = sansFace.getGlyph(glyphIndex);
      expect(glyph, isNotNull);
    });

    test('Missing glyph returns notdef', () {
      // Try to get a glyph for an unlikely codepoint
      final glyphIndex = sansFace.getGlyphIndex(0xFFFF);
      // Should return 0 (notdef) or a valid replacement
      expect(glyphIndex, greaterThanOrEqualTo(0));
    });
  });
}

Future<Typeface> _loadFont(String path) async {
  final file = File(path);
  if (!file.existsSync()) {
    throw Exception('Font file not found: $path');
  }

  final bytes = await file.readAsBytes();
  final reader = OpenFontReader();
  final typeface = reader.read(bytes);

  if (typeface == null) {
    throw Exception('Failed to load typeface from: $path');
  }

  return typeface;
}

void _clearBuffer(ImageBuffer buffer, Color color) {
  for (var y = 0; y < buffer.height; y++) {
    for (var x = 0; x < buffer.width; x++) {
      buffer.SetPixel(x, y, color);
    }
  }
}

void _renderText(
  ImageBuffer buffer,
  Typeface typeface,
  String text,
  double startX,
  double startY,
  double fontSize,
  Color color,
) {
  final scale = typeface.calculateScaleToPixel(fontSize);

  final layout = GlyphLayout();
  layout.typeface = typeface;
  layout.layout(text);
  final plans = layout.generateGlyphPlans(scale);

  final ras = ScanlineRasterizer();
  final sl = ScanlineCachePacked8();

  for (var i = 0; i < plans.count; i++) {
    final plan = plans[i];
    final glyph = typeface.getGlyph(plan.glyphIndex);

    final glyphSource = GlyphVertexSource(glyph);

    final mtx = Affine.identity();
    mtx.scale(scale, -scale);
    mtx.translate(startX + plan.x, startY - plan.y);

    final transSource = ApplyTransform(glyphSource, mtx);

    ras.add_path(transSource);
    ScanlineRenderer.renderSolid(ras, sl, buffer, color);
  }
}

void _renderTextOutlined(
  ImageBuffer buffer,
  Typeface typeface,
  String text,
  double startX,
  double startY,
  double fontSize,
  Color color,
  double strokeWidth,
) {
  final scale = typeface.calculateScaleToPixel(fontSize);

  final layout = GlyphLayout();
  layout.typeface = typeface;
  layout.layout(text);
  final plans = layout.generateGlyphPlans(scale);

  final ras = ScanlineRasterizer();
  final sl = ScanlineCachePacked8();

  for (var i = 0; i < plans.count; i++) {
    final plan = plans[i];
    final glyph = typeface.getGlyph(plan.glyphIndex);

    final glyphSource = GlyphVertexSource(glyph);

    final mtx = Affine.identity();
    mtx.scale(scale, -scale);
    mtx.translate(startX + plan.x, startY - plan.y);

    final transSource = ApplyTransform(glyphSource, mtx);
    final stroke = Stroke(transSource);
    stroke.width = strokeWidth;

    ras.add_path(stroke);
    ScanlineRenderer.renderSolid(ras, sl, buffer, color);
  }
}

void _renderTextWithTransform(
  ImageBuffer buffer,
  Typeface typeface,
  String text,
  double centerX,
  double centerY,
  double fontSize,
  Color color, {
  double rotation = 0.0,
  double scaleX = 1.0,
  double scaleY = 1.0,
}) {
  final scale = typeface.calculateScaleToPixel(fontSize);

  final layout = GlyphLayout();
  layout.typeface = typeface;
  layout.layout(text);
  final plans = layout.generateGlyphPlans(scale);

  // Calculate text width for centering
  double totalWidth = 0;
  if (plans.count > 0) {
    final lastPlan = plans[plans.count - 1];
    final lastGlyph = typeface.getGlyph(lastPlan.glyphIndex);
    final glyphAdvance = lastGlyph.originalAdvanceWidth ?? 0;
    totalWidth = lastPlan.x + (glyphAdvance * scale);
  }

  final ras = ScanlineRasterizer();
  final sl = ScanlineCachePacked8();

  for (var i = 0; i < plans.count; i++) {
    final plan = plans[i];
    final glyph = typeface.getGlyph(plan.glyphIndex);

    final glyphSource = GlyphVertexSource(glyph);

    final mtx = Affine.identity();
    // Scale glyph
    mtx.scale(scale * scaleX, -scale * scaleY);
    // Position relative to text origin
    mtx.translate(plan.x - totalWidth / 2, -plan.y);
    // Apply rotation around text center
    mtx.rotate(rotation);
    // Move to final position
    mtx.translate(centerX, centerY);

    final transSource = ApplyTransform(glyphSource, mtx);

    ras.add_path(transSource);
    ScanlineRenderer.renderSolid(ras, sl, buffer, color);
  }
}

void _renderTextWithGamma(
  ImageBuffer buffer,
  Typeface typeface,
  String text,
  double startX,
  double startY,
  double fontSize,
  Color color,
  double gamma,
) {
  final scale = typeface.calculateScaleToPixel(fontSize);

  final layout = GlyphLayout();
  layout.typeface = typeface;
  layout.layout(text);
  final plans = layout.generateGlyphPlans(scale);

  final ras = ScanlineRasterizer();
  ras.gamma(GammaPower(gamma));
  final sl = ScanlineCachePacked8();

  for (var i = 0; i < plans.count; i++) {
    final plan = plans[i];
    final glyph = typeface.getGlyph(plan.glyphIndex);

    final glyphSource = GlyphVertexSource(glyph);

    final mtx = Affine.identity();
    mtx.scale(scale, -scale);
    mtx.translate(startX + plan.x, startY - plan.y);

    final transSource = ApplyTransform(glyphSource, mtx);

    ras.add_path(transSource);
    ScanlineRenderer.renderSolid(ras, sl, buffer, color);
  }
}
