/// SVG Path parsing for Cairo
/// 
/// This module handles parsing SVG path data (the 'd' attribute) and
/// converting it to Cairo path operations.

import 'dart:math' as math;
import '../cairo_api.dart';

/// SVG path command types
enum CairoSvgPathCommandType {
  moveTo,
  lineTo,
  horizontalLineTo,
  verticalLineTo,
  curveTo,
  smoothCurveTo,
  quadraticCurveTo,
  smoothQuadraticCurveTo,
  arcTo,
  closePath,
}

/// A single SVG path command
class CairoSvgPathCommand {
  final CairoSvgPathCommandType type;
  final bool relative;
  final List<double> args;
  
  const CairoSvgPathCommand(this.type, this.args, {this.relative = false});
}

/// SVG Path parser and renderer for Cairo
class CairoSvgPath {
  final List<CairoSvgPathCommand> commands;
  
  CairoSvgPath(this.commands);
  
  /// Parse an SVG path string (d attribute)
  factory CairoSvgPath.parse(String pathData) {
    final commands = <CairoSvgPathCommand>[];
    final regex = RegExp(r'([MmLlHhVvCcSsQqTtAaZz])([^MmLlHhVvCcSsQqTtAaZz]*)');
    
    for (final match in regex.allMatches(pathData)) {
      final command = match.group(1)!;
      final argsStr = match.group(2)!.trim();
      
      // Parse numbers from the arguments
      final args = <double>[];
      if (argsStr.isNotEmpty) {
        // Handle negative numbers and comma/space separators
        final numRegex = RegExp(r'-?\d*\.?\d+(?:[eE][+-]?\d+)?');
        for (final numMatch in numRegex.allMatches(argsStr)) {
          args.add(double.parse(numMatch.group(0)!));
        }
      }
      
      final relative = command.toLowerCase() == command;
      
      switch (command.toUpperCase()) {
        case 'M':
          commands.add(CairoSvgPathCommand(CairoSvgPathCommandType.moveTo, args, relative: relative));
        case 'L':
          commands.add(CairoSvgPathCommand(CairoSvgPathCommandType.lineTo, args, relative: relative));
        case 'H':
          commands.add(CairoSvgPathCommand(CairoSvgPathCommandType.horizontalLineTo, args, relative: relative));
        case 'V':
          commands.add(CairoSvgPathCommand(CairoSvgPathCommandType.verticalLineTo, args, relative: relative));
        case 'C':
          commands.add(CairoSvgPathCommand(CairoSvgPathCommandType.curveTo, args, relative: relative));
        case 'S':
          commands.add(CairoSvgPathCommand(CairoSvgPathCommandType.smoothCurveTo, args, relative: relative));
        case 'Q':
          commands.add(CairoSvgPathCommand(CairoSvgPathCommandType.quadraticCurveTo, args, relative: relative));
        case 'T':
          commands.add(CairoSvgPathCommand(CairoSvgPathCommandType.smoothQuadraticCurveTo, args, relative: relative));
        case 'A':
          commands.add(CairoSvgPathCommand(CairoSvgPathCommandType.arcTo, args, relative: relative));
        case 'Z':
          commands.add(CairoSvgPathCommand(CairoSvgPathCommandType.closePath, [], relative: false));
      }
    }
    
    return CairoSvgPath(commands);
  }
  
