import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:test/test.dart';

img.Image _decodePngFile(String path) {
  final bytes = File(path).readAsBytesSync();
  final decoded = img.decodePng(bytes);
  if (decoded == null) {
    throw StateError('Failed to decode PNG: $path');
  }
  return decoded;
}

/// Compares the pixel content of 2 PNGs.
///
/// This ignores PNG compression/metadata differences by decoding both images.
void expectPngMatchesGolden(
  String generatedPath,
  String goldenPath, {
  int perChannelTolerance = 0,
  int maxDifferentPixels = 0,
  bool compareAlpha = true,
  String? diffOutputPath,
}) {
  final generatedFile = File(generatedPath);
  final goldenFile = File(goldenPath);

  expect(generatedFile.existsSync(), isTrue, reason: 'Missing $generatedPath');
  expect(goldenFile.existsSync(), isTrue, reason: 'Missing golden $goldenPath');

  final gen = _decodePngFile(generatedPath);
  final gold = _decodePngFile(goldenPath);

  expect(gen.width, gold.width, reason: 'Width mismatch vs golden');
  expect(gen.height, gold.height, reason: 'Height mismatch vs golden');

  var differentPixels = 0;
  var maxAbsDiff = 0;
  var firstDiffX = -1;
  var firstDiffY = -1;
  String? firstA;
  String? firstB;

  img.Image? diff;
  if (diffOutputPath != null) {
    diff = img.Image(width: gen.width, height: gen.height);
  }

  for (var y = 0; y < gen.height; y++) {
    for (var x = 0; x < gen.width; x++) {
      final a = gen.getPixel(x, y);
      final b = gold.getPixel(x, y);

      final dr = (a.r.toInt() - b.r.toInt()).abs();
      final dg = (a.g.toInt() - b.g.toInt()).abs();
      final db = (a.b.toInt() - b.b.toInt()).abs();
      final da = compareAlpha ? (a.a.toInt() - b.a.toInt()).abs() : 0;

      final pixelMax = [dr, dg, db, da].reduce((m, v) => v > m ? v : m);
      if (pixelMax > maxAbsDiff) maxAbsDiff = pixelMax;

      if (dr > perChannelTolerance ||
          dg > perChannelTolerance ||
          db > perChannelTolerance ||
          (compareAlpha && da > perChannelTolerance)) {
        differentPixels++;

        if (firstDiffX == -1) {
          firstDiffX = x;
          firstDiffY = y;
          firstA = 'r=${a.r.toInt()} g=${a.g.toInt()} b=${a.b.toInt()} a=${a.a.toInt()}';
          firstB = 'r=${b.r.toInt()} g=${b.g.toInt()} b=${b.b.toInt()} a=${b.a.toInt()}';
        }

        if (diff != null) {
          // Visualize per-pixel max channel difference (grayscale).
          diff.setPixelRgb(x, y, pixelMax, pixelMax, pixelMax);
        }
      } else {
        if (diff != null) {
          diff.setPixelRgba(x, y, 0, 0, 0, 255);
        }
      }
    }
  }

  if (diff != null) {
    final out = File(diffOutputPath!);
    out.parent.createSync(recursive: true);
    out.writeAsBytesSync(img.encodePng(diff));
  }

  expect(
    differentPixels,
    lessThanOrEqualTo(maxDifferentPixels),
    reason:
        'Image mismatch vs golden. differentPixels=$differentPixels, maxAbsDiff=$maxAbsDiff, '
        'tolerance=$perChannelTolerance, allowedDifferentPixels=$maxDifferentPixels'
        '${diffOutputPath != null ? ', diff=$diffOutputPath' : ''}'
        '${firstDiffX != -1 ? ', firstDiff=($firstDiffX,$firstDiffY) a=[$firstA] b=[$firstB]' : ''}',
  );
}
