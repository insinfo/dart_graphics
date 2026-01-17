/// CanvasGradient - DartGraphics implementation of HTML5 Canvas gradient
/// 
/// Represents either a linear or radial gradient that can be used
/// as a fill or stroke style.

import 'package:dart_graphics/src/shared/canvas2d/canvas2d.dart';

import '../primitives/color.dart';
import '../spans/span_gradient.dart';

/// Gradient type enumeration
enum _GradientType { linear, radial, conic }

/// Represents a gradient (linear or radial) for use with Canvas fill/stroke styles
class DartGraphicsCanvasGradient implements ICanvasGradient {
  final _GradientType _type;
  final List<_ColorStop> _stops = [];
  
  // Linear gradient params
  final double _x0, _y0, _x1, _y1;
  
  // Radial gradient params (r0 for inner circle, r1 for outer)
  final double _r0, _r1;
  
  // Conic gradient params
  final double _startAngle;
  
  /// Creates a linear gradient
  DartGraphicsCanvasGradient.linear(double x0, double y0, double x1, double y1)
      : _type = _GradientType.linear,
        _x0 = x0,
        _y0 = y0,
        _x1 = x1,
        _y1 = y1,
        _r0 = 0,
        _r1 = 0,
        _startAngle = 0;
  
  /// Creates a radial gradient
  DartGraphicsCanvasGradient.radial(double x0, double y0, double r0, double x1, double y1, double r1)
      : _type = _GradientType.radial,
        _x0 = x0,
        _y0 = y0,
        _x1 = x1,
        _y1 = y1,
        _r0 = r0,
        _r1 = r1,
        _startAngle = 0;
  
  /// Creates a conic gradient
  DartGraphicsCanvasGradient.conic(double startAngle, double x, double y)
      : _type = _GradientType.conic,
        _x0 = x,
        _y0 = y,
        _x1 = x,
        _y1 = y,
        _r0 = 0,
        _r1 = 0,
        _startAngle = startAngle;
  
  /// Whether this is a linear gradient
  bool get isLinear => _type == _GradientType.linear;
  
  /// Whether this is a radial gradient
  bool get isRadial => _type == _GradientType.radial;
  
  /// Whether this is a conic gradient
  bool get isConic => _type == _GradientType.conic;
  
  /// The inner radius for radial gradients
  double get innerRadius => _r0;
  
  /// The start angle for conic gradients (in radians)
  double get startAngle => _startAngle;
  
  /// Adds a color stop to the gradient
  /// 
  /// [offset] must be between 0.0 and 1.0
  /// [color] is a CSS color string (hex, rgb, rgba, named colors)
  @override
  void addColorStop(double offset, String color) {
    if (offset < 0.0 || offset > 1.0) {
      throw RangeError('Color stop offset must be between 0.0 and 1.0');
    }
    _stops.add(_ColorStop(offset, color));
    _stops.sort((a, b) => a.offset.compareTo(b.offset));
  }
  
  /// Gets the color stops
  List<({double offset, Color color})> get colorStops {
    return _stops.map((stop) {
      return (offset: stop.offset, color: _parseColor(stop.color));
    }).toList();
  }
  
  /// Creates an DartGraphics SpanGradient for rendering
  SpanGradient? createSpanGradient() {
    if (_stops.isEmpty) return null;
    
    SpanGradient gradient;
    
    if (_type == _GradientType.linear) {
      gradient = SpanGradientLinear(_x0, _y0, _x1, _y1);
    } else if (_type == _GradientType.radial) {
      // For radial gradient, use the outer circle center and radius
      gradient = SpanGradientRadial(_x1, _y1, _r1);
    } else {
      // Conic gradient - not directly supported by DartGraphics, fallback to linear
      gradient = SpanGradientLinear(_x0, _y0, _x0 + 100, _y0);
    }
    
    // Build the color lookup table
    final stops = colorStops;
    gradient.buildLut(stops);
    
    return gradient;
  }
  
  /// Gets the color at a given position (0..1)
  Color getColorAt(double t) {
    if (_stops.isEmpty) {
      return Color.black;
    }
    
    t = t.clamp(0.0, 1.0);
    
    // Find the two stops to interpolate between
    final stops = colorStops;
    
    if (t <= stops.first.offset) {
      return stops.first.color;
    }
    if (t >= stops.last.offset) {
      return stops.last.color;
    }
    
    for (int i = 0; i < stops.length - 1; i++) {
      if (t >= stops[i].offset && t <= stops[i + 1].offset) {
        final t0 = stops[i].offset;
        final t1 = stops[i + 1].offset;
        final localT = (t - t0) / (t1 - t0);
        
        return _interpolateColor(stops[i].color, stops[i + 1].color, localT);
      }
    }
    
    return stops.last.color;
  }
  
  Color _interpolateColor(Color c0, Color c1, double t) {
    return Color.fromRgba(
      (c0.red + (c1.red - c0.red) * t).round(),
      (c0.green + (c1.green - c0.green) * t).round(),
      (c0.blue + (c1.blue - c0.blue) * t).round(),
      (c0.alpha + (c1.alpha - c0.alpha) * t).round(),
    );
  }
  
  /// Parses a CSS color string to Color
  Color _parseColor(String colorStr) {
    colorStr = colorStr.trim().toLowerCase();
    
    // Named colors
    final namedColors = _namedColors[colorStr];
    if (namedColors != null) {
      return Color.fromHex(namedColors);
    }
    
    // Hex colors
    if (colorStr.startsWith('#')) {
      return _parseHexColor(colorStr);
    }
    
    // rgb/rgba colors
    if (colorStr.startsWith('rgb')) {
      return _parseRgbColor(colorStr);
    }
    
    return Color.black;
  }
  
