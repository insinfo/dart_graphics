/// Skia-based Canvas 2D API
/// 
/// This module provides an HTML5 Canvas 2D-style API for drawing
/// operations using the Skia graphics library as the backend.
/// 
/// Based on the HTML5 Canvas 2D Context specification and inspired by
/// the skia-canvas project.
/// 
/// ## Example
/// 
/// ```dart
/// import 'package:dart_graphics/skia.dart';
/// import 'package:dart_graphics/canvas.dart';
/// 
/// void main() {
///   // Create a Skia instance
///   final skia = Skia();
///   
///   // Create a canvas
///   final canvas = Canvas(skia, 800, 600);
///   final ctx = canvas.getContext('2d');
///   
///   // Draw a red rectangle
///   ctx.fillStyle = '#ff0000';
///   ctx.fillRect(50, 50, 200, 100);
///   
///   // Draw a stroked circle
///   ctx.strokeStyle = 'blue';
///   ctx.lineWidth = 3;
///   ctx.beginPath();
///   ctx.arc(400, 300, 75, 0, 2 * 3.14159);
///   ctx.stroke();
///   
///   // Save to PNG
///   canvas.saveAs('output.png');
/// }
/// ```
library;

export 'canvas.dart';
export 'canvas_rendering_context_2d.dart';
export 'canvas_gradient.dart';
export 'canvas_pattern.dart';
export 'path_2d.dart';
