/// CSS Parser for SVG styling in Cairo
/// 
/// This module handles parsing CSS stylesheets embedded in SVG documents
/// and applying them to SVG elements.

import 'svg_element.dart';
import 'svg_style.dart';

/// CSS Selector types
enum CairoSvgSelectorType {
  universal,    // *
  element,      // rect, circle, etc
  classSelector, // .classname
  idSelector,   // #id
}

/// Represents a CSS selector with its specificity
class CairoSvgCssSelector {
  final CairoSvgSelectorType type;
  final String? value;
  final CairoSvgCssSpecificity specificity;
  
  CairoSvgCssSelector(this.type, this.value, this.specificity);
  
  /// Parse a simple selector string
  static CairoSvgCssSelector? parse(String selector) {
    final trimmed = selector.trim();
    
    if (trimmed.isEmpty) return null;
    
    // ID selector (#id)
    if (trimmed.startsWith('#')) {
      return CairoSvgCssSelector(
        CairoSvgSelectorType.idSelector,
        trimmed.substring(1),
        CairoSvgCssSpecificity.idSelector,
      );
    }
    
    // Class selector (.class)
    if (trimmed.startsWith('.')) {
      return CairoSvgCssSelector(
        CairoSvgSelectorType.classSelector,
        trimmed.substring(1),
        CairoSvgCssSpecificity.classSelector,
      );
    }
    
    // Universal selector (*)
    if (trimmed == '*') {
      return CairoSvgCssSelector(
        CairoSvgSelectorType.universal,
        null,
        CairoSvgCssSpecificity.universal,
      );
    }
    
    // Element selector (element)
    return CairoSvgCssSelector(
      CairoSvgSelectorType.element,
      trimmed,
      CairoSvgCssSpecificity.elementSelector,
    );
  }
  
  /// Check if this selector matches an element
  bool matches(CairoSvgElement element) {
    switch (type) {
      case CairoSvgSelectorType.universal:
        return true;
        
      case CairoSvgSelectorType.element:
        return element.elementType == value;
        
      case CairoSvgSelectorType.classSelector:
        if (value == null) return false;
        final classes = element.className?.split(RegExp(r'\s+')) ?? [];
        return classes.contains(value);
        
      case CairoSvgSelectorType.idSelector:
        return element.id == value;
    }
  }
  
  @override
  String toString() {
    switch (type) {
      case CairoSvgSelectorType.universal:
        return '*';
      case CairoSvgSelectorType.element:
        return value ?? '';
      case CairoSvgSelectorType.classSelector:
        return '.$value';
      case CairoSvgSelectorType.idSelector:
        return '#$value';
    }
  }
}

/// Represents a CSS rule with selector and declarations
class CairoSvgCssRule {
  final CairoSvgCssSelector selector;
  final Map<String, String> declarations;
  
  CairoSvgCssRule(this.selector, this.declarations);
  
  /// Apply this rule to an element if it matches
  void applyTo(CairoSvgElement element) {
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
class CairoSvgCssStylesheet {
  final List<CairoSvgCssRule> rules = [];
  
  /// Parse CSS from string
  static CairoSvgCssStylesheet? parse(String cssText) {
    try {
      final stylesheet = CairoSvgCssStylesheet();
      stylesheet._parseRules(cssText);
      return stylesheet;
    } catch (e) {
      // Silently ignore CSS parsing errors
      return null;
    }
  }
  
  void _parseRules(String cssText) {
    // Remove CSS comments
    var cleaned = cssText.replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '');
    
    // Simple CSS parser - split by } and parse each rule
    final ruleStrings = cleaned.split('}');
    
    for (final ruleStr in ruleStrings) {
      final trimmed = ruleStr.trim();
      if (trimmed.isEmpty) continue;
      
      // Split selector and declarations
      final parts = trimmed.split('{');
      if (parts.length != 2) continue;
      
      final selectorStr = parts[0].trim();
      final declarationsStr = parts[1].trim();
      
      // Handle multiple selectors (e.g., "rect, circle { ... }")
      final selectors = selectorStr.split(',');
      
      // Parse declarations
      final declarations = <String, String>{};
      for (final declaration in declarationsStr.split(';')) {
        final trimmedDecl = declaration.trim();
        if (trimmedDecl.isEmpty) continue;
        
        final colonIndex = trimmedDecl.indexOf(':');
        if (colonIndex == -1) continue;
        
        final property = trimmedDecl.substring(0, colonIndex).trim();
        final value = trimmedDecl.substring(colonIndex + 1).trim();
        if (property.isNotEmpty && value.isNotEmpty) {
          declarations[property] = value;
        }
      }
      
      if (declarations.isEmpty) continue;
      
      // Create rules for each selector
      for (final selectorPart in selectors) {
        final selector = CairoSvgCssSelector.parse(selectorPart.trim());
        if (selector != null) {
          rules.add(CairoSvgCssRule(selector, Map.from(declarations)));
        }
      }
    }
  }
  
  /// Apply all rules to an element
  void applyTo(CairoSvgElement element) {
    for (final rule in rules) {
      rule.applyTo(element);
    }
  }
  
  /// Apply all rules recursively to element and its children
  void applyToTree(CairoSvgElement element) {
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
