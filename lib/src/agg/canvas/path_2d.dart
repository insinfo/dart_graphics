/// Path2D - AGG implementation of HTML5 Canvas Path2D
/// 
/// Represents a reusable path that can be drawn multiple times.

import 'dart:math' as math;

import 'package:agg/src/shared/canvas2d/canvas2d.dart';

import '../vertex_source/vertex_storage.dart';
import 'canvas_rendering_context_2d.dart';

/// Represents a 2D path that can be reused
/// 
/// The Path2D interface allows declaring paths that can be used
/// with fill() and stroke() methods on CanvasRenderingContext2D.
class AggPath2D implements IPath2D {
  final List<_PathCommand> _commands = [];
  
  /// Creates an empty path
  AggPath2D();
  
  /// Creates a path from SVG path data
  factory AggPath2D.fromSvgPath(String svgPath) {
    final path = AggPath2D();
    path.addSvgPath(svgPath);
    return path;
  }
  
  /// Copies another Path2D
  factory AggPath2D.from(AggPath2D other) {
    final path = AggPath2D();
    path._commands.addAll(other._commands);
    return path;
  }
  
  /// Adds SVG path data to this path
  void addSvgPath(String svgPath) {
    _parseSvgPath(svgPath);
  }
  
  /// Adds another path to this path
  @override
  void addPath(covariant IPath2D path, [DOMMatrix? transform]) {
    if (path is! AggPath2D) return;
    if (transform == null) {
      _commands.addAll(path._commands);
    } else {
      // Convert DOMMatrix to AggMatrix2D
      final aggTransform = AggMatrix2D(transform.a, transform.b, transform.c, transform.d, transform.e, transform.f);
      for (final cmd in path._commands) {
        _commands.add(cmd.transformed(aggTransform));
      }
    }
  }
  
  /// Closes the current subpath
  @override
  void closePath() {
    _commands.add(_PathCommand.close());
  }
  
  /// Moves the pen to a new position
  @override
  void moveTo(double x, double y) {
    _commands.add(_PathCommand.moveTo(x, y));
  }
  
  /// Draws a line to the specified point
  @override
  void lineTo(double x, double y) {
    _commands.add(_PathCommand.lineTo(x, y));
  }
  
