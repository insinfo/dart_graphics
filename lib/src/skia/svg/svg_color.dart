import '../sk_color.dart';

/// SVG color parser
class SvgColor {
  /// Parses an SVG color string
  static SKColor? parse(String? value) {
    if (value == null || value.isEmpty) return null;
    
    final color = value.trim().toLowerCase();
    
    // Named colors
    if (color == 'none' || color == 'transparent') {
      return SKColors.transparent;
    }
    
    // Hex colors
    if (color.startsWith('#')) {
      return SKColor.tryParse(color);
    }
    
    // rgb() / rgba()
    if (color.startsWith('rgb')) {
      return _parseRgb(color);
    }
    
    // Named colors
    return _namedColors[color];
  }

  static SKColor? _parseRgb(String value) {
    final match = RegExp(r'rgba?\s*\(\s*([^)]+)\s*\)').firstMatch(value);
    if (match == null) return null;
    
    final parts = match.group(1)!.split(',').map((s) => s.trim()).toList();
    if (parts.length < 3) return null;
    
    int? r, g, b;
    double a = 1.0;
    
    // Parse RGB values (can be numbers or percentages)
    r = _parseColorValue(parts[0]);
    g = _parseColorValue(parts[1]);
    b = _parseColorValue(parts[2]);
    
    if (r == null || g == null || b == null) return null;
    
    // Parse alpha if present
    if (parts.length >= 4) {
      a = double.tryParse(parts[3]) ?? 1.0;
    }
    
    return SKColor.fromARGB((a * 255).round(), r, g, b);
  }

  static int? _parseColorValue(String value) {
    if (value.endsWith('%')) {
      final percent = double.tryParse(value.substring(0, value.length - 1));
      if (percent == null) return null;
      return ((percent / 100) * 255).round().clamp(0, 255);
    }
    return int.tryParse(value)?.clamp(0, 255);
  }

