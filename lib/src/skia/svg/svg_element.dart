import '../skia_api.dart';
import '../sk_color.dart';
import '../sk_geometry.dart';
import 'svg_color.dart';
import 'svg_style.dart';
import 'svg_transform.dart';

/// Context for SVG rendering operations
/// Contains the Skia instance needed to create Skia objects
class SvgRenderContext {
  final Skia skia;
  
  SvgRenderContext(this.skia);
  
  /// Create a path using this context's Skia instance
  SkiaPath? createPath() => skia.createPath();
  
  /// Create a font using this context's Skia instance
  SkiaFont? createFont({double size = 12.0}) {
    final typeface = skia.createDefaultTypeface();
    if (typeface == null) return null;
    return skia.createFontFromTypeface(typeface, size: size);
  }
}

/// Base class for SVG elements that can be rendered
abstract class SvgElement {
  String? id;
  String? className;
  String? elementType; // Element type for CSS selectors (rect, circle, etc)
  Map<String, String> attributes = {};
  List<SvgElement> children = [];
  
  /// Style manager for handling CSS and presentation attributes
  final StyleManager styleManager = StyleManager();
  
  /// Fill paint (color or gradient)
  SKColor? fill;
  double fillOpacity = 1.0;
  
  /// Stroke paint
  SKColor? stroke;
  double strokeWidth = 1.0;
  double strokeOpacity = 1.0;
  StrokeCap strokeLineCap = StrokeCap.butt;
  StrokeJoin strokeLineJoin = StrokeJoin.miter;
  double strokeMiterLimit = 4.0;
  
  /// Opacity
  double opacity = 1.0;
  
  /// Transform
  SvgTransform? transform;
  
  /// Whether this element should be rendered
  bool isVisible = true;
  
  SvgElement();
  
  /// Renders this element to a canvas
  void render(SvgRenderContext ctx, SkiaCanvas canvas);
  
  /// Parses common attributes including CSS styles
  void parseCommonAttributes(Map<String, String> attrs) {
    id = attrs['id'];
    className = attrs['class'];
    attributes = Map.from(attrs);
    
    // First, apply presentation attributes (lowest priority)
    for (final entry in attrs.entries) {
      if (SvgPresentationAttributes.isPresentation(entry.key)) {
        styleManager.applyPresentationAttribute(entry.key, entry.value);
      }
    }
    
    // Then apply inline style attribute (highest priority)
    final styleStr = attrs['style'];
    if (styleStr != null) {
      styleManager.applyInlineStyle(styleStr);
    }
    
    // Now resolve all style properties
    _applyResolvedStyles();
  }
  
  /// Apply resolved styles to element properties
  void _applyResolvedStyles() {
    // Parse fill
    final fillStr = styleManager.getProperty('fill');
    if (fillStr != null && fillStr != 'none') {
      fill = SvgColor.parse(fillStr);
    } else if (fillStr == 'none') {
      fill = null;
    } else {
      fill = SKColors.black; // Default fill
    }
    
    // Parse stroke
    final strokeStr = styleManager.getProperty('stroke');
    if (strokeStr != null && strokeStr != 'none') {
      stroke = SvgColor.parse(strokeStr);
    }
    
    // Parse stroke-width
    final strokeWidthStr = styleManager.getProperty('stroke-width');
    if (strokeWidthStr != null) {
      strokeWidth = double.tryParse(strokeWidthStr) ?? 1.0;
    }
    
    // Parse opacity
    final opacityStr = styleManager.getProperty('opacity');
    if (opacityStr != null) {
      opacity = double.tryParse(opacityStr)?.clamp(0.0, 1.0) ?? 1.0;
    }
    
    final fillOpacityStr = styleManager.getProperty('fill-opacity');
    if (fillOpacityStr != null) {
      fillOpacity = double.tryParse(fillOpacityStr)?.clamp(0.0, 1.0) ?? 1.0;
    }
    
    final strokeOpacityStr = styleManager.getProperty('stroke-opacity');
    if (strokeOpacityStr != null) {
      strokeOpacity = double.tryParse(strokeOpacityStr)?.clamp(0.0, 1.0) ?? 1.0;
    }
    
    // Parse stroke-linecap
    final linecapStr = styleManager.getProperty('stroke-linecap');
    if (linecapStr != null) {
      switch (linecapStr) {
        case 'round':
          strokeLineCap = StrokeCap.round;
          break;
        case 'square':
          strokeLineCap = StrokeCap.square;
          break;
        default:
          strokeLineCap = StrokeCap.butt;
      }
    }
    
    // Parse stroke-linejoin
    final linejoinStr = styleManager.getProperty('stroke-linejoin');
    if (linejoinStr != null) {
      switch (linejoinStr) {
        case 'round':
          strokeLineJoin = StrokeJoin.round;
          break;
        case 'bevel':
          strokeLineJoin = StrokeJoin.bevel;
          break;
        default:
          strokeLineJoin = StrokeJoin.miter;
      }
    }
    
    // Parse visibility/display
    final displayStr = styleManager.getProperty('display');
    final visibilityStr = styleManager.getProperty('visibility');
    isVisible = displayStr != 'none' && visibilityStr != 'hidden';
    
    // Parse transform
    final transformStr = styleManager.getProperty('transform');
    if (transformStr != null) {
      transform = SvgTransform.parse(transformStr);
    }
  }
  
