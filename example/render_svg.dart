import 'dart:io';
import 'dart:typed_data';
import 'package:dart_graphics/src/agg/image/image_buffer.dart';
import 'package:dart_graphics/src/agg/scanline_renderer.dart';
import 'package:dart_graphics/src/agg/scanline_rasterizer.dart';
import 'package:dart_graphics/src/agg/scanline_packed8.dart';
import 'package:dart_graphics/src/agg/svg/svg_parser_new.dart';

import 'package:dart_graphics/src/agg/svg/svg_paint.dart';
import 'package:dart_graphics/src/agg/transform/affine.dart';
import 'package:dart_graphics/src/agg/spans/span_allocator.dart';
import 'package:dart_graphics/src/agg/spans/span_gradient.dart';
import 'package:dart_graphics/src/agg/vertex_source/vertex_storage.dart';
import 'package:dart_graphics/src/agg/primitives/color.dart';
import 'package:dart_graphics/src/agg/vertex_source/stroke.dart';
import 'package:dart_graphics/src/agg/vertex_source/stroke_math.dart';
import 'package:dart_graphics/src/agg/agg_basics.dart';

Future<void> main() async {
  final file = File('resources/image/brasao_editado_1.svg');
  if (!file.existsSync()) {
    print('File not found: ${file.path}');
    return;
  }

  final svgContent = file.readAsStringSync();
  final shapes = SvgParserNew.parse(svgContent);

  // SVG dimensions (from file)
  // width="694px" height="748px"
  // viewBox="0 0 539.56 581.43"
  const width = 694;
  const height = 748;
  const viewBoxX = 0.0;
  const viewBoxY = 0.0;
  const viewBoxW = 539.56;
  const viewBoxH = 581.43;

  // Calculate scale to fit viewBox into width/height
  final scaleX = width / viewBoxW;
  final scaleY = height / viewBoxH;

  // Create transformation matrix
  final transform = Affine.translation(-viewBoxX, -viewBoxY);
  transform.premultiply(Affine.scaling(scaleX, scaleY));

  // Render buffer
  final imageBuffer = ImageBuffer(width, height);

  // clear to white
  final white = Color(255, 255, 255, 255);
  for (int y = 0; y < height; y++) {
    imageBuffer.copy_hline(0, y, width, white);
  }

  final rasterizer = ScanlineRasterizer();
  final scanline = ScanlineCachePacked8();

  for (final shape in shapes) {
    final vs = _transformPath(shape.path, transform);

    rasterizer.reset();
    rasterizer.filling_rule(shape.fillRule);
    rasterizer.add_path(vs);

    if (shape.fill != null) {
      final fill = shape.fill!;
      final effectiveOpacity = shape.opacity * shape.fillOpacity;

      if (fill is SvgPaintSolid) {
        var color = fill.color;
        if (effectiveOpacity < 1.0) {
          color = Color(
            color.red,
            color.green,
            color.blue,
            (color.alpha * effectiveOpacity).round(),
          );
        }
        ScanlineRenderer.renderSolid(rasterizer, scanline, imageBuffer, color);
      } else if (fill is SvgPaintLinearGradient) {
        // Handle gradient
        final spanGradient =
            SpanGradientLinear(fill.x1, fill.y1, fill.x2, fill.y2);

        // Convert stops and apply opacity
        final stops = fill.stops.map((s) {
          var color = s.color;
          if (effectiveOpacity < 1.0) {
            color = Color(
              color.red,
              color.green,
              color.blue,
              (color.alpha * effectiveOpacity).round(),
            );
          }
          return (offset: s.offset, color: color);
        }).toList();
        spanGradient.buildLut(stops);

        // We need a span allocator
        final allocator = SpanAllocator();

        // Transform gradient coordinates
        final pt1 = transform.transformPoint(fill.x1, fill.y1);
        final pt2 = transform.transformPoint(fill.x2, fill.y2);
        spanGradient.setGradient(pt1.x, pt1.y, pt2.x, pt2.y);

        ScanlineRenderer.generateAndRender(
            rasterizer, scanline, imageBuffer, allocator, spanGradient);
      }
    }

    if (shape.stroke != null && shape.strokeWidth > 0) {
      final stroke = Stroke(vs, shape.strokeWidth);
      stroke.lineCap = LineCap.values[shape.strokeLineCap.index];
      stroke.lineJoin = LineJoin.values[shape.strokeLineJoin.index];
      stroke.miterLimit = shape.strokeMiterLimit;

      rasterizer.reset();
      rasterizer.filling_rule(filling_rule_e.fill_non_zero);
      rasterizer.add_path(stroke);

      final strokePaint = shape.stroke!;
      final effectiveOpacity = shape.opacity * shape.strokeOpacity;

      if (strokePaint is SvgPaintSolid) {
        var color = strokePaint.color;
        if (effectiveOpacity < 1.0) {
          color = Color(
            color.red,
            color.green,
            color.blue,
            (color.alpha * effectiveOpacity).round(),
          );
        }
        ScanlineRenderer.renderSolid(rasterizer, scanline, imageBuffer, color);
      } else if (strokePaint is SvgPaintLinearGradient) {
        // Handle gradient stroke
        final spanGradient = SpanGradientLinear(
            strokePaint.x1, strokePaint.y1, strokePaint.x2, strokePaint.y2);

        final stops = strokePaint.stops.map((s) {
          var color = s.color;
          if (effectiveOpacity < 1.0) {
            color = Color(
              color.red,
              color.green,
              color.blue,
              (color.alpha * effectiveOpacity).round(),
            );
          }
          return (offset: s.offset, color: color);
        }).toList();
        spanGradient.buildLut(stops);

        final allocator = SpanAllocator();

        final pt1 = transform.transformPoint(strokePaint.x1, strokePaint.y1);
        final pt2 = transform.transformPoint(strokePaint.x2, strokePaint.y2);
        spanGradient.setGradient(pt1.x, pt1.y, pt2.x, pt2.y);

        ScanlineRenderer.generateAndRender(
            rasterizer, scanline, imageBuffer, allocator, spanGradient);
      }
    }
  }

  await _savePpm('brasao.ppm', imageBuffer.getBuffer(), width, height);
  print('Saved brasao.ppm');
}

VertexStorage _transformPath(VertexStorage source, Affine transform) {
  final dest = VertexStorage();
  for (int i = 0; i < source.count; i++) {
    final v = source[i];
    if (v.command.isVertex) {
      final pt = transform.transformPoint(v.x, v.y);
      dest.addVertex(pt.x, pt.y, v.command);
    } else {
      dest.addVertex(0, 0, v.command);
    }
  }
  return dest;
}

Future<void> _savePpm(
    String filename, Uint8List buffer, int width, int height) async {
  final file = File(filename);
  final sink = file.openWrite();
  sink.write('P3\n$width $height\n255\n');
  for (int i = 0; i < width * height; i++) {
    final r = buffer[i * 4];
    final g = buffer[i * 4 + 1];
    final b = buffer[i * 4 + 2];
    sink.write('$r $g $b ');
    if ((i + 1) % width == 0) sink.write('\n');
  }
  await sink.close();
}
