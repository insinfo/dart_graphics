/// Cairo API Facade - Main entry point for Cairo graphics library
///
/// This class is the main entry point for the Cairo library. It manages the
/// native library bindings and provides factory methods for creating all
/// Cairo objects.
///
/// Example:
/// ```dart
/// // Default library path
/// final cairo = Cairo();
///
/// // Or with custom library path
/// final cairo = Cairo(libraryPath: 'path/to/libcairo.dll');
///
/// // Create surfaces and canvases
/// final canvas = cairo.createCanvas(800, 600);
/// canvas
///   ..setSourceRgb(1.0, 0.0, 0.0)
///   ..drawLine(0, 0, 100, 100)
///   ..saveToPng('output.png');
/// canvas.dispose();
/// ```

import 'dart:ffi' as ffi;
import 'dart:typed_data';
import 'package:ffi/ffi.dart' show calloc;
import 'generated/ffi.dart' as cairo_ffi;
import 'cairo_load.dart' show loadCairo;
import 'cairo_types.dart';
import '../freetype/freetype.dart' hide FT_FaceRec_;

/// Main Cairo API facade class
///
/// This is the single entry point for Cairo functionality. All Cairo objects
/// (surfaces, canvases, fonts) should be created through this class.
class Cairo {
  final cairo_ffi.CairoBindings _bindings;
  final CairoFontCacheInternal _fontCache;

  /// Create a Cairo instance
  ///
  /// [libraryPath] - Optional path to the Cairo library (DLL/so/dylib).
  /// If not provided, the library will be loaded from the default system path.
  Cairo({String? libraryPath})
      : _bindings = loadCairo(libraryPath: libraryPath),
        _fontCache = CairoFontCacheInternal._();

  /// Get the underlying bindings (for advanced use only)
  cairo_ffi.CairoBindings get bindings => _bindings;

  /// Create an image surface with the given dimensions
  CairoSurfaceImpl createImageSurface(
    int width,
    int height, {
    cairo_ffi.CairoFormatEnum format =
        cairo_ffi.CairoFormatEnum.CAIRO_FORMAT_ARGB32,
  }) {
    final ptr = _bindings.cairo_image_surface_create(format, width, height);
    return CairoSurfaceImpl._(this, ptr, width, height, format);
  }

  /// Create a surface from raw pixel data
  CairoSurfaceImpl createSurfaceFromData(
    Uint8List data,
    int width,
    int height, {
    cairo_ffi.CairoFormatEnum format =
        cairo_ffi.CairoFormatEnum.CAIRO_FORMAT_ARGB32,
  }) {
    final stride = _bindings.cairo_format_stride_for_width(format, width);
    final dataPtr = calloc<ffi.UnsignedChar>(data.length);
    for (var i = 0; i < data.length; i++) {
      dataPtr[i] = data[i];
    }
    final ptr = _bindings.cairo_image_surface_create_for_data(
        dataPtr, format, width, height, stride);
    return CairoSurfaceImpl._(this, ptr, width, height, format);
  }

  /// Create a canvas with the given dimensions
  CairoCanvasImpl createCanvas(
    int width,
    int height, {
    cairo_ffi.CairoFormatEnum format =
        cairo_ffi.CairoFormatEnum.CAIRO_FORMAT_ARGB32,
  }) {
    final surface = createImageSurface(width, height, format: format);
    return CairoCanvasImpl.fromSurface(surface);
  }

  /// Create a canvas from an existing surface
  CairoCanvasImpl createCanvasFromSurface(CairoSurfaceImpl surface) {
    return CairoCanvasImpl.fromSurface(surface);
  }

  // ==================== Font Loading ====================

  /// Load a font from a file
  ///
  /// Returns null if the font cannot be loaded.
  CairoFreeTypeFaceImpl? loadFont(
    String filePath, {
    int faceIndex = 0,
    int loadFlags = 0,
  }) {
    final ftFace = FreeTypeFace.fromFile(filePath, faceIndex: faceIndex);
    if (ftFace == null) return null;

    final cairoFtFace = ftFace.ftFace.cast<cairo_ffi.FT_FaceRec_>();
    final cairoFontFace = _bindings.cairo_ft_font_face_create_for_ft_face(
      cairoFtFace,
      loadFlags,
    );

    if (cairoFontFace == ffi.nullptr) {
      ftFace.dispose();
      return null;
    }

    return CairoFreeTypeFaceImpl._(this, ftFace, cairoFontFace);
  }

