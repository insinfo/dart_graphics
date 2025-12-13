// MIT, 2019-present, WinterDev
// Ported to Dart by insinfo, 2025

import 'dart:math' as math;
import 'item_variation_store.dart';
import 'tuple_variation.dart';
import 'gvar.dart';

/// Represents a set of variation axis values for variable fonts.
/// Each entry is a tag (like 'wght', 'wdth') mapped to a normalized value (-1.0 to 1.0).
class VariationCoordinates {
  final Map<String, double> _coords = {};

  /// Create empty coordinates
  VariationCoordinates();

  /// Create from a map of tag -> normalized value
  VariationCoordinates.from(Map<String, double> coords) {
    _coords.addAll(coords);
  }

  /// Set a coordinate value
  void set(String tag, double value) {
    _coords[tag] = value.clamp(-1.0, 1.0);
  }

  /// Get a coordinate value (defaults to 0.0 if not set)
  double get(String tag) => _coords[tag] ?? 0.0;

  /// Get all tags
  Iterable<String> get tags => _coords.keys;

  /// Check if any coordinates are non-zero
  bool get hasVariations => _coords.values.any((v) => v != 0.0);

  /// Convert axis tags to an ordered list of values
  List<double> toOrderedList(List<String> axisTags) {
    return axisTags.map((tag) => get(tag)).toList();
  }

  @override
  String toString() => _coords.toString();
}

/// Helper class for calculating variation deltas
class VariationCalculator {
  /// Calculate scalar for a variation region given axis coordinates.
  /// 
  /// The scalar is calculated as the product of per-axis scalars.
  /// Each axis scalar is computed based on where the coordinate falls
  /// within the region's start/peak/end range.
  /// 
  /// Returns a value between 0.0 and 1.0.
  static double calculateRegionScalar(
    List<double> axisCoords,
    VariationRegion region,
  ) {
    double scalar = 1.0;

    for (int i = 0; i < axisCoords.length && i < region.regionAxes!.length; i++) {
      final coord = axisCoords[i];
      final axis = region.regionAxes![i];
      
      final axisScalar = calculateAxisScalar(
        coord,
        axis.startCoord,
        axis.peakCoord,
        axis.endCoord,
      );
      
      scalar *= axisScalar;
      
      // Early exit if scalar becomes 0
      if (scalar == 0.0) break;
    }

    return scalar;
  }

  /// Calculate scalar for a single axis
  static double calculateAxisScalar(
    double coord,
    double start,
    double peak,
    double end,
  ) {
    // If peak is 0, this axis has no effect
    if (peak == 0.0) return 1.0;

    // If coordinate is at peak, full contribution
    if (coord == peak) return 1.0;

    // If coordinate is outside the region, no contribution
    if (coord <= start || coord >= end) return 0.0;

    // If coordinate is between start and peak
    if (coord < peak) {
      // Avoid division by zero
      if (peak == start) return 1.0;
      return (coord - start) / (peak - start);
    }

    // If coordinate is between peak and end
    // Avoid division by zero
    if (end == peak) return 1.0;
    return (end - coord) / (end - peak);
  }

  /// Calculate interpolated delta from ItemVariationStore for a given delta set index
  static double calculateDelta(
    ItemVariationStore store,
    int outerIndex,
    int innerIndex,
    List<double> axisCoords,
  ) {
    if (store.itemVariationData == null ||
        outerIndex < 0 ||
        outerIndex >= store.itemVariationData!.length) {
      return 0.0;
    }

    final itemData = store.itemVariationData![outerIndex];
    final deltas = itemData.getDeltaSet(innerIndex);
    if (deltas.isEmpty) return 0.0;

    final regionList = store.variationRegionList;
    if (regionList == null || regionList.variationRegions == null) {
      return 0.0;
    }

    double totalDelta = 0.0;

    for (int i = 0; i < deltas.length && i < (itemData.regionIndices?.length ?? 0); i++) {
      final regionIndex = itemData.regionIndices![i];
      if (regionIndex < 0 || regionIndex >= regionList.variationRegions!.length) {
        continue;
      }

      final region = regionList.variationRegions![regionIndex];
      final scalar = calculateRegionScalar(axisCoords, region);
      
      totalDelta += deltas[i] * scalar;
    }

    return totalDelta;
  }

