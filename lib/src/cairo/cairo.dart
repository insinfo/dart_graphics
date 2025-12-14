/// High-level Cairo Graphics API for Dart
///
/// This library provides an easy-to-use API on top of the raw Cairo FFI bindings,
/// hiding pointer complexity and memory management from the user.
///
/// Example:
/// ```dart
/// final canvas = CairoCanvas(800, 600);
/// canvas
///   ..setSourceRgb(1.0, 0.0, 0.0)  // Red
///   ..moveTo(100, 100)
///   ..lineTo(200, 200)
///   ..stroke()
///   ..saveToPng('output.png');
/// canvas.dispose();
/// ```
library cairo;

import 'dart:ffi' as ffi;
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'cairo_load.dart';
import 'generated/ffi.dart';

/// Global Cairo library instance
late final CairoBindings _cairo = loadCairo();

/// A 2D point
class Point {
  final double x;
  final double y;

  const Point(this.x, this.y);

  @override
  String toString() => 'Point($x, $y)';
}

/// A rectangle defined by position and size
class Rect {
  final double x;
  final double y;
  final double width;
  final double height;

  const Rect(this.x, this.y, this.width, this.height);

  double get left => x;
  double get top => y;
  double get right => x + width;
  double get bottom => y + height;

  @override
  String toString() => 'Rect($x, $y, $width, $height)';
}

/// RGBA Color with components in 0.0-1.0 range
class CairoColor {
  final double r;
  final double g;
  final double b;
  final double a;

  const CairoColor(this.r, this.g, this.b, [this.a = 1.0]);

  /// Create from 0-255 integer components
  factory CairoColor.fromRgba(int r, int g, int b, [int a = 255]) {
    return CairoColor(r / 255.0, g / 255.0, b / 255.0, a / 255.0);
  }

  /// Create from hex color code (e.g., 0xFF0000 for red)
  factory CairoColor.fromHex(int hex, [double alpha = 1.0]) {
    return CairoColor(
      ((hex >> 16) & 0xFF) / 255.0,
      ((hex >> 8) & 0xFF) / 255.0,
      (hex & 0xFF) / 255.0,
      alpha,
    );
  }

  // Common colors
  static const black = CairoColor(0.0, 0.0, 0.0);
  static const white = CairoColor(1.0, 1.0, 1.0);
  static const red = CairoColor(1.0, 0.0, 0.0);
  static const green = CairoColor(0.0, 1.0, 0.0);
  static const blue = CairoColor(0.0, 0.0, 1.0);
  static const yellow = CairoColor(1.0, 1.0, 0.0);
  static const cyan = CairoColor(0.0, 1.0, 1.0);
  static const magenta = CairoColor(1.0, 0.0, 1.0);
  static const transparent = CairoColor(0.0, 0.0, 0.0, 0.0);

  @override
  String toString() => 'CairoColor($r, $g, $b, $a)';
}

/// Font style options
enum FontSlant {
  normal,
  italic,
  oblique,
}

/// Font weight options
enum FontWeight {
  normal,
  bold,
}

/// Line cap styles
enum LineCap {
  butt,
  round,
  square,
}

/// Line join styles
enum LineJoin {
  miter,
  round,
  bevel,
}

/// A Cairo image surface for drawing
class CairoSurface {
  final ffi.Pointer<cairo_surface_t> _ptr;
  final int width;
  final int height;
  final CairoFormatEnum format;
  bool _disposed = false;

  CairoSurface._(this._ptr, this.width, this.height, this.format);

  /// Create an image surface with the given dimensions
  factory CairoSurface.image(int width, int height,
      {CairoFormatEnum format = CairoFormatEnum.CAIRO_FORMAT_ARGB32}) {
    final ptr = _cairo.cairo_image_surface_create(format, width, height);
    return CairoSurface._(ptr, width, height, format);
  }

  /// Create a surface from raw pixel data
  factory CairoSurface.fromData(
    Uint8List data,
    int width,
    int height, {
    CairoFormatEnum format = CairoFormatEnum.CAIRO_FORMAT_ARGB32,
  }) {
    final stride = _cairo.cairo_format_stride_for_width(format, width);
    final dataPtr = calloc<ffi.UnsignedChar>(data.length);
    for (var i = 0; i < data.length; i++) {
      dataPtr[i] = data[i];
    }
    final ptr = _cairo.cairo_image_surface_create_for_data(
        dataPtr, format, width, height, stride);
    return CairoSurface._(ptr, width, height, format);
  }