  Color _parseHexColor(String hex) {
    hex = hex.substring(1);
    
    int r, g, b, a = 255;
    
    if (hex.length == 3) {
      r = int.parse(hex[0] + hex[0], radix: 16);
      g = int.parse(hex[1] + hex[1], radix: 16);
      b = int.parse(hex[2] + hex[2], radix: 16);
    } else if (hex.length == 4) {
      r = int.parse(hex[0] + hex[0], radix: 16);
      g = int.parse(hex[1] + hex[1], radix: 16);
      b = int.parse(hex[2] + hex[2], radix: 16);
      a = int.parse(hex[3] + hex[3], radix: 16);
    } else if (hex.length == 6) {
      r = int.parse(hex.substring(0, 2), radix: 16);
      g = int.parse(hex.substring(2, 4), radix: 16);
      b = int.parse(hex.substring(4, 6), radix: 16);
    } else if (hex.length == 8) {
      r = int.parse(hex.substring(0, 2), radix: 16);
      g = int.parse(hex.substring(2, 4), radix: 16);
      b = int.parse(hex.substring(4, 6), radix: 16);
      a = int.parse(hex.substring(6, 8), radix: 16);
    } else {
      return Color.black;
    }
    
    return Color.fromRgba(r, g, b, a);
  }
  
  Color _parseRgbColor(String rgb) {
    final isRgba = rgb.startsWith('rgba');
    final start = isRgba ? 5 : 4;
    final end = rgb.length - 1;
    final parts = rgb.substring(start, end).split(',').map((s) => s.trim()).toList();
    
    if (parts.length < 3) return Color.black;
    
    final r = _parseColorComponent(parts[0]).round();
    final g = _parseColorComponent(parts[1]).round();
    final b = _parseColorComponent(parts[2]).round();
    final a = parts.length > 3 
        ? ((double.tryParse(parts[3]) ?? 1.0) * 255).round()
        : 255;
    
    return Color.fromRgba(
      r.clamp(0, 255), 
      g.clamp(0, 255), 
      b.clamp(0, 255), 
      a.clamp(0, 255),
    );
  }
  
  double _parseColorComponent(String value) {
    if (value.endsWith('%')) {
      return (double.tryParse(value.substring(0, value.length - 1)) ?? 0) * 2.55;
    }
    return double.tryParse(value) ?? 0;
  }
}

/// Internal color stop class
class _ColorStop {
  final double offset;
  final String color;
  
  _ColorStop(this.offset, this.color);
}

/// Named CSS colors
const Map<String, String> _namedColors = {
  'transparent': '#00000000',
  'black': '#000000',
  'white': '#FFFFFF',
  'red': '#FF0000',
  'green': '#008000',
  'blue': '#0000FF',
  'yellow': '#FFFF00',
  'cyan': '#00FFFF',
  'magenta': '#FF00FF',
  'orange': '#FFA500',
  'purple': '#800080',
  'pink': '#FFC0CB',
  'brown': '#A52A2A',
  'gray': '#808080',
  'grey': '#808080',
  'silver': '#C0C0C0',
  'gold': '#FFD700',
  'navy': '#000080',
  'teal': '#008080',
  'olive': '#808000',
  'lime': '#00FF00',
  'aqua': '#00FFFF',
  'maroon': '#800000',
  'fuchsia': '#FF00FF',
  'coral': '#FF7F50',
  'salmon': '#FA8072',
  'tomato': '#FF6347',
  'crimson': '#DC143C',
  'darkred': '#8B0000',
  'darkgreen': '#006400',
  'darkblue': '#00008B',
  'darkcyan': '#008B8B',
  'darkmagenta': '#8B008B',
  'darkorange': '#FF8C00',
  'darkviolet': '#9400D3',
  'deeppink': '#FF1493',
  'deepskyblue': '#00BFFF',
  'dimgray': '#696969',
  'dimgrey': '#696969',
  'dodgerblue': '#1E90FF',
  'firebrick': '#B22222',
  'forestgreen': '#228B22',
  'gainsboro': '#DCDCDC',
  'ghostwhite': '#F8F8FF',
  'goldenrod': '#DAA520',
  'greenyellow': '#ADFF2F',
  'honeydew': '#F0FFF0',
  'hotpink': '#FF69B4',
  'indianred': '#CD5C5C',
  'indigo': '#4B0082',
  'ivory': '#FFFFF0',
  'khaki': '#F0E68C',
  'lavender': '#E6E6FA',
  'lawngreen': '#7CFC00',
  'lightblue': '#ADD8E6',
  'lightcoral': '#F08080',
  'lightcyan': '#E0FFFF',
  'lightgray': '#D3D3D3',
  'lightgrey': '#D3D3D3',
  'lightgreen': '#90EE90',
  'lightpink': '#FFB6C1',
  'lightsalmon': '#FFA07A',
  'lightseagreen': '#20B2AA',
  'lightskyblue': '#87CEFA',
  'lightslategray': '#778899',
  'lightslategrey': '#778899',
  'lightsteelblue': '#B0C4DE',
  'lightyellow': '#FFFFE0',
  'limegreen': '#32CD32',
  'linen': '#FAF0E6',
};
