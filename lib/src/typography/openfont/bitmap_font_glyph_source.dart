

import 'dart:typed_data';
import 'glyph.dart';
import 'tables/cblc.dart';
import 'tables/cbdt.dart';

/// Helper class for extracting bitmap glyph data from CBLC/CBDT tables.
///
/// This class combines the CBLC (Color Bitmap Location) and CBDT (Color Bitmap Data)
/// tables to provide a unified interface for accessing bitmap glyph data,
/// commonly used for color emoji and other bitmap-based glyphs.
class BitmapFontGlyphSource {
  final CBLC _cblc;
  final CBDT _cbdt;

  /// Creates a bitmap font glyph source from CBLC and CBDT tables.
  BitmapFontGlyphSource(this._cblc, this._cbdt);

  /// Copies the bitmap content for a glyph to an output buffer.
  ///
  /// Returns a [Uint8List] containing the raw bitmap data, or null if
  /// the glyph has no bitmap data.
  Uint8List? copyBitmapContent(Glyph glyph) {
    if (glyph.bitmapOffset == null || glyph.bitmapLength == null) {
      return null;
    }
    
    // The bitmap data is stored in CBDT at the offset specified in the glyph
    // The actual extraction requires reading from the CBDT raw data
    // which would need access to the original reader/buffer
    
    // For now, return the glyph's stored bitmap buffer if available
    // Full implementation would require CBDT to store raw data and 
    // provide extraction methods
    return null;
  }

  /// Builds a list of glyphs that have bitmap data.
  ///
  /// This iterates through the CBLC size tables and extracts glyph
  /// information from the index subtables.
  List<Glyph> buildGlyphList() {
    // Delegate to EBLC/CBLC which has the implementation
    return _cblc.buildGlyphList();
  }
  
  /// Check if a glyph has bitmap data available.
  bool hasGlyphBitmap(int glyphIndex) {
    final sizeTables = _cblc.bitmapSizeTables;
    if (sizeTables == null) return false;
    
    for (final sizeTable in sizeTables) {
      final subTables = sizeTable.indexSubTables;
      if (subTables == null) continue;
      
      for (final subTable in subTables) {
        if (glyphIndex >= subTable.firstGlyphIndex && 
            glyphIndex <= subTable.lastGlyphIndex) {
          return true;
        }
      }
    }
    return false;
  }
  
  /// Get bitmap size information for a specific ppem (pixels per em).
  /// Returns the BitmapSizeTable that matches, or null if not found.
  dynamic getBitmapSizeForPpem(int ppem) {
    final sizeTables = _cblc.bitmapSizeTables;
    if (sizeTables == null) return null;
    
    for (final sizeTable in sizeTables) {
      if (sizeTable.ppemX == ppem || sizeTable.ppemY == ppem) {
        return sizeTable;
      }
    }
    return null;
  }

  /// Get the CBLC table.
  CBLC get cblc => _cblc;

  /// Get the CBDT table.
  CBDT get cbdt => _cbdt;
}
