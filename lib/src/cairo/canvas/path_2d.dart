/// Path2D - Cairo implementation of HTML5 Canvas Path2D
/// 
/// Represents a reusable path that can be drawn multiple times.

import 'dart:math' as math;

import '../cairo_api.dart';
import '../../shared/canvas2d/canvas2d.dart';

/// Represents a 2D path that can be reused
/// 
/// The Path2D interface allows declaring paths that can be used
/// with fill() and stroke() methods on CanvasRenderingContext2D.
class CairoPath2D implements IPath2D {
  final List<_PathCommand> _commands = [];
  
  /// Creates an empty path
  CairoPath2D();
  
  /// Creates a path from SVG path data
  factory CairoPath2D.fromSvgPath(String svgPath) {
    final path = CairoPath2D();
    path.addSvgPath(svgPath);
    return path;
  }
  
  /// Copies another Path2D
  factory CairoPath2D.from(CairoPath2D other) {
    final path = CairoPath2D();
    path._commands.addAll(other._commands);
    return path;
  }
  
  /// Adds SVG path data to this path
  void addSvgPath(String svgPath) {
    _parseSvgPath(svgPath);
  }
  
  /// Adds another path to this path
  @override
  void addPath(IPath2D path, [DOMMatrix? transform]) {
    if (path is CairoPath2D) {
      if (transform != null) {
        // Transform each command
        for (final cmd in path._commands) {
          _commands.add(cmd.transformed(transform));
        }
      } else {
        _commands.addAll(path._commands);
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
    // Convert quadratic to cubic
    // For quadratic P0, P1, P2 -> cubic P0, (P0+2*P1)/3, (P2+2*P1)/3, P2
    // We need the current point for this conversion
    // For simplicity, store as quadratic command
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
  
  /// Applies the path commands to a Cairo context
  void applyTo(CairoCanvasImpl ctx) {
    double currentX = 0, currentY = 0;
    double startX = 0, startY = 0;
    
    for (final cmd in _commands) {
      switch (cmd.type) {
        case _PathCommandType.moveTo:
          ctx.moveTo(cmd.x!, cmd.y!);
          currentX = startX = cmd.x!;
          currentY = startY = cmd.y!;
          break;
          
        case _PathCommandType.lineTo:
          ctx.lineTo(cmd.x!, cmd.y!);
          currentX = cmd.x!;
          currentY = cmd.y!;
          break;
          
        case _PathCommandType.bezierCurveTo:
          ctx.curveTo(cmd.cp1x!, cmd.cp1y!, cmd.cp2x!, cmd.cp2y!, cmd.x!, cmd.y!);
          currentX = cmd.x!;
          currentY = cmd.y!;
          break;
          
        case _PathCommandType.quadraticCurveTo:
          // Convert quadratic to cubic
          final qx = cmd.cpx!, qy = cmd.cpy!;
          final x = cmd.x!, y = cmd.y!;
          final cp1x = currentX + 2.0/3.0 * (qx - currentX);
          final cp1y = currentY + 2.0/3.0 * (qy - currentY);
          final cp2x = x + 2.0/3.0 * (qx - x);
          final cp2y = y + 2.0/3.0 * (qy - y);
          ctx.curveTo(cp1x, cp1y, cp2x, cp2y, x, y);
          currentX = x;
          currentY = y;
          break;
          
        case _PathCommandType.arc:
          if (cmd.counterclockwise ?? false) {
            ctx.arcNegative(cmd.x!, cmd.y!, cmd.radius!, cmd.startAngle!, cmd.endAngle!);
          } else {
            ctx.arc(cmd.x!, cmd.y!, cmd.radius!, cmd.startAngle!, cmd.endAngle!);
          }
          // Update current position to end of arc
          currentX = cmd.x! + cmd.radius! * math.cos(cmd.endAngle!);
          currentY = cmd.y! + cmd.radius! * math.sin(cmd.endAngle!);
          break;
          
        case _PathCommandType.arcTo:
          _applyArcTo(ctx, currentX, currentY, cmd.x1!, cmd.y1!, cmd.x2!, cmd.y2!, cmd.radius!);
          // arcTo updates current position to tangent point
          break;
          
        case _PathCommandType.ellipse:
          ctx.save();
          ctx.translate(cmd.x!, cmd.y!);
          ctx.rotate(cmd.rotation!);
          ctx.scale(cmd.radiusX!, cmd.radiusY!);
          if (cmd.counterclockwise ?? false) {
            ctx.arcNegative(0, 0, 1, cmd.startAngle!, cmd.endAngle!);
          } else {
            ctx.arc(0, 0, 1, cmd.startAngle!, cmd.endAngle!);
          }
          ctx.restore();
          break;
          
        case _PathCommandType.rect:
          ctx.rectangle(cmd.x!, cmd.y!, cmd.width!, cmd.height!);
          currentX = cmd.x!;
          currentY = cmd.y!;
          break;
          
        case _PathCommandType.roundRect:
          _applyRoundRect(ctx, cmd.x!, cmd.y!, cmd.width!, cmd.height!,
                         cmd.topLeft!, cmd.topRight!, cmd.bottomRight!, cmd.bottomLeft!);
          currentX = cmd.x!;
          currentY = cmd.y!;
          break;
          
        case _PathCommandType.close:
          ctx.closePath();
          currentX = startX;
          currentY = startY;
          break;
      }
    }
  }
  
  void _applyArcTo(CairoCanvasImpl ctx, double x0, double y0, 
                   double x1, double y1, double x2, double y2, double radius) {
    // Calculate arcTo using the algorithm from HTML5 spec
    final v1x = x0 - x1;
    final v1y = y0 - y1;
    final v2x = x2 - x1;
    final v2y = y2 - y1;
    
    final v1len = math.sqrt(v1x * v1x + v1y * v1y);
    final v2len = math.sqrt(v2x * v2x + v2y * v2y);
    
    if (v1len == 0 || v2len == 0) {
      ctx.lineTo(x1, y1);
      return;
    }
    
    final v1nx = v1x / v1len;
    final v1ny = v1y / v1len;
    final v2nx = v2x / v2len;
    final v2ny = v2y / v2len;
    
    final angle = math.acos(v1nx * v2nx + v1ny * v2ny);
    if (angle == 0 || angle == math.pi) {
      ctx.lineTo(x1, y1);
      return;
    }
    
    final tan = math.tan(angle / 2);
    final dist = radius / tan;
    
    final t1x = x1 + v1nx * dist;
    final t1y = y1 + v1ny * dist;
    final t2x = x1 + v2nx * dist;
    final t2y = y1 + v2ny * dist;
    
    // Calculate center
    final cross = v1nx * v2ny - v1ny * v2nx;
    final perpx = cross > 0 ? -v1ny : v1ny;
    final perpy = cross > 0 ? v1nx : -v1nx;
    
    final cx = t1x + perpx * radius;
    final cy = t1y + perpy * radius;
    
    final startAngle = math.atan2(t1y - cy, t1x - cx);
    final endAngle = math.atan2(t2y - cy, t2x - cx);
    
    ctx.lineTo(t1x, t1y);
    if (cross > 0) {
      ctx.arcNegative(cx, cy, radius, startAngle, endAngle);
    } else {
      ctx.arc(cx, cy, radius, startAngle, endAngle);
    }
  }
  
  void _applyRoundRect(CairoCanvasImpl ctx, double x, double y, double w, double h,
                       double tl, double tr, double br, double bl) {
    ctx.newSubPath();
    ctx.moveTo(x + tl, y);
    ctx.lineTo(x + w - tr, y);
    if (tr > 0) {
      ctx.arc(x + w - tr, y + tr, tr, -math.pi / 2, 0);
    }
    ctx.lineTo(x + w, y + h - br);
    if (br > 0) {
      ctx.arc(x + w - br, y + h - br, br, 0, math.pi / 2);
    }
    ctx.lineTo(x + bl, y + h);
    if (bl > 0) {
      ctx.arc(x + bl, y + h - bl, bl, math.pi / 2, math.pi);
    }
    ctx.lineTo(x, y + tl);
    if (tl > 0) {
      ctx.arc(x + tl, y + tl, tl, math.pi, math.pi * 1.5);
    }
    ctx.closePath();
  }
  
  void _parseSvgPath(String d) {
    // Simple SVG path parser
    final regex = RegExp(r'([MmLlHhVvCcSsQqTtAaZz])([^MmLlHhVvCcSsQqTtAaZz]*)');
    final matches = regex.allMatches(d);
    
    double currentX = 0, currentY = 0;
    double? lastCpX, lastCpY;
    String? lastCommand;
    
    for (final match in matches) {
      final command = match.group(1)!;
      final argsStr = match.group(2) ?? '';
      final args = _parseNumbers(argsStr);
      
      switch (command) {
        case 'M':
          for (var i = 0; i < args.length; i += 2) {
            if (i == 0) {
              moveTo(args[i], args[i + 1]);
            } else {
              lineTo(args[i], args[i + 1]);
            }
            currentX = args[i];
            currentY = args[i + 1];
          }
          break;
        case 'm':
          for (var i = 0; i < args.length; i += 2) {
            if (i == 0) {
              moveTo(currentX + args[i], currentY + args[i + 1]);
            } else {
              lineTo(currentX + args[i], currentY + args[i + 1]);
            }
            currentX += args[i];
            currentY += args[i + 1];
          }
          break;
        case 'L':
          for (var i = 0; i < args.length; i += 2) {
            lineTo(args[i], args[i + 1]);
            currentX = args[i];
            currentY = args[i + 1];
          }
          break;
        case 'l':
          for (var i = 0; i < args.length; i += 2) {
            lineTo(currentX + args[i], currentY + args[i + 1]);
            currentX += args[i];
            currentY += args[i + 1];
          }
          break;
        case 'H':
          for (var i = 0; i < args.length; i++) {
            lineTo(args[i], currentY);
            currentX = args[i];
          }
          break;
        case 'h':
          for (var i = 0; i < args.length; i++) {
            lineTo(currentX + args[i], currentY);
            currentX += args[i];
          }
          break;
        case 'V':
          for (var i = 0; i < args.length; i++) {
            lineTo(currentX, args[i]);
            currentY = args[i];
          }
          break;
        case 'v':
          for (var i = 0; i < args.length; i++) {
            lineTo(currentX, currentY + args[i]);
            currentY += args[i];
          }
          break;
        case 'C':
          for (var i = 0; i < args.length; i += 6) {
            bezierCurveTo(args[i], args[i + 1], args[i + 2], args[i + 3], args[i + 4], args[i + 5]);
            lastCpX = args[i + 2];
            lastCpY = args[i + 3];
            currentX = args[i + 4];
            currentY = args[i + 5];
          }
          break;
        case 'c':
          for (var i = 0; i < args.length; i += 6) {
            bezierCurveTo(
              currentX + args[i], currentY + args[i + 1],
              currentX + args[i + 2], currentY + args[i + 3],
              currentX + args[i + 4], currentY + args[i + 5]
            );
            lastCpX = currentX + args[i + 2];
            lastCpY = currentY + args[i + 3];
            currentX += args[i + 4];
            currentY += args[i + 5];
          }
          break;
        case 'S':
          for (var i = 0; i < args.length; i += 4) {
            final cp1x = lastCommand == 'C' || lastCommand == 'c' || lastCommand == 'S' || lastCommand == 's'
                ? currentX * 2 - (lastCpX ?? currentX)
                : currentX;
            final cp1y = lastCommand == 'C' || lastCommand == 'c' || lastCommand == 'S' || lastCommand == 's'
                ? currentY * 2 - (lastCpY ?? currentY)
                : currentY;
            bezierCurveTo(cp1x, cp1y, args[i], args[i + 1], args[i + 2], args[i + 3]);
            lastCpX = args[i];
            lastCpY = args[i + 1];
            currentX = args[i + 2];
            currentY = args[i + 3];
          }
          break;
        case 's':
          for (var i = 0; i < args.length; i += 4) {
            final cp1x = lastCommand == 'C' || lastCommand == 'c' || lastCommand == 'S' || lastCommand == 's'
                ? currentX * 2 - (lastCpX ?? currentX)
                : currentX;
            final cp1y = lastCommand == 'C' || lastCommand == 'c' || lastCommand == 'S' || lastCommand == 's'
                ? currentY * 2 - (lastCpY ?? currentY)
                : currentY;
            bezierCurveTo(cp1x, cp1y, currentX + args[i], currentY + args[i + 1],
                          currentX + args[i + 2], currentY + args[i + 3]);
            lastCpX = currentX + args[i];
            lastCpY = currentY + args[i + 1];
            currentX += args[i + 2];
            currentY += args[i + 3];
          }
          break;
        case 'Q':
          for (var i = 0; i < args.length; i += 4) {
            quadraticCurveTo(args[i], args[i + 1], args[i + 2], args[i + 3]);
            lastCpX = args[i];
            lastCpY = args[i + 1];
            currentX = args[i + 2];
            currentY = args[i + 3];
          }
          break;
        case 'q':
          for (var i = 0; i < args.length; i += 4) {
            quadraticCurveTo(currentX + args[i], currentY + args[i + 1],
                            currentX + args[i + 2], currentY + args[i + 3]);
            lastCpX = currentX + args[i];
            lastCpY = currentY + args[i + 1];
            currentX += args[i + 2];
            currentY += args[i + 3];
          }
          break;
        case 'T':
          for (var i = 0; i < args.length; i += 2) {
            final cpx = lastCommand == 'Q' || lastCommand == 'q' || lastCommand == 'T' || lastCommand == 't'
                ? currentX * 2 - (lastCpX ?? currentX)
                : currentX;
            final cpy = lastCommand == 'Q' || lastCommand == 'q' || lastCommand == 'T' || lastCommand == 't'
                ? currentY * 2 - (lastCpY ?? currentY)
                : currentY;
            quadraticCurveTo(cpx, cpy, args[i], args[i + 1]);
            lastCpX = cpx;
            lastCpY = cpy;
            currentX = args[i];
            currentY = args[i + 1];
          }
          break;
        case 't':
          for (var i = 0; i < args.length; i += 2) {
            final cpx = lastCommand == 'Q' || lastCommand == 'q' || lastCommand == 'T' || lastCommand == 't'
                ? currentX * 2 - (lastCpX ?? currentX)
                : currentX;
            final cpy = lastCommand == 'Q' || lastCommand == 'q' || lastCommand == 'T' || lastCommand == 't'
                ? currentY * 2 - (lastCpY ?? currentY)
                : currentY;
            quadraticCurveTo(cpx, cpy, currentX + args[i], currentY + args[i + 1]);
            lastCpX = cpx;
            lastCpY = cpy;
            currentX += args[i];
            currentY += args[i + 1];
          }
          break;
        case 'A':
        case 'a':
          // Arc commands - simplified implementation
          for (var i = 0; i < args.length; i += 7) {
            final endX = command == 'A' ? args[i + 5] : currentX + args[i + 5];
            final endY = command == 'A' ? args[i + 6] : currentY + args[i + 6];
            // For simplicity, draw a line to the endpoint
            // A full implementation would convert elliptical arc to bezier curves
            lineTo(endX, endY);
            currentX = endX;
            currentY = endY;
          }
          break;
        case 'Z':
        case 'z':
          closePath();
          break;
      }
      lastCommand = command;
    }
  }
  
  List<double> _parseNumbers(String str) {
    final regex = RegExp(r'-?[0-9]*\.?[0-9]+(?:[eE][-+]?[0-9]+)?');
    return regex.allMatches(str)
        .map((m) => double.parse(m.group(0)!))
        .toList();
  }
}

/// 2D transformation matrix
class Matrix2D {
  final double a, b, c, d, e, f;
  
  const Matrix2D(this.a, this.b, this.c, this.d, this.e, this.f);
  
  factory Matrix2D.identity() => const Matrix2D(1, 0, 0, 1, 0, 0);
  
  Matrix2D clone() => Matrix2D(a, b, c, d, e, f);
  
  Matrix2D multiplied(Matrix2D other) {
    return Matrix2D(
      a * other.a + c * other.b,
      b * other.a + d * other.b,
      a * other.c + c * other.d,
      b * other.c + d * other.d,
      a * other.e + c * other.f + e,
      b * other.e + d * other.f + f,
    );
  }
  
  Matrix2D translated(double tx, double ty) {
    return Matrix2D(a, b, c, d, e + tx, f + ty);
  }
  
  Matrix2D scaled(double sx, double sy) {
    return Matrix2D(a * sx, b * sx, c * sy, d * sy, e, f);
  }
  
  Matrix2D rotated(double angle) {
    final cos = math.cos(angle);
    final sin = math.sin(angle);
    return Matrix2D(
      a * cos + c * sin,
      b * cos + d * sin,
      c * cos - a * sin,
      d * cos - b * sin,
      e, f,
    );
  }
}

// Internal path command types
enum _PathCommandType {
  moveTo, lineTo, bezierCurveTo, quadraticCurveTo,
  arc, arcTo, ellipse, rect, roundRect, close
}

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
  
  const _PathCommand._({
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
  
  factory _PathCommand.moveTo(double x, double y) =>
      _PathCommand._(type: _PathCommandType.moveTo, x: x, y: y);
  
  factory _PathCommand.lineTo(double x, double y) =>
      _PathCommand._(type: _PathCommandType.lineTo, x: x, y: y);
  
  factory _PathCommand.bezierCurveTo(double cp1x, double cp1y, double cp2x, double cp2y, double x, double y) =>
      _PathCommand._(type: _PathCommandType.bezierCurveTo, cp1x: cp1x, cp1y: cp1y, cp2x: cp2x, cp2y: cp2y, x: x, y: y);
  
  factory _PathCommand.quadraticCurveTo(double cpx, double cpy, double x, double y) =>
      _PathCommand._(type: _PathCommandType.quadraticCurveTo, cpx: cpx, cpy: cpy, x: x, y: y);
  
  factory _PathCommand.arc(double x, double y, double radius, double startAngle, double endAngle, bool counterclockwise) =>
      _PathCommand._(type: _PathCommandType.arc, x: x, y: y, radius: radius, startAngle: startAngle, endAngle: endAngle, counterclockwise: counterclockwise);
  
  factory _PathCommand.arcTo(double x1, double y1, double x2, double y2, double radius) =>
      _PathCommand._(type: _PathCommandType.arcTo, x1: x1, y1: y1, x2: x2, y2: y2, radius: radius);
  
  factory _PathCommand.ellipse(double x, double y, double radiusX, double radiusY, double rotation, double startAngle, double endAngle, bool counterclockwise) =>
      _PathCommand._(type: _PathCommandType.ellipse, x: x, y: y, radiusX: radiusX, radiusY: radiusY, rotation: rotation, startAngle: startAngle, endAngle: endAngle, counterclockwise: counterclockwise);
  
  factory _PathCommand.rect(double x, double y, double width, double height) =>
      _PathCommand._(type: _PathCommandType.rect, x: x, y: y, width: width, height: height);
  
  factory _PathCommand.roundRect(double x, double y, double width, double height, double tl, double tr, double br, double bl) =>
      _PathCommand._(type: _PathCommandType.roundRect, x: x, y: y, width: width, height: height, topLeft: tl, topRight: tr, bottomRight: br, bottomLeft: bl);
  
  factory _PathCommand.close() =>
      const _PathCommand._(type: _PathCommandType.close);
  
  /// Creates a transformed copy of this command
  _PathCommand transformed(DOMMatrix m) {
    // Helper to transform a point
    ({double x, double y}) transformPoint(double x, double y) {
      return m.transformPoint(x, y);
    }
    
    switch (type) {
      case _PathCommandType.moveTo:
        final p = transformPoint(x!, y!);
        return _PathCommand.moveTo(p.x, p.y);
        
      case _PathCommandType.lineTo:
        final p = transformPoint(x!, y!);
        return _PathCommand.lineTo(p.x, p.y);
        
      case _PathCommandType.bezierCurveTo:
        final cp1 = transformPoint(cp1x!, cp1y!);
        final cp2 = transformPoint(cp2x!, cp2y!);
        final p = transformPoint(x!, y!);
        return _PathCommand.bezierCurveTo(cp1.x, cp1.y, cp2.x, cp2.y, p.x, p.y);
        
      case _PathCommandType.quadraticCurveTo:
        final cp = transformPoint(cpx!, cpy!);
        final p = transformPoint(x!, y!);
        return _PathCommand.quadraticCurveTo(cp.x, cp.y, p.x, p.y);
        
      case _PathCommandType.arc:
        final center = transformPoint(x!, y!);
        // Note: Arc radius and angles would need more complex transformation
        // for non-uniform scaling. For now, use the average scale.
        return _PathCommand.arc(center.x, center.y, radius!, startAngle!, endAngle!, counterclockwise!);
        
      case _PathCommandType.arcTo:
        final p1 = transformPoint(x1!, y1!);
        final p2 = transformPoint(x2!, y2!);
        return _PathCommand.arcTo(p1.x, p1.y, p2.x, p2.y, radius!);
        
      case _PathCommandType.ellipse:
        final center = transformPoint(x!, y!);
        return _PathCommand.ellipse(center.x, center.y, radiusX!, radiusY!, rotation!, startAngle!, endAngle!, counterclockwise!);
        
      case _PathCommandType.rect:
        final p = transformPoint(x!, y!);
        return _PathCommand.rect(p.x, p.y, width!, height!);
        
      case _PathCommandType.roundRect:
        final p = transformPoint(x!, y!);
        return _PathCommand.roundRect(p.x, p.y, width!, height!, topLeft!, topRight!, bottomRight!, bottomLeft!);
        
      case _PathCommandType.close:
        return this;
    }
  }
}
