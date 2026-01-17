/// DartGraphicsCanvasRenderingContext2D - HTML5 Canvas 2D Rendering Context for DartGraphics
///
/// This class provides the drawing methods for 2D rendering using DartGraphics,
/// following the HTML5 Canvas 2D Context specification.

import 'dart:math' as math;
import 'dart:typed_data';

import '../graphics2D.dart';
import '../image/image_buffer.dart';
import '../line_aa_basics.dart';
import '../line_profile_aa.dart';
import '../outline_renderer.dart';
import '../primitives/color.dart';
import '../rasterizer_outline_aa.dart';
import '../transform/affine.dart';
import '../vertex_source/vertex_storage.dart';
import '../gamma_functions.dart';
import '../../shared/canvas2d/canvas2d.dart';
import 'canvas.dart';

/// Text alignment options
enum DartGraphicsTextAlign { left, right, center, start, end }

/// Text baseline options
enum DartGraphicsTextBaseline {
  top,
  hanging,
  middle,
  alphabetic,
  ideographic,
  bottom
}

/// Image smoothing quality
enum DartGraphicsImageSmoothingQuality { low, medium, high }

/// Direction for text rendering
enum DartGraphicsTextDirection { ltr, rtl, inherit }

/// 2x3 transformation matrix for Canvas 2D
class DartGraphicsMatrix2D {
  double a, b, c, d, e, f;

  DartGraphicsMatrix2D(
      [this.a = 1, this.b = 0, this.c = 0, this.d = 1, this.e = 0, this.f = 0]);

  factory DartGraphicsMatrix2D.identity() =>
      DartGraphicsMatrix2D(1, 0, 0, 1, 0, 0);

  DartGraphicsMatrix2D clone() => DartGraphicsMatrix2D(a, b, c, d, e, f);

  DartGraphicsMatrix2D multiplied(DartGraphicsMatrix2D other) {
    return DartGraphicsMatrix2D(
      a * other.a + c * other.b,
      b * other.a + d * other.b,
      a * other.c + c * other.d,
      b * other.c + d * other.d,
      a * other.e + c * other.f + e,
      b * other.e + d * other.f + f,
    );
  }

  DartGraphicsMatrix2D scaled(double sx, double sy) {
    return multiplied(DartGraphicsMatrix2D(sx, 0, 0, sy, 0, 0));
  }

  DartGraphicsMatrix2D rotated(double angle) {
    final cos = math.cos(angle);
    final sin = math.sin(angle);
    return multiplied(DartGraphicsMatrix2D(cos, sin, -sin, cos, 0, 0));
  }

  DartGraphicsMatrix2D translated(double tx, double ty) {
    return multiplied(DartGraphicsMatrix2D(1, 0, 0, 1, tx, ty));
  }

  ({double x, double y}) transformPoint(double x, double y) {
    return (
      x: a * x + c * y + e,
      y: b * x + d * y + f,
    );
  }

  Affine toAffine() {
    return Affine(a, b, c, d, e, f);
  }
}

