import 'dart:io';
import 'package:test/test.dart';
import 'package:dart_graphics/src/agg/agg.dart';

void main() {
  group('AGG Bindings', () {
    late Agg agg;

    setUp(() {
      agg = Agg();
    });

    test('Can create and dispose surface', () {
      final surface = agg.createSurface(100, 100);
      expect(surface.width, 100);
      expect(surface.height, 100);
      expect(surface.data, isNotNull);
      expect(surface.stride, greaterThan(0));
      surface.dispose();
      expect(surface.isDisposed, isTrue);
    });

    test('Can create and use canvas', () {
      final surface = agg.createSurface(100, 100);
      final canvas = surface.createCanvas();
      
      // Basic drawing
      canvas.setFillColor(255, 0, 0);
      canvas.rect(0, 0, 10, 10);
      canvas.fill();
      
      canvas.setStrokeColor(0, 255, 0);
      canvas.setLineWidth(2.0);
      canvas.moveTo(0, 0);
      canvas.lineTo(10, 10);
      canvas.stroke();
      
      canvas.dispose();
      expect(canvas.isDisposed, isTrue);
      surface.dispose();
    });

    test('Can create and use gradients', () {
      final gradient = agg.createGradient(AggGradientType.AggGradientLinear);
      
      gradient.setLinear(0, 0, 100, 100);
      gradient.addStop(0.0, 255, 0, 0);
      gradient.addStop(1.0, 0, 0, 255);
      gradient.build();
      
      final surface = agg.createSurface(100, 100);
      final canvas = surface.createCanvas();
      
      canvas.setFillGradient(gradient);
      canvas.rect(0, 0, 100, 100);
      canvas.fill();
      
      canvas.dispose();
      gradient.dispose();
      surface.dispose();
    });
    
    test('Can create font', () {
       // Font creation only creates the object, doesn't need file yet
       final font = agg.createFont();
       font.dispose();
    });

    test('Can load font and draw text', () {
      if (!Platform.isWindows) return; // Only testing on Windows with assumed fonts
      
      final font = agg.createFont();
      final loaded = font.load('C:/Windows/Fonts/arial.ttf');
      // If font loading fails (e.g. file not found), we just skip the rest of the test but don't fail
      // However, if it succeeds, we test drawing.
      if (loaded) {
        final surface = agg.createSurface(100, 100);
        final canvas = surface.createCanvas();
        canvas.setFont(font);
        canvas.drawText("Test", 10, 50);
        canvas.dispose();
        surface.dispose();
      }
      font.dispose();
    });
  });
}