  /// Get or load a cached font from a file
  ///
  /// This caches fonts for reuse. Use this for better performance when
  /// loading the same font multiple times.
  CairoFreeTypeFaceImpl? getCachedFont(
    String filePath, {
    int faceIndex = 0,
    int loadFlags = 0,
  }) {
    final key = '$filePath:$faceIndex:$loadFlags';

    // Check cache first
    if (_fontCache._cache.containsKey(key)) {
      final face = _fontCache._cache[key]!;
      if (!face.isDisposed) return face;
      _fontCache._cache.remove(key);
    }

    // Load and cache
    final face = loadFont(filePath, faceIndex: faceIndex, loadFlags: loadFlags);
    if (face != null) {
      _fontCache._cache[key] = face;
    }
    return face;
  }

  /// Clear all cached fonts
  void clearFontCache() {
    for (final face in _fontCache._cache.values) {
      face.dispose();
    }
    _fontCache._cache.clear();
  }

  /// Dispose a specific cached font
  void removeCachedFont(String filePath,
      {int faceIndex = 0, int loadFlags = 0}) {
    final key = '$filePath:$faceIndex:$loadFlags';
    final face = _fontCache._cache.remove(key);
    face?.dispose();
  }
}

/// Internal font cache
class CairoFontCacheInternal {
  final Map<String, CairoFreeTypeFaceImpl> _cache = {};
  CairoFontCacheInternal._();
}

/// Cairo image surface implementation
class CairoSurfaceImpl {
  final Cairo cairo;
  final ffi.Pointer<cairo_ffi.cairo_surface_t> _ptr;
  final int width;
  final int height;
  final cairo_ffi.CairoFormatEnum format;
  bool _disposed = false;

  CairoSurfaceImpl._(
      this.cairo, this._ptr, this.width, this.height, this.format);

  /// Get the Cairo bindings
  cairo_ffi.CairoBindings get _bindings => cairo._bindings;

  /// Get the raw pointer (for advanced use)
  ffi.Pointer<cairo_ffi.cairo_surface_t> get pointer => _ptr;

  /// Check the surface status
  cairo_ffi.CairoStatusEnum get status => _bindings.cairo_surface_status(_ptr);

  /// Check if surface is valid
  bool get isValid => status == cairo_ffi.CairoStatusEnum.CAIRO_STATUS_SUCCESS;

  /// Get the pixel data from the surface
  Uint8List? getData() {
    final dataPtr = _bindings.cairo_image_surface_get_data(_ptr);
    if (dataPtr == ffi.nullptr) return null;

    final stride = _bindings.cairo_image_surface_get_stride(_ptr);
    final totalBytes = stride * height;
    return dataPtr.cast<ffi.Uint8>().asTypedList(totalBytes);
  }

  /// Save surface to a PNG file
  bool saveToPng(String filename) {
    final filenamePtr = filename.toNativeUtf8().cast<ffi.Char>();
    try {
      final result = _bindings.cairo_surface_write_to_png(_ptr, filenamePtr);
      return result == cairo_ffi.CairoStatusEnum.CAIRO_STATUS_SUCCESS;
    } finally {
      calloc.free(filenamePtr);
    }
  }

  /// Flush any pending drawing operations
  void flush() {
    _bindings.cairo_surface_flush(_ptr);
  }

  /// Mark the entire surface as dirty
  void markDirty() {
    _bindings.cairo_surface_mark_dirty(_ptr);
  }

  /// Mark a rectangle as dirty
  void markDirtyRect(int x, int y, int width, int height) {
    _bindings.cairo_surface_mark_dirty_rectangle(_ptr, x, y, width, height);
  }

  /// Dispose the surface and free resources
  void dispose() {
    if (!_disposed) {
      _bindings.cairo_surface_destroy(_ptr);
      _disposed = true;
    }
  }

  /// Check if disposed
  bool get isDisposed => _disposed;
}

/// Cairo canvas implementation for drawing
class CairoCanvasImpl {
  final CairoSurfaceImpl surface;
  final ffi.Pointer<cairo_ffi.cairo_t> _ctx;
  bool _disposed = false;

  /// Get the Cairo instance
  Cairo get cairo => surface.cairo;

  /// Get the Cairo bindings
  cairo_ffi.CairoBindings get _bindings => cairo._bindings;