/// The 2D rendering context for an DartGraphics Canvas
///
/// Provides methods for drawing shapes, text, images, and other graphics
/// following the HTML5 Canvas 2D API.
class DartGraphicsCanvasRenderingContext2D
    implements ICanvasRenderingContext2D {
  final DartGraphicsCanvas canvas;
  final ImageBuffer _buffer;
  late final BasicGraphics2D _graphics;

  // Current path being built
  DartGraphicsPath2D _currentPath;

  // Style stacks
  final List<_ContextState> _stateStack = [];
  _ContextState _state;

  // ==================== Constructor ====================

  DartGraphicsCanvasRenderingContext2D(this.canvas)
      : _buffer = canvas.buffer,
        _currentPath = DartGraphicsPath2D(),
        _state = _ContextState() {
    _graphics = BasicGraphics2D(_buffer);
  }

  // ==================== State Management ====================

  /// Saves the current drawing state to the stack
  void save() {
    _stateStack.add(_state.clone());
  }

  /// Restores the most recently saved drawing state
  void restore() {
    if (_stateStack.isNotEmpty) {
      _state = _stateStack.removeLast();
    }
  }

  /// Resets the context to its default state
  void reset() {
    _stateStack.clear();
    _state = _ContextState();
    _currentPath.reset();
  }

  /// Returns whether context is lost (always false for this implementation)
  bool isContextLost() => false;

  // ==================== Transforms ====================

  /// Adds a scaling transformation
  void scale(double x, double y) {
    _state.transform = _state.transform.scaled(x, y);
  }

  /// Adds a rotation transformation
  void rotate(double angle) {
    _state.transform = _state.transform.rotated(angle);
  }

  /// Adds a translation transformation
  void translate(double x, double y) {
    _state.transform = _state.transform.translated(x, y);
  }

  /// Multiplies the current transformation matrix
  @override
  void transform(double a, double b, double c, double d, double e, double f) {
    final matrix = DOMMatrix(a, b, c, d, e, f);
    _state.transform = _state.transform.multiplied(matrix);
  }

  /// Sets the transformation matrix
  @override
  void setTransform(
      double a, double b, double c, double d, double e, double f) {
    _state.transform = DOMMatrix(a, b, c, d, e, f);
  }

  /// Gets the current transformation matrix
  @override
  DOMMatrix getTransform() => _state.transform.clone();

  /// Resets the transformation to identity
  @override
  void resetTransform() {
    _state.transform = DOMMatrix.identity();
  }

  // ==================== Compositing ====================

  /// Global alpha (transparency) value
  double get globalAlpha => _state.globalAlpha;
  set globalAlpha(double value) {
    _state.globalAlpha = value.clamp(0.0, 1.0);
  }

  /// Global composite operation
  String get globalCompositeOperation => _state.globalCompositeOperation;
  set globalCompositeOperation(String value) {
    _state.globalCompositeOperation = value;
  }

  // ==================== Image Smoothing ====================

  /// Whether image smoothing is enabled
  bool get imageSmoothingEnabled => _state.imageSmoothingEnabled;
  set imageSmoothingEnabled(bool value) {
    _state.imageSmoothingEnabled = value;
  }

  /// Image smoothing quality
  @override
  ImageSmoothingQuality get imageSmoothingQuality =>
      _state.imageSmoothingQuality;
  @override
  set imageSmoothingQuality(ImageSmoothingQuality value) {
    _state.imageSmoothingQuality = value;
  }

  // ==================== Fill and Stroke Styles ====================

  /// Fill style (color, gradient, or pattern)
  Object get fillStyle => _state.fillStyle;
  set fillStyle(Object value) {
    _state.fillStyle = value;
  }

  /// Stroke style (color, gradient, or pattern)
  Object get strokeStyle => _state.strokeStyle;
  set strokeStyle(Object value) {
    _state.strokeStyle = value;
  }

  Color _getFillColor() {
    final style = _state.fillStyle;
    if (style is String) {
      final color = _parseColor(style);
      return Color.fromRgba(
        color.red,
        color.green,
        color.blue,
        (color.alpha * _state.globalAlpha).round(),
      );
    } else if (style is DartGraphicsCanvasGradient) {
      // For gradients, we'd need more complex rendering
      // For now, return a solid color
      return Color.black;
    } else if (style is DartGraphicsCanvasPattern) {
      return Color.black;
    }
    return Color.black;
  }

  Color _getStrokeColor() {
    final style = _state.strokeStyle;
    if (style is String) {
      final color = _parseColor(style);
      return Color.fromRgba(
        color.red,
        color.green,
        color.blue,
        (color.alpha * _state.globalAlpha).round(),
      );
    } else if (style is DartGraphicsCanvasGradient) {
      return Color.black;
    } else if (style is DartGraphicsCanvasPattern) {
      return Color.black;
    }
    return Color.black;
  }

  Color _parseColor(String colorStr) {
    colorStr = colorStr.trim().toLowerCase();

    final namedColors = _namedColors[colorStr];
    if (namedColors != null) {
      return Color.fromHex(namedColors);
    }

    if (colorStr.startsWith('#')) {
      return _parseHexColor(colorStr);
    }

    if (colorStr.startsWith('rgb')) {
      return _parseRgbColor(colorStr);
    }

    return Color.black;
  }

  Color _parseHexColor(String hex) {
    hex = hex.substring(1);

    int r, g, b, a = 255;

    if (hex.length == 3) {
      r = int.parse(hex[0] + hex[0], radix: 16);
      g = int.parse(hex[1] + hex[1], radix: 16);
      b = int.parse(hex[2] + hex[2], radix: 16);
    } else if (hex.length == 4) {
      r = int.parse(hex[0] + hex[0], radix: 16);
      g = int.parse(hex[1] + hex[1], radix: 16);
      b = int.parse(hex[2] + hex[2], radix: 16);
      a = int.parse(hex[3] + hex[3], radix: 16);
    } else if (hex.length == 6) {
      r = int.parse(hex.substring(0, 2), radix: 16);
      g = int.parse(hex.substring(2, 4), radix: 16);
      b = int.parse(hex.substring(4, 6), radix: 16);
    } else if (hex.length == 8) {
      r = int.parse(hex.substring(0, 2), radix: 16);
      g = int.parse(hex.substring(2, 4), radix: 16);
      b = int.parse(hex.substring(4, 6), radix: 16);
      a = int.parse(hex.substring(6, 8), radix: 16);
    } else {
      return Color.black;
    }

    return Color.fromRgba(r, g, b, a);
  }

  Color _parseRgbColor(String rgb) {
    final isRgba = rgb.startsWith('rgba');
    final start = isRgba ? 5 : 4;
    final end = rgb.length - 1;
    final parts =
        rgb.substring(start, end).split(',').map((s) => s.trim()).toList();

    if (parts.length < 3) return Color.black;

    final r = _parseColorComponent(parts[0]).round();
    final g = _parseColorComponent(parts[1]).round();
    final b = _parseColorComponent(parts[2]).round();
    final a = parts.length > 3
        ? ((double.tryParse(parts[3]) ?? 1.0) * 255).round()
        : 255;

    return Color.fromRgba(
      r.clamp(0, 255),
      g.clamp(0, 255),
      b.clamp(0, 255),
      a.clamp(0, 255),
    );
  }

  double _parseColorComponent(String value) {
    if (value.endsWith('%')) {
      return (double.tryParse(value.substring(0, value.length - 1)) ?? 0) *
          2.55;
    }
    return double.tryParse(value) ?? 0;
  }

  // ==================== Shadow Helpers ====================

  /// Returns whether shadow should be drawn
  bool _shouldDrawShadow() {
    final shadowColor = _parseShadowColor();
    // Shadow is only drawn if color has non-zero alpha and there's offset or blur
    if (shadowColor.alpha == 0) return false;
    return _state.shadowBlur > 0 ||
        _state.shadowOffsetX != 0 ||
        _state.shadowOffsetY != 0;
  }

  /// Parses the shadow color string to a Color
  Color _parseShadowColor() {
    return _parseColor(_state.shadowColor);
  }

  /// Applies box blur to a buffer (3-pass approximation of Gaussian blur)
  void _applyBoxBlur(ImageBuffer buffer, double radius) {
    if (radius <= 0) return;

    final r = radius.ceil();
    final w = buffer.width;
    final h = buffer.height;
    final pixels = buffer.getBuffer();

    // Create temporary buffer for the intermediate result
    final temp = Uint8List(pixels.length);

    // 3-pass box blur approximation of Gaussian blur
    for (int pass = 0; pass < 3; pass++) {
      // Horizontal pass
      for (int y = 0; y < h; y++) {
        for (int x = 0; x < w; x++) {
          int sumR = 0, sumG = 0, sumB = 0, sumA = 0;
          int count = 0;

          for (int dx = -r; dx <= r; dx++) {
            final nx = x + dx;
            if (nx >= 0 && nx < w) {
              final offset = (y * w + nx) * 4;
              sumR += pixels[offset];
              sumG += pixels[offset + 1];
              sumB += pixels[offset + 2];
              sumA += pixels[offset + 3];
              count++;
            }
          }

          final offset = (y * w + x) * 4;
          temp[offset] = sumR ~/ count;
          temp[offset + 1] = sumG ~/ count;
          temp[offset + 2] = sumB ~/ count;
          temp[offset + 3] = sumA ~/ count;
        }
      }

      // Copy temp back to pixels for vertical pass
      pixels.setAll(0, temp);

      // Vertical pass
      for (int y = 0; y < h; y++) {
        for (int x = 0; x < w; x++) {
          int sumR = 0, sumG = 0, sumB = 0, sumA = 0;
          int count = 0;

          for (int dy = -r; dy <= r; dy++) {
            final ny = y + dy;
            if (ny >= 0 && ny < h) {
              final offset = (ny * w + x) * 4;
              sumR += pixels[offset];
              sumG += pixels[offset + 1];
              sumB += pixels[offset + 2];
              sumA += pixels[offset + 3];
              count++;
            }
          }

          final offset = (y * w + x) * 4;
          temp[offset] = sumR ~/ count;
          temp[offset + 1] = sumG ~/ count;
          temp[offset + 2] = sumB ~/ count;
          temp[offset + 3] = sumA ~/ count;
        }
      }

      // Copy temp back to pixels
      pixels.setAll(0, temp);
    }
  }

  /// Draws a shadow for the given vertex storage
  void _drawShadow(VertexStorage vs, {bool isFill = true}) {
    if (!_shouldDrawShadow()) return;

    final shadowColor = _parseShadowColor();
    final offsetX = _state.shadowOffsetX;
    final offsetY = _state.shadowOffsetY;
    final blur = _state.shadowBlur;

    // Calculate the bounding box of the path
    double minX = double.infinity, minY = double.infinity;
    double maxX = double.negativeInfinity, maxY = double.negativeInfinity;

    for (final v in vs.vertices()) {
      if (v.x < minX) minX = v.x;
      if (v.y < minY) minY = v.y;
      if (v.x > maxX) maxX = v.x;
      if (v.y > maxY) maxY = v.y;
    }

    // Expand bounds for blur radius and offset
    final blurExpand = (blur * 2).ceil();
    final bufferX =
        (minX + offsetX - blurExpand).floor().clamp(0, _buffer.width - 1);
    final bufferY =
        (minY + offsetY - blurExpand).floor().clamp(0, _buffer.height - 1);
    final bufferW = ((maxX - minX + blurExpand * 2).ceil() + 1)
        .clamp(1, _buffer.width - bufferX);
    final bufferH = ((maxY - minY + blurExpand * 2).ceil() + 1)
        .clamp(1, _buffer.height - bufferY);

    if (bufferW <= 0 || bufferH <= 0) return;

    // Create a temporary buffer for the shadow
    final shadowBuffer = ImageBuffer(bufferW, bufferH);
    final shadowGraphics = BasicGraphics2D(shadowBuffer);

    // Translate the path to draw in the shadow buffer
    final translatedVs = VertexStorage();
    for (final v in vs.vertices()) {
      final newX = v.x - bufferX + offsetX;
      final newY = v.y - bufferY + offsetY;

      if (v.command.isMoveTo) {
        translatedVs.moveTo(newX, newY);
      } else if (v.command.isLineTo) {
        translatedVs.lineTo(newX, newY);
      } else if (v.command.isClose) {
        translatedVs.closePath();
      }
    }

    // Draw the shape in shadow color
    if (isFill) {
      shadowGraphics.render(translatedVs, shadowColor);
    } else {
      // For stroke, we need to draw lines
      final vertices = translatedVs.vertices().toList();
      ({double x, double y})? firstPoint;
      ({double x, double y})? lastPoint;

      for (final v in vertices) {
        if (v.command.isMoveTo) {
          firstPoint = (x: v.x, y: v.y);
          lastPoint = firstPoint;
        } else if (v.command.isLineTo && lastPoint != null) {
          shadowGraphics.drawLine(
            lastPoint.x,
            lastPoint.y,
            v.x,
            v.y,
            shadowColor,
            thickness: _state.lineWidth,
          );
          lastPoint = (x: v.x, y: v.y);
        } else if (v.command.isClose &&
            lastPoint != null &&
            firstPoint != null) {
          shadowGraphics.drawLine(
            lastPoint.x,
            lastPoint.y,
            firstPoint.x,
            firstPoint.y,
            shadowColor,
            thickness: _state.lineWidth,
          );
          lastPoint = firstPoint;
        }
      }
    }

    // Apply blur if needed
    if (blur > 0) {
      _applyBoxBlur(shadowBuffer, blur / 2);
    }

    // Blend the shadow buffer onto the main buffer
    for (int y = 0; y < bufferH; y++) {
      final destY = bufferY + y;
      if (destY < 0 || destY >= _buffer.height) continue;

      for (int x = 0; x < bufferW; x++) {
        final destX = bufferX + x;
        if (destX < 0 || destX >= _buffer.width) continue;

        final shadowPixel = shadowBuffer.getPixel(x, y);
        if (shadowPixel.alpha > 0) {
          _buffer.BlendPixel(destX, destY, shadowPixel, shadowPixel.alpha);
        }
      }
    }
  }

  /// Draws a shadow for a rectangle
  void _drawRectShadow(double x1, double y1, double x2, double y2,
      {bool isFill = true}) {
    final vs = VertexStorage();
    vs.moveTo(x1, y1);
    vs.lineTo(x2, y1);
    vs.lineTo(x2, y2);
    vs.lineTo(x1, y2);
    vs.closePath();
    _drawShadow(vs, isFill: isFill);
  }

  // ==================== Line Styles ====================

  /// Line width for strokes
  double get lineWidth => _state.lineWidth;
  set lineWidth(double value) {
    if (value > 0) _state.lineWidth = value;
  }

  /// Line cap style
  String get lineCap => _state.lineCap;
  set lineCap(String value) {
    if (value == 'butt' || value == 'round' || value == 'square') {
      _state.lineCap = value;
    }
  }

  /// Line join style
  String get lineJoin => _state.lineJoin;
  set lineJoin(String value) {
    if (value == 'miter' || value == 'round' || value == 'bevel') {
      _state.lineJoin = value;
    }
  }

  /// Miter limit for line joins
  double get miterLimit => _state.miterLimit;
  set miterLimit(double value) {
    if (value > 0) _state.miterLimit = value;
  }

  /// Line dash offset
  double get lineDashOffset => _state.lineDashOffset;
  set lineDashOffset(double value) {
    _state.lineDashOffset = value;
  }

  /// Gets the current line dash pattern
  List<double> getLineDash() => List.from(_state.lineDash);

  /// Sets the line dash pattern
  void setLineDash(List<double> segments) {
    _state.lineDash = List.from(segments);
  }

  // ==================== Shadow Styles ====================

  /// Shadow blur amount
  double get shadowBlur => _state.shadowBlur;
  set shadowBlur(double value) {
    _state.shadowBlur = value < 0 ? 0 : value;
  }

  /// Shadow color
  String get shadowColor => _state.shadowColor;
  set shadowColor(String value) {
    _state.shadowColor = value;
  }

  /// Shadow X offset
  double get shadowOffsetX => _state.shadowOffsetX;
  set shadowOffsetX(double value) {
    _state.shadowOffsetX = value;
  }

  /// Shadow Y offset
  double get shadowOffsetY => _state.shadowOffsetY;
  set shadowOffsetY(double value) {
    _state.shadowOffsetY = value;
  }

  // ==================== Filter ====================

  /// CSS filter (e.g., 'blur(5px)')
  @override
  String get filter => _state.filter;
  @override
  set filter(String value) {
    _state.filter = value;
  }

  // ==================== Text Styles ====================

  /// Font specification
  String get font => _state.font;
  set font(String value) {
    _state.font = value;
    _parseFontString(value);
  }

  /// Text alignment
  String get textAlign => _textAlignToString(_state.textAlign);
  set textAlign(String value) {
    _state.textAlign = _parseTextAlign(value);
  }

  /// Text baseline
  String get textBaseline => _textBaselineToString(_state.textBaseline);
  set textBaseline(String value) {
    _state.textBaseline = _parseTextBaseline(value);
  }

  /// Text direction
  String get direction => _textDirectionToString(_state.direction);
  set direction(String value) {
    _state.direction = _parseTextDirection(value);
  }

  /// Font kerning
  String get fontKerning => _state.fontKerning;
  set fontKerning(String value) {
    _state.fontKerning = value;
  }

  /// Font stretch
  String get fontStretch => _state.fontStretch;
  set fontStretch(String value) {
    _state.fontStretch = value;
  }

  /// Font variant caps
  String get fontVariantCaps => _state.fontVariantCaps;
  set fontVariantCaps(String value) {
    _state.fontVariantCaps = value;
  }

  /// Letter spacing
  String get letterSpacing => _state.letterSpacing;
  set letterSpacing(String value) {
    _state.letterSpacing = value;
  }

  /// Text rendering quality
  String get textRendering => _state.textRendering;
  set textRendering(String value) {
    _state.textRendering = value;
  }

  /// Word spacing
  String get wordSpacing => _state.wordSpacing;
  set wordSpacing(String value) {
    _state.wordSpacing = value;
  }

  void _parseFontString(String fontStr) {
    // Parse CSS font string like "italic bold 16px Arial"
    final parts = fontStr.split(RegExp(r'\s+'));

    for (final part in parts) {
      if (part.endsWith('px')) {
        _state.fontSize = double.tryParse(part.replaceAll('px', '')) ?? 10.0;
      } else if (part.endsWith('pt')) {
        _state.fontSize =
            (double.tryParse(part.replaceAll('pt', '')) ?? 10.0) * 1.333;
      } else if (part == 'bold') {
        _state.fontWeight = 'bold';
      } else if (part == 'italic') {
        _state.fontStyle = 'italic';
      }
    }
  }

  DartGraphicsTextAlign _parseTextAlign(String align) {
    switch (align) {
      case 'left':
        return DartGraphicsTextAlign.left;
      case 'right':
        return DartGraphicsTextAlign.right;
      case 'center':
        return DartGraphicsTextAlign.center;
      case 'start':
        return DartGraphicsTextAlign.start;
      case 'end':
        return DartGraphicsTextAlign.end;
      default:
        return DartGraphicsTextAlign.start;
    }
  }

  String _textAlignToString(DartGraphicsTextAlign align) {
    switch (align) {
      case DartGraphicsTextAlign.left:
        return 'left';
      case DartGraphicsTextAlign.right:
        return 'right';
      case DartGraphicsTextAlign.center:
        return 'center';
      case DartGraphicsTextAlign.start:
        return 'start';
      case DartGraphicsTextAlign.end:
        return 'end';
    }
  }

  DartGraphicsTextBaseline _parseTextBaseline(String baseline) {
    switch (baseline) {
      case 'top':
        return DartGraphicsTextBaseline.top;
      case 'hanging':
        return DartGraphicsTextBaseline.hanging;
      case 'middle':
        return DartGraphicsTextBaseline.middle;
      case 'alphabetic':
        return DartGraphicsTextBaseline.alphabetic;
      case 'ideographic':
        return DartGraphicsTextBaseline.ideographic;
      case 'bottom':
        return DartGraphicsTextBaseline.bottom;
      default:
        return DartGraphicsTextBaseline.alphabetic;
    }
  }

  String _textBaselineToString(DartGraphicsTextBaseline baseline) {
    switch (baseline) {
      case DartGraphicsTextBaseline.top:
        return 'top';
      case DartGraphicsTextBaseline.hanging:
        return 'hanging';
      case DartGraphicsTextBaseline.middle:
        return 'middle';
      case DartGraphicsTextBaseline.alphabetic:
        return 'alphabetic';
      case DartGraphicsTextBaseline.ideographic:
        return 'ideographic';
      case DartGraphicsTextBaseline.bottom:
        return 'bottom';
    }
  }

  DartGraphicsTextDirection _parseTextDirection(String dir) {
    switch (dir) {
      case 'ltr':
        return DartGraphicsTextDirection.ltr;
      case 'rtl':
        return DartGraphicsTextDirection.rtl;
      default:
        return DartGraphicsTextDirection.inherit;
    }
  }

  String _textDirectionToString(DartGraphicsTextDirection dir) {
    switch (dir) {
      case DartGraphicsTextDirection.ltr:
        return 'ltr';
      case DartGraphicsTextDirection.rtl:
        return 'rtl';
      case DartGraphicsTextDirection.inherit:
        return 'inherit';
    }
  }

  // ==================== Path Methods ====================

  /// Begins a new path
  void beginPath() {
    _currentPath.reset();
  }

  /// Closes the current subpath
  void closePath() {
    _currentPath.closePath();
  }

  /// Moves the pen to the specified point
  void moveTo(double x, double y) {
    final transformed = _state.transform.transformPoint(x, y);
    _currentPath.moveTo(transformed.x, transformed.y);
  }

  /// Draws a line to the specified point
  void lineTo(double x, double y) {
    final transformed = _state.transform.transformPoint(x, y);
    _currentPath.lineTo(transformed.x, transformed.y);
  }

  /// Draws a cubic Bezier curve
  void bezierCurveTo(
      double cp1x, double cp1y, double cp2x, double cp2y, double x, double y) {
    final t = _state.transform;
    final tcp1 = t.transformPoint(cp1x, cp1y);
    final tcp2 = t.transformPoint(cp2x, cp2y);
    final tp = t.transformPoint(x, y);
    _currentPath.bezierCurveTo(tcp1.x, tcp1.y, tcp2.x, tcp2.y, tp.x, tp.y);
  }

  /// Draws a quadratic Bezier curve
  void quadraticCurveTo(double cpx, double cpy, double x, double y) {
    final t = _state.transform;
    final tcp = t.transformPoint(cpx, cpy);
    final tp = t.transformPoint(x, y);
    _currentPath.quadraticCurveTo(tcp.x, tcp.y, tp.x, tp.y);
  }

  /// Draws an arc
  void arc(
      double x, double y, double radius, double startAngle, double endAngle,
      [bool counterclockwise = false]) {
    final t = _state.transform;
    final tp = t.transformPoint(x, y);
    // Note: radius should also be transformed for non-uniform scaling
    _currentPath.arc(
        tp.x, tp.y, radius, startAngle, endAngle, counterclockwise);
  }

  /// Draws an arc using control points
  void arcTo(double x1, double y1, double x2, double y2, double radius) {
    final t = _state.transform;
    final tp1 = t.transformPoint(x1, y1);
    final tp2 = t.transformPoint(x2, y2);
    _currentPath.arcTo(tp1.x, tp1.y, tp2.x, tp2.y, radius);
  }

  /// Draws an ellipse
  void ellipse(double x, double y, double radiusX, double radiusY,
      double rotation, double startAngle, double endAngle,
      [bool counterclockwise = false]) {
    final t = _state.transform;
    final tp = t.transformPoint(x, y);
    _currentPath.ellipse(tp.x, tp.y, radiusX, radiusY, rotation, startAngle,
        endAngle, counterclockwise);
  }

  /// Adds a rectangle to the current path
  void rect(double x, double y, double width, double height) {
    final t = _state.transform;
    final tp = t.transformPoint(x, y);
    _currentPath.rect(tp.x, tp.y, width, height);
  }

  /// Adds a rounded rectangle to the current path
  void roundRect(double x, double y, double width, double height,
      [dynamic radii]) {
    final t = _state.transform;
    final tp = t.transformPoint(x, y);
    _currentPath.roundRect(tp.x, tp.y, width, height, radii);
  }

  // ==================== Drawing Paths ====================

  /// Fills the current path
  void fill([dynamic fillRuleOrPath, String? fillRule]) {
    DartGraphicsPath2D path = _currentPath;

    if (fillRuleOrPath is DartGraphicsPath2D) {
      path = fillRuleOrPath;
    }

    final vs = path.toVertexStorage();

    // Draw shadow first if enabled
    _drawShadow(vs, isFill: true);

    final fillColor = _getFillColor();
    _graphics.render(vs, fillColor);
  }

  /// Strokes the current path
  @override
  void stroke([IPath2D? path]) {
    DartGraphicsPath2D p = _currentPath;
    if (path is DartGraphicsPath2D) {
      p = path;
    }

    // Convert path to flattened list of points
    final vs = p.toVertexStorageFlattened();

    // Draw shadow first if enabled
    _drawShadow(vs, isFill: false);

    final strokeColor = _getStrokeColor();
    final strokeWidth = _state.lineWidth;
    final preferRoundJoinForCurves = _state.lineJoin == 'miter' && p.hasCurves;

    // Collect all points for each subpath
    final subpaths = <List<({double x, double y})>>[];
    var currentSubpath = <({double x, double y})>[];
    ({double x, double y})? subpathStart;

    for (final v in vs.vertices()) {
      if (v.command.isMoveTo) {
        if (currentSubpath.isNotEmpty) {
          subpaths.add(currentSubpath);
          currentSubpath = [];
        }
        currentSubpath.add((x: v.x, y: v.y));
        subpathStart = (x: v.x, y: v.y);
      } else if (v.command.isLineTo) {
        currentSubpath.add((x: v.x, y: v.y));
      } else if (v.command.isClose &&
          subpathStart != null &&
          currentSubpath.isNotEmpty) {
        // Close back to the first point
        currentSubpath.add(subpathStart);
      }
    }

    if (currentSubpath.isNotEmpty) {
      subpaths.add(currentSubpath);
    }

    // Draw each subpath
    for (final points in subpaths) {
      // Apply dashing if needed
      if (_state.lineDash.isNotEmpty) {
        _drawDashedPath(points, strokeColor, strokeWidth);
      } else {
        _strokeSubpathOutline(
          points,
          strokeColor,
          strokeWidth,
          preferRoundJoin: preferRoundJoinForCurves,
        );
      }
    }
  }

  /// Draws a dashed path
  void _drawDashedPath(List<({double x, double y})> points, Color strokeColor,
      double strokeWidth) {
    if (points.length < 2) return;

    final dashPattern = _state.lineDash;
    if (dashPattern.isEmpty) return;

    int dashIndex = 0;
    double dashRemaining = dashPattern[0];
    bool drawing = true; // Start by drawing
    double offset = _state.lineDashOffset;

    // Apply offset
    while (offset > 0 && dashPattern.isNotEmpty) {
      if (offset >= dashRemaining) {
        offset -= dashRemaining;
        dashIndex = (dashIndex + 1) % dashPattern.length;
        dashRemaining = dashPattern[dashIndex];
        drawing = !drawing;
      } else {
        dashRemaining -= offset;
        offset = 0;
      }
    }

    for (int i = 0; i + 1 < points.length; i++) {
      double x0 = points[i].x;
      double y0 = points[i].y;
      final x1 = points[i + 1].x;
      final y1 = points[i + 1].y;

      final dx = x1 - x0;
      final dy = y1 - y0;
      final segmentLength = math.sqrt(dx * dx + dy * dy);
      if (segmentLength < 0.001) continue;

      final ux = dx / segmentLength;
      final uy = dy / segmentLength;

      double remaining = segmentLength;

      while (remaining > 0) {
        final step = math.min(remaining, dashRemaining);

        if (drawing) {
          final nx = x0 + ux * step;
          final ny = y0 + uy * step;
          if (_isAxisAligned(dx, dy)) {
            final snapped =
                _snapAxisAligned(x0, y0, nx, ny, dx, dy, strokeWidth);
            _drawAxisAlignedStrokeSegment(
              snapped.x0,
              snapped.y0,
              snapped.x1,
              snapped.y1,
              strokeColor,
              strokeWidth,
            );
          } else {
            _strokeSegmentOutline(x0, y0, nx, ny, strokeColor, strokeWidth);
          }
        }

        x0 += ux * step;
        y0 += uy * step;
        remaining -= step;
        dashRemaining -= step;

        if (dashRemaining <= 0) {
          dashIndex = (dashIndex + 1) % dashPattern.length;
          dashRemaining = dashPattern[dashIndex];
          drawing = !drawing;
        }
      }
    }
  }

  bool _isAxisAligned(double dx, double dy) {
    return dx.abs() < 1e-6 || dy.abs() < 1e-6;
  }

  ({double x0, double y0, double x1, double y1}) _snapAxisAligned(
    double x0,
    double y0,
    double x1,
    double y1,
    double dx,
    double dy,
    double strokeWidth,
  ) {
    if (dy.abs() < 1e-6) {
      final sy = _snapCoord(y0, strokeWidth);
      return (x0: x0, y0: sy, x1: x1, y1: sy);
    }

    final sx = _snapCoord(x0, strokeWidth);
    return (x0: sx, y0: y0, x1: sx, y1: y1);
  }

  double _snapCoord(double value, double strokeWidth) {
    if (strokeWidth % 2 == 0) {
      return value.roundToDouble();
    }

    return value.roundToDouble() + 0.5;
  }

  void _drawAxisAlignedStrokeSegment(
    double x0,
    double y0,
    double x1,
    double y1,
    Color strokeColor,
    double strokeWidth,
  ) {
    if (strokeWidth <= 0) return;

    if ((x1 - x0).abs() < 1e-6) {
      final sx = _snapCoord(x0, strokeWidth);
      final half = strokeWidth / 2.0;
      final left = sx - half;
      final right = sx + half;
      final top = math.min(y0, y1);
      final bottom = math.max(y0, y1);
      _graphics.fillRect(left, top, right, bottom, strokeColor);
      return;
    }

    if ((y1 - y0).abs() < 1e-6) {
      final sy = _snapCoord(y0, strokeWidth);
      final half = strokeWidth / 2.0;
      final top = sy - half;
      final bottom = sy + half;
      final left = math.min(x0, x1);
      final right = math.max(x0, x1);
      _graphics.fillRect(left, top, right, bottom, strokeColor);
    }
  }

  void _strokeSubpathOutline(
    List<({double x, double y})> points,
    Color strokeColor,
    double strokeWidth, {
    bool preferRoundJoin = false,
  }) {
    if (points.length < 2 || strokeWidth <= 0) return;

    final normalized = _normalizeSubpath(points);
    final pathPoints = normalized.points;
    final closed = normalized.closed;
    if (pathPoints.length < 2) return;

    final profile = LineProfileAA.withWidth(strokeWidth, GammaNone());
    profile.smootherWidth(0.0);
    final renderer = OutlineRenderer(_buffer, profile, strokeColor);
    final rasterizer = RasterizerOutlineAA(renderer);

    final join = preferRoundJoin ? 'round' : _state.lineJoin;
    rasterizer.lineJoin = _mapOutlineJoin(join);
    rasterizer.roundCap = _state.lineCap == 'round';

    rasterizer.moveTo(
      LineCoord.conv(pathPoints.first.x),
      LineCoord.conv(pathPoints.first.y),
    );

    for (int i = 1; i < pathPoints.length; i++) {
      rasterizer.lineTo(
        LineCoord.conv(pathPoints[i].x),
        LineCoord.conv(pathPoints[i].y),
      );
    }

    rasterizer.render(closed);
  }

  void _strokeSegmentOutline(
    double x0,
    double y0,
    double x1,
    double y1,
    Color strokeColor,
    double strokeWidth,
  ) {
    if (strokeWidth <= 0) return;

    final profile = LineProfileAA.withWidth(strokeWidth, GammaNone());
    profile.smootherWidth(0.0);
    final renderer = OutlineRenderer(_buffer, profile, strokeColor);
    final rasterizer = RasterizerOutlineAA(renderer)
      ..lineJoin = OutlineJoin.noJoin
      ..roundCap = _state.lineCap == 'round';

    rasterizer.moveTo(LineCoord.conv(x0), LineCoord.conv(y0));
    rasterizer.lineTo(LineCoord.conv(x1), LineCoord.conv(y1));
    rasterizer.render(false);
  }

  ({List<({double x, double y})> points, bool closed}) _normalizeSubpath(
    List<({double x, double y})> points,
  ) {
    if (points.length < 2) {
      return (points: points, closed: false);
    }

    final first = points.first;
    final last = points.last;
    final closed = _pointsEqual(first, last);

    if (!closed) {
      return (points: points, closed: false);
    }

    return (points: points.sublist(0, points.length - 1), closed: true);
  }

  bool _pointsEqual(
    ({double x, double y}) a,
    ({double x, double y}) b,
  ) {
    const eps = 1e-6;
    return (a.x - b.x).abs() < eps && (a.y - b.y).abs() < eps;
  }

  OutlineJoin _mapOutlineJoin(String join) {
    switch (join) {
      case 'round':
        return OutlineJoin.round;
      case 'bevel':
        return OutlineJoin.noJoin;
      case 'miter':
      default:
        return OutlineJoin.miter;
    }
  }

  /// Draws a focus ring
  @override
  void drawFocusIfNeeded(dynamic elementOrPath, [dynamic element]) {
    // Not implemented for DartGraphics
  }

  /// Scrolls the path into view
  @override
  void scrollPathIntoView([IPath2D? path]) {
    // Not applicable for DartGraphics
  }

  /// Clips to the current path
  void clip([dynamic fillRuleOrPath, String? fillRule]) {
    // Clipping would require more complex implementation with DartGraphics
    // Store the clipping path for future use
    if (fillRuleOrPath is DartGraphicsPath2D) {
      _state.clipPath = fillRuleOrPath;
    } else {
      _state.clipPath = DartGraphicsPath2D.from(_currentPath);
    }
  }

  /// Tests if a point is in the current path
  bool isPointInPath(dynamic xOrPath, double y,
      [dynamic fillRuleOrY, String? fillRule]) {
    // Simplified implementation
    return false;
  }

  /// Tests if a point is in the stroke of the current path
  bool isPointInStroke(dynamic xOrPath, [double? y]) {
    // Simplified implementation
    return false;
  }

  // ==================== Drawing Rectangles ====================

  /// Clears a rectangular area
  void clearRect(double x, double y, double width, double height) {
    final t = _state.transform;
    final tp = t.transformPoint(x, y);

    final x1 = tp.x.round();
    final y1 = tp.y.round();
    final x2 = (tp.x + width).round();
    final y2 = (tp.y + height).round();

    for (int py = y1; py < y2 && py < _buffer.height; py++) {
      if (py < 0) continue;
      for (int px = x1; px < x2 && px < _buffer.width; px++) {
        if (px < 0) continue;
        _buffer.SetPixel(px, py, Color.transparent);
      }
    }
  }

  /// Fills a rectangle
  void fillRect(double x, double y, double width, double height) {
    final t = _state.transform;

    // Check if we have a non-trivial transform (rotation or skew)
    final isSimpleTransform = t.b == 0 && t.c == 0;

    if (isSimpleTransform) {
      // Simple case: only translation and scale
      final tp = t.transformPoint(x, y);
      final x1 = tp.x;
      final y1 = tp.y;
      final x2 = tp.x + width * t.a;
      final y2 = tp.y + height * t.d;

      // Draw shadow first if enabled
      _drawRectShadow(x1, y1, x2, y2, isFill: true);

      final fillColor = _getFillColor();
      _graphics.fillRect(x1, y1, x2, y2, fillColor);
    } else {
      // Complex transform: transform all 4 corners and draw as polygon
      final p1 = t.transformPoint(x, y);
      final p2 = t.transformPoint(x + width, y);
      final p3 = t.transformPoint(x + width, y + height);
      final p4 = t.transformPoint(x, y + height);

      final vs = VertexStorage();
      vs.moveTo(p1.x, p1.y);
      vs.lineTo(p2.x, p2.y);
      vs.lineTo(p3.x, p3.y);
      vs.lineTo(p4.x, p4.y);
      vs.closePath();

      // Draw shadow first if enabled
      _drawShadow(vs, isFill: true);

      final fillColor = _getFillColor();
      _graphics.render(vs, fillColor);
    }
  }

  /// Strokes a rectangle
  void strokeRect(double x, double y, double width, double height) {
    final t = _state.transform;

    // Check if we have a non-trivial transform (rotation or skew)
    final isSimpleTransform = t.b == 0 && t.c == 0;

    if (isSimpleTransform) {
      // Simple case: only translation and scale
      final tp = t.transformPoint(x, y);
      final x1 = tp.x;
      final y1 = tp.y;
      final x2 = tp.x + width * t.a;
      final y2 = tp.y + height * t.d;

      // Draw shadow first if enabled
      _drawRectShadow(x1, y1, x2, y2, isFill: false);

      final strokeColor = _getStrokeColor();
      final strokeWidth = _state.lineWidth;

      _drawAxisAlignedStrokeSegment(
        x1,
        y1,
        x2,
        y1,
        strokeColor,
        strokeWidth,
      );
      _drawAxisAlignedStrokeSegment(
        x2,
        y1,
        x2,
        y2,
        strokeColor,
        strokeWidth,
      );
      _drawAxisAlignedStrokeSegment(
        x2,
        y2,
        x1,
        y2,
        strokeColor,
        strokeWidth,
      );
      _drawAxisAlignedStrokeSegment(
        x1,
        y2,
        x1,
        y1,
        strokeColor,
        strokeWidth,
      );
    } else {
      // Complex transform: draw as path
      final p1 = t.transformPoint(x, y);
      final p2 = t.transformPoint(x + width, y);
      final p3 = t.transformPoint(x + width, y + height);
      final p4 = t.transformPoint(x, y + height);

      final vs = VertexStorage();
      vs.moveTo(p1.x, p1.y);
      vs.lineTo(p2.x, p2.y);
      vs.lineTo(p3.x, p3.y);
      vs.lineTo(p4.x, p4.y);
      vs.closePath();

      // Draw shadow first if enabled
      _drawShadow(vs, isFill: false);

      final strokeColor = _getStrokeColor();
      final strokeWidth = _state.lineWidth;

      _graphics.drawLine(p1.x, p1.y, p2.x, p2.y, strokeColor,
          thickness: strokeWidth);
      _graphics.drawLine(p2.x, p2.y, p3.x, p3.y, strokeColor,
          thickness: strokeWidth);
      _graphics.drawLine(p3.x, p3.y, p4.x, p4.y, strokeColor,
          thickness: strokeWidth);
      _graphics.drawLine(p4.x, p4.y, p1.x, p1.y, strokeColor,
          thickness: strokeWidth);
    }
  }

  // ==================== Drawing Text ====================

  /// Fills text at the specified position
  void fillText(String text, double x, double y, [double? maxWidth]) {
    // Text rendering requires font support
    // For now, this is a placeholder - text rendering should use the typography module
    // _graphics.drawText() requires a Typeface which we don't have in the basic canvas API
  }

  /// Strokes text at the specified position
  void strokeText(String text, double x, double y, [double? maxWidth]) {
    // Text stroke is complex and not commonly implemented
  }

  /// Measures text width
  @override
  ITextMetrics measureText(String text) {
    // Simplified implementation
    return TextMetrics(text.length * _state.fontSize * 0.6);
  }

  // ==================== Drawing Images ====================

  /// Draws an image
  void drawImage(dynamic image, double dx, double dy,
      [double? dWidth,
      double? dHeight,
      double? sx,
      double? sy,
      double? sWidth,
      double? sHeight]) {
    if (image is ImageBuffer) {
      final t = _state.transform;
      final tp = t.transformPoint(dx, dy);

      final srcX = sx?.round() ?? 0;
      final srcY = sy?.round() ?? 0;
      final srcW = sWidth?.round() ?? image.width;
      final srcH = sHeight?.round() ?? image.height;
      final dstX = tp.x.round();
      final dstY = tp.y.round();
      final dstW = dWidth?.round() ?? srcW;
      final dstH = dHeight?.round() ?? srcH;

      // Simple nearest-neighbor image drawing
      for (int y = 0; y < dstH && (dstY + y) < _buffer.height; y++) {
        if (dstY + y < 0) continue;
        final sy2 = srcY + (y * srcH ~/ dstH);
        if (sy2 >= image.height) continue;

        for (int x = 0; x < dstW && (dstX + x) < _buffer.width; x++) {
          if (dstX + x < 0) continue;
          final sx2 = srcX + (x * srcW ~/ dstW);
          if (sx2 >= image.width) continue;

          final color = image.getPixel(sx2, sy2);
          if (color.alpha > 0) {
            _buffer.BlendPixel(dstX + x, dstY + y, color, color.alpha);
          }
        }
      }
    }
  }

  // ==================== Pixel Manipulation ====================

  /// Creates an ImageData object
  @override
  IImageData createImageData(int width, [int? height]) {
    return ImageData(width, height ?? width);
  }

  /// Gets pixel data from the canvas
  @override
  IImageData getImageData(int sx, int sy, int sw, int sh) {
    final imageData = ImageData(sw, sh);

    for (int y = 0; y < sh; y++) {
      final srcY = sy + y;
      if (srcY < 0 || srcY >= _buffer.height) continue;

      for (int x = 0; x < sw; x++) {
        final srcX = sx + x;
        if (srcX < 0 || srcX >= _buffer.width) continue;

        final color = _buffer.getPixel(srcX, srcY);
        final offset = (y * sw + x) * 4;
        imageData.data[offset] = color.red;
        imageData.data[offset + 1] = color.green;
        imageData.data[offset + 2] = color.blue;
        imageData.data[offset + 3] = color.alpha;
      }
    }

    return imageData;
  }

  /// Puts pixel data onto the canvas
  @override
  void putImageData(IImageData imageData, int dx, int dy,
      [int? dirtyX, int? dirtyY, int? dirtyWidth, int? dirtyHeight]) {
    final sx = dirtyX ?? 0;
    final sy = dirtyY ?? 0;
    final sw = dirtyWidth ?? imageData.width;
    final sh = dirtyHeight ?? imageData.height;

    for (int y = sy; y < sy + sh && y < imageData.height; y++) {
      final dstY = dy + y - sy;
      if (dstY < 0 || dstY >= _buffer.height) continue;

      for (int x = sx; x < sx + sw && x < imageData.width; x++) {
        final dstX = dx + x - sx;
        if (dstX < 0 || dstX >= _buffer.width) continue;

        final offset = (y * imageData.width + x) * 4;
        final color = Color.fromRgba(
          imageData.data[offset],
          imageData.data[offset + 1],
          imageData.data[offset + 2],
          imageData.data[offset + 3],
        );
        _buffer.SetPixel(dstX, dstY, color);
      }
    }
  }

  // ==================== Gradients and Patterns ====================

  /// Creates a linear gradient
  DartGraphicsCanvasGradient createLinearGradient(
      double x0, double y0, double x1, double y1) {
    return DartGraphicsCanvasGradient.linear(x0, y0, x1, y1);
  }

  /// Creates a radial gradient
  DartGraphicsCanvasGradient createRadialGradient(
      double x0, double y0, double r0, double x1, double y1, double r1) {
    return DartGraphicsCanvasGradient.radial(x0, y0, r0, x1, y1, r1);
  }

  /// Creates a conic gradient
  DartGraphicsCanvasGradient createConicGradient(
      double startAngle, double x, double y) {
    return DartGraphicsCanvasGradient.conic(startAngle, x, y);
  }

  /// Creates a pattern from an image
  @override
  ICanvasPattern? createPattern(dynamic image, String repetition) {
    if (image is ImageBuffer) {
      return DartGraphicsCanvasPattern(image, repetition);
    }
    return null;
  }

  /// Disposes of context resources
  void dispose() {
    // Clean up any resources if needed
  }
}

