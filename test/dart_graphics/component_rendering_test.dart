import 'dart:io';

import 'package:dart_graphics/src/dart_graphics/image/blender_single_channel.dart';
import 'package:dart_graphics/src/dart_graphics/image/image_buffer.dart';
import 'package:dart_graphics/src/dart_graphics/image/png_encoder.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';
import 'package:dart_graphics/src/dart_graphics/scanline_rasterizer.dart';
import 'package:dart_graphics/src/dart_graphics/scanline_renderer.dart';
import 'package:dart_graphics/src/dart_graphics/scanline_unpacked8.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/ellipse.dart';
import 'package:test/test.dart';

import '../test_utils/png_golden.dart';

class _ComponentCase {
  const _ComponentCase(this.alpha, this.outputName);

  final int alpha;
  final String outputName;

  String get goldenPath => 'resources/$outputName';
  String get outputPath => 'test/tmp/$outputName';
}

void main() {
  final cases = <_ComponentCase>[
    const _ComponentCase(0, 'component_rendering_000.png'),
    const _ComponentCase(128, 'component_rendering_128.png'),
    const _ComponentCase(255, 'component_rendering_255.png'),
  ];

  for (final testCase in cases) {
    test('Component rendering alpha ${testCase.alpha}', () {
      _renderComponentScene(testCase);
    });
  }
}

void _renderComponentScene(_ComponentCase testCase) {
  const width = 320;
  const height = 320;

  final buffer = ImageBuffer(width, height);
  final defaultBlender = buffer.getRecieveBlender();

  // Clear to white so each channel blend behaves as in the original DartGraphics test.
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      buffer.setPixel(x, y, Color(255, 255, 255));
    }
  }

  final ras = ScanlineRasterizer();
  final sl = ScanlineUnpacked8();

  void drawEllipse(double cx, double cy, int channelIndex) {
    ras.reset();
    final ellipse = Ellipse(cx, cy, 100.0, 100.0, 100);
    ras.addPath(ellipse);
    buffer.setRecieveBlender(BlenderSingleChannel(channelIndex));
    ScanlineRenderer.renderSolid(
        ras, sl, buffer, Color(0, 0, 0, testCase.alpha));
    buffer.setRecieveBlender(defaultBlender);
  }

  final double w2 = width / 2.0;
  final double h2 = height / 2.0;

  drawEllipse(w2 - 0.87 * 50.0, h2 - 0.5 * 50.0, 0);
  drawEllipse(w2 + 0.87 * 50.0, h2 - 0.5 * 50.0, 1);
  drawEllipse(w2, h2 + 50.0, 2);

  Directory('test/tmp').createSync(recursive: true);
  PngEncoder.saveImage(buffer, testCase.outputPath);

  expectPngMatchesGolden(
    testCase.outputPath,
    testCase.goldenPath,
    perChannelTolerance: testCase.alpha == 0 ? 2 : 8,
    maxDifferentPixels: testCase.alpha == 0 ? 400 : 1200,
    compositeOnWhite: true,
    compareAlpha: false,
  );
}