  /// Create a canvas from an existing surface
  CairoCanvasImpl.fromSurface(this.surface)
      : _ctx = surface._bindings.cairo_create(surface._ptr);

  /// Width of the canvas
  int get width => surface.width;

  /// Height of the canvas
  int get height => surface.height;

  /// Get the raw context pointer (for advanced use)
  ffi.Pointer<cairo_ffi.cairo_t> get pointer => _ctx;

  /// Check context status
  cairo_ffi.CairoStatusEnum get status => _bindings.cairo_status(_ctx);

  /// Check if context is valid
  bool get isValid => status == cairo_ffi.CairoStatusEnum.CAIRO_STATUS_SUCCESS;

  // ==================== State Management ====================

  CairoCanvasImpl save() {
    _bindings.cairo_save(_ctx);
    return this;
  }

  CairoCanvasImpl restore() {
    _bindings.cairo_restore(_ctx);
    return this;
  }

  // ==================== Color & Source ====================

  CairoCanvasImpl setSourceRgb(double r, double g, double b) {
    _bindings.cairo_set_source_rgb(_ctx, r, g, b);
    return this;
  }

  CairoCanvasImpl setSourceRgba(double r, double g, double b, double a) {
    _bindings.cairo_set_source_rgba(_ctx, r, g, b, a);
    return this;
  }

  CairoCanvasImpl setColor(CairoColor color) {
    _bindings.cairo_set_source_rgba(_ctx, color.r, color.g, color.b, color.a);
    return this;
  }

  /// Set a pattern as the source (gradient, surface pattern, etc.)
  CairoCanvasImpl setPattern(ffi.Pointer<cairo_ffi.cairo_pattern_t> pattern) {
    _bindings.cairo_set_source(_ctx, pattern);
    return this;
  }
  
  /// Set a surface as the source for drawing
  CairoCanvasImpl setSourceSurface(CairoSurfaceImpl surface, [double x = 0, double y = 0]) {
    _bindings.cairo_set_source_surface(_ctx, surface.pointer, x, y);
    return this;
  }

  // ==================== Line Style ====================

  CairoCanvasImpl setLineWidth(double width) {
    _bindings.cairo_set_line_width(_ctx, width);
    return this;
  }

  double getLineWidth() => _bindings.cairo_get_line_width(_ctx);

  CairoCanvasImpl setLineCap(LineCap cap) {
    final cairoCap = switch (cap) {
      LineCap.butt => cairo_ffi.CairoLineCapEnum.CAIRO_LINE_CAP_BUTT,
      LineCap.round => cairo_ffi.CairoLineCapEnum.CAIRO_LINE_CAP_ROUND,
      LineCap.square => cairo_ffi.CairoLineCapEnum.CAIRO_LINE_CAP_SQUARE,
    };
    _bindings.cairo_set_line_cap(_ctx, cairoCap);
    return this;
  }

  CairoCanvasImpl setLineJoin(LineJoin join) {
    final cairoJoin = switch (join) {
      LineJoin.miter => cairo_ffi.CairoLineJoinEnum.CAIRO_LINE_JOIN_MITER,
      LineJoin.round => cairo_ffi.CairoLineJoinEnum.CAIRO_LINE_JOIN_ROUND,
      LineJoin.bevel => cairo_ffi.CairoLineJoinEnum.CAIRO_LINE_JOIN_BEVEL,
    };
    _bindings.cairo_set_line_join(_ctx, cairoJoin);
    return this;
  }

  CairoCanvasImpl setMiterLimit(double limit) {
    _bindings.cairo_set_miter_limit(_ctx, limit);
    return this;
  }

  CairoCanvasImpl setDash(List<double> dashes, [double offset = 0.0]) {
    if (dashes.isEmpty) {
      _bindings.cairo_set_dash(_ctx, ffi.nullptr, 0, 0.0);
    } else {
      final dashPtr = calloc<ffi.Double>(dashes.length);
      for (var i = 0; i < dashes.length; i++) {
        dashPtr[i] = dashes[i];
      }
      _bindings.cairo_set_dash(_ctx, dashPtr, dashes.length, offset);
      calloc.free(dashPtr);
    }
    return this;
  }

  CairoCanvasImpl clearDash() {
    _bindings.cairo_set_dash(_ctx, ffi.nullptr, 0, 0.0);
    return this;
  }