  /// Creates fill paint if needed
  SkiaPaint? createFillPaint(SvgRenderContext ctx) {
    if (fill == null) return null;
    
    var color = fill!;
    final effectiveOpacity = opacity * fillOpacity;
    if (effectiveOpacity < 1.0) {
      color = color.withAlpha((color.alpha * effectiveOpacity).round());
    }
    
    return ctx.skia.createPaint()
      ..color = color
      ..style = PaintStyle.fill
      ..isAntialias = true;
  }
  
  /// Creates stroke paint if needed
  SkiaPaint? createStrokePaint(SvgRenderContext ctx) {
    if (stroke == null || strokeWidth <= 0) return null;
    
    var color = stroke!;
    final effectiveOpacity = opacity * strokeOpacity;
    if (effectiveOpacity < 1.0) {
      color = color.withAlpha((color.alpha * effectiveOpacity).round());
    }
    
    return ctx.skia.createPaint()
      ..color = color
      ..style = PaintStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = strokeLineCap
      ..strokeJoin = strokeLineJoin
      ..isAntialias = true;
  }
}

/// SVG Group element
class SvgGroup extends SvgElement {
  @override
  void render(SvgRenderContext ctx, SkiaCanvas canvas) {
    if (!isVisible) return;
    
    canvas.save();
    
    // Apply transform if present
    if (transform != null) {
      _applyTransform(canvas, transform!);
    }
    
    // Render children
    for (final child in children) {
      child.render(ctx, canvas);
    }
    
    canvas.restore();
  }
  
  /// Apply a transform matrix to the canvas
  static void _applyTransform(SkiaCanvas canvas, SvgTransform transform) {
    final m = transform.matrix;
    // For 2D affine transform [a, b, c, d, e, f]:
    // We can decompose into scale, rotation, skew, and translation
    // For now, use a simpler approach: translate + scale + skew
    // This won't handle all cases perfectly but works for most SVG transforms
    
    // Apply translation
    canvas.translate(m[4], m[5]);
    
    // Apply the rest of the transform using scale and skew
    // TODO: Implement proper matrix concat when we have SKMatrix support
    if (m[0] != 1.0 || m[3] != 1.0) {
      canvas.scale(m[0], m[3]);
    }
    if (m[1] != 0.0 || m[2] != 0.0) {
      canvas.skew(m[2], m[1]);
    }
  }
}

/// SVG Path element
class SvgPath extends SvgElement {
  String? pathData;
  SkiaPath? _skPath;
  
  /// Sets the path data and parses it using the given context
  void setPathData(SvgRenderContext ctx, String data) {
    pathData = data;
    _skPath = ctx.createPath();
    _skPath?.parseSvgString(data);
  }
  
  @override
  void render(SvgRenderContext ctx, SkiaCanvas canvas) {
    if (!isVisible || _skPath == null) return;
    
    canvas.save();
    
    // Draw fill
    final fillPaint = createFillPaint(ctx);
    if (fillPaint != null) {
      canvas.drawPath(_skPath!, fillPaint);
      fillPaint.dispose();
    }
    
    // Draw stroke
    final strokePaint = createStrokePaint(ctx);
    if (strokePaint != null) {
      canvas.drawPath(_skPath!, strokePaint);
      strokePaint.dispose();
    }
    
    canvas.restore();
  }
  