  /// Draws a cubic Bezier curve
  @override
  void bezierCurveTo(double cp1x, double cp1y, double cp2x, double cp2y, double x, double y) {
    _commands.add(_PathCommand.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, x, y));
  }
  
  /// Draws a quadratic Bezier curve
  @override
  void quadraticCurveTo(double cpx, double cpy, double x, double y) {
    _commands.add(_PathCommand.quadraticCurveTo(cpx, cpy, x, y));
  }
  
  /// Draws an arc
  @override
  void arc(double x, double y, double radius, double startAngle, double endAngle, [bool counterclockwise = false]) {
    _commands.add(_PathCommand.arc(x, y, radius, startAngle, endAngle, counterclockwise));
  }
  
  /// Draws an arc using control points
  @override
  void arcTo(double x1, double y1, double x2, double y2, double radius) {
    _commands.add(_PathCommand.arcTo(x1, y1, x2, y2, radius));
  }
  
  /// Draws an ellipse
  @override
  void ellipse(double x, double y, double radiusX, double radiusY, 
               double rotation, double startAngle, double endAngle, 
               [bool counterclockwise = false]) {
    _commands.add(_PathCommand.ellipse(x, y, radiusX, radiusY, rotation, startAngle, endAngle, counterclockwise));
  }
  
  /// Adds a rectangle to the path
  @override
  void rect(double x, double y, double width, double height) {
    _commands.add(_PathCommand.rect(x, y, width, height));
  }
  
  /// Adds a rounded rectangle to the path
  @override
  void roundRect(double x, double y, double width, double height, [dynamic radii]) {
    double topLeft = 0, topRight = 0, bottomRight = 0, bottomLeft = 0;
    
    if (radii != null) {
      if (radii is num) {
        topLeft = topRight = bottomRight = bottomLeft = radii.toDouble();
      } else if (radii is List) {
        if (radii.length == 1) {
          topLeft = topRight = bottomRight = bottomLeft = (radii[0] as num).toDouble();
        } else if (radii.length == 2) {
          topLeft = bottomRight = (radii[0] as num).toDouble();
          topRight = bottomLeft = (radii[1] as num).toDouble();
        } else if (radii.length == 4) {
          topLeft = (radii[0] as num).toDouble();
          topRight = (radii[1] as num).toDouble();
          bottomRight = (radii[2] as num).toDouble();
          bottomLeft = (radii[3] as num).toDouble();
        }
      }
    }
    
    _commands.add(_PathCommand.roundRect(x, y, width, height, topLeft, topRight, bottomRight, bottomLeft));
  }
  
  /// Resets the path
  void reset() {
    _commands.clear();
  }
  
  /// Converts this path to an AGG VertexStorage with curves flattened to line segments
  /// 
  /// This is useful for stroking paths that contain curves.
  VertexStorage toVertexStorageFlattened() {
    final vs = VertexStorage();
    double currentX = 0, currentY = 0;
    double startX = 0, startY = 0;
    
    for (final cmd in _commands) {
      switch (cmd.type) {
        case _PathCommandType.moveTo:
          vs.moveTo(cmd.x!, cmd.y!);
          currentX = startX = cmd.x!;
          currentY = startY = cmd.y!;
          break;
          
        case _PathCommandType.lineTo:
          vs.lineTo(cmd.x!, cmd.y!);
          currentX = cmd.x!;
          currentY = cmd.y!;
          break;
          
        case _PathCommandType.bezierCurveTo:
          // Flatten cubic bezier to line segments
          _flattenCubicBezier(vs, currentX, currentY,
                              cmd.cp1x!, cmd.cp1y!, cmd.cp2x!, cmd.cp2y!, cmd.x!, cmd.y!);
          currentX = cmd.x!;
          currentY = cmd.y!;
          break;
          
        case _PathCommandType.quadraticCurveTo:
          // Flatten quadratic bezier to line segments
          _flattenQuadraticBezier(vs, currentX, currentY,
                                   cmd.cpx!, cmd.cpy!, cmd.x!, cmd.y!);
          currentX = cmd.x!;
          currentY = cmd.y!;
          break;
          
        case _PathCommandType.arc:
          _addArcToVertexStorage(vs, cmd.x!, cmd.y!, cmd.radius!, 
                                  cmd.startAngle!, cmd.endAngle!, 
                                  cmd.counterclockwise ?? false,
                                  currentX, currentY);
          currentX = cmd.x! + cmd.radius! * math.cos(cmd.endAngle!);
          currentY = cmd.y! + cmd.radius! * math.sin(cmd.endAngle!);
          break;
          
        case _PathCommandType.arcTo:
          _addArcToPathToVertexStorage(vs, currentX, currentY, 
                                        cmd.x1!, cmd.y1!, cmd.x2!, cmd.y2!, cmd.radius!);
          break;
          
        case _PathCommandType.ellipse:
          _addEllipseToVertexStorage(vs, cmd.x!, cmd.y!, cmd.radiusX!, cmd.radiusY!,
                                      cmd.rotation!, cmd.startAngle!, cmd.endAngle!,
                                      cmd.counterclockwise ?? false);
          break;
          
        case _PathCommandType.rect:
          vs.moveTo(cmd.x!, cmd.y!);
          vs.lineTo(cmd.x! + cmd.width!, cmd.y!);
          vs.lineTo(cmd.x! + cmd.width!, cmd.y! + cmd.height!);
          vs.lineTo(cmd.x!, cmd.y! + cmd.height!);
          vs.closePath();
          currentX = cmd.x!;
          currentY = cmd.y!;
          break;
          
        case _PathCommandType.roundRect:
          _addRoundRectToVertexStorage(vs, cmd.x!, cmd.y!, cmd.width!, cmd.height!,
                                        cmd.topLeft!, cmd.topRight!, cmd.bottomRight!, cmd.bottomLeft!);
          currentX = cmd.x!;
          currentY = cmd.y!;
          break;
          
        case _PathCommandType.close:
          vs.closePath();
          currentX = startX;
          currentY = startY;
          break;
      }
    }
    
    return vs;
  }
  
  /// Flattens a quadratic bezier curve to line segments
  void _flattenQuadraticBezier(VertexStorage vs, double x0, double y0,
                                double cpx, double cpy, double x, double y) {
    const int segments = 20;
    for (int i = 1; i <= segments; i++) {
      final t = i / segments;
      final t2 = t * t;
      final mt = 1 - t;
      final mt2 = mt * mt;
      
      final px = mt2 * x0 + 2 * mt * t * cpx + t2 * x;
      final py = mt2 * y0 + 2 * mt * t * cpy + t2 * y;
      vs.lineTo(px, py);
    }
  }
  
  /// Flattens a cubic bezier curve to line segments
  void _flattenCubicBezier(VertexStorage vs, double x0, double y0,
                           double cp1x, double cp1y, double cp2x, double cp2y, 
                           double x, double y) {
    const int segments = 20;
    for (int i = 1; i <= segments; i++) {
      final t = i / segments;
      final t2 = t * t;
      final t3 = t2 * t;
      final mt = 1 - t;
      final mt2 = mt * mt;
      final mt3 = mt2 * mt;
      
      final px = mt3 * x0 + 3 * mt2 * t * cp1x + 3 * mt * t2 * cp2x + t3 * x;
      final py = mt3 * y0 + 3 * mt2 * t * cp1y + 3 * mt * t2 * cp2y + t3 * y;
      vs.lineTo(px, py);
    }
  }

  /// Converts this path to an AGG VertexStorage
  VertexStorage toVertexStorage() {
    final vs = VertexStorage();
    double currentX = 0, currentY = 0;
    double startX = 0, startY = 0;
    
    for (final cmd in _commands) {
      switch (cmd.type) {
        case _PathCommandType.moveTo:
          vs.moveTo(cmd.x!, cmd.y!);
          currentX = startX = cmd.x!;
          currentY = startY = cmd.y!;
          break;
          
        case _PathCommandType.lineTo:
          vs.lineTo(cmd.x!, cmd.y!);
          currentX = cmd.x!;
          currentY = cmd.y!;
          break;
          
        case _PathCommandType.bezierCurveTo:
          vs.curve4(cmd.cp1x!, cmd.cp1y!, cmd.cp2x!, cmd.cp2y!, cmd.x!, cmd.y!);
          currentX = cmd.x!;
          currentY = cmd.y!;
          break;
          
        case _PathCommandType.quadraticCurveTo:
          vs.curve3(cmd.cpx!, cmd.cpy!, cmd.x!, cmd.y!);
          currentX = cmd.x!;
          currentY = cmd.y!;
          break;
          
        case _PathCommandType.arc:
          _addArcToVertexStorage(vs, cmd.x!, cmd.y!, cmd.radius!, 
                                  cmd.startAngle!, cmd.endAngle!, 
                                  cmd.counterclockwise ?? false,
                                  currentX, currentY);
          currentX = cmd.x! + cmd.radius! * math.cos(cmd.endAngle!);
          currentY = cmd.y! + cmd.radius! * math.sin(cmd.endAngle!);
          break;
          
        case _PathCommandType.arcTo:
          _addArcToPathToVertexStorage(vs, currentX, currentY, 
                                        cmd.x1!, cmd.y1!, cmd.x2!, cmd.y2!, cmd.radius!);
          break;
          
        case _PathCommandType.ellipse:
          _addEllipseToVertexStorage(vs, cmd.x!, cmd.y!, cmd.radiusX!, cmd.radiusY!,
                                      cmd.rotation!, cmd.startAngle!, cmd.endAngle!,
                                      cmd.counterclockwise ?? false);
          break;
          
        case _PathCommandType.rect:
          vs.moveTo(cmd.x!, cmd.y!);
          vs.lineTo(cmd.x! + cmd.width!, cmd.y!);
          vs.lineTo(cmd.x! + cmd.width!, cmd.y! + cmd.height!);
          vs.lineTo(cmd.x!, cmd.y! + cmd.height!);
          vs.closePath();
          currentX = cmd.x!;
          currentY = cmd.y!;
          break;
          
        case _PathCommandType.roundRect:
          _addRoundRectToVertexStorage(vs, cmd.x!, cmd.y!, cmd.width!, cmd.height!,
                                        cmd.topLeft!, cmd.topRight!, cmd.bottomRight!, cmd.bottomLeft!);
          currentX = cmd.x!;
          currentY = cmd.y!;
          break;
          
        case _PathCommandType.close:
          vs.closePath();
          currentX = startX;
          currentY = startY;
          break;
      }
    }
    
    return vs;
  }
  
  void _addArcToVertexStorage(VertexStorage vs, double cx, double cy, double radius,
                               double startAngle, double endAngle, bool counterclockwise,
                               double currentX, double currentY) {
    // Calculate number of segments based on arc length
    double sweep = endAngle - startAngle;
    if (counterclockwise && sweep > 0) {
      sweep -= 2 * math.pi;
    } else if (!counterclockwise && sweep < 0) {
      sweep += 2 * math.pi;
    }
    
    final segments = math.max(4, (sweep.abs() * radius / 4).round());
    final step = sweep / segments;
    
    // Move to start of arc if not already there
    final startX = cx + radius * math.cos(startAngle);
    final startY = cy + radius * math.sin(startAngle);
    
    // Check if we need to draw a line to the start
    final dx = startX - currentX;
    final dy = startY - currentY;
    if (dx * dx + dy * dy > 0.01) {
      vs.lineTo(startX, startY);
    }
    
    // Draw arc as line segments (can be improved with bezier curves)
    for (int i = 1; i <= segments; i++) {
      final angle = startAngle + step * i;
      final x = cx + radius * math.cos(angle);
      final y = cy + radius * math.sin(angle);
      vs.lineTo(x, y);
    }
  }
  
  void _addArcToPathToVertexStorage(VertexStorage vs, double x0, double y0,
                                     double x1, double y1, double x2, double y2, double radius) {
    // Calculate the arc that connects (x0,y0) to a point on line (x1,y1)-(x2,y2)
    // with the given radius
    
    // Vector from (x1,y1) to (x0,y0)
    double dx0 = x0 - x1;
    double dy0 = y0 - y1;
    double len0 = math.sqrt(dx0 * dx0 + dy0 * dy0);
    
    // Vector from (x1,y1) to (x2,y2)
    double dx1 = x2 - x1;
    double dy1 = y2 - y1;
    double len1 = math.sqrt(dx1 * dx1 + dy1 * dy1);
    
    if (len0 < 1e-10 || len1 < 1e-10 || radius < 1e-10) {
      vs.lineTo(x1, y1);
      return;
    }
    
    // Normalize vectors
    dx0 /= len0;
    dy0 /= len0;
    dx1 /= len1;
    dy1 /= len1;
    
    // Calculate angle between vectors
    final cosAngle = dx0 * dx1 + dy0 * dy1;
    final sinAngle = dx0 * dy1 - dy0 * dx1;
    final angle = math.atan2(sinAngle.abs(), cosAngle);
    
    if (angle < 1e-10) {
      vs.lineTo(x1, y1);
      return;
    }
    
    // Distance from corner to tangent points
    final tangentDist = radius / math.tan(angle / 2);
    
    // Tangent points
    final t1x = x1 + dx0 * tangentDist;
    final t1y = y1 + dy0 * tangentDist;
    final t2x = x1 + dx1 * tangentDist;
    final t2y = y1 + dy1 * tangentDist;
    
    // Draw line to first tangent point
    vs.lineTo(t1x, t1y);
    
    // Calculate center of the arc
    final cx = t1x + dy0 * radius * (sinAngle > 0 ? -1 : 1);
    final cy = t1y - dx0 * radius * (sinAngle > 0 ? -1 : 1);
    
    // Calculate start and end angles
    final startAngle = math.atan2(t1y - cy, t1x - cx);
    final endAngle = math.atan2(t2y - cy, t2x - cx);
    
    // Draw arc
    _addArcToVertexStorage(vs, cx, cy, radius, startAngle, endAngle, sinAngle < 0, t1x, t1y);
  }
  
  void _addEllipseToVertexStorage(VertexStorage vs, double cx, double cy,
                                   double rx, double ry, double rotation,
                                   double startAngle, double endAngle, bool counterclockwise) {
    double sweep = endAngle - startAngle;
    if (counterclockwise && sweep > 0) {
      sweep -= 2 * math.pi;
    } else if (!counterclockwise && sweep < 0) {
      sweep += 2 * math.pi;
    }
    
    final segments = math.max(8, (sweep.abs() * math.max(rx, ry) / 4).round());
    final step = sweep / segments;
    
    final cosRot = math.cos(rotation);
    final sinRot = math.sin(rotation);
    
    for (int i = 0; i <= segments; i++) {
      final angle = startAngle + step * i;
      final ex = rx * math.cos(angle);
      final ey = ry * math.sin(angle);
      
      // Apply rotation
      final x = cx + ex * cosRot - ey * sinRot;
      final y = cy + ex * sinRot + ey * cosRot;
      
      if (i == 0) {
        vs.moveTo(x, y);
      } else {
        vs.lineTo(x, y);
      }
    }
  }
  
  void _addRoundRectToVertexStorage(VertexStorage vs, double x, double y,
                                     double w, double h,
                                     double tl, double tr, double br, double bl) {
    // Clamp radii to half the rectangle dimensions
    final maxRadius = math.min(w / 2, h / 2);
    tl = math.min(tl, maxRadius);
    tr = math.min(tr, maxRadius);
    br = math.min(br, maxRadius);
    bl = math.min(bl, maxRadius);
    
    // Start at top-left after the corner
    vs.moveTo(x + tl, y);
    
    // Top edge and top-right corner
    vs.lineTo(x + w - tr, y);
    if (tr > 0) {
      _addCornerArc(vs, x + w - tr, y + tr, tr, -math.pi / 2, 0);
    }
    
    // Right edge and bottom-right corner
    vs.lineTo(x + w, y + h - br);
    if (br > 0) {
      _addCornerArc(vs, x + w - br, y + h - br, br, 0, math.pi / 2);
    }
    
    // Bottom edge and bottom-left corner
    vs.lineTo(x + bl, y + h);
    if (bl > 0) {
      _addCornerArc(vs, x + bl, y + h - bl, bl, math.pi / 2, math.pi);
    }
    
    // Left edge and top-left corner
    vs.lineTo(x, y + tl);
    if (tl > 0) {
      _addCornerArc(vs, x + tl, y + tl, tl, math.pi, 3 * math.pi / 2);
    }
    
    vs.closePath();
  }
  
  void _addCornerArc(VertexStorage vs, double cx, double cy, double radius,
                      double startAngle, double endAngle) {
    final segments = 8;
    final step = (endAngle - startAngle) / segments;
    
    for (int i = 1; i <= segments; i++) {
      final angle = startAngle + step * i;
      final x = cx + radius * math.cos(angle);
      final y = cy + radius * math.sin(angle);
      vs.lineTo(x, y);
    }
  }
  
  void _parseSvgPath(String svgPath) {
    // Simple SVG path parser
    final commands = RegExp(r'([MmLlHhVvCcSsQqTtAaZz])([^MmLlHhVvCcSsQqTtAaZz]*)');
    
    double currentX = 0, currentY = 0;
    double startX = 0, startY = 0;
    double lastControlX = 0, lastControlY = 0;
    String lastCommand = '';
    
    for (final match in commands.allMatches(svgPath)) {
      final cmd = match.group(1)!;
      final args = _parseNumbers(match.group(2) ?? '');
      
      final isRelative = cmd == cmd.toLowerCase();
      
      switch (cmd.toUpperCase()) {
        case 'M':
          var i = 0;
          while (i < args.length - 1) {
            final x = args[i] + (isRelative && i > 0 ? currentX : (isRelative ? currentX : 0));
            final y = args[i + 1] + (isRelative && i > 0 ? currentY : (isRelative ? currentY : 0));
            if (i == 0) {
              moveTo(x, y);
              startX = x;
              startY = y;
            } else {
              lineTo(x, y);
            }
            currentX = x;
            currentY = y;
            i += 2;
          }
          break;
          
        case 'L':
          var i = 0;
          while (i < args.length - 1) {
            final x = args[i] + (isRelative ? currentX : 0);
            final y = args[i + 1] + (isRelative ? currentY : 0);
            lineTo(x, y);
            currentX = x;
            currentY = y;
            i += 2;
          }
          break;
          
        case 'H':
          for (final arg in args) {
            final x = arg + (isRelative ? currentX : 0);
            lineTo(x, currentY);
            currentX = x;
          }
          break;
          
        case 'V':
          for (final arg in args) {
            final y = arg + (isRelative ? currentY : 0);
            lineTo(currentX, y);
            currentY = y;
          }
          break;
          
        case 'C':
          var i = 0;
          while (i < args.length - 5) {
            final cp1x = args[i] + (isRelative ? currentX : 0);
            final cp1y = args[i + 1] + (isRelative ? currentY : 0);
            final cp2x = args[i + 2] + (isRelative ? currentX : 0);
            final cp2y = args[i + 3] + (isRelative ? currentY : 0);
            final x = args[i + 4] + (isRelative ? currentX : 0);
            final y = args[i + 5] + (isRelative ? currentY : 0);
            bezierCurveTo(cp1x, cp1y, cp2x, cp2y, x, y);
            lastControlX = cp2x;
            lastControlY = cp2y;
            currentX = x;
            currentY = y;
            i += 6;
          }
          break;
          
        case 'S':
          var i = 0;
          while (i < args.length - 3) {
            double cp1x, cp1y;
            if (lastCommand == 'C' || lastCommand == 'c' || lastCommand == 'S' || lastCommand == 's') {
              cp1x = 2 * currentX - lastControlX;
              cp1y = 2 * currentY - lastControlY;
            } else {
              cp1x = currentX;
              cp1y = currentY;
            }
            final cp2x = args[i] + (isRelative ? currentX : 0);
            final cp2y = args[i + 1] + (isRelative ? currentY : 0);
            final x = args[i + 2] + (isRelative ? currentX : 0);
            final y = args[i + 3] + (isRelative ? currentY : 0);
            bezierCurveTo(cp1x, cp1y, cp2x, cp2y, x, y);
            lastControlX = cp2x;
            lastControlY = cp2y;
            currentX = x;
            currentY = y;
            i += 4;
          }
          break;
          
        case 'Q':
          var i = 0;
          while (i < args.length - 3) {
            final cpx = args[i] + (isRelative ? currentX : 0);
            final cpy = args[i + 1] + (isRelative ? currentY : 0);
            final x = args[i + 2] + (isRelative ? currentX : 0);
            final y = args[i + 3] + (isRelative ? currentY : 0);
            quadraticCurveTo(cpx, cpy, x, y);
            lastControlX = cpx;
            lastControlY = cpy;
            currentX = x;
            currentY = y;
            i += 4;
          }
          break;
          
        case 'T':
          var i = 0;
          while (i < args.length - 1) {
            double cpx, cpy;
            if (lastCommand == 'Q' || lastCommand == 'q' || lastCommand == 'T' || lastCommand == 't') {
              cpx = 2 * currentX - lastControlX;
              cpy = 2 * currentY - lastControlY;
            } else {
              cpx = currentX;
              cpy = currentY;
            }
            final x = args[i] + (isRelative ? currentX : 0);
            final y = args[i + 1] + (isRelative ? currentY : 0);
            quadraticCurveTo(cpx, cpy, x, y);
            lastControlX = cpx;
            lastControlY = cpy;
            currentX = x;
            currentY = y;
            i += 2;
          }
          break;
          
        case 'A':
          var i = 0;
          while (i < args.length - 6) {
            final rx = args[i];
            final ry = args[i + 1];
            final rotation = args[i + 2] * math.pi / 180;
            final largeArc = args[i + 3] != 0;
            final sweep = args[i + 4] != 0;
            final x = args[i + 5] + (isRelative ? currentX : 0);
            final y = args[i + 6] + (isRelative ? currentY : 0);
            _addSvgArc(currentX, currentY, rx, ry, rotation, largeArc, sweep, x, y);
            currentX = x;
            currentY = y;
            i += 7;
          }
          break;
          
        case 'Z':
          closePath();
          currentX = startX;
          currentY = startY;
          break;
      }
      
      lastCommand = cmd;
    }
  }
  
  void _addSvgArc(double x1, double y1, double rx, double ry, double rotation,
                  bool largeArc, bool sweep, double x2, double y2) {
    // Convert SVG arc to center parameterization
    if (rx == 0 || ry == 0) {
      lineTo(x2, y2);
      return;
    }
    
    rx = rx.abs();
    ry = ry.abs();
    
    final cosRot = math.cos(rotation);
    final sinRot = math.sin(rotation);
    
    // Transform to centered ellipse coordinates
    final dx = (x1 - x2) / 2;
    final dy = (y1 - y2) / 2;
    final x1p = cosRot * dx + sinRot * dy;
    final y1p = -sinRot * dx + cosRot * dy;
    
    // Scale radii if necessary
    final lambda = (x1p * x1p) / (rx * rx) + (y1p * y1p) / (ry * ry);
    if (lambda > 1) {
      final sqrtLambda = math.sqrt(lambda);
      rx *= sqrtLambda;
      ry *= sqrtLambda;
    }
    
    // Calculate center
    final sq = ((rx * rx * ry * ry - rx * rx * y1p * y1p - ry * ry * x1p * x1p) /
                (rx * rx * y1p * y1p + ry * ry * x1p * x1p)).abs();
    final coef = (largeArc != sweep ? 1 : -1) * math.sqrt(sq);
    final cxp = coef * rx * y1p / ry;
    final cyp = -coef * ry * x1p / rx;
    
    final cx = cosRot * cxp - sinRot * cyp + (x1 + x2) / 2;
    final cy = sinRot * cxp + cosRot * cyp + (y1 + y2) / 2;
    
    // Calculate angles
    final startAngle = _svgAngle(1, 0, (x1p - cxp) / rx, (y1p - cyp) / ry);
    var deltaAngle = _svgAngle((x1p - cxp) / rx, (y1p - cyp) / ry,
                                (-x1p - cxp) / rx, (-y1p - cyp) / ry);
    
    if (!sweep && deltaAngle > 0) {
      deltaAngle -= 2 * math.pi;
    } else if (sweep && deltaAngle < 0) {
      deltaAngle += 2 * math.pi;
    }
    
    ellipse(cx, cy, rx, ry, rotation, startAngle, startAngle + deltaAngle, !sweep);
  }
  
  double _svgAngle(double ux, double uy, double vx, double vy) {
    final dot = ux * vx + uy * vy;
    final len = math.sqrt(ux * ux + uy * uy) * math.sqrt(vx * vx + vy * vy);
    var angle = math.acos((dot / len).clamp(-1.0, 1.0));
    if (ux * vy - uy * vx < 0) {
      angle = -angle;
    }
    return angle;
  }
  
  List<double> _parseNumbers(String str) {
    final numbers = <double>[];
    final regex = RegExp(r'-?[\d.]+(?:e[+-]?\d+)?');
    for (final match in regex.allMatches(str)) {
      final value = double.tryParse(match.group(0) ?? '');
      if (value != null) {
        numbers.add(value);
      }
    }
    return numbers;
  }
}

