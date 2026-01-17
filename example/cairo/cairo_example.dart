/// Example demonstrating the high-level Cairo API
/// 
/// Run with: dart run example/cairo_example.dart
/// 
/// Requires cairo library to be installed on your system.

import 'dart:math' as math;
import 'package:dart_graphics/cairo.dart';

/// Global Cairo instance for all examples
final cairo = Cairo();

void main() {
  print('Cairo High-Level API Example');
  print('============================\n');
  
  // Example 1: Basic shapes
  basicShapesExample();
  
  // Example 2: Text rendering
  textExample();
  
  // Example 3: SVG path rendering
  svgPathExample();
  
  // Example 4: Complex drawing
  complexDrawingExample();
  
  print('\nAll examples completed! Check the output PNG files.');
}

/// Example 1: Drawing basic shapes
void basicShapesExample() {
  print('Creating basic_shapes.png...');
  
  final canvas = cairo.createCanvas(400, 400);
  
  // Clear with white background
  canvas.clear(CairoColor.white);
  
  // Draw a red filled rectangle
  canvas
    ..setColor(CairoColor.red)
    ..fillRect(50, 50, 100, 80);
  
  // Draw a blue stroked rectangle
  canvas
    ..setColor(CairoColor.blue)
    ..setLineWidth(3)
    ..strokeRect(200, 50, 100, 80);
  
  // Draw a green filled circle
  canvas
    ..setColor(CairoColor.green)
    ..fillCircle(100, 250, 50);
  
  // Draw a yellow stroked circle with dashed line
  canvas
    ..setColor(CairoColor.fromHex(0xFFA500)) // Orange
    ..setLineWidth(4)
    ..setDash([10, 5])
    ..strokeCircle(250, 250, 50);
  
  // Draw a magenta rounded rectangle
  canvas
    ..setColor(CairoColor.magenta)
    ..clearDash()
    ..fillRoundedRect(150, 320, 100, 60, 15);
  
  // Draw a line
  canvas
    ..setColor(CairoColor.black)
    ..setLineWidth(2)
    ..drawLine(50, 380, 350, 380);
  
  canvas.saveToPng('basic_shapes.png');
  canvas.dispose();
  
  print('  -> basic_shapes.png created');
}

/// Example 2: Text rendering
void textExample() {
  print('Creating text_example.png...');
  
  final canvas = cairo.createCanvas(500, 300);
  
  canvas.clear(CairoColor.white);
  
  // Title
  canvas
    ..setColor(CairoColor.black)
    ..selectFontFace('Arial', weight: FontWeight.bold)
    ..setFontSize(32)
    ..drawText('Cairo Text Rendering', 50, 50);
  
  // Normal text
  canvas
    ..selectFontFace('Arial')
    ..setFontSize(18)
    ..drawText('Normal text in Arial', 50, 100);
  
  // Italic text
  canvas
    ..selectFontFace('Arial', slant: FontSlant.italic)
    ..setFontSize(18)
    ..drawText('Italic text', 50, 130);
  
  // Bold text
  canvas
    ..selectFontFace('Arial', weight: FontWeight.bold)
    ..setFontSize(18)
    ..drawText('Bold text', 50, 160);
  
  // Colored text
  canvas
    ..setColor(CairoColor.blue)
    ..selectFontFace('Arial')
    ..setFontSize(24)
    ..drawText('Blue text', 50, 200);
  
  canvas
    ..setColor(CairoColor.red)
    ..drawText('Red text', 200, 200);
  
  // Stroked text (outline)
  canvas
    ..setColor(CairoColor.fromHex(0x006400)) // Dark green
    ..selectFontFace('Arial', weight: FontWeight.bold)
    ..setFontSize(40)
    ..moveTo(50, 260)
    ..textPath('Outlined Text')
    ..setLineWidth(2)
    ..stroke();
  
  canvas.saveToPng('text_example.png');
  canvas.dispose();
  
  print('  -> text_example.png created');
}