  static final Map<String, SKColor> _namedColors = {
    'aliceblue': SKColor(0xFFF0F8FF),
    'antiquewhite': SKColor(0xFFFAEBD7),
    'aqua': SKColor(0xFF00FFFF),
    'aquamarine': SKColor(0xFF7FFFD4),
    'azure': SKColor(0xFFF0FFFF),
    'beige': SKColor(0xFFF5F5DC),
    'bisque': SKColor(0xFFFFE4C4),
    'black': SKColor(0xFF000000),
    'blanchedalmond': SKColor(0xFFFFEBCD),
    'blue': SKColor(0xFF0000FF),
    'blueviolet': SKColor(0xFF8A2BE2),
    'brown': SKColor(0xFFA52A2A),
    'burlywood': SKColor(0xFFDEB887),
    'cadetblue': SKColor(0xFF5F9EA0),
    'chartreuse': SKColor(0xFF7FFF00),
    'chocolate': SKColor(0xFFD2691E),
    'coral': SKColor(0xFFFF7F50),
    'cornflowerblue': SKColor(0xFF6495ED),
    'cornsilk': SKColor(0xFFFFF8DC),
    'crimson': SKColor(0xFFDC143C),
    'cyan': SKColor(0xFF00FFFF),
    'darkblue': SKColor(0xFF00008B),
    'darkcyan': SKColor(0xFF008B8B),
    'darkgoldenrod': SKColor(0xFFB8860B),
    'darkgray': SKColor(0xFFA9A9A9),
    'darkgreen': SKColor(0xFF006400),
    'darkgrey': SKColor(0xFFA9A9A9),
    'darkkhaki': SKColor(0xFFBDB76B),
    'darkmagenta': SKColor(0xFF8B008B),
    'darkolivegreen': SKColor(0xFF556B2F),
    'darkorange': SKColor(0xFFFF8C00),
    'darkorchid': SKColor(0xFF9932CC),
    'darkred': SKColor(0xFF8B0000),
    'darksalmon': SKColor(0xFFE9967A),
    'darkseagreen': SKColor(0xFF8FBC8F),
    'darkslateblue': SKColor(0xFF483D8B),
    'darkslategray': SKColor(0xFF2F4F4F),
    'darkslategrey': SKColor(0xFF2F4F4F),
    'darkturquoise': SKColor(0xFF00CED1),
    'darkviolet': SKColor(0xFF9400D3),
    'deeppink': SKColor(0xFFFF1493),
    'deepskyblue': SKColor(0xFF00BFFF),
    'dimgray': SKColor(0xFF696969),
    'dimgrey': SKColor(0xFF696969),
    'dodgerblue': SKColor(0xFF1E90FF),
    'firebrick': SKColor(0xFFB22222),
    'floralwhite': SKColor(0xFFFFFAF0),
    'forestgreen': SKColor(0xFF228B22),
    'fuchsia': SKColor(0xFFFF00FF),
    'gainsboro': SKColor(0xFFDCDCDC),
    'ghostwhite': SKColor(0xFFF8F8FF),
    'gold': SKColor(0xFFFFD700),
    'goldenrod': SKColor(0xFFDAA520),
    'gray': SKColor(0xFF808080),
    'green': SKColor(0xFF008000),
    'greenyellow': SKColor(0xFFADFF2F),
    'grey': SKColor(0xFF808080),
    'honeydew': SKColor(0xFFF0FFF0),
    'hotpink': SKColor(0xFFFF69B4),
    'indianred': SKColor(0xFFCD5C5C),
    'indigo': SKColor(0xFF4B0082),
    'ivory': SKColor(0xFFFFFFF0),
    'khaki': SKColor(0xFFF0E68C),
    'lavender': SKColor(0xFFE6E6FA),
    'lavenderblush': SKColor(0xFFFFF0F5),
    'lawngreen': SKColor(0xFF7CFC00),
    'lemonchiffon': SKColor(0xFFFFFACD),
    'lightblue': SKColor(0xFFADD8E6),
    'lightcoral': SKColor(0xFFF08080),
    'lightcyan': SKColor(0xFFE0FFFF),
    'lightgoldenrodyellow': SKColor(0xFFFAFAD2),
    'lightgray': SKColor(0xFFD3D3D3),
    'lightgreen': SKColor(0xFF90EE90),
    'lightgrey': SKColor(0xFFD3D3D3),
    'lightpink': SKColor(0xFFFFB6C1),
    'lightsalmon': SKColor(0xFFFFA07A),
    'lightseagreen': SKColor(0xFF20B2AA),
    'lightskyblue': SKColor(0xFF87CEFA),
    'lightslategray': SKColor(0xFF778899),
    'lightslategrey': SKColor(0xFF778899),
    'lightsteelblue': SKColor(0xFFB0C4DE),
    'lightyellow': SKColor(0xFFFFFFE0),
    'lime': SKColor(0xFF00FF00),
    'limegreen': SKColor(0xFF32CD32),
    'linen': SKColor(0xFFFAF0E6),
    'magenta': SKColor(0xFFFF00FF),
    'maroon': SKColor(0xFF800000),
    'mediumaquamarine': SKColor(0xFF66CDAA),
    'mediumblue': SKColor(0xFF0000CD),
    'mediumorchid': SKColor(0xFFBA55D3),
    'mediumpurple': SKColor(0xFF9370DB),
    'mediumseagreen': SKColor(0xFF3CB371),
    'mediumslateblue': SKColor(0xFF7B68EE),
    'mediumspringgreen': SKColor(0xFF00FA9A),
    'mediumturquoise': SKColor(0xFF48D1CC),
    'mediumvioletred': SKColor(0xFFC71585),
    'midnightblue': SKColor(0xFF191970),
    'mintcream': SKColor(0xFFF5FFFA),
    'mistyrose': SKColor(0xFFFFE4E1),
    'moccasin': SKColor(0xFFFFE4B5),
    'navajowhite': SKColor(0xFFFFDEAD),
    'navy': SKColor(0xFF000080),
    'oldlace': SKColor(0xFFFDF5E6),
    'olive': SKColor(0xFF808000),
    'olivedrab': SKColor(0xFF6B8E23),
    'orange': SKColor(0xFFFFA500),
    'orangered': SKColor(0xFFFF4500),
    'orchid': SKColor(0xFFDA70D6),
    'palegoldenrod': SKColor(0xFFEEE8AA),
    'palegreen': SKColor(0xFF98FB98),
    'paleturquoise': SKColor(0xFFAFEEEE),
    'palevioletred': SKColor(0xFFDB7093),
    'papayawhip': SKColor(0xFFFFEFD5),
    'peachpuff': SKColor(0xFFFFDAB9),
    'peru': SKColor(0xFFCD853F),
    'pink': SKColor(0xFFFFC0CB),
    'plum': SKColor(0xFFDDA0DD),
    'powderblue': SKColor(0xFFB0E0E6),
    'purple': SKColor(0xFF800080),
    'red': SKColor(0xFFFF0000),
    'rosybrown': SKColor(0xFFBC8F8F),
    'royalblue': SKColor(0xFF4169E1),
    'saddlebrown': SKColor(0xFF8B4513),
    'salmon': SKColor(0xFFFA8072),
    'sandybrown': SKColor(0xFFF4A460),
    'seagreen': SKColor(0xFF2E8B57),
    'seashell': SKColor(0xFFFFF5EE),
    'sienna': SKColor(0xFFA0522D),
    'silver': SKColor(0xFFC0C0C0),
    'skyblue': SKColor(0xFF87CEEB),
    'slateblue': SKColor(0xFF6A5ACD),
    'slategray': SKColor(0xFF708090),
    'slategrey': SKColor(0xFF708090),
    'snow': SKColor(0xFFFFFAFA),
    'springgreen': SKColor(0xFF00FF7F),
    'steelblue': SKColor(0xFF4682B4),
    'tan': SKColor(0xFFD2B48C),
    'teal': SKColor(0xFF008080),
    'thistle': SKColor(0xFFD8BFD8),
    'tomato': SKColor(0xFFFF6347),
    'turquoise': SKColor(0xFF40E0D0),
    'violet': SKColor(0xFFEE82EE),
    'wheat': SKColor(0xFFF5DEB3),
    'white': SKColor(0xFFFFFFFF),
    'whitesmoke': SKColor(0xFFF5F5F5),
    'yellow': SKColor(0xFFFFFF00),
    'yellowgreen': SKColor(0xFF9ACD32),
  };
}