/// Path command types
enum _PathCommandType {
  moveTo,
  lineTo,
  bezierCurveTo,
  quadraticCurveTo,
  arc,
  arcTo,
  ellipse,
  rect,
  roundRect,
  close,
}

/// Internal path command
class _PathCommand {
  final _PathCommandType type;
  final double? x, y;
  final double? cp1x, cp1y, cp2x, cp2y;
  final double? cpx, cpy;
  final double? x1, y1, x2, y2;
  final double? radius, radiusX, radiusY;
  final double? startAngle, endAngle, rotation;
  final double? width, height;
  final double? topLeft, topRight, bottomRight, bottomLeft;
  final bool? counterclockwise;
  
  _PathCommand._({
    required this.type,
    this.x, this.y,
    this.cp1x, this.cp1y, this.cp2x, this.cp2y,
    this.cpx, this.cpy,
    this.x1, this.y1, this.x2, this.y2,
    this.radius, this.radiusX, this.radiusY,
    this.startAngle, this.endAngle, this.rotation,
    this.width, this.height,
    this.topLeft, this.topRight, this.bottomRight, this.bottomLeft,
    this.counterclockwise,
  });
  
  factory _PathCommand.moveTo(double x, double y) {
    return _PathCommand._(type: _PathCommandType.moveTo, x: x, y: y);
  }
  
