/// SVG Style parsing and management for Cairo
/// 
/// This module handles parsing and applying CSS styles to SVG elements,
/// managing specificity and cascading.

/// Parses and applies CSS styles to SVG elements
class CairoSvgStyle {
  final Map<String, String> _properties = {};
  
  CairoSvgStyle();
  
  /// Parse inline style attribute (e.g., "fill: red; stroke: blue;")
  factory CairoSvgStyle.fromInline(String styleString) {
    final style = CairoSvgStyle();
    style.parseInlineStyle(styleString);
    return style;
  }
  
  /// Parse inline style string
  void parseInlineStyle(String styleString) {
    if (styleString.isEmpty) return;
    
    // Split by semicolon and process each declaration
    final declarations = styleString.split(';');
    for (final declaration in declarations) {
      final parts = declaration.split(':');
      if (parts.length == 2) {
        final property = parts[0].trim();
        final value = parts[1].trim();
        if (property.isNotEmpty && value.isNotEmpty) {
          _properties[property] = value;
        }
      }
    }
  }
  
  /// Get a style property value
  String? getProperty(String name) {
    return _properties[name];
  }
  
  /// Set a style property value
  void setProperty(String name, String value) {
    _properties[name] = value;
  }
  
  /// Check if a property exists
  bool hasProperty(String name) {
    return _properties.containsKey(name);
  }
  
  /// Merge styles from another CairoSvgStyle (other takes precedence)
  void merge(CairoSvgStyle other) {
    _properties.addAll(other._properties);
  }
  
  /// Get all properties
  Map<String, String> get properties => Map.unmodifiable(_properties);
  
  /// Convert to inline style string
  String toInlineStyle() {
    return _properties.entries
        .map((e) => '${e.key}: ${e.value}')
        .join('; ');
  }
  
  @override
  String toString() => toInlineStyle();
}

/// CSS specificity for style resolution
class CairoSvgCssSpecificity implements Comparable<CairoSvgCssSpecificity> {
  final int inline;      // 1000
  final int ids;         // 100
  final int classes;     // 10
  final int elements;    // 1
  
  const CairoSvgCssSpecificity({
    this.inline = 0,
    this.ids = 0,
    this.classes = 0,
    this.elements = 0,
  });
  
  /// Inline style (highest specificity)
  static const inlineStyle = CairoSvgCssSpecificity(inline: 1);
  
  /// ID selector (#id)
  static const idSelector = CairoSvgCssSpecificity(ids: 1);
  
  /// Class selector (.class)
  static const classSelector = CairoSvgCssSpecificity(classes: 1);
  
  /// Element selector (element)
  static const elementSelector = CairoSvgCssSpecificity(elements: 1);
  
  /// Universal selector (*)
  static const universal = CairoSvgCssSpecificity();
  
  /// Presentation attribute (lowest specificity)
  static const presentationAttribute = CairoSvgCssSpecificity();
  
  int get value => inline * 1000 + ids * 100 + classes * 10 + elements;
  
  @override
  int compareTo(CairoSvgCssSpecificity other) => value.compareTo(other.value);
  
  @override
  bool operator ==(Object other) =>
      other is CairoSvgCssSpecificity && value == other.value;
  
  @override
  int get hashCode => value.hashCode;
  
  bool operator <(CairoSvgCssSpecificity other) => value < other.value;
  bool operator <=(CairoSvgCssSpecificity other) => value <= other.value;
  bool operator >(CairoSvgCssSpecificity other) => value > other.value;
  bool operator >=(CairoSvgCssSpecificity other) => value >= other.value;
  
  @override
  String toString() => 'Specificity($inline,$ids,$classes,$elements)';
}

/// Represents a styled property with its specificity
class CairoSvgStyledProperty {
  final String value;
  final CairoSvgCssSpecificity specificity;
  
  const CairoSvgStyledProperty(this.value, this.specificity);
}

/// Manages style properties with specificity
class CairoSvgStyleManager {
  final Map<String, CairoSvgStyledProperty> _properties = {};
  
  /// Set a property with specificity
  void setProperty(String name, String value, CairoSvgCssSpecificity specificity) {
    final existing = _properties[name];
    if (existing == null || specificity >= existing.specificity) {
      _properties[name] = CairoSvgStyledProperty(value, specificity);
    }
  }
  
  /// Get property value
  String? getProperty(String name) {
    return _properties[name]?.value;
  }
  
  /// Check if property exists
  bool hasProperty(String name) {
    return _properties.containsKey(name);
  }
  
  /// Get all properties
  Map<String, String> get properties {
    return _properties.map((key, value) => MapEntry(key, value.value));
  }
  
  /// Apply styles from CairoSvgStyle with specificity
  void applyStyle(CairoSvgStyle style, CairoSvgCssSpecificity specificity) {
    for (final entry in style.properties.entries) {
      setProperty(entry.key, entry.value, specificity);
    }
  }
  
  /// Apply inline style (highest priority)
  void applyInlineStyle(String styleString) {
    final style = CairoSvgStyle.fromInline(styleString);
    applyStyle(style, CairoSvgCssSpecificity.inlineStyle);
  }
  
  /// Apply presentation attribute (lowest priority)
  void applyPresentationAttribute(String name, String value) {
    setProperty(name, value, CairoSvgCssSpecificity.presentationAttribute);
  }
}

/// Presentation attributes that can be specified in SVG
class CairoSvgPresentationAttributes {
  // Fill and stroke
  static const fill = 'fill';
  static const fillOpacity = 'fill-opacity';
  static const fillRule = 'fill-rule';
  static const stroke = 'stroke';
  static const strokeWidth = 'stroke-width';
  static const strokeOpacity = 'stroke-opacity';
  static const strokeLinecap = 'stroke-linecap';
  static const strokeLinejoin = 'stroke-linejoin';
  static const strokeMiterlimit = 'stroke-miterlimit';
  static const strokeDasharray = 'stroke-dasharray';
  static const strokeDashoffset = 'stroke-dashoffset';
  
  // Opacity
  static const opacity = 'opacity';
  
  // Display and visibility
  static const display = 'display';
  static const visibility = 'visibility';
  
  // Transform
  static const transform = 'transform';
  
  // Font properties
  static const fontFamily = 'font-family';
  static const fontSize = 'font-size';
  static const fontWeight = 'font-weight';
  static const fontStyle = 'font-style';
  static const textAnchor = 'text-anchor';
  static const textDecoration = 'text-decoration';
  
  // Other
  static const clipPath = 'clip-path';
  static const clipRule = 'clip-rule';
  static const mask = 'mask';
  static const filter = 'filter';
  
  /// All presentation attribute names
  static const all = [
    fill, fillOpacity, fillRule,
    stroke, strokeWidth, strokeOpacity, strokeLinecap, strokeLinejoin,
    strokeMiterlimit, strokeDasharray, strokeDashoffset,
    opacity, display, visibility, transform,
    fontFamily, fontSize, fontWeight, fontStyle, textAnchor, textDecoration,
    clipPath, clipRule, mask, filter,
  ];
  
  /// Check if a name is a presentation attribute
  static bool isPresentation(String name) {
    return all.contains(name);
  }
}
