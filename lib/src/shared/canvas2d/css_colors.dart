/// CSS Named Colors
/// 
/// Standard CSS named colors with their hex values.
/// Reference: https://developer.mozilla.org/en-US/docs/Web/CSS/named-color

/// Map of CSS named colors to their ARGB values (0xAARRGGBB)
const Map<String, int> cssNamedColors = {
  // Basic colors
  'transparent': 0x00000000,
  'black': 0xFF000000,
  'white': 0xFFFFFFFF,
  'red': 0xFFFF0000,
  'green': 0xFF008000,
  'blue': 0xFF0000FF,
  'yellow': 0xFFFFFF00,
  'cyan': 0xFF00FFFF,
  'magenta': 0xFFFF00FF,
  
  // Extended colors
  'aliceblue': 0xFFF0F8FF,
  'antiquewhite': 0xFFFAEBD7,
  'aqua': 0xFF00FFFF,
  'aquamarine': 0xFF7FFFD4,
  'azure': 0xFFF0FFFF,
  'beige': 0xFFF5F5DC,
  'bisque': 0xFFFFE4C4,
  'blanchedalmond': 0xFFFFEBCD,
  'blueviolet': 0xFF8A2BE2,
  'brown': 0xFFA52A2A,
  'burlywood': 0xFFDEB887,
  'cadetblue': 0xFF5F9EA0,
  'chartreuse': 0xFF7FFF00,
  'chocolate': 0xFFD2691E,
  'coral': 0xFFFF7F50,
  'cornflowerblue': 0xFF6495ED,
  'cornsilk': 0xFFFFF8DC,
  'crimson': 0xFFDC143C,
  'darkblue': 0xFF00008B,
  'darkcyan': 0xFF008B8B,
  'darkgoldenrod': 0xFFB8860B,
  'darkgray': 0xFFA9A9A9,
  'darkgrey': 0xFFA9A9A9,
  'darkgreen': 0xFF006400,
  'darkkhaki': 0xFFBDB76B,
  'darkmagenta': 0xFF8B008B,
  'darkolivegreen': 0xFF556B2F,
  'darkorange': 0xFFFF8C00,
  'darkorchid': 0xFF9932CC,
  'darkred': 0xFF8B0000,
  'darksalmon': 0xFFE9967A,
  'darkseagreen': 0xFF8FBC8F,
  'darkslateblue': 0xFF483D8B,
  'darkslategray': 0xFF2F4F4F,
  'darkslategrey': 0xFF2F4F4F,
  'darkturquoise': 0xFF00CED1,
  'darkviolet': 0xFF9400D3,
  'deeppink': 0xFFFF1493,
  'deepskyblue': 0xFF00BFFF,
  'dimgray': 0xFF696969,
  'dimgrey': 0xFF696969,
  'dodgerblue': 0xFF1E90FF,
  'firebrick': 0xFFB22222,
  'floralwhite': 0xFFFFFAF0,
  'forestgreen': 0xFF228B22,
  'fuchsia': 0xFFFF00FF,
  'gainsboro': 0xFFDCDCDC,
  'ghostwhite': 0xFFF8F8FF,
  'gold': 0xFFFFD700,
  'goldenrod': 0xFFDAA520,
  'gray': 0xFF808080,
  'grey': 0xFF808080,
  'greenyellow': 0xFFADFF2F,
  'honeydew': 0xFFF0FFF0,
  'hotpink': 0xFFFF69B4,
  'indianred': 0xFFCD5C5C,
  'indigo': 0xFF4B0082,
  'ivory': 0xFFFFFFF0,
  'khaki': 0xFFF0E68C,
  'lavender': 0xFFE6E6FA,
  'lavenderblush': 0xFFFFF0F5,
  'lawngreen': 0xFF7CFC00,
  'lemonchiffon': 0xFFFFFACD,
  'lightblue': 0xFFADD8E6,
  'lightcoral': 0xFFF08080,
  'lightcyan': 0xFFE0FFFF,
  'lightgoldenrodyellow': 0xFFFAFAD2,
  'lightgray': 0xFFD3D3D3,
  'lightgrey': 0xFFD3D3D3,
  'lightgreen': 0xFF90EE90,
  'lightpink': 0xFFFFB6C1,
  'lightsalmon': 0xFFFFA07A,
  'lightseagreen': 0xFF20B2AA,
  'lightskyblue': 0xFF87CEFA,
  'lightslategray': 0xFF778899,
  'lightslategrey': 0xFF778899,
  'lightsteelblue': 0xFFB0C4DE,
  'lightyellow': 0xFFFFFFE0,
  'lime': 0xFF00FF00,
  'limegreen': 0xFF32CD32,
  'linen': 0xFFFAF0E6,
  'maroon': 0xFF800000,
  'mediumaquamarine': 0xFF66CDAA,
  'mediumblue': 0xFF0000CD,
  'mediumorchid': 0xFFBA55D3,
  'mediumpurple': 0xFF9370DB,
  'mediumseagreen': 0xFF3CB371,
  'mediumslateblue': 0xFF7B68EE,
  'mediumspringgreen': 0xFF00FA9A,
  'mediumturquoise': 0xFF48D1CC,
  'mediumvioletred': 0xFFC71585,
  'midnightblue': 0xFF191970,
  'mintcream': 0xFFF5FFFA,
  'mistyrose': 0xFFFFE4E1,
  'moccasin': 0xFFFFE4B5,
  'navajowhite': 0xFFFFDEAD,
  'navy': 0xFF000080,
  'oldlace': 0xFFFDF5E6,
  'olive': 0xFF808000,
  'olivedrab': 0xFF6B8E23,
  'orange': 0xFFFFA500,
  'orangered': 0xFFFF4500,
  'orchid': 0xFFDA70D6,
  'palegoldenrod': 0xFFEEE8AA,
  'palegreen': 0xFF98FB98,
  'paleturquoise': 0xFFAFEEEE,
  'palevioletred': 0xFFDB7093,
  'papayawhip': 0xFFFFEFD5,
  'peachpuff': 0xFFFFDAB9,
  'peru': 0xFFCD853F,
  'pink': 0xFFFFC0CB,
  'plum': 0xFFDDA0DD,
  'powderblue': 0xFFB0E0E6,
  'purple': 0xFF800080,
  'rebeccapurple': 0xFF663399,
  'rosybrown': 0xFFBC8F8F,
  'royalblue': 0xFF4169E1,
  'saddlebrown': 0xFF8B4513,
  'salmon': 0xFFFA8072,
  'sandybrown': 0xFFF4A460,
  'seagreen': 0xFF2E8B57,
  'seashell': 0xFFFFF5EE,
  'sienna': 0xFFA0522D,
  'silver': 0xFFC0C0C0,
  'skyblue': 0xFF87CEEB,
  'slateblue': 0xFF6A5ACD,
  'slategray': 0xFF708090,
  'slategrey': 0xFF708090,
  'snow': 0xFFFFFAFA,
  'springgreen': 0xFF00FF7F,
  'steelblue': 0xFF4682B4,
  'tan': 0xFFD2B48C,
  'teal': 0xFF008080,
  'thistle': 0xFFD8BFD8,
  'tomato': 0xFFFF6347,
  'turquoise': 0xFF40E0D0,
  'violet': 0xFFEE82EE,
  'wheat': 0xFFF5DEB3,
  'whitesmoke': 0xFFF5F5F5,
  'yellowgreen': 0xFF9ACD32,
};