  factory _PathCommand.lineTo(double x, double y) {
    return _PathCommand._(type: _PathCommandType.lineTo, x: x, y: y);
  }
  
  factory _PathCommand.bezierCurveTo(double cp1x, double cp1y, double cp2x, double cp2y, double x, double y) {
    return _PathCommand._(type: _PathCommandType.bezierCurveTo, 
                          cp1x: cp1x, cp1y: cp1y, cp2x: cp2x, cp2y: cp2y, x: x, y: y);
  }
  
  factory _PathCommand.quadraticCurveTo(double cpx, double cpy, double x, double y) {
    return _PathCommand._(type: _PathCommandType.quadraticCurveTo, cpx: cpx, cpy: cpy, x: x, y: y);
  }
  
  factory _PathCommand.arc(double x, double y, double radius, double startAngle, double endAngle, bool counterclockwise) {
    return _PathCommand._(type: _PathCommandType.arc, x: x, y: y, radius: radius,
                          startAngle: startAngle, endAngle: endAngle, counterclockwise: counterclockwise);
  }
  
  factory _PathCommand.arcTo(double x1, double y1, double x2, double y2, double radius) {
    return _PathCommand._(type: _PathCommandType.arcTo, x1: x1, y1: y1, x2: x2, y2: y2, radius: radius);
  }
  