/// Text metrics returned by measureText
class TextMetrics implements ITextMetrics {
  @override
  final double width;
  @override
  final double actualBoundingBoxLeft;
  @override
  final double actualBoundingBoxRight;
  @override
  final double actualBoundingBoxAscent;
  @override
  final double actualBoundingBoxDescent;
  @override
  final double fontBoundingBoxAscent;
  @override
  final double fontBoundingBoxDescent;
  @override
  final double emHeightAscent;
  @override
  final double emHeightDescent;
  @override
  final double hangingBaseline;
  @override
  final double alphabeticBaseline;
  @override
  final double ideographicBaseline;

  TextMetrics(
    this.width, {
    this.actualBoundingBoxLeft = 0,
    this.actualBoundingBoxRight = 0,
    this.actualBoundingBoxAscent = 0,
    this.actualBoundingBoxDescent = 0,
    this.fontBoundingBoxAscent = 0,
    this.fontBoundingBoxDescent = 0,
    this.emHeightAscent = 0,
    this.emHeightDescent = 0,
    this.hangingBaseline = 0,
    this.alphabeticBaseline = 0,
    this.ideographicBaseline = 0,
  });
}

/// Pixel data for canvas operations
class ImageData implements IImageData {
  @override
  final int width;
  @override
  final int height;
  @override
  final Uint8ClampedList data;
  @override
  final String colorSpace;

