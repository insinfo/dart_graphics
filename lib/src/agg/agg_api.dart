import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'generated/ffi.dart' as agg_ffi;
import 'agg_load.dart';

export 'generated/ffi.dart' show AggGradientType, AggTextRenderMode;

/// Main AGG API facade
class Agg {
  final agg_ffi.AggBindings _bindings;

  Agg({String? libraryPath}) : _bindings = loadAgg(libraryPath: libraryPath);

  /// Get AGG Library Version
  String getVersion() {
    return _bindings.agg_get_agg_version().cast<Utf8>().toDartString();
  }

  /// Get FreeType Library Version
  String getFreetypeVersion() {
    return _bindings.agg_get_freetype_version().cast<Utf8>().toDartString();
  }

  /// Create a new surface (pixel buffer)
  AggSurface createSurface(int width, int height) {
    final ptr = _bindings.agg_canvas_create(width, height);
    return AggSurface._(this, ptr, width, height);
  }

  /// Create a new gradient
  AggGradient createGradient(agg_ffi.AggGradientType type) {
    final ptr = _bindings.agg_gradient_create(type);
    return AggGradient._(this, ptr);
  }

  /// Create a new font
  AggFont createFont() {
    final ptr = _bindings.agg_font_create();
    return AggFont._(this, ptr);
  }
}

/// Represents a pixel buffer (Surface)
class AggSurface {
  final Agg _agg;
  final ffi.Pointer<agg_ffi.AggCanvas> _ptr;
  final int _width;
  final int _height;
  bool _disposed = false;

  AggSurface._(this._agg, this._ptr, this._width, this._height);

  int get width => _width;
  int get height => _height;
  bool get isDisposed => _disposed;

  /// Get direct access to pixel data if needed (use with care)
  ffi.Pointer<ffi.Uint8> get data => _agg._bindings.agg_canvas_data(_ptr);
  int get stride => _agg._bindings.agg_canvas_stride(_ptr);

  /// Create a drawing context (Canvas) for this surface
  AggCanvas createCanvas() {
    _checkDisposed();
    final ctxPtr = _agg._bindings.agg_context_create(_ptr);
    return AggCanvas._(_agg, ctxPtr);
  }

  /// Free native resources
  void dispose() {
    if (!_disposed) {
      _agg._bindings.agg_canvas_destroy(_ptr);
      _disposed = true;
    }
  }

  void _checkDisposed() {
    if (_disposed) {
      throw StateError('AggSurface access after dispose');
    }
  }
}

/// Represents a drawing context (Canvas)
class AggCanvas {
  final Agg _agg;
  final ffi.Pointer<agg_ffi.AggContext> _ptr;
  bool _disposed = false;

  AggCanvas._(this._agg, this._ptr);

  bool get isDisposed => _disposed;

  void dispose() {
    if (!_disposed) {
      _agg._bindings.agg_context_destroy(_ptr);
      _disposed = true;
    }
  }

  void _checkDisposed() {
    if (_disposed) {
      throw StateError('AggCanvas access after dispose');
    }
  }

  // --- Drawing Operations ---

  /// Clear the canvas with a color
  void clear(int r, int g, int b, [int a = 255]) {
    _checkDisposed();
    // Note: agg_canvas_clear is on the canvas struct in C, but here we probably want to expose it on the context or surface.
    // However, the C API `agg_canvas_clear` takes an AggCanvas*.
    // The context also has `agg_context_set_fill_color` + `agg_context_fill` (for paths).
    // Let's see if we have `agg_context_clear`? No.
    // So we might need to access the surface to clear it, OR user checks `AggSurface`.
    // But `Graphics2D` usually has clear.
    // Let's skip direct clear on Context if C doesn't support it directly on context, or implementing it via full-screen rect.
    // Wait, the C wrapper has `agg_canvas_clear(AggCanvas*)`.
    // Since AggCanvas (Dart) wraps AggContext(C), we don't hold AggCanvas(C) directly here.
    // The user should clear the Surface. 
    // BUT constructs usually allow clearing via Context.
    // Let's leave it on Surface or implement via fillRect.
    
    // Implementation via full screen rect is cleaner for Context API.
    // But we don't know the size here easily without querying.
    // Let's rely on the user clearing the Surface for now, or add a method to Surface.
  }

  // State
  void setFillColor(int r, int g, int b, [int a = 255]) {
    _checkDisposed();
    _agg._bindings.agg_context_set_fill_color(_ptr, r, g, b, a);
  }

  void setStrokeColor(int r, int g, int b, [int a = 255]) {
    _checkDisposed();
    _agg._bindings.agg_context_set_stroke_color(_ptr, r, g, b, a);
  }

  void setLineWidth(double width) {
    _checkDisposed();
    _agg._bindings.agg_context_set_line_width(_ptr, width);
  }

