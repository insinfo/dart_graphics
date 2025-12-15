/// CairoCanvasRenderingContext2D - HTML5 Canvas 2D Rendering Context for Cairo
/// 
/// This class provides the drawing methods for 2D rendering using Cairo,
/// following the HTML5 Canvas 2D Context specification.

import 'dart:typed_data';

import '../cairo_api.dart';
import '../cairo_types.dart';
import '../generated/ffi.dart' as cairo_ffi;
import '../../shared/canvas2d/canvas2d.dart' hide LineCap, LineJoin;
import 'canvas.dart';

/// Text alignment options
enum CairoTextAlign { left, right, center, start, end }

/// Text baseline options
enum CairoTextBaseline { top, hanging, middle, alphabetic, ideographic, bottom }

/// Image smoothing quality
enum CairoImageSmoothingQuality { low, medium, high }

/// Direction for text rendering
enum CairoTextDirection { ltr, rtl, inherit }

/// The 2D rendering context for a Cairo Canvas
/// 
/// Provides methods for drawing shapes, text, images, and other graphics
/// following the HTML5 Canvas 2D API.
class CairoCanvasRenderingContext2D implements ICanvasRenderingContext2D {
  final CairoHtmlCanvas canvas;
  final CairoCanvasImpl _ctx;
  
  // Current path being built
  CairoPath2D _currentPath;
  
  // Style stacks
  final List<_ContextState> _stateStack = [];
  _ContextState _state;
  
  // ==================== Constructor ====================
  
  CairoCanvasRenderingContext2D(this.canvas)
      : _ctx = canvas.cairoCanvas,
        _currentPath = CairoPath2D(),
        _state = _ContextState();
  
  /// Get the Cairo instance
  Cairo get cairo => canvas.cairo;
  
  // ==================== State Management ====================
  
  /// Saves the current drawing state to the stack
  void save() {
    _stateStack.add(_state.clone());
    _ctx.save();
  }
  
  /// Restores the most recently saved drawing state
  void restore() {
    if (_stateStack.isNotEmpty) {
      _state = _stateStack.removeLast();
      _ctx.restore();
      _applyState();
    }
  }
  
  /// Resets the context to its default state
  void reset() {
    _stateStack.clear();
    _state = _ContextState();
    _currentPath.reset();
    _ctx.identityMatrix();
    _applyState();
  }
  
  /// Returns whether context is lost (always false for this implementation)
  bool isContextLost() => false;
  
  void _applyState() {
    _ctx.setLineWidth(_state.lineWidth);
    _ctx.setLineCap(_state.lineCap);
    _ctx.setLineJoin(_state.lineJoin);
    _ctx.setMiterLimit(_state.miterLimit);
    if (_state.lineDash.isEmpty) {
      _ctx.clearDash();
    } else {
      _ctx.setDash(_state.lineDash, _state.lineDashOffset);
    }
  }
  
  // ==================== Transforms ====================
  
  /// Adds a scaling transformation
  void scale(double x, double y) {
    _ctx.scale(x, y);
    _state.transform = _state.transform.scaled(x, y);
  }
  
  /// Adds a rotation transformation
  void rotate(double angle) {
    _ctx.rotate(angle);
    _state.transform = _state.transform.rotated(angle);
  }
  
  /// Adds a translation transformation
  void translate(double x, double y) {
    _ctx.translate(x, y);
    _state.transform = _state.transform.translated(x, y);
  }
  
  /// Multiplies the current transformation matrix
  @override
  void transform(double a, double b, double c, double d, double e, double f) {
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
    _ctx.identityMatrix();
  }
  
