/// SVG Element classes for Cairo rendering
/// 
/// This module defines the SVG element hierarchy and rendering logic
/// for each element type.

import 'dart:math' as math;
import '../cairo_api.dart';
import '../cairo_types.dart';
import 'svg_color.dart';
import 'svg_path.dart';
import 'svg_style.dart';
import 'svg_transform.dart';

/// Line cap styles
enum CairoSvgStrokeCap {
  butt,
  round,
  square,
}

/// Line join styles
enum CairoSvgStrokeJoin {
  miter,
  round,
  bevel,
}

/// Base class for SVG elements that can be rendered
abstract class CairoSvgElement {
  String? id;
  String? className;
  String? elementType; // Element type for CSS selectors (rect, circle, etc)
  Map<String, String> attributes = {};
  List<CairoSvgElement> children = [];
  
  /// Style manager for handling CSS and presentation attributes
  final CairoSvgStyleManager styleManager = CairoSvgStyleManager();
  
  /// Fill paint (color)
  CairoColor? fill;
  double fillOpacity = 1.0;
  
  /// Stroke paint
  CairoColor? stroke;
  double strokeWidth = 1.0;
  double strokeOpacity = 1.0;
  CairoSvgStrokeCap strokeLineCap = CairoSvgStrokeCap.butt;
  CairoSvgStrokeJoin strokeLineJoin = CairoSvgStrokeJoin.miter;
  double strokeMiterLimit = 4.0;
  List<double>? strokeDashArray;
  double strokeDashOffset = 0.0;
  
  /// Opacity
  double opacity = 1.0;
  
  /// Transform
  CairoSvgTransform? transform;
  
  /// Whether this element should be rendered
  bool isVisible = true;
  
  CairoSvgElement();
  
  /// Renders this element to a Cairo canvas
  void render(CairoCanvasImpl canvas);
  
  /// Parses common attributes including CSS styles
  void parseCommonAttributes(Map<String, String> attrs) {
    id = attrs['id'];
    className = attrs['class'];
    attributes = Map.from(attrs);
    
    // First, apply presentation attributes (lowest priority)
    for (final entry in attrs.entries) {
      if (CairoSvgPresentationAttributes.isPresentation(entry.key)) {
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
      fill = CairoSvgColor.parse(fillStr);
    } else if (fillStr == 'none') {
      fill = null;
    } else {
      fill = CairoColor.black; // Default fill
    }
    
    // Parse stroke
    final strokeStr = styleManager.getProperty('stroke');
    if (strokeStr != null && strokeStr != 'none') {
      stroke = CairoSvgColor.parse(strokeStr);
    }
    
    // Parse stroke-width
    final strokeWidthStr = styleManager.getProperty('stroke-width');
    if (strokeWidthStr != null) {
      strokeWidth = _parseLength(strokeWidthStr);
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
          strokeLineCap = CairoSvgStrokeCap.round;
        case 'square':
          strokeLineCap = CairoSvgStrokeCap.square;
        default:
          strokeLineCap = CairoSvgStrokeCap.butt;
      }
    }
    
    // Parse stroke-linejoin
    final linejoinStr = styleManager.getProperty('stroke-linejoin');
    if (linejoinStr != null) {
      switch (linejoinStr) {
        case 'round':
          strokeLineJoin = CairoSvgStrokeJoin.round;
        case 'bevel':
          strokeLineJoin = CairoSvgStrokeJoin.bevel;
        default:
          strokeLineJoin = CairoSvgStrokeJoin.miter;
      }
    }
    
    // Parse stroke-miterlimit
    final miterlimitStr = styleManager.getProperty('stroke-miterlimit');
    if (miterlimitStr != null) {
      strokeMiterLimit = double.tryParse(miterlimitStr) ?? 4.0;
    }
    
    // Parse stroke-dasharray
    final dasharrayStr = styleManager.getProperty('stroke-dasharray');
    if (dasharrayStr != null && dasharrayStr != 'none') {
      final nums = RegExp(r'-?\d*\.?\d+').allMatches(dasharrayStr);
      strokeDashArray = nums.map((m) => double.parse(m.group(0)!)).toList();
    }
    
    // Parse stroke-dashoffset
    final dashoffsetStr = styleManager.getProperty('stroke-dashoffset');
    if (dashoffsetStr != null) {
      strokeDashOffset = _parseLength(dashoffsetStr);
    }
    
    // Parse visibility/display
    final displayStr = styleManager.getProperty('display');
    final visibilityStr = styleManager.getProperty('visibility');
    isVisible = displayStr != 'none' && visibilityStr != 'hidden';
    
    // Parse transform
    final transformStr = styleManager.getProperty('transform');
    if (transformStr != null) {
      transform = CairoSvgTransform.parse(transformStr);
    }
  }
  