  ImageData(this.width, this.height, {this.colorSpace = 'srgb'})
      : data = Uint8ClampedList(width * height * 4);

  ImageData.fromData(this.width, this.height, this.data,
      {this.colorSpace = 'srgb'});
}

/// Internal context state
class _ContextState {
  DOMMatrix transform = DOMMatrix.identity();
  double globalAlpha = 1.0;
  String globalCompositeOperation = 'source-over';
  bool imageSmoothingEnabled = true;
  ImageSmoothingQuality imageSmoothingQuality = ImageSmoothingQuality.low;
  String filter = 'none';

  Object fillStyle = '#000000';
  Object strokeStyle = '#000000';

  double lineWidth = 1.0;
  String lineCap = 'butt';
  String lineJoin = 'miter';
  double miterLimit = 10.0;
  List<double> lineDash = [];
  double lineDashOffset = 0.0;

  double shadowBlur = 0.0;
  String shadowColor = 'rgba(0, 0, 0, 0)';
  double shadowOffsetX = 0.0;
  double shadowOffsetY = 0.0;

  String font = '10px sans-serif';
  double fontSize = 10.0;
  String fontWeight = 'normal';
  String fontStyle = 'normal';
  DartGraphicsTextAlign textAlign = DartGraphicsTextAlign.start;
  DartGraphicsTextBaseline textBaseline = DartGraphicsTextBaseline.alphabetic;
  DartGraphicsTextDirection direction = DartGraphicsTextDirection.inherit;
  String fontKerning = 'auto';
  String fontStretch = 'normal';
  String fontVariantCaps = 'normal';
  String letterSpacing = '0px';
  String textRendering = 'auto';
  String wordSpacing = '0px';