  /// Get the raw pointer (for advanced use)
  ffi.Pointer<cairo_surface_t> get pointer => _ptr;

  /// Check the surface status
  CairoStatusEnum get status => _cairo.cairo_surface_status(_ptr);

  /// Check if surface is valid
  bool get isValid => status == CairoStatusEnum.CAIRO_STATUS_SUCCESS;

  /// Get the pixel data from the surface
  Uint8List? getData() {
    final dataPtr = _cairo.cairo_image_surface_get_data(_ptr);
    if (dataPtr == ffi.nullptr) return null;

    final stride = _cairo.cairo_image_surface_get_stride(_ptr);
    final totalBytes = stride * height;
    return dataPtr.cast<ffi.Uint8>().asTypedList(totalBytes);
  }

  /// Save surface to a PNG file
  bool saveToPng(String filename) {
    final filenamePtr = filename.toNativeUtf8().cast<ffi.Char>();
    try {
      final result = _cairo.cairo_surface_write_to_png(_ptr, filenamePtr);
      return result == CairoStatusEnum.CAIRO_STATUS_SUCCESS;
    } finally {
      calloc.free(filenamePtr);
    }
  }

  /// Flush any pending drawing operations
  void flush() {
    _cairo.cairo_surface_flush(_ptr);
  }

  /// Mark the entire surface as dirty
  void markDirty() {
    _cairo.cairo_surface_mark_dirty(_ptr);
  }

  /// Mark a rectangle as dirty
  void markDirtyRect(int x, int y, int width, int height) {
    _cairo.cairo_surface_mark_dirty_rectangle(_ptr, x, y, width, height);
  }

  /// Dispose the surface and free resources
  void dispose() {
    if (!_disposed) {
      _cairo.cairo_surface_destroy(_ptr);
      _disposed = true;
    }
  }
}

/// High-level Cairo drawing canvas
///
/// This class wraps a Cairo context and provides an easy-to-use API for 2D drawing.
class CairoCanvas {
  final CairoSurface surface;
  final ffi.Pointer<cairo_t> _ctx;
  bool _disposed = false;

  /// Create a new canvas with the given dimensions
  factory CairoCanvas(int width, int height,
      {CairoFormatEnum format = CairoFormatEnum.CAIRO_FORMAT_ARGB32}) {
    final surface = CairoSurface.image(width, height, format: format);
    return CairoCanvas.fromSurface(surface);
  }

  /// Create a canvas from an existing surface
  CairoCanvas.fromSurface(this.surface)
      : _ctx = _cairo.cairo_create(surface._ptr);

  /// Width of the canvas
  int get width => surface.width;

  /// Height of the canvas
  int get height => surface.height;

  /// Get the raw context pointer (for advanced use)
  ffi.Pointer<cairo_t> get pointer => _ctx;

  /// Check context status
  CairoStatusEnum get status => _cairo.cairo_status(_ctx);

  /// Check if context is valid
  bool get isValid => status == CairoStatusEnum.CAIRO_STATUS_SUCCESS;

  // ==================== State Management ====================

  /// Save the current drawing state
  CairoCanvas save() {
    _cairo.cairo_save(_ctx);
    return this;
  }

  /// Restore a previously saved drawing state
  CairoCanvas restore() {
    _cairo.cairo_restore(_ctx);
    return this;
  }

  // ==================== Color & Source ====================

  /// Set the source color (RGB)
  CairoCanvas setSourceRgb(double r, double g, double b) {
    _cairo.cairo_set_source_rgb(_ctx, r, g, b);
    return this;
  }

  /// Set the source color (RGBA)
  CairoCanvas setSourceRgba(double r, double g, double b, double a) {
    _cairo.cairo_set_source_rgba(_ctx, r, g, b, a);
    return this;
  }

  /// Set the source color from a CairoColor
  CairoCanvas setColor(CairoColor color) {
    _cairo.cairo_set_source_rgba(_ctx, color.r, color.g, color.b, color.a);
    return this;
  }

  // ==================== Line Style ====================

  /// Set the line width
  CairoCanvas setLineWidth(double width) {
    _cairo.cairo_set_line_width(_ctx, width);
    return this;
  }

  /// Get the current line width
  double getLineWidth() {
    return _cairo.cairo_get_line_width(_ctx);
  }

