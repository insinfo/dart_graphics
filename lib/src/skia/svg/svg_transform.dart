import 'dart:math' as math;

/// Represents a 2D transformation matrix [a, b, c, d, e, f]
/// which maps points as: x' = ax + cy + e, y' = bx + dy + f
class SvgTransform {
  final List<double> matrix;
  
  SvgTransform(this.matrix) {
    assert(matrix.length == 6);
  }
  
  /// Identity transform
  factory SvgTransform.identity() {
    return SvgTransform([1, 0, 0, 1, 0, 0]);
  }
  
  /// Translation transform
  factory SvgTransform.translate(double tx, double ty) {
    return SvgTransform([1, 0, 0, 1, tx, ty]);
  }
  
  /// Scale transform
  factory SvgTransform.scale(double sx, [double? sy]) {
    sy ??= sx;
    return SvgTransform([sx, 0, 0, sy, 0, 0]);
  }
  
  /// Rotation transform (angle in degrees)
  factory SvgTransform.rotate(double angle, [double cx = 0, double cy = 0]) {
    final rad = angle * math.pi / 180.0;
    final cos = math.cos(rad);
    final sin = math.sin(rad);
    
    if (cx == 0 && cy == 0) {
      return SvgTransform([cos, sin, -sin, cos, 0, 0]);
    }
    
    // Rotate around point (cx, cy)
    // T(cx, cy) * R(angle) * T(-cx, -cy)
    return SvgTransform([
      cos,
      sin,
      -sin,
      cos,
      -cx * cos + cy * sin + cx,
      -cx * sin - cy * cos + cy,
    ]);
  }
  
  /// Skew X transform (angle in degrees)
  factory SvgTransform.skewX(double angle) {
    final rad = angle * math.pi / 180.0;
    final tan = math.tan(rad);
    return SvgTransform([1, 0, tan, 1, 0, 0]);
  }
  
  /// Skew Y transform (angle in degrees)
  factory SvgTransform.skewY(double angle) {
    final rad = angle * math.pi / 180.0;
    final tan = math.tan(rad);
    return SvgTransform([1, tan, 0, 1, 0, 0]);
  }
  
  /// Matrix transform
  factory SvgTransform.matrix(
    double a, double b, double c, double d, double e, double f) {
    return SvgTransform([a, b, c, d, e, f]);
  }
  
  /// Multiply this transform by another
  SvgTransform multiply(SvgTransform other) {
    final a1 = matrix[0], b1 = matrix[1], c1 = matrix[2];
    final d1 = matrix[3], e1 = matrix[4], f1 = matrix[5];
    
    final a2 = other.matrix[0], b2 = other.matrix[1], c2 = other.matrix[2];
    final d2 = other.matrix[3], e2 = other.matrix[4], f2 = other.matrix[5];
    
    return SvgTransform([
      a1 * a2 + c1 * b2,
      b1 * a2 + d1 * b2,
      a1 * c2 + c1 * d2,
      b1 * c2 + d1 * d2,
      a1 * e2 + c1 * f2 + e1,
      b1 * e2 + d1 * f2 + f1,
    ]);
  }
  
  /// Parse SVG transform string
  static SvgTransform? parse(String? transformStr) {
    if (transformStr == null || transformStr.trim().isEmpty) {
      return null;
    }
    
    var result = SvgTransform.identity();
    final str = transformStr.trim();
    
    // Match transform functions: translate(...), scale(...), etc.
    final regex = RegExp(r'(\w+)\s*\(([^)]*)\)');
    final matches = regex.allMatches(str);
    
    for (final match in matches) {
      final funcName = match.group(1)!;
      final argsStr = match.group(2)!.trim();
      final args = _parseArgs(argsStr);
      
      SvgTransform? transform;
      
      switch (funcName.toLowerCase()) {
        case 'translate':
          if (args.length >= 1) {
            final tx = args[0];
            final ty = args.length >= 2 ? args[1] : 0.0;
            transform = SvgTransform.translate(tx, ty);
          }
          break;
          
        case 'scale':
          if (args.length >= 1) {
            final sx = args[0];
            final sy = args.length >= 2 ? args[1] : sx;
            transform = SvgTransform.scale(sx, sy);
          }
          break;
          
        case 'rotate':
          if (args.length >= 1) {
            final angle = args[0];
            if (args.length >= 3) {
              final cx = args[1];
              final cy = args[2];
              transform = SvgTransform.rotate(angle, cx, cy);
            } else {
              transform = SvgTransform.rotate(angle);
            }
          }
          break;
          
        case 'skewx':
          if (args.length >= 1) {
            transform = SvgTransform.skewX(args[0]);
          }
          break;
          
        case 'skewy':
          if (args.length >= 1) {
            transform = SvgTransform.skewY(args[0]);
          }
          break;
          
        case 'matrix':
          if (args.length >= 6) {
            transform = SvgTransform.matrix(
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
  
  /// Parse comma/space separated numbers
  static List<double> _parseArgs(String argsStr) {
    final args = <double>[];
    
    // Replace commas with spaces and split
    final parts = argsStr
        .replaceAll(',', ' ')
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty);
    
    for (final part in parts) {
      final value = double.tryParse(part);
      if (value != null) {
        args.add(value);
      }
    }
    
    return args;
  }
  
  @override
  String toString() {
    return 'matrix(${matrix.join(', ')})';
  }
}
