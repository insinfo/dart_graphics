/// Example demonstrating the Canvas API (similar to HTML5 Canvas)
///
/// This example shows how to use the JavaScript-style Canvas API built on Skia.

import 'package:agg/canvas.dart';

void main() {
  print('Canvas API Demo');
  print('═══════════════════════════════════════\n');

  // Initialize Skia
  final skia = Skia();
  
  // Create a 800x600 canvas
  final canvas = Canvas(skia, 800, 600);
  final ctx = canvas.getContext('2d');

  // Example 1: Fill the background
  print('Drawing background...');
  ctx.fillStyle = '#F0F0F0';
  ctx.fillRect(0, 0, 800, 600);

  // Example 2: Draw rectangles
  print('Drawing rectangles...');
  ctx.fillStyle = '#FF0000';
  ctx.fillRect(50, 50, 200, 100);

  ctx.strokeStyle = '#0000FF';
  ctx.lineWidth = 5.0;
  ctx.strokeRect(300, 50, 200, 100);

  // Example 3: Draw a circle
  print('Drawing circle...');
  ctx.fillStyle = '#00FF00';
  ctx.beginPath();
  ctx.arc(150, 300, 80, 0, 2 * 3.14159);
  ctx.fill();

  // Example 4: Draw a stroked circle
  print('Drawing stroked circle...');
  ctx.strokeStyle = '#FF00FF';
  ctx.lineWidth = 4.0;
  ctx.beginPath();
  ctx.arc(400, 300, 80, 0, 2 * 3.14159);
  ctx.stroke();

  // Example 5: Draw paths
  print('Drawing path...');
  ctx.beginPath();
  ctx.moveTo(550, 200);
  ctx.lineTo(650, 250);
  ctx.lineTo(600, 350);
  ctx.closePath();
  ctx.fillStyle = '#FFAA00';
  ctx.fill();

  // Example 6: Draw text
  print('Drawing text...');
  ctx.fillStyle = '#000000';
  ctx.font = '48px sans-serif';
  ctx.fillText('Hello Canvas!', 50, 500);

  // Example 7: Use transformations
  print('Drawing with transformations...');
  ctx.save();
  ctx.translate(650, 500);
  ctx.rotate(0.5); // Rotate 0.5 radians
  ctx.fillStyle = '#0088FF';
  ctx.fillRect(-30, -30, 60, 60);
  ctx.restore();

  // Example 8: Draw bezier curves
  print('Drawing curves...');
  ctx.strokeStyle = '#AA00AA';
  ctx.lineWidth = 3.0;
  ctx.beginPath();
  ctx.moveTo(50, 550);
  ctx.bezierCurveTo(100, 500, 200, 600, 250, 550);
  ctx.stroke();

  // Example 9: Draw quadratic curve
  print('Drawing quadratic curve...');
  ctx.strokeStyle = '#00AAAA';
  ctx.lineWidth = 3.0;
  ctx.beginPath();
  ctx.moveTo(300, 550);
  ctx.quadraticCurveTo(400, 500, 500, 550);
  ctx.stroke();

  // Example 10: Clear a region
  print('Clearing a region...');
  ctx.clearRect(550, 450, 100, 50);

  // Example 11: Use line styles
  print('Drawing with line styles...');
  ctx.strokeStyle = '#FF0000';
  ctx.lineWidth = 10.0;
  ctx.lineCap = 'round';
  ctx.lineJoin = 'round';
  ctx.beginPath();
  ctx.moveTo(600, 100);
  ctx.lineTo(650, 150);
  ctx.lineTo(700, 100);
  ctx.stroke();

  // Example 12: Draw ellipse
  print('Drawing ellipse...');
  ctx.fillStyle = '#8800FF';
  ctx.beginPath();
  ctx.ellipse(700, 300, 60, 40, 0.5, 0, 2 * 3.14159);
  ctx.fill();

  // Example 13: Use global alpha
  print('Drawing with transparency...');
  ctx.globalAlpha = 0.5;
  ctx.fillStyle = '#FFFF00';
  ctx.fillRect(100, 450, 150, 100);
  ctx.globalAlpha = 1.0;

  // Save to file (not yet implemented)
  print('\nCanvas demo complete!');
  // Note: PNG encoding not yet implemented
  // canvas.savePng('canvas_demo.png');

  // Alternative: Get as data URL
  final dataUrl = canvas.toDataURL('image/png');
  print('Data URL: $dataUrl');

  // Clean up
  ctx.dispose();
  canvas.dispose();

  print('\n✓ Canvas demo completed!');
  print('  Output: canvas_demo.png');
}