  /// Parse a length value (removes units)
  double _parseLength(String value) {
    final cleaned = value.replaceAll(RegExp(r'[a-z]+$'), '');
    return double.tryParse(cleaned) ?? 0;
  }
  
  /// Apply fill to canvas if set
  void applyFill(CairoCanvasImpl canvas) {
    if (fill == null) return;
    
    final effectiveOpacity = opacity * fillOpacity;
    final color = fill!.withAlpha(effectiveOpacity);
    canvas.setColor(color);
  }
  
  /// Apply stroke style to canvas if set
  void applyStroke(CairoCanvasImpl canvas) {
    if (stroke == null || strokeWidth <= 0) return;
    
    final effectiveOpacity = opacity * strokeOpacity;
    final color = stroke!.withAlpha(effectiveOpacity);
    canvas.setColor(color);
    canvas.setLineWidth(strokeWidth);
    
    // Set line cap
    final cap = switch (strokeLineCap) {
      CairoSvgStrokeCap.butt => LineCap.butt,
      CairoSvgStrokeCap.round => LineCap.round,
      CairoSvgStrokeCap.square => LineCap.square,
    };
    canvas.setLineCap(cap);
    
    // Set line join
    final join = switch (strokeLineJoin) {
      CairoSvgStrokeJoin.miter => LineJoin.miter,
      CairoSvgStrokeJoin.round => LineJoin.round,
      CairoSvgStrokeJoin.bevel => LineJoin.bevel,
    };
    canvas.setLineJoin(join);
    
    canvas.setMiterLimit(strokeMiterLimit);
    
    // Set dash pattern
    if (strokeDashArray != null && strokeDashArray!.isNotEmpty) {
      canvas.setDash(strokeDashArray!, strokeDashOffset);
    } else {
      canvas.clearDash();
    }
  }
  
  /// Apply transform to canvas if set
  void applyTransform(CairoCanvasImpl canvas) {
    if (transform == null) return;
    
    final m = transform!.matrix;
    // Apply translation
    canvas.translate(m[4], m[5]);
    
    // Apply the rest of the transform using scale and skew
    if (m[0] != 1.0 || m[3] != 1.0) {
      canvas.scale(m[0], m[3]);
    }
    // Note: skew is harder to apply in Cairo without a full matrix
    // For now, we handle the common cases
  }
}

/// SVG Group element
class CairoSvgGroup extends CairoSvgElement {
  @override
  void render(CairoCanvasImpl canvas) {
    if (!isVisible) return;
    
    canvas.save();
    
    // Apply transform if present
    applyTransform(canvas);
    
    // Render children
    for (final child in children) {
      child.render(canvas);
    }
    
    canvas.restore();
  }
}

/// SVG Path element
class CairoSvgPathElement extends CairoSvgElement {
  String? pathData;
  CairoSvgPath? _path;
  
  void setPathData(String data) {
    pathData = data;
    _path = CairoSvgPath.parse(data);
  }
  
