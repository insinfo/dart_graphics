import 'package:xml/xml.dart';

import '../skia_api.dart';
import '../sk_geometry.dart';
import 'svg_css.dart';
import 'svg_element.dart';

/// SVG Document that can be loaded and rendered
class SvgDocument {
  SvgElement? root;
  double width = 0;
  double height = 0;
  SKRect? viewBox;
  final List<CssStylesheet> stylesheets = [];
  
  /// The Skia context used for parsing (needed for path/polyline/polygon)
  SvgRenderContext? _parseContext;
  
  SvgDocument();
  
  /// Loads an SVG from XML string
  /// 
  /// Note: If the SVG contains path, polyline, or polygon elements,
  /// you must call [prepareForRendering] with a Skia instance before rendering.
  static SvgDocument? fromString(String svgString) {
    try {
      final xmlDoc = XmlDocument.parse(svgString);
      final svgElement = xmlDoc.rootElement;
      
      if (svgElement.name.local != 'svg') {
        return null;
      }
      
      final doc = SvgDocument();
      doc._parseRootAttributes(svgElement);
      doc._parseStylesheets(svgElement);
      doc.root = doc._parseElement(svgElement);
      
      // Apply stylesheets after parsing elements
      if (doc.root != null) {
        for (final stylesheet in doc.stylesheets) {
          stylesheet.applyToTree(doc.root!);
        }
        // Re-apply resolved styles after CSS
        doc._reapplyStyles(doc.root!);
      }
      
      return doc;
    } catch (e) {
      print('Error parsing SVG: $e');
      return null;
    }
  }
  
  /// Prepares the document for rendering by initializing paths and other
  /// Skia-dependent objects.
  /// 
  /// This must be called before [render] or [renderToSurface] if the SVG
  /// contains path, polyline, or polygon elements.
  void prepareForRendering(Skia skia) {
    _parseContext = SvgRenderContext(skia);
    if (root != null) {
      _prepareElement(root!);
    }
  }
  
  void _prepareElement(SvgElement element) {
    final ctx = _parseContext!;
    
    // Initialize paths for elements that need them
    if (element is SvgPath && element.pathData != null) {
      element.setPathData(ctx, element.pathData!);
    } else if (element is SvgPolyline && element.points.isNotEmpty) {
      element.setPoints(ctx, element.points);
    } else if (element is SvgPolygon && element.points.isNotEmpty) {
      element.setPoints(ctx, element.points);
    }
    
    // Recurse to children
    for (final child in element.children) {
      _prepareElement(child);
    }
  }
  
  void _parseStylesheets(XmlElement element) {
    // Find all <style> elements
    for (final child in element.childElements) {
      if (child.name.local == 'style') {
        final cssText = child.innerText;
        if (cssText.isNotEmpty) {
          final stylesheet = CssStylesheet.parse(cssText);
          if (stylesheet != null) {
            stylesheets.add(stylesheet);
          }
        }
      }
    }
  }
  
  void _reapplyStyles(SvgElement element) {
    element.parseCommonAttributes(element.attributes);
    for (final child in element.children) {
      _reapplyStyles(child);
    }
  }
  
  void _parseRootAttributes(XmlElement element) {
    // Parse width
    final widthStr = element.getAttribute('width');
    if (widthStr != null) {
      width = _parseLength(widthStr);
    }
    
    // Parse height
    final heightStr = element.getAttribute('height');
    if (heightStr != null) {
      height = _parseLength(heightStr);
    }
    
    // Parse viewBox
    final viewBoxStr = element.getAttribute('viewBox');
    if (viewBoxStr != null) {
      final parts = viewBoxStr.split(RegExp(r'[\s,]+'));
      if (parts.length == 4) {
        final x = double.tryParse(parts[0]) ?? 0;
        final y = double.tryParse(parts[1]) ?? 0;
        final w = double.tryParse(parts[2]) ?? 0;
        final h = double.tryParse(parts[3]) ?? 0;
        viewBox = SKRect.fromXYWH(x, y, w, h);
        
        // If width/height not specified, use viewBox dimensions
        if (width == 0) width = w;
        if (height == 0) height = h;
      }
    }
  }
  
  double _parseLength(String value) {
    // Remove units (px, pt, etc) and parse
    final cleaned = value.replaceAll(RegExp(r'[a-z]+$'), '');
    return double.tryParse(cleaned) ?? 0;
  }

  List<SKPoint> _parsePoints(String pointsStr) {
    final points = <SKPoint>[];
    
    // Parse space/comma separated coordinate pairs
    final cleaned = pointsStr.replaceAll(',', ' ').trim();
    final coords = cleaned.split(RegExp(r'\s+'));
    
    for (int i = 0; i < coords.length - 1; i += 2) {
      final x = double.tryParse(coords[i]);
      final y = double.tryParse(coords[i + 1]);
      if (x != null && y != null) {
        points.add(SKPoint(x, y));
      }
    }
    
    return points;
  }
  
