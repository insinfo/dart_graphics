import 'package:test/test.dart';

import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/rectangle_double.dart';
import 'package:dart_graphics/src/dart_graphics/recording/clip_stack.dart';
import 'package:dart_graphics/src/dart_graphics/recording/graphics_commands.dart';
import 'package:dart_graphics/src/dart_graphics/recording/image_graphics_backend.dart';
import 'package:dart_graphics/src/dart_graphics/recording/layer_stack.dart';
import 'package:dart_graphics/src/dart_graphics/image/image_buffer.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/vertex_storage.dart';

VertexStorage _rect(double x1, double y1, double x2, double y2) {
  final path = VertexStorage();
  path.moveTo(x1, y1);
  path.lineTo(x2, y1);
  path.lineTo(x2, y2);
  path.lineTo(x1, y2);
  path.closePath();
  return path;
}

void main() {
  group('ImageGraphicsBackend', () {
    test('saveLayer srcOver opacity blends', () {
      final buffer = CommandBuffer();
      buffer.clear(Color(0, 0, 0, 255));
      buffer.saveLayer(const Layer(opacity: 0.5, blendMode: BlendModeLite.srcOver));
      buffer.drawPath(_rect(0, 0, 10, 10), SolidPaint(Color(255, 0, 0, 255)));
      buffer.restore();

      final backend = ImageGraphicsBackend();
      buffer.play(backend, 10, 10);
      final frame = backend.frame!;

      final pixel = frame.getPixel(5, 5);
      expect(pixel.red, closeTo(128, 1));
      expect(pixel.green, closeTo(0, 1));
      expect(pixel.blue, closeTo(0, 1));
      expect(pixel.alpha, closeTo(255, 1));
    });

    test('saveLayer respects bounds on composite', () {
      final buffer = CommandBuffer();
      buffer.clear(Color(255, 255, 255, 255));
      buffer.saveLayer(
        const Layer(opacity: 1.0, blendMode: BlendModeLite.srcOver),
        bounds: RectangleDouble(2, 2, 6, 6),
      );
      buffer.drawPath(_rect(0, 0, 10, 10), SolidPaint(Color(255, 0, 0, 255)));
      buffer.restore();

      final backend = ImageGraphicsBackend();
      buffer.play(backend, 10, 10);
      final frame = backend.frame!;

      expect(frame.getPixel(1, 1), Color(255, 255, 255, 255));
      expect(frame.getPixel(8, 8), Color(255, 255, 255, 255));
      expect(frame.getPixel(3, 3), Color(255, 0, 0, 255));
      expect(frame.getPixel(5, 5), Color(255, 0, 0, 255));
    });

    test('clip difference removes region', () {
      final buffer = CommandBuffer();
      buffer.clear(Color(255, 255, 255, 255));
      buffer.clipPath(_rect(2, 2, 6, 6), op: ClipOp.difference);
      buffer.drawPath(_rect(0, 0, 10, 10), SolidPaint(Color(255, 0, 0, 255)));

      final backend = ImageGraphicsBackend();
      buffer.play(backend, 10, 10);
      final frame = backend.frame!;

      expect(frame.getPixel(0, 0), Color(255, 0, 0, 255));
      expect(frame.getPixel(3, 3), Color(255, 255, 255, 255));
      expect(frame.getPixel(9, 9), Color(255, 0, 0, 255));
    });

    test('saveLayer multiply blends', () {
      final buffer = CommandBuffer();
      buffer.clear(Color(128, 128, 128, 255));
      buffer.saveLayer(const Layer(opacity: 1.0, blendMode: BlendModeLite.multiply));
      buffer.drawPath(_rect(0, 0, 10, 10), SolidPaint(Color(255, 0, 0, 255)));
      buffer.restore();

      final backend = ImageGraphicsBackend();
      buffer.play(backend, 10, 10);
      final frame = backend.frame!;

      final pixel = frame.getPixel(5, 5);
      expect(pixel.red, closeTo(128, 1));
      expect(pixel.green, closeTo(0, 1));
      expect(pixel.blue, closeTo(0, 1));
      expect(pixel.alpha, closeTo(255, 1));
    });

    test('linear gradient fills across path', () {
      final buffer = CommandBuffer();
      buffer.clear(Color(0, 0, 0, 0));
      buffer.drawPath(
        _rect(0, 0, 10, 10),
        LinearGradientPaint(
          x1: 0,
          y1: 0,
          x2: 10,
          y2: 0,
          stops: [
            PaintStop(0.0, Color(0, 0, 0, 255)),
            PaintStop(1.0, Color(255, 255, 255, 255)),
          ],
        ),
      );

      final backend = ImageGraphicsBackend();
      buffer.play(backend, 10, 10);
      final frame = backend.frame!;

      final left = frame.getPixel(1, 5);
      final right = frame.getPixel(8, 5);
      expect(left.red, lessThan(right.red));
      expect(left.green, lessThan(right.green));
      expect(left.blue, lessThan(right.blue));
    });

    test('pattern paint repeats image', () {
      final pattern = ImageBuffer(2, 2);
      pattern.setPixel(0, 0, Color(255, 0, 0, 255));
      pattern.setPixel(1, 0, Color(0, 255, 0, 255));
      pattern.setPixel(0, 1, Color(0, 0, 255, 255));
      pattern.setPixel(1, 1, Color(255, 255, 0, 255));

      final buffer = CommandBuffer();
      buffer.clear(Color(0, 0, 0, 0));
      buffer.drawPath(_rect(0, 0, 4, 4), ImagePaint(image: pattern));

      final backend = ImageGraphicsBackend();
      buffer.play(backend, 4, 4);
      final frame = backend.frame!;

      expect(frame.getPixel(0, 0), Color(255, 0, 0, 255));
      expect(frame.getPixel(1, 0), Color(0, 255, 0, 255));
      expect(frame.getPixel(0, 1), Color(0, 0, 255, 255));
      expect(frame.getPixel(1, 1), Color(255, 255, 0, 255));
      expect(frame.getPixel(2, 2), Color(255, 0, 0, 255));
      expect(frame.getPixel(3, 2), Color(0, 255, 0, 255));
    });
  });
}
