import 'dart:io';
import 'package:test/test.dart';
import 'package:dart_graphics/src/dart_graphics/image/image_buffer.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';
import 'package:dart_graphics/src/dart_graphics/scanline_rasterizer.dart';
import 'package:dart_graphics/src/dart_graphics/scanline_renderer.dart';
import 'package:dart_graphics/src/dart_graphics/scanline_unpacked8.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/vertex_storage.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/stroke.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/stroke_math.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/gsv_text.dart';
import 'package:dart_graphics/src/dart_graphics/image/png_encoder.dart';
import '../test_utils/png_golden.dart';

void main() {
  test('Line Join Test', () {
    const width = 300;
    const height = 100;
    
    final buffer = ImageBuffer(width, height);
    // Clear to white
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        buffer.SetPixel(x, y, Color(255, 255, 255, 255));
      }
    }
    
    final ras = ScanlineRasterizer();
    final sl = ScanlineUnpacked8();
    final black = Color(0, 0, 0, 255);
    
    final joins = [LineJoin.miter, LineJoin.round, LineJoin.bevel];
    
    for (var i = 0; i < joins.length; i++) {
      final dx = 100.0 * i;
      final path = VertexStorage();
      path.moveTo(10.0 + dx, 70.0);
      path.lineTo(50.0 + dx, 30.0);
      path.lineTo(90.0 + dx, 70.0);
      
      final stroke = Stroke(path);
      stroke.width = 25.0;
      stroke.lineJoin = joins[i];
      
      ras.reset();
      ras.add_path(stroke);
      ScanlineRenderer.renderSolid(ras, sl, buffer, black);
    }

    // Text labels (match DartGraphics-rust/tests/t21_line_join.rs)
    final labels = ['Miter', 'Round', 'Bevel'];
    final textX = [29.0, 125.0, 225.0];
    for (var i = 0; i < labels.length; i++) {
      final txt = GsvText();
      txt.size(12.0);
      txt.text(labels[i]);
      txt.startPoint(textX[i], 90.0);
      txt.flip(true);

      final txtStroke = Stroke(txt);
      txtStroke.width = 1.0;

      ras.reset();
      ras.add_path(txtStroke);
      ScanlineRenderer.renderSolid(ras, sl, buffer, black);
    }
    
    // Save image
    Directory('test/tmp').createSync(recursive: true);
    const outPath = 'test/tmp/line_join.png';
    PngEncoder.saveImage(buffer, outPath);

    expectPngMatchesGolden(
      outPath,
      'resources/line_join.png',
      perChannelTolerance: 22,
      diffOutputPath: 'test/tmp/line_join.diff.png',
    );
  });
}
