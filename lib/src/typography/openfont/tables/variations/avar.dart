import 'package:agg/src/typography/io/byte_order_swapping_reader.dart';
import '../table_entry.dart';

/// avar — Axis Variations Table
///
/// https://docs.microsoft.com/en-us/typography/opentype/spec/avar
///
/// The axis variations table ('avar') is an optional table used in variable
/// fonts that use OpenType Font Variations mechanisms. It can be used to
/// modify aspects of how a design varies for different instances along a
/// particular design-variation axis.
///
/// Specifically, it allows modification of the coordinate normalization that
/// is used when processing variation data for a particular variation instance.
///
/// The 'avar' table must be used in combination with a font variations ('fvar')
/// table and other required or optional tables used in variable fonts.
class AVar extends TableEntry {
  static const String tableName = 'avar';

  @override
  String get name => tableName;

  /// Major version of the avar table (should be 1).
  int majorVersion = 0;

  /// Minor version of the avar table (should be 0).
  int minorVersion = 0;

  /// The number of variation axes for this font.
  /// This must be the same number as axisCount in the 'fvar' table.
  int axisCount = 0;

  /// The segment maps array—one segment map for each axis, in the order of
  /// axes specified in the 'fvar' table.
  List<SegmentMapRecord> axisSegmentMaps = [];

  @override
  void readContentFrom(ByteOrderSwappingBinaryReader reader) {
    // Axis variation table:
    // Type      Name            Description
    // uint16    majorVersion    Major version number of the axis variations table — set to 1.
    // uint16    minorVersion    Minor version number of the axis variations table — set to 0.
    // uint16    <reserved>      Permanently reserved; set to zero.
    // uint16    axisCount       The number of variation axes for this font.
    // SegmentMaps axisSegmentMaps[axisCount]  The segment maps array.

    majorVersion = reader.readUInt16();
    minorVersion = reader.readUInt16();
    reader.readUInt16(); // reserved
    axisCount = reader.readUInt16();

    axisSegmentMaps = List<SegmentMapRecord>.generate(
      axisCount,
      (_) => SegmentMapRecord.readFrom(reader),
    );
  }

  /// Apply avar normalization to a normalized coordinate value.
  ///
  /// Given a [normalizedValue] (typically from -1 to 1) for axis [axisIndex],
  /// returns the modified coordinate using the segment map.
  double applySegmentMap(int axisIndex, double normalizedValue) {
    if (axisIndex < 0 || axisIndex >= axisSegmentMaps.length) {
      return normalizedValue;
    }
    return axisSegmentMaps[axisIndex].applyMapping(normalizedValue);
  }
}

/// SegmentMaps record for a single axis.
///
/// Each segment map consists of a list of axis-value mapping records that
/// modify the default normalization for that axis.
class SegmentMapRecord {
  /// The array of axis value map records for this axis.
  List<AxisValueMap> axisValueMaps = [];

  static SegmentMapRecord readFrom(ByteOrderSwappingBinaryReader reader) {
    // SegmentMaps record:
    // Type          Name                                Description
    // uint16        positionMapCount                    The number of correspondence pairs for this axis.
    // AxisValueMap  axisValueMaps[positionMapCount]     The array of axis value map records for this axis.

    final record = SegmentMapRecord();
    final positionMapCount = reader.readUInt16();

    record.axisValueMaps = List<AxisValueMap>.generate(
      positionMapCount,
      (_) => AxisValueMap(
        reader.readF2Dot14(),
        reader.readF2Dot14(),
      ),
    );

    return record;
  }

  /// Apply this segment map to a normalized coordinate value.
  ///
  /// Uses piecewise linear interpolation between the axis value map records.
  double applyMapping(double normalizedValue) {
    final maps = axisValueMaps;

    // If there are no maps or less than 3 required maps (-1,0,1), return unchanged
    if (maps.isEmpty) {
      return normalizedValue;
    }

    // Find the segment containing the normalized value
    // Maps are sorted by fromCoordinate in increasing order.
    for (int i = 0; i < maps.length - 1; i++) {
      final from1 = maps[i].fromCoordinate;
      final from2 = maps[i + 1].fromCoordinate;

      if (normalizedValue >= from1 && normalizedValue <= from2) {
        final to1 = maps[i].toCoordinate;
        final to2 = maps[i + 1].toCoordinate;

        // Linear interpolation
        if (from2 == from1) {
          return to1;
        }

        final t = (normalizedValue - from1) / (from2 - from1);
        return to1 + t * (to2 - to1);
      }
    }

    // If value is outside the range of the map, clamp to endpoints
    if (normalizedValue < maps.first.fromCoordinate) {
      return maps.first.toCoordinate;
    }
    if (normalizedValue > maps.last.fromCoordinate) {
      return maps.last.toCoordinate;
    }

    return normalizedValue;
  }
}

/// AxisValueMap record that provides a single axis-value mapping correspondence.
///
/// Maps a fromCoordinate (using default normalization) to a toCoordinate
/// (the modified value).
class AxisValueMap {
  /// A normalized coordinate value obtained using default normalization.
  final double fromCoordinate;

  /// The modified, normalized coordinate value.
  final double toCoordinate;

  AxisValueMap(this.fromCoordinate, this.toCoordinate);

  @override
  String toString() => 'AxisValueMap(from: $fromCoordinate, to: $toCoordinate)';
}
