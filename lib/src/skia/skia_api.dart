/// Skia API Facade - Main entry point for Skia graphics library
///
/// This class is the main entry point for the Skia library. It manages the
/// native library bindings and provides factory methods for creating all
/// Skia objects.
///
/// Example:
/// ```dart
/// // Default library path
/// final skia = Skia();
///
/// // Or with custom library path
/// final skia = Skia(libraryPath: 'path/to/libSkiaSharp.dll');
///
/// // Create surfaces and canvases
/// final surface = skia.createSurface(800, 600);
/// final canvas = surface.canvas;
/// canvas
///   ..clear(SKColors.white)
///   ..drawCircle(400, 300, 100, skia.createPaint()..color = SKColors.red);
/// surface.dispose();
/// ```

import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as ffi_alloc;

import 'generated/skiasharp_bindings.dart';
import 'sk_color.dart';
import 'sk_geometry.dart';

/// Main Skia API facade class
///
/// This is the single entry point for Skia functionality. All Skia objects
/// (surfaces, canvases, paints, fonts) should be created through this class.
class Skia {
  final SkiaSharpBindings _bindings;

  /// Create a Skia instance
  ///
  /// [libraryPath] - Optional path to the Skia library (DLL/so/dylib).
  /// If not provided, the library will be loaded from the default system path.
  Skia({String? libraryPath}) : _bindings = _loadSkiaSharp(libraryPath);

  /// Get the underlying bindings (for advanced use only)
  SkiaSharpBindings get bindings => _bindings;

  /// Load the SkiaSharp native library
  static SkiaSharpBindings _loadSkiaSharp(String? libraryPath) {
    // If a specific path is provided, try it first
    if (libraryPath != null) {
      try {
        return SkiaSharpBindings(ffi.DynamicLibrary.open(libraryPath));
      } catch (e) {
        throw UnsupportedError(
            'Could not load SkiaSharp library from: $libraryPath. Error: $e');
      }
    }

    // Otherwise, try common locations
    if (Platform.isWindows) {
      final possiblePaths = [
        'libSkiaSharp.dll',
        'native/libs/skiasharp/win-x64/libSkiaSharp.dll',
        '${Directory.current.path}/libSkiaSharp.dll',
        '${Directory.current.path}/native/libs/skiasharp/win-x64/libSkiaSharp.dll',
      ];

      for (final path in possiblePaths) {
        try {
          return SkiaSharpBindings(ffi.DynamicLibrary.open(path));
        } catch (_) {
          continue;
        }
      }
      throw UnsupportedError(
          'Could not find SkiaSharp library. Please ensure libSkiaSharp.dll is in your PATH or current directory.');
    } else if (Platform.isLinux) {
      final possiblePaths = [
        'libSkiaSharp.so',
        'native/libs/skiasharp/linux-x64/libSkiaSharp.so',
        '${Directory.current.path}/libSkiaSharp.so',
        '${Directory.current.path}/native/libs/skiasharp/linux-x64/libSkiaSharp.so',
      ];

      for (final path in possiblePaths) {
        try {
          return SkiaSharpBindings(ffi.DynamicLibrary.open(path));
        } catch (_) {
          continue;
        }
      }
      throw UnsupportedError(
          'Could not find SkiaSharp library. Please ensure libSkiaSharp.so is available.');
    } else if (Platform.isMacOS) {
      final possiblePaths = [
        'libSkiaSharp.dylib',
        'native/libs/skiasharp/osx-x64/libSkiaSharp.dylib',
        '${Directory.current.path}/libSkiaSharp.dylib',
        '${Directory.current.path}/native/libs/skiasharp/osx-x64/libSkiaSharp.dylib',
      ];

      for (final path in possiblePaths) {
        try {
          return SkiaSharpBindings(ffi.DynamicLibrary.open(path));
        } catch (_) {
          continue;
        }
      }
      throw UnsupportedError(
          'Could not find SkiaSharp library. Please ensure libSkiaSharp.dylib is available.');
    } else {
      throw UnsupportedError('SkiaSharp is not supported on this platform');
    }
  }


  /// Create a new raster surface with the specified dimensions
  SkiaSurface? createSurface(
    int width,
    int height, {
    int colorType = ColorType.rgba8888,
  }) {
    if (width <= 0 || height <= 0) return null;

    final info = ffi_alloc.calloc<_SKImageInfoNative>();
    try {
      info.ref.width = width;
      info.ref.height = height;
      info.ref.colorType = colorType;
      info.ref.alphaType = AlphaType.premul;
      info.ref.colorspace = ffi.nullptr;

      final handle = _bindings.sk_surface_new_raster(
        info.cast<ffi.Void>(),
        ffi.nullptr,
        ffi.nullptr,
      );

      if (handle == ffi.nullptr) return null;
      return SkiaSurface._(this, handle, width, height);
    } finally {
      ffi_alloc.calloc.free(info);
    }
  }

  /// Create a null surface (for measurements)
  SkiaSurface? createNullSurface(int width, int height) {
    final handle = _bindings.sk_surface_new_null(width, height);
    if (handle == ffi.nullptr) return null;
    return SkiaSurface._(this, handle, width, height);
  }

  // ==================== Paint Creation ====================

  /// Create a new paint with default settings
  SkiaPaint createPaint() {
    final handle = _bindings.sk_paint_new();
    return SkiaPaint._(this, handle);
  }

  // ==================== Font Creation ====================

  /// Create a new font with default settings
  SkiaFont createFont() {
    final handle = _bindings.sk_font_new();
    return SkiaFont._(this, handle);
  }

  /// Create a font from a typeface
  SkiaFont createFontFromTypeface(
    SkiaTypeface typeface, {
    double size = 12,
    double scaleX = 1,
    double skewX = 0,
  }) {
    final handle = _bindings.sk_font_new_with_values(
      typeface._handle,
      size,
      scaleX,
      skewX,
    );
    return SkiaFont._(this, handle);
  }

  // ==================== Shader Creation ====================

  /// Create a linear gradient shader
  /// [points] array of 2 points: start and end
  /// [colors] array of ARGB color values
  /// [positions] optional array of color stop positions (0-1), or null for even distribution
  /// [tileMode] how to tile the gradient (clamp, repeat, mirror, decal)
  ffi.Pointer<ffi.Void> createLinearGradientShader(
    List<SKPoint> points,
    List<int> colors,
    List<double>? positions, {
    int tileMode = 0, // 0 = clamp
  }) {
    if (points.length < 2) {
      throw ArgumentError('Linear gradient requires at least 2 points');
    }
    if (colors.length < 2) {
      throw ArgumentError('Gradient requires at least 2 colors');
    }
    
    // Allocate points array (2 points, each with x,y floats)
    final pointsPtr = ffi_alloc.calloc<ffi.Float>(4);
    pointsPtr[0] = points[0].x;
    pointsPtr[1] = points[0].y;
    pointsPtr[2] = points[1].x;
    pointsPtr[3] = points[1].y;
    
    // Allocate colors array
    final colorsPtr = ffi_alloc.calloc<ffi.Uint32>(colors.length);
    for (int i = 0; i < colors.length; i++) {
      colorsPtr[i] = colors[i];
    }
    
    // Allocate positions array
    ffi.Pointer<ffi.Float> posPtr = ffi.nullptr.cast();
    if (positions != null && positions.length == colors.length) {
      posPtr = ffi_alloc.calloc<ffi.Float>(positions.length);
      for (int i = 0; i < positions.length; i++) {
        posPtr[i] = positions[i];
      }
    }
    
    try {
      return _bindings.sk_shader_new_linear_gradient(
        pointsPtr.cast(),
        colorsPtr,
        posPtr,
        colors.length,
        tileMode,
        ffi.nullptr, // no local matrix
      );
    } finally {
      ffi_alloc.calloc.free(pointsPtr);
      ffi_alloc.calloc.free(colorsPtr);
      if (posPtr != ffi.nullptr.cast()) {
        ffi_alloc.calloc.free(posPtr);
      }
    }
  }
  
