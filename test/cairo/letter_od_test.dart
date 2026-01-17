/// Teste específico para investigar renderização das letras "o" e "d"
/// O problema: em vez de círculos, está renderizando cantos quadrados (90 graus)

import 'dart:io';
import 'package:test/test.dart';
import 'package:dart_graphics/cairo.dart';
import 'package:dart_graphics/src/agg/image/image_buffer.dart';
import 'package:dart_graphics/src/agg/image/png_encoder.dart';
import 'package:dart_graphics/src/agg/primitives/color.dart';
import 'package:dart_graphics/src/agg/scanline_rasterizer.dart';
import 'package:dart_graphics/src/agg/scanline_renderer.dart';
import 'package:dart_graphics/src/agg/scanline_packed8.dart';
import 'package:dart_graphics/src/agg/transform/affine.dart';
import 'package:dart_graphics/src/agg/vertex_source/apply_transform.dart';
import 'package:dart_graphics/src/agg/vertex_source/glyph_vertex_source.dart';
import 'package:dart_graphics/src/typography/text_layout/glyph_layout.dart';
import 'package:dart_graphics/src/typography/openfont/open_font_reader.dart';
import 'package:dart_graphics/src/typography/openfont/typeface.dart';
import 'package:image/image.dart' as img;
import 'dart:math' as math;

/// Global Cairo instance
final cairo = Cairo();