  /// Set the line cap style
  CairoCanvas setLineCap(LineCap cap) {
    final cairoCap = switch (cap) {
      LineCap.butt => CairoLineCapEnum.CAIRO_LINE_CAP_BUTT,
      LineCap.round => CairoLineCapEnum.CAIRO_LINE_CAP_ROUND,
      LineCap.square => CairoLineCapEnum.CAIRO_LINE_CAP_SQUARE,
    };
    _cairo.cairo_set_line_cap(_ctx, cairoCap);
    return this;
  }

  /// Set the line join style
  CairoCanvas setLineJoin(LineJoin join) {
    final cairoJoin = switch (join) {
      LineJoin.miter => CairoLineJoinEnum.CAIRO_LINE_JOIN_MITER,
      LineJoin.round => CairoLineJoinEnum.CAIRO_LINE_JOIN_ROUND,
      LineJoin.bevel => CairoLineJoinEnum.CAIRO_LINE_JOIN_BEVEL,
    };
    _cairo.cairo_set_line_join(_ctx, cairoJoin);
    return this;
  }

  /// Set the miter limit for mitered joins
  CairoCanvas setMiterLimit(double limit) {
    _cairo.cairo_set_miter_limit(_ctx, limit);
    return this;
  }

  /// Set the dash pattern
  CairoCanvas setDash(List<double> dashes, [double offset = 0.0]) {
    if (dashes.isEmpty) {
      _cairo.cairo_set_dash(_ctx, ffi.nullptr, 0, 0.0);
    } else {
      final dashPtr = calloc<ffi.Double>(dashes.length);
      for (var i = 0; i < dashes.length; i++) {
        dashPtr[i] = dashes[i];
      }
      _cairo.cairo_set_dash(_ctx, dashPtr, dashes.length, offset);
      calloc.free(dashPtr);
    }
    return this;
  }

  /// Clear the dash pattern (solid line)
  CairoCanvas clearDash() {
    _cairo.cairo_set_dash(_ctx, ffi.nullptr, 0, 0.0);
    return this;
  }

  // ==================== Anti-aliasing ====================

  /// Set anti-aliasing mode
  CairoCanvas setAntialias(CairoAntialiasEnum antialias) {
    _cairo.cairo_set_antialias(_ctx, antialias);
    return this;
  }

  // ==================== Fill Rule ====================

  /// Set the fill rule (winding or even-odd)
  CairoCanvas setFillRule(CairoFillRuleEnum rule) {
    _cairo.cairo_set_fill_rule(_ctx, rule);
    return this;
  }

  // ==================== Path Operations ====================

  /// Begin a new path
  CairoCanvas newPath() {
    _cairo.cairo_new_path(_ctx);
    return this;
  }

  /// Begin a new sub-path
  CairoCanvas newSubPath() {
    _cairo.cairo_new_sub_path(_ctx);
    return this;
  }

  /// Move to a point (start a new sub-path)
  CairoCanvas moveTo(double x, double y) {
    _cairo.cairo_move_to(_ctx, x, y);
    return this;
  }

  /// Draw a line to a point
  CairoCanvas lineTo(double x, double y) {
    _cairo.cairo_line_to(_ctx, x, y);
    return this;
  }

  /// Draw a cubic Bezier curve
  CairoCanvas curveTo(
      double x1, double y1, double x2, double y2, double x3, double y3) {
    _cairo.cairo_curve_to(_ctx, x1, y1, x2, y2, x3, y3);
    return this;
  }

  /// Draw an arc
  CairoCanvas arc(
      double xc, double yc, double radius, double angle1, double angle2) {
    _cairo.cairo_arc(_ctx, xc, yc, radius, angle1, angle2);
    return this;
  }

  /// Draw an arc in the negative direction
  CairoCanvas arcNegative(
      double xc, double yc, double radius, double angle1, double angle2) {
    _cairo.cairo_arc_negative(_ctx, xc, yc, radius, angle1, angle2);
    return this;
  }

  /// Move relative to current point
  CairoCanvas relMoveTo(double dx, double dy) {
    _cairo.cairo_rel_move_to(_ctx, dx, dy);
    return this;
  }

  /// Line relative to current point
  CairoCanvas relLineTo(double dx, double dy) {
    _cairo.cairo_rel_line_to(_ctx, dx, dy);
    return this;
  }

  /// Curve relative to current point
  CairoCanvas relCurveTo(
      double dx1, double dy1, double dx2, double dy2, double dx3, double dy3) {
    _cairo.cairo_rel_curve_to(_ctx, dx1, dy1, dx2, dy2, dx3, dy3);
    return this;
  }

  /// Add a rectangle to the path
  CairoCanvas rectangle(double x, double y, double width, double height) {
    _cairo.cairo_rectangle(_ctx, x, y, width, height);
    return this;
  }