  /// Create a radial gradient shader
  /// [center] center point of the gradient
  /// [radius] radius of the gradient
  /// [colors] array of ARGB color values
  /// [positions] optional array of color stop positions (0-1)
  ffi.Pointer<ffi.Void> createRadialGradientShader(
    SKPoint center,
    double radius,
    List<int> colors,
    List<double>? positions, {
    int tileMode = 0,
  }) {
    if (colors.length < 2) {
      throw ArgumentError('Gradient requires at least 2 colors');
    }
    
    // Allocate center point
    final centerPtr = ffi_alloc.calloc<ffi.Float>(2);
    centerPtr[0] = center.x;
    centerPtr[1] = center.y;
    
    // Allocate colors array
    final colorsPtr = ffi_alloc.calloc<ffi.Uint32>(colors.length);
    for (int i = 0; i < colors.length; i++) {
      colorsPtr[i] = colors[i];
    }
    
    // Allocate positions array
    ffi.Pointer<ffi.Float> posPtr = ffi.nullptr.cast();
    if (positions != null && positions.length == colors.length) {
      posPtr = ffi_alloc.calloc<ffi.Float>(positions.length);
      for (int i = 0; i < positions.length; i++) {
        posPtr[i] = positions[i];
      }
    }
    
    try {
      return _bindings.sk_shader_new_radial_gradient(
        centerPtr.cast(),
        radius,
        colorsPtr,
        posPtr,
        colors.length,
        tileMode,
        ffi.nullptr,
      );
    } finally {
      ffi_alloc.calloc.free(centerPtr);
      ffi_alloc.calloc.free(colorsPtr);
      if (posPtr != ffi.nullptr.cast()) {
        ffi_alloc.calloc.free(posPtr);
      }
    }
  }
  
  /// Create a sweep (conic) gradient shader
  /// [center] center point of the gradient
  /// [colors] array of ARGB color values
  /// [positions] optional array of color stop positions (0-1)
  /// [startAngle] starting angle in degrees
  /// [endAngle] ending angle in degrees
  ffi.Pointer<ffi.Void> createSweepGradientShader(
    SKPoint center,
    List<int> colors,
    List<double>? positions, {
    double startAngle = 0,
    double endAngle = 360,
    int tileMode = 0,
  }) {
    if (colors.length < 2) {
      throw ArgumentError('Gradient requires at least 2 colors');
    }
    
    // Allocate center point
    final centerPtr = ffi_alloc.calloc<ffi.Float>(2);
    centerPtr[0] = center.x;
    centerPtr[1] = center.y;
    
    // Allocate colors array
    final colorsPtr = ffi_alloc.calloc<ffi.Uint32>(colors.length);
    for (int i = 0; i < colors.length; i++) {
      colorsPtr[i] = colors[i];
    }
    
    // Allocate positions array
    ffi.Pointer<ffi.Float> posPtr = ffi.nullptr.cast();
    if (positions != null && positions.length == colors.length) {
      posPtr = ffi_alloc.calloc<ffi.Float>(positions.length);
      for (int i = 0; i < positions.length; i++) {
        posPtr[i] = positions[i];
      }
    }
    
    try {
      return _bindings.sk_shader_new_sweep_gradient(
        centerPtr.cast(),
        colorsPtr,
        posPtr,
        colors.length,
        tileMode,
        startAngle,
        endAngle,
        ffi.nullptr,
      );
    } finally {
      ffi_alloc.calloc.free(centerPtr);
      ffi_alloc.calloc.free(colorsPtr);
      if (posPtr != ffi.nullptr.cast()) {
        ffi_alloc.calloc.free(posPtr);
      }
    }
  }
  
  /// Delete a shader
  void deleteShader(ffi.Pointer<ffi.Void> shader) {
    if (shader != ffi.nullptr) {
      _bindings.sk_shader_unref(shader);
    }
  }

  // ==================== Typeface Creation ====================

  /// Load a typeface from a font file
  SkiaTypeface? loadTypeface(String path, {int index = 0}) {
    final pathPtr = path.toNativeUtf8(allocator: ffi_alloc.calloc);
    try {
      final handle = _bindings.sk_typeface_create_from_file(
        pathPtr.cast<ffi.Void>(),
        index,
      );
      if (handle == ffi.nullptr) return null;
      return SkiaTypeface._(this, handle);
    } finally {
      ffi_alloc.calloc.free(pathPtr);
    }
  }

  /// Create the default typeface
  SkiaTypeface? createDefaultTypeface() {
    final handle = _bindings.sk_typeface_create_default();
    if (handle == ffi.nullptr) return null;
    return SkiaTypeface._(this, handle);
  }

  /// Create a typeface from a font family name
  /// 
  /// [familyName] - The font family name (e.g., "Arial", "Times New Roman")
  /// [weight] - Font weight (100-900, 400 is normal, 700 is bold)
  /// [width] - Font width (1-9, 5 is normal)  
  /// [slant] - Font slant (0 = upright, 1 = italic, 2 = oblique)
  SkiaTypeface? createTypefaceFromFamilyName(String familyName, {
    int weight = 400,
    int width = 5,
    int slant = 0,
  }) {
    // Create font style
    final styleHandle = _bindings.sk_fontstyle_new(weight, width, slant);
    if (styleHandle == ffi.nullptr) return null;
    
    final familyPtr = familyName.toNativeUtf8(allocator: ffi_alloc.calloc);
    try {
      // Get the default font manager
      final fontMgr = _bindings.sk_fontmgr_ref_default();
      if (fontMgr == ffi.nullptr) {
        _bindings.sk_fontstyle_delete(styleHandle);
        return null;
      }
      
      // Match the family and style
      final handle = _bindings.sk_fontmgr_match_family_style(
        fontMgr,
        familyPtr.cast(),
        styleHandle,
      );
      
      // Clean up
      _bindings.sk_fontstyle_delete(styleHandle);
      _bindings.sk_fontmgr_unref(fontMgr);
      
      if (handle == ffi.nullptr) return null;
      return SkiaTypeface._(this, handle);
    } finally {
      ffi_alloc.calloc.free(familyPtr);
    }
  }

  // ==================== Path Creation ====================

  /// Create a new empty path
  SkiaPath createPath() {
    final handle = _bindings.sk_path_new();
    return SkiaPath._(this, handle);
  }

  // ==================== Bitmap Creation ====================

