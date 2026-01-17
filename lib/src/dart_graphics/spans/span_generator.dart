import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color_f.dart';

/// Generates spans of colors for scanline rendering.
abstract class ISpanGenerator {
  void prepare();

  void generate(List<Color> span, int spanIndex, int x, int y, int len);
}

/// Floating-point variant mirroring DartGraphics's span generator API.
abstract class ISpanGeneratorFloat {
  void prepare();

  void generate(List<ColorF> span, int spanIndex, int x, int y, int len);
}
