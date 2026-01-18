import 'dart:io';

import 'package:dart_graphics/src/dart_graphics/image/image_buffer.dart';
import 'package:dart_graphics/src/dart_graphics/image/png_encoder.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';
import 'package:dart_graphics/src/dart_graphics/scanline_bin.dart';
import 'package:dart_graphics/src/dart_graphics/scanline_rasterizer.dart';
import 'package:dart_graphics/src/dart_graphics/scanline_renderer.dart';
import 'package:dart_graphics/src/dart_graphics/scanline_unpacked8.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/vertex_storage.dart';
import 'package:test/test.dart';

import '../test_utils/png_golden.dart';

Color _rgbaFromFloats(double r, double g, double b, double a) {
  int conv(double v) => (v.clamp(0.0, 1.0) * 255.0).round();
  return Color(conv(r), conv(g), conv(b), conv(a));
}

VertexStorage _triangle(List<double> xs, List<double> ys) {
  final path = VertexStorage()
    ..moveTo(xs[0], ys[0])
    ..lineTo(xs[1], ys[1])
    ..lineTo(xs[2], ys[2])
    ..closePath();
  return path;
}

void _clearTo(ImageBuffer buffer, Color color) {
  for (var y = 0; y < buffer.height; y++) {
    for (var x = 0; x < buffer.width; x++) {
      buffer.setPixel(x, y, color);
    }
  }
}

void main() {
  test('Rasterizer AA vs binary matches golden rasterizers.png', () {
    const width = 500;
    const height = 330;

    final buffer = ImageBuffer(width, height);
    _clearTo(buffer, Color(255, 255, 255, 255));

    final mx = [220.0, 489.0, 263.0];
    final my = [60.0, 170.0, 310.0];

    final rasterizer = ScanlineRasterizer();
    final scanlineAA = ScanlineUnpacked8();
    final scanlineBin = ScanlineBin();

    rasterizer.reset();
    rasterizer.addPath(_triangle(mx, my));
    ScanlineRenderer.renderSolid(
      rasterizer,
      scanlineAA,
      buffer,
      _rgbaFromFloats(0.7, 0.5, 0.1, 0.5),
    );

    rasterizer.reset();
    rasterizer.addPath(_triangle(
      [mx[0] - 200.0, mx[1] - 200.0, mx[2] - 200.0],
      my,
    ));
    ScanlineRenderer.renderSolid(
      rasterizer,
      scanlineBin,
      buffer,
      _rgbaFromFloats(0.1, 0.5, 0.7, 0.5),
    );

    Directory('test/tmp').createSync(recursive: true);
    const outPath = 'test/tmp/rasterizers.png';
    PngEncoder.saveImage(buffer, outPath);

    expectPngMatchesGolden(
      outPath,
      'resources/rasterizers.png',
      perChannelTolerance: 4,
      maxDifferentPixels: 1500,
      compositeOnWhite: true,
      compareAlpha: false,
    );
  });
}
