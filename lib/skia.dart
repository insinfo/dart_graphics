/// Skia bindings for Dart.
///
/// This library provides Dart bindings to the SkiaSharp native library,
/// which is a cross-platform 2D graphics API based on Google's Skia.
///
/// ## Getting Started
///
/// ```dart
/// import 'package:dart_graphics/skia.dart';
///
/// void main() {
///   // Create Skia instance (optionally with custom DLL path)
///   final skia = Skia();
///   // or: final skia = Skia(libraryPath: 'path/to/libSkiaSharp.dll');
///
///   // Create a surface to draw on
///   final surface = skia.createSurface(800, 600);
///   if (surface == null) {
///     print('Failed to create surface');
///     return;
///   }
///
///   // Get the canvas from the surface
///   final canvas = surface.canvas;
///
///   // Clear with white
///   canvas.clear(SKColors.white);
///
///   // Create a paint for drawing
///   final paint = skia.createPaint()
///     ..color = SKColors.red
///     ..isAntialias = true
///     ..style = PaintStyle.fill;
///
///   // Draw a circle
///   canvas.drawCircle(400, 300, 100, paint);
///
///   // Create a snapshot
///   final image = surface.snapshot();
///
///   // Clean up
///   paint.dispose();
///   image?.dispose();
///   surface.dispose();
/// }
/// ```
///
/// ## Requirements
///
/// The SkiaSharp native library must be installed:
/// - **Windows**: `libSkiaSharp.dll` in PATH or current directory
/// - **Linux**: `libSkiaSharp.so` in LD_LIBRARY_PATH or current directory
/// - **macOS**: `libSkiaSharp.dylib` in DYLD_LIBRARY_PATH or current directory
library skia;

// Main API facade
export 'src/skia/skia_api.dart';

// Primitives (colors and geometry are standalone, no bindings dependency)
export 'src/skia/sk_color.dart';
export 'src/skia/sk_geometry.dart';

// SVG support
export 'src/skia/svg/svg.dart';

// Generated bindings (for advanced use)
export 'src/skia/generated/skiasharp_bindings.dart' show SkiaSharpBindings;
export 'src/skia/generated/skiasharp_enums.dart' hide SKAlphaType, SKTextEncoding;
