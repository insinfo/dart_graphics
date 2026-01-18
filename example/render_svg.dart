import 'dart:io';
import 'package:dart_graphics/src/dart_graphics/graphics2D.dart';
import 'package:dart_graphics/src/dart_graphics/image/image_buffer.dart';
import 'package:dart_graphics/src/dart_graphics/image/png_encoder.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';

Future<void> main() async {
  final file = File('resources/image/brasao_editado_1.svg');
  if (!file.existsSync()) {
    print('File not found: ${file.path}');
    return;
  }

  final svgContent = file.readAsStringSync();

  // SVG dimensions (from file)
  // width="694px" height="748px"
  // viewBox="0 0 539.56 581.43"
  const width = 694;
  const height = 748;
  const viewBoxX = 0.0;
  const viewBoxY = 0.0;
  const viewBoxW = 539.56;
  const viewBoxH = 581.43;

  final imageBuffer = ImageBuffer(width, height);
  final g = BasicGraphics2D(imageBuffer);

  g.renderSvgString(
    svgContent,
    viewBoxX: viewBoxX,
    viewBoxY: viewBoxY,
    viewBoxWidth: viewBoxW,
    viewBoxHeight: viewBoxH,
    background: Color(255, 255, 255, 255),
  );

  Directory('test/tmp').createSync(recursive: true);
  const outputPath = 'test/tmp/brasao.png';
  PngEncoder.saveImage(imageBuffer, outputPath);
   print('Saved $outputPath');
}
