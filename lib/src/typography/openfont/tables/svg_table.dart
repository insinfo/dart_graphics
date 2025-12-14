

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import '../../io/byte_order_swapping_reader.dart';
import 'table_entry.dart';

class SvgDocumentEntry {
  int startGlyphID = 0;
  int endGlyphID = 0;
  int svgDocOffset = 0;
  int svgDocLength = 0;

  Uint8List? svgBuffer;
  bool compressed = false;

  @override
  String toString() {
    return "startGlyphID:$startGlyphID,"
        "endGlyphID:$endGlyphID,"
        "svgDocOffset:$svgDocOffset,"
        "svgDocLength:$svgDocLength";
  }
}

class SvgTable extends TableEntry {
  static const String _N = "SVG "; // with 1 whitespace ***
  @override
  String get name => _N;

  // https://www.microsoft.com/typography/otspec/svg.htm
  // OpenType fonts with either TrueType or CFF outlines may also contain an optional 'SVG ' table,
  // which allows some or all glyphs in the font to be defined with color, gradients, or animation.

  Map<int, Uint8List>? _dicSvgEntries;
  List<SvgDocumentEntry>? _entries;

  @override
  void readContentFrom(ByteOrderSwappingBinaryReader reader) {
    int svgTableStartAt = reader.position;
    // SVG Main Header
    reader.readUInt16(); // version
    int offset32 = reader.readUInt32();
    reader.readUInt32(); // reserved

    // SVG Document Index
    int svgDocIndexStartAt = svgTableStartAt + offset32;
    reader.seek(svgDocIndexStartAt);

    int numEntries = reader.readUInt16();

    _entries = List<SvgDocumentEntry>.generate(numEntries, (index) {
      return SvgDocumentEntry()
        ..startGlyphID = reader.readUInt16()
        ..endGlyphID = reader.readUInt16()
        ..svgDocOffset = reader.readUInt32()
        ..svgDocLength = reader.readUInt32();
    });

    // Load all SVG documents
    for (int i = 0; i < numEntries; ++i) {
      // read data
      SvgDocumentEntry entry = _entries![i];

      // SVG entries can cover a range of glyphs that share the same SVG document
      // This is common for ligatures or variant glyphs

      reader.seek(svgDocIndexStartAt + entry.svgDocOffset);

      if (entry.svgDocLength == 0) {
        throw UnsupportedError("Zero length SVG document");
      }

      //
      Uint8List svgData = reader.readBytes(entry.svgDocLength);
      if (svgData.isNotEmpty && svgData[0] == '<'.codeUnitAt(0)) {
        // Plain-text SVG
        entry.svgBuffer = svgData;
        entry.compressed = false;
      } else if (svgData.length >= 2 && svgData[0] == 0x1f && svgData[1] == 0x8b) {
        // gzip-encoded SVG (magic bytes 0x1f 0x8b)
        entry.compressed = true;
        try {
          entry.svgBuffer = Uint8List.fromList(gzip.decode(svgData));
        } catch (e) {
          // If decompression fails, store raw data
          entry.svgBuffer = svgData;
        }
      } else {
        // Unknown format, store as-is
        entry.svgBuffer = svgData;
        entry.compressed = false;
      }
    }
  }

  bool readSvgContent(int glyphIndex, StringBuffer outputStBuilder) {
    if (_dicSvgEntries == null) {
      _dicSvgEntries = {};
      if (_entries != null) {
        for (int i = 0; i < _entries!.length; ++i) {
          SvgDocumentEntry en = _entries![i];
          if (en.svgBuffer != null) {
            _dicSvgEntries![en.startGlyphID] = en.svgBuffer!;
          }
        }
      }
    }
    if (_dicSvgEntries!.containsKey(glyphIndex)) {
      Uint8List svgData = _dicSvgEntries![glyphIndex]!;
      outputStBuilder.write(utf8.decode(svgData));
      return true;
    }
    return false;
  }
}