  // ==================== Anti-aliasing ====================

  CairoCanvasImpl setAntialias(cairo_ffi.CairoAntialiasEnum antialias) {
    _bindings.cairo_set_antialias(_ctx, antialias);
    return this;
  }

  // ==================== Fill Rule ====================

  CairoCanvasImpl setFillRule(cairo_ffi.CairoFillRuleEnum rule) {
    _bindings.cairo_set_fill_rule(_ctx, rule);
    return this;
  }

  // ==================== Path Operations ====================

  CairoCanvasImpl newPath() {
    _bindings.cairo_new_path(_ctx);
    return this;
  }

  CairoCanvasImpl newSubPath() {
    _bindings.cairo_new_sub_path(_ctx);
    return this;
  }

  CairoCanvasImpl moveTo(double x, double y) {
    _bindings.cairo_move_to(_ctx, x, y);
    return this;
  }

  CairoCanvasImpl lineTo(double x, double y) {
    _bindings.cairo_line_to(_ctx, x, y);
    return this;
  }

  CairoCanvasImpl curveTo(
      double x1, double y1, double x2, double y2, double x3, double y3) {
    _bindings.cairo_curve_to(_ctx, x1, y1, x2, y2, x3, y3);
    return this;
  }

  CairoCanvasImpl arc(
      double xc, double yc, double radius, double angle1, double angle2) {
    _bindings.cairo_arc(_ctx, xc, yc, radius, angle1, angle2);
    return this;
  }

  CairoCanvasImpl arcNegative(
      double xc, double yc, double radius, double angle1, double angle2) {
    _bindings.cairo_arc_negative(_ctx, xc, yc, radius, angle1, angle2);
    return this;
  }

  CairoCanvasImpl relMoveTo(double dx, double dy) {
    _bindings.cairo_rel_move_to(_ctx, dx, dy);
    return this;
  }

  CairoCanvasImpl relLineTo(double dx, double dy) {
    _bindings.cairo_rel_line_to(_ctx, dx, dy);
    return this;
  }

  CairoCanvasImpl relCurveTo(
      double dx1, double dy1, double dx2, double dy2, double dx3, double dy3) {
    _bindings.cairo_rel_curve_to(_ctx, dx1, dy1, dx2, dy2, dx3, dy3);
    return this;
  }

  CairoCanvasImpl rectangle(double x, double y, double width, double height) {
    _bindings.cairo_rectangle(_ctx, x, y, width, height);
    return this;
  }

  CairoCanvasImpl rect(Rect r) {
    _bindings.cairo_rectangle(_ctx, r.x, r.y, r.width, r.height);
    return this;
  }

  CairoCanvasImpl closePath() {
    _bindings.cairo_close_path(_ctx);
    return this;
  }

  // ==================== Drawing Operations ====================

  CairoCanvasImpl stroke() {
    _bindings.cairo_stroke(_ctx);
    return this;
  }

  CairoCanvasImpl strokePreserve() {
    _bindings.cairo_stroke_preserve(_ctx);
    return this;
  }

  CairoCanvasImpl fill() {
    _bindings.cairo_fill(_ctx);
    return this;
  }

  CairoCanvasImpl fillPreserve() {
    _bindings.cairo_fill_preserve(_ctx);
    return this;
  }

  CairoCanvasImpl paint() {
    _bindings.cairo_paint(_ctx);
    return this;
  }

  CairoCanvasImpl paintWithAlpha(double alpha) {
    _bindings.cairo_paint_with_alpha(_ctx, alpha);
    return this;
  }

  // ==================== Clipping ====================

  CairoCanvasImpl clip() {
    _bindings.cairo_clip(_ctx);
    return this;
  }

  CairoCanvasImpl clipPreserve() {
    _bindings.cairo_clip_preserve(_ctx);
    return this;
  }

  CairoCanvasImpl resetClip() {
    _bindings.cairo_reset_clip(_ctx);
    return this;
  }

  // ==================== Transformations ====================

  CairoCanvasImpl translate(double tx, double ty) {
    _bindings.cairo_translate(_ctx, tx, ty);
    return this;
  }

  CairoCanvasImpl scale(double sx, double sy) {
    _bindings.cairo_scale(_ctx, sx, sy);
    return this;
  }

  CairoCanvasImpl rotate(double angle) {
    _bindings.cairo_rotate(_ctx, angle);
    return this;
  }