  /// Render this path to a Cairo canvas
  void render(CairoCanvasImpl canvas) {
    double currentX = 0;
    double currentY = 0;
    double startX = 0;
    double startY = 0;
    double lastControlX = 0;
    double lastControlY = 0;
    CairoSvgPathCommandType? lastCommand;
    
    for (final cmd in commands) {
      switch (cmd.type) {
        case CairoSvgPathCommandType.moveTo:
          _handleMoveTo(cmd, canvas, 
            relative: cmd.relative,
            currentX: currentX, currentY: currentY,
            onUpdate: (x, y) { currentX = x; currentY = y; startX = x; startY = y; }
          );
        
        case CairoSvgPathCommandType.lineTo:
          _handleLineTo(cmd, canvas,
            relative: cmd.relative,
            currentX: currentX, currentY: currentY,
            onUpdate: (x, y) { currentX = x; currentY = y; }
          );
        
        case CairoSvgPathCommandType.horizontalLineTo:
          for (var i = 0; i < cmd.args.length; i++) {
            final x = cmd.relative ? currentX + cmd.args[i] : cmd.args[i];
            canvas.lineTo(x, currentY);
            currentX = x;
          }
        
        case CairoSvgPathCommandType.verticalLineTo:
          for (var i = 0; i < cmd.args.length; i++) {
            final y = cmd.relative ? currentY + cmd.args[i] : cmd.args[i];
            canvas.lineTo(currentX, y);
            currentY = y;
          }
        
        case CairoSvgPathCommandType.curveTo:
          for (var i = 0; i + 5 < cmd.args.length; i += 6) {
            double x1, y1, x2, y2, x3, y3;
            if (cmd.relative) {
              x1 = currentX + cmd.args[i];
              y1 = currentY + cmd.args[i + 1];
              x2 = currentX + cmd.args[i + 2];
              y2 = currentY + cmd.args[i + 3];
              x3 = currentX + cmd.args[i + 4];
              y3 = currentY + cmd.args[i + 5];
            } else {
              x1 = cmd.args[i];
              y1 = cmd.args[i + 1];
              x2 = cmd.args[i + 2];
              y2 = cmd.args[i + 3];
              x3 = cmd.args[i + 4];
              y3 = cmd.args[i + 5];
            }
            canvas.curveTo(x1, y1, x2, y2, x3, y3);
            lastControlX = x2;
            lastControlY = y2;
            currentX = x3;
            currentY = y3;
          }
        
        case CairoSvgPathCommandType.smoothCurveTo:
          for (var i = 0; i + 3 < cmd.args.length; i += 4) {
            // Reflect the last control point
            double x1, y1;
            if (lastCommand == CairoSvgPathCommandType.curveTo || 
                lastCommand == CairoSvgPathCommandType.smoothCurveTo) {
              x1 = 2 * currentX - lastControlX;
              y1 = 2 * currentY - lastControlY;
            } else {
              x1 = currentX;
              y1 = currentY;
            }
            
            double x2, y2, x3, y3;
            if (cmd.relative) {
              x2 = currentX + cmd.args[i];
              y2 = currentY + cmd.args[i + 1];
              x3 = currentX + cmd.args[i + 2];
              y3 = currentY + cmd.args[i + 3];
            } else {
              x2 = cmd.args[i];
              y2 = cmd.args[i + 1];
              x3 = cmd.args[i + 2];
              y3 = cmd.args[i + 3];
            }
            
            canvas.curveTo(x1, y1, x2, y2, x3, y3);
            lastControlX = x2;
            lastControlY = y2;
            currentX = x3;
            currentY = y3;
          }
        
        case CairoSvgPathCommandType.quadraticCurveTo:
          for (var i = 0; i + 3 < cmd.args.length; i += 4) {
            double qx, qy, x, y;
            if (cmd.relative) {
              qx = currentX + cmd.args[i];
              qy = currentY + cmd.args[i + 1];
              x = currentX + cmd.args[i + 2];
              y = currentY + cmd.args[i + 3];
            } else {
              qx = cmd.args[i];
              qy = cmd.args[i + 1];
              x = cmd.args[i + 2];
              y = cmd.args[i + 3];
            }
            
            // Convert quadratic to cubic Bezier
            final cx1 = currentX + 2.0 / 3.0 * (qx - currentX);
            final cy1 = currentY + 2.0 / 3.0 * (qy - currentY);
            final cx2 = x + 2.0 / 3.0 * (qx - x);
            final cy2 = y + 2.0 / 3.0 * (qy - y);
            
            canvas.curveTo(cx1, cy1, cx2, cy2, x, y);
            lastControlX = qx;
            lastControlY = qy;
            currentX = x;
            currentY = y;
          }
        
        case CairoSvgPathCommandType.smoothQuadraticCurveTo:
          for (var i = 0; i + 1 < cmd.args.length; i += 2) {
            // Reflect the last control point
            double qx, qy;
            if (lastCommand == CairoSvgPathCommandType.quadraticCurveTo || 
                lastCommand == CairoSvgPathCommandType.smoothQuadraticCurveTo) {
              qx = 2 * currentX - lastControlX;
              qy = 2 * currentY - lastControlY;
            } else {
              qx = currentX;
              qy = currentY;
            }
            
            double x, y;
            if (cmd.relative) {
              x = currentX + cmd.args[i];
              y = currentY + cmd.args[i + 1];
            } else {
              x = cmd.args[i];
              y = cmd.args[i + 1];
            }
            
            // Convert quadratic to cubic Bezier
            final cx1 = currentX + 2.0 / 3.0 * (qx - currentX);
            final cy1 = currentY + 2.0 / 3.0 * (qy - currentY);
            final cx2 = x + 2.0 / 3.0 * (qx - x);
            final cy2 = y + 2.0 / 3.0 * (qy - y);
            
            canvas.curveTo(cx1, cy1, cx2, cy2, x, y);
            lastControlX = qx;
            lastControlY = qy;
            currentX = x;
            currentY = y;
          }
        
        case CairoSvgPathCommandType.arcTo:
          for (var i = 0; i + 6 < cmd.args.length; i += 7) {
            final rx = cmd.args[i];
            final ry = cmd.args[i + 1];
            final rotation = cmd.args[i + 2] * math.pi / 180.0;
            final largeArc = cmd.args[i + 3] != 0;
            final sweep = cmd.args[i + 4] != 0;
            double x, y;
            if (cmd.relative) {
              x = currentX + cmd.args[i + 5];
              y = currentY + cmd.args[i + 6];
            } else {
              x = cmd.args[i + 5];
              y = cmd.args[i + 6];
            }
            
            _arcTo(canvas, currentX, currentY, rx, ry, rotation, largeArc, sweep, x, y);
            currentX = x;
            currentY = y;
          }
        
        case CairoSvgPathCommandType.closePath:
          canvas.closePath();
          currentX = startX;
          currentY = startY;
      }
      
      lastCommand = cmd.type;
    }
  }
  
