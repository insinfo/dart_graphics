import 'dart:math' as math;

import 'package:dart_graphics/src/dart_graphics/image/iimage.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/color.dart';
import 'package:dart_graphics/src/dart_graphics/transform/affine.dart';
import 'package:dart_graphics/src/dart_graphics/spans/span_generator.dart';
import 'package:dart_graphics/src/dart_graphics/primitives/pattern_repetition.dart';

/// Span generator that fills with a repeating image pattern.
class SpanPatternImage implements ISpanGenerator {
  final IImageByte _image;
  final DartGraphicsPatternRepetition _repetition;
  final Affine _patternTransform;
  final double _masterAlpha;
  late final bool _useInverse;

  SpanPatternImage(
    this._image,
    this._repetition,
    Affine? patternTransform, {
    double masterAlpha = 1.0,
  })  : _patternTransform = patternTransform ?? Affine.identity(),
        _masterAlpha = masterAlpha.clamp(0.0, 1.0) {
    _useInverse = _patternTransform.determinant().abs() > 1e-10;
  }

  @override
  void prepare() {}

  @override
  void generate(List<Color> span, int spanIndex, int x, int y, int len) {
    final int w = _image.width;
    final int h = _image.height;
    if (w <= 0 || h <= 0) {
      for (int i = 0; i < len; i++) {
        span[spanIndex + i] = Color.transparent;
      }
      return;
    }

    for (int i = 0; i < len; i++) {
      double px = x + i.toDouble();
      double py = y.toDouble();

      if (_useInverse) {
        final p = _patternTransform.inverseTransform(px, py);
        px = p.x;
        py = p.y;
      }

      int ix = px.floor();
      int iy = py.floor();
      final Color c = _sample(ix, iy, w, h);
      span[spanIndex + i] = _applyAlpha(c, _masterAlpha);
    }
  }

  Color _sample(int x, int y, int w, int h) {
    switch (_repetition) {
      case DartGraphicsPatternRepetition.repeat:
        return _image.getPixel(_wrap(x, w), _wrap(y, h));
      case DartGraphicsPatternRepetition.repeatX:
        if (y < 0 || y >= h) return Color.transparent;
        return _image.getPixel(_wrap(x, w), _clamp(y, 0, h - 1));
      case DartGraphicsPatternRepetition.repeatY:
        if (x < 0 || x >= w) return Color.transparent;
        return _image.getPixel(_clamp(x, 0, w - 1), _wrap(y, h));
      case DartGraphicsPatternRepetition.noRepeat:
        if (x < 0 || x >= w || y < 0 || y >= h) return Color.transparent;
        return _image.getPixel(x, y);
    }
  }

  int _wrap(int v, int max) {
    if (max == 0) return 0;
    int r = v % max;
    if (r < 0) r += max;
    return r;
  }

  int _clamp(int v, int min, int max) {
    return math.max(min, math.min(max, v));
  }

  Color _applyAlpha(Color c, double alpha) {
    if (alpha >= 1.0) return c;
    final a = (c.alpha * alpha).round().clamp(0, 255);
    if (a == c.alpha) return c;
    return Color(c.red, c.green, c.blue, a);
  }
}