  SvgElement _parseElement(XmlElement xml) {
    final attrs = <String, String>{};
    for (final attr in xml.attributes) {
      attrs[attr.name.local] = attr.value;
    }
    
    final elementName = xml.name.local;
    SvgElement element;
    
    switch (elementName) {
      case 'svg':
      case 'g':
        element = SvgGroup();
        break;
      case 'path':
        element = SvgPath();
        final d = xml.getAttribute('d');
        if (d != null) {
          // Store path data for later initialization
          (element as SvgPath).pathData = d;
        }
        break;
      case 'rect':
        element = SvgRect()
          ..x = double.tryParse(xml.getAttribute('x') ?? '0') ?? 0
          ..y = double.tryParse(xml.getAttribute('y') ?? '0') ?? 0
          ..width = double.tryParse(xml.getAttribute('width') ?? '0') ?? 0
          ..height = double.tryParse(xml.getAttribute('height') ?? '0') ?? 0
          ..rx = double.tryParse(xml.getAttribute('rx') ?? '0') ?? 0
          ..ry = double.tryParse(xml.getAttribute('ry') ?? '0') ?? 0;
        break;
      case 'circle':
        element = SvgCircle()
          ..cx = double.tryParse(xml.getAttribute('cx') ?? '0') ?? 0
          ..cy = double.tryParse(xml.getAttribute('cy') ?? '0') ?? 0
          ..r = double.tryParse(xml.getAttribute('r') ?? '0') ?? 0;
        break;
      case 'ellipse':
        element = SvgEllipse()
          ..cx = double.tryParse(xml.getAttribute('cx') ?? '0') ?? 0
          ..cy = double.tryParse(xml.getAttribute('cy') ?? '0') ?? 0
          ..rx = double.tryParse(xml.getAttribute('rx') ?? '0') ?? 0
          ..ry = double.tryParse(xml.getAttribute('ry') ?? '0') ?? 0;
        break;
      case 'line':
        element = SvgLine()
          ..x1 = double.tryParse(xml.getAttribute('x1') ?? '0') ?? 0
          ..y1 = double.tryParse(xml.getAttribute('y1') ?? '0') ?? 0
          ..x2 = double.tryParse(xml.getAttribute('x2') ?? '0') ?? 0
          ..y2 = double.tryParse(xml.getAttribute('y2') ?? '0') ?? 0;
        break;
      case 'polyline':
        element = SvgPolyline();
        final pointsStr = xml.getAttribute('points');
        if (pointsStr != null) {
          // Store points for later initialization
          (element as SvgPolyline).points = _parsePoints(pointsStr);
        }
        break;
      case 'polygon':
        element = SvgPolygon();
        final pointsStr = xml.getAttribute('points');
        if (pointsStr != null) {
          // Store points for later initialization
          (element as SvgPolygon).points = _parsePoints(pointsStr);
        }
        break;
      case 'text':
        element = SvgText()
          ..x = double.tryParse(xml.getAttribute('x') ?? '0') ?? 0
          ..y = double.tryParse(xml.getAttribute('y') ?? '0') ?? 0
          ..text = xml.innerText
          ..fontFamily = xml.getAttribute('font-family')
          ..fontSize = double.tryParse(xml.getAttribute('font-size') ?? '16') ?? 16.0
          ..fontWeight = xml.getAttribute('font-weight') ?? 'normal'
          ..fontStyle = xml.getAttribute('font-style') ?? 'normal'
          ..textAnchor = xml.getAttribute('text-anchor') ?? 'start';
        break;
      case 'style':
        // Skip style elements - they're processed separately
        element = SvgGroup();
        break;
      default:
        // Unknown element - create group to hold children
        element = SvgGroup();
    }
    
    // Set element type for CSS selectors
    element.elementType = elementName;
    
    element.parseCommonAttributes(attrs);
    
    // Parse children
    for (final child in xml.childElements) {
      element.children.add(_parseElement(child));
    }
    
    return element;
  }
  
  /// Renders the SVG to a canvas
  /// 
  /// You must call [prepareForRendering] first if the SVG contains
  /// path, polyline, or polygon elements.
  void render(Skia skia, SkiaCanvas canvas, {double? width, double? height}) {
    if (root == null) return;
    
    // Auto-prepare if not already done
    if (_parseContext == null) {
      prepareForRendering(skia);
    }
    
    final ctx = _parseContext!;
    
    canvas.save();
    
    // Apply scaling if target size is specified
    if (width != null && height != null && this.width > 0 && this.height > 0) {
      final scaleX = width / this.width;
      final scaleY = height / this.height;
      canvas.scale(scaleX, scaleY);
    }
    
    root!.render(ctx, canvas);
    
    canvas.restore();
  }
  
  /// Renders the SVG to a new surface with the specified dimensions
  SkiaSurface? renderToSurface(Skia skia, {double? width, double? height}) {
    final w = (width ?? this.width).round();
    final h = (height ?? this.height).round();
    
    if (w <= 0 || h <= 0) return null;
    
    final surface = skia.createSurface(w, h);
    if (surface == null) return null;
    
    final canvas = surface.canvas;
    render(skia, canvas, width: w.toDouble(), height: h.toDouble());
    
    return surface;
  }
}
