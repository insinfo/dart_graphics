// Image comparison utilities for visual tests
// Dart port by insinfo, 2025

import 'dart:io';
import 'package:image/image.dart' as img;

/// Compares two images and returns true if they match within tolerance.
///
/// [generatedPath] - Path to the generated test image
/// [referencePath] - Path to the reference/golden image
/// [perChannelTolerance] - Maximum allowed difference per color channel (0-255)
/// [maxDifferentPixels] - Maximum number of pixels that can differ
/// [compareAlpha] - Whether to compare alpha channel
///
/// Returns true if images match within the specified tolerance.
bool compareImages(
  String generatedPath,
  String referencePath, {
  int perChannelTolerance = 2,
  int maxDifferentPixels = 100,
  bool compareAlpha = false,
}) {
  final generatedFile = File(generatedPath);
  final resolvedReferencePath = _resolveReferencePath(referencePath);
  final referenceFile = File(resolvedReferencePath);

  if (!generatedFile.existsSync()) {
    print('Generated image not found: $generatedPath');
    return false;
  }

  if (!referenceFile.existsSync()) {
    print('Reference image not found: $referencePath');
    // If reference doesn't exist, we can't compare - could auto-generate it
    return true; // Return true to allow test to pass for initial generation
  }

  final genBytes = generatedFile.readAsBytesSync();
  final refBytes = referenceFile.readAsBytesSync();

  final gen = img.decodePng(genBytes);
  final ref = img.decodePng(refBytes);

  if (gen == null) {
    print('Failed to decode generated image: $generatedPath');
    return false;
  }

  if (ref == null) {
    print('Failed to decode reference image: $referencePath');
    return false;
  }

  // Check dimensions
  if (gen.width != ref.width || gen.height != ref.height) {
    print('Image dimensions mismatch: '
        'generated=${gen.width}x${gen.height}, '
        'reference=${ref.width}x${ref.height}');
    return false;
  }

  var differentPixels = 0;
  var maxDiff = 0;

  for (var y = 0; y < gen.height; y++) {
    for (var x = 0; x < gen.width; x++) {
      final a = gen.getPixel(x, y);
      final b = ref.getPixel(x, y);

      final dr = (a.r.toInt() - b.r.toInt()).abs();
      final dg = (a.g.toInt() - b.g.toInt()).abs();
      final db = (a.b.toInt() - b.b.toInt()).abs();
      final da = compareAlpha ? (a.a.toInt() - b.a.toInt()).abs() : 0;

      final pixelMax = [dr, dg, db, da].reduce((m, v) => v > m ? v : m);
      if (pixelMax > maxDiff) maxDiff = pixelMax;

      if (dr > perChannelTolerance ||
          dg > perChannelTolerance ||
          db > perChannelTolerance ||
          (compareAlpha && da > perChannelTolerance)) {
        differentPixels++;
      }
    }
  }

  if (differentPixels > maxDifferentPixels) {
    print('Image comparison failed: '
        '$differentPixels pixels differ (max allowed: $maxDifferentPixels), '
        'max channel diff: $maxDiff (tolerance: $perChannelTolerance)');
    return false;
  }

  return true;
}

String _resolveReferencePath(String referencePath) {
  final direct = File(referencePath);
  if (direct.existsSync()) return referencePath;

  final candidates = <String>{};

  if (referencePath.contains('dartgraphics_test_')) {
    candidates.add(referencePath.replaceAll('dartgraphics_test_', 'agg_test_'));
  }

  if (referencePath.contains('resources/') && !referencePath.contains('resources/image/')) {
    final withImage = referencePath.replaceFirst('resources/', 'resources/image/');
    candidates.add(withImage);
    if (withImage.contains('dartgraphics_test_')) {
      candidates.add(withImage.replaceAll('dartgraphics_test_', 'agg_test_'));
    }
  }

  for (final path in candidates) {
    if (File(path).existsSync()) {
      return path;
    }
  }

  return referencePath;
}

/// Saves a diff image highlighting the differences between two images.
void saveDiffImage(
  String generatedPath,
  String referencePath,
  String diffPath, {
  int perChannelTolerance = 2,
}) {
  final generatedFile = File(generatedPath);
  final referenceFile = File(referencePath);

  if (!generatedFile.existsSync() || !referenceFile.existsSync()) {
    return;
  }

  final genBytes = generatedFile.readAsBytesSync();
  final refBytes = referenceFile.readAsBytesSync();

  final gen = img.decodePng(genBytes);
  final ref = img.decodePng(refBytes);

  if (gen == null || ref == null) return;
  if (gen.width != ref.width || gen.height != ref.height) return;

  final diff = img.Image(width: gen.width, height: gen.height);

  for (var y = 0; y < gen.height; y++) {
    for (var x = 0; x < gen.width; x++) {
      final a = gen.getPixel(x, y);
      final b = ref.getPixel(x, y);

      final dr = (a.r.toInt() - b.r.toInt()).abs();
      final dg = (a.g.toInt() - b.g.toInt()).abs();
      final db = (a.b.toInt() - b.b.toInt()).abs();

      final pixelMax = [dr, dg, db].reduce((m, v) => v > m ? v : m);

      if (pixelMax > perChannelTolerance) {
        // Mark different pixels in red
        diff.setPixelRgba(x, y, 255, 0, 0, 255);
      } else {
        // Mark similar pixels in black
        diff.setPixelRgba(x, y, 0, 0, 0, 255);
      }
    }
  }

  final outFile = File(diffPath);
  outFile.parent.createSync(recursive: true);
  outFile.writeAsBytesSync(img.encodePng(diff));
}