  /// Add a rectangle from a Rect object
  CairoCanvas rect(Rect r) {
    _cairo.cairo_rectangle(_ctx, r.x, r.y, r.width, r.height);
    return this;
  }

  /// Close the current sub-path
  CairoCanvas closePath() {
    _cairo.cairo_close_path(_ctx);
    return this;
  }

  // ==================== Drawing Operations ====================

  /// Stroke the current path (draw the outline)
  CairoCanvas stroke() {
    _cairo.cairo_stroke(_ctx);
    return this;
  }

  /// Stroke and preserve the path
  CairoCanvas strokePreserve() {
    _cairo.cairo_stroke_preserve(_ctx);
    return this;
  }

  /// Fill the current path
  CairoCanvas fill() {
    _cairo.cairo_fill(_ctx);
    return this;
  }

  /// Fill and preserve the path
  CairoCanvas fillPreserve() {
    _cairo.cairo_fill_preserve(_ctx);
    return this;
  }

  /// Paint the entire surface with the current source
  CairoCanvas paint() {
    _cairo.cairo_paint(_ctx);
    return this;
  }

  /// Paint with alpha
  CairoCanvas paintWithAlpha(double alpha) {
    _cairo.cairo_paint_with_alpha(_ctx, alpha);
    return this;
  }

  // ==================== Clipping ====================

  /// Clip to the current path
  CairoCanvas clip() {
    _cairo.cairo_clip(_ctx);
    return this;
  }

  /// Clip and preserve the path
  CairoCanvas clipPreserve() {
    _cairo.cairo_clip_preserve(_ctx);
    return this;
  }

  /// Reset the clip region
  CairoCanvas resetClip() {
    _cairo.cairo_reset_clip(_ctx);
    return this;
  }

  // ==================== Transformations ====================

  /// Translate the coordinate system
  CairoCanvas translate(double tx, double ty) {
    _cairo.cairo_translate(_ctx, tx, ty);
    return this;
  }

  /// Scale the coordinate system
  CairoCanvas scale(double sx, double sy) {
    _cairo.cairo_scale(_ctx, sx, sy);
    return this;
  }

  /// Rotate the coordinate system
  CairoCanvas rotate(double angle) {
    _cairo.cairo_rotate(_ctx, angle);
    return this;
  }

  /// Reset transformations to identity
  CairoCanvas identityMatrix() {
    _cairo.cairo_identity_matrix(_ctx);
    return this;
  }

  // ==================== Text Operations ====================

  /// Select a font by family name
  CairoCanvas selectFontFace(String family,
      {FontSlant slant = FontSlant.normal,
      FontWeight weight = FontWeight.normal}) {
    final familyPtr = family.toNativeUtf8().cast<ffi.Char>();
    final cairoSlant = switch (slant) {
      FontSlant.normal => CairoFontSlantEnum.CAIRO_FONT_SLANT_NORMAL,
      FontSlant.italic => CairoFontSlantEnum.CAIRO_FONT_SLANT_ITALIC,
      FontSlant.oblique => CairoFontSlantEnum.CAIRO_FONT_SLANT_OBLIQUE,
    };
    final cairoWeight = switch (weight) {
      FontWeight.normal => CairoFontWeightEnum.CAIRO_FONT_WEIGHT_NORMAL,
      FontWeight.bold => CairoFontWeightEnum.CAIRO_FONT_WEIGHT_BOLD,
    };
    try {
      _cairo.cairo_select_font_face(_ctx, familyPtr, cairoSlant, cairoWeight);
    } finally {
      calloc.free(familyPtr);
    }
    return this;
  }

  /// Set the font size
  CairoCanvas setFontSize(double size) {
    _cairo.cairo_set_font_size(_ctx, size);
    return this;
  }

  /// Show text at the current position
  CairoCanvas showText(String text) {
    final textPtr = text.toNativeUtf8().cast<ffi.Char>();
    try {
      _cairo.cairo_show_text(_ctx, textPtr);
    } finally {
      calloc.free(textPtr);
    }
    return this;
  }

  /// Add text to the path (for stroking/filling)
  CairoCanvas textPath(String text) {
    final textPtr = text.toNativeUtf8().cast<ffi.Char>();
    try {
      _cairo.cairo_text_path(_ctx, textPtr);
    } finally {
      calloc.free(textPtr);
    }
    return this;
  }

  /// Draw text at a specific position
  CairoCanvas drawText(String text, double x, double y) {
    moveTo(x, y);
    showText(text);
    return this;
  }