  void _handleMoveTo(CairoSvgPathCommand cmd, CairoCanvasImpl canvas, {
    required bool relative,
    required double currentX,
    required double currentY,
    required void Function(double x, double y) onUpdate,
  }) {
    if (cmd.args.length >= 2) {
      double x = relative ? currentX + cmd.args[0] : cmd.args[0];
      double y = relative ? currentY + cmd.args[1] : cmd.args[1];
      canvas.moveTo(x, y);
      onUpdate(x, y);
      
      // Additional coordinate pairs are implicit lineTo commands
      for (var i = 2; i + 1 < cmd.args.length; i += 2) {
        x = relative ? x + cmd.args[i] : cmd.args[i];
        y = relative ? y + cmd.args[i + 1] : cmd.args[i + 1];
        canvas.lineTo(x, y);
        onUpdate(x, y);
      }
    }
  }
  
  void _handleLineTo(CairoSvgPathCommand cmd, CairoCanvasImpl canvas, {
    required bool relative,
    required double currentX,
    required double currentY,
    required void Function(double x, double y) onUpdate,
  }) {
    double x = currentX;
    double y = currentY;
    for (var i = 0; i + 1 < cmd.args.length; i += 2) {
      x = relative ? x + cmd.args[i] : cmd.args[i];
      y = relative ? y + cmd.args[i + 1] : cmd.args[i + 1];
      canvas.lineTo(x, y);
      onUpdate(x, y);
    }
  }
  
