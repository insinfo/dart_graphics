/// CanvasRenderingContext2D - HTML5 Canvas 2D Rendering Context
/// 
/// This class provides the drawing methods for 2D rendering,
/// following the HTML5 Canvas 2D Context specification.

import 'dart:math' as math;
import 'dart:typed_data';

import '../skia_api.dart';
import '../sk_color.dart';
import '../sk_geometry.dart';
import '../../shared/canvas2d/canvas2d.dart' hide TextAlign, TextBaseline;
import 'canvas.dart';
import 'canvas_gradient.dart';
import 'canvas_pattern.dart';
import 'path_2d.dart';

/// Text alignment options
enum TextAlign { left, right, center, start, end }

/// Text baseline options
enum TextBaseline { top, hanging, middle, alphabetic, ideographic, bottom }

/// Direction for text rendering
enum TextDirection { ltr, rtl, inherit }

/// The 2D rendering context for a Canvas
/// 
/// Provides methods for drawing shapes, text, images, and other graphics
/// following the HTML5 Canvas 2D API.
class CanvasRenderingContext2D implements ICanvasRenderingContext2D {
  final Canvas canvas;
  final Skia _skia;
  
  SkiaCanvas get _skCanvas => canvas.surface!.canvas;
  
  // Current path being built
  Path2D _currentPath;
  
  // Paint objects
  SkiaPaint _fillPaint;
  SkiaPaint _strokePaint;
  
  // Style stacks
  final List<_ContextState> _stateStack = [];
  _ContextState _state;
  
  // ==================== Constructor ====================
  
  CanvasRenderingContext2D(this.canvas, this._skia)
      : _currentPath = Path2D(_skia),
        _fillPaint = _skia.createPaint()
          ..style = PaintStyle.fill
          ..isAntialias = true,
        _strokePaint = _skia.createPaint()
          ..style = PaintStyle.stroke
          ..isAntialias = true,
        _state = _ContextState();
  
  // ==================== State Management ====================
  
  /// Saves the current drawing state to the stack
  void save() {
    _stateStack.add(_state.clone());
    _skCanvas.save();
  }
  
  /// Restores the most recently saved drawing state
  void restore() {
    if (_stateStack.isNotEmpty) {
      _state = _stateStack.removeLast();
      _skCanvas.restore();
    }
  }
  
  /// Resets the context to its default state
  void reset() {
    _stateStack.clear();
    _state = _ContextState();
    _currentPath.reset();
    
    // Reset canvas
    _skCanvas.restore();
    _skCanvas.save();
    
    // Clear to transparent
    _skCanvas.clear(SKColors.transparent);
  }
  
  /// Returns whether context is lost (always false for this implementation)
  bool isContextLost() => false;
  
  // ==================== Transforms ====================
  
  /// Adds a scaling transformation
  @override
  void scale(double x, double y) {
    _skCanvas.scale(x, y);
    _state.transform = _state.transform.scaled(x, y);
  }
  
  /// Adds a rotation transformation
  @override
  void rotate(double angle) {
    final degrees = angle * 180 / math.pi;
    _skCanvas.rotate(degrees);
    _state.transform = _state.transform.rotated(angle);
  }
  
  /// Adds a translation transformation
  @override
  void translate(double x, double y) {
    _skCanvas.translate(x, y);
    _state.transform = _state.transform.translated(x, y);
  }
  
  /// Multiplies the current transformation matrix
  @override
  void transform(double a, double b, double c, double d, double e, double f) {
    // [ a c e ]   [ m11 m21 dx ]
    // [ b d f ] = [ m12 m22 dy ]
    // [ 0 0 1 ]   [  0   0   1 ]
    final matrix = DOMMatrix(a, b, c, d, e, f);
    _state.transform = _state.transform.multiplied(matrix);
    _applyTransformToCanvas();
  }
  
  /// Sets the transformation matrix
  @override
  void setTransform(double a, double b, double c, double d, double e, double f) {
    _state.transform = DOMMatrix(a, b, c, d, e, f);
    _applyTransformToCanvas();
  }
  