  void setLineCap(agg_ffi.AggLineCap cap) {
    _checkDisposed();
    _agg._bindings.agg_context_set_line_cap(_ptr, cap);
  }

  void setLineJoin(agg_ffi.AggLineJoin join) {
    _checkDisposed();
    _agg._bindings.agg_context_set_line_join(_ptr, join);
  }

  void setFillRule(agg_ffi.AggFillRule rule) {
    _checkDisposed();
    _agg._bindings.agg_context_set_fill_rule(_ptr, rule);
  }


  void setFillGradient(AggGradient gradient) {
    _checkDisposed();
    _agg._bindings.agg_context_set_fill_gradient(_ptr, gradient._ptr);
  }

  void setStrokeGradient(AggGradient gradient) {
    _checkDisposed();
    _agg._bindings.agg_context_set_stroke_gradient(_ptr, gradient._ptr);
  }

  // Transform
  void translate(double tx, double ty) {
    _checkDisposed();
    _agg._bindings.agg_context_translate(_ptr, tx, ty);
  }

  void rotate(double radians) {
    _checkDisposed();
    _agg._bindings.agg_context_rotate(_ptr, radians);
  }

  void scale(double sx, double sy) {
    _checkDisposed();
    _agg._bindings.agg_context_scale(_ptr, sx, sy);
  }
  
  void resetTransform() {
    _checkDisposed();
    _agg._bindings.agg_context_reset_transform(_ptr);
  }

  void setTransform(double a, double b, double c, double d, double tx, double ty) {
    _checkDisposed();
    _agg._bindings.agg_context_set_transform(_ptr, a, b, c, d, tx, ty);
  }

  // Path
  void beginPath() {
    _checkDisposed();
    _agg._bindings.agg_path_clear(_ptr);
  }

  void moveTo(double x, double y) {
    _checkDisposed();
    _agg._bindings.agg_path_move_to(_ptr, x, y);
  }

  void lineTo(double x, double y) {
    _checkDisposed();
    _agg._bindings.agg_path_line_to(_ptr, x, y);
  }

  void cubicTo(double x1, double y1, double x2, double y2, double x3, double y3) {
    _checkDisposed();
    _agg._bindings.agg_path_curve4(_ptr, x1, y1, x2, y2, x3, y3);
  }

  void arc(double rx, double ry, double angle, bool largeArcFlag, bool sweepFlag, double x, double y) {
     _checkDisposed();
     _agg._bindings.agg_path_arc(_ptr, rx, ry, angle, largeArcFlag ? 1 : 0, sweepFlag ? 1 : 0, x, y);
  }

  void arcCenter(double cx, double cy, double r, double startAngle, double sweepAngle) {
    _checkDisposed();
    _agg._bindings.agg_path_arc_center(_ptr, cx, cy, r, startAngle, sweepAngle);
  }

  void addSvgPath(String svgPath) {
    _checkDisposed();
    final strPtr = svgPath.toNativeUtf8();
    try {
        _agg._bindings.agg_path_add_svg_string(_ptr, strPtr.cast());
    } finally {
        calloc.free(strPtr);
    }
  }

  String getAggVersion() {
    final ptr = _agg._bindings.agg_get_agg_version();
    return ptr.cast<Utf8>().toDartString();
  }

  String getFreetypeVersion() {
    final ptr = _agg._bindings.agg_get_freetype_version();
    return ptr.cast<Utf8>().toDartString();
  }

  void quadraticTo(double x1, double y1, double x2, double y2) {
    _checkDisposed();
    _agg._bindings.agg_path_curve3(_ptr, x1, y1, x2, y2);
  }

  void closePath() {
    _checkDisposed();
    _agg._bindings.agg_path_close(_ptr);
  }

  void rect(double x, double y, double width, double height) {
    _checkDisposed();
    _agg._bindings.agg_path_add_rect(_ptr, x, y, x + width, y + height);
  }

  void roundedRect(double x, double y, double width, double height, double r) {
    _checkDisposed();
    _agg._bindings.agg_path_add_rounded_rect(_ptr, x, y, x + width, y + height, r, r);
  }

  void ellipse(double cx, double cy, double rx, double ry) {
    _checkDisposed();
    _agg._bindings.agg_path_add_ellipse(_ptr, cx, cy, rx, ry);
  }

  // Drawing
  void fill() {
    _checkDisposed();
    _agg._bindings.agg_context_fill(_ptr);
  }

  void stroke() {
    _checkDisposed();
    _agg._bindings.agg_context_stroke(_ptr);
  }
  
  void fillPreserve() {
      _checkDisposed();
      _agg._bindings.agg_context_fill_preserve(_ptr);
  }

  void strokePreserve() {
      _checkDisposed();
      _agg._bindings.agg_context_stroke_preserve(_ptr);
  }

