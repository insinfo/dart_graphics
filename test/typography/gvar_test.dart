import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:dart_graphics/src/typography/io/byte_order_swapping_reader.dart';
import 'package:dart_graphics/src/typography/openfont/tables/variations/gvar.dart';
import 'package:dart_graphics/src/typography/openfont/tables/table_entry.dart';

void main() {
  group('GVar Table', () {
    test('reads header and shared tuples', () {
      final builder = BytesBuilder();

      // Header (20 bytes)
      builder.add([0x00, 0x01, 0x00, 0x00]); // version 1.0
      builder.add([0x00, 0x02]); // axisCount: 2
      builder.add([0x00, 0x01]); // sharedTupleCount: 1
      builder.add([0x00, 0x00, 0x00, 0x1C]); // sharedTuplesOffset: 28
      builder.add([0x00, 0x02]); // glyphCount: 2
      builder.add([0x00, 0x00]); // flags: 0 (short offsets)
      builder
          .add([0x00, 0x00, 0x00, 0x20]); // glyphVariationDataArrayOffset: 32

      // Offsets (glyphCount + 1 = 3 offsets, 2 bytes each = 6 bytes)
      // 20 + 6 = 26 bytes
      builder.add([0x00, 0x00]); // Offset 0: 0
      builder.add([0x00, 0x0A]); // Offset 1: 20 bytes (10 * 2)
      builder.add([0x00, 0x14]); // Offset 2: 40 bytes (20 * 2)

      // Padding to 28 bytes (2 bytes)
      builder.add([0x00, 0x00]);

      // Shared Tuples (at offset 28) (4 bytes)
      // Tuple 0: (1.0, 0.5)
      builder.add([0x40, 0x00]); // 1.0
      builder.add([0x20, 0x00]); // 0.5

      // Total so far: 32 bytes. Matches glyphVariationDataArrayOffset.

      // Glyph 0 Data (20 bytes)
      // Header
      builder.add([0x00, 0x01]); // tupleVariationCount: 1
      builder.add([0x00, 0x08]); // dataOffset: 8
      // TupleVariationHeader (4 bytes)
      builder.add([0x00, 0x0C]); // variationDataSize: 12
      builder.add([0x20, 0x00]); // tupleIndex: 0x2000 (PRIVATE_POINT_NUMBERS)

      // Serialized Data (12 bytes)
      // Point numbers: 0 (all points) - 1 byte? No, if count is 0, it means all points?
      // PackedPointNumbers:
      // "If the first byte is 0, then the set of points is all points in the glyph."
      builder.add([0x00]);

      // Deltas X (assume 4 points)
      // Control byte: 3 (run count 4), 0x00 (8-bit deltas) -> 0x03
      builder.add([0x03]);
      builder.add([0x01, 0x02, 0x03, 0x04]); // 1, 2, 3, 4

      // Deltas Y
      // Control byte: 3 (run count 4), 0x00 (8-bit deltas) -> 0x03
      builder.add([0x03]);
      builder.add([0x05, 0x06, 0x07, 0x08]); // 5, 6, 7, 8

      // Total data: 1 + 1 + 4 + 1 + 4 = 11 bytes.
      // variationDataSize was 12. Padding 1 byte.
      builder.add([0x00]);

      // Glyph 1 Data (20 bytes) - similar...
      // Just fill with zeros for now as we test Glyph 0
      for (var i = 0; i < 20; i++) builder.addByte(0);

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final gvar = GVar();
      gvar.header = TableHeader(
          tag: 0x67766172, checkSum: 0, offset: 0, length: data.length);
      gvar.readContentFrom(reader);

      expect(gvar.axisCount, equals(2));
      expect(gvar.sharedTupleCount, equals(1));
      expect(gvar.glyphCount, equals(2));

      // Check shared tuple
      expect(gvar.sharedTuples![0].coords[0], closeTo(1.0, 0.001));
      expect(gvar.sharedTuples![0].coords[1], closeTo(0.5, 0.001));

      // Get Glyph 0 Data
      // We need to pass glyphPointCount = 4
      final glyphData = gvar.getGlyphVariationData(0, 4);
      expect(glyphData, isNotNull);
      expect(glyphData!.tupleVariationHeaders!.length, equals(1));

      final header = glyphData.tupleVariationHeaders![0];
      expect(header.tupleIndex, equals(0x2000));
      expect(header.points, isNull); // All points

      expect(header.deltasX, equals([1, 2, 3, 4]));
      expect(header.deltasY, equals([5, 6, 7, 8]));
    });
  });
}