  DartGraphicsPath2D? clipPath;

  _ContextState clone() {
    final state = _ContextState();
    state.transform = transform.clone();
    state.globalAlpha = globalAlpha;
    state.globalCompositeOperation = globalCompositeOperation;
    state.imageSmoothingEnabled = imageSmoothingEnabled;
    state.imageSmoothingQuality = imageSmoothingQuality;
    state.filter = filter;
    state.fillStyle = fillStyle;
    state.strokeStyle = strokeStyle;
    state.lineWidth = lineWidth;
    state.lineCap = lineCap;
    state.lineJoin = lineJoin;
    state.miterLimit = miterLimit;
    state.lineDash = List.from(lineDash);
    state.lineDashOffset = lineDashOffset;
    state.shadowBlur = shadowBlur;
    state.shadowColor = shadowColor;
    state.shadowOffsetX = shadowOffsetX;
    state.shadowOffsetY = shadowOffsetY;
    state.font = font;
    state.fontSize = fontSize;
    state.fontWeight = fontWeight;
    state.fontStyle = fontStyle;
    state.textAlign = textAlign;
    state.textBaseline = textBaseline;
    state.direction = direction;
    state.fontKerning = fontKerning;
    state.fontStretch = fontStretch;
    state.fontVariantCaps = fontVariantCaps;
    state.letterSpacing = letterSpacing;
    state.textRendering = textRendering;
    state.wordSpacing = wordSpacing;
    state.clipPath = clipPath;
    return state;
  }
}

