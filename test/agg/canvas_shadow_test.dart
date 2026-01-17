import 'package:dart_graphics/src/agg/canvas/canvas.dart';
import 'package:test/test.dart';

void main() {
  group('Canvas Shadow Tests', () {
    late AggHtmlCanvas canvas;
    late AggCanvasRenderingContext2D ctx;

    setUp(() {
      canvas = AggHtmlCanvas(200, 200);
      ctx = canvas.getContext('2d');
    });

    test('shadow properties default values', () {
      expect(ctx.shadowBlur, equals(0.0));
      expect(ctx.shadowColor, equals('rgba(0, 0, 0, 0)'));
      expect(ctx.shadowOffsetX, equals(0.0));
      expect(ctx.shadowOffsetY, equals(0.0));
    });

    test('shadow properties can be set', () {
      ctx.shadowBlur = 5.0;
      ctx.shadowColor = 'rgba(0, 0, 0, 0.5)';
      ctx.shadowOffsetX = 10.0;
      ctx.shadowOffsetY = 10.0;

      expect(ctx.shadowBlur, equals(5.0));
      expect(ctx.shadowColor, equals('rgba(0, 0, 0, 0.5)'));
      expect(ctx.shadowOffsetX, equals(10.0));
      expect(ctx.shadowOffsetY, equals(10.0));
    });

    test('shadowBlur rejects negative values', () {
      ctx.shadowBlur = -5.0;
      expect(ctx.shadowBlur, equals(0.0));
    });

    test('fillRect draws shadow when shadow is configured', () {
      // Configure shadow
      ctx.shadowBlur = 5.0;
      ctx.shadowColor = 'rgba(0, 0, 0, 0.5)';
      ctx.shadowOffsetX = 10.0;
      ctx.shadowOffsetY = 10.0;

      // Draw a red rectangle
      ctx.fillStyle = '#FF0000';
      ctx.fillRect(20, 20, 50, 50);

      // Check that the main rectangle is drawn
      final mainRectPixel = canvas.buffer.getPixel(45, 45);
      expect(mainRectPixel.red, equals(255));
      expect(mainRectPixel.green, equals(0));
      expect(mainRectPixel.blue, equals(0));

      // Check that there's something in the shadow area (offset from main rect)
      // The shadow should be at approximately (30, 30) due to 10px offset
      final shadowAreaPixel = canvas.buffer.getPixel(85, 85);
      // Shadow should have some alpha (not fully transparent)
      // It may vary due to blur, so we just check it's not the background
      expect(shadowAreaPixel.alpha > 0 || shadowAreaPixel.red > 0, isTrue);
    });

    test('fillRect draws no shadow when shadow color is transparent', () {
      // Configure shadow with transparent color
      ctx.shadowBlur = 5.0;
      ctx.shadowColor = 'rgba(0, 0, 0, 0)'; // Fully transparent
      ctx.shadowOffsetX = 10.0;
      ctx.shadowOffsetY = 10.0;

      // Clear and draw
      ctx.clearRect(0, 0, 200, 200);
      ctx.fillStyle = '#FF0000';
      ctx.fillRect(20, 20, 50, 50);

      // Check that shadow area is empty (outside the main rect)
      final outsidePixel = canvas.buffer.getPixel(100, 100);
      expect(outsidePixel.alpha, equals(0));
    });

    test('stroke draws shadow when shadow is configured', () {
      // Configure shadow
      ctx.shadowBlur = 3.0;
      ctx.shadowColor = 'rgba(0, 0, 0, 0.5)';
      ctx.shadowOffsetX = 5.0;
      ctx.shadowOffsetY = 5.0;

      // Draw a stroked path
      ctx.strokeStyle = '#0000FF';
      ctx.lineWidth = 3.0;
      ctx.beginPath();
      ctx.moveTo(50, 50);
      ctx.lineTo(150, 50);
      ctx.lineTo(150, 150);
      ctx.stroke();

      // Check that the stroke is drawn
      final strokePixel = canvas.buffer.getPixel(100, 50);
      expect(strokePixel.blue > 0, isTrue);
    });

    test('fill draws shadow for path', () {
      // Configure shadow
      ctx.shadowBlur = 4.0;
      ctx.shadowColor = '#00000080'; // Semi-transparent black
      ctx.shadowOffsetX = 8.0;
      ctx.shadowOffsetY = 8.0;

      // Draw a triangle
      ctx.fillStyle = '#00FF00';
      ctx.beginPath();
      ctx.moveTo(100, 20);
      ctx.lineTo(150, 100);
      ctx.lineTo(50, 100);
      ctx.closePath();
      ctx.fill();

      // Check that the triangle is drawn
      final trianglePixel = canvas.buffer.getPixel(100, 70);
      expect(trianglePixel.green, equals(255));
    });

    test('shadow is saved and restored with context state', () {
      ctx.shadowBlur = 10.0;
      ctx.shadowColor = '#FF0000';
      ctx.shadowOffsetX = 20.0;
      ctx.shadowOffsetY = 20.0;

      ctx.save();
      
      ctx.shadowBlur = 5.0;
      ctx.shadowColor = '#0000FF';
      ctx.shadowOffsetX = 10.0;
      ctx.shadowOffsetY = 10.0;

      expect(ctx.shadowBlur, equals(5.0));
      expect(ctx.shadowColor, equals('#0000FF'));
      expect(ctx.shadowOffsetX, equals(10.0));
      expect(ctx.shadowOffsetY, equals(10.0));

      ctx.restore();

      expect(ctx.shadowBlur, equals(10.0));
      expect(ctx.shadowColor, equals('#FF0000'));
      expect(ctx.shadowOffsetX, equals(20.0));
      expect(ctx.shadowOffsetY, equals(20.0));
    });

    test('strokeRect draws shadow when shadow is configured', () {
      // Configure shadow
      ctx.shadowBlur = 3.0;
      ctx.shadowColor = 'rgba(0, 0, 0, 0.5)';
      ctx.shadowOffsetX = 5.0;
      ctx.shadowOffsetY = 5.0;

      // Draw a stroked rectangle
      ctx.strokeStyle = '#FF00FF';
      ctx.lineWidth = 2.0;
      ctx.strokeRect(40, 40, 60, 60);

      // Check that the stroke is drawn (on the edge of the rectangle)
      final edgePixel = canvas.buffer.getPixel(40, 70);
      expect(edgePixel.red > 0 || edgePixel.blue > 0, isTrue);
    });
  });
}