  @override
  void render(CairoCanvasImpl canvas) {
    if (!isVisible || _path == null) return;
    
    canvas.save();
    applyTransform(canvas);
    
    canvas.newPath();
    _path!.render(canvas);
    
    // Fill
    if (fill != null) {
      applyFill(canvas);
      if (stroke != null) {
        canvas.fillPreserve();
      } else {
        canvas.fill();
      }
    }
    
    // Stroke
    if (stroke != null && strokeWidth > 0) {
      applyStroke(canvas);
      canvas.stroke();
    }
    
    canvas.restore();
  }
}

/// SVG Rectangle element
class CairoSvgRect extends CairoSvgElement {
  double x = 0;
  double y = 0;
  double width = 0;
  double height = 0;
  double rx = 0;
  double ry = 0;
  
  @override
  void render(CairoCanvasImpl canvas) {
    if (!isVisible || width <= 0 || height <= 0) return;
    
    canvas.save();
    applyTransform(canvas);
    
    canvas.newPath();
    if (rx > 0 || ry > 0) {
      final r = rx > 0 ? rx : ry;
      canvas.roundedRect(x, y, width, height, r);
    } else {
      canvas.rectangle(x, y, width, height);
    }
    
    // Fill
    if (fill != null) {
      applyFill(canvas);
      if (stroke != null) {
        canvas.fillPreserve();
      } else {
        canvas.fill();
      }
    }
    
    // Stroke
    if (stroke != null && strokeWidth > 0) {
      applyStroke(canvas);
      canvas.stroke();
    }
    
    canvas.restore();
  }
}

/// SVG Circle element
class CairoSvgCircle extends CairoSvgElement {
  double cx = 0;
  double cy = 0;
  double r = 0;
  
  @override
  void render(CairoCanvasImpl canvas) {
    if (!isVisible || r <= 0) return;
    
    canvas.save();
    applyTransform(canvas);
    
    canvas.newPath();
    canvas.arc(cx, cy, r, 0, 2 * math.pi);
    canvas.closePath();
    
    // Fill
    if (fill != null) {
      applyFill(canvas);
      if (stroke != null) {
        canvas.fillPreserve();
      } else {
        canvas.fill();
      }
    }
    
    // Stroke
    if (stroke != null && strokeWidth > 0) {
      applyStroke(canvas);
      canvas.stroke();
    }
    
    canvas.restore();
  }
}

/// SVG Ellipse element
class CairoSvgEllipse extends CairoSvgElement {
  double cx = 0;
  double cy = 0;
  double rx = 0;
  double ry = 0;
  
  @override
  void render(CairoCanvasImpl canvas) {
    if (!isVisible || rx <= 0 || ry <= 0) return;
    
    canvas.save();
    applyTransform(canvas);
    
    canvas.newPath();
    // Use scaling to draw ellipse
    canvas.save();
    canvas.translate(cx, cy);
    canvas.scale(rx, ry);
    canvas.arc(0, 0, 1, 0, 2 * math.pi);
    canvas.restore();
    canvas.closePath();
    
    // Fill
    if (fill != null) {
      applyFill(canvas);
      if (stroke != null) {
        canvas.fillPreserve();
      } else {
        canvas.fill();
      }
    }
    
    // Stroke
    if (stroke != null && strokeWidth > 0) {
      applyStroke(canvas);
      canvas.stroke();
    }
    
    canvas.restore();
  }
}

/// SVG Line element
class CairoSvgLine extends CairoSvgElement {
  double x1 = 0;
  double y1 = 0;
  double x2 = 0;
  double y2 = 0;
  
  @override
  void render(CairoCanvasImpl canvas) {
    if (!isVisible) return;
    
    canvas.save();
    applyTransform(canvas);
    
    // Lines have no fill, only stroke
    if (stroke != null && strokeWidth > 0) {
      canvas.newPath();
      canvas.moveTo(x1, y1);
      canvas.lineTo(x2, y2);
      applyStroke(canvas);
      canvas.stroke();
    }
    
    canvas.restore();
  }
}

/// SVG Polyline element
class CairoSvgPolyline extends CairoSvgElement {
  List<Point> points = [];
  
