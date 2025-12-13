// Apache2, 2016-present, WinterDev
// Dart port by insinfo

import '../../io/byte_order_swapping_reader.dart';
import 'table_entry.dart';

/// hdmx — Horizontal Device Metrics
///
/// https://docs.microsoft.com/en-us/typography/opentype/spec/hdmx
///
/// The Horizontal Device Metrics table stores integer advance widths scaled
/// to particular pixel sizes. This allows the font manager to build integer
/// width tables without calling the scaler for each glyph.
///
/// Typically this table contains only selected screen sizes.
/// This table is sorted by pixel size.
class HorizontalDeviceMetrics extends TableEntry {
  static const String tableName = 'hdmx';

  @override
  String get name => tableName;

  /// Table version number (0)
  int version = 0;

  /// Number of device records
  int numRecords = 0;

  /// Size of a device record (must be long-aligned)
  int sizeDeviceRecord = 0;

  /// Array of device records
  List<DeviceRecord> records = [];

  /// Read the table with the number of glyphs from maxp table
  void readContentWithGlyphCount(ByteOrderSwappingBinaryReader reader, int numGlyphs) {
    version = reader.readUInt16();
    numRecords = reader.readInt16();
    sizeDeviceRecord = reader.readInt32();

    records = [];
    for (int i = 0; i < numRecords; i++) {
      final record = DeviceRecord();
      record.pixelSize = reader.readUInt8();
      record.maxWidth = reader.readUInt8();
      record.widths = reader.readBytes(numGlyphs);

      // Skip padding bytes to align to long (4 bytes)
      final recordBytesRead = 2 + numGlyphs;
      final padding = sizeDeviceRecord - recordBytesRead;
      if (padding > 0) {
        reader.readBytes(padding);
      }

      records.add(record);
    }
  }

  @override
  void readContentFrom(ByteOrderSwappingBinaryReader reader) {
    // Note: To fully read this table, numGlyphs from maxp is required.
    // This method reads only the header.
    version = reader.readUInt16();
    numRecords = reader.readInt16();
    sizeDeviceRecord = reader.readInt32();
  }

  /// Get the advance width for a glyph at a specific pixel size.
  /// Returns null if no record exists for that size.
  int? getWidth(int pixelSize, int glyphIndex) {
    for (final record in records) {
      if (record.pixelSize == pixelSize) {
        if (glyphIndex >= 0 && glyphIndex < record.widths.length) {
          return record.widths[glyphIndex];
        }
      }
    }
    return null;
  }
}

/// Device record containing widths for a specific pixel size.
class DeviceRecord {
  /// Pixel size for following widths (as ppem).
  int pixelSize = 0;

  /// Maximum width across all glyphs.
  int maxWidth = 0;

  /// Array of widths (one per glyph).
  List<int> widths = [];
}
