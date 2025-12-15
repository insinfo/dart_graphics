/// SVG Color parsing for Cairo
/// 
/// This module handles parsing SVG color values (hex, rgb, rgba, named colors)
/// and converting them to Cairo RGBA format.

import '../cairo_types.dart';

/// SVG color parser
class CairoSvgColor {
  /// Parses an SVG color string and returns a CairoColor
  static CairoColor? parse(String? value) {
    if (value == null || value.isEmpty) return null;
    
    final color = value.trim().toLowerCase();
    
    // Handle 'none' and 'transparent'
    if (color == 'none' || color == 'transparent') {
      return CairoColor(0, 0, 0, 0);
    }
    
    // Hex colors
    if (color.startsWith('#')) {
      return _parseHex(color);
    }
    
    // rgb() / rgba()
    if (color.startsWith('rgb')) {
      return _parseRgb(color);
    }
    
    // hsl() / hsla()
    if (color.startsWith('hsl')) {
      return _parseHsl(color);
    }
    
    // Named colors
    return _namedColors[color];
  }
  
  /// Parse hex color (#RGB, #RRGGBB, #RGBA, #RRGGBBAA)
  static CairoColor? _parseHex(String value) {
    var hex = value.substring(1);
    
    // Convert shorthand (#RGB, #RGBA) to full format
    if (hex.length == 3) {
      hex = '${hex[0]}${hex[0]}${hex[1]}${hex[1]}${hex[2]}${hex[2]}';
    } else if (hex.length == 4) {
      hex = '${hex[0]}${hex[0]}${hex[1]}${hex[1]}${hex[2]}${hex[2]}${hex[3]}${hex[3]}';
    }
    
    if (hex.length == 6) {
      final r = int.tryParse(hex.substring(0, 2), radix: 16);
      final g = int.tryParse(hex.substring(2, 4), radix: 16);
      final b = int.tryParse(hex.substring(4, 6), radix: 16);
      if (r != null && g != null && b != null) {
        return CairoColor(r / 255.0, g / 255.0, b / 255.0, 1.0);
      }
    } else if (hex.length == 8) {
      final r = int.tryParse(hex.substring(0, 2), radix: 16);
      final g = int.tryParse(hex.substring(2, 4), radix: 16);
      final b = int.tryParse(hex.substring(4, 6), radix: 16);
      final a = int.tryParse(hex.substring(6, 8), radix: 16);
      if (r != null && g != null && b != null && a != null) {
        return CairoColor(r / 255.0, g / 255.0, b / 255.0, a / 255.0);
      }
    }
    
    return null;
  }
  
  /// Parse rgb()/rgba() color
  static CairoColor? _parseRgb(String value) {
    final match = RegExp(r'rgba?\s*\(\s*([^)]+)\s*\)').firstMatch(value);
    if (match == null) return null;
    
    final parts = match.group(1)!.split(RegExp(r'[,\s/]+')).where((s) => s.isNotEmpty).toList();
    if (parts.length < 3) return null;
    
    final r = _parseColorValue(parts[0]);
    final g = _parseColorValue(parts[1]);
    final b = _parseColorValue(parts[2]);
    
    if (r == null || g == null || b == null) return null;
    
    double a = 1.0;
    if (parts.length >= 4) {
      final aValue = parts[3].trim();
      if (aValue.endsWith('%')) {
        a = (double.tryParse(aValue.substring(0, aValue.length - 1)) ?? 100) / 100.0;
      } else {
        a = double.tryParse(aValue) ?? 1.0;
      }
    }
    
    return CairoColor(r, g, b, a.clamp(0.0, 1.0));
  }
  
  /// Parse a single color channel value (number or percentage)
  static double? _parseColorValue(String value) {
    final trimmed = value.trim();
    if (trimmed.endsWith('%')) {
      final percent = double.tryParse(trimmed.substring(0, trimmed.length - 1));
      if (percent == null) return null;
      return (percent / 100.0).clamp(0.0, 1.0);
    }
    final intValue = int.tryParse(trimmed);
    if (intValue == null) return null;
    return (intValue / 255.0).clamp(0.0, 1.0);
  }
  