  void setPoints(List<Point> pts) {
    points = pts;
  }
  
  @override
  void render(CairoCanvasImpl canvas) {
    if (!isVisible || points.isEmpty) return;
    
    canvas.save();
    applyTransform(canvas);
    
    canvas.newPath();
    canvas.moveTo(points[0].x, points[0].y);
    for (int i = 1; i < points.length; i++) {
      canvas.lineTo(points[i].x, points[i].y);
    }
    
    // Fill (polyline can have fill)
    if (fill != null) {
      applyFill(canvas);
      if (stroke != null) {
        canvas.fillPreserve();
      } else {
        canvas.fill();
      }
    }
    
    // Stroke
    if (stroke != null && strokeWidth > 0) {
      applyStroke(canvas);
      canvas.stroke();
    }
    
    canvas.restore();
  }
}

/// SVG Polygon element (closed polyline)
class CairoSvgPolygon extends CairoSvgElement {
  List<Point> points = [];
  
  void setPoints(List<Point> pts) {
    points = pts;
  }
  
  @override
  void render(CairoCanvasImpl canvas) {
    if (!isVisible || points.isEmpty) return;
    
    canvas.save();
    applyTransform(canvas);
    
    canvas.newPath();
    canvas.moveTo(points[0].x, points[0].y);
    for (int i = 1; i < points.length; i++) {
      canvas.lineTo(points[i].x, points[i].y);
    }
    canvas.closePath();
    
    // Fill
    if (fill != null) {
      applyFill(canvas);
      if (stroke != null) {
        canvas.fillPreserve();
      } else {
        canvas.fill();
      }
    }
    
    // Stroke
    if (stroke != null && strokeWidth > 0) {
      applyStroke(canvas);
      canvas.stroke();
    }
    
    canvas.restore();
  }
}

/// SVG Text element
class CairoSvgText extends CairoSvgElement {
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
  void render(CairoCanvasImpl canvas) {
    if (!isVisible || text.isEmpty) return;
    
    canvas.save();
    applyTransform(canvas);
    
    // Set font
    final weight = fontWeight == 'bold' ? FontWeight.bold : FontWeight.normal;
    final slant = fontStyle == 'italic' ? FontSlant.italic : FontSlant.normal;
    
    canvas.selectFontFace(fontFamily ?? 'sans-serif', weight: weight, slant: slant);
    canvas.setFontSize(fontSize);
    
    // Render text with fill
    if (fill != null) {
      applyFill(canvas);
      canvas.moveTo(x, y);
      canvas.showText(text);
    }
    
    // Stroke text if specified
    if (stroke != null && strokeWidth > 0) {
      applyStroke(canvas);
      canvas.moveTo(x, y);
      canvas.textPath(text);
      canvas.stroke();
    }
    
    canvas.restore();
  }
}

/// SVG Image element (placeholder - full implementation would need image loading)
class CairoSvgImage extends CairoSvgElement {
  double x = 0;
  double y = 0;
  double width = 0;
  double height = 0;
  String? href;
  
  @override
  void render(CairoCanvasImpl canvas) {
    if (!isVisible || width <= 0 || height <= 0 || href == null) return;
    
    canvas.save();
    applyTransform(canvas);
    
    // Placeholder: draw a rectangle where the image would be
    canvas.newPath();
    canvas.rectangle(x, y, width, height);
    canvas.setSourceRgba(0.9, 0.9, 0.9, 1.0);
    canvas.fill();
    
    canvas.restore();
  }
}

/// SVG Use element (reference another element)
class CairoSvgUse extends CairoSvgElement {
  double x = 0;
  double y = 0;
  double? width;
  double? height;
  String? href;
  CairoSvgElement? referencedElement;
  
  @override
  void render(CairoCanvasImpl canvas) {
    if (!isVisible || referencedElement == null) return;
    
    canvas.save();
    canvas.translate(x, y);
    applyTransform(canvas);
    
    referencedElement!.render(canvas);
    
    canvas.restore();
  }
}
