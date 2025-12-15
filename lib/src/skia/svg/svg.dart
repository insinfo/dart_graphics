/// SVG rendering for SkiaSharp
/// 
/// This library provides SVG document loading and rendering capabilities
/// using the Skia graphics library.
/// 
/// Example usage:
/// ```dart
/// final svg = SvgDocument.fromString('''
///   <svg width="100" height="100">
///     <circle cx="50" cy="50" r="40" fill="red"/>
///   </svg>
/// ''');
/// 
/// final surface = svg?.renderToSurface();
/// ```
library svg;

export 'svg_document.dart';
export 'svg_element.dart';
export 'svg_color.dart';
export 'svg_path_parser.dart';
export 'svg_transform.dart';
export 'svg_style.dart';
export 'svg_css.dart';
