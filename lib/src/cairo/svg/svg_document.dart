/// SVG Document parser and renderer for Cairo
/// 
/// This module provides the main entry point for parsing and rendering
/// SVG documents using Cairo.

import 'package:xml/xml.dart';

import '../cairo_api.dart';
import '../cairo_types.dart';
import 'svg_css.dart';
import 'svg_element.dart';

/// Represents a parsed SVG document that can be rendered
class CairoSvgDocument {
  CairoSvgElement? root;
  double width = 0;
  double height = 0;
  CairoSvgViewBox? viewBox;
  final List<CairoSvgCssStylesheet> stylesheets = [];
  final Map<String, CairoSvgElement> _defs = {};
  
  CairoSvgDocument();
  
  /// Loads an SVG from XML string
  static CairoSvgDocument? fromString(String svgString) {
    try {
      final xmlDoc = XmlDocument.parse(svgString);
      final svgElement = xmlDoc.rootElement;
      
      if (svgElement.name.local != 'svg') {
        return null;
      }
      
      final doc = CairoSvgDocument();
      doc._parseRootAttributes(svgElement);
      doc._parseStylesheets(svgElement);
      doc._parseDefs(svgElement);
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
  
  void _parseStylesheets(XmlElement element) {
    // Find all <style> elements
    for (final child in element.childElements) {
      if (child.name.local == 'style') {
        final cssText = child.innerText;
        if (cssText.isNotEmpty) {
          final stylesheet = CairoSvgCssStylesheet.parse(cssText);
          if (stylesheet != null) {
            stylesheets.add(stylesheet);
          }
        }
      }
      // Recursively check nested elements
      _parseStylesheets(child);
    }
  }
  
  void _parseDefs(XmlElement element) {
    // Find all <defs> elements and their children
    for (final child in element.childElements) {
      if (child.name.local == 'defs') {
        for (final defChild in child.childElements) {
          final id = defChild.getAttribute('id');
          if (id != null) {
            final parsed = _parseElement(defChild);
            _defs[id] = parsed;
          }
        }
      }
      // Recursively check nested elements
      _parseDefs(child);
    }
  }
  
  void _reapplyStyles(CairoSvgElement element) {
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
        viewBox = CairoSvgViewBox(x, y, w, h);
        
        // If width/height not specified, use viewBox dimensions
        if (width == 0) width = w;
        if (height == 0) height = h;
      }
    }
    
    // Default dimensions if not specified
    if (width == 0) width = 300;
    if (height == 0) height = 150;
  }
  
  double _parseLength(String value) {
    // Remove units (px, pt, em, etc) and parse
    final cleaned = value.replaceAll(RegExp(r'[a-z%]+$', caseSensitive: false), '');
    return double.tryParse(cleaned) ?? 0;
  }
  
  List<Point> _parsePoints(String pointsStr) {
    final points = <Point>[];
    
    // Parse space/comma separated coordinate pairs
    final cleaned = pointsStr.replaceAll(',', ' ').trim();
    final coords = cleaned.split(RegExp(r'\s+'));
    
    for (int i = 0; i < coords.length - 1; i += 2) {
      final x = double.tryParse(coords[i]);
      final y = double.tryParse(coords[i + 1]);
      if (x != null && y != null) {
        points.add(Point(x, y));
      }
    }
    
    return points;
  }
  
