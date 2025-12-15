/// HTML5 Path2D Interface
/// 
/// Reference: https://developer.mozilla.org/en-US/docs/Web/API/Path2D

import 'canvas_rendering_context_2d.dart';

/// Abstract Path2D Interface
/// 
/// Represents a path that can be used with CanvasRenderingContext2D methods.
abstract class IPath2D {
  /// Adds a path to this path
  void addPath(IPath2D path, [DOMMatrix? transform]);
  
  /// Closes the current subpath
  void closePath();
  
  /// Moves the starting point of a new subpath
  void moveTo(double x, double y);
  
  /// Connects the last point to the given point with a straight line
  void lineTo(double x, double y);
  
  /// Adds a quadratic Bézier curve
  void quadraticCurveTo(double cpx, double cpy, double x, double y);
  
  /// Adds a cubic Bézier curve
  void bezierCurveTo(double cp1x, double cp1y, double cp2x, double cp2y, double x, double y);
  
  /// Adds an arc to the path using control points and radius
  void arcTo(double x1, double y1, double x2, double y2, double radius);
  
  /// Adds a circular arc to the path
  void arc(double x, double y, double radius, double startAngle, double endAngle, [bool counterclockwise = false]);
  
  /// Adds an elliptical arc to the path
  void ellipse(double x, double y, double radiusX, double radiusY, double rotation, double startAngle, double endAngle, [bool counterclockwise = false]);
  
  /// Adds a rectangle to the path
  void rect(double x, double y, double width, double height);
  
  /// Adds a rounded rectangle to the path
  void roundRect(double x, double y, double width, double height, [dynamic radii]);
}