  /// Create a new bitmap with the specified dimensions
  SkiaBitmap createBitmap(
    int width,
    int height, {
    int colorType = ColorType.rgba8888,
  }) {
    final handle = _bindings.sk_bitmap_new();
    if (handle == ffi.nullptr) {
      throw Exception('Failed to create bitmap');
    }

    final info = ffi_alloc.calloc<_SKImageInfoNative>();
    try {
      info.ref.width = width;
      info.ref.height = height;
      info.ref.colorType = colorType;
      info.ref.alphaType = AlphaType.premul;
      info.ref.colorspace = ffi.nullptr;

      final success = _bindings.sk_bitmap_try_alloc_pixels(
        handle,
        info.cast<ffi.Void>(),
        ffi.nullptr,
      );

      if (!success) {
        _bindings.sk_bitmap_destructor(handle);
        throw Exception('Failed to allocate bitmap pixels');
      }

      return SkiaBitmap._(this, handle, width, height);
    } finally {
      ffi_alloc.calloc.free(info);
    }
  }
}

// ==================== Internal Types ====================

/// Native struct for SKImageInfo
final class _SKImageInfoNative extends ffi.Struct {
  external ffi.Pointer<ffi.Void> colorspace;

  @ffi.Int32()
  external int width;

  @ffi.Int32()
  external int height;

  @ffi.Int32()
  external int colorType;

  @ffi.Int32()
  external int alphaType;
}

/// Native struct for SKPngEncoderOptions
final class _SKPngEncoderOptions extends ffi.Struct {
  @ffi.Int32()
  external int fFilterFlags;  // SKPngEncoderFilterFlags
  
  @ffi.Int32()
  external int fZLibLevel;
  
  external ffi.Pointer<ffi.Void> fComments;
  
  external ffi.Pointer<ffi.Void> fICCProfile;
  
  external ffi.Pointer<ffi.Void> fICCProfileDescription;
}

// ==================== Skia Surface ====================

/// A drawing surface backed by pixels
class SkiaSurface {
  final Skia skia;
  final ffi.Pointer<ffi.Void> _handle;
  final int width;
  final int height;
  bool _disposed = false;
  SkiaCanvas? _canvas;

  SkiaSurface._(this.skia, this._handle, this.width, this.height);

  /// Get the Cairo bindings
  SkiaSharpBindings get _bindings => skia._bindings;

  /// Get the raw pointer (for advanced use)
  ffi.Pointer<ffi.Void> get handle => _handle;

  /// Get the canvas for drawing on this surface
  SkiaCanvas get canvas {
    _checkDisposed();
    _canvas ??= SkiaCanvas._(
      skia,
      _bindings.sk_surface_get_canvas(_handle),
      owns: false,
    );
    return _canvas!;
  }

  /// Create a snapshot of the current surface as an image
  SkiaImage? snapshot() {
    _checkDisposed();
    final imageHandle = _bindings.sk_surface_new_image_snapshot(_handle);
    if (imageHandle == ffi.nullptr) return null;
    return SkiaImage._(skia, imageHandle);
  }

  /// Dispose the surface
  void dispose() {
    if (!_disposed) {
      _canvas = null;
      _bindings.sk_surface_unref(_handle);
      _disposed = true;
    }
  }

  bool get isDisposed => _disposed;

  void _checkDisposed() {
    if (_disposed) throw StateError('SkiaSurface has been disposed');
  }
}

// ==================== Skia Canvas ====================

/// Provides methods for drawing content to a surface
class SkiaCanvas {
  final Skia skia;
  final ffi.Pointer<ffi.Void> _handle;
  final bool _owns;
  bool _disposed = false;

  SkiaCanvas._(this.skia, this._handle, {bool owns = false}) : _owns = owns;

  SkiaSharpBindings get _bindings => skia._bindings;

  ffi.Pointer<ffi.Void> get handle => _handle;

  // ==================== Clear & Color ====================

  /// Clear the entire canvas with the specified color
  void clear(SKColor color) {
    _checkDisposed();
    _bindings.sk_canvas_clear(_handle, color.value);
  }

  /// Clear the canvas with transparent color
  void clearTransparent() {
    clear(SKColors.transparent);
  }

  /// Draw a filled color over the entire canvas
  void drawColor(SKColor color, [BlendMode blendMode = BlendMode.srcOver]) {
    _checkDisposed();
    _bindings.sk_canvas_draw_color(_handle, color.value, blendMode.index);
  }

  // ==================== Save/Restore ====================

  /// Save the current transformation matrix
  int save() {
    _checkDisposed();
    return _bindings.sk_canvas_save(_handle);
  }

  /// Restore the previously saved transformation matrix
  void restore() {
    _checkDisposed();
    _bindings.sk_canvas_restore(_handle);
  }

  /// Restore to a specific save count
  void restoreToCount(int count) {
    _checkDisposed();
    _bindings.sk_canvas_restore_to_count(_handle, count);
  }

  /// Get the current save count
  int get saveCount {
    _checkDisposed();
    return _bindings.sk_canvas_get_save_count(_handle);
  }

  // ==================== Transformations ====================

  /// Translate the canvas
  void translate(double dx, double dy) {
    _checkDisposed();
    _bindings.sk_canvas_translate(_handle, dx, dy);
  }

  /// Scale the canvas
  void scale(double sx, [double? sy]) {
    _checkDisposed();
    _bindings.sk_canvas_scale(_handle, sx, sy ?? sx);
  }

  /// Rotate the canvas in degrees
  void rotateDegrees(double degrees) {
    _checkDisposed();
    _bindings.sk_canvas_rotate_degrees(_handle, degrees);
  }

  /// Rotate the canvas in radians
  void rotateRadians(double radians) {
    _checkDisposed();
    _bindings.sk_canvas_rotate_radians(_handle, radians);
  }
  
  /// Rotate the canvas (in degrees, for Canvas 2D API compatibility)
  void rotate(double degrees) {
    rotateDegrees(degrees);
  }

  /// Skew the canvas
  void skew(double sx, double sy) {
    _checkDisposed();
    _bindings.sk_canvas_skew(_handle, sx, sy);
  }

  /// Reset the transformation matrix to identity
  void resetMatrix() {
    _checkDisposed();
    _bindings.sk_canvas_reset_matrix(_handle);
  }

  /// Concatenate a 3x3 matrix with the current canvas transformation
  /// [matrix] should be a list of 9 floats in row-major order:
  /// [scaleX, skewX, transX, skewY, scaleY, transY, persp0, persp1, persp2]
  void concat(List<double> matrix) {
    _checkDisposed();
    if (matrix.length != 9) {
      throw ArgumentError('Matrix must have exactly 9 elements');
    }
    final nativeMatrix = ffi_alloc.calloc<ffi.Float>(9);
    try {
      for (int i = 0; i < 9; i++) {
        nativeMatrix[i] = matrix[i];
      }
      _bindings.sk_canvas_concat(_handle, nativeMatrix.cast());
    } finally {
      ffi_alloc.calloc.free(nativeMatrix);
    }
  }

  /// Concatenate a 2D affine transform [a, b, c, d, e, f] with the current transformation
  /// This converts the 2D transform to a 3x3 matrix
  void concat2D(double a, double b, double c, double d, double e, double f) {
    // Convert 2D affine transform to 3x3 matrix (row-major)
    // | a  c  e |
    // | b  d  f |
    // | 0  0  1 |
    concat([a, c, e, b, d, f, 0, 0, 1]);
  }

  // ==================== Drawing ====================

  /// Fill the canvas with the given paint
  void drawPaint(SkiaPaint paint) {
    _checkDisposed();
    _bindings.sk_canvas_draw_paint(_handle, paint._handle);
  }