  void _applyTransformToCanvas() {
    _ctx.identityMatrix();
    final t = _state.transform;
    _ctx.translate(t.e, t.f);
    if (t.a != 1.0 || t.d != 1.0 || t.b != 0.0 || t.c != 0.0) {
      if (t.b == 0.0 && t.c == 0.0) {
        _ctx.scale(t.a, t.d);
      }
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
  
  cairo_ffi.CairoOperatorEnum _parseOperator(String op) {
    switch (op) {
      case 'source-over': return cairo_ffi.CairoOperatorEnum.CAIRO_OPERATOR_OVER;
      case 'source-in': return cairo_ffi.CairoOperatorEnum.CAIRO_OPERATOR_IN;
      case 'source-out': return cairo_ffi.CairoOperatorEnum.CAIRO_OPERATOR_OUT;
      case 'source-atop': return cairo_ffi.CairoOperatorEnum.CAIRO_OPERATOR_ATOP;
      case 'destination-over': return cairo_ffi.CairoOperatorEnum.CAIRO_OPERATOR_DEST_OVER;
      case 'destination-in': return cairo_ffi.CairoOperatorEnum.CAIRO_OPERATOR_DEST_IN;
      case 'destination-out': return cairo_ffi.CairoOperatorEnum.CAIRO_OPERATOR_DEST_OUT;
      case 'destination-atop': return cairo_ffi.CairoOperatorEnum.CAIRO_OPERATOR_DEST_ATOP;
      case 'lighter': return cairo_ffi.CairoOperatorEnum.CAIRO_OPERATOR_ADD;
      case 'copy': return cairo_ffi.CairoOperatorEnum.CAIRO_OPERATOR_SOURCE;
      case 'xor': return cairo_ffi.CairoOperatorEnum.CAIRO_OPERATOR_XOR;
      case 'multiply': return cairo_ffi.CairoOperatorEnum.CAIRO_OPERATOR_MULTIPLY;
      case 'screen': return cairo_ffi.CairoOperatorEnum.CAIRO_OPERATOR_SCREEN;
      case 'overlay': return cairo_ffi.CairoOperatorEnum.CAIRO_OPERATOR_OVERLAY;
      case 'darken': return cairo_ffi.CairoOperatorEnum.CAIRO_OPERATOR_DARKEN;
      case 'lighten': return cairo_ffi.CairoOperatorEnum.CAIRO_OPERATOR_LIGHTEN;
      case 'color-dodge': return cairo_ffi.CairoOperatorEnum.CAIRO_OPERATOR_COLOR_DODGE;
      case 'color-burn': return cairo_ffi.CairoOperatorEnum.CAIRO_OPERATOR_COLOR_BURN;
      case 'hard-light': return cairo_ffi.CairoOperatorEnum.CAIRO_OPERATOR_HARD_LIGHT;
      case 'soft-light': return cairo_ffi.CairoOperatorEnum.CAIRO_OPERATOR_SOFT_LIGHT;
      case 'difference': return cairo_ffi.CairoOperatorEnum.CAIRO_OPERATOR_DIFFERENCE;
      case 'exclusion': return cairo_ffi.CairoOperatorEnum.CAIRO_OPERATOR_EXCLUSION;
      default: return cairo_ffi.CairoOperatorEnum.CAIRO_OPERATOR_OVER;
    }
  }
  
  // ==================== Image Smoothing ====================
  
  /// Whether image smoothing is enabled
  bool get imageSmoothingEnabled => _state.imageSmoothingEnabled;
  set imageSmoothingEnabled(bool value) {
    _state.imageSmoothingEnabled = value;
  }
  
  /// Image smoothing quality
  @override
  ImageSmoothingQuality get imageSmoothingQuality => _state.imageSmoothingQuality;
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
  
  void _applyFillStyle() {
    final style = _state.fillStyle;
    if (style is String) {
      final color = _parseColor(style);
      final alpha = _state.globalAlpha * color.a;
      _ctx.setSourceRgba(color.r, color.g, color.b, alpha);
    } else if (style is CairoCanvasGradient) {
      final pattern = style.getPattern();
      if (pattern != null) {
        _ctx.setPattern(pattern.pointer);
      }
    } else if (style is CairoCanvasPattern) {
      final pattern = style.getPattern();
      _ctx.setPattern(pattern.pointer);
    }
    cairo.bindings.cairo_set_operator(_ctx.pointer, _parseOperator(_state.globalCompositeOperation));
  }
  
  void _applyStrokeStyle() {
    final style = _state.strokeStyle;
    if (style is String) {
      final color = _parseColor(style);
      final alpha = _state.globalAlpha * color.a;
      _ctx.setSourceRgba(color.r, color.g, color.b, alpha);
    } else if (style is CairoCanvasGradient) {
      final pattern = style.getPattern();
      if (pattern != null) {
        _ctx.setPattern(pattern.pointer);
      }
    } else if (style is CairoCanvasPattern) {
      final pattern = style.getPattern();
      _ctx.setPattern(pattern.pointer);
    }
    
    _ctx.setLineWidth(_state.lineWidth);
    _ctx.setLineCap(_state.lineCap);
    _ctx.setLineJoin(_state.lineJoin);
    _ctx.setMiterLimit(_state.miterLimit);
    
    if (_state.lineDash.isEmpty) {
      _ctx.clearDash();
    } else {
      _ctx.setDash(_state.lineDash, _state.lineDashOffset);
    }
    
    cairo.bindings.cairo_set_operator(_ctx.pointer, _parseOperator(_state.globalCompositeOperation));
  }
  
  CairoColor _parseColor(String colorStr) {
    colorStr = colorStr.trim().toLowerCase();
    
    final namedColors = _namedColors[colorStr];
    if (namedColors != null) {
      return CairoColor.fromHex(namedColors);
    }
    
    if (colorStr.startsWith('#')) {
      return _parseHexColor(colorStr);
    }
    
    if (colorStr.startsWith('rgb')) {
      return _parseRgbColor(colorStr);
    }
    
    return CairoColor.black;
  }
  
  CairoColor _parseHexColor(String hex) {
    hex = hex.substring(1);
    
    int r, g, b;
    double a = 1.0;
    
    if (hex.length == 3) {
      r = int.parse(hex[0] + hex[0], radix: 16);
      g = int.parse(hex[1] + hex[1], radix: 16);
      b = int.parse(hex[2] + hex[2], radix: 16);
    } else if (hex.length == 4) {
      r = int.parse(hex[0] + hex[0], radix: 16);
      g = int.parse(hex[1] + hex[1], radix: 16);
      b = int.parse(hex[2] + hex[2], radix: 16);
      a = int.parse(hex[3] + hex[3], radix: 16) / 255.0;
    } else if (hex.length == 6) {
      r = int.parse(hex.substring(0, 2), radix: 16);
      g = int.parse(hex.substring(2, 4), radix: 16);
      b = int.parse(hex.substring(4, 6), radix: 16);
    } else if (hex.length == 8) {
      r = int.parse(hex.substring(0, 2), radix: 16);
      g = int.parse(hex.substring(2, 4), radix: 16);
      b = int.parse(hex.substring(4, 6), radix: 16);
      a = int.parse(hex.substring(6, 8), radix: 16) / 255.0;
    } else {
      return CairoColor.black;
    }
    
    return CairoColor(r / 255.0, g / 255.0, b / 255.0, a);
  }
  
  CairoColor _parseRgbColor(String rgb) {
    final isRgba = rgb.startsWith('rgba');
    final start = isRgba ? 5 : 4;
    final end = rgb.length - 1;
    final parts = rgb.substring(start, end).split(',').map((s) => s.trim()).toList();
    
    if (parts.length < 3) return CairoColor.black;
    
    final r = _parseColorComponent(parts[0]) / 255.0;
    final g = _parseColorComponent(parts[1]) / 255.0;
    final b = _parseColorComponent(parts[2]) / 255.0;
    final a = parts.length > 3 ? double.tryParse(parts[3]) ?? 1.0 : 1.0;
    
    return CairoColor(r.clamp(0.0, 1.0), g.clamp(0.0, 1.0), b.clamp(0.0, 1.0), a.clamp(0.0, 1.0));
  }
  
  double _parseColorComponent(String value) {
    if (value.endsWith('%')) {
      return (double.tryParse(value.substring(0, value.length - 1)) ?? 0) * 2.55;
    }
    return double.tryParse(value) ?? 0;
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
  
  LineCap _parseLineCap(String cap) {
    switch (cap) {
      case 'round': return LineCap.round;
      case 'square': return LineCap.square;
      default: return LineCap.butt;
    }
  }
  
  String _lineCapToString(LineCap cap) {
    switch (cap) {
      case LineCap.round: return 'round';
      case LineCap.square: return 'square';
      default: return 'butt';
    }
  }
  
  LineJoin _parseLineJoin(String join) {
    switch (join) {
      case 'round': return LineJoin.round;
      case 'bevel': return LineJoin.bevel;
      default: return LineJoin.miter;
    }
  }
  
  String _lineJoinToString(LineJoin join) {
    switch (join) {
      case LineJoin.round: return 'round';
      case LineJoin.bevel: return 'bevel';
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
    _applyFont();
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
  
  /// CSS filter
  @override
  String get filter => _state.filter;
  @override
  set filter(String value) {
    _state.filter = value;
  }
  
  void _applyFont() {
    final size = _parseFontSize(_state.font);
    final family = _parseFontFamily(_state.font);
    final weight = _parseFontWeight(_state.font);
    final slant = _parseFontSlant(_state.font);
    
    _ctx.selectFontFace(family, slant: slant, weight: weight);
    _ctx.setFontSize(size);
  }
  
  double _parseFontSize(String fontStr) {
    final match = RegExp(r'(\d+(?:\.\d+)?)\s*px').firstMatch(fontStr);
    if (match != null) {
      return double.tryParse(match.group(1)!) ?? 10.0;
    }
    return 10.0;
  }
  
  String _parseFontFamily(String fontStr) {
    final parts = fontStr.split(' ');
    for (var i = parts.length - 1; i >= 0; i--) {
      final part = parts[i].replaceAll('"', '').replaceAll("'", '');
      if (!RegExp(r'^\d+(\.\d+)?px$').hasMatch(part) &&
          part != 'bold' && part != 'italic' && part != 'normal') {
        return part;
      }
    }
    return 'sans-serif';
  }
  
  FontWeight _parseFontWeight(String fontStr) {
    if (fontStr.contains('bold')) return FontWeight.bold;
    return FontWeight.normal;
  }
  
  FontSlant _parseFontSlant(String fontStr) {
    if (fontStr.contains('italic')) return FontSlant.italic;
    if (fontStr.contains('oblique')) return FontSlant.oblique;
    return FontSlant.normal;
  }
  
  CairoTextAlign _parseTextAlign(String align) {
    switch (align) {
      case 'left': return CairoTextAlign.left;
      case 'right': return CairoTextAlign.right;
      case 'center': return CairoTextAlign.center;
      case 'start': return CairoTextAlign.start;
      case 'end': return CairoTextAlign.end;
      default: return CairoTextAlign.start;
    }
  }
  
  String _textAlignToString(CairoTextAlign align) {
    switch (align) {
      case CairoTextAlign.left: return 'left';
      case CairoTextAlign.right: return 'right';
      case CairoTextAlign.center: return 'center';
      case CairoTextAlign.start: return 'start';
      case CairoTextAlign.end: return 'end';
    }
  }
  
  CairoTextBaseline _parseTextBaseline(String baseline) {
    switch (baseline) {
      case 'top': return CairoTextBaseline.top;
      case 'hanging': return CairoTextBaseline.hanging;
      case 'middle': return CairoTextBaseline.middle;
      case 'alphabetic': return CairoTextBaseline.alphabetic;
      case 'ideographic': return CairoTextBaseline.ideographic;
      case 'bottom': return CairoTextBaseline.bottom;
      default: return CairoTextBaseline.alphabetic;
    }
  }
  
  String _textBaselineToString(CairoTextBaseline baseline) {
    switch (baseline) {
      case CairoTextBaseline.top: return 'top';
      case CairoTextBaseline.hanging: return 'hanging';
      case CairoTextBaseline.middle: return 'middle';
      case CairoTextBaseline.alphabetic: return 'alphabetic';
      case CairoTextBaseline.ideographic: return 'ideographic';
      case CairoTextBaseline.bottom: return 'bottom';
    }
  }
  
  CairoTextDirection _parseTextDirection(String dir) {
    switch (dir) {
      case 'ltr': return CairoTextDirection.ltr;
      case 'rtl': return CairoTextDirection.rtl;
      default: return CairoTextDirection.inherit;
    }
  }
  
  String _textDirectionToString(CairoTextDirection dir) {
    switch (dir) {
      case CairoTextDirection.ltr: return 'ltr';
      case CairoTextDirection.rtl: return 'rtl';
      case CairoTextDirection.inherit: return 'inherit';
    }
  }
  
  // ==================== Path Methods ====================
  
  /// Begins a new path
  void beginPath() {
    _currentPath = CairoPath2D();
    _ctx.newPath();
  }
  
  /// Closes the current subpath
  void closePath() {
    _currentPath.closePath();
    _ctx.closePath();
  }
  
  /// Moves the path to a point
  void moveTo(double x, double y) {
    _currentPath.moveTo(x, y);
    _ctx.moveTo(x, y);
  }
  
  /// Draws a line to a point
  void lineTo(double x, double y) {
    _currentPath.lineTo(x, y);
    _ctx.lineTo(x, y);
  }
  
  /// Draws a quadratic Bézier curve
  void quadraticCurveTo(double cpx, double cpy, double x, double y) {
    _currentPath.quadraticCurveTo(cpx, cpy, x, y);
  }
  
  /// Draws a cubic Bézier curve
  void bezierCurveTo(double cp1x, double cp1y, double cp2x, double cp2y, double x, double y) {
    _currentPath.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, x, y);
    _ctx.curveTo(cp1x, cp1y, cp2x, cp2y, x, y);
  }
  
  /// Draws an arc with tangent lines
  void arcTo(double x1, double y1, double x2, double y2, double radius) {
    _currentPath.arcTo(x1, y1, x2, y2, radius);
  }
  
  /// Adds an arc to the path
  void arc(double x, double y, double radius, double startAngle, double endAngle, [bool counterclockwise = false]) {
    _currentPath.arc(x, y, radius, startAngle, endAngle, counterclockwise);
    if (counterclockwise) {
      _ctx.arcNegative(x, y, radius, startAngle, endAngle);
    } else {
      _ctx.arc(x, y, radius, startAngle, endAngle);
    }
  }
  
  /// Adds an ellipse to the path
  void ellipse(double x, double y, double radiusX, double radiusY, double rotation, double startAngle, double endAngle, [bool counterclockwise = false]) {
    _currentPath.ellipse(x, y, radiusX, radiusY, rotation, startAngle, endAngle, counterclockwise);
  }
  
  /// Adds a rectangle to the path
  void rect(double x, double y, double width, double height) {
    _currentPath.rect(x, y, width, height);
    _ctx.rectangle(x, y, width, height);
  }
  
  /// Adds a rounded rectangle to the path
  void roundRect(double x, double y, double width, double height, [dynamic radii = 0]) {
    _currentPath.roundRect(x, y, width, height, radii);
  }
  
  // ==================== Drawing Paths ====================
  
  /// Fills the current path
  void fill([dynamic pathOrFillRule, String? fillRule]) {
    CairoPath2D? pathToFill;
    String rule = 'nonzero';
    
    if (pathOrFillRule is CairoPath2D) {
      pathToFill = pathOrFillRule;
      rule = fillRule ?? 'nonzero';
    } else if (pathOrFillRule is String) {
      pathToFill = _currentPath;
      rule = pathOrFillRule;
    } else {
      pathToFill = _currentPath;
    }
    
    _applyFillStyle();
    
    // Set fill rule
    if (rule == 'evenodd') {
      _ctx.setFillRule(cairo_ffi.CairoFillRuleEnum.CAIRO_FILL_RULE_EVEN_ODD);
    } else {
      _ctx.setFillRule(cairo_ffi.CairoFillRuleEnum.CAIRO_FILL_RULE_WINDING);
    }
    
    // Apply path and fill
    _ctx.newPath();
    pathToFill.applyTo(_ctx);
    _ctx.fill();
  }
  
  /// Strokes the current path
  @override
  void stroke([IPath2D? path]) {
    CairoPath2D pathToStroke = _currentPath;
    if (path is CairoPath2D) {
      pathToStroke = path;
    }
    
    _applyStrokeStyle();
    
    // Apply path and stroke
    _ctx.newPath();
    pathToStroke.applyTo(_ctx);
    _ctx.stroke();
  }
  
  /// Draws a focus ring
  @override
  void drawFocusIfNeeded(dynamic elementOrPath, [dynamic element]) {
    // Not implemented for Cairo
  }
  
  /// Scrolls the path into view
  @override
  void scrollPathIntoView([IPath2D? path]) {
    // Not applicable for Cairo
  }
  
  /// Clips to the current path
  void clip([dynamic pathOrFillRule, String? fillRule]) {
    CairoPath2D? pathToClip;
    String rule = 'nonzero';
    
    if (pathOrFillRule is CairoPath2D) {
      pathToClip = pathOrFillRule;
      rule = fillRule ?? 'nonzero';
    } else if (pathOrFillRule is String) {
      pathToClip = _currentPath;
      rule = pathOrFillRule;
    } else {
      pathToClip = _currentPath;
    }
    
    if (rule == 'evenodd') {
      _ctx.setFillRule(cairo_ffi.CairoFillRuleEnum.CAIRO_FILL_RULE_EVEN_ODD);
    } else {
      _ctx.setFillRule(cairo_ffi.CairoFillRuleEnum.CAIRO_FILL_RULE_WINDING);
    }
    
    _ctx.newPath();
    pathToClip.applyTo(_ctx);
    _ctx.clip();
  }
  
  /// Tests if a point is in the current path
  bool isPointInPath(double x, double y, [String fillRule = 'nonzero']) {
    _ctx.newPath();
    _currentPath.applyTo(_ctx);
    return cairo.bindings.cairo_in_fill(_ctx.pointer, x, y) != 0;
  }
  
  /// Tests if a point is in the stroke of the current path
  bool isPointInStroke(double x, double y) {
    _ctx.newPath();
    _currentPath.applyTo(_ctx);
    return cairo.bindings.cairo_in_stroke(_ctx.pointer, x, y) != 0;
  }
  
  // ==================== Drawing Rectangles ====================
  
  /// Fills a rectangle
  void fillRect(double x, double y, double width, double height) {
    _applyFillStyle();
    _ctx.rectangle(x, y, width, height);
    _ctx.fill();
  }
  
  /// Strokes a rectangle
  void strokeRect(double x, double y, double width, double height) {
    _applyStrokeStyle();
    _ctx.rectangle(x, y, width, height);
    _ctx.stroke();
  }
  
  /// Clears a rectangle to transparent
  void clearRect(double x, double y, double width, double height) {
    _ctx.save();
    cairo.bindings.cairo_set_operator(_ctx.pointer, cairo_ffi.CairoOperatorEnum.CAIRO_OPERATOR_CLEAR);
    _ctx.rectangle(x, y, width, height);
    _ctx.fill();
    _ctx.restore();
  }
  
  // ==================== Drawing Text ====================
  
  /// Fills text at a position
  void fillText(String text, double x, double y, [double? maxWidth]) {
    _applyFillStyle();
    _applyFont();
    
    final adjustedX = _getTextAlignOffset(text, x);
    final adjustedY = _getTextBaselineOffset(y);
    
    _ctx.moveTo(adjustedX, adjustedY);
    _ctx.showText(text);
  }
  
  /// Strokes text at a position
  void strokeText(String text, double x, double y, [double? maxWidth]) {
    _applyStrokeStyle();
    _applyFont();
    
    final adjustedX = _getTextAlignOffset(text, x);
    final adjustedY = _getTextBaselineOffset(y);
    
    _ctx.moveTo(adjustedX, adjustedY);
    _ctx.textPath(text);
    _ctx.stroke();
  }
  
  /// Measures text width
  @override
  ITextMetrics measureText(String text) {
    _applyFont();
    final fontSize = _parseFontSize(_state.font);
    final width = text.length * fontSize * 0.5;
    return CairoTextMetrics(width: width);
  }
  
  double _getTextAlignOffset(String text, double x) {
    final fontSize = _parseFontSize(_state.font);
    final width = text.length * fontSize * 0.5;
    
    switch (_state.textAlign) {
      case CairoTextAlign.center:
        return x - width / 2;
      case CairoTextAlign.right:
      case CairoTextAlign.end:
        return x - width;
      default:
        return x;
    }
  }
  
  double _getTextBaselineOffset(double y) {
    final fontSize = _parseFontSize(_state.font);
    
    switch (_state.textBaseline) {
      case CairoTextBaseline.top:
        return y + fontSize;
      case CairoTextBaseline.middle:
        return y + fontSize / 2;
      case CairoTextBaseline.bottom:
        return y;
      case CairoTextBaseline.hanging:
        return y + fontSize * 0.8;
      default:
        return y;
    }
  }
  
  // ==================== Drawing Images ====================
  
  /// Draws an image to the canvas
  void drawImage(dynamic image, double dx, double dy, [double? dWidth, double? dHeight, double? sx, double? sy, double? sWidth, double? sHeight]) {
    if (image is CairoSurfaceImpl) {
      _drawCairoSurface(image, dx, dy, dWidth, dHeight, sx, sy, sWidth, sHeight);
    } else if (image is CairoImageData) {
      // Create a temporary surface from ImageData
      final surface = cairo.createImageSurface(image.width, image.height);
      final surfaceData = surface.getData();
      if (surfaceData != null) {
        // Convert RGBA to BGRA for Cairo
        for (var i = 0; i < image.data.length; i += 4) {
          final r = image.data[i];
          final g = image.data[i + 1];
          final b = image.data[i + 2];
          final a = image.data[i + 3];
          surfaceData[i] = b;
          surfaceData[i + 1] = g;
          surfaceData[i + 2] = r;
          surfaceData[i + 3] = a;
        }
        surface.markDirty();
      }
      _drawCairoSurface(surface, dx, dy, dWidth, dHeight, sx, sy, sWidth, sHeight);
      surface.dispose();
    }
  }
  
  void _drawCairoSurface(CairoSurfaceImpl surface, double dx, double dy, 
      [double? dWidth, double? dHeight, double? sx, double? sy, double? sWidth, double? sHeight]) {
    _ctx.save();
    
    // Source rectangle
    final srcX = sx ?? 0;
    final srcY = sy ?? 0;
    final srcW = sWidth ?? surface.width.toDouble();
    final srcH = sHeight ?? surface.height.toDouble();
    
    // Destination size
    final dstW = dWidth ?? srcW;
    final dstH = dHeight ?? srcH;
    
    // Calculate scale
    final scaleX = dstW / srcW;
    final scaleY = dstH / srcH;
    
    // Move to destination, apply scale
    _ctx.translate(dx, dy);
    _ctx.scale(scaleX, scaleY);
    
    // Set the source surface with offset for source rectangle
    _ctx.setSourceSurface(surface, -srcX, -srcY);
    
    // Draw the rectangle
    _ctx.rectangle(0, 0, srcW, srcH);
    _ctx.fill();
    
    _ctx.restore();
  }
  
  // ==================== Pixel Manipulation ====================
  
  /// Creates image data
  @override
  IImageData createImageData(int width, [int? height]) {
    return CairoImageData(width, height ?? width);
  }
  
  /// Gets image data from the canvas
  @override
  IImageData getImageData(int sx, int sy, int sw, int sh) {
    final data = _ctx.surface.getData();
    if (data == null) {
      return CairoImageData(sw, sh);
    }
    
    final imageData = CairoImageData(sw, sh);
    final stride = canvas.width * 4;
    
    for (var y = 0; y < sh; y++) {
      for (var x = 0; x < sw; x++) {
        final srcX = sx + x;
        final srcY = sy + y;
        if (srcX >= 0 && srcX < canvas.width && srcY >= 0 && srcY < canvas.height) {
          final srcIdx = srcY * stride + srcX * 4;
          final dstIdx = (y * sw + x) * 4;
          // Cairo uses BGRA, convert to RGBA
          imageData.data[dstIdx + 0] = data[srcIdx + 2]; // R
          imageData.data[dstIdx + 1] = data[srcIdx + 1]; // G
          imageData.data[dstIdx + 2] = data[srcIdx + 0]; // B
          imageData.data[dstIdx + 3] = data[srcIdx + 3]; // A
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
    
    // Get direct access to surface data
    final surfaceData = _ctx.surface.getData();
    if (surfaceData == null) return;
    
    final surfaceStride = canvas.width * 4;
    
    for (var y = 0; y < srcH; y++) {
      for (var x = 0; x < srcW; x++) {
        final imgX = srcX + x;
        final imgY = srcY + y;
        final dstX = dx + srcX + x;
        final dstY = dy + srcY + y;
        
        // Bounds checking
        if (imgX < 0 || imgX >= imageData.width || imgY < 0 || imgY >= imageData.height) continue;
        if (dstX < 0 || dstX >= canvas.width || dstY < 0 || dstY >= canvas.height) continue;
        
        final srcIdx = (imgY * imageData.width + imgX) * 4;
        final dstIdx = dstY * surfaceStride + dstX * 4;
        
        // Convert RGBA to BGRA for Cairo
        surfaceData[dstIdx + 0] = imageData.data[srcIdx + 2]; // B
        surfaceData[dstIdx + 1] = imageData.data[srcIdx + 1]; // G
        surfaceData[dstIdx + 2] = imageData.data[srcIdx + 0]; // R
        surfaceData[dstIdx + 3] = imageData.data[srcIdx + 3]; // A
      }
    }
    
    // Mark the modified region as dirty
    _ctx.surface.markDirty();
  }
  
  // ==================== Gradients and Patterns ====================
  
  /// Creates a linear gradient
  @override
  ICanvasGradient createLinearGradient(double x0, double y0, double x1, double y1) {
    return CairoCanvasGradient.linear(cairo, x0, y0, x1, y1);
  }
  
  /// Creates a radial gradient
  @override
  ICanvasGradient createRadialGradient(double x0, double y0, double r0, double x1, double y1, double r1) {
    return CairoCanvasGradient.radial(cairo, x0, y0, r0, x1, y1, r1);
  }
  
  /// Creates a conic gradient (not natively supported by Cairo)
  @override
  ICanvasGradient createConicGradient(double startAngle, double x, double y) {
    // Cairo doesn't support conic gradients natively, return a linear gradient as fallback
    return CairoCanvasGradient.linear(cairo, x, y, x + 100, y);
  }
  
  /// Creates a pattern
  @override
  ICanvasPattern? createPattern(dynamic image, String repetition) {
    if (image is CairoSurfaceImpl) {
      final rep = switch (repetition) {
        'repeat' => PatternRepetition.repeat,
        'repeat-x' => PatternRepetition.repeatX,
        'repeat-y' => PatternRepetition.repeatY,
        'no-repeat' => PatternRepetition.noRepeat,
        _ => PatternRepetition.repeat,
      };
      return CairoCanvasPattern.fromSurface(image, repetition: rep);
    }
    return null;
  }
  
  // ==================== Disposal ====================
  
  /// Disposes resources
  void dispose() {
    // Context state is managed by the canvas
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
  String filter = 'none';
  
  Object fillStyle = '#000000';
  Object strokeStyle = '#000000';
  
  double lineWidth = 1.0;
  LineCap lineCap = LineCap.butt;
  LineJoin lineJoin = LineJoin.miter;
  double miterLimit = 10.0;
  double lineDashOffset = 0.0;
  List<double> lineDash = [];
  
  double shadowBlur = 0.0;
  String shadowColor = 'transparent';
  double shadowOffsetX = 0.0;
  double shadowOffsetY = 0.0;
  
  String font = '10px sans-serif';
  CairoTextAlign textAlign = CairoTextAlign.start;
  CairoTextBaseline textBaseline = CairoTextBaseline.alphabetic;
  CairoTextDirection direction = CairoTextDirection.inherit;
  String letterSpacing = '0px';
  String wordSpacing = '0px';
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
      ..filter = filter
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
      ..fontKerning = fontKerning
      ..fontStretch = fontStretch
      ..fontVariantCaps = fontVariantCaps
      ..textRendering = textRendering;
  }
}

/// Text measurement result
class CairoTextMetrics implements ITextMetrics {
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
  
  CairoTextMetrics({
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
class CairoImageData implements IImageData {
  @override
  final int width;
  @override
  final int height;
  @override
  late final Uint8ClampedList data;
  @override
  final String colorSpace;
  
  CairoImageData(this.width, this.height, {this.colorSpace = 'srgb'}) {
    data = Uint8ClampedList(width * height * 4);
  }
  
  CairoImageData.fromData(this.width, this.height, this.data, {this.colorSpace = 'srgb'});
}

/// Common named CSS colors
const Map<String, int> _namedColors = {
  'transparent': 0x00000000,
  'black': 0xFF000000,
  'white': 0xFFFFFFFF,
  'red': 0xFFFF0000,
  'green': 0xFF008000,
  'blue': 0xFF0000FF,
  'yellow': 0xFFFFFF00,
  'cyan': 0xFF00FFFF,
  'magenta': 0xFFFF00FF,
  'orange': 0xFFFFA500,
  'purple': 0xFF800080,
  'pink': 0xFFFFC0CB,
  'brown': 0xFFA52A2A,
  'gray': 0xFF808080,
  'grey': 0xFF808080,
  'lime': 0xFF00FF00,
  'navy': 0xFF000080,
  'teal': 0xFF008080,
  'aqua': 0xFF00FFFF,
  'maroon': 0xFF800000,
  'olive': 0xFF808000,
  'silver': 0xFFC0C0C0,
  'fuchsia': 0xFFFF00FF,
  'coral': 0xFFFF7F50,
  'gold': 0xFFFFD700,
  'indigo': 0xFF4B0082,
  'violet': 0xFFEE82EE,
  'crimson': 0xFFDC143C,
  'darkblue': 0xFF00008B,
  'darkgreen': 0xFF006400,
  'darkred': 0xFF8B0000,
  'lightblue': 0xFFADD8E6,
  'lightgreen': 0xFF90EE90,
  'lightgray': 0xFFD3D3D3,
  'lightgrey': 0xFFD3D3D3,
  'darkgray': 0xFFA9A9A9,
  'darkgrey': 0xFFA9A9A9,
  'skyblue': 0xFF87CEEB,
  'steelblue': 0xFF4682B4,
  'tomato': 0xFFFF6347,
  'turquoise': 0xFF40E0D0,
  'wheat': 0xFFF5DEB3,
  'beige': 0xFFF5F5DC,
  'ivory': 0xFFFFFFF0,
  'khaki': 0xFFF0E68C,
  'lavender': 0xFFE6E6FA,
  'salmon': 0xFFFA8072,
  'tan': 0xFFD2B48C,
  'chocolate': 0xFFD2691E,
  'firebrick': 0xFFB22222,
  'forestgreen': 0xFF228B22,
  'goldenrod': 0xFFDAA520,
  'hotpink': 0xFFFF69B4,
  'limegreen': 0xFF32CD32,
  'mediumblue': 0xFF0000CD,
  'midnightblue': 0xFF191970,
  'orangered': 0xFFFF4500,
  'orchid': 0xFFDA70D6,
  'plum': 0xFFDDA0DD,
  'rosybrown': 0xFFBC8F8F,
  'royalblue': 0xFF4169E1,
  'seagreen': 0xFF2E8B57,
  'sienna': 0xFFA0522D,
  'slateblue': 0xFF6A5ACD,
  'slategray': 0xFF708090,
  'slategrey': 0xFF708090,
  'springgreen': 0xFF00FF7F,
  'yellowgreen': 0xFF9ACD32,
};
