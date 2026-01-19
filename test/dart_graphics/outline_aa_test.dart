import 'dart:io';
import 'package:test/test.dart';
import 'package:dart_graphics/src/dart_graphics/image/image_buffer.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';
import 'package:dart_graphics/src/dart_graphics/rasterizer_outline_aa.dart';
import 'package:dart_graphics/src/dart_graphics/outline_renderer.dart';
import 'package:dart_graphics/src/dart_graphics/line_profile_aa.dart';
import 'package:dart_graphics/src/dart_graphics/line_aa_basics.dart';
import 'package:dart_graphics/src/dart_graphics/image/png_encoder.dart';
import 'package:dart_graphics/src/dart_graphics/graphics2D.dart';
import '../test_utils/png_golden.dart';

void main() {
  test('Outline AA Rendering Test', () {
    const width = 100;
    const height = 100;
    
    final buffer = ImageBuffer(width, height);
    // Clear to white
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        buffer.setPixel(x, y, Color(255, 255, 255, 255));
      }
    }
    
    final profile = LineProfileAA();
    profile.width(20.0);
    
    final ren = OutlineRenderer(buffer, profile, Color(0, 0, 0, 255));
    final ras = RasterizerOutlineAA(ren);
    ras.roundCap = true;
    
    ras.moveTo(LineCoord.conv(10.0), LineCoord.conv(10.0));
    ras.lineTo(LineCoord.conv(50.0), LineCoord.conv(90.0));
    ras.lineTo(LineCoord.conv(90.0), LineCoord.conv(10.0));
    
    ras.render(false);
    
    // Save image
    Directory('test/tmp').createSync(recursive: true);
    const outPath = 'test/tmp/outline_aa.png';
    PngEncoder.saveImage(buffer, outPath);

    expectPngMatchesGolden(outPath, 'resources/outline_aa.png');
  });

  test('BasicGraphics2D drawLine renders with profile', () {
    const width = 32;
    const height = 32;

    final buffer = ImageBuffer(width, height);
    final g = buffer.newGraphics2D() as BasicGraphics2D;
    g.clear(Color(255, 255, 255, 255));
    g.drawLine(4, 16, 28, 16, Color(0, 0, 0, 255), thickness: 6.0);

    final center = buffer.getPixel(16, 16);
    expect(center.alpha, equals(255));
    expect(center.red, lessThan(10));
    expect(center.green, lessThan(10));
    expect(center.blue, lessThan(10));

    final outside = buffer.getPixel(16, 2);
    expect(outside, Color(255, 255, 255, 255));
  });
}