  /// Gets the current transformation matrix
  @override
  DOMMatrix getTransform() => _state.transform.clone();
  
  /// Resets the transformation to identity
  @override
  void resetTransform() {
    _state.transform = DOMMatrix.identity();
    _applyTransformToCanvas();
  }
  
  void _applyTransformToCanvas() {
    // Reset to saved state then apply new transform
    _skCanvas.restore();
    _skCanvas.save();
    
    final t = _state.transform;
    // Apply affine transform via scale/translate/skew
    _skCanvas.translate(t.e, t.f);
    if (t.a != 1.0 || t.d != 1.0) {
      _skCanvas.scale(t.a, t.d);
    }
    if (t.b != 0.0 || t.c != 0.0) {
      _skCanvas.skew(t.c / t.a, t.b / t.d);
    }
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
  ImageSmoothingQuality get imageSmoothingQuality => _state.imageSmoothingQuality;
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
  
  void _updateFillPaint() {
    final style = _state.fillStyle;
    if (style is String) {
      final color = SKColor.parse(style);
      final alpha = (_state.globalAlpha * color.alpha).round();
      _fillPaint.color = color.withAlpha(alpha);
      _fillPaint.clearShader();
    } else if (style is CanvasGradient) {
      _applyGradientShader(_fillPaint, style);
    } else if (style is CanvasPattern) {
      // Pattern shaders require bitmap support - using fallback color
      _fillPaint.color = SKColors.black;
      _fillPaint.clearShader();
    }
    
    _applyBlendMode(_fillPaint);
    _applyShadow(_fillPaint);
  }
  
  void _updateStrokePaint() {
    final style = _state.strokeStyle;
    if (style is String) {
      final color = SKColor.parse(style);
      final alpha = (_state.globalAlpha * color.alpha).round();
      _strokePaint.color = color.withAlpha(alpha);
      _strokePaint.clearShader();
    } else if (style is CanvasGradient) {
      _applyGradientShader(_strokePaint, style);
    } else if (style is CanvasPattern) {
      // Pattern shaders require bitmap support - using fallback color
      _strokePaint.color = SKColors.black;
      _strokePaint.clearShader();
    }
    
    _strokePaint.strokeWidth = _state.lineWidth;
    _strokePaint.strokeCap = _state.lineCap;
    _strokePaint.strokeJoin = _state.lineJoin;
    _strokePaint.strokeMiter = _state.miterLimit;
    
    // Apply dash pattern if set
    if (_state.lineDash.isNotEmpty) {
      // Ensure even number of intervals
      final intervals = _state.lineDash.length % 2 == 0 
          ? _state.lineDash 
          : [..._state.lineDash, ..._state.lineDash];
      _strokePaint.setDashPathEffect(intervals, _state.lineDashOffset);
    } else {
      _strokePaint.clearPathEffect();
    }
    
    _applyBlendMode(_strokePaint);
    _applyShadow(_strokePaint);
  }
  
  void _applyBlendMode(SkiaPaint paint) {
    final blendMode = _parseBlendMode(_state.globalCompositeOperation);
    paint.blendMode = blendMode;
  }
  
  void _applyShadow(SkiaPaint paint) {
    // Shadow support requires image filters which aren't fully exposed
    // The shadow properties are stored but not applied visually
    // shadowBlur, shadowColor, shadowOffsetX, shadowOffsetY are available
    // but SkiaSharp's sk_paint_set_image_filter would be needed
  }
  
  void _applyGradientShader(SkiaPaint paint, CanvasGradient gradient) {
    final stops = gradient.colorStops;
    if (stops.isEmpty) {
      paint.color = SKColors.black;
      paint.clearShader();
      return;
    }
    
    // Convert colors to ARGB integers
    final colors = stops.map((s) => s.color.value).toList();
    final positions = stops.map((s) => s.offset).toList();
    
    final shader = switch (gradient.type) {
      GradientType.linear => () {
        final start = gradient.startPoint;
        final end = gradient.endPoint;
        if (start == null || end == null) return null;
        return _skia.createLinearGradientShader(
          [SKPoint(start.x, start.y), SKPoint(end.x, end.y)],
          colors,
          positions,
        );
      }(),
      GradientType.radial => () {
        final start = gradient.startPoint;
        final r1 = gradient.endRadius;
        if (start == null || r1 == null) return null;
        return _skia.createRadialGradientShader(
          SKPoint(start.x, start.y),
          r1,
          colors,
          positions,
        );
      }(),
      GradientType.conic => () {
        final start = gradient.startPoint;
        final angle = gradient.startAngle;
        if (start == null || angle == null) return null;
        // Convert radians to degrees for sweep gradient
        final startDegrees = angle * 180 / math.pi;
        return _skia.createSweepGradientShader(
          SKPoint(start.x, start.y),
          colors,
          positions,
          startAngle: startDegrees,
          endAngle: startDegrees + 360,
        );
      }(),
    };
    
    if (shader != null && shader.address != 0) {
      paint.setShader(shader);
    } else {
      paint.color = stops.isNotEmpty ? stops.first.color : SKColors.black;
      paint.clearShader();
    }
  }
  
  BlendMode _parseBlendMode(String op) {
    switch (op) {
      case 'source-over': return BlendMode.srcOver;
      case 'source-in': return BlendMode.srcIn;
      case 'source-out': return BlendMode.srcOut;
      case 'source-atop': return BlendMode.srcATop;
      case 'destination-over': return BlendMode.dstOver;
      case 'destination-in': return BlendMode.dstIn;
      case 'destination-out': return BlendMode.dstOut;
      case 'destination-atop': return BlendMode.dstATop;
      case 'lighter': return BlendMode.plus;
      case 'copy': return BlendMode.src;
      case 'xor': return BlendMode.xor;
      case 'multiply': return BlendMode.multiply;
      case 'screen': return BlendMode.screen;
      case 'overlay': return BlendMode.overlay;
      case 'darken': return BlendMode.darken;
      case 'lighten': return BlendMode.lighten;
      case 'color-dodge': return BlendMode.colorDodge;
      case 'color-burn': return BlendMode.colorBurn;
      case 'hard-light': return BlendMode.hardLight;
      case 'soft-light': return BlendMode.softLight;
      case 'difference': return BlendMode.difference;
      case 'exclusion': return BlendMode.exclusion;
      case 'hue': return BlendMode.hue;
      case 'saturation': return BlendMode.saturation;
      case 'color': return BlendMode.color;
      case 'luminosity': return BlendMode.luminosity;
      default: return BlendMode.srcOver;
    }
  }
  
  // ==================== Line Styles ====================
  
  /// Line width for strokes
  double get lineWidth => _state.lineWidth;
  set lineWidth(double value) {
    if (value > 0) _state.lineWidth = value;
  }
  
  /// Line cap style
  String get lineCap => _lineCapToString(_state.lineCap);
  set lineCap(String value) {
    _state.lineCap = _parseLineCap(value);
  }
  
  /// Line join style
  String get lineJoin => _lineJoinToString(_state.lineJoin);
  set lineJoin(String value) {
    _state.lineJoin = _parseLineJoin(value);
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
  
  StrokeCap _parseLineCap(String cap) {
    switch (cap) {
      case 'round': return StrokeCap.round;
      case 'square': return StrokeCap.square;
      default: return StrokeCap.butt;
    }
  }
  
  String _lineCapToString(StrokeCap cap) {
    switch (cap) {
      case StrokeCap.round: return 'round';
      case StrokeCap.square: return 'square';
      default: return 'butt';
    }
  }
  
  StrokeJoin _parseLineJoin(String join) {
    switch (join) {
      case 'round': return StrokeJoin.round;
      case 'bevel': return StrokeJoin.bevel;
      default: return StrokeJoin.miter;
    }
  }
  
  String _lineJoinToString(StrokeJoin join) {
    switch (join) {
      case StrokeJoin.round: return 'round';
      case StrokeJoin.bevel: return 'bevel';
      default: return 'miter';
    }
  }
  
  // ==================== Shadow Properties ====================
  
  /// Shadow blur radius
  double get shadowBlur => _state.shadowBlur;
  set shadowBlur(double value) {
    if (value >= 0) _state.shadowBlur = value;
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
  
  // ==================== Text Properties ====================
  
  /// Font for text rendering
  String get font => _state.font;
  set font(String value) {
    _state.font = value;
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
  
  /// Letter spacing
  @override
  String get letterSpacing => _state.letterSpacing;
  @override
  set letterSpacing(String value) {
    _state.letterSpacing = value;
  }
  
  /// Word spacing
  @override
  String get wordSpacing => _state.wordSpacing;
  @override
  set wordSpacing(String value) {
    _state.wordSpacing = value;
  }
  
  /// Filter effects
  @override
  String get filter => _state.filter;
  @override
  set filter(String value) {
    _state.filter = value;
  }
  
  /// Font kerning
  @override
  String get fontKerning => _state.fontKerning;
  @override
  set fontKerning(String value) {
    _state.fontKerning = value;
  }
  
  /// Font stretch
  @override
  String get fontStretch => _state.fontStretch;
  @override
  set fontStretch(String value) {
    _state.fontStretch = value;
  }
  
  /// Font variant caps
  @override
  String get fontVariantCaps => _state.fontVariantCaps;
  @override
  set fontVariantCaps(String value) {
    _state.fontVariantCaps = value;
  }
  
  /// Text rendering
  @override
  String get textRendering => _state.textRendering;
  @override
  set textRendering(String value) {
    _state.textRendering = value;
  }

  TextAlign _parseTextAlign(String align) {
    switch (align) {
      case 'left': return TextAlign.left;
      case 'right': return TextAlign.right;
      case 'center': return TextAlign.center;
      case 'start': return TextAlign.start;
      case 'end': return TextAlign.end;
      default: return TextAlign.start;
    }
  }
  
  String _textAlignToString(TextAlign align) {
    switch (align) {
      case TextAlign.left: return 'left';
      case TextAlign.right: return 'right';
      case TextAlign.center: return 'center';
      case TextAlign.start: return 'start';
      case TextAlign.end: return 'end';
    }
  }
  
  TextBaseline _parseTextBaseline(String baseline) {
    switch (baseline) {
      case 'top': return TextBaseline.top;
      case 'hanging': return TextBaseline.hanging;
      case 'middle': return TextBaseline.middle;
      case 'alphabetic': return TextBaseline.alphabetic;
      case 'ideographic': return TextBaseline.ideographic;
      case 'bottom': return TextBaseline.bottom;
      default: return TextBaseline.alphabetic;
    }
  }
  
  String _textBaselineToString(TextBaseline baseline) {
    switch (baseline) {
      case TextBaseline.top: return 'top';
      case TextBaseline.hanging: return 'hanging';
      case TextBaseline.middle: return 'middle';
      case TextBaseline.alphabetic: return 'alphabetic';
      case TextBaseline.ideographic: return 'ideographic';
      case TextBaseline.bottom: return 'bottom';
    }
  }
  
  TextDirection _parseTextDirection(String dir) {
    switch (dir) {
      case 'ltr': return TextDirection.ltr;
      case 'rtl': return TextDirection.rtl;
      default: return TextDirection.inherit;
    }
  }
  
  String _textDirectionToString(TextDirection dir) {
    switch (dir) {
      case TextDirection.ltr: return 'ltr';
      case TextDirection.rtl: return 'rtl';
      case TextDirection.inherit: return 'inherit';
    }
  }
  
  // ==================== Path Methods ====================
  
  /// Begins a new path
  void beginPath() {
    _currentPath = Path2D(_skia);
  }
  
  /// Closes the current subpath
  void closePath() {
    _currentPath.closePath();
  }
  
  /// Moves the path to a point
  void moveTo(double x, double y) {
    _currentPath.moveTo(x, y);
  }
  
  /// Draws a line to a point
  void lineTo(double x, double y) {
    _currentPath.lineTo(x, y);
  }
  
  /// Draws a quadratic Bézier curve
  void quadraticCurveTo(double cpx, double cpy, double x, double y) {
    _currentPath.quadraticCurveTo(cpx, cpy, x, y);
  }
  
  /// Draws a cubic Bézier curve
  void bezierCurveTo(double cp1x, double cp1y, double cp2x, double cp2y, double x, double y) {
    _currentPath.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, x, y);
  }
  
  /// Draws an arc with tangent lines
  void arcTo(double x1, double y1, double x2, double y2, double radius) {
    _currentPath.arcTo(x1, y1, x2, y2, radius);
  }
  
  /// Adds an arc to the path
  void arc(double x, double y, double radius, double startAngle, double endAngle, [bool counterclockwise = false]) {
    _currentPath.arc(x, y, radius, startAngle, endAngle, counterclockwise);
  }
  
  /// Adds an ellipse to the path
  void ellipse(double x, double y, double radiusX, double radiusY, double rotation, double startAngle, double endAngle, [bool counterclockwise = false]) {
    _currentPath.ellipse(x, y, radiusX, radiusY, rotation, startAngle, endAngle, counterclockwise);
  }
  
  /// Adds a rectangle to the path
  void rect(double x, double y, double width, double height) {
    _currentPath.rect(x, y, width, height);
  }
  
  /// Adds a rounded rectangle to the path
  void roundRect(double x, double y, double width, double height, [dynamic radii = 0]) {
    _currentPath.roundRect(x, y, width, height, radii);
  }
  
  // ==================== Drawing Paths ====================
  
  /// Fills the current path
  void fill([dynamic pathOrFillRule, String? fillRule]) {
    Path2D? pathToFill;
    String rule = 'nonzero';
    
    if (pathOrFillRule is Path2D) {
      pathToFill = pathOrFillRule;
      rule = fillRule ?? 'nonzero';
    } else if (pathOrFillRule is String) {
      pathToFill = _currentPath;
      rule = pathOrFillRule;
    } else {
      pathToFill = _currentPath;
    }
    
    _updateFillPaint();
    
    // Set fill type
    if (rule == 'evenodd') {
      pathToFill.path?.fillType = PathFillType.evenOdd;
    } else {
      pathToFill.path?.fillType = PathFillType.winding;
    }
    
    if (pathToFill.path != null) {
      _skCanvas.drawPath(pathToFill.path!, _fillPaint);
    }
  }
  
  /// Strokes the current path
  @override
  void stroke([IPath2D? path]) {
    final pathToStroke = (path as Path2D?) ?? _currentPath;
    
    _updateStrokePaint();
    
    if (pathToStroke.path != null) {
      _skCanvas.drawPath(pathToStroke.path!, _strokePaint);
    }
  }
  
  /// Clips to the current path
  void clip([dynamic pathOrFillRule, String? fillRule]) {
    Path2D? pathToClip;
    String rule = 'nonzero';
    
    if (pathOrFillRule is Path2D) {
      pathToClip = pathOrFillRule;
      rule = fillRule ?? 'nonzero';
    } else if (pathOrFillRule is String) {
      pathToClip = _currentPath;
      rule = pathOrFillRule;
    } else {
      pathToClip = _currentPath;
    }
    
    if (rule == 'evenodd') {
      pathToClip.path?.fillType = PathFillType.evenOdd;
    } else {
      pathToClip.path?.fillType = PathFillType.winding;
    }
    
    if (pathToClip.path != null) {
      _skCanvas.clipPath(pathToClip.path!, doAntiAlias: true);
    }
  }
  
  /// Tests if a point is in the current path
  bool isPointInPath(double x, double y, [String fillRule = 'nonzero']) {
    final path = _currentPath.path;
    if (path == null) return false;
    
    // Set fill type based on fill rule
    final previousFillType = path.fillType;
    path.fillType = fillRule == 'evenodd' ? PathFillType.evenOdd : PathFillType.winding;
    
    final result = path.contains(x, y);
    
    // Restore previous fill type
    path.fillType = previousFillType;
    return result;
  }
  
  /// Tests if a point is in the stroke of the current path
  bool isPointInStroke(double x, double y) {
    // Get the stroked path and test containment
    // For now, use a simple bounding box approximation
    final path = _currentPath.path;
    if (path == null) return false;
    
    // A proper implementation would create a stroked path copy
    // and test containment on that. For now, use the fill containment
    // with a small tolerance based on stroke width.
    final halfWidth = _state.lineWidth / 2;
    
    // Test points around the target in a cross pattern
    return path.contains(x, y) ||
           path.contains(x - halfWidth, y) ||
           path.contains(x + halfWidth, y) ||
           path.contains(x, y - halfWidth) ||
           path.contains(x, y + halfWidth);
  }
  
  /// Draws focus ring if element is focused (not supported in this implementation)
  @override
  void drawFocusIfNeeded(dynamic pathOrElement, [dynamic element]) {
    // Not supported - this is a browser-specific feature
  }
  
  /// Scrolls the path into view (not supported in this implementation)
  @override
  void scrollPathIntoView([IPath2D? path]) {
    // Not supported - this is a browser-specific feature
  }
  
  // ==================== Drawing Rectangles ====================
  
  /// Fills a rectangle
  void fillRect(double x, double y, double width, double height) {
    _updateFillPaint();
    _skCanvas.drawRect(SKRect.fromXYWH(x, y, width, height), _fillPaint);
  }
  
  /// Strokes a rectangle
  void strokeRect(double x, double y, double width, double height) {
    _updateStrokePaint();
    _skCanvas.drawRect(SKRect.fromXYWH(x, y, width, height), _strokePaint);
  }
  
  /// Clears a rectangle to transparent
  void clearRect(double x, double y, double width, double height) {
    final clearPaint = _skia.createPaint()
      ..style = PaintStyle.fill
      ..blendMode = BlendMode.clear;
    _skCanvas.drawRect(SKRect.fromXYWH(x, y, width, height), clearPaint);
    clearPaint.dispose();
  }
  
  // ==================== Drawing Text ====================
  
  /// Fills text at a position
  void fillText(String text, double x, double y, [double? maxWidth]) {
    _updateFillPaint();
    final font = _createFont();
    if (font != null) {
      _skCanvas.drawSimpleText(text, x, y, font, _fillPaint);
      font.dispose();
    }
  }
  
  /// Strokes text at a position
  void strokeText(String text, double x, double y, [double? maxWidth]) {
    _updateStrokePaint();
    final font = _createFont();
    if (font != null) {
      _skCanvas.drawSimpleText(text, x, y, font, _strokePaint);
      font.dispose();
    }
  }
  
  /// Measures text width
  @override
  ITextMetrics measureText(String text) {
    final font = _createFont();
    final fontSize = _parseFontSize(_state.font);
    // Rough approximation
    final width = text.length * fontSize * 0.5;
    font?.dispose();
    return TextMetrics(width: width);
  }
  
  SkiaFont? _createFont() {
    final fontSize = _parseFontSize(_state.font);
    final typeface = _skia.createDefaultTypeface();
    if (typeface == null) return null;
    return _skia.createFontFromTypeface(typeface, size: fontSize);
  }
  
  double _parseFontSize(String fontStr) {
    final match = RegExp(r'(\d+(?:\.\d+)?)\s*px').firstMatch(fontStr);
    if (match != null) {
      return double.tryParse(match.group(1)!) ?? 10.0;
    }
    return 10.0;
  }
  
  // ==================== Drawing Images ====================
  
  /// Draws an image to the canvas
  void drawImage(dynamic image, double dx, double dy, [double? dWidth, double? dHeight, double? sx, double? sy, double? sWidth, double? sHeight]) {
    if (image is SkiaImage) {
      _drawSkiaImage(image, dx, dy, dWidth, dHeight, sx, sy, sWidth, sHeight);
    } else if (image is ImageData) {
      // Create temporary image from ImageData
      final bitmap = _skia.createBitmap(image.width, image.height);
      // Copy pixel data (RGBA to RGBA)
      final pixels = bitmap.getPixels();
      if (pixels != null) {
        for (int i = 0; i < image.data.length && i < pixels.length; i++) {
          pixels[i] = image.data[i];
        }
        bitmap.notifyPixelsChanged();
      }
      
      final skImage = bitmap.toImage();
      if (skImage != null) {
        _drawSkiaImage(skImage, dx, dy, dWidth, dHeight, sx, sy, sWidth, sHeight);
        skImage.dispose();
      }
      bitmap.dispose();
    }
  }
  
  void _drawSkiaImage(SkiaImage image, double dx, double dy, [double? dWidth, double? dHeight, double? sx, double? sy, double? sWidth, double? sHeight]) {
    _updateFillPaint();
    
    final srcRect = sx != null && sy != null && sWidth != null && sHeight != null
        ? SKRect.fromXYWH(sx, sy, sWidth, sHeight)
        : SKRect.fromXYWH(0, 0, image.width.toDouble(), image.height.toDouble());
    
    final dstRect = SKRect.fromXYWH(
      dx, 
      dy, 
      dWidth ?? image.width.toDouble(), 
      dHeight ?? image.height.toDouble(),
    );
    
    _skCanvas.drawImageRect(image, srcRect, dstRect, _fillPaint);
  }
  
  // ==================== Pixel Manipulation ====================
  
  /// Creates image data
  @override
  IImageData createImageData(int width, int height) {
    return ImageData(width, height);
  }
  
  /// Gets image data from the canvas
  @override
  IImageData getImageData(int sx, int sy, int sw, int sh) {
    final imageData = ImageData(sw, sh);
    
    // Get a snapshot of the surface
    final snapshot = canvas.surface?.snapshot();
    if (snapshot == null) return imageData;
    
    // Read pixels from the snapshot
    final pixels = snapshot.readPixels();
    snapshot.dispose();
    
    if (pixels == null) return imageData;
    
    // Copy the requested region
    final surfaceWidth = canvas.width;
    final surfaceStride = surfaceWidth * 4;
    
    for (int y = 0; y < sh; y++) {
      for (int x = 0; x < sw; x++) {
        final srcX = sx + x;
        final srcY = sy + y;
        
        if (srcX >= 0 && srcX < surfaceWidth && srcY >= 0 && srcY < canvas.height) {
          final srcIdx = srcY * surfaceStride + srcX * 4;
          final dstIdx = (y * sw + x) * 4;
          
          if (srcIdx + 3 < pixels.length && dstIdx + 3 < imageData.data.length) {
            // RGBA to RGBA (direct copy)
            imageData.data[dstIdx + 0] = pixels[srcIdx + 0];
            imageData.data[dstIdx + 1] = pixels[srcIdx + 1];
            imageData.data[dstIdx + 2] = pixels[srcIdx + 2];
            imageData.data[dstIdx + 3] = pixels[srcIdx + 3];
          }
        }
      }
    }
    
    return imageData;
  }
  
  /// Puts image data to the canvas
  @override
  void putImageData(IImageData imageData, int dx, int dy, [int? dirtyX, int? dirtyY, int? dirtyWidth, int? dirtyHeight]) {
    final srcX = dirtyX ?? 0;
    final srcY = dirtyY ?? 0;
    final srcW = dirtyWidth ?? imageData.width;
    final srcH = dirtyHeight ?? imageData.height;
    
    // Create a bitmap from the image data
    final bitmap = _skia.createBitmap(imageData.width, imageData.height);
    final pixels = bitmap.getPixels();
    
    if (pixels != null) {
      // Copy RGBA data
      for (int i = 0; i < imageData.data.length && i < pixels.length; i++) {
        pixels[i] = imageData.data[i];
      }
      bitmap.notifyPixelsChanged();
    }
    
    // Draw the bitmap to canvas
    final skImage = bitmap.toImage();
    if (skImage != null) {
      final srcRect = SKRect.fromXYWH(srcX.toDouble(), srcY.toDouble(), srcW.toDouble(), srcH.toDouble());
      final dstRect = SKRect.fromXYWH((dx + srcX).toDouble(), (dy + srcY).toDouble(), srcW.toDouble(), srcH.toDouble());
      
      final paint = _skia.createPaint();
      paint.blendMode = BlendMode.src; // Replace pixels directly
      _skCanvas.drawImageRect(skImage, srcRect, dstRect, paint);
      paint.dispose();
      skImage.dispose();
    }
    bitmap.dispose();
  }
  
  // ==================== Gradients and Patterns ====================
  
  /// Creates a linear gradient
  CanvasGradient createLinearGradient(double x0, double y0, double x1, double y1) {
    return CanvasGradient.linear(x0, y0, x1, y1);
  }
  
  /// Creates a radial gradient
  CanvasGradient createRadialGradient(double x0, double y0, double r0, double x1, double y1, double r1) {
    return CanvasGradient.radial(x0, y0, r0, x1, y1, r1);
  }
  
  /// Creates a conic gradient
  CanvasGradient createConicGradient(double startAngle, double x, double y) {
    return CanvasGradient.conic(startAngle, x, y);
  }
  
  /// Creates a pattern
  CanvasPattern createPattern(dynamic image, String repetition) {
    return CanvasPattern(image, repetition);
  }
  
  // ==================== Disposal ====================
  
  /// Disposes resources
  void dispose() {
    _fillPaint.dispose();
    _strokePaint.dispose();
    _currentPath.dispose();
  }
}

// ==================== Helper Classes ====================

/// Internal state for context
class _ContextState {
  DOMMatrix transform = DOMMatrix.identity();
  double globalAlpha = 1.0;
  String globalCompositeOperation = 'source-over';
  bool imageSmoothingEnabled = true;
  ImageSmoothingQuality imageSmoothingQuality = ImageSmoothingQuality.low;
  
  Object fillStyle = '#000000';
  Object strokeStyle = '#000000';
  
  double lineWidth = 1.0;
  StrokeCap lineCap = StrokeCap.butt;
  StrokeJoin lineJoin = StrokeJoin.miter;
  double miterLimit = 10.0;
  double lineDashOffset = 0.0;
  List<double> lineDash = [];
  
  double shadowBlur = 0.0;
  String shadowColor = 'transparent';
  double shadowOffsetX = 0.0;
  double shadowOffsetY = 0.0;
  
  String font = '10px sans-serif';
  TextAlign textAlign = TextAlign.start;
  TextBaseline textBaseline = TextBaseline.alphabetic;
  TextDirection direction = TextDirection.inherit;
  String letterSpacing = '0px';
  String wordSpacing = '0px';
  String filter = 'none';
  String fontKerning = 'auto';
  String fontStretch = 'normal';
  String fontVariantCaps = 'normal';
  String textRendering = 'auto';
  
  _ContextState clone() {
    return _ContextState()
      ..transform = transform.clone()
      ..globalAlpha = globalAlpha
      ..globalCompositeOperation = globalCompositeOperation
      ..imageSmoothingEnabled = imageSmoothingEnabled
      ..imageSmoothingQuality = imageSmoothingQuality
      ..fillStyle = fillStyle
      ..strokeStyle = strokeStyle
      ..lineWidth = lineWidth
      ..lineCap = lineCap
      ..lineJoin = lineJoin
      ..miterLimit = miterLimit
      ..lineDashOffset = lineDashOffset
      ..lineDash = List.from(lineDash)
      ..shadowBlur = shadowBlur
      ..shadowColor = shadowColor
      ..shadowOffsetX = shadowOffsetX
      ..shadowOffsetY = shadowOffsetY
      ..font = font
      ..textAlign = textAlign
      ..textBaseline = textBaseline
      ..direction = direction
      ..letterSpacing = letterSpacing
      ..wordSpacing = wordSpacing
      ..filter = filter
      ..fontKerning = fontKerning
      ..fontStretch = fontStretch
      ..fontVariantCaps = fontVariantCaps
      ..textRendering = textRendering;
  }
}

/// Text measurement result
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
  
  TextMetrics({
    required this.width,
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

/// Image data for pixel manipulation
class ImageData implements IImageData {
  @override
  final int width;
  @override
  final int height;
  @override
  late final Uint8ClampedList data;
  @override
  final String colorSpace;
  
  ImageData(this.width, this.height, {this.colorSpace = 'srgb'}) {
    data = Uint8ClampedList(width * height * 4);
  }
  
  ImageData.fromData(this.width, this.height, this.data, {this.colorSpace = 'srgb'});
}