  /// Draw a point
  void drawPoint(double x, double y, SkiaPaint paint) {
    _checkDisposed();
    _bindings.sk_canvas_draw_point(_handle, x, y, paint._handle);
  }

  /// Draw a line
  void drawLine(double x0, double y0, double x1, double y1, SkiaPaint paint) {
    _checkDisposed();
    _bindings.sk_canvas_draw_line(_handle, x0, y0, x1, y1, paint._handle);
  }

  /// Draw a circle
  void drawCircle(double cx, double cy, double radius, SkiaPaint paint) {
    _checkDisposed();
    _bindings.sk_canvas_draw_circle(_handle, cx, cy, radius, paint._handle);
  }

  /// Draw a rectangle
  void drawRect(SKRect rect, SkiaPaint paint) {
    _checkDisposed();
    final nativeRect = _allocSKRect(rect);
    try {
      _bindings.sk_canvas_draw_rect(_handle, nativeRect, paint._handle);
    } finally {
      _freeSKRect(nativeRect);
    }
  }

  /// Draw a rounded rectangle
  void drawRoundRect(SKRect rect, double rx, double ry, SkiaPaint paint) {
    _checkDisposed();
    final nativeRect = _allocSKRect(rect);
    try {
      _bindings.sk_canvas_draw_round_rect(
          _handle, nativeRect, rx, ry, paint._handle);
    } finally {
      _freeSKRect(nativeRect);
    }
  }

  /// Draw an oval
  void drawOval(SKRect rect, SkiaPaint paint) {
    _checkDisposed();
    final nativeRect = _allocSKRect(rect);
    try {
      _bindings.sk_canvas_draw_oval(_handle, nativeRect, paint._handle);
    } finally {
      _freeSKRect(nativeRect);
    }
  }

  /// Draw a path
  void drawPath(SkiaPath path, SkiaPaint paint) {
    _checkDisposed();
    _bindings.sk_canvas_draw_path(_handle, path._handle, paint._handle);
  }

  /// Clip to a path
  /// [clipOp] - 0 = difference, 1 = intersect (default)
  void clipPath(SkiaPath path, {bool doAntiAlias = false, int clipOp = 1}) {
    _checkDisposed();
    _bindings.sk_canvas_clip_path_with_operation(
      _handle,
      path._handle,
      ffi.Pointer.fromAddress(clipOp),
      doAntiAlias,
    );
  }

  /// Clip to a rectangle
  /// [clipOp] - 0 = difference, 1 = intersect (default)
  void clipRect(SKRect rect, {bool doAntiAlias = false, int clipOp = 1}) {
    _checkDisposed();
    final nativeRect = _allocSKRect(rect);
    try {
      _bindings.sk_canvas_clip_rect_with_operation(
        _handle,
        nativeRect,
        ffi.Pointer.fromAddress(clipOp),
        doAntiAlias,
      );
    } finally {
      _freeSKRect(nativeRect);
    }
  }

  /// Draw simple text
  void drawSimpleText(
    String text,
    double x,
    double y,
    SkiaFont font,
    SkiaPaint paint, {
    SKTextEncoding encoding = SKTextEncoding.utf8,
  }) {
    _checkDisposed();
    final textBytes = text.toNativeUtf8(allocator: ffi_alloc.calloc);
    try {
      _bindings.sk_canvas_draw_simple_text(
        _handle,
        textBytes.cast<ffi.Void>(),
        ffi.Pointer.fromAddress(text.length),
        encoding.index,
        x,
        y,
        font._handle,
        paint._handle,
      );
    } finally {
      ffi_alloc.calloc.free(textBytes);
    }
  }

  /// Draw an image at the specified position
  void drawImage(SkiaImage image, double x, double y, SkiaPaint paint) {
    _checkDisposed();
    _bindings.sk_canvas_draw_image(
      _handle,
      image._handle,
      x,
      y,
      ffi.nullptr, // sampling options
      paint._handle,
    );
  }

  /// Draw an image with source and destination rectangles
  void drawImageRect(SkiaImage image, SKRect srcRect, SKRect dstRect, SkiaPaint paint) {
    _checkDisposed();
    final src = _allocSKRect(srcRect);
    final dst = _allocSKRect(dstRect);
    try {
      _bindings.sk_canvas_draw_image_rect(
        _handle,
        image._handle,
        src,
        dst,
        ffi.nullptr, // sampling options
        paint._handle,
      );
    } finally {
      _freeSKRect(src);
      _freeSKRect(dst);
    }
  }

  void dispose() {
    if (!_disposed && _owns) {
      // Canvas is typically owned by surface, don't dispose
      _disposed = true;
    }
  }

  bool get isDisposed => _disposed;

  void _checkDisposed() {
    if (_disposed) throw StateError('SkiaCanvas has been disposed');
  }

  // Helper methods for SKRect
  ffi.Pointer<ffi.Void> _allocSKRect(SKRect rect) {
    final ptr = ffi_alloc.calloc<ffi.Float>(4);
    ptr[0] = rect.left;
    ptr[1] = rect.top;
    ptr[2] = rect.right;
    ptr[3] = rect.bottom;
    return ptr.cast();
  }

  void _freeSKRect(ffi.Pointer<ffi.Void> ptr) {
    ffi_alloc.calloc.free(ptr);
  }
}

// ==================== Skia Paint ====================

/// Paint style
enum PaintStyle { fill, stroke, strokeAndFill }

/// Stroke cap style
enum StrokeCap { butt, round, square }

/// Stroke join style
enum StrokeJoin { miter, round, bevel }

/// Blend mode
enum BlendMode {
  clear, src, dst, srcOver, dstOver, srcIn, dstIn, srcOut, dstOut,
  srcATop, dstATop, xor, plus, modulate, screen, overlay, darken,
  lighten, colorDodge, colorBurn, hardLight, softLight, difference,
  exclusion, multiply, hue, saturation, color, luminosity,
}

/// Text encoding
enum SKTextEncoding { utf8, utf16, utf32, glyphId }

/// Paint for drawing operations
class SkiaPaint {
  final Skia skia;
  final ffi.Pointer<ffi.Void> _handle;
  bool _disposed = false;

  SkiaPaint._(this.skia, this._handle);

  SkiaSharpBindings get _bindings => skia._bindings;

  ffi.Pointer<ffi.Void> get handle => _handle;

  /// Clone this paint
  SkiaPaint clone() {
    _checkDisposed();
    return SkiaPaint._(skia, _bindings.sk_paint_clone(_handle));
  }

  /// Reset to default settings
  void reset() {
    _checkDisposed();
    _bindings.sk_paint_reset(_handle);
  }

  // Properties

  bool get isAntialias {
    _checkDisposed();
    return _bindings.sk_paint_is_antialias(_handle);
  }

  set isAntialias(bool value) {
    _checkDisposed();
    _bindings.sk_paint_set_antialias(_handle, value);
  }

  bool get isDither {
    _checkDisposed();
    return _bindings.sk_paint_is_dither(_handle);
  }

  set isDither(bool value) {
    _checkDisposed();
    _bindings.sk_paint_set_dither(_handle, value);
  }

  SKColor get color {
    _checkDisposed();
    return SKColor(_bindings.sk_paint_get_color(_handle));
  }

  set color(SKColor value) {
    _checkDisposed();
    _bindings.sk_paint_set_color(_handle, value.value);
  }

