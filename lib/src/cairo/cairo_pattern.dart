/// Cairo Pattern support (gradients, solid colors, surface patterns)

import 'dart:ffi' as ffi;

import 'generated/ffi.dart';
import 'cairo_types.dart';
import 'cairo_api.dart';

/// Base class for Cairo patterns
abstract class CairoPattern {
  ffi.Pointer<cairo_pattern_t> get pointer;
  
  /// Get the Cairo instance
  Cairo get cairo;
  
  /// Get Cairo bindings
  CairoBindings get _bindings => cairo.bindings;
  
  /// Check pattern status
  CairoStatusEnum get status => _bindings.cairo_pattern_status(pointer);
  
  /// Check if pattern is valid
  bool get isValid => status == CairoStatusEnum.CAIRO_STATUS_SUCCESS;
  
  /// Set the extend mode for the pattern
  void setExtend(CairoExtendEnum extend) {
    _bindings.cairo_pattern_set_extend(pointer, extend);
  }
  
  /// Get the extend mode
  CairoExtendEnum getExtend() {
    return _bindings.cairo_pattern_get_extend(pointer);
  }
  
  /// Set the filter for the pattern
  void setFilter(CairoFilterEnum filter) {
    _bindings.cairo_pattern_set_filter(pointer, filter);
  }
  
  /// Get the filter
  CairoFilterEnum getFilter() {
    return _bindings.cairo_pattern_get_filter(pointer);
  }
  
  /// Dispose the pattern
  void dispose();
}

/// A solid color pattern
class SolidPattern extends CairoPattern {
  @override
  final Cairo cairo;
  final ffi.Pointer<cairo_pattern_t> _ptr;
  bool _disposed = false;
  
  @override
  ffi.Pointer<cairo_pattern_t> get pointer => _ptr;
  
  SolidPattern._(this.cairo, this._ptr);
  
  /// Create a solid RGB pattern
  factory SolidPattern.rgb(Cairo cairo, double r, double g, double b) {
    final ptr = cairo.bindings.cairo_pattern_create_rgb(r, g, b);
    return SolidPattern._(cairo, ptr);
  }
  
  /// Create a solid RGBA pattern
  factory SolidPattern.rgba(Cairo cairo, double r, double g, double b, double a) {
    final ptr = cairo.bindings.cairo_pattern_create_rgba(r, g, b, a);
    return SolidPattern._(cairo, ptr);
  }
  
  /// Create from a CairoColor
  factory SolidPattern.fromColor(Cairo cairo, CairoColor color) {
    return SolidPattern.rgba(cairo, color.r, color.g, color.b, color.a);
  }
  
  @override
  void dispose() {
    if (!_disposed) {
      _bindings.cairo_pattern_destroy(_ptr);
      _disposed = true;
    }
  }
}

/// A linear gradient pattern
class LinearGradient extends CairoPattern {
  @override
  final Cairo cairo;
  final ffi.Pointer<cairo_pattern_t> _ptr;
  bool _disposed = false;
  
  @override
  ffi.Pointer<cairo_pattern_t> get pointer => _ptr;
  
  LinearGradient._(this.cairo, this._ptr);
  
  /// Create a linear gradient from (x0, y0) to (x1, y1)
  factory LinearGradient(Cairo cairo, double x0, double y0, double x1, double y1) {
    final ptr = cairo.bindings.cairo_pattern_create_linear(x0, y0, x1, y1);
    return LinearGradient._(cairo, ptr);
  }
  
  /// Add a color stop at the given offset (0.0-1.0)
  LinearGradient addColorStopRgb(double offset, double r, double g, double b) {
    _bindings.cairo_pattern_add_color_stop_rgb(_ptr, offset, r, g, b);
    return this;
  }
  
  /// Add a color stop with alpha at the given offset (0.0-1.0)
  LinearGradient addColorStopRgba(double offset, double r, double g, double b, double a) {
    _bindings.cairo_pattern_add_color_stop_rgba(_ptr, offset, r, g, b, a);
    return this;
  }
  
  /// Add a color stop from a CairoColor
  LinearGradient addColorStop(double offset, CairoColor color) {
    _bindings.cairo_pattern_add_color_stop_rgba(
      _ptr, offset, color.r, color.g, color.b, color.a);
    return this;
  }
  
  @override
  void dispose() {
    if (!_disposed) {
      _bindings.cairo_pattern_destroy(_ptr);
      _disposed = true;
    }
  }
}

/// A radial gradient pattern
class RadialGradient extends CairoPattern {
  @override
  final Cairo cairo;
  final ffi.Pointer<cairo_pattern_t> _ptr;
  bool _disposed = false;
  
  @override
  ffi.Pointer<cairo_pattern_t> get pointer => _ptr;
  
  RadialGradient._(this.cairo, this._ptr);
  
  /// Create a radial gradient between two circles
  /// (cx0, cy0, radius0) defines the start circle
  /// (cx1, cy1, radius1) defines the end circle
  factory RadialGradient(
    Cairo cairo,
    double cx0, double cy0, double radius0,
    double cx1, double cy1, double radius1,
  ) {
    final ptr = cairo.bindings.cairo_pattern_create_radial(cx0, cy0, radius0, cx1, cy1, radius1);
    return RadialGradient._(cairo, ptr);
  }
  
  /// Create a radial gradient centered at a point with start and end radius
  factory RadialGradient.centered(Cairo cairo, double cx, double cy, double innerRadius, double outerRadius) {
    return RadialGradient(cairo, cx, cy, innerRadius, cx, cy, outerRadius);
  }
  
  /// Add a color stop at the given offset (0.0-1.0)
  RadialGradient addColorStopRgb(double offset, double r, double g, double b) {
    _bindings.cairo_pattern_add_color_stop_rgb(_ptr, offset, r, g, b);
    return this;
  }
  
  /// Add a color stop with alpha at the given offset (0.0-1.0)
  RadialGradient addColorStopRgba(double offset, double r, double g, double b, double a) {
    _bindings.cairo_pattern_add_color_stop_rgba(_ptr, offset, r, g, b, a);
    return this;
  }
  
  /// Add a color stop from a CairoColor
  RadialGradient addColorStop(double offset, CairoColor color) {
    _bindings.cairo_pattern_add_color_stop_rgba(
      _ptr, offset, color.r, color.g, color.b, color.a);
    return this;
  }
  
  @override
  void dispose() {
    if (!_disposed) {
      _bindings.cairo_pattern_destroy(_ptr);
      _disposed = true;
    }
  }
}

/// A surface pattern (for tiling images)
class SurfacePattern extends CairoPattern {
  @override
  final Cairo cairo;
  final ffi.Pointer<cairo_pattern_t> _ptr;
  bool _disposed = false;
  
  @override
  ffi.Pointer<cairo_pattern_t> get pointer => _ptr;
  
  SurfacePattern._(this.cairo, this._ptr);
  
  /// Create a pattern from a surface pointer
  factory SurfacePattern.fromPointer(Cairo cairo, ffi.Pointer<cairo_surface_t> surfacePtr) {
    final ptr = cairo.bindings.cairo_pattern_create_for_surface(surfacePtr);
    return SurfacePattern._(cairo, ptr);
  }
  
  @override
  void dispose() {
    if (!_disposed) {
      _bindings.cairo_pattern_destroy(_ptr);
      _disposed = true;
    }
  }
}