/// Parses a CSS color string to ARGB components
/// 
/// Supports:
/// - Named colors: 'red', 'blue', etc.
/// - Hex: '#RGB', '#RGBA', '#RRGGBB', '#RRGGBBAA'
/// - RGB: 'rgb(r, g, b)', 'rgb(r g b)'
/// - RGBA: 'rgba(r, g, b, a)', 'rgba(r g b / a)'
/// - HSL: 'hsl(h, s%, l%)', 'hsl(h s% l%)'
/// - HSLA: 'hsla(h, s%, l%, a)', 'hsla(h s% l% / a)'
({int r, int g, int b, double a})? parseCssColor(String colorStr) {
  colorStr = colorStr.trim().toLowerCase();
  
  // Named colors
  final namedColor = cssNamedColors[colorStr];
  if (namedColor != null) {
    return (
      r: (namedColor >> 16) & 0xFF,
      g: (namedColor >> 8) & 0xFF,
      b: namedColor & 0xFF,
      a: ((namedColor >> 24) & 0xFF) / 255.0,
    );
  }
  
  // Hex colors
  if (colorStr.startsWith('#')) {
    return _parseHexColor(colorStr.substring(1));
  }
  
  // RGB/RGBA
  if (colorStr.startsWith('rgb')) {
    return _parseRgbColor(colorStr);
  }
  
  // HSL/HSLA
  if (colorStr.startsWith('hsl')) {
    return _parseHslColor(colorStr);
  }
  
  return null;
}

({int r, int g, int b, double a})? _parseHexColor(String hex) {
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
    return null;
  }
  
  return (r: r, g: g, b: b, a: a);
}