  /// Parse hsl()/hsla() color
  static CairoColor? _parseHsl(String value) {
    final match = RegExp(r'hsla?\s*\(\s*([^)]+)\s*\)').firstMatch(value);
    if (match == null) return null;
    
    final parts = match.group(1)!.split(RegExp(r'[,\s/]+')).where((s) => s.isNotEmpty).toList();
    if (parts.length < 3) return null;
    
    // Hue: 0-360 degrees (can also be turn, rad, grad)
    double h = 0;
    final hStr = parts[0].trim().toLowerCase();
    if (hStr.endsWith('turn')) {
      h = (double.tryParse(hStr.replaceAll('turn', '')) ?? 0) * 360;
    } else if (hStr.endsWith('rad')) {
      h = (double.tryParse(hStr.replaceAll('rad', '')) ?? 0) * 180 / 3.141592653589793;
    } else if (hStr.endsWith('grad')) {
      h = (double.tryParse(hStr.replaceAll('grad', '')) ?? 0) * 0.9;
    } else {
      h = double.tryParse(hStr.replaceAll('deg', '')) ?? 0;
    }
    h = h % 360;
    if (h < 0) h += 360;
    
    // Saturation and Lightness: percentages
    final sStr = parts[1].trim();
    final lStr = parts[2].trim();
    final s = (double.tryParse(sStr.replaceAll('%', '')) ?? 0) / 100.0;
    final l = (double.tryParse(lStr.replaceAll('%', '')) ?? 0) / 100.0;
    
    // Alpha
    double a = 1.0;
    if (parts.length >= 4) {
      final aStr = parts[3].trim();
      if (aStr.endsWith('%')) {
        a = (double.tryParse(aStr.substring(0, aStr.length - 1)) ?? 100) / 100.0;
      } else {
        a = double.tryParse(aStr) ?? 1.0;
      }
    }
    
    // HSL to RGB conversion
    final rgb = _hslToRgb(h / 360.0, s.clamp(0.0, 1.0), l.clamp(0.0, 1.0));
    return CairoColor(rgb[0], rgb[1], rgb[2], a.clamp(0.0, 1.0));
  }
  
  /// Convert HSL to RGB (all values 0-1)
  static List<double> _hslToRgb(double h, double s, double l) {
    if (s == 0) {
      return [l, l, l];
    }
    
    double hue2rgb(double p, double q, double t) {
      var tt = t;
      if (tt < 0) tt += 1;
      if (tt > 1) tt -= 1;
      if (tt < 1/6) return p + (q - p) * 6 * tt;
      if (tt < 1/2) return q;
      if (tt < 2/3) return p + (q - p) * (2/3 - tt) * 6;
      return p;
    }
    
    final q = l < 0.5 ? l * (1 + s) : l + s - l * s;
    final p = 2 * l - q;
    
    return [
      hue2rgb(p, q, h + 1/3),
      hue2rgb(p, q, h),
      hue2rgb(p, q, h - 1/3),
    ];
  }

