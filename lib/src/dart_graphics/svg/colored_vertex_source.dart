import 'package:dart_graphics/src/dart_graphics/vertex_source/vertex_storage.dart';
import 'package:dart_graphics/src/dart_graphics/svg/svg_paint.dart';

/// Simple pair of geometry + fill paint for parsed SVG shapes.
class ColoredVertexSource {
  final VertexStorage vertices;
  final SvgPaint fill;

  ColoredVertexSource(this.vertices, this.fill);
}
