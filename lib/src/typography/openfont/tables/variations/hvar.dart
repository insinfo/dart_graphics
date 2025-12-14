

import '../../../io/byte_order_swapping_reader.dart';
import '../table_entry.dart';
import 'item_variation_store.dart';

/// DeltaSetIndexMap for mapping glyph indices to delta-set indices.
/// Used in HVAR/VVAR/MVAR tables.
class DeltaSetIndexMap {
  /// Format of the mapping (0 or 1)
  int format = 0;
  
  /// Entry format flags
  int entryFormat = 0;
  
  /// Map count
  int mapCount = 0;
  
  /// Map data - stores packed outer/inner indices
  List<int> mapData = [];
  
  /// Read DeltaSetIndexMap from reader
  void readContent(ByteOrderSwappingBinaryReader reader) {
    format = reader.readByte();
    entryFormat = reader.readByte();
    
    if (format == 0) {
      mapCount = reader.readUInt16();
    } else {
      mapCount = reader.readUInt32();
    }
    
    // Entry size is determined by entryFormat
    // Bits 0-3: innerIndexBitCount (minus 1)
    // Bits 4-5: mapEntrySize (minus 1)
    final mapEntrySize = ((entryFormat >> 4) & 0x03) + 1;
    
    mapData = [];
    for (int i = 0; i < mapCount; i++) {
      int entry = 0;
      for (int b = 0; b < mapEntrySize; b++) {
        entry = (entry << 8) | reader.readByte();
      }
      mapData.add(entry);
    }
  }
  
  /// Get the outer and inner indices for a glyph
  (int outer, int inner) getIndices(int glyphIndex) {
    if (glyphIndex >= mapCount || mapData.isEmpty) {
      // Implicit identity mapping
      return (0, glyphIndex);
    }
    
    final innerIndexBitCount = (entryFormat & 0x0F) + 1;
    final entry = mapData[glyphIndex];
    final innerMask = (1 << innerIndexBitCount) - 1;
    final inner = entry & innerMask;
    final outer = entry >> innerIndexBitCount;
    return (outer, inner);
  }
}

/// HVAR — Horizontal Metrics Variations Table
class HVar extends TableEntry {
  static const String _N = "HVAR";
  @override
  String get name => _N;

  ItemVariationStore? itemVariationStore;
  
  int majorVersion = 0;
  int minorVersion = 0;
  int itemVariationStoreOffset = 0;
  int advanceWidthMappingOffset = 0;
  int lsbMappingOffset = 0;
  int rsbMappingOffset = 0;
  
  /// Advance width delta-set index mapping
  DeltaSetIndexMap? advanceWidthMapping;
  
  /// Left side bearing delta-set index mapping  
  DeltaSetIndexMap? lsbMapping;
  
  /// Right side bearing delta-set index mapping
  DeltaSetIndexMap? rsbMapping;

  @override
  void readContentFrom(ByteOrderSwappingBinaryReader reader) {
    int beginAt = reader.position;

    // Horizontal metrics variations table:
    // Type      Name                        Description
    // uint16    majorVersion                Major version number of the horizontal metrics variations table — set to 1.
    // uint16    minorVersion                Minor version number of the horizontal metrics variations table — set to 0.
    // Offset32  itemVariationStoreOffset    Offset in bytes from the start of this table to the item variation store table.
    // Offset32  advanceWidthMappingOffset   Offset in bytes from the start of this table to the delta-set index mapping for advance widths (may be NULL).
    // Offset32  lsbMappingOffset            Offset in bytes from the start of this table to the delta - set index mapping for left side bearings(may be NULL).
    // Offset32  rsbMappingOffset            Offset in bytes from the start of this table to the delta - set index mapping for right side bearings(may be NULL).            

    majorVersion = reader.readUInt16();
    minorVersion = reader.readUInt16();
    itemVariationStoreOffset = reader.readUInt32();
    advanceWidthMappingOffset = reader.readUInt32();
    lsbMappingOffset = reader.readUInt32();
    rsbMappingOffset = reader.readUInt32();

    // itemVariationStore
    if (itemVariationStoreOffset > 0) {
      reader.seek(beginAt + itemVariationStoreOffset);
      itemVariationStore = ItemVariationStore();
      itemVariationStore!.readContent(reader);
    }
    
    // Read DeltaSetIndexMaps
    if (advanceWidthMappingOffset > 0) {
      reader.seek(beginAt + advanceWidthMappingOffset);
      advanceWidthMapping = DeltaSetIndexMap();
      advanceWidthMapping!.readContent(reader);
    }
    
    if (lsbMappingOffset > 0) {
      reader.seek(beginAt + lsbMappingOffset);
      lsbMapping = DeltaSetIndexMap();
      lsbMapping!.readContent(reader);
    }
    
    if (rsbMappingOffset > 0) {
      reader.seek(beginAt + rsbMappingOffset);
      rsbMapping = DeltaSetIndexMap();
      rsbMapping!.readContent(reader);
    }
  }
}
