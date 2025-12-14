/// Cairo Graphics Library for Dart
/// 
/// A high-level API for 2D graphics using the Cairo library.
/// 
/// ## Features
/// - Simple drawing API (lines, curves, shapes)
/// - Text rendering
/// - SVG path parsing and rendering
/// - Gradients (linear, radial)
/// - PNG output
/// 
/// ## Example
/// 
/// ```dart
/// import 'package:agg/cairo.dart';
/// 
/// void main() {
///   // Create a 400x400 canvas
///   final canvas = CairoCanvas(400, 400);
///   
///   // Clear with white background
///   canvas.clear(CairoColor.white);
///   
///   // Draw a red circle
///   canvas
///     ..setColor(CairoColor.red)
///     ..fillCircle(200, 200, 100);
///   
///   // Draw blue text
///   canvas
///     ..setColor(CairoColor.blue)
///     ..selectFontFace('Arial', weight: FontWeight.bold)
///     ..setFontSize(24)
///     ..drawText('Hello Cairo!', 150, 350);
///   
///   // Save to PNG
///   canvas.saveToPng('output.png');
///   
///   // Clean up
///   canvas.dispose();
/// }
/// ```
/// 
/// ## Requirements
/// 
/// The Cairo native library must be installed:
/// - **Windows**: `libcairo-2.dll` or `cairo.dll` in PATH or current directory
/// - **Linux**: `libcairo.so.2` (install via `apt install libcairo2`)
/// - **macOS**: `libcairo.dylib` (install via `brew install cairo`)
library cairo;

export 'src/cairo/cairo.dart';
export 'src/cairo/cairo_pattern.dart';
export 'src/cairo/cairo_svg.dart';