  factory _PathCommand.ellipse(double x, double y, double radiusX, double radiusY,
                               double rotation, double startAngle, double endAngle, bool counterclockwise) {
    return _PathCommand._(type: _PathCommandType.ellipse, x: x, y: y,
                          radiusX: radiusX, radiusY: radiusY, rotation: rotation,
                          startAngle: startAngle, endAngle: endAngle, counterclockwise: counterclockwise);
  }
  
  factory _PathCommand.rect(double x, double y, double width, double height) {
    return _PathCommand._(type: _PathCommandType.rect, x: x, y: y, width: width, height: height);
  }
  
  factory _PathCommand.roundRect(double x, double y, double width, double height,
                                 double topLeft, double topRight, double bottomRight, double bottomLeft) {
    return _PathCommand._(type: _PathCommandType.roundRect, x: x, y: y, width: width, height: height,
                          topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft);
  }
  
  factory _PathCommand.close() {
    return _PathCommand._(type: _PathCommandType.close);
  }
  
  /// Creates a transformed copy of this command
  _PathCommand transformed(AggMatrix2D t) {
    switch (type) {
      case _PathCommandType.moveTo:
        final p = t.transformPoint(x!, y!);
        return _PathCommand.moveTo(p.x, p.y);
        
      case _PathCommandType.lineTo:
        final p = t.transformPoint(x!, y!);
        return _PathCommand.lineTo(p.x, p.y);
        
      case _PathCommandType.bezierCurveTo:
        final p1 = t.transformPoint(cp1x!, cp1y!);
        final p2 = t.transformPoint(cp2x!, cp2y!);
        final p = t.transformPoint(x!, y!);
        return _PathCommand.bezierCurveTo(p1.x, p1.y, p2.x, p2.y, p.x, p.y);
        
      case _PathCommandType.quadraticCurveTo:
        final pc = t.transformPoint(cpx!, cpy!);
        final p = t.transformPoint(x!, y!);
        return _PathCommand.quadraticCurveTo(pc.x, pc.y, p.x, p.y);
        
      case _PathCommandType.arc:
        final c = t.transformPoint(x!, y!);
        // Note: radius should also be transformed for proper scaling
        return _PathCommand.arc(c.x, c.y, radius!, startAngle!, endAngle!, counterclockwise!);
        
      case _PathCommandType.arcTo:
        final p1 = t.transformPoint(x1!, y1!);
        final p2 = t.transformPoint(x2!, y2!);
        return _PathCommand.arcTo(p1.x, p1.y, p2.x, p2.y, radius!);
        
      case _PathCommandType.ellipse:
        final c = t.transformPoint(x!, y!);
        return _PathCommand.ellipse(c.x, c.y, radiusX!, radiusY!, rotation!, startAngle!, endAngle!, counterclockwise!);
        
      case _PathCommandType.rect:
        final p = t.transformPoint(x!, y!);
        return _PathCommand.rect(p.x, p.y, width!, height!);
        
      case _PathCommandType.roundRect:
        final p = t.transformPoint(x!, y!);
        return _PathCommand.roundRect(p.x, p.y, width!, height!, topLeft!, topRight!, bottomRight!, bottomLeft!);
        
      case _PathCommandType.close:
        return _PathCommand.close();
    }
  }
}