  PaintStyle get style {
    _checkDisposed();
    return PaintStyle.values[_bindings.sk_paint_get_style(_handle)];
  }

  set style(PaintStyle value) {
    _checkDisposed();
    _bindings.sk_paint_set_style(_handle, value.index);
  }

  double get strokeWidth {
    _checkDisposed();
    return _bindings.sk_paint_get_stroke_width(_handle);
  }

  set strokeWidth(double value) {
    _checkDisposed();
    _bindings.sk_paint_set_stroke_width(_handle, value);
  }

  double get strokeMiter {
    _checkDisposed();
    return _bindings.sk_paint_get_stroke_miter(_handle);
  }

  set strokeMiter(double value) {
    _checkDisposed();
    _bindings.sk_paint_set_stroke_miter(_handle, value);
  }

  StrokeCap get strokeCap {
    _checkDisposed();
    return StrokeCap.values[_bindings.sk_paint_get_stroke_cap(_handle)];
  }

  set strokeCap(StrokeCap value) {
    _checkDisposed();
    _bindings.sk_paint_set_stroke_cap(_handle, value.index);
  }

  StrokeJoin get strokeJoin {
    _checkDisposed();
    return StrokeJoin.values[_bindings.sk_paint_get_stroke_join(_handle)];
  }

  set strokeJoin(StrokeJoin value) {
    _checkDisposed();
    _bindings.sk_paint_set_stroke_join(_handle, value.index);
  }

  BlendMode get blendMode {
    _checkDisposed();
    return BlendMode.values[_bindings.sk_paint_get_blendmode(_handle)];
  }

  set blendMode(BlendMode value) {
    _checkDisposed();
    _bindings.sk_paint_set_blendmode(_handle, value.index);
  }

  /// Sets a dash path effect on this paint
  void setDashPathEffect(List<double> intervals, double phase) {
    _checkDisposed();
    if (intervals.isEmpty || intervals.length % 2 != 0) {
      // Clear the path effect if intervals are invalid
      _bindings.sk_paint_set_path_effect(_handle, ffi.nullptr);
      return;
    }
    
    final nativeIntervals = ffi_alloc.calloc<ffi.Float>(intervals.length);
    try {
      for (int i = 0; i < intervals.length; i++) {
        nativeIntervals[i] = intervals[i];
      }
      final effect = _bindings.sk_path_effect_create_dash(nativeIntervals, intervals.length, phase);
      _bindings.sk_paint_set_path_effect(_handle, effect);
    } finally {
      ffi_alloc.calloc.free(nativeIntervals);
    }
  }
  
  /// Clears any path effect on this paint
  void clearPathEffect() {
    _checkDisposed();
    _bindings.sk_paint_set_path_effect(_handle, ffi.nullptr);
  }
  
  /// Sets a shader on this paint
  void setShader(ffi.Pointer<ffi.Void> shader) {
    _checkDisposed();
    _bindings.sk_paint_set_shader(_handle, shader);
  }
  
  /// Clears any shader on this paint
  void clearShader() {
    _checkDisposed();
    _bindings.sk_paint_set_shader(_handle, ffi.nullptr);
  }

  void dispose() {
    if (!_disposed) {
      _bindings.sk_paint_delete(_handle);
      _disposed = true;
    }
  }

  bool get isDisposed => _disposed;

  void _checkDisposed() {
    if (_disposed) throw StateError('SkiaPaint has been disposed');
  }
}

// ==================== Skia Font ====================

/// Font edging (anti-aliasing mode)
enum FontEdging { alias, antialias, subpixelAntialias }

/// Font hinting level
enum FontHinting { none, slight, normal, full }

/// Font for text rendering
class SkiaFont {
  final Skia skia;
  final ffi.Pointer<ffi.Void> _handle;
  bool _disposed = false;

  SkiaFont._(this.skia, this._handle);

  SkiaSharpBindings get _bindings => skia._bindings;

  ffi.Pointer<ffi.Void> get handle => _handle;

  double get size {
    _checkDisposed();
    return _bindings.sk_font_get_size(_handle);
  }

  set size(double value) {
    _checkDisposed();
    _bindings.sk_font_set_size(_handle, value);
  }

  double get scaleX {
    _checkDisposed();
    return _bindings.sk_font_get_scale_x(_handle);
  }

  set scaleX(double value) {
    _checkDisposed();
    _bindings.sk_font_set_scale_x(_handle, value);
  }

  double get skewX {
    _checkDisposed();
    return _bindings.sk_font_get_skew_x(_handle);
  }

  set skewX(double value) {
    _checkDisposed();
    _bindings.sk_font_set_skew_x(_handle, value);
  }

  bool get isSubpixel {
    _checkDisposed();
    return _bindings.sk_font_is_subpixel(_handle);
  }

  set isSubpixel(bool value) {
    _checkDisposed();
    _bindings.sk_font_set_subpixel(_handle, value);
  }

  bool get isForceAutoHinting {
    _checkDisposed();
    return _bindings.sk_font_is_force_auto_hinting(_handle);
  }

  set isForceAutoHinting(bool value) {
    _checkDisposed();
    _bindings.sk_font_set_force_auto_hinting(_handle, value);
  }

  bool get isEmbolden {
    _checkDisposed();
    return _bindings.sk_font_is_embolden(_handle);
  }

  set isEmbolden(bool value) {
    _checkDisposed();
    _bindings.sk_font_set_embolden(_handle, value);
  }

  bool get isLinearMetrics {
    _checkDisposed();
    return _bindings.sk_font_is_linear_metrics(_handle);
  }

  set isLinearMetrics(bool value) {
    _checkDisposed();
    _bindings.sk_font_set_linear_metrics(_handle, value);
  }

  FontEdging get edging {
    _checkDisposed();
    return FontEdging.values[_bindings.sk_font_get_edging(_handle).address];
  }

  set edging(FontEdging value) {
    _checkDisposed();
    _bindings.sk_font_set_edging(_handle, ffi.Pointer.fromAddress(value.index));
  }

  FontHinting get hinting {
    _checkDisposed();
    return FontHinting.values[_bindings.sk_font_get_hinting(_handle).address];
  }

  set hinting(FontHinting value) {
    _checkDisposed();
    _bindings.sk_font_set_hinting(_handle, ffi.Pointer.fromAddress(value.index));
  }

  void dispose() {
    if (!_disposed) {
      _bindings.sk_font_delete(_handle);
      _disposed = true;
    }
  }

  bool get isDisposed => _disposed;

  void _checkDisposed() {
    if (_disposed) throw StateError('SkiaFont has been disposed');
  }
}

// ==================== Skia Typeface ====================

/// Font slant
enum FontSlant { upright, italic, oblique }

/// Typeface (font file/family)
class SkiaTypeface {
  final Skia skia;
  final ffi.Pointer<ffi.Void> _handle;
  bool _disposed = false;

  SkiaTypeface._(this.skia, this._handle);

  SkiaSharpBindings get _bindings => skia._bindings;

  ffi.Pointer<ffi.Void> get handle => _handle;

  int get glyphCount {
    _checkDisposed();
    return _bindings.sk_typeface_count_glyphs(_handle);
  }

  int get tableCount {
    _checkDisposed();
    return _bindings.sk_typeface_count_tables(_handle);
  }

  int get unitsPerEm {
    _checkDisposed();
    return _bindings.sk_typeface_get_units_per_em(_handle);
  }

