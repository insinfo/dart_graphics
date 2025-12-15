/// Canvas Gradient - HTML5-style gradient for Canvas 2D
/// 
/// Provides linear, radial, and conic gradient support.

import '../sk_color.dart';

/// A gradient that can be used as fill or stroke style
class CanvasGradient {
  final _GradientType _type;
  final List<_ColorStop> _colorStops = [];
  
  // Linear gradient parameters
  final double? _x0, _y0, _x1, _y1;
  
  // Radial gradient parameters
  final double? _r0, _r1;
  
  // Conic gradient parameters
  final double? _startAngle;
  
  CanvasGradient._linear(this._x0, this._y0, this._x1, this._y1)
      : _type = _GradientType.linear,
        _r0 = null,
        _r1 = null,
        _startAngle = null;
  
  CanvasGradient._radial(this._x0, this._y0, this._r0, this._x1, this._y1, this._r1)
      : _type = _GradientType.radial,
        _startAngle = null;
  
  CanvasGradient._conic(this._startAngle, double x, double y)
      : _type = _GradientType.conic,
        _x0 = x,
        _y0 = y,
        _x1 = null,
        _y1 = null,
        _r0 = null,
        _r1 = null;
  
  /// Creates a linear gradient from (x0, y0) to (x1, y1)
  factory CanvasGradient.linear(double x0, double y0, double x1, double y1) {
    return CanvasGradient._linear(x0, y0, x1, y1);
  }
  
  /// Creates a radial gradient with two circles
  factory CanvasGradient.radial(double x0, double y0, double r0, double x1, double y1, double r1) {
    return CanvasGradient._radial(x0, y0, r0, x1, y1, r1);
  }
  
  /// Creates a conic gradient starting at the given angle
  factory CanvasGradient.conic(double startAngle, double x, double y) {
    return CanvasGradient._conic(startAngle, x, y);
  }
  
  /// Adds a color stop to the gradient
  /// 
  /// [offset] must be between 0.0 and 1.0
  void addColorStop(double offset, String color) {
    if (offset < 0.0 || offset > 1.0) {
      throw RangeError('Color stop offset must be between 0 and 1');
    }
    _colorStops.add(_ColorStop(offset, color));
    _colorStops.sort((a, b) => a.offset.compareTo(b.offset));
  }
  
  /// Get the color stops
  List<({double offset, SKColor color})> get colorStops {
    return _colorStops.map((stop) => (
      offset: stop.offset,
      color: SKColor.parse(stop.color),
    )).toList();
  }
  
  /// Get gradient type
  _GradientType get type => _type;
  
  /// Linear gradient start point
  ({double x, double y})? get startPoint {
    if (_x0 != null && _y0 != null) {
      return (x: _x0, y: _y0);
    }
    return null;
  }
  
  /// Linear gradient end point
  ({double x, double y})? get endPoint {
    if (_x1 != null && _y1 != null) {
      return (x: _x1, y: _y1);
    }
    return null;
  }
  
  /// Radial gradient start radius
  double? get startRadius => _r0;
  
  /// Radial gradient end radius
  double? get endRadius => _r1;
  
  /// Conic gradient start angle
  double? get startAngle => _startAngle;
}

enum _GradientType { linear, radial, conic }

class _ColorStop {
  final double offset;
  final String color;
  
  _ColorStop(this.offset, this.color);
}
