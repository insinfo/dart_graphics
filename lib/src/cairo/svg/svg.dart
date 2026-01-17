/// SVG rendering support for Cairo
/// 
/// This library provides complete SVG parsing and rendering capabilities
/// using Cairo as the rendering backend.
/// 
/// ## Features
/// 
/// - Full SVG path parsing (M, L, H, V, C, S, Q, T, A, Z commands)
/// - Basic shapes: rect, circle, ellipse, line, polyline, polygon
/// - Text rendering
/// - CSS styling support (inline styles, embedded stylesheets, selectors)
/// - Transform support (translate, scale, rotate, skew, matrix)
/// - Stroke and fill with opacity
/// - Named colors, hex colors, rgb(), rgba(), hsl(), hsla()
/// 
/// ## Example
/// 
/// ```dart
/// import 'package:dart_graphics/cairo.dart';
/// import 'package:dart_graphics/src/cairo/svg/svg.dart';
/// 
/// void main() {
///   final svg = '''
///     <svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
///       <rect x="10" y="10" width="80" height="80" fill="red" />
///       <circle cx="150" cy="50" r="40" fill="blue" />
///     </svg>
///   ''';
///   
///   final doc = CairoSvgDocument.fromString(svg);
///   if (doc != null) {
///     doc.renderToPng('output.png');
///   }
/// }
/// ```
library cairo_svg;

export 'svg_color.dart' show CairoSvgColor;
export 'svg_css.dart' show CairoSvgCssStylesheet, CairoSvgCssRule, CairoSvgCssSelector, CairoSvgSelectorType;
export 'svg_document.dart' show CairoSvgDocument, CairoSvgViewBox;
export 'svg_element.dart' show 
    CairoSvgElement,
    CairoSvgGroup,
    CairoSvgPathElement,
    CairoSvgRect,
    CairoSvgCircle,
    CairoSvgEllipse,
    CairoSvgLine,
    CairoSvgPolyline,
    CairoSvgPolygon,
    CairoSvgText,
    CairoSvgImage,
    CairoSvgUse,
    CairoSvgStrokeCap,
    CairoSvgStrokeJoin;
export 'svg_path.dart' show CairoSvgPath, CairoSvgPathCommand, CairoSvgPathCommandType;
export 'svg_style.dart' show 
    CairoSvgStyle,
    CairoSvgStyleManager,
    CairoSvgCssSpecificity,
    CairoSvgPresentationAttributes;
export 'svg_transform.dart' show CairoSvgTransform;
