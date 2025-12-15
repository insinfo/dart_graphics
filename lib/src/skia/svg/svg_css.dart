import 'svg_element.dart';
import 'svg_style.dart';

/// CSS Selector types
enum SelectorType {
  universal,    // *
  element,      // rect, circle, etc
  classSelector, // .classname
  idSelector,   // #id
}

/// Represents a CSS selector with its specificity
class CssSelector {
  final SelectorType type;
  final String? value;
  final CssSpecificity specificity;
  
  CssSelector(this.type, this.value, this.specificity);
  
  /// Parse a simple selector string
  static CssSelector? parse(String selector) {
    final trimmed = selector.trim();
    
    if (trimmed.isEmpty) return null;
    
    // ID selector (#id)
    if (trimmed.startsWith('#')) {
      return CssSelector(
        SelectorType.idSelector,
        trimmed.substring(1),
        CssSpecificity.idSelector,
      );
    }
    
    // Class selector (.class)
    if (trimmed.startsWith('.')) {
      return CssSelector(
        SelectorType.classSelector,
        trimmed.substring(1),
        CssSpecificity.classSelector,
      );
    }
    
    // Universal selector (*)
    if (trimmed == '*') {
      return CssSelector(
        SelectorType.universal,
        null,
        CssSpecificity.universal,
      );
    }
    
    // Element selector (element)
    return CssSelector(
      SelectorType.element,
      trimmed,
      CssSpecificity.elementSelector,
    );
  }
  
  /// Check if this selector matches an element
  bool matches(SvgElement element) {
    switch (type) {
      case SelectorType.universal:
        return true;
        
      case SelectorType.element:
        return element.elementType == value;
        
      case SelectorType.classSelector:
        if (value == null) return false;
        final classes = element.className?.split(RegExp(r'\s+')) ?? [];
        return classes.contains(value);
        
      case SelectorType.idSelector:
        return element.id == value;
    }
  }
  
  @override
  String toString() {
    switch (type) {
      case SelectorType.universal:
        return '*';
      case SelectorType.element:
        return value ?? '';
      case SelectorType.classSelector:
        return '.$value';
      case SelectorType.idSelector:
        return '#$value';
    }
  }
}

/// Represents a CSS rule with selector and declarations
class CssRule {
  final CssSelector selector;
  final Map<String, String> declarations;
  
  CssRule(this.selector, this.declarations);
  
  /// Apply this rule to an element if it matches
  void applyTo(SvgElement element) {
    if (selector.matches(element)) {
      for (final entry in declarations.entries) {
        element.styleManager.setProperty(
          entry.key,
          entry.value,
          selector.specificity,
        );
      }
    }
  }
}

/// Manages CSS stylesheets for SVG documents
class CssStylesheet {
  final List<CssRule> rules = [];
  
  /// Parse CSS from string
  static CssStylesheet? parse(String cssText) {
    try {
      final stylesheet = CssStylesheet();
      stylesheet._parseRules(cssText);
      return stylesheet;
    } catch (e) {
      print('Error parsing CSS: $e');
      return null;
    }
  }
  
  void _parseRules(String cssText) {
    // Simple CSS parser - split by } and parse each rule
    final ruleStrings = cssText.split('}');
    
    for (final ruleStr in ruleStrings) {
      final trimmed = ruleStr.trim();
      if (trimmed.isEmpty) continue;
      
      // Split selector and declarations
      final parts = trimmed.split('{');
      if (parts.length != 2) continue;
      
      final selectorStr = parts[0].trim();
      final declarationsStr = parts[1].trim();
      
      // Parse selector
      final selector = CssSelector.parse(selectorStr);
      if (selector == null) continue;
      
      // Parse declarations
      final declarations = <String, String>{};
      for (final declaration in declarationsStr.split(';')) {
        final declParts = declaration.split(':');
        if (declParts.length == 2) {
          final property = declParts[0].trim();
          final value = declParts[1].trim();
          if (property.isNotEmpty && value.isNotEmpty) {
            declarations[property] = value;
          }
        }
      }
      
      if (declarations.isNotEmpty) {
        rules.add(CssRule(selector, declarations));
      }
    }
  }
  
  /// Apply all rules to an element
  void applyTo(SvgElement element) {
    for (final rule in rules) {
      rule.applyTo(element);
    }
  }
  
  /// Apply all rules recursively to element and its children
  void applyToTree(SvgElement element) {
    applyTo(element);
    for (final child in element.children) {
      applyToTree(child);
    }
  }
  
  @override
  String toString() {
    return rules.map((r) => '${r.selector} { ${r.declarations.length} props }').join('\n');
  }
}