/// Named CSS colors
const Map<String, String> _namedColors = {
  'transparent': '#00000000',
  'black': '#000000',
  'white': '#FFFFFF',
  'red': '#FF0000',
  'green': '#008000',
  'blue': '#0000FF',
  'yellow': '#FFFF00',
  'cyan': '#00FFFF',
  'magenta': '#FF00FF',
  'orange': '#FFA500',
  'purple': '#800080',
  'pink': '#FFC0CB',
  'brown': '#A52A2A',
  'gray': '#808080',
  'grey': '#808080',
  'silver': '#C0C0C0',
  'gold': '#FFD700',
  'navy': '#000080',
  'teal': '#008080',
  'olive': '#808000',
  'lime': '#00FF00',
  'aqua': '#00FFFF',
  'maroon': '#800000',
  'fuchsia': '#FF00FF',
  'coral': '#FF7F50',
  'salmon': '#FA8072',
  'tomato': '#FF6347',
  'crimson': '#DC143C',
  'darkred': '#8B0000',
  'darkgreen': '#006400',
  'darkblue': '#00008B',
  'darkcyan': '#008B8B',
  'darkmagenta': '#8B008B',
  'darkorange': '#FF8C00',
  'darkviolet': '#9400D3',
  'deeppink': '#FF1493',
  'deepskyblue': '#00BFFF',
  'dimgray': '#696969',
  'dimgrey': '#696969',
  'dodgerblue': '#1E90FF',
  'firebrick': '#B22222',
  'forestgreen': '#228B22',
  'gainsboro': '#DCDCDC',
  'ghostwhite': '#F8F8FF',
  'goldenrod': '#DAA520',
  'greenyellow': '#ADFF2F',
  'honeydew': '#F0FFF0',
  'hotpink': '#FF69B4',
  'indianred': '#CD5C5C',
  'indigo': '#4B0082',
  'ivory': '#FFFFF0',
  'khaki': '#F0E68C',
  'lavender': '#E6E6FA',
  'lawngreen': '#7CFC00',
  'lightblue': '#ADD8E6',
  'lightcoral': '#F08080',
  'lightcyan': '#E0FFFF',
  'lightgray': '#D3D3D3',
  'lightgrey': '#D3D3D3',
  'lightgreen': '#90EE90',
  'lightpink': '#FFB6C1',
  'lightsalmon': '#FFA07A',
  'lightseagreen': '#20B2AA',
  'lightskyblue': '#87CEFA',
  'lightslategray': '#778899',
  'lightslategrey': '#778899',
  'lightsteelblue': '#B0C4DE',
  'lightyellow': '#FFFFE0',
  'limegreen': '#32CD32',
  'linen': '#FAF0E6',
  'mediumaquamarine': '#66CDAA',
  'mediumblue': '#0000CD',
  'mediumorchid': '#BA55D3',
  'mediumpurple': '#9370DB',
  'mediumseagreen': '#3CB371',
  'mediumslateblue': '#7B68EE',
  'mediumspringgreen': '#00FA9A',
  'mediumturquoise': '#48D1CC',
  'mediumvioletred': '#C71585',
  'midnightblue': '#191970',
  'mintcream': '#F5FFFA',
  'mistyrose': '#FFE4E1',
  'moccasin': '#FFE4B5',
  'navajowhite': '#FFDEAD',
  'oldlace': '#FDF5E6',
  'olivedrab': '#6B8E23',
  'orangered': '#FF4500',
  'orchid': '#DA70D6',
  'palegoldenrod': '#EEE8AA',
  'palegreen': '#98FB98',
  'paleturquoise': '#AFEEEE',
  'palevioletred': '#DB7093',
  'papayawhip': '#FFEFD5',
  'peachpuff': '#FFDAB9',
  'peru': '#CD853F',
  'plum': '#DDA0DD',
  'powderblue': '#B0E0E6',
  'rosybrown': '#BC8F8F',
  'royalblue': '#4169E1',
  'saddlebrown': '#8B4513',
  'sandybrown': '#F4A460',
  'seagreen': '#2E8B57',
  'seashell': '#FFF5EE',
  'sienna': '#A0522D',
  'skyblue': '#87CEEB',
  'slateblue': '#6A5ACD',
  'slategray': '#708090',
  'slategrey': '#708090',
  'snow': '#FFFAFA',
  'springgreen': '#00FF7F',
  'steelblue': '#4682B4',
  'tan': '#D2B48C',
  'thistle': '#D8BFD8',
  'turquoise': '#40E0D0',
  'violet': '#EE82EE',
  'wheat': '#F5DEB3',
  'whitesmoke': '#F5F5F5',
  'yellowgreen': '#9ACD32',
  'aliceblue': '#F0F8FF',
  'antiquewhite': '#FAEBD7',
  'aquamarine': '#7FFFD4',
  'azure': '#F0FFFF',
  'beige': '#F5F5DC',
  'bisque': '#FFE4C4',
  'blanchedalmond': '#FFEBCD',
  'blueviolet': '#8A2BE2',
  'burlywood': '#DEB887',
  'cadetblue': '#5F9EA0',
  'chartreuse': '#7FFF00',
  'chocolate': '#D2691E',
  'cornflowerblue': '#6495ED',
  'cornsilk': '#FFF8DC',
  'darkolivegreen': '#556B2F',
  'darkgoldenrod': '#B8860B',
  'darkgray': '#A9A9A9',
  'darkgrey': '#A9A9A9',
  'darkkhaki': '#BDB76B',
  'darksalmon': '#E9967A',
  'darkseagreen': '#8FBC8F',
  'darkslateblue': '#483D8B',
  'darkslategray': '#2F4F4F',
  'darkslategrey': '#2F4F4F',
  'darkturquoise': '#00CED1',
  'floralwhite': '#FFFAF0',
  'darkorchid': '#9932CC',
};