  bool get isFixedPitch {
    _checkDisposed();
    return _bindings.sk_typeface_is_fixed_pitch(_handle);
  }

  int get fontWeight {
    _checkDisposed();
    return _bindings.sk_typeface_get_font_weight(_handle);
  }

  int get fontWidth {
    _checkDisposed();
    return _bindings.sk_typeface_get_font_width(_handle);
  }

  FontSlant get fontSlant {
    _checkDisposed();
    final slant = _bindings.sk_typeface_get_font_slant(_handle);
    return FontSlant.values[slant.clamp(0, FontSlant.values.length - 1)];
  }

  int unicharToGlyph(int unichar) {
    _checkDisposed();
    return _bindings.sk_typeface_unichar_to_glyph(_handle, unichar);
  }

  void dispose() {
    if (!_disposed) {
      _bindings.sk_typeface_unref(_handle);
      _disposed = true;
    }
  }

  bool get isDisposed => _disposed;

  void _checkDisposed() {
    if (_disposed) throw StateError('SkiaTypeface has been disposed');
  }
}

// ==================== Skia Path ====================

/// Path fill type
enum PathFillType { winding, evenOdd, inverseWinding, inverseEvenOdd }

/// Path for drawing operations
class SkiaPath {
  final Skia skia;
  final ffi.Pointer<ffi.Void> _handle;
  bool _disposed = false;

  SkiaPath._(this.skia, this._handle);

  SkiaSharpBindings get _bindings => skia._bindings;

  ffi.Pointer<ffi.Void> get handle => _handle;

  /// Clone this path
  SkiaPath clone() {
    _checkDisposed();
    return SkiaPath._(skia, _bindings.sk_path_clone(_handle));
  }

  /// Reset the path to empty
  void reset() {
    _checkDisposed();
    _bindings.sk_path_reset(_handle);
  }

  /// Move to a point
  void moveTo(double x, double y) {
    _checkDisposed();
    _bindings.sk_path_move_to(_handle, x, y);
  }

  /// Line to a point
  void lineTo(double x, double y) {
    _checkDisposed();
    _bindings.sk_path_line_to(_handle, x, y);
  }

  /// Cubic bezier curve
  void cubicTo(
      double x1, double y1, double x2, double y2, double x3, double y3) {
    _checkDisposed();
    _bindings.sk_path_cubic_to(_handle, x1, y1, x2, y2, x3, y3);
  }

  /// Quadratic bezier curve
  void quadTo(double x1, double y1, double x2, double y2) {
    _checkDisposed();
    _bindings.sk_path_quad_to(_handle, x1, y1, x2, y2);
  }

  /// Conic curve
  void conicTo(double x1, double y1, double x2, double y2, double weight) {
    _checkDisposed();
    _bindings.sk_path_conic_to(_handle, x1, y1, x2, y2, weight);
  }

  /// Close the current contour
  void close() {
    _checkDisposed();
    _bindings.sk_path_close(_handle);
  }

  /// Add a rectangle
  void addRect(SKRect rect, [PathDirection direction = PathDirection.cw]) {
    _checkDisposed();
    final nativeRect = _allocSKRect(rect);
    try {
      _bindings.sk_path_add_rect(_handle, nativeRect, direction.index);
    } finally {
      _freeSKRect(nativeRect);
    }
  }

  /// Add a circle
  void addCircle(double cx, double cy, double radius,
      [PathDirection direction = PathDirection.cw]) {
    _checkDisposed();
    _bindings.sk_path_add_circle(_handle, cx, cy, radius, direction.index);
  }

  /// Add an oval
  void addOval(SKRect rect, [PathDirection direction = PathDirection.cw]) {
    _checkDisposed();
    final nativeRect = _allocSKRect(rect);
    try {
      _bindings.sk_path_add_oval(_handle, nativeRect, direction.index);
    } finally {
      _freeSKRect(nativeRect);
    }
  }

  /// Add a rounded rectangle
  void addRoundRect(SKRect rect, double rx, double ry, [PathDirection direction = PathDirection.cw]) {
    _checkDisposed();
    final nativeRect = _allocSKRect(rect);
    try {
      _bindings.sk_path_add_rounded_rect(_handle, nativeRect, rx, ry, direction.index);
    } finally {
      _freeSKRect(nativeRect);
    }
  }

  PathFillType get fillType {
    _checkDisposed();
    return PathFillType.values[_bindings.sk_path_get_filltype(_handle)];
  }

  set fillType(PathFillType value) {
    _checkDisposed();
    _bindings.sk_path_set_filltype(_handle, value.index);
  }
  
  /// Check if a point is inside this path
  bool contains(double x, double y) {
    _checkDisposed();
    return _bindings.sk_path_contains(_handle, x, y);
  }

  /// Add another path to this path
  /// [mode] - 0 = append, 1 = extend
  void addPath(SkiaPath other, [int mode = 0]) {
    _checkDisposed();
    _bindings.sk_path_add_path(_handle, other._handle, ffi.Pointer.fromAddress(mode));
  }

  /// Add another path to this path with offset
  void addPathOffset(SkiaPath other, double dx, double dy, [int mode = 0]) {
    _checkDisposed();
    _bindings.sk_path_add_path_offset(_handle, other._handle, dx, dy, ffi.Pointer.fromAddress(mode));
  }

  /// Add arc to path using control points and radius (HTML5 Canvas style)
  void arcTo(double x1, double y1, double x2, double y2, double radius) {
    _checkDisposed();
    _bindings.sk_path_arc_to_with_points(_handle, x1, y1, x2, y2, radius);
  }

  /// Add arc to path using SVG-style parameters
  /// [rx], [ry] - radii
  /// [xAxisRotate] - rotation in degrees
  /// [largeArc] - 0 = small, 1 = large
  /// [sweep] - 0 = CCW, 1 = CW
  /// [x], [y] - end point
  void arcToSvg(double rx, double ry, double xAxisRotate, int largeArc, int sweep, double x, double y) {
    _checkDisposed();
    _bindings.sk_path_arc_to(_handle, rx, ry, xAxisRotate, largeArc, sweep, x, y);
  }

  /// Parse an SVG path string and add commands to this path
  /// Returns true if parsing succeeded
  bool parseSvgString(String svgPath) {
    _checkDisposed();
    final nativeStr = svgPath.toNativeUtf8(allocator: ffi_alloc.calloc);
    try {
      return _bindings.sk_path_parse_svg_string(_handle, nativeStr.cast());
    } finally {
      ffi_alloc.calloc.free(nativeStr);
    }
  }

  void dispose() {
    if (!_disposed) {
      _bindings.sk_path_delete(_handle);
      _disposed = true;
    }
  }

  bool get isDisposed => _disposed;

  void _checkDisposed() {
    if (_disposed) throw StateError('SkiaPath has been disposed');
  }

  ffi.Pointer<ffi.Void> _allocSKRect(SKRect rect) {
    final ptr = ffi_alloc.calloc<ffi.Float>(4);
    ptr[0] = rect.left;
    ptr[1] = rect.top;
    ptr[2] = rect.right;
    ptr[3] = rect.bottom;
    return ptr.cast();
  }

  void _freeSKRect(ffi.Pointer<ffi.Void> ptr) {
    ffi_alloc.calloc.free(ptr);
  }
}

/// Path direction
enum PathDirection { cw, ccw }

