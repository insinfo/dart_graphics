/// Skia Canvas 2D Example
///
/// This example demonstrates the HTML5-style Canvas 2D API for Skia.
/// It shows how to create a canvas, draw shapes, and save the result as PNG.
///
/// This example is aligned with the AGG and Cairo examples to show
/// the same visual output.

import 'dart:math' as math;
import 'package:dart_graphics/skia_canvas.dart';

void main() {
  print('Skia Canvas 2D API Example');
  print('=' * 40);

  // Initialize Skia
  final skia = Skia();

  // Create a canvas
  final canvas = Canvas(skia, 800, 600);
  final ctx = canvas.getContext('2d');

  // Clear with white background
  ctx.fillStyle = 'white';
  ctx.fillRect(0, 0, 800, 600);

  // ========================
  // 1. Drawing Rectangles
  // ========================
  print('1. Drawing rectangles...');

  // Filled rectangle (Red)
  ctx.fillStyle = '#FF0000';
  ctx.fillRect(50, 50, 100, 80);

  // Stroked rectangle (Blue)
  ctx.strokeStyle = '#0000FF';
  ctx.lineWidth = 3;
  ctx.strokeRect(200, 50, 100, 80);

  // Filled rectangle (Green)
  ctx.fillStyle = '#00FF00';
  ctx.fillRect(350, 50, 100, 80);

  // ========================
  // 2. Drawing Circles
  // ========================
  print('2. Drawing circles...');

  // Filled circle (Cyan)
  ctx.beginPath();
  ctx.arc(550, 90, 40, 0, 2 * math.pi);
  ctx.fillStyle = '#00FFFF';
  ctx.fill();

  // Stroked circle (Purple)
  ctx.beginPath();
  ctx.arc(650, 90, 40, 0, 2 * math.pi);
  ctx.strokeStyle = 'purple';
  ctx.lineWidth = 4;
  ctx.stroke();

  // ========================
  // 3. Drawing Paths - Triangles
  // ========================
  print('3. Drawing triangles...');

  // Filled triangle (Green)
  ctx.beginPath();
  ctx.fillStyle = '#2ECC71';
  ctx.moveTo(100, 180);
  ctx.lineTo(50, 300);
  ctx.lineTo(150, 300);
  ctx.closePath();
  ctx.fill();

  // Stroked triangle (Red)
  ctx.beginPath();
  ctx.strokeStyle = '#E74C3C';
  ctx.lineWidth = 3;
  ctx.moveTo(250, 180);
  ctx.lineTo(200, 300);
  ctx.lineTo(300, 300);
  ctx.closePath();
  ctx.stroke();

  // ========================
  // 4. Drawing Arcs
  // ========================
  print('4. Drawing arcs...');

  // Filled circle (Teal)
  ctx.beginPath();
  ctx.fillStyle = '#1ABC9C';
  ctx.arc(400, 240, 60, 0, 2 * math.pi);
  ctx.fill();

  // Arc (pac-man shape - Yellow)
  ctx.beginPath();
  ctx.fillStyle = '#F1C40F';
  ctx.moveTo(530, 240);
  ctx.arc(530, 240, 50, 0.3, 2 * math.pi - 0.3);
  ctx.closePath();
  ctx.fill();

  // ========================
  // 5. Drawing Star
  // ========================
  print('5. Drawing star...');

  ctx.beginPath();
  final starCenterX = 100.0;
  final starCenterY = 420.0;
  final outerRadius = 50.0;
  final innerRadius = 25.0;

  for (int i = 0; i < 10; i++) {
    final angle = i * math.pi / 5 - math.pi / 2;
    final radius = i.isEven ? outerRadius : innerRadius;
    final x = starCenterX + radius * math.cos(angle);
    final y = starCenterY + radius * math.sin(angle);

    if (i == 0) {
      ctx.moveTo(x, y);
    } else {
      ctx.lineTo(x, y);
    }
  }
  ctx.closePath();

  ctx.fillStyle = '#9B59B6'; // Purple
  ctx.fill();

  // ========================
  // 6. Bezier Curves
  // ========================
  print('6. Drawing bezier curves...');

  // Quadratic bezier curve
  ctx.beginPath();
  ctx.strokeStyle = '#00BCD4'; // Cyan
  ctx.lineWidth = 4;
  ctx.moveTo(200, 380);
  ctx.quadraticCurveTo(275, 320, 350, 420);
  ctx.stroke();

  // ========================
  // 7. Rounded Rectangle
  // ========================
  print('7. Drawing rounded rectangle...');

  // Draw rounded rectangle manually
  final rx = 400.0;
  final ry = 350.0;
  final rw = 120.0;
  final rh = 80.0;
  final rr = 15.0;
  
  ctx.beginPath();
  ctx.moveTo(rx + rr, ry);
  ctx.lineTo(rx + rw - rr, ry);
  ctx.arc(rx + rw - rr, ry + rr, rr, -math.pi / 2, 0);
  ctx.lineTo(rx + rw, ry + rh - rr);
  ctx.arc(rx + rw - rr, ry + rh - rr, rr, 0, math.pi / 2);
  ctx.lineTo(rx + rr, ry + rh);
  ctx.arc(rx + rr, ry + rh - rr, rr, math.pi / 2, math.pi);
  ctx.lineTo(rx, ry + rr);
  ctx.arc(rx + rr, ry + rr, rr, math.pi, 3 * math.pi / 2);
  ctx.closePath();
  
  ctx.fillStyle = '#FF9800'; // Orange
  ctx.fill();

  // ========================
  // 8. Dashed Line
  // ========================
  print('8. Drawing dashed line...');

  ctx.setLineDash([10, 5]);
  ctx.strokeStyle = '#607D8B';
  ctx.lineWidth = 2;
  ctx.beginPath();
  ctx.moveTo(50, 520);
  ctx.lineTo(550, 520);
  ctx.stroke();
  ctx.setLineDash([]);

  // ========================
  // 9. Save and Transform
  // ========================
  print('9. Using save/restore and transforms...');

  ctx.save();
  ctx.translate(650, 400);
  ctx.rotate(math.pi / 6);
  ctx.fillStyle = 'rgba(128, 0, 128, 0.7)';
  ctx.fillRect(-50, -30, 100, 60);
  ctx.restore();

  // ========================
  // Save the result
  // ========================
  print('\n' + '=' * 40);
  print('Saving canvas...');

  canvas.savePng('skia_canvas2d_example.png');

  print('Example completed! Check skia_canvas2d_example.png');
  print('\nCanvas info:');
  print('  Size: `${canvas.width} x `${canvas.height}');

  // Clean up
  ctx.dispose();
  canvas.dispose();
}
