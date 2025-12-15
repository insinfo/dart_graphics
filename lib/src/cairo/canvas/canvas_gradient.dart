/// CanvasGradient - Cairo implementation of HTML5 Canvas gradient
/// 
/// Represents either a linear or radial gradient that can be used
/// as a fill or stroke style.

import '../cairo_api.dart';
import '../cairo_types.dart';
import '../cairo_pattern.dart';
import '../../shared/canvas2d/canvas2d.dart';

/// Represents a gradient (linear or radial) for use with Canvas fill/stroke styles
class CairoCanvasGradient implements ICanvasGradient {
  final Cairo _cairo;
  CairoPattern? _pattern;
  final List<_ColorStop> _stops = [];
  final bool _isLinear;
  
  // Linear gradient params
  final double? _x0, _y0, _x1, _y1;
  
  // Radial gradient params
  final double? _r0, _r1;
  
  /// Creates a linear gradient
  CairoCanvasGradient.linear(Cairo cairo, double x0, double y0, double x1, double y1)
      : _cairo = cairo,
        _isLinear = true,
        _x0 = x0,
        _y0 = y0,
        _x1 = x1,
        _y1 = y1,
        _r0 = null,
        _r1 = null;
  
  /// Creates a radial gradient
  CairoCanvasGradient.radial(Cairo cairo, double x0, double y0, double r0, double x1, double y1, double r1)
      : _cairo = cairo,
        _isLinear = false,
        _x0 = x0,
        _y0 = y0,
        _x1 = x1,
        _y1 = y1,
        _r0 = r0,
        _r1 = r1;
  
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
    _pattern = null; // Invalidate cached pattern
  }
  
  /// Gets the Cairo pattern for this gradient
  CairoPattern? getPattern() {
    if (_pattern != null) return _pattern;
    if (_stops.isEmpty) return null;
    
    CairoPattern pattern;
    
    if (_isLinear) {
      final linearGradient = LinearGradient(_cairo, _x0!, _y0!, _x1!, _y1!);
      for (final stop in _stops) {
        final color = _parseColor(stop.color);
        linearGradient.addColorStopRgba(stop.offset, color.r, color.g, color.b, color.a);
      }
      pattern = linearGradient;
    } else {
      final radialGradient = RadialGradient(_cairo, _x0!, _y0!, _r0!, _x1!, _y1!, _r1!);
      for (final stop in _stops) {
        final color = _parseColor(stop.color);
        radialGradient.addColorStopRgba(stop.offset, color.r, color.g, color.b, color.a);
      }
      pattern = radialGradient;
    }
    
    _pattern = pattern;
    return _pattern;
  }
  
  /// Parses a CSS color string to CairoColor
  CairoColor _parseColor(String colorStr) {
    colorStr = colorStr.trim().toLowerCase();
    
    // Named colors
    final namedColors = _namedColors[colorStr];
    if (namedColors != null) {
      return CairoColor.fromHex(namedColors);
    }
    
    // Hex colors
    if (colorStr.startsWith('#')) {
      return _parseHexColor(colorStr);
    }
    
    // rgb/rgba colors
    if (colorStr.startsWith('rgb')) {
      return _parseRgbColor(colorStr);
    }
    
    // Default to black
    return CairoColor.black;
  }
  
  CairoColor _parseHexColor(String hex) {
    hex = hex.substring(1); // Remove #
    
    int r, g, b;
    double a = 1.0;
    
    if (hex.length == 3) {
      r = int.parse(hex[0] + hex[0], radix: 16);
      g = int.parse(hex[1] + hex[1], radix: 16);
      b = int.parse(hex[2] + hex[2], radix: 16);
    } else if (hex.length == 4) {
      r = int.parse(hex[0] + hex[0], radix: 16);
      g = int.parse(hex[1] + hex[1], radix: 16);
      b = int.parse(hex[2] + hex[2], radix: 16);
      a = int.parse(hex[3] + hex[3], radix: 16) / 255.0;
    } else if (hex.length == 6) {
      r = int.parse(hex.substring(0, 2), radix: 16);
      g = int.parse(hex.substring(2, 4), radix: 16);
      b = int.parse(hex.substring(4, 6), radix: 16);
    } else if (hex.length == 8) {
      r = int.parse(hex.substring(0, 2), radix: 16);
      g = int.parse(hex.substring(2, 4), radix: 16);
      b = int.parse(hex.substring(4, 6), radix: 16);
      a = int.parse(hex.substring(6, 8), radix: 16) / 255.0;
    } else {
      return CairoColor.black;
    }
    
    return CairoColor(r / 255.0, g / 255.0, b / 255.0, a);
  }
  
  CairoColor _parseRgbColor(String rgb) {
    final isRgba = rgb.startsWith('rgba');
    final start = isRgba ? 5 : 4;
    final end = rgb.length - 1;
    final parts = rgb.substring(start, end).split(',').map((s) => s.trim()).toList();
    
    if (parts.length < 3) return CairoColor.black;
    
    final r = _parseColorComponent(parts[0]) / 255.0;
    final g = _parseColorComponent(parts[1]) / 255.0;
    final b = _parseColorComponent(parts[2]) / 255.0;
    final a = parts.length > 3 ? double.tryParse(parts[3]) ?? 1.0 : 1.0;
    
    return CairoColor(r.clamp(0.0, 1.0), g.clamp(0.0, 1.0), b.clamp(0.0, 1.0), a.clamp(0.0, 1.0));
  }
  
  double _parseColorComponent(String value) {
    if (value.endsWith('%')) {
      return (double.tryParse(value.substring(0, value.length - 1)) ?? 0) * 2.55;
    }
    return double.tryParse(value) ?? 0;
  }
  
  void dispose() {
    _pattern?.dispose();
    _pattern = null;
  }
}

class _ColorStop {
  final double offset;
  final String color;
  
  _ColorStop(this.offset, this.color);
}

/// Common named CSS colors
const Map<String, int> _namedColors = {
  'transparent': 0x00000000,
  'black': 0xFF000000,
  'white': 0xFFFFFFFF,
  'red': 0xFFFF0000,
  'green': 0xFF008000,
  'blue': 0xFF0000FF,
  'yellow': 0xFFFFFF00,
  'cyan': 0xFF00FFFF,
  'magenta': 0xFFFF00FF,
  'orange': 0xFFFFA500,
  'purple': 0xFF800080,
  'pink': 0xFFFFC0CB,
  'brown': 0xFFA52A2A,
  'gray': 0xFF808080,
  'grey': 0xFF808080,
  'lime': 0xFF00FF00,
  'navy': 0xFF000080,
  'teal': 0xFF008080,
  'aqua': 0xFF00FFFF,
  'maroon': 0xFF800000,
  'olive': 0xFF808000,
  'silver': 0xFFC0C0C0,
  'fuchsia': 0xFFFF00FF,
  'coral': 0xFFFF7F50,
  'gold': 0xFFFFD700,
  'indigo': 0xFF4B0082,
  'violet': 0xFFEE82EE,
  'crimson': 0xFFDC143C,
  'darkblue': 0xFF00008B,
  'darkgreen': 0xFF006400,
  'darkred': 0xFF8B0000,
  'lightblue': 0xFFADD8E6,
  'lightgreen': 0xFF90EE90,
  'lightgray': 0xFFD3D3D3,
  'lightgrey': 0xFFD3D3D3,
  'darkgray': 0xFFA9A9A9,
  'darkgrey': 0xFFA9A9A9,
};
