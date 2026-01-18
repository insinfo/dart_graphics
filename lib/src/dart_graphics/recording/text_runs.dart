import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';

/// Basic text style for backend-agnostic text runs.
class TextStyle {
  final String fontFamily;
  final double fontSize;
  final Color color;
  final double letterSpacing;
  final double wordSpacing;

  const TextStyle({
    required this.fontFamily,
    required this.fontSize,
    required this.color,
    this.letterSpacing = 0.0,
    this.wordSpacing = 0.0,
  });
}

class GlyphPosition {
  final int glyphId;
  final double x;
  final double y;

  const GlyphPosition(this.glyphId, this.x, this.y);
}

class GlyphRun {
  final TextStyle style;
  final List<GlyphPosition> glyphs;

  const GlyphRun(this.style, this.glyphs);
}

class TextRun {
  final String text;
  final TextStyle style;
  final double x;
  final double y;

  const TextRun(this.text, this.style, this.x, this.y);
}
