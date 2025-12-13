import 'package:agg/src/typography/io/byte_order_swapping_reader.dart';
import '../table_entry.dart';

/// cvar — CVT Variations Table
///
/// https://docs.microsoft.com/en-us/typography/opentype/spec/cvar
///
/// The CVT variations table ('cvar') is an optional table used in TrueType-
/// based variable fonts to provide variation data for the control value table
/// ('cvt').
///
/// The 'cvar' table is used in TrueType-based variable fonts to vary the
/// values in the CVT (Control Value Table) across the font's variation space.
/// This allows for fine-tuning of hinted rendering at different design
/// instances.
class CVar extends TableEntry {
  static const String tableName = 'cvar';

  @override
  String get name => tableName;

  /// Major version of the cvar table (should be 1).
  int majorVersion = 0;

  /// Minor version of the cvar table (should be 0).
  int minorVersion = 0;

  /// Tuple variation count from header.
  int tupleVariationCount = 0;

  /// Whether shared point numbers are used (from header flags).
  bool sharedPointNumbers = false;

  /// Offset to serialized data.
  int dataOffset = 0;

  /// Tuple variation headers for CVT deltas.
  List<TupleVariationHeader> tupleVariationHeaders = [];

  /// Serialized CVT delta data.
  List<int> serializedData = [];

  @override
  void readContentFrom(ByteOrderSwappingBinaryReader reader) {
    final tableStart = reader.position;

    // cvar — CVT Variations Table Header
    // Type      Name                Description
    // uint16    majorVersion        Major version number of the CVT variations table — set to 1.
    // uint16    minorVersion        Minor version number of the CVT variations table — set to 0.
    // uint16    tupleVariationCount A packed field.
    //                               The high 4 bits are flags, and the low 12 bits are
    //                               the number of tuple variation tables for this glyph.
    //                               The count can be any number between 1 and 4095.
    // Offset16  dataOffset          Offset from the start of the 'cvar' table to the serialized data.
    // TupleVariationHeader[tupleVariationCount]  Array of tuple variation headers.

    majorVersion = reader.readUInt16();
    minorVersion = reader.readUInt16();

    final tupleVariationCountRaw = reader.readUInt16();
    dataOffset = reader.readUInt16();

    // Parse flags from tupleVariationCount
    // Bit 15: SHARED_POINT_NUMBERS - if set, shared point numbers are used
    sharedPointNumbers = (tupleVariationCountRaw & 0x8000) != 0;
    tupleVariationCount = tupleVariationCountRaw & 0x0FFF;

    // Read tuple variation headers
    tupleVariationHeaders = [];
    for (int i = 0; i < tupleVariationCount; i++) {
      tupleVariationHeaders.add(TupleVariationHeader.readFrom(reader));
    }

    // If there's serialized data, read it
    if (dataOffset > 0) {
      reader.seek(tableStart + dataOffset);
      // The serialized data contains:
      // - Shared point numbers (if SHARED_POINT_NUMBERS flag is set)
      // - Per-tuple point numbers and deltas

      // For simplicity, we'll store raw data for now.
      // Full implementation would parse the packed delta values.
      // The data size depends on the tuple headers and their data sizes.
      int totalDataSize = 0;
      for (final header in tupleVariationHeaders) {
        totalDataSize += header.variationDataSize;
      }

      if (totalDataSize > 0) {
        serializedData = reader.readBytes(totalDataSize);
      }
    }
  }

  /// Check if shared point numbers are used.
  bool get hasSharedPointNumbers => sharedPointNumbers;
}

/// Tuple variation header used in cvar table.
///
/// This is similar to the gvar tuple variation header but specific to CVT variations.
class TupleVariationHeader {
  /// The size in bytes of the serialized data for this tuple variation table.
  int variationDataSize = 0;

  /// A packed field containing flags and tuple index.
  int tupleIndex = 0;

  /// Peak tuple coordinates (if embedded).
  List<double>? peakTuple;

  /// Intermediate start tuple (if present).
  List<double>? intermediateStartTuple;

  /// Intermediate end tuple (if present).
  List<double>? intermediateEndTuple;

  // Flags
  static const int embeddedPeakTuple = 0x8000;
  static const int intermediateRegion = 0x4000;
  static const int privatePointNumbers = 0x2000;
  static const int tupleIndexMask = 0x0FFF;

  bool get hasEmbeddedPeakTuple => (tupleIndex & embeddedPeakTuple) != 0;
  bool get hasIntermediateRegion => (tupleIndex & intermediateRegion) != 0;
  bool get hasPrivatePointNumbers => (tupleIndex & privatePointNumbers) != 0;
  int get tupleIndexValue => tupleIndex & tupleIndexMask;

  static TupleVariationHeader readFrom(ByteOrderSwappingBinaryReader reader) {
    final header = TupleVariationHeader();

    // TupleVariationHeader:
    // Type      Name                Description
    // uint16    variationDataSize   The size in bytes of the serialized data for this tuple variation table.
    // uint16    tupleIndex          A packed field. The high 4 bits are flags.
    //                               The low 12 bits are an index into a shared tuple records array.
    // Tuple     peakTuple           Peak tuple record for this tuple variation table — optional,
    //                               determined by flags in the tupleIndex value.
    // Tuple     intermediateStartTuple  Intermediate start tuple — optional.
    // Tuple     intermediateEndTuple    Intermediate end tuple — optional.

    header.variationDataSize = reader.readUInt16();
    header.tupleIndex = reader.readUInt16();

    // Note: Reading peak and intermediate tuples requires knowing the axis count,
    // which is determined by the fvar table. For full implementation, the axis
    // count should be passed in.

    return header;
  }

  /// Read the optional tuple coordinates given the axis count.
  void readTuples(ByteOrderSwappingBinaryReader reader, int axisCount) {
    if (hasEmbeddedPeakTuple) {
      peakTuple = List<double>.generate(
        axisCount,
        (_) => reader.readF2Dot14(),
      );
    }

    if (hasIntermediateRegion) {
      intermediateStartTuple = List<double>.generate(
        axisCount,
        (_) => reader.readF2Dot14(),
      );
      intermediateEndTuple = List<double>.generate(
        axisCount,
        (_) => reader.readF2Dot14(),
      );
    }
  }
}