/// Image encoder format (internal)
enum _EncoderFormat { png, jpeg, webp }

// ==================== Skia Image ====================

/// An immutable image
class SkiaImage {
  final Skia skia;
  final ffi.Pointer<ffi.Void> _handle;
  bool _disposed = false;

  SkiaImage._(this.skia, this._handle);

  SkiaSharpBindings get _bindings => skia._bindings;

  ffi.Pointer<ffi.Void> get handle => _handle;

  int get width {
    _checkDisposed();
    return _bindings.sk_image_get_width(_handle);
  }

  int get height {
    _checkDisposed();
    return _bindings.sk_image_get_height(_handle);
  }

  SKSizeI get size => SKSizeI(width, height);

  int get uniqueId {
    _checkDisposed();
    return _bindings.sk_image_get_unique_id(_handle);
  }

  /// Read the raw pixels of the image as RGBA bytes
  /// Returns null if the read fails
  Uint8List? readPixels() {
    _checkDisposed();
    final w = width;
    final h = height;
    final rowBytes = w * 4; // RGBA = 4 bytes per pixel
    final totalBytes = rowBytes * h;
    
    // Allocate buffer for pixels
    final pixels = ffi_alloc.calloc<ffi.Uint8>(totalBytes);
    if (pixels == ffi.nullptr) return null;
    
    try {
      // Create image info for RGBA8888
      final info = ffi_alloc.calloc<_SKImageInfoNative>();
      try {
        info.ref.width = w;
        info.ref.height = h;
        info.ref.colorType = ColorType.rgba8888;
        info.ref.alphaType = AlphaType.premul;
        info.ref.colorspace = ffi.nullptr;
        
        final success = _bindings.sk_image_read_pixels(
          _handle,
          info.cast<ffi.Void>(),
          pixels.cast<ffi.Void>(),
          ffi.Pointer.fromAddress(rowBytes),
          0,
          0,
          0, // SKImageCachingHint.Allow = 0
        );
        
        if (!success) return null;
        
        // Copy pixels to Dart list
        return Uint8List.fromList(pixels.asTypedList(totalBytes));
      } finally {
        ffi_alloc.calloc.free(info);
      }
    } finally {
      ffi_alloc.calloc.free(pixels);
    }
  }

  /// Encode the image as PNG and save to file
  bool saveToPng(String path) {
    _checkDisposed();
    return _saveWithEncoder(path, _EncoderFormat.png);
  }

  /// Encode the image as JPEG and save to file
  bool saveToJpeg(String path, {int quality = 90}) {
    _checkDisposed();
    return _saveWithEncoder(path, _EncoderFormat.jpeg, quality: quality);
  }

  /// Encode the image as WebP and save to file
  bool saveToWebp(String path, {int quality = 90}) {
    _checkDisposed();
    return _saveWithEncoder(path, _EncoderFormat.webp, quality: quality);
  }

  bool _saveWithEncoder(String path, _EncoderFormat format, {int quality = 90}) {
    // Create pixmap from image
    final pixmap = _bindings.sk_pixmap_new();
    if (pixmap == ffi.nullptr) return false;
    
    try {
      // Try to peek pixels from image
      if (!_bindings.sk_image_peek_pixels(_handle, pixmap)) {
        // Image doesn't have direct pixel access, need to read pixels
        final w = width;
        final h = height;
        final rowBytes = w * 4;
        final totalBytes = rowBytes * h;
        
        final pixels = ffi_alloc.calloc<ffi.Uint8>(totalBytes);
        if (pixels == ffi.nullptr) return false;
        
        try {
          final info = ffi_alloc.calloc<_SKImageInfoNative>();
          try {
            info.ref.width = w;
            info.ref.height = h;
            info.ref.colorType = ColorType.rgba8888;
            info.ref.alphaType = AlphaType.premul;
            info.ref.colorspace = ffi.nullptr;
            
            if (!_bindings.sk_image_read_pixels(
              _handle,
              info.cast<ffi.Void>(),
              pixels.cast<ffi.Void>(),
              ffi.Pointer.fromAddress(rowBytes),
              0, 0, 0,
            )) {
              return false;
            }
            
            // Reset pixmap with our data
            _bindings.sk_pixmap_reset_with_params(
              pixmap,
              info.cast<ffi.Void>(),
              pixels.cast<ffi.Void>(),
              ffi.Pointer.fromAddress(rowBytes),
            );
            
            return _encodePixmapToFile(pixmap, path, format, quality);
          } finally {
            ffi_alloc.calloc.free(info);
          }
        } finally {
          ffi_alloc.calloc.free(pixels);
        }
      }
      
      return _encodePixmapToFile(pixmap, path, format, quality);
    } finally {
      _bindings.sk_pixmap_destructor(pixmap);
    }
  }

  bool _encodePixmapToFile(ffi.Pointer<ffi.Void> pixmap, String path, _EncoderFormat format, int quality) {
    // Create file write stream
    final pathPtr = path.toNativeUtf8(allocator: ffi_alloc.calloc);
    try {
      final fileStream = _bindings.sk_filewstream_new(pathPtr.cast<ffi.Void>());
      if (fileStream == ffi.nullptr) return false;
      
      try {
        if (!_bindings.sk_filewstream_is_valid(fileStream)) return false;
        
        bool success;
        switch (format) {
          case _EncoderFormat.png:
            success = _bindings.sk_pngencoder_encode(fileStream, pixmap, ffi.nullptr);
            break;
          case _EncoderFormat.jpeg:
            // For JPEG, we'd need to create options struct - use nullptr for defaults
            success = _bindings.sk_jpegencoder_encode(fileStream, pixmap, ffi.nullptr);
            break;
          case _EncoderFormat.webp:
            // For WebP, we'd need to create options struct - use nullptr for defaults
            success = _bindings.sk_webpencoder_encode(fileStream, pixmap, ffi.nullptr);
            break;
        }
        
        return success;
      } finally {
        _bindings.sk_filewstream_destroy(fileStream);
      }
    } finally {
      ffi_alloc.calloc.free(pathPtr);
    }
  }

  /// Encode the image as PNG and return as bytes
  Uint8List? encodeToPng() {
    _checkDisposed();
    return _encodeToBytes(_EncoderFormat.png);
  }

  /// Encode the image as JPEG and return as bytes
  Uint8List? encodeToJpeg({int quality = 90}) {
    _checkDisposed();
    return _encodeToBytes(_EncoderFormat.jpeg, quality: quality);
  }

  /// Encode the image as WebP and return as bytes
  Uint8List? encodeToWebp({int quality = 90}) {
    _checkDisposed();
    return _encodeToBytes(_EncoderFormat.webp, quality: quality);
  }