  /// Named SVG colors
  static final Map<String, CairoColor> _namedColors = {
    'aliceblue': CairoColor(240/255, 248/255, 255/255),
    'antiquewhite': CairoColor(250/255, 235/255, 215/255),
    'aqua': CairoColor(0/255, 255/255, 255/255),
    'aquamarine': CairoColor(127/255, 255/255, 212/255),
    'azure': CairoColor(240/255, 255/255, 255/255),
    'beige': CairoColor(245/255, 245/255, 220/255),
    'bisque': CairoColor(255/255, 228/255, 196/255),
    'black': CairoColor(0/255, 0/255, 0/255),
    'blanchedalmond': CairoColor(255/255, 235/255, 205/255),
    'blue': CairoColor(0/255, 0/255, 255/255),
    'blueviolet': CairoColor(138/255, 43/255, 226/255),
    'brown': CairoColor(165/255, 42/255, 42/255),
    'burlywood': CairoColor(222/255, 184/255, 135/255),
    'cadetblue': CairoColor(95/255, 158/255, 160/255),
    'chartreuse': CairoColor(127/255, 255/255, 0/255),
    'chocolate': CairoColor(210/255, 105/255, 30/255),
    'coral': CairoColor(255/255, 127/255, 80/255),
    'cornflowerblue': CairoColor(100/255, 149/255, 237/255),
    'cornsilk': CairoColor(255/255, 248/255, 220/255),
    'crimson': CairoColor(220/255, 20/255, 60/255),
    'cyan': CairoColor(0/255, 255/255, 255/255),
    'darkblue': CairoColor(0/255, 0/255, 139/255),
    'darkcyan': CairoColor(0/255, 139/255, 139/255),
    'darkgoldenrod': CairoColor(184/255, 134/255, 11/255),
    'darkgray': CairoColor(169/255, 169/255, 169/255),
    'darkgreen': CairoColor(0/255, 100/255, 0/255),
    'darkgrey': CairoColor(169/255, 169/255, 169/255),
    'darkkhaki': CairoColor(189/255, 183/255, 107/255),
    'darkmagenta': CairoColor(139/255, 0/255, 139/255),
    'darkolivegreen': CairoColor(85/255, 107/255, 47/255),
    'darkorange': CairoColor(255/255, 140/255, 0/255),
    'darkorchid': CairoColor(153/255, 50/255, 204/255),
    'darkred': CairoColor(139/255, 0/255, 0/255),
    'darksalmon': CairoColor(233/255, 150/255, 122/255),
    'darkseagreen': CairoColor(143/255, 188/255, 143/255),
    'darkslateblue': CairoColor(72/255, 61/255, 139/255),
    'darkslategray': CairoColor(47/255, 79/255, 79/255),
    'darkslategrey': CairoColor(47/255, 79/255, 79/255),
    'darkturquoise': CairoColor(0/255, 206/255, 209/255),
    'darkviolet': CairoColor(148/255, 0/255, 211/255),
    'deeppink': CairoColor(255/255, 20/255, 147/255),
    'deepskyblue': CairoColor(0/255, 191/255, 255/255),
    'dimgray': CairoColor(105/255, 105/255, 105/255),
    'dimgrey': CairoColor(105/255, 105/255, 105/255),
    'dodgerblue': CairoColor(30/255, 144/255, 255/255),
    'firebrick': CairoColor(178/255, 34/255, 34/255),
    'floralwhite': CairoColor(255/255, 250/255, 240/255),
    'forestgreen': CairoColor(34/255, 139/255, 34/255),
    'fuchsia': CairoColor(255/255, 0/255, 255/255),
    'gainsboro': CairoColor(220/255, 220/255, 220/255),
    'ghostwhite': CairoColor(248/255, 248/255, 255/255),
    'gold': CairoColor(255/255, 215/255, 0/255),
    'goldenrod': CairoColor(218/255, 165/255, 32/255),
    'gray': CairoColor(128/255, 128/255, 128/255),
    'green': CairoColor(0/255, 128/255, 0/255),
    'greenyellow': CairoColor(173/255, 255/255, 47/255),
    'grey': CairoColor(128/255, 128/255, 128/255),
    'honeydew': CairoColor(240/255, 255/255, 240/255),
    'hotpink': CairoColor(255/255, 105/255, 180/255),
    'indianred': CairoColor(205/255, 92/255, 92/255),
    'indigo': CairoColor(75/255, 0/255, 130/255),
    'ivory': CairoColor(255/255, 255/255, 240/255),
    'khaki': CairoColor(240/255, 230/255, 140/255),
    'lavender': CairoColor(230/255, 230/255, 250/255),
    'lavenderblush': CairoColor(255/255, 240/255, 245/255),
    'lawngreen': CairoColor(124/255, 252/255, 0/255),
    'lemonchiffon': CairoColor(255/255, 250/255, 205/255),
    'lightblue': CairoColor(173/255, 216/255, 230/255),
    'lightcoral': CairoColor(240/255, 128/255, 128/255),
    'lightcyan': CairoColor(224/255, 255/255, 255/255),
    'lightgoldenrodyellow': CairoColor(250/255, 250/255, 210/255),
    'lightgray': CairoColor(211/255, 211/255, 211/255),
    'lightgreen': CairoColor(144/255, 238/255, 144/255),
    'lightgrey': CairoColor(211/255, 211/255, 211/255),
    'lightpink': CairoColor(255/255, 182/255, 193/255),
    'lightsalmon': CairoColor(255/255, 160/255, 122/255),
    'lightseagreen': CairoColor(32/255, 178/255, 170/255),
    'lightskyblue': CairoColor(135/255, 206/255, 250/255),
    'lightslategray': CairoColor(119/255, 136/255, 153/255),
    'lightslategrey': CairoColor(119/255, 136/255, 153/255),
    'lightsteelblue': CairoColor(176/255, 196/255, 222/255),
    'lightyellow': CairoColor(255/255, 255/255, 224/255),
    'lime': CairoColor(0/255, 255/255, 0/255),
    'limegreen': CairoColor(50/255, 205/255, 50/255),
    'linen': CairoColor(250/255, 240/255, 230/255),
    'magenta': CairoColor(255/255, 0/255, 255/255),
    'maroon': CairoColor(128/255, 0/255, 0/255),
    'mediumaquamarine': CairoColor(102/255, 205/255, 170/255),
    'mediumblue': CairoColor(0/255, 0/255, 205/255),
    'mediumorchid': CairoColor(186/255, 85/255, 211/255),
    'mediumpurple': CairoColor(147/255, 112/255, 219/255),
    'mediumseagreen': CairoColor(60/255, 179/255, 113/255),
    'mediumslateblue': CairoColor(123/255, 104/255, 238/255),
    'mediumspringgreen': CairoColor(0/255, 250/255, 154/255),
    'mediumturquoise': CairoColor(72/255, 209/255, 204/255),
    'mediumvioletred': CairoColor(199/255, 21/255, 133/255),
    'midnightblue': CairoColor(25/255, 25/255, 112/255),
    'mintcream': CairoColor(245/255, 255/255, 250/255),
    'mistyrose': CairoColor(255/255, 228/255, 225/255),
    'moccasin': CairoColor(255/255, 228/255, 181/255),
    'navajowhite': CairoColor(255/255, 222/255, 173/255),
    'navy': CairoColor(0/255, 0/255, 128/255),
    'oldlace': CairoColor(253/255, 245/255, 230/255),
    'olive': CairoColor(128/255, 128/255, 0/255),
    'olivedrab': CairoColor(107/255, 142/255, 35/255),
    'orange': CairoColor(255/255, 165/255, 0/255),
    'orangered': CairoColor(255/255, 69/255, 0/255),
    'orchid': CairoColor(218/255, 112/255, 214/255),
    'palegoldenrod': CairoColor(238/255, 232/255, 170/255),
    'palegreen': CairoColor(152/255, 251/255, 152/255),
    'paleturquoise': CairoColor(175/255, 238/255, 238/255),
    'palevioletred': CairoColor(219/255, 112/255, 147/255),
    'papayawhip': CairoColor(255/255, 239/255, 213/255),
    'peachpuff': CairoColor(255/255, 218/255, 185/255),
    'peru': CairoColor(205/255, 133/255, 63/255),
    'pink': CairoColor(255/255, 192/255, 203/255),
    'plum': CairoColor(221/255, 160/255, 221/255),
    'powderblue': CairoColor(176/255, 224/255, 230/255),
    'purple': CairoColor(128/255, 0/255, 128/255),
    'rebeccapurple': CairoColor(102/255, 51/255, 153/255),
    'red': CairoColor(255/255, 0/255, 0/255),
    'rosybrown': CairoColor(188/255, 143/255, 143/255),
    'royalblue': CairoColor(65/255, 105/255, 225/255),
    'saddlebrown': CairoColor(139/255, 69/255, 19/255),
    'salmon': CairoColor(250/255, 128/255, 114/255),
    'sandybrown': CairoColor(244/255, 164/255, 96/255),
    'seagreen': CairoColor(46/255, 139/255, 87/255),
    'seashell': CairoColor(255/255, 245/255, 238/255),
    'sienna': CairoColor(160/255, 82/255, 45/255),
    'silver': CairoColor(192/255, 192/255, 192/255),
    'skyblue': CairoColor(135/255, 206/255, 235/255),
    'slateblue': CairoColor(106/255, 90/255, 205/255),
    'slategray': CairoColor(112/255, 128/255, 144/255),
    'slategrey': CairoColor(112/255, 128/255, 144/255),
    'snow': CairoColor(255/255, 250/255, 250/255),
    'springgreen': CairoColor(0/255, 255/255, 127/255),
    'steelblue': CairoColor(70/255, 130/255, 180/255),
    'tan': CairoColor(210/255, 180/255, 140/255),
    'teal': CairoColor(0/255, 128/255, 128/255),
    'thistle': CairoColor(216/255, 191/255, 216/255),
    'tomato': CairoColor(255/255, 99/255, 71/255),
    'turquoise': CairoColor(64/255, 224/255, 208/255),
    'violet': CairoColor(238/255, 130/255, 238/255),
    'wheat': CairoColor(245/255, 222/255, 179/255),
    'white': CairoColor(255/255, 255/255, 255/255),
    'whitesmoke': CairoColor(245/255, 245/255, 245/255),
    'yellow': CairoColor(255/255, 255/255, 0/255),
    'yellowgreen': CairoColor(154/255, 205/255, 50/255),
  };
}
