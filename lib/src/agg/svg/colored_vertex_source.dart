import 'package:dart_graphics/src/agg/vertex_source/vertex_storage.dart';
import 'package:dart_graphics/src/agg/svg/svg_paint.dart';

/// Simple pair of geometry + fill paint for parsed SVG shapes.
class ColoredVertexSource {
  final VertexStorage vertices;
  final SvgPaint fill;

  ColoredVertexSource(this.vertices, this.fill);
}
