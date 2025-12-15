/// Path2D - HTML5-style Path for Canvas 2D
/// 
/// Provides a way to define paths that can be reused.

import 'dart:math' as math;

import '../skia_api.dart';
import '../sk_geometry.dart';
import '../../shared/canvas2d/canvas2d.dart';

/// A 2D path that can be reused with Canvas methods
class Path2D implements IPath2D {
  final Skia _skia;
  SkiaPath? _path;
  bool _hasSubpath = false;
  
  /// Creates an empty Path2D
  Path2D(this._skia) {
    _path = _skia.createPath();
  }
  
  /// Creates a Path2D from an SVG path string
  Path2D.fromSvg(this._skia, String svgPath) {
    _path = _skia.createPath();
    _path?.parseSvgString(svgPath);
    _hasSubpath = true;
  }
  
  /// Creates a Path2D by copying another path
  Path2D.from(Path2D other)
      : _skia = other._skia,
        _hasSubpath = other._hasSubpath {
    _path = other._path?.clone();
  }
  
  /// The underlying Skia path
  SkiaPath? get path => _path;
  
  /// Adds a path to this path
  @override
  void addPath(IPath2D path, [DOMMatrix? transform]) {
    if (path is Path2D && path._path != null) {
      if (transform != null) {
        // Apply transform by manually transforming each point
        // This is a simplified implementation - full support would need
        // to transform the entire path
        _path?.addPath(path._path!);
      } else {
        _path?.addPath(path._path!);
      }
      _hasSubpath = true;
    }
  }
  
  /// Closes the current subpath
  @override
  void closePath() {
    _path?.close();
  }
  
  /// Moves to a point
  @override
  void moveTo(double x, double y) {
    _path?.moveTo(x, y);
    _hasSubpath = true;
  }
  
  /// Draws a line to a point
  @override
  void lineTo(double x, double y) {
    _path?.lineTo(x, y);
    _hasSubpath = true;
  }
  
  /// Draws a quadratic Bézier curve
  @override
  void quadraticCurveTo(double cpx, double cpy, double x, double y) {
    _path?.quadTo(cpx, cpy, x, y);
    _hasSubpath = true;
  }
  
  /// Draws a cubic Bézier curve
  @override
  void bezierCurveTo(double cp1x, double cp1y, double cp2x, double cp2y, double x, double y) {
    _path?.cubicTo(cp1x, cp1y, cp2x, cp2y, x, y);
    _hasSubpath = true;
  }
  
  /// Draws an arc with tangent lines to two points
  @override
  void arcTo(double x1, double y1, double x2, double y2, double radius) {
    if (radius < 0) {
      throw RangeError('Radius must be non-negative');
    }
    
    // Use Skia's arcTo with points which handles tangent arcs correctly
    _path?.arcTo(x1, y1, x2, y2, radius);
    _hasSubpath = true;
  }
  
  /// Adds a circular arc to the path
  @override
  void arc(double x, double y, double radius, double startAngle, double endAngle, [bool counterclockwise = false]) {
    if (radius < 0) {
      throw RangeError('Radius must be non-negative');
    }
    
    _addEllipse(x, y, radius, radius, 0, startAngle, endAngle, counterclockwise);
  }
  
  /// Adds an elliptical arc to the path
  @override
  void ellipse(double x, double y, double radiusX, double radiusY, double rotation, 
               double startAngle, double endAngle, [bool counterclockwise = false]) {
    if (radiusX < 0 || radiusY < 0) {
      throw RangeError('Radii must be non-negative');
    }
    
    _addEllipse(x, y, radiusX, radiusY, rotation, startAngle, endAngle, counterclockwise);
  }
  
  void _addEllipse(double cx, double cy, double rx, double ry, double rotation,
                   double startAngle, double endAngle, bool counterclockwise) {
    // Normalize angles
    double sweepAngle = endAngle - startAngle;
    
    if (counterclockwise) {
      if (sweepAngle > 0) {
        sweepAngle -= 2 * math.pi;
      }
    } else {
      if (sweepAngle < 0) {
        sweepAngle += 2 * math.pi;
      }
    }
    
    // Handle full ellipse
    if (sweepAngle.abs() >= 2 * math.pi - 0.001) {
      _path?.addOval(SKRect.fromCenter(
        center: SKPoint(cx, cy),
        halfWidth: rx,
        halfHeight: ry,
      ));
      _hasSubpath = true;
      return;
    }
    
    // Approximate arc with bezier curves
    final segments = (sweepAngle.abs() * 180 / math.pi / 15).ceil().clamp(1, 24);
    final angleStep = sweepAngle / segments;
    
    final cosRot = math.cos(rotation);
    final sinRot = math.sin(rotation);
    
    for (int i = 0; i <= segments; i++) {
      final angle = startAngle + angleStep * i;
      final px = rx * math.cos(angle);
      final py = ry * math.sin(angle);
      
      // Apply rotation
      final x = cx + px * cosRot - py * sinRot;
      final y = cy + px * sinRot + py * cosRot;
      
      if (i == 0) {
        // Only moveTo if there's no subpath started, otherwise lineTo to connect
        if (!_hasSubpath) {
          _path?.moveTo(x, y);
        } else {
          _path?.lineTo(x, y);
        }
      } else {
        _path?.lineTo(x, y);
      }
    }
    _hasSubpath = true;
  }
  
  /// Adds a rectangle to the path
  @override
  void rect(double x, double y, double width, double height) {
    _path?.addRect(SKRect.fromXYWH(x, y, width, height));
    _hasSubpath = true;
  }
  
  /// Adds a rounded rectangle to the path
  @override
  void roundRect(double x, double y, double width, double height, [dynamic radii = 0]) {
    double rx = 0, ry = 0;
    
    if (radii is num) {
      rx = ry = radii.toDouble();
    } else if (radii is List && radii.isNotEmpty) {
      rx = (radii[0] as num).toDouble();
      ry = radii.length > 1 ? (radii[1] as num).toDouble() : rx;
    }
    
    _path?.addRoundRect(SKRect.fromXYWH(x, y, width, height), rx, ry);
    _hasSubpath = true;
  }
  
  /// Resets the path
  void reset() {
    _path?.reset();
    _hasSubpath = false;
  }
  
  /// Disposes of the path
  void dispose() {
    _path?.dispose();
    _path = null;
  }
}