  void dispose() {
    _skPath?.dispose();
  }
}

/// SVG Rectangle element
class SvgRect extends SvgElement {
  double x = 0;
  double y = 0;
  double width = 0;
  double height = 0;
  double rx = 0;
  double ry = 0;
  
  @override
  void render(SvgRenderContext ctx, SkiaCanvas canvas) {
    if (!isVisible || width <= 0 || height <= 0) return;
    
    canvas.save();
    
    final rect = SKRect.fromXYWH(x, y, width, height);
    
    // Draw fill
    final fillPaint = createFillPaint(ctx);
    if (fillPaint != null) {
      if (rx > 0 || ry > 0) {
        canvas.drawRoundRect(rect, rx, ry, fillPaint);
      } else {
        canvas.drawRect(rect, fillPaint);
      }
      fillPaint.dispose();
    }
    
    // Draw stroke
    final strokePaint = createStrokePaint(ctx);
    if (strokePaint != null) {
      if (rx > 0 || ry > 0) {
        canvas.drawRoundRect(rect, rx, ry, strokePaint);
      } else {
        canvas.drawRect(rect, strokePaint);
      }
      strokePaint.dispose();
    }
    
    canvas.restore();
  }
}

/// SVG Circle element
class SvgCircle extends SvgElement {
  double cx = 0;
  double cy = 0;
  double r = 0;
  
  @override
  void render(SvgRenderContext ctx, SkiaCanvas canvas) {
    if (!isVisible || r <= 0) return;
    
    canvas.save();
    
    // Draw fill
    final fillPaint = createFillPaint(ctx);
    if (fillPaint != null) {
      canvas.drawCircle(cx, cy, r, fillPaint);
      fillPaint.dispose();
    }
    
    // Draw stroke
    final strokePaint = createStrokePaint(ctx);
    if (strokePaint != null) {
      canvas.drawCircle(cx, cy, r, strokePaint);
      strokePaint.dispose();
    }
    
    canvas.restore();
  }
}

/// SVG Ellipse element
class SvgEllipse extends SvgElement {
  double cx = 0;
  double cy = 0;
  double rx = 0;
  double ry = 0;
  
  @override
  void render(SvgRenderContext ctx, SkiaCanvas canvas) {
    if (!isVisible || rx <= 0 || ry <= 0) return;
    
    canvas.save();
    
    final rect = SKRect.fromCenter(
      center: SKPoint(cx, cy),
      halfWidth: rx,
      halfHeight: ry,
    );
    
    // Draw fill
    final fillPaint = createFillPaint(ctx);
    if (fillPaint != null) {
      canvas.drawOval(rect, fillPaint);
      fillPaint.dispose();
    }
    
    // Draw stroke
    final strokePaint = createStrokePaint(ctx);
    if (strokePaint != null) {
      canvas.drawOval(rect, strokePaint);
      strokePaint.dispose();
    }
    
    canvas.restore();
  }
}

/// SVG Line element
class SvgLine extends SvgElement {
  double x1 = 0;
  double y1 = 0;
  double x2 = 0;
  double y2 = 0;
  
  @override
  void render(SvgRenderContext ctx, SkiaCanvas canvas) {
    if (!isVisible) return;
    
    canvas.save();
    
    final strokePaint = createStrokePaint(ctx);
    if (strokePaint != null) {
      canvas.drawLine(x1, y1, x2, y2, strokePaint);
      strokePaint.dispose();
    }
    
    canvas.restore();
  }
}

/// SVG Polyline element
class SvgPolyline extends SvgElement {
  List<SKPoint> points = [];
  SkiaPath? _skPath;
  
  void setPoints(SvgRenderContext ctx, List<SKPoint> pts) {
    points = pts;
    _buildPath(ctx);
  }
  
  void _buildPath(SvgRenderContext ctx) {
    _skPath?.dispose();
    if (points.isEmpty) return;
    
    _skPath = ctx.createPath();
    _skPath!.moveTo(points[0].x, points[0].y);
    for (int i = 1; i < points.length; i++) {
      _skPath!.lineTo(points[i].x, points[i].y);
    }
  }
  
