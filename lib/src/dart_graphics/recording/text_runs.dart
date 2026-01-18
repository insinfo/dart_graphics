import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';

enum FontStyleLite { normal, italic, oblique }

enum FontWeightLite {
  w100,
  w200,
  w300,
  w400,
  w500,
  w600,
  w700,
  w800,
  w900,
}

enum TextDirectionLite { ltr, rtl }

enum TextAlignLite { left, right, center, justify, start, end }

enum TextBaselineLite { alphabetic, ideographic, hanging, middle }

/// Text style for backend-agnostic text runs.
class TextStyle {
  final String fontFamily;
  final double fontSize;
  final Color color;
  final FontStyleLite fontStyle;
  final FontWeightLite fontWeight;
  final double letterSpacing;
  final double wordSpacing;
  final double? height;

  const TextStyle({
    required this.fontFamily,
    required this.fontSize,
    required this.color,
    this.fontStyle = FontStyleLite.normal,
    this.fontWeight = FontWeightLite.w400,
    this.letterSpacing = 0.0,
    this.wordSpacing = 0.0,
    this.height,
  });
}

class GlyphPosition {
  final int glyphId;
  final double x;
  final double y;
  final double advanceX;
  final double advanceY;
  final int? cluster;

  const GlyphPosition(
    this.glyphId,
    this.x,
    this.y, {
    this.advanceX = 0.0,
    this.advanceY = 0.0,
    this.cluster,
  });
}

class GlyphRun {
  final TextStyle style;
  final List<GlyphPosition> glyphs;
  final double x;
  final double y;
  final TextDirectionLite direction;
  final List<int>? clusters;

  const GlyphRun(
    this.style,
    this.glyphs, {
    this.x = 0.0,
    this.y = 0.0,
    this.direction = TextDirectionLite.ltr,
    this.clusters,
  });
}

class TextRun {
  final String text;
  final TextStyle style;
  final double x;
  final double y;
  final TextDirectionLite direction;
  final TextAlignLite align;
  final TextBaselineLite baseline;
  final double? maxWidth;
  final List<GlyphRun>? glyphRuns;

  const TextRun(
    this.text,
    this.style,
    this.x,
    this.y, {
    this.direction = TextDirectionLite.ltr,
    this.align = TextAlignLite.start,
    this.baseline = TextBaselineLite.alphabetic,
    this.maxWidth,
    this.glyphRuns,
  });
}