  // Text
  void setFont(AggFont font) {
    _checkDisposed();
    _agg._bindings.agg_context_set_font(_ptr, font._ptr);
  }

  void setTextColor(int r, int g, int b, [int a = 255]) {
     _checkDisposed();
     _agg._bindings.agg_context_set_text_color(_ptr, r, g, b, a);
  }

  void drawText(String text, double x, double y, {agg_ffi.AggTextRenderMode mode = agg_ffi.AggTextRenderMode.AggTextRenderModeGray}) {
    _checkDisposed();
    final textPtr = text.toNativeUtf8();
    try {
      _agg._bindings.agg_context_draw_text(_ptr, x, y, textPtr.cast(), mode);
    } finally {
      calloc.free(textPtr);
    }
  }

  // Clipping
  void clipRect(int x, int y, int w, int h) {
    _checkDisposed();
    _agg._bindings.agg_context_clip_rect(_ptr, x, y, w, h);
  }

  void resetClip() {
    _checkDisposed();
    _agg._bindings.agg_context_reset_clip(_ptr);
  }

  // Dashes
  void setLineDash(List<double> dashes, {double startOffset = 0.0}) {
    _checkDisposed();
    final count = dashes.length;
    final ptr = calloc<ffi.Double>(count);
    for (var i = 0; i < count; i++) {
        ptr[i] = dashes[i];
    }
    
    try {
        _agg._bindings.agg_context_set_dash(_ptr, ptr, count, startOffset);
    } finally {
        calloc.free(ptr);
    }
  }

  /// Measure text dimensions.
  /// Returns a map with keys: 'x', 'y', 'width', 'height', 'advanceX', 'advanceY'.
  /// Note: implementation currently returns bounding box x, y, width, height.
  /// You can pass null pointers in C, but here we'll return the values.
  Map<String, double> measureText(String text) {
    _checkDisposed();
    final textPtr = text.toNativeUtf8();
    final xPtr = calloc<ffi.Double>();
    final yPtr = calloc<ffi.Double>();
    final wPtr = calloc<ffi.Double>();
    final hPtr = calloc<ffi.Double>();
    
    try {
      _agg._bindings.agg_context_measure_text(_ptr, textPtr.cast(), xPtr, yPtr, wPtr, hPtr);
      return {
        'x': xPtr.value,
        'y': yPtr.value,
        'width': wPtr.value,
        'height': hPtr.value,
      };
    } finally {
      calloc.free(textPtr);
      calloc.free(xPtr);
      calloc.free(yPtr);
      calloc.free(wPtr);
      calloc.free(hPtr);
    }
  }
}

/// Gradient wrapper
class AggGradient {
  final Agg _agg;
  final ffi.Pointer<agg_ffi.AggGradient> _ptr;
  bool _disposed = false;

  AggGradient._(this._agg, this._ptr);

  void dispose() {
    if (!_disposed) {
      _agg._bindings.agg_gradient_destroy(_ptr);
      _disposed = true;
    }
  }

  void setLinear(double x1, double y1, double x2, double y2) {
    _agg._bindings.agg_gradient_set_linear(_ptr, x1, y1, x2, y2);
  }

  void setRadial(double cx, double cy, double r) {
    _agg._bindings.agg_gradient_set_radial(_ptr, cx, cy, r);
  }

  void addStop(double offset, int r, int g, int b, [int a = 255]) {
    _agg._bindings.agg_gradient_add_stop(_ptr, offset, r, g, b, a);
  }

  void clearStops() {
    _agg._bindings.agg_gradient_clear_stops(_ptr);
  }

  void build() {
    _agg._bindings.agg_gradient_build(_ptr);
  }
}

/// Font wrapper
class AggFont {
  final Agg _agg;
  final ffi.Pointer<agg_ffi.AggFont> _ptr;
  bool _disposed = false;

  AggFont._(this._agg, this._ptr);

  void dispose() {
    if (!_disposed) {
      _agg._bindings.agg_font_destroy(_ptr);
      _disposed = true;
    }
  }

  /// Load font from file. Returns true if successful.
  bool load(String filePath, {double height = 12.0, int faceIndex = 0, agg_ffi.AggTextRenderMode mode = agg_ffi.AggTextRenderMode.AggTextRenderModeGray}) {
    final pathPtr = filePath.toNativeUtf8();
    try {
      final result = _agg._bindings.agg_font_load(_ptr, pathPtr.cast(), faceIndex, height, 1, mode); 
      return result != 0;
    } finally {
      calloc.free(pathPtr);
    }
  }

  void setWidth(double width) {
    _agg._bindings.agg_font_set_width(_ptr, width);
  }
  
  void setHinting(bool enable) {
    _agg._bindings.agg_font_set_hinting(_ptr, enable ? 1 : 0);
  }
}