  // ==================== Convenience Methods ====================

  /// Draw a line from (x1, y1) to (x2, y2)
  CairoCanvas drawLine(double x1, double y1, double x2, double y2) {
    moveTo(x1, y1);
    lineTo(x2, y2);
    stroke();
    return this;
  }

  /// Draw a rectangle outline
  CairoCanvas strokeRect(double x, double y, double width, double height) {
    rectangle(x, y, width, height);
    stroke();
    return this;
  }

  /// Draw a filled rectangle
  CairoCanvas fillRect(double x, double y, double width, double height) {
    rectangle(x, y, width, height);
    fill();
    return this;
  }

  /// Draw a circle outline
  CairoCanvas strokeCircle(double cx, double cy, double radius) {
    newSubPath();
    arc(cx, cy, radius, 0, 2 * 3.141592653589793);
    closePath();
    stroke();
    return this;
  }

  /// Draw a filled circle
  CairoCanvas fillCircle(double cx, double cy, double radius) {
    newSubPath();
    arc(cx, cy, radius, 0, 2 * 3.141592653589793);
    closePath();
    fill();
    return this;
  }

  /// Draw an ellipse outline
  CairoCanvas strokeEllipse(double cx, double cy, double rx, double ry) {
    save();
    translate(cx, cy);
    scale(rx, ry);
    newSubPath();
    arc(0, 0, 1, 0, 2 * 3.141592653589793);
    closePath();
    restore();
    stroke();
    return this;
  }

  /// Draw a filled ellipse
  CairoCanvas fillEllipse(double cx, double cy, double rx, double ry) {
    save();
    translate(cx, cy);
    scale(rx, ry);
    newSubPath();
    arc(0, 0, 1, 0, 2 * 3.141592653589793);
    closePath();
    restore();
    fill();
    return this;
  }

  /// Clear the canvas with a color
  CairoCanvas clear([CairoColor color = CairoColor.white]) {
    save();
    setColor(color);
    paint();
    restore();
    return this;
  }

  /// Draw a rounded rectangle
  CairoCanvas roundedRect(
      double x, double y, double width, double height, double radius) {
    final r = radius.clamp(0, width / 2).clamp(0, height / 2).toDouble();
    newPath();
    moveTo(x + r, y);
    lineTo(x + width - r, y);
    arc(x + width - r, y + r, r, -3.141592653589793 / 2, 0);
    lineTo(x + width, y + height - r);
    arc(x + width - r, y + height - r, r, 0, 3.141592653589793 / 2);
    lineTo(x + r, y + height);
    arc(x + r, y + height - r, r, 3.141592653589793 / 2, 3.141592653589793);
    lineTo(x, y + r);
    arc(x + r, y + r, r, 3.141592653589793, 3.141592653589793 * 1.5);
    closePath();
    return this;
  }

  /// Draw a rounded rectangle outline
  CairoCanvas strokeRoundedRect(
      double x, double y, double width, double height, double radius) {
    roundedRect(x, y, width, height, radius);
    stroke();
    return this;
  }

  /// Draw a filled rounded rectangle
  CairoCanvas fillRoundedRect(
      double x, double y, double width, double height, double radius) {
    roundedRect(x, y, width, height, radius);
    fill();
    return this;
  }

  /// Draw a polyline (connected line segments)
  CairoCanvas polyline(List<Point> points) {
    if (points.isEmpty) return this;
    moveTo(points.first.x, points.first.y);
    for (var i = 1; i < points.length; i++) {
      lineTo(points[i].x, points[i].y);
    }
    return this;
  }

  /// Draw a polygon (closed shape)
  CairoCanvas polygon(List<Point> points) {
    polyline(points);
    closePath();
    return this;
  }

  // ==================== Output ====================

  /// Save the canvas to a PNG file
  bool saveToPng(String filename) {
    surface.flush();
    return surface.saveToPng(filename);
  }

  /// Get the pixel data
  Uint8List? getData() {
    surface.flush();
    return surface.getData();
  }

  // ==================== Cleanup ====================

  /// Dispose the canvas and free resources
  void dispose() {
    if (!_disposed) {
      _cairo.cairo_destroy(_ctx);
      surface.dispose();
      _disposed = true;
    }
  }
}

/// Extension to add Cairo-specific hex color parsing
extension CairoColorExtension on int {
  /// Convert hex value to CairoColor
  CairoColor toCairoColor([double alpha = 1.0]) =>
      CairoColor.fromHex(this, alpha);
}