  /// Convert SVG arc to Cairo curves (approximation using Bezier curves)
  void _arcTo(
    CairoCanvasImpl canvas,
    double x1, double y1,
    double rx, double ry,
    double phi,
    bool largeArc,
    bool sweep,
    double x2, double y2,
  ) {
    // Handle degenerate cases
    if (rx == 0 || ry == 0) {
      canvas.lineTo(x2, y2);
      return;
    }
    
    rx = rx.abs();
    ry = ry.abs();
    
    final cosPhi = math.cos(phi);
    final sinPhi = math.sin(phi);
    
    // Step 1: Compute (x1', y1')
    final dx = (x1 - x2) / 2;
    final dy = (y1 - y2) / 2;
    final x1p = cosPhi * dx + sinPhi * dy;
    final y1p = -sinPhi * dx + cosPhi * dy;
    
    // Step 2: Compute (cx', cy')
    final x1p2 = x1p * x1p;
    final y1p2 = y1p * y1p;
    var rx2 = rx * rx;
    var ry2 = ry * ry;
    
    // Check if radii are large enough
    final lambda = x1p2 / rx2 + y1p2 / ry2;
    if (lambda > 1) {
      final sqrtLambda = math.sqrt(lambda);
      rx *= sqrtLambda;
      ry *= sqrtLambda;
      rx2 = rx * rx;
      ry2 = ry * ry;
    }
    
    var sq = (rx2 * ry2 - rx2 * y1p2 - ry2 * x1p2) /
             (rx2 * y1p2 + ry2 * x1p2);
    sq = sq < 0 ? 0 : sq;
    final coef = (largeArc != sweep ? 1 : -1) * math.sqrt(sq);
    final cxp = coef * rx * y1p / ry;
    final cyp = -coef * ry * x1p / rx;
    
    // Step 3: Compute (cx, cy)
    final cx = cosPhi * cxp - sinPhi * cyp + (x1 + x2) / 2;
    final cy = sinPhi * cxp + cosPhi * cyp + (y1 + y2) / 2;
    
    // Step 4: Compute theta1 and dtheta
    final theta1 = _vectorAngle(1, 0, (x1p - cxp) / rx, (y1p - cyp) / ry);
    var dtheta = _vectorAngle(
      (x1p - cxp) / rx, (y1p - cyp) / ry,
      (-x1p - cxp) / rx, (-y1p - cyp) / ry,
    );
    
    if (!sweep && dtheta > 0) {
      dtheta -= 2 * math.pi;
    } else if (sweep && dtheta < 0) {
      dtheta += 2 * math.pi;
    }
    
    // Convert arc to bezier curves
    final numSegments = (dtheta.abs() / (math.pi / 2)).ceil();
    final delta = dtheta / numSegments;
    final t = (8 / 3) * math.sin(delta / 4) * math.sin(delta / 4) / math.sin(delta / 2);
    
    var angle = theta1;
    for (var i = 0; i < numSegments; i++) {
      final cosAngle = math.cos(angle);
      final sinAngle = math.sin(angle);
      final nextAngle = angle + delta;
      final cosNextAngle = math.cos(nextAngle);
      final sinNextAngle = math.sin(nextAngle);
      
      final ep2x = cx + rx * cosPhi * cosNextAngle - ry * sinPhi * sinNextAngle;
      final ep2y = cy + rx * sinPhi * cosNextAngle + ry * cosPhi * sinNextAngle;
      
      final cp1x = cx + rx * cosPhi * cosAngle - ry * sinPhi * sinAngle +
                   t * (-rx * cosPhi * sinAngle - ry * sinPhi * cosAngle);
      final cp1y = cy + rx * sinPhi * cosAngle + ry * cosPhi * sinAngle +
                   t * (-rx * sinPhi * sinAngle + ry * cosPhi * cosAngle);
      final cp2x = ep2x - t * (-rx * cosPhi * sinNextAngle - ry * sinPhi * cosNextAngle);
      final cp2y = ep2y - t * (-rx * sinPhi * sinNextAngle + ry * cosPhi * cosNextAngle);
      
      canvas.curveTo(cp1x, cp1y, cp2x, cp2y, ep2x, ep2y);
      angle = nextAngle;
    }
  }
  
  double _vectorAngle(double ux, double uy, double vx, double vy) {
    final sign = (ux * vy - uy * vx) < 0 ? -1 : 1;
    final dot = ux * vx + uy * vy;
    final len = math.sqrt(ux * ux + uy * uy) * math.sqrt(vx * vx + vy * vy);
    var angle = math.acos((dot / len).clamp(-1.0, 1.0));
    return sign * angle;
  }
}
