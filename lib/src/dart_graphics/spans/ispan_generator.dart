import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';

abstract class ISpanGenerator {
  void prepare();
  void generate(List<Color> span, int spanIndex, int x, int y, int len);
}
