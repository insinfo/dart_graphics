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
  bool compositeOnWhite = false,
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

  int compositeChannel(int src, int alpha, int bg) {
    return ((src * alpha) + (bg * (255 - alpha)) + 127) ~/ 255;
  }

  for (var y = 0; y < gen.height; y++) {
    for (var x = 0; x < gen.width; x++) {
      final a = gen.getPixel(x, y);
      final b = gold.getPixel(x, y);

      int ar = a.r.toInt();
      int ag = a.g.toInt();
      int ab = a.b.toInt();
      int aa = a.a.toInt();

      int br = b.r.toInt();
      int bg = b.g.toInt();
      int bb = b.b.toInt();
      int ba = b.a.toInt();

      if (compositeOnWhite) {
        ar = compositeChannel(ar, aa, 255);
        ag = compositeChannel(ag, aa, 255);
        ab = compositeChannel(ab, aa, 255);
        aa = 255;

        br = compositeChannel(br, ba, 255);
        bg = compositeChannel(bg, ba, 255);
        bb = compositeChannel(bb, ba, 255);
        ba = 255;
      }

      final dr = (ar - br).abs();
      final dg = (ag - bg).abs();
      final db = (ab - bb).abs();
      final da = compareAlpha && !compositeOnWhite ? (aa - ba).abs() : 0;

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
          firstA =
              'r=${a.r.toInt()} g=${a.g.toInt()} b=${a.b.toInt()} a=${a.a.toInt()}';
          firstB =
              'r=${b.r.toInt()} g=${b.g.toInt()} b=${b.b.toInt()} a=${b.a.toInt()}';
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
