// Apache2, 2016-present, WinterDev
// Dart port by insinfo

import '../../io/byte_order_swapping_reader.dart';
import 'table_entry.dart';
import 'utils.dart';

/// VDMX — Vertical Device Metrics
///
/// https://docs.microsoft.com/en-us/typography/opentype/spec/vdmx
///
/// The VDMX table relates to OpenType fonts with TrueType outlines.
/// Under Windows, the usWinAscent and usWinDescent values from the 'OS/2'
/// table will be used to determine the maximum black height for a font at
/// any given size.
///
/// Windows calls this distance the Font Height. Because TrueType instructions
/// can lead to Font Heights that differ from the actual scaled and rounded
/// values, basing the Font Height strictly on the yMax and yMin can result
/// in "lost pixels."
class VerticalDeviceMetrics extends TableEntry {
  static const String tableName = 'VDMX';

  @override
  String get name => tableName;

  /// Table version (0 or 1)
  int version = 0;

  /// Number of VDMX groups present
  int numRecs = 0;

  /// Number of aspect ratio groupings
  int numRatios = 0;

  /// Ratio ranges
  List<RatioRange> ratioRanges = [];

  /// Offsets to VDMX groups for each ratio range
  List<int> offsets = [];

  /// VDMX groups
  List<VdmxGroup> groups = [];

  @override
  void readContentFrom(ByteOrderSwappingBinaryReader reader) {
    final tableStart = reader.position;

    // Header
    // uint16    version        Version number (0 or 1).
    // uint16    numRecs        Number of VDMX groups present
    // uint16    numRatios      Number of aspect ratio groupings
    // RatioRange ratRange[numRatios]  Ratio ranges
    // Offset16  offset[numRatios]     Offset from start of table to VDMX group

    version = reader.readUInt16();
    numRecs = reader.readUInt16();
    numRatios = reader.readUInt16();

    // Read RatioRange records
    ratioRanges = [];
    for (int i = 0; i < numRatios; i++) {
      ratioRanges.add(RatioRange(
        bCharSet: reader.readUInt8(),
        xRatio: reader.readUInt8(),
        yStartRatio: reader.readUInt8(),
        yEndRatio: reader.readUInt8(),
      ));
    }

    // Read offsets
    offsets = Utils.readUInt16Array(reader, numRatios);

    // Read VDMX groups
    groups = [];
    for (final offset in offsets) {
      reader.seek(tableStart + offset);
      groups.add(VdmxGroup.readFrom(reader));
    }
  }

  /// Find the VDMX group for a given aspect ratio.
  VdmxGroup? findGroup(int xRatio, int yRatio) {
    for (int i = 0; i < ratioRanges.length; i++) {
      final range = ratioRanges[i];
      if (range.xRatio == xRatio &&
          yRatio >= range.yStartRatio &&
          yRatio <= range.yEndRatio) {
        return groups.length > i ? groups[i] : null;
      }
      // A ratio of 0 means "any"
      if (range.xRatio == 0 || range.yStartRatio == 0) {
        return groups.length > i ? groups[i] : null;
      }
    }
    return null;
  }
}

/// RatioRange record describing an aspect ratio grouping.
class RatioRange {
  /// Character set (0 = all character sets)
  final int bCharSet;

  /// Value to use for x-Ratio (0 = any)
  final int xRatio;

  /// Starting y-Ratio value
  final int yStartRatio;

  /// Ending y-Ratio value
  final int yEndRatio;

  RatioRange({
    required this.bCharSet,
    required this.xRatio,
    required this.yStartRatio,
    required this.yEndRatio,
  });
}

/// VDMX Group containing height records for specific sizes.
class VdmxGroup {
  /// Number of height records
  int recs = 0;

  /// Starting yPelHeight
  int startsz = 0;

  /// Ending yPelHeight
  int endsz = 0;

  /// VDMX height records
  List<VdmxRecord> records = [];

  static VdmxGroup readFrom(ByteOrderSwappingBinaryReader reader) {
    final group = VdmxGroup();

    // VDMXGroup:
    // uint16    recs       Number of height records in this group
    // uint8     startsz    Starting yPelHeight
    // uint8     endsz      Ending yPelHeight
    // vTable    entry[recs]  The VDMX records

    group.recs = reader.readUInt16();
    group.startsz = reader.readUInt8();
    group.endsz = reader.readUInt8();

    group.records = [];
    for (int i = 0; i < group.recs; i++) {
      group.records.add(VdmxRecord(
        yPelHeight: reader.readUInt16(),
        yMax: reader.readInt16(),
        yMin: reader.readInt16(),
      ));
    }

    return group;
  }

  /// Find the record for a given pixel height.
  VdmxRecord? findRecord(int yPelHeight) {
    for (final record in records) {
      if (record.yPelHeight == yPelHeight) {
        return record;
      }
    }
    return null;
  }
}

/// VDMX height record (vTable).
class VdmxRecord {
  /// yPelHeight to which values apply
  final int yPelHeight;

  /// Maximum value (in pels) for this yPelHeight
  final int yMax;

  /// Minimum value (in pels) for this yPelHeight
  final int yMin;

  VdmxRecord({
    required this.yPelHeight,
    required this.yMax,
    required this.yMin,
  });
}