({int r, int g, int b, double a})? _parseRgbColor(String rgb) {
  // rgba is handled the same as rgb in modern CSS  
  // Extract content between parentheses
  final start = rgb.indexOf('(');
  final end = rgb.lastIndexOf(')');
  if (start == -1 || end == -1) return null;
  
  var content = rgb.substring(start + 1, end).trim();
  
  // Handle modern syntax with / for alpha
  List<String> parts;
  double a = 1.0;
  
  if (content.contains('/')) {
    final slashParts = content.split('/');
    final colorPart = slashParts[0].trim();
    final alphaPart = slashParts.length > 1 ? slashParts[1].trim() : '1';
    
    // Parse color components (space or comma separated)
    parts = colorPart.contains(',') 
        ? colorPart.split(',').map((s) => s.trim()).toList()
        : colorPart.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
    
    a = _parseAlpha(alphaPart);
  } else {
    // Traditional syntax with commas
    parts = content.split(',').map((s) => s.trim()).toList();
    if (parts.length >= 4) {
      a = _parseAlpha(parts[3]);
      parts = parts.sublist(0, 3);
    }
  }
  
  if (parts.length < 3) return null;
  
  final r = _parseColorComponent(parts[0]);
  final g = _parseColorComponent(parts[1]);
  final b = _parseColorComponent(parts[2]);
  
  return (r: r, g: g, b: b, a: a);
}

({int r, int g, int b, double a})? _parseHslColor(String hsl) {
  // hsla is handled the same as hsl in modern CSS
  final start = hsl.indexOf('(');
  final end = hsl.lastIndexOf(')');
  if (start == -1 || end == -1) return null;
  
  var content = hsl.substring(start + 1, end).trim();
  
  List<String> parts;
  double a = 1.0;
  
  if (content.contains('/')) {
    final slashParts = content.split('/');
    final colorPart = slashParts[0].trim();
    final alphaPart = slashParts.length > 1 ? slashParts[1].trim() : '1';
    
    parts = colorPart.contains(',')
        ? colorPart.split(',').map((s) => s.trim()).toList()
        : colorPart.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
    
    a = _parseAlpha(alphaPart);
  } else {
    parts = content.split(',').map((s) => s.trim()).toList();
    if (parts.length >= 4) {
      a = _parseAlpha(parts[3]);
      parts = parts.sublist(0, 3);
    }
  }
  
  if (parts.length < 3) return null;
  
  // Parse hue (degrees)
  var h = double.tryParse(parts[0].replaceAll('deg', '')) ?? 0;
  h = h % 360;
  if (h < 0) h += 360;
  
  // Parse saturation and lightness (percentages)
  final s = _parsePercentage(parts[1]) / 100;
  final l = _parsePercentage(parts[2]) / 100;
  
  // Convert HSL to RGB
  final rgb = _hslToRgb(h, s, l);
  
  return (r: rgb.r, g: rgb.g, b: rgb.b, a: a);
}

int _parseColorComponent(String value) {
  value = value.trim();
  if (value.endsWith('%')) {
    final percent = double.tryParse(value.substring(0, value.length - 1)) ?? 0;
    return (percent * 2.55).round().clamp(0, 255);
  }
  return (double.tryParse(value) ?? 0).round().clamp(0, 255);
}

double _parsePercentage(String value) {
  value = value.trim().replaceAll('%', '');
  return double.tryParse(value) ?? 0;
}

double _parseAlpha(String value) {
  value = value.trim();
  if (value.endsWith('%')) {
    return (double.tryParse(value.substring(0, value.length - 1)) ?? 100) / 100;
  }
  return (double.tryParse(value) ?? 1.0).clamp(0.0, 1.0);
}

({int r, int g, int b}) _hslToRgb(double h, double s, double l) {
  if (s == 0) {
    final v = (l * 255).round();
    return (r: v, g: v, b: v);
  }
  
  double hueToRgb(double p, double q, double t) {
    if (t < 0) t += 1;
    if (t > 1) t -= 1;
    if (t < 1/6) return p + (q - p) * 6 * t;
    if (t < 1/2) return q;
    if (t < 2/3) return p + (q - p) * (2/3 - t) * 6;
    return p;
  }
  
  final q = l < 0.5 ? l * (1 + s) : l + s - l * s;
  final p = 2 * l - q;
  
  final r = hueToRgb(p, q, h / 360 + 1/3);
  final g = hueToRgb(p, q, h / 360);
  final b = hueToRgb(p, q, h / 360 - 1/3);
  
  return (
    r: (r * 255).round().clamp(0, 255),
    g: (g * 255).round().clamp(0, 255),
    b: (b * 255).round().clamp(0, 255),
  );
}

/// Converts ARGB value to CSS color string
String argbToCssColor(int argb) {
  final a = ((argb >> 24) & 0xFF) / 255.0;
  final r = (argb >> 16) & 0xFF;
  final g = (argb >> 8) & 0xFF;
  final b = argb & 0xFF;
  
  if (a == 1.0) {
    return '#${r.toRadixString(16).padLeft(2, '0')}'
           '${g.toRadixString(16).padLeft(2, '0')}'
           '${b.toRadixString(16).padLeft(2, '0')}';
  } else {
    return 'rgba($r, $g, $b, ${a.toStringAsFixed(2)})';
  }
}
