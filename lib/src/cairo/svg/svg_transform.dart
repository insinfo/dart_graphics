/// SVG Transform parsing and application for Cairo
/// 
/// This module handles parsing SVG transform attributes and converting them
/// to Cairo transformation operations.

import 'dart:math' as math;

/// Represents a 2D transformation matrix [a, b, c, d, e, f]
/// which maps points as: x' = ax + cy + e, y' = bx + dy + f
class CairoSvgTransform {
  final List<double> matrix;
  
  CairoSvgTransform(this.matrix) {
    assert(matrix.length == 6);
  }
  
  /// Identity transform
  factory CairoSvgTransform.identity() {
    return CairoSvgTransform([1, 0, 0, 1, 0, 0]);
  }
  
  /// Translation transform
  factory CairoSvgTransform.translate(double tx, double ty) {
    return CairoSvgTransform([1, 0, 0, 1, tx, ty]);
  }
  
  /// Scale transform
  factory CairoSvgTransform.scale(double sx, [double? sy]) {
    sy ??= sx;
    return CairoSvgTransform([sx, 0, 0, sy, 0, 0]);
  }
  
  /// Rotation transform (angle in degrees)
  factory CairoSvgTransform.rotate(double angle, [double cx = 0, double cy = 0]) {
    final rad = angle * math.pi / 180.0;
    final cos = math.cos(rad);
    final sin = math.sin(rad);
    
    if (cx == 0 && cy == 0) {
      return CairoSvgTransform([cos, sin, -sin, cos, 0, 0]);
    }
    
    // Rotate around point (cx, cy)
    // T(cx, cy) * R(angle) * T(-cx, -cy)
    return CairoSvgTransform([
      cos,
      sin,
      -sin,
      cos,
      -cx * cos + cy * sin + cx,
      -cx * sin - cy * cos + cy,
    ]);
  }
  
  /// Skew X transform (angle in degrees)
  factory CairoSvgTransform.skewX(double angle) {
    final rad = angle * math.pi / 180.0;
    final tan = math.tan(rad);
    return CairoSvgTransform([1, 0, tan, 1, 0, 0]);
  }
  
  /// Skew Y transform (angle in degrees)
  factory CairoSvgTransform.skewY(double angle) {
    final rad = angle * math.pi / 180.0;
    final tan = math.tan(rad);
    return CairoSvgTransform([1, tan, 0, 1, 0, 0]);
  }
  
  /// Matrix transform
  factory CairoSvgTransform.matrix(
    double a, double b, double c, double d, double e, double f) {
    return CairoSvgTransform([a, b, c, d, e, f]);
  }
  
  /// Multiply this transform by another
  CairoSvgTransform multiply(CairoSvgTransform other) {
    final a1 = matrix[0], b1 = matrix[1], c1 = matrix[2];
    final d1 = matrix[3], e1 = matrix[4], f1 = matrix[5];
    
    final a2 = other.matrix[0], b2 = other.matrix[1], c2 = other.matrix[2];
    final d2 = other.matrix[3], e2 = other.matrix[4], f2 = other.matrix[5];
    
    return CairoSvgTransform([
      a1 * a2 + c1 * b2,
      b1 * a2 + d1 * b2,
      a1 * c2 + c1 * d2,
      b1 * c2 + d1 * d2,
      a1 * e2 + c1 * f2 + e1,
      b1 * e2 + d1 * f2 + f1,
    ]);
  }
  
  /// Get the translation components
  double get tx => matrix[4];
  double get ty => matrix[5];
  
  /// Get the scale components (approximation)
  double get scaleX => matrix[0];
  double get scaleY => matrix[3];
  
  /// Get the skew components
  double get skewX => matrix[2];
  double get skewY => matrix[1];
  
  /// Parse SVG transform string
  static CairoSvgTransform? parse(String? transformStr) {
    if (transformStr == null || transformStr.trim().isEmpty) {
      return null;
    }
    
    var result = CairoSvgTransform.identity();
    final str = transformStr.trim();
    
    // Match transform functions: translate(...), scale(...), etc.
    final regex = RegExp(r'(\w+)\s*\(([^)]*)\)');
    final matches = regex.allMatches(str);
    
    for (final match in matches) {
      final funcName = match.group(1)!;
      final argsStr = match.group(2)!.trim();
      final args = _parseArgs(argsStr);
      
      CairoSvgTransform? transform;
      
      switch (funcName.toLowerCase()) {
        case 'translate':
          if (args.isNotEmpty) {
            final tx = args[0];
            final ty = args.length >= 2 ? args[1] : 0.0;
            transform = CairoSvgTransform.translate(tx, ty);
          }
          break;
          
        case 'scale':
          if (args.isNotEmpty) {
            final sx = args[0];
            final sy = args.length >= 2 ? args[1] : sx;
            transform = CairoSvgTransform.scale(sx, sy);
          }
          break;
          
        case 'rotate':
          if (args.isNotEmpty) {
            final angle = args[0];
            if (args.length >= 3) {
              final cx = args[1];
              final cy = args[2];
              transform = CairoSvgTransform.rotate(angle, cx, cy);
            } else {
              transform = CairoSvgTransform.rotate(angle);
            }
          }
          break;
          
        case 'skewx':
          if (args.isNotEmpty) {
            transform = CairoSvgTransform.skewX(args[0]);
          }
          break;
          
        case 'skewy':
          if (args.isNotEmpty) {
            transform = CairoSvgTransform.skewY(args[0]);
          }
          break;
          
        case 'matrix':
          if (args.length >= 6) {
            transform = CairoSvgTransform.matrix(
              args[0], args[1], args[2], args[3], args[4], args[5]);
          }
          break;
      }
      
      if (transform != null) {
        result = result.multiply(transform);
      }
    }
    
    return result;
  }
  
  /// Parse space/comma separated numbers
  static List<double> _parseArgs(String str) {
    final args = <double>[];
    final regex = RegExp(r'-?\d*\.?\d+(?:[eE][+-]?\d+)?');
    
    for (final match in regex.allMatches(str)) {
      final value = double.tryParse(match.group(0)!);
      if (value != null) {
        args.add(value);
      }
    }
    
    return args;
  }
  
  @override
  String toString() => 'CairoSvgTransform(${matrix.join(', ')})';
}
