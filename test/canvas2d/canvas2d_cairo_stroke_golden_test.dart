/// Cairo golden comparisons for Canvas2D stroke fidelity.
///
/// These tests compare DartGraphics output against Cairo-generated goldens.

import 'dart:io';
import 'dart:math' as math;

import 'package:test/test.dart';
import 'package:dart_graphics/src/dart_graphics/canvas/canvas.dart';

import 'package:dart_graphics/cairo.dart';
import '../test_utils/png_golden.dart';

const _triangleGolden = 'resources/golden/canvas2d_stroke_triangle.png';
const _arcGolden = 'resources/golden/canvas2d_stroke_arc.png';

void _drawStrokeTriangle(dynamic ctx) {
  ctx.fillStyle = 'white';
  ctx.fillRect(0.0, 0.0, 300.0, 200.0);

  ctx.beginPath();
  ctx.strokeStyle = '#E74C3C';
  ctx.lineWidth = 3.0;
  ctx.moveTo(60.0, 40.0);
  ctx.lineTo(20.0, 160.0);
  ctx.lineTo(120.0, 160.0);
  ctx.closePath();
  ctx.stroke();
}

void _drawStrokeArc(dynamic ctx) {
  ctx.fillStyle = 'white';
  ctx.fillRect(0.0, 0.0, 300.0, 200.0);

  ctx.beginPath();
  ctx.strokeStyle = '#00BCD4';
  ctx.lineWidth = 4.0;
  ctx.arc(150.0, 120.0, 70.0, math.pi * 0.15, math.pi * 0.95);
  ctx.stroke();
}

void _ensureCairoGolden(String path, void Function(dynamic ctx) draw) {
  if (File(path).existsSync()) {
    return;
  }

  final cairo = Cairo();
  final canvas = CairoHtmlCanvas(300, 200, cairo: cairo);
  final ctx = canvas.getContext('2d');

  draw(ctx);

  canvas.saveAs(path);
  canvas.dispose();
}

void main() {
  setUpAll(() {
    Directory('test/tmp').createSync(recursive: true);
    _ensureCairoGolden(_triangleGolden, _drawStrokeTriangle);
    _ensureCairoGolden(_arcGolden, _drawStrokeArc);
  });

  group('Canvas2D DartGraphics vs Cairo goldens (strokes)', () {
    test('stroke triangle matches Cairo golden', () {
      _ensureCairoGolden(_triangleGolden, _drawStrokeTriangle);

      final canvas = DartGraphicsCanvas(300, 200);
      final ctx = canvas.getContext('2d');
      _drawStrokeTriangle(ctx);

      final outPath = 'test/tmp/canvas2d_dartgraphics_stroke_triangle.png';
      canvas.saveAs(outPath);
      canvas.dispose();

      expectPngMatchesGolden(
        outPath,
        _triangleGolden,
        perChannelTolerance: 3,
        maxDifferentPixels: 1200,
        compareAlpha: false,
        compositeOnWhite: true,
        diffOutputPath: 'test/tmp/diff_canvas2d_stroke_triangle.png',
      );
    });

    test('stroke arc matches Cairo golden', () {
      _ensureCairoGolden(_arcGolden, _drawStrokeArc);

      final canvas = DartGraphicsCanvas(300, 200);
      final ctx = canvas.getContext('2d');
      _drawStrokeArc(ctx);

      final outPath = 'test/tmp/canvas2d_dartgraphics_stroke_arc.png';
      canvas.saveAs(outPath);
      canvas.dispose();

      expectPngMatchesGolden(
        outPath,
        _arcGolden,
        perChannelTolerance: 3,
        maxDifferentPixels: 1200,
        compareAlpha: false,
        compositeOnWhite: true,
        diffOutputPath: 'test/tmp/diff_canvas2d_stroke_arc.png',
      );
    });
  });
}
