import 'dart:io';

import 'package:dart_graphics/src/dart_graphics/graphics2D.dart';
import 'package:dart_graphics/src/dart_graphics/image/image_buffer.dart';
import 'package:dart_graphics/src/dart_graphics/image/png_encoder.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';
import 'package:test/test.dart';

import '../test_utils/png_golden.dart';

const _goldenDir = 'resources/golden';
const _tmpDir = 'test/tmp';

const _fillGolden = 'resources/golden/graphics2d_fill.png';
const _strokeGolden = 'resources/golden/graphics2d_stroke.png';
const _gradientGolden = 'resources/golden/graphics2d_gradient.png';

void main() {
  group('Graphics2D goldens', () {
    setUpAll(() {
      Directory(_goldenDir).createSync(recursive: true);
      Directory(_tmpDir).createSync(recursive: true);
    });

    test('fill matches golden', () {
      final img = _drawFillSample();
      final outPath = 'test/tmp/graphics2d_fill.png';
      PngEncoder.saveImage(img, outPath);
      _ensureGolden(_fillGolden, img);
      expectPngMatchesGolden(outPath, _fillGolden, compareAlpha: true);
    });

    test('stroke matches golden', () {
      final img = _drawStrokeSample();
      final outPath = 'test/tmp/graphics2d_stroke.png';
      PngEncoder.saveImage(img, outPath);
      _ensureGolden(_strokeGolden, img);
      expectPngMatchesGolden(outPath, _strokeGolden, compareAlpha: true);
    });

    test('gradient matches golden', () {
      final img = _drawGradientSample();
      final outPath = 'test/tmp/graphics2d_gradient.png';
      PngEncoder.saveImage(img, outPath);
      _ensureGolden(_gradientGolden, img);
      expectPngMatchesGolden(outPath, _gradientGolden,
          compareAlpha: true, perChannelTolerance: 2, maxDifferentPixels: 50);
    });
  });
}

ImageBuffer _drawFillSample() {
  final img = ImageBuffer(120, 80);
  final g = img.newGraphics2D() as BasicGraphics2D;
  g.clear(Color.transparent);

  g.beginPath();
  g.rect(8, 8, 112, 72);
  g.fillColor = Color(230, 230, 230, 255);
  g.fillPath();

  g.beginPath();
  g.ellipse(60, 40, 24, 16, 48);
  g.fillColor = Color(0, 120, 255, 255);
  g.fillPath();

  return img;
}

ImageBuffer _drawStrokeSample() {
  final img = ImageBuffer(120, 80);
  final g = img.newGraphics2D() as BasicGraphics2D;
  g.clear(Color.transparent);

  g.lineWidth = 2.0;
  g.strokeColor = Color(255, 80, 0, 255);

  g.beginPath();
  g.moveTo(10, 10);
  g.lineTo(110, 10);
  g.lineTo(60, 70);
  g.closePath();
  g.strokePath();

  return img;
}

ImageBuffer _drawGradientSample() {
  final img = ImageBuffer(120, 80);
  final g = img.newGraphics2D() as BasicGraphics2D;
  g.clear(Color.transparent);

  g.beginPath();
  g.rect(10, 10, 110, 70);
  g.setLinearGradient(10, 10, 110, 70, [
    (offset: 0.0, color: Color(255, 0, 0, 255)),
    (offset: 1.0, color: Color(0, 0, 255, 255)),
  ]);
  g.fillPath();

  return img;
}

void _ensureGolden(String path, ImageBuffer img) {
  final file = File(path);
  if (!file.existsSync()) {
    PngEncoder.saveImage(img, path);
  }
}