void main() {
  late Typeface sansFace;

  setUpAll(() async {
    Directory('test/tmp').createSync(recursive: true);
    Directory('test/golden').createSync(recursive: true);

    // Carregar fonte
    final fontData = await File('resources/fonts/liberation-fonts-ttf-1.07.0/LiberationSans-Regular.ttf').readAsBytes();
    final reader = OpenFontReader();
    sansFace = reader.read(fontData)!;
  });

  group('Investigação Letra O e D', () {
    test('Cairo golden - letra "o"', () {
      final canvas = cairo.createCanvas(100, 100);
      canvas.clear(CairoColor.white);

      canvas.setFontSize(60);
      canvas.setColor(CairoColor.black);
      canvas.moveTo(20, 75);
      canvas.showText('o');

      canvas.saveToPng('test/golden/letter_o.png');
      canvas.dispose();

      expect(File('test/golden/letter_o.png').existsSync(), isTrue);
    });

    test('Cairo golden - letra "d"', () {
      final canvas = cairo.createCanvas(100, 100);
      canvas.clear(CairoColor.white);

      canvas.setFontSize(60);
      canvas.setColor(CairoColor.black);
      canvas.moveTo(20, 75);
      canvas.showText('d');

      canvas.saveToPng('test/golden/letter_d.png');
      canvas.dispose();

      expect(File('test/golden/letter_d.png').existsSync(), isTrue);
    });

    test('Cairo golden - "od"', () {
      final canvas = cairo.createCanvas(150, 100);
      canvas.clear(CairoColor.white);

      canvas.setFontSize(60);
      canvas.setColor(CairoColor.black);
      canvas.moveTo(10, 75);
      canvas.showText('od');

      canvas.saveToPng('test/golden/letters_od.png');
      canvas.dispose();

      expect(File('test/golden/letters_od.png').existsSync(), isTrue);
    });

    test('AGG - letra "o"', () {
      final buffer = ImageBuffer(100, 100);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      _renderText(buffer, sansFace, 'o', 20, 75, 60, Color(0, 0, 0, 255));

      PngEncoder.saveImage(buffer, 'test/tmp/letter_o.png');
      expect(File('test/tmp/letter_o.png').existsSync(), isTrue);
    });

    test('AGG - letra "d"', () {
      final buffer = ImageBuffer(100, 100);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      _renderText(buffer, sansFace, 'd', 20, 75, 60, Color(0, 0, 0, 255));

      PngEncoder.saveImage(buffer, 'test/tmp/letter_d.png');
      expect(File('test/tmp/letter_d.png').existsSync(), isTrue);
    });

    test('AGG - "od"', () {
      final buffer = ImageBuffer(150, 100);
      _clearBuffer(buffer, Color(255, 255, 255, 255));

      _renderText(buffer, sansFace, 'od', 10, 75, 60, Color(0, 0, 0, 255));

      PngEncoder.saveImage(buffer, 'test/tmp/letters_od.png');
      expect(File('test/tmp/letters_od.png').existsSync(), isTrue);
    });

    test('Comparação letra "o" - AGG vs Cairo', () {
      // Carregar imagens
      final aggFile = File('test/tmp/letter_o.png');
      final cairoFile = File('test/golden/letter_o.png');

      if (!aggFile.existsSync() || !cairoFile.existsSync()) {
        fail('Imagens não encontradas. Execute os testes de geração primeiro.');
      }

      final aggImage = img.decodePng(aggFile.readAsBytesSync())!;
      final cairoImage = img.decodePng(cairoFile.readAsBytesSync())!;

      // Criar imagem de diferença
      final diffImage = img.Image(width: aggImage.width, height: aggImage.height);
      int diffPixels = 0;
      double mse = 0;

      for (int y = 0; y < aggImage.height; y++) {
        for (int x = 0; x < aggImage.width; x++) {
          final aggPixel = aggImage.getPixel(x, y);
          final cairoPixel = cairoImage.getPixel(x, y);

          final dr = (aggPixel.r - cairoPixel.r).abs();
          final dg = (aggPixel.g - cairoPixel.g).abs();
          final db = (aggPixel.b - cairoPixel.b).abs();

          mse += (dr * dr + dg * dg + db * db) / 3;

          if (dr > 10 || dg > 10 || db > 10) {
            diffPixels++;
            diffImage.setPixelRgba(x, y, 255, 0, 0, 255);
          } else {
            diffImage.setPixelRgba(x, y, aggPixel.r.toInt(), aggPixel.g.toInt(), aggPixel.b.toInt(), 255);
          }
        }
      }

      mse /= (aggImage.width * aggImage.height);
      final psnr = mse > 0 ? 10 * (math.log(255 * 255 / mse) / math.ln10) : double.infinity;

      print('Comparação letra "o":');
      print('  PSNR: ${psnr.toStringAsFixed(2)} dB');
      print('  MSE: ${mse.toStringAsFixed(4)}');
      print('  Pixels diferentes: $diffPixels / ${aggImage.width * aggImage.height}');

      // Salvar imagem de diferença
      File('test/tmp/letter_o.diff.png').writeAsBytesSync(img.encodePng(diffImage));

      expect(psnr, greaterThan(20.0), reason: 'Letra "o" deve ter renderização similar');
    });

    test('Comparação letra "d" - AGG vs Cairo', () {
      // Carregar imagens
      final aggFile = File('test/tmp/letter_d.png');
      final cairoFile = File('test/golden/letter_d.png');

      if (!aggFile.existsSync() || !cairoFile.existsSync()) {
        fail('Imagens não encontradas. Execute os testes de geração primeiro.');
      }

      final aggImage = img.decodePng(aggFile.readAsBytesSync())!;
      final cairoImage = img.decodePng(cairoFile.readAsBytesSync())!;

      // Criar imagem de diferença
      final diffImage = img.Image(width: aggImage.width, height: aggImage.height);
      int diffPixels = 0;
      double mse = 0;

      for (int y = 0; y < aggImage.height; y++) {
        for (int x = 0; x < aggImage.width; x++) {
          final aggPixel = aggImage.getPixel(x, y);
          final cairoPixel = cairoImage.getPixel(x, y);

          final dr = (aggPixel.r - cairoPixel.r).abs();
          final dg = (aggPixel.g - cairoPixel.g).abs();
          final db = (aggPixel.b - cairoPixel.b).abs();

          mse += (dr * dr + dg * dg + db * db) / 3;

          if (dr > 10 || dg > 10 || db > 10) {
            diffPixels++;
            diffImage.setPixelRgba(x, y, 255, 0, 0, 255);
          } else {
            diffImage.setPixelRgba(x, y, aggPixel.r.toInt(), aggPixel.g.toInt(), aggPixel.b.toInt(), 255);
          }
        }
      }

      mse /= (aggImage.width * aggImage.height);
      final psnr = mse > 0 ? 10 * (math.log(255 * 255 / mse) / math.ln10) : double.infinity;

      print('Comparação letra "d":');
      print('  PSNR: ${psnr.toStringAsFixed(2)} dB');
      print('  MSE: ${mse.toStringAsFixed(4)}');
      print('  Pixels diferentes: $diffPixels / ${aggImage.width * aggImage.height}');

      // Salvar imagem de diferença
      File('test/tmp/letter_d.diff.png').writeAsBytesSync(img.encodePng(diffImage));

      expect(psnr, greaterThan(20.0), reason: 'Letra "d" deve ter renderização similar');
    });
  });
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
