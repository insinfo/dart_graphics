import 'dart:io';
import 'dart:math' as math;

import 'package:dart_graphics/src/dart_graphics/graphics2D.dart';
import 'package:dart_graphics/src/dart_graphics/image/image_buffer.dart';
import 'package:dart_graphics/src/dart_graphics/image/png_encoder.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';
import 'package:dart_graphics/src/typography/openfont/open_font_reader.dart';
import 'package:dart_graphics/src/typography/openfont/typeface.dart';

void main() async {
  final width = 1200;
  final height = 700;
  final buffer = ImageBuffer(width, height);
  final g = buffer.newGraphics2D() as BasicGraphics2D;

  g.clear(Color.white);
  g.textBaseline = TextBaseline.alphabetic;

  final samples = <_TextSample>[
    _TextSample(
      text: 'DartGraphics - Sans Regular',
      fontPath:
          'resources/fonts/liberation-fonts-ttf-1.07.0/LiberationSans-Regular.ttf',
      size: 48,
      color: Color(22, 44, 120),
      x: 80,
      y: 120,
      rotation: 0.0,
      align: TextAlign.left,
      baseline: TextBaseline.alphabetic,
    ),
    _TextSample(
      text: 'Serif Bold / rotate -12°',
      fontPath:
          'resources/fonts/liberation-fonts-ttf-1.07.0/LiberationSerif-Bold.ttf',
      size: 42,
      color: Color(180, 40, 40),
      x: 720,
      y: 140,
      rotation: -12 * math.pi / 180,
      align: TextAlign.left,
      baseline: TextBaseline.alphabetic,
    ),
    _TextSample(
      text: 'Mono Italic / rotate 20°',
      fontPath:
          'resources/fonts/liberation-fonts-ttf-1.07.0/LiberationMono-Italic.ttf',
      size: 34,
      color: Color(25, 120, 75),
      x: 140,
      y: 260,
      rotation: 20 * math.pi / 180,
      align: TextAlign.left,
      baseline: TextBaseline.alphabetic,
    ),
    _TextSample(
      text: 'Comic Relief / rotate 8°',
      fontPath: 'resources/fonts/Comic_Relief/ComicRelief-Regular.ttf',
      size: 40,
      color: Color(110, 65, 180),
      x: 760,
      y: 320,
      rotation: 8 * math.pi / 180,
      align: TextAlign.left,
      baseline: TextBaseline.alphabetic,
    ),
    _TextSample(
      text: 'Liberation Sans Narrow',
      fontPath:
          'resources/fonts/liberation-fonts-ttf-1.07.0/LiberationSansNarrow-BoldItalic.ttf',
      size: 56,
      color: Color(200, 110, 0),
      x: 160,
      y: 470,
      rotation: -18 * math.pi / 180,
      align: TextAlign.left,
      baseline: TextBaseline.alphabetic,
    ),
    _TextSample(
      text: 'Serif Italic / rotate 30°',
      fontPath:
          'resources/fonts/liberation-fonts-ttf-1.07.0/LiberationSerif-Italic.ttf',
      size: 30,
      color: Color(0, 120, 150),
      x: 780,
      y: 560,
      rotation: 30 * math.pi / 180,
      align: TextAlign.left,
      baseline: TextBaseline.alphabetic,
    ),
  ];

  final typefaces = <String, Typeface>{};
  for (final path in samples.map((s) => s.fontPath).toSet()) {
    final typeface = await _loadTypeface(path);
    if (typeface != null) {
      typefaces[path] = typeface;
    }
  }

  for (final sample in samples) {
    final typeface = typefaces[sample.fontPath];
    if (typeface == null) continue;

    g.save();
    g.translate(sample.x, sample.y);
    g.rotate(sample.rotation);
    g.textAlign = sample.align;
    g.textBaseline = sample.baseline;
    g.setFont(typeface, sample.size);
    g.fillColor = sample.color;
    g.drawTextCurrent(sample.text, x: 0, y: 0);
    g.restore();
  }

  const outputPath = 'render_text_example.png';
  PngEncoder.saveImage(buffer, outputPath);
  print('PNG salvo em: $outputPath');
}

Future<Typeface?> _loadTypeface(String fontPath) async {
  final file = File(fontPath);
  if (!file.existsSync()) {
    print('Font file not found: $fontPath');
    return null;
  }

  try {
    final bytes = await file.readAsBytes();
    final reader = OpenFontReader();
    return reader.read(bytes);
  } catch (e) {
    print('Failed to load font $fontPath: $e');
    return null;
  }
}

class _TextSample {
  final String text;
  final String fontPath;
  final double size;
  final Color color;
  final double x;
  final double y;
  final double rotation;
  final TextAlign align;
  final TextBaseline baseline;

  const _TextSample({
    required this.text,
    required this.fontPath,
    required this.size,
    required this.color,
    required this.x,
    required this.y,
    required this.rotation,
    required this.align,
    required this.baseline,
  });
}