  /// Calculate scalar for a TupleVariationHeader
  static double calculateTupleScalar(
    TupleVariationHeader header,
    List<double> axisCoords,
    List<TupleRecord>? sharedTuples,
  ) {
    TupleRecord? peakTuple = header.peakTuple;
    
    // If no embedded peak tuple, get from shared tuples
    if (peakTuple == null) {
      final tupleIndex = header.tupleIndex & TupleIndexFormat.TUPLE_INDEX_MASK;
      if (sharedTuples != null && tupleIndex < sharedTuples.length) {
        peakTuple = sharedTuples[tupleIndex];
      }
    }

    if (peakTuple == null) return 0.0;

    double scalar = 1.0;

    for (int i = 0; i < axisCoords.length && i < peakTuple.coords.length; i++) {
      final coord = axisCoords[i];
      final peak = peakTuple.coords[i];
      
      double start = 0.0;
      double end = 0.0;

      // Use intermediate region if present
      if (header.intermediateStartTuple != null &&
          header.intermediateEndTuple != null) {
        start = header.intermediateStartTuple!.coords[i];
        end = header.intermediateEndTuple!.coords[i];
      } else {
        // Infer start/end from peak
        if (peak > 0) {
          start = 0.0;
          end = 1.0;
        } else if (peak < 0) {
          start = -1.0;
          end = 0.0;
        } else {
          // peak == 0, this axis doesn't contribute
          continue;
        }
      }

      final axisScalar = calculateAxisScalar(coord, start, peak, end);
      scalar *= axisScalar;

      if (scalar == 0.0) break;
    }

    return scalar;
  }

  /// Apply glyph variations from GVar table
  static void applyGlyphVariations(
    GVar gvar,
    int glyphIndex,
    int pointCount,
    List<double> axisCoords,
    List<int> xCoords,
    List<int> yCoords,
  ) {
    final glyphData = gvar.getGlyphVariationData(glyphIndex, pointCount);
    if (glyphData == null || glyphData.tupleVariationHeaders == null) {
      return;
    }

    for (final header in glyphData.tupleVariationHeaders!) {
      final scalar = calculateTupleScalar(header, axisCoords, gvar.sharedTuples);
      if (scalar == 0.0) continue;

      final deltasX = header.deltasX;
      final deltasY = header.deltasY;
      final points = header.points;

      if (deltasX == null || deltasY == null) continue;

      if (points == null) {
        // Apply to all points
        for (int i = 0; i < deltasX.length && i < xCoords.length; i++) {
          xCoords[i] += (deltasX[i] * scalar).round();
          yCoords[i] += (deltasY[i] * scalar).round();
        }
      } else {
        // Apply to specified points only
        for (int i = 0; i < deltasX.length && i < points.length; i++) {
          final pointIndex = points[i];
          if (pointIndex < xCoords.length) {
            xCoords[pointIndex] += (deltasX[i] * scalar).round();
            yCoords[pointIndex] += (deltasY[i] * scalar).round();
          }
        }
      }
    }
  }
}

/// Utility for normalizing user-space axis values to design space
class AxisNormalizer {
  /// Normalize a user-space value to design space (-1.0 to 1.0)
  /// 
  /// [value] - the user-space value (e.g., 400 for weight)
  /// [minValue] - minimum axis value from fvar
  /// [defaultValue] - default axis value from fvar
  /// [maxValue] - maximum axis value from fvar
  static double normalize(
    double value,
    double minValue,
    double defaultValue,
    double maxValue,
  ) {
    // Clamp to valid range
    value = value.clamp(minValue, maxValue);

    if (value < defaultValue) {
      // Negative region: minValue maps to -1.0, defaultValue maps to 0.0
      if (defaultValue == minValue) return 0.0;
      return (value - defaultValue) / (defaultValue - minValue);
    } else if (value > defaultValue) {
      // Positive region: defaultValue maps to 0.0, maxValue maps to 1.0
      if (maxValue == defaultValue) return 0.0;
      return (value - defaultValue) / (maxValue - defaultValue);
    } else {
      return 0.0;
    }
  }

  /// Denormalize a design space value back to user space
  static double denormalize(
    double normalizedValue,
    double minValue,
    double defaultValue,
    double maxValue,
  ) {
    normalizedValue = normalizedValue.clamp(-1.0, 1.0);

    if (normalizedValue < 0) {
      return defaultValue + normalizedValue * (defaultValue - minValue);
    } else if (normalizedValue > 0) {
      return defaultValue + normalizedValue * (maxValue - defaultValue);
    } else {
      return defaultValue;
    }
  }
}