  CairoCanvasImpl identityMatrix() {
    _bindings.cairo_identity_matrix(_ctx);
    return this;
  }

  // ==================== Text Operations ====================

  CairoCanvasImpl selectFontFace(String family,
      {FontSlant slant = FontSlant.normal,
      FontWeight weight = FontWeight.normal}) {
    final familyPtr = family.toNativeUtf8().cast<ffi.Char>();
    final cairoSlant = switch (slant) {
      FontSlant.normal => cairo_ffi.CairoFontSlantEnum.CAIRO_FONT_SLANT_NORMAL,
      FontSlant.italic => cairo_ffi.CairoFontSlantEnum.CAIRO_FONT_SLANT_ITALIC,
      FontSlant.oblique =>
        cairo_ffi.CairoFontSlantEnum.CAIRO_FONT_SLANT_OBLIQUE,
    };
    final cairoWeight = switch (weight) {
      FontWeight.normal =>
        cairo_ffi.CairoFontWeightEnum.CAIRO_FONT_WEIGHT_NORMAL,
      FontWeight.bold => cairo_ffi.CairoFontWeightEnum.CAIRO_FONT_WEIGHT_BOLD,
    };
    try {
      _bindings.cairo_select_font_face(
          _ctx, familyPtr, cairoSlant, cairoWeight);
    } finally {
      calloc.free(familyPtr);
    }
    return this;
  }

  /// Set a font face from a file path (cached)
  CairoCanvasImpl setFontFaceFromFile(String fontPath, {int faceIndex = 0}) {
    final face = cairo.getCachedFont(fontPath, faceIndex: faceIndex);
    if (face == null) {
      throw ArgumentError('Failed to load font: $fontPath');
    }
    _bindings.cairo_set_font_face(_ctx, face.cairoFontFace);
    return this;
  }

  /// Set a Cairo+FreeType font face directly
  CairoCanvasImpl setCairoFontFace(CairoFreeTypeFaceImpl face) {
    if (face.isDisposed) {
      throw ArgumentError('Font face has been disposed');
    }
    _bindings.cairo_set_font_face(_ctx, face.cairoFontFace);
    return this;
  }

  CairoCanvasImpl setFontSize(double size) {
    _bindings.cairo_set_font_size(_ctx, size);
    return this;
  }

  CairoCanvasImpl showText(String text) {
    final textPtr = text.toNativeUtf8().cast<ffi.Char>();
    try {
      _bindings.cairo_show_text(_ctx, textPtr);
    } finally {
      calloc.free(textPtr);
    }
    return this;
  }

  CairoCanvasImpl textPath(String text) {
    final textPtr = text.toNativeUtf8().cast<ffi.Char>();
    try {
      _bindings.cairo_text_path(_ctx, textPtr);
    } finally {
      calloc.free(textPtr);
    }
    return this;
  }

  CairoCanvasImpl drawText(String text, double x, double y) {
    moveTo(x, y);
    showText(text);
    return this;
  }

  // ==================== Convenience Methods ====================

  CairoCanvasImpl drawLine(double x1, double y1, double x2, double y2) {
    moveTo(x1, y1);
    lineTo(x2, y2);
    stroke();
    return this;
  }

  CairoCanvasImpl strokeRect(double x, double y, double width, double height) {
    rectangle(x, y, width, height);
    stroke();
    return this;
  }

  CairoCanvasImpl fillRect(double x, double y, double width, double height) {
    rectangle(x, y, width, height);
    fill();
    return this;
  }

  static const double _pi = 3.141592653589793;

  CairoCanvasImpl strokeCircle(double cx, double cy, double radius) {
    newSubPath();
    arc(cx, cy, radius, 0, 2 * _pi);
    closePath();
    stroke();
    return this;
  }

  CairoCanvasImpl fillCircle(double cx, double cy, double radius) {
    newSubPath();
    arc(cx, cy, radius, 0, 2 * _pi);
    closePath();
    fill();
    return this;
  }

  CairoCanvasImpl strokeEllipse(double cx, double cy, double rx, double ry) {
    save();
    translate(cx, cy);
    scale(rx, ry);
    newSubPath();
    arc(0, 0, 1, 0, 2 * _pi);
    closePath();
    restore();
    stroke();
    return this;
  }

