// Apache2, 2016-present, WinterDev
// Dart port by insinfo

import '../../io/byte_order_swapping_reader.dart';
import 'table_entry.dart';

/// LTSH — Linear Threshold
///
/// https://docs.microsoft.com/en-us/typography/opentype/spec/ltsh
///
/// The Linear Threshold table is used to improve the performance of
/// scaling TrueType fonts. It determines when a font can be scaled
/// linearly without loss of glyph shape quality.
///
/// The table consists of a header followed by an array of byte values,
/// one for each glyph. Each value indicates the largest ppem (pixels
/// per em) at which the glyph benefits from non-linear scaling.
///
/// For any ppem greater than or equal to this value, linear scaling
/// can be used without loss of quality.
class LinearThreshold extends TableEntry {
  static const String tableName = 'LTSH';

  @override
  String get name => tableName;

  /// Table version (0)
  int version = 0;

  /// Number of glyphs
  int numGlyphs = 0;

  /// Array of ppem values, one for each glyph.
  /// Each value is the largest ppem at which the glyph benefits from
  /// non-linear scaling (hinting).
  List<int> yPels = [];

  @override
  void readContentFrom(ByteOrderSwappingBinaryReader reader) {
    // LTSH Header:
    // uint16    version     Version number (0)
    // uint16    numGlyphs   Number of glyphs (from maxp)
    // uint8     yPels[numGlyphs]  The vertical pel height at which the glyph
    //                              can be assumed to scale linearly.

    version = reader.readUInt16();
    numGlyphs = reader.readUInt16();
    yPels = reader.readBytes(numGlyphs);
  }

  /// Get the linear threshold for a specific glyph.
  ///
  /// Returns the ppem at which the glyph scales linearly,
  /// or null if the glyph index is out of range.
  int? getThreshold(int glyphIndex) {
    if (glyphIndex >= 0 && glyphIndex < yPels.length) {
      return yPels[glyphIndex];
    }
    return null;
  }

  /// Check if a glyph scales linearly at the given ppem.
  ///
  /// Returns true if the glyph can be scaled linearly at the given
  /// ppem without loss of quality.
  bool isLinearAt(int glyphIndex, int ppem) {
    final threshold = getThreshold(glyphIndex);
    if (threshold == null) {
      return false;
    }
    return ppem >= threshold;
  }
}