/// Example 3: SVG path rendering
void svgPathExample() {
  print('Creating svg_path.png...');
  
  final canvas = cairo.createCanvas(400, 400);
  canvas.clear(CairoColor.white);
  
  final svg = canvas.svg;
  
  // Heart shape (SVG path)
  const heartPath = 'M 200,100 '
      'C 200,50 150,50 100,100 '
      'C 50,150 50,200 100,250 '
      'L 200,350 '
      'L 300,250 '
      'C 350,200 350,150 300,100 '
      'C 250,50 200,50 200,100 Z';
  
  svg.renderPath(
    heartPath,
    fill: CairoColor.red,
    stroke: CairoColor.fromHex(0x8B0000), // Dark red
    strokeWidth: 3,
  );
  
  // Star shape using SVG path
  canvas.translate(0, 0);
  final starPath = _createStarPath(320, 320, 50, 25, 5);
  svg.renderPath(
    starPath,
    fill: CairoColor.fromHex(0xFFD700), // Gold
    stroke: CairoColor.fromHex(0xDAA520), // Goldenrod
    strokeWidth: 2,
  );
  
  canvas.saveToPng('svg_path.png');
  canvas.dispose();
  
  print('  -> svg_path.png created');
}

/// Generate a star SVG path
String _createStarPath(double cx, double cy, double outerR, double innerR, int points) {
  final path = StringBuffer();
  final angleStep = math.pi / points;
  
  for (var i = 0; i < points * 2; i++) {
    final r = i.isEven ? outerR : innerR;
    final angle = i * angleStep - math.pi / 2;
    final x = cx + r * math.cos(angle);
    final y = cy + r * math.sin(angle);
    
    if (i == 0) {
      path.write('M $x,$y ');
    } else {
      path.write('L $x,$y ');
    }
  }
  path.write('Z');
  
  return path.toString();
}

/// Example 4: Complex drawing with transformations
void complexDrawingExample() {
  print('Creating complex_drawing.png...');
  
  final canvas = cairo.createCanvas(500, 500);
  canvas.clear(CairoColor.fromHex(0xF0F0F0)); // Light gray
  
  // Draw a pattern of rotated squares
  canvas.save();
  canvas.translate(250, 250);
  
  for (var i = 0; i < 12; i++) {
    final hue = i / 12.0;
    final color = _hsvToRgb(hue, 0.8, 0.9);
    
    canvas
      ..setColor(color)
      ..setLineWidth(2)
      ..strokeRect(-80, -80, 160, 160)
      ..rotate(math.pi / 6); // 30 degrees
  }
  
  canvas.restore();
  
  // Draw concentric circles
  canvas.save();
  canvas.translate(250, 250);
  
  for (var i = 10; i > 0; i--) {
    final hue = i / 10.0;
    final color = _hsvToRgb(hue, 0.5, 1.0);
    
    canvas
      ..setColor(color)
      ..fillCircle(0, 0, i * 20.0);
  }
  
  canvas.restore();
  
  // Add title
  canvas
    ..setColor(CairoColor.black)
    ..selectFontFace('Arial', weight: FontWeight.bold)
    ..setFontSize(20)
    ..drawText('Complex Drawing Example', 130, 480);
  
  canvas.saveToPng('complex_drawing.png');
  canvas.dispose();
  
  print('  -> complex_drawing.png created');
}

/// Convert HSV to CairoColor
CairoColor _hsvToRgb(double h, double s, double v) {
  final i = (h * 6).floor();
  final f = h * 6 - i;
  final p = v * (1 - s);
  final q = v * (1 - f * s);
  final t = v * (1 - (1 - f) * s);
  
  double r, g, b;
  switch (i % 6) {
    case 0:
      r = v; g = t; b = p;
    case 1:
      r = q; g = v; b = p;
    case 2:
      r = p; g = v; b = t;
    case 3:
      r = p; g = q; b = v;
    case 4:
      r = t; g = p; b = v;
    case 5:
    default:
      r = v; g = p; b = q;
  }
  
  return CairoColor(r, g, b);
}