  CairoSvgElement _parseElement(XmlElement xml) {
    final attrs = <String, String>{};
    for (final attr in xml.attributes) {
      attrs[attr.name.local] = attr.value;
    }
    
    final elementName = xml.name.local;
    CairoSvgElement element;
    
    switch (elementName) {
      case 'svg':
      case 'g':
        element = CairoSvgGroup();
        break;
      case 'path':
        element = CairoSvgPathElement();
        final d = xml.getAttribute('d');
        if (d != null) {
          (element as CairoSvgPathElement).setPathData(d);
        }
        break;
      case 'rect':
        element = CairoSvgRect()
          ..x = double.tryParse(xml.getAttribute('x') ?? '0') ?? 0
          ..y = double.tryParse(xml.getAttribute('y') ?? '0') ?? 0
          ..width = double.tryParse(xml.getAttribute('width') ?? '0') ?? 0
          ..height = double.tryParse(xml.getAttribute('height') ?? '0') ?? 0
          ..rx = double.tryParse(xml.getAttribute('rx') ?? '0') ?? 0
          ..ry = double.tryParse(xml.getAttribute('ry') ?? '0') ?? 0;
        break;
      case 'circle':
        element = CairoSvgCircle()
          ..cx = double.tryParse(xml.getAttribute('cx') ?? '0') ?? 0
          ..cy = double.tryParse(xml.getAttribute('cy') ?? '0') ?? 0
          ..r = double.tryParse(xml.getAttribute('r') ?? '0') ?? 0;
        break;
      case 'ellipse':
        element = CairoSvgEllipse()
          ..cx = double.tryParse(xml.getAttribute('cx') ?? '0') ?? 0
          ..cy = double.tryParse(xml.getAttribute('cy') ?? '0') ?? 0
          ..rx = double.tryParse(xml.getAttribute('rx') ?? '0') ?? 0
          ..ry = double.tryParse(xml.getAttribute('ry') ?? '0') ?? 0;
        break;
      case 'line':
        element = CairoSvgLine()
          ..x1 = double.tryParse(xml.getAttribute('x1') ?? '0') ?? 0
          ..y1 = double.tryParse(xml.getAttribute('y1') ?? '0') ?? 0
          ..x2 = double.tryParse(xml.getAttribute('x2') ?? '0') ?? 0
          ..y2 = double.tryParse(xml.getAttribute('y2') ?? '0') ?? 0;
        break;
      case 'polyline':
        element = CairoSvgPolyline();
        final pointsStr = xml.getAttribute('points');
        if (pointsStr != null) {
          (element as CairoSvgPolyline).setPoints(_parsePoints(pointsStr));
        }
        break;
      case 'polygon':
        element = CairoSvgPolygon();
        final pointsStr = xml.getAttribute('points');
        if (pointsStr != null) {
          (element as CairoSvgPolygon).setPoints(_parsePoints(pointsStr));
        }
        break;
      case 'text':
        element = CairoSvgText()
          ..x = double.tryParse(xml.getAttribute('x') ?? '0') ?? 0
          ..y = double.tryParse(xml.getAttribute('y') ?? '0') ?? 0
          ..text = xml.innerText
          ..fontFamily = xml.getAttribute('font-family')
          ..fontSize = double.tryParse(xml.getAttribute('font-size') ?? '16') ?? 16.0
          ..fontWeight = xml.getAttribute('font-weight') ?? 'normal'
          ..fontStyle = xml.getAttribute('font-style') ?? 'normal'
          ..textAnchor = xml.getAttribute('text-anchor') ?? 'start';
        break;
      case 'image':
        element = CairoSvgImage()
          ..x = double.tryParse(xml.getAttribute('x') ?? '0') ?? 0
          ..y = double.tryParse(xml.getAttribute('y') ?? '0') ?? 0
          ..width = double.tryParse(xml.getAttribute('width') ?? '0') ?? 0
          ..height = double.tryParse(xml.getAttribute('height') ?? '0') ?? 0
          ..href = xml.getAttribute('href') ?? xml.getAttribute('xlink:href');
        break;
      case 'use':
        final use = CairoSvgUse()
          ..x = double.tryParse(xml.getAttribute('x') ?? '0') ?? 0
          ..y = double.tryParse(xml.getAttribute('y') ?? '0') ?? 0
          ..width = double.tryParse(xml.getAttribute('width') ?? '')
          ..height = double.tryParse(xml.getAttribute('height') ?? '');
        final href = xml.getAttribute('href') ?? xml.getAttribute('xlink:href');
        if (href != null && href.startsWith('#')) {
          final refId = href.substring(1);
          use.href = refId;
          use.referencedElement = _defs[refId];
        }
        element = use;
        break;
      default:
        // Unknown element - treat as group
        element = CairoSvgGroup();
    }
    
    element.elementType = elementName;
    element.parseCommonAttributes(attrs);
    
    // Parse children (except for text which uses innerText)
    if (elementName != 'text') {
      for (final child in xml.childElements) {
        // Skip defs and style elements
        if (child.name.local == 'defs' || child.name.local == 'style') {
          continue;
        }
        final childElement = _parseElement(child);
        element.children.add(childElement);
      }
    }
    
    return element;
  }
  
  /// Render the SVG to a Cairo canvas
  /// 
  /// If [scaleToFit] is true, the SVG will be scaled to fit the canvas
  void render(CairoCanvasImpl canvas, {bool scaleToFit = false}) {
    if (root == null) return;
    
    canvas.save();
    
    // Apply viewBox transformation
    if (viewBox != null && scaleToFit) {
      final scaleX = canvas.width / viewBox!.width;
      final scaleY = canvas.height / viewBox!.height;
      final scale = scaleX < scaleY ? scaleX : scaleY;
      
      canvas.translate(-viewBox!.x * scale, -viewBox!.y * scale);
      canvas.scale(scale, scale);
    } else if (viewBox != null) {
      // Just apply viewBox offset
      final scaleX = width / viewBox!.width;
      final scaleY = height / viewBox!.height;
      
      canvas.translate(-viewBox!.x * scaleX, -viewBox!.y * scaleY);
      canvas.scale(scaleX, scaleY);
    }
    
    root!.render(canvas);
    
    canvas.restore();
  }
  
  /// Create a canvas sized for this SVG and render to it
  CairoCanvasImpl renderToCanvas(Cairo cairo, {CairoColor? background}) {
    final w = width.ceil();
    final h = height.ceil();
    final canvas = cairo.createCanvas(w > 0 ? w : 300, h > 0 ? h : 150);
    
    if (background != null) {
      canvas.clear(background);
    }
    
    render(canvas);
    
    return canvas;
  }
  
  /// Render to PNG file
  bool renderToPng(Cairo cairo, String filename, {CairoColor? background}) {
    final canvas = renderToCanvas(cairo, background: background);
    final result = canvas.saveToPng(filename);
    canvas.dispose();
    return result;
  }
}

/// Represents an SVG viewBox
class CairoSvgViewBox {
  final double x;
  final double y;
  final double width;
  final double height;
  
  const CairoSvgViewBox(this.x, this.y, this.width, this.height);
  
  @override
  String toString() => 'CairoSvgViewBox($x, $y, $width, $height)';
}