  CairoCanvasImpl fillEllipse(double cx, double cy, double rx, double ry) {
    save();
    translate(cx, cy);
    scale(rx, ry);
    newSubPath();
    arc(0, 0, 1, 0, 2 * _pi);
    closePath();
    restore();
    fill();
    return this;
  }

  CairoCanvasImpl clear([CairoColor color = CairoColor.white]) {
    save();
    setColor(color);
    paint();
    restore();
    return this;
  }

  CairoCanvasImpl roundedRect(
      double x, double y, double width, double height, double radius) {
    final r = radius.clamp(0, width / 2).clamp(0, height / 2).toDouble();
    newPath();
    moveTo(x + r, y);
    lineTo(x + width - r, y);
    arc(x + width - r, y + r, r, -_pi / 2, 0);
    lineTo(x + width, y + height - r);
    arc(x + width - r, y + height - r, r, 0, _pi / 2);
    lineTo(x + r, y + height);
    arc(x + r, y + height - r, r, _pi / 2, _pi);
    lineTo(x, y + r);
    arc(x + r, y + r, r, _pi, _pi * 1.5);
    closePath();
    return this;
  }

  CairoCanvasImpl strokeRoundedRect(
      double x, double y, double width, double height, double radius) {
    roundedRect(x, y, width, height, radius);
    stroke();
    return this;
  }

  CairoCanvasImpl fillRoundedRect(
      double x, double y, double width, double height, double radius) {
    roundedRect(x, y, width, height, radius);
    fill();
    return this;
  }

  CairoCanvasImpl polyline(List<Point> points) {
    if (points.isEmpty) return this;
    moveTo(points.first.x, points.first.y);
    for (var i = 1; i < points.length; i++) {
      lineTo(points[i].x, points[i].y);
    }
    return this;
  }

  CairoCanvasImpl polygon(List<Point> points) {
    polyline(points);
    closePath();
    return this;
  }

  // ==================== Output ====================

  bool saveToPng(String filename) {
    surface.flush();
    return surface.saveToPng(filename);
  }

  Uint8List? getData() {
    surface.flush();
    return surface.getData();
  }

  // ==================== Cleanup ====================

  void dispose() {
    if (!_disposed) {
      _bindings.cairo_destroy(_ctx);
      surface.dispose();
      _disposed = true;
    }
  }

  bool get isDisposed => _disposed;
}

/// Cairo+FreeType font face implementation
class CairoFreeTypeFaceImpl {
  final Cairo cairo;
  final FreeTypeFace _ftFace;
  ffi.Pointer<cairo_ffi.cairo_font_face_t> _cairoFontFace;
  bool _disposed = false;

  CairoFreeTypeFaceImpl._(this.cairo, this._ftFace, this._cairoFontFace);

  /// Get the Cairo bindings
  cairo_ffi.CairoBindings get _bindings => cairo._bindings;

  /// Get the underlying FreeType face
  FreeTypeFace get ftFace => _ftFace;

  /// Get the Cairo font face pointer
  ffi.Pointer<cairo_ffi.cairo_font_face_t> get cairoFontFace {
    if (_disposed) throw StateError('Cairo font face has been disposed');
    return _cairoFontFace;
  }

  /// Get font family name
  String? get familyName => _ftFace.familyName;

  /// Get font style name
  String? get styleName => _ftFace.styleName;

  /// Get number of glyphs
  int get numGlyphs => _ftFace.numGlyphs;

  /// Check if this is a scalable font
  bool get isScalable => _ftFace.isScalable;

  /// Dispose of the Cairo font face only
  void disposeCairoFace() {
    if (_disposed) return;
    _disposed = true;

    if (_cairoFontFace != ffi.nullptr) {
      _bindings.cairo_font_face_destroy(_cairoFontFace);
      _cairoFontFace = ffi.nullptr;
    }
  }

  /// Dispose of both Cairo and FreeType resources
  void dispose() {
    disposeCairoFace();
    _ftFace.dispose();
  }

  /// Check if disposed
  bool get isDisposed => _disposed;
}

// Extension for native string conversion
extension _StringToNative on String {
  ffi.Pointer<ffi.Char> toNativeUtf8() {
    final units = codeUnits;
    final ptr = calloc<ffi.Uint8>(units.length + 1);
    for (var i = 0; i < units.length; i++) {
      ptr[i] = units[i];
    }
    ptr[units.length] = 0;
    return ptr.cast();
  }
}
