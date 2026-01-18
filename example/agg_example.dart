import 'dart:io';
import 'dart:math' as math;
import 'dart:ffi' as ffi;
import 'package:image/image.dart' as img;
import 'package:dart_graphics/src/agg/agg.dart';

void main() {
  print('AGG Canvas Example - Clean Layout');
  final agg = Agg();
  print('AGG Version: ${agg.getVersion()}');
  print('FreeType Version: ${agg.getFreetypeVersion()}');
  print('=' * 40);

  // Create a canvas 800x1000 to fit everything comfortably
  final surface = agg.createSurface(800, 1000);
  final canvas = surface.createCanvas();

  // Clear with white background
  canvas.setFillColor(255, 255, 255);
  canvas.rect(0, 0, 800, 1000);
  canvas.fill();

  // ========================
  // Row 1: Basic Shapes & Clipping (Y: 50-150)
  // ========================
  print('1. Drawing Rectangles & Clipping...');

  // Filled & Stroked Rects
  canvas.setFillColor(255, 0, 0); // Red Fill
  canvas.rect(50, 50, 80, 60);
  canvas.fill();

  canvas.setStrokeColor(0, 0, 255); // Blue Stroke
  canvas.setLineWidth(3);
  canvas.rect(150, 50, 80, 60);
  canvas.stroke();

  canvas.setFillColor(0, 255, 0); // Green Fill
  canvas.rect(250, 50, 80, 60);
  canvas.fill();

  // Build a Clipping Region
  // We want to clip a large gray rectangle into a smaller window
  canvas.clipRect(400, 50, 100, 60); // Clip window
  
  canvas.setFillColor(150, 150, 150);
  canvas.rect(380, 40, 150, 120); // Larger rect
  canvas.fill();
  
  canvas.resetClip();
  // Draw border of clip rect for visualization
  canvas.setStrokeColor(0, 0, 0);
  canvas.setLineWidth(1);
  canvas.rect(400, 50, 100, 60);
  canvas.stroke();


  // ========================
  // Row 2: Circles, Arcs & Rounded Rects (Y: 200-300)
  // ========================
  print('2. Drawing Curves...');

  // Circle Fill
  canvas.beginPath();
  canvas.setFillColor(0, 255, 255); // Cyan
  canvas.ellipse(90, 250, 40, 40);
  canvas.fill();

  // Circle Stroke
  canvas.beginPath();
  canvas.setStrokeColor(128, 0, 128); // Purple
  canvas.setLineWidth(4);
  canvas.ellipse(190, 250, 40, 40);
  canvas.stroke();

  // Rounded Rect
  canvas.beginPath();
  canvas.setFillColor(255, 152, 0); // Orange
  canvas.roundedRect(300, 210, 120, 80, 15);
  canvas.fill();

  // Pac-man approximation (Yellow)
  canvas.beginPath();
  canvas.setFillColor(241, 196, 15);
  canvas.ellipse(500, 250, 40, 40);
  canvas.fill();
  // Draw mouth (white wedge)
  canvas.beginPath();
  canvas.setFillColor(255, 255, 255);
  canvas.moveTo(500, 250);
  canvas.lineTo(540, 230);
  canvas.lineTo(540, 270);
  canvas.closePath();
  canvas.fill();


  // ========================
  // Row 3: Paths, Triangles, Stars & Dashes (Y: 350-450)
  // ========================
  print('3. Drawing Paths...');

  // Triangle
  canvas.beginPath();
  canvas.setFillColor(46, 204, 113); // Emerald
  canvas.moveTo(90, 350);
  canvas.lineTo(50, 450);
  canvas.lineTo(130, 450);
  canvas.closePath();
  canvas.fill();

  // Star
  final starCX = 250.0;
  final starCY = 400.0;
  canvas.beginPath();
  for (int i = 0; i < 10; i++) {
    final angle = i * math.pi / 5 - math.pi / 2;
    final r = i.isEven ? 50.0 : 25.0;
    final x = starCX + r * math.cos(angle);
    final y = starCY + r * math.sin(angle);
    if (i == 0) canvas.moveTo(x, y); else canvas.lineTo(x, y);
  }
  canvas.closePath();
  canvas.setFillColor(155, 89, 182); // Amethyst
  canvas.fill();

  // Dashed Line (Removed from Row 3)
  /*
  canvas.beginPath();
  canvas.setStrokeColor(0, 0, 0);
  canvas.setLineWidth(4);
  canvas.setLineDash([10.0, 5.0, 2.0, 5.0]);
  canvas.moveTo(350, 400);
  canvas.lineTo(550, 400);
  canvas.stroke();
  canvas.setLineDash([]); // Reset
  */

  // Bezier Curve
  canvas.beginPath();
  canvas.setStrokeColor(0, 188, 212); // Cyan
  canvas.setLineWidth(4);
  canvas.moveTo(600, 420);
  canvas.quadraticTo(650, 320, 700, 420);
  canvas.stroke();


  // ========================
  // Row 4: Transforms (Y: 500-600)
  // ========================
  print('4. Transforms...');
  
  // We want to draw a rotated rectangle at x=100, y=550
  canvas.translate(100, 550);
  canvas.rotate(math.pi / 6); // 30 deg
  canvas.setFillColor(100, 100, 200, 180); // Translucent Blue
  canvas.rect(-40, -25, 80, 50); // Center at origin
  canvas.fill();
  canvas.resetTransform();


  // ========================
  // Row 5: Typography (Y: 650-750)
  // ========================
  print('5. Typography...');
  
  final fontPath = 'C:/Windows/Fonts/arial.ttf';
  final font = agg.createFont();
  
  if (File(fontPath).existsSync() && 
      font.load(fontPath, height: 40, mode: AggTextRenderMode.AggTextRenderModeGray)) {
      
      canvas.setFont(font);
      canvas.setTextColor(0, 0, 0);

      // --- Measured Text ---
      String msg = "Measured Box";
      final metrics = canvas.measureText(msg);
      
      double tmX = 100;
      double tmY = 700;
      
      // Draw text
      canvas.drawText(msg, tmX, tmY);
      
      // Draw box around it
      canvas.setStrokeColor(255, 0, 0);
      canvas.setLineWidth(1);
      canvas.rect(
          tmX + metrics['x']!, 
          tmY + metrics['y']!, 
          metrics['width']!, 
          metrics['height']!
      );
      canvas.stroke();

      // --- Gradient Text ---
      final fontOutline = agg.createFont();
      fontOutline.load(fontPath, height: 80, mode: AggTextRenderMode.AggTextRenderModeOutline); 
      canvas.setFont(fontOutline); // Set contour font
      
      // Create Gradient
      final grad = agg.createGradient(AggGradientType.AggGradientLinear);
      grad.setLinear(400, 650, 400, 720); // Adjusted to cover text height (approx 650 to 720)
      grad.addStop(0.0, 255, 0, 0); // Red
      grad.addStop(1.0, 0, 0, 255); // Blue
      grad.build();
      
      canvas.setFillGradient(grad);
      canvas.setLineWidth(1.5);
      canvas.setStrokeColor(0, 0, 0);
      
      canvas.drawText("Gradient Filled", 400, 720, mode: AggTextRenderMode.AggTextRenderModeFill);
      
      grad.dispose();
      fontOutline.dispose();
      
  } else {
      print("Font not found: ");
  }
  font.dispose();

  // Dashed Line (Footer)
  // Moved to bottom as requested
  // ========================
  // Row 6: Footer (Y: 980)
  // ========================
  print('6. Drawing Footer (Dashed Line)...');
  canvas.beginPath();
  canvas.setStrokeColor(0, 0, 0);
  canvas.setLineWidth(2);
  canvas.setLineDash([10.0, 5.0, 2.0, 5.0]);
  canvas.moveTo(50, 980);
  canvas.lineTo(750, 980);
  canvas.stroke();
  canvas.setLineDash([]); // Reset

  // Save Output
  print('\nSaving...');
  final outputPath = 'test/tmp/agg_example.png';
  Directory('test/tmp').createSync(recursive: true);
  // ========================
  // Row 7: Advanced Paths (Arcs, Beziers, SVG) (Y: 850-920)
  // ========================
  print('7. Drawing Arcs & SVG Paths...');
  
  // Bezier Curve (Quadratic)
  canvas.setStrokeColor(0, 0, 0);
  canvas.setLineWidth(2);
  canvas.beginPath();
  canvas.moveTo(50, 900);
  canvas.quadraticTo(100, 850, 150, 900);
  canvas.stroke();
  
  // Cubic Bezier
  canvas.setStrokeColor(255, 0, 0);
  canvas.beginPath();
  canvas.moveTo(200, 900);
  canvas.cubicTo(230, 850, 270, 950, 300, 900);
  canvas.stroke();
  
  // Arc (SVG style common arc)
  canvas.setStrokeColor(0, 0, 255);
  canvas.beginPath();
  canvas.moveTo(350, 900);
  // rx, ry, rot, large, sweep, x, y
  canvas.arc(40, 30, 0, false, false, 430, 900);
  canvas.stroke();
  
  // 45 Degree Arc using center point
  canvas.setStrokeColor(255, 0, 255); // Magenta
  canvas.setLineWidth(3);
  canvas.beginPath();
  // cx, cy, r, startAngle, sweepAngle (radians)
  canvas.arcCenter(600, 900, 40, 0, math.pi / 4); // 45 degrees
  canvas.stroke();

  // SVG Path String
  canvas.setFillColor(0, 150, 0);
  canvas.setStrokeColor(0, 0, 0); // Optional stroke if you want
  canvas.beginPath();
  // A small star or shape using path data "M x y ..."
  // Let's draw a simple shape at x=500
  // Standard star path
  canvas.addSvgPath("M 550 900 L 565 850 L 580 900 L 535 865 L 595 865 Z");
  canvas.fill();
  canvas.stroke();

  savePng(surface, outputPath);
  print('Done: test/tmp/agg_example.png');
}

void savePng(AggSurface surface, String filename) {
  final width = surface.width;
  final height = surface.height;
  final buffer = surface.data;
  final image = img.Image(width: width, height: height);
  final stride = surface.stride;
  
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      final index = y * stride + x * 4;
      final r = buffer[index];
      final g = buffer[index + 1];
      final b = buffer[index + 2];
      final a = buffer[index + 3];
      image.setPixel(x, y, img.ColorInt8.rgba(r, g, b, a));
    }
  }

  final png = img.encodePng(image);
  File(filename).writeAsBytesSync(png);
}
