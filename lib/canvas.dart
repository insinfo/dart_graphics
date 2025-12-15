/// JavaScript-style Canvas API for Dart using Skia
///
/// This library provides a Canvas API similar to HTML5 Canvas, built on top
/// of the Skia graphics library.
///
/// ## Features
/// - JavaScript-style Canvas 2D API
/// - Path drawing (lines, curves, arcs, ellipses)
/// - Fill and stroke operations
/// - Transformations (translate, rotate, scale)
/// - Gradients (linear, radial, conic)
/// - Text rendering
/// - Image export (PNG, JPEG, WebP)
///
/// ## Example
///
/// ```dart
/// import 'package:agg/canvas.dart';
///
/// void main() {
///   // Create a 800x600 canvas
///   final canvas = Canvas(800, 600);
///   final ctx = canvas.getContext('2d')!;
///
///   // Draw a red rectangle
///   ctx.fillStyle = '#FF0000';
///   ctx.fillRect(50, 50, 200, 100);
///
///   // Draw a blue circle
///   ctx.fillStyle = '#0000FF';
///   ctx.beginPath();
///   ctx.arc(400, 300, 80, 0, 2 * 3.14159);
///   ctx.fill();
///
///   // Draw text with gradient
///   final gradient = ctx.createLinearGradient(100, 200, 300, 200);
///   gradient.addColorStop(0, '#FF0000');
///   gradient.addColorStop(1, '#0000FF');
///   ctx.fillStyle = gradient;
///   ctx.font = '48px sans-serif';
///   ctx.fillText('Hello Canvas!', 100, 200);
///
///   // Save to file
///   canvas.save('output.png');
///
///   // Clean up
///   ctx.dispose();
///   canvas.dispose();
/// }
/// ```
///
/// ## Requirements
///
/// The SkiaSharp native library must be available:
/// - **Windows**: `libSkiaSharp.dll` in PATH or current directory
/// - **Linux**: `libSkiaSharp.so`
/// - **macOS**: `libSkiaSharp.dylib`
library canvas;

// Core canvas classes
export 'src/skia/canvas/canvas.dart';
export 'src/skia/canvas/canvas_rendering_context_2d.dart';
export 'src/skia/canvas/canvas_gradient.dart';
export 'src/skia/canvas/canvas_pattern.dart';
export 'src/skia/canvas/path_2d.dart';

// Underlying Skia primitives (for advanced usage)
export 'src/skia/skia_api.dart';
export 'src/skia/sk_color.dart';
export 'src/skia/sk_geometry.dart';
