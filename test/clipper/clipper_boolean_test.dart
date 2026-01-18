import 'package:test/test.dart';
import 'package:dart_graphics/src/clipper/clipper.dart' as clipper;

clipper.Path64 _rect(int x1, int y1, int x2, int y2) {
  return [
    clipper.Point64(x1, y1),
    clipper.Point64(x2, y1),
    clipper.Point64(x2, y2),
    clipper.Point64(x1, y2),
  ];
}

double _absArea(clipper.Paths64 paths) {
  var total = 0.0;
  for (final path in paths) {
    total += path.area.abs();
  }
  return total;
}

void main() {
  group('Clipper boolean ops', () {
    final subject = [_rect(0, 0, 10, 10)];
    final clip = [_rect(5, 0, 15, 10)];

    test('union area', () {
      final result = clipper.Clipper.booleanOp(
        clipType: clipper.ClipType.union,
        subject: subject,
        clip: clip,
        fillRule: clipper.FillRule.nonZero,
      );
      expect(_absArea(result), closeTo(150.0, 1e-6));
    });

    test('intersection area', () {
      final result = clipper.Clipper.booleanOp(
        clipType: clipper.ClipType.intersection,
        subject: subject,
        clip: clip,
        fillRule: clipper.FillRule.nonZero,
      );
      expect(_absArea(result), closeTo(50.0, 1e-6));
    });

    test('difference area', () {
      final result = clipper.Clipper.booleanOp(
        clipType: clipper.ClipType.difference,
        subject: subject,
        clip: clip,
        fillRule: clipper.FillRule.nonZero,
      );
      expect(_absArea(result), closeTo(50.0, 1e-6));
    });

    test('xor area', () {
      final result = clipper.Clipper.booleanOp(
        clipType: clipper.ClipType.xor,
        subject: subject,
        clip: clip,
        fillRule: clipper.FillRule.nonZero,
      );
      expect(_absArea(result), closeTo(100.0, 1e-6));
    });
  });

  group('Clipper Path64 utilities', () {
    test('ramerDouglasPeucker reduces points', () {
      final path = <clipper.Point64>[
        const clipper.Point64(0, 0),
        const clipper.Point64(2, 0),
        const clipper.Point64(4, 0),
        const clipper.Point64(6, 0),
        const clipper.Point64(8, 0),
        const clipper.Point64(10, 0),
      ];
      final simplified = path.ramerDouglasPeucker(0.1);
      expect(simplified.length, lessThan(path.length));
    });
  });
}