  @override
  void render(SvgRenderContext ctx, SkiaCanvas canvas) {
    if (!isVisible || _skPath == null) return;
    
    canvas.save();
    
    // Draw fill
    final fillPaint = createFillPaint(ctx);
    if (fillPaint != null) {
      canvas.drawPath(_skPath!, fillPaint);
      fillPaint.dispose();
    }
    
    // Draw stroke
    final strokePaint = createStrokePaint(ctx);
    if (strokePaint != null) {
      canvas.drawPath(_skPath!, strokePaint);
      strokePaint.dispose();
    }
    
    canvas.restore();
  }
  
  void dispose() {
    _skPath?.dispose();
  }
}

/// SVG Polygon element (closed polyline)
class SvgPolygon extends SvgElement {
  List<SKPoint> points = [];
  SkiaPath? _skPath;
  
  void setPoints(SvgRenderContext ctx, List<SKPoint> pts) {
    points = pts;
    _buildPath(ctx);
  }
  
  void _buildPath(SvgRenderContext ctx) {
    _skPath?.dispose();
    if (points.isEmpty) return;
    
    _skPath = ctx.createPath();
    _skPath!.moveTo(points[0].x, points[0].y);
    for (int i = 1; i < points.length; i++) {
      _skPath!.lineTo(points[i].x, points[i].y);
    }
    _skPath!.close();
  }
  
  @override
  void render(SvgRenderContext ctx, SkiaCanvas canvas) {
    if (!isVisible || _skPath == null) return;
    
    canvas.save();
    
    // Draw fill
    final fillPaint = createFillPaint(ctx);
    if (fillPaint != null) {
      canvas.drawPath(_skPath!, fillPaint);
      fillPaint.dispose();
    }
    
    // Draw stroke
    final strokePaint = createStrokePaint(ctx);
    if (strokePaint != null) {
      canvas.drawPath(_skPath!, strokePaint);
      strokePaint.dispose();
    }
    
    canvas.restore();
  }
  
  void dispose() {
    _skPath?.dispose();
  }
}

/// SVG Text element
class SvgText extends SvgElement {
  double x = 0;
  double y = 0;
  String text = '';
  String? fontFamily;
  double fontSize = 16.0;
  String fontWeight = 'normal';
  String fontStyle = 'normal';
  String textAnchor = 'start'; // start, middle, end
  
  @override
  void _applyResolvedStyles() {
    super._applyResolvedStyles();
    
    // Parse font properties from style
    final fontFamilyStr = styleManager.getProperty('font-family');
    if (fontFamilyStr != null) {
      fontFamily = fontFamilyStr.replaceAll('"', '').replaceAll("'", '');
    }
    
    final fontSizeStr = styleManager.getProperty('font-size');
    if (fontSizeStr != null) {
      fontSize = _parseFontSize(fontSizeStr);
    }
    
    final fontWeightStr = styleManager.getProperty('font-weight');
    if (fontWeightStr != null) {
      fontWeight = fontWeightStr;
    }
    
    final fontStyleStr = styleManager.getProperty('font-style');
    if (fontStyleStr != null) {
      fontStyle = fontStyleStr;
    }
    
    final textAnchorStr = styleManager.getProperty('text-anchor');
    if (textAnchorStr != null) {
      textAnchor = textAnchorStr;
    }
  }
  
  double _parseFontSize(String value) {
    // Remove units and parse
    final cleaned = value.replaceAll(RegExp(r'[a-z]+$'), '');
    return double.tryParse(cleaned) ?? 16.0;
  }
  
  @override
  void render(SvgRenderContext ctx, SkiaCanvas canvas) {
    if (!isVisible || text.isEmpty) return;
    
    canvas.save();
    
    // For now, use simple text rendering with a default font
    // TODO: Load custom typefaces based on fontFamily
    final fillPaint = createFillPaint(ctx);
    if (fillPaint != null) {
      // Create a default font with the specified size
      final font = ctx.createFont(size: fontSize);
      if (font != null) {
        canvas.drawSimpleText(text, x, y, font, fillPaint);
        font.dispose();
      }
      fillPaint.dispose();
    }
    
    canvas.restore();
  }
}