  Uint8List? _encodeToBytes(_EncoderFormat format, {int quality = 90}) {
    // Use sk_pixmap_new_with_params and sk_image_read_pixels_into_pixmap
    // for a cleaner approach
    final w = width;
    final h = height;
    final rowBytes = w * 4;
    final totalBytes = rowBytes * h;
    
    // Allocate pixel buffer
    final pixels = ffi_alloc.calloc<ffi.Uint8>(totalBytes);
    if (pixels == ffi.nullptr) return null;
    
    // Allocate and configure image info struct
    final info = ffi_alloc.calloc<_SKImageInfoNative>();
    if (info == ffi.nullptr) {
      ffi_alloc.calloc.free(pixels);
      return null;
    }
    
    try {
      info.ref.colorspace = ffi.nullptr;
      info.ref.width = w;
      info.ref.height = h;
      info.ref.colorType = ColorType.rgba8888;
      info.ref.alphaType = AlphaType.premul;
      
      // Create pixmap with our buffer
      final pixmap = _bindings.sk_pixmap_new_with_params(
        info.cast<ffi.Void>(),
        pixels.cast<ffi.Void>(),
        ffi.Pointer.fromAddress(rowBytes),
      );
      
      if (pixmap == ffi.nullptr) {
        return null;
      }
      
      try {
        // Read image pixels directly into the pixmap
        // SKImageCachingHint: 0 = Allow, 1 = Disallow
        if (!_bindings.sk_image_read_pixels_into_pixmap(
          _handle,
          pixmap,
          0, 0, // srcX, srcY
          0, // cachingHint = Allow
        )) {
          return null;
        }
        
        return _encodePixmapToBytes(pixmap, format, quality);
      } finally {
        _bindings.sk_pixmap_destructor(pixmap);
      }
    } finally {
      ffi_alloc.calloc.free(info);
      ffi_alloc.calloc.free(pixels);
    }
  }

  Uint8List? _encodePixmapToBytes(ffi.Pointer<ffi.Void> pixmap, _EncoderFormat format, int quality) {
    // Create dynamic memory write stream
    final memStream = _bindings.sk_dynamicmemorywstream_new();
    if (memStream == ffi.nullptr) return null;
    
    try {
      bool success;
      switch (format) {
        case _EncoderFormat.png:
          // Allocate and configure PNG encoder options
          final pngOptions = ffi_alloc.calloc<_SKPngEncoderOptions>();
          try {
            // FilterFlags: All = 0xF8 (248) is the default for PNG encoding
            pngOptions.ref.fFilterFlags = 248;
            // ZLib compression level (0-9), 6 is default
            pngOptions.ref.fZLibLevel = 6;
            pngOptions.ref.fComments = ffi.nullptr;
            pngOptions.ref.fICCProfile = ffi.nullptr;
            pngOptions.ref.fICCProfileDescription = ffi.nullptr;
            
            success = _bindings.sk_pngencoder_encode(
              memStream, 
              pixmap, 
              pngOptions.cast<ffi.Void>(),
            );
          } finally {
            ffi_alloc.calloc.free(pngOptions);
          }
          break;
        case _EncoderFormat.jpeg:
          success = _bindings.sk_jpegencoder_encode(memStream, pixmap, ffi.nullptr);
          break;
        case _EncoderFormat.webp:
          success = _bindings.sk_webpencoder_encode(memStream, pixmap, ffi.nullptr);
          break;
      }

      
      if (!success) return null;
      
      // Get the data - detach transfers ownership to us
      final skData = _bindings.sk_dynamicmemorywstream_detach_as_data(memStream);
      if (skData == ffi.nullptr) return null;
      
      try {
        // sk_data_get_size returns IntPtr (size_t), use .address to get int
        final dataSize = _bindings.sk_data_get_size(skData).address;
        if (dataSize <= 0) return null;
        
        final dataPtr = _bindings.sk_data_get_data(skData);
        if (dataPtr == ffi.nullptr) return null;
        
        // Copy data to Dart Uint8List
        return Uint8List.fromList(
          dataPtr.cast<ffi.Uint8>().asTypedList(dataSize),
        );
      } finally {
        _bindings.sk_data_unref(skData);
      }
    } finally {
      _bindings.sk_dynamicmemorywstream_destroy(memStream);
    }
  }

  void dispose() {
    if (!_disposed) {
      _bindings.sk_image_unref(_handle);
      _disposed = true;
    }
  }

  bool get isDisposed => _disposed;

  void _checkDisposed() {
    if (_disposed) throw StateError('SkiaImage has been disposed');
  }
}

// ==================== Skia Bitmap ====================

/// A bitmap that can be drawn and modified
class SkiaBitmap {
  final Skia skia;
  final ffi.Pointer<ffi.Void> _handle;
  final int width;
  final int height;
  bool _disposed = false;

  SkiaBitmap._(this.skia, this._handle, this.width, this.height);

  SkiaSharpBindings get _bindings => skia._bindings;

  ffi.Pointer<ffi.Void> get handle => _handle;

  /// Erase the bitmap to the specified color
  void erase(SKColor color) {
    _checkDisposed();
    _bindings.sk_bitmap_erase(_handle, color.value);
  }

  /// Get the pixel color at (x, y)
  SKColor getPixel(int x, int y) {
    _checkDisposed();
    return SKColor(_bindings.sk_bitmap_get_pixel_color(_handle, x, y));
  }

  /// Get direct access to pixel data
  /// Returns a Uint8List view of the pixel data, or null if unavailable
  Uint8List? getPixels() {
    _checkDisposed();
    final lengthPtr = ffi_alloc.calloc<ffi.IntPtr>();
    try {
      final pixels = _bindings.sk_bitmap_get_pixels(_handle, lengthPtr.cast());
      if (pixels == ffi.nullptr) return null;
      
      // Calculate expected length: width * height * 4 bytes per pixel (RGBA)
      final length = width * height * 4;
      return pixels.cast<ffi.Uint8>().asTypedList(length);
    } finally {
      ffi_alloc.calloc.free(lengthPtr);
    }
  }

  /// Notify that pixels have been changed (must call after modifying pixels)
  void notifyPixelsChanged() {
    _checkDisposed();
    _bindings.sk_bitmap_notify_pixels_changed(_handle);
  }

  /// Create an image from this bitmap
  SkiaImage? toImage() {
    _checkDisposed();
    final imageHandle = _bindings.sk_image_new_from_bitmap(_handle);
    if (imageHandle == ffi.nullptr) return null;
    return SkiaImage._(skia, imageHandle);
  }

  bool get isImmutable {
    _checkDisposed();
    return _bindings.sk_bitmap_is_immutable(_handle);
  }

  void setImmutable() {
    _checkDisposed();
    _bindings.sk_bitmap_set_immutable(_handle);
  }

  bool get isNull {
    _checkDisposed();
    return _bindings.sk_bitmap_is_null(_handle);
  }

  void dispose() {
    if (!_disposed) {
      _bindings.sk_bitmap_destructor(_handle);
      _disposed = true;
    }
  }

  bool get isDisposed => _disposed;

  void _checkDisposed() {
    if (_disposed) throw StateError('SkiaBitmap has been disposed');
  }
}

// ============================================================================
// Type Aliases for backward compatibility with SVG module
// ============================================================================

/// Alias for SkiaCanvas (backward compatibility)
typedef SKCanvas = SkiaCanvas;

/// Alias for SkiaPaint (backward compatibility)
typedef SKPaint = SkiaPaint;

/// Alias for SkiaPath (backward compatibility)
typedef SKPath = SkiaPath;

/// Alias for SkiaSurface (backward compatibility)
typedef SKSurface = SkiaSurface;

/// Alias for SkiaFont (backward compatibility)
typedef SKFont = SkiaFont;

/// Alias for SkiaTypeface (backward compatibility)
typedef SKTypeface = SkiaTypeface;

/// Alias for SkiaImage (backward compatibility)
typedef SKImage = SkiaImage;

/// Alias for SkiaBitmap (backward compatibility)
typedef SKBitmap = SkiaBitmap;
