import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:agg/src/typography/io/byte_order_swapping_reader.dart';
import 'package:agg/src/typography/openfont/tables/variations/avar.dart';
import 'package:agg/src/typography/openfont/tables/variations/cvar.dart';

void main() {
  group('AVar table', () {
    test('reads basic avar table with one axis', () {
      // Build a simple avar table with 1 axis
      // Header: majorVersion(2) + minorVersion(2) + reserved(2) + axisCount(2) = 8 bytes
      // SegmentMap: positionMapCount(2) + maps (each 4 bytes: 2xF2DOT14)
      // 3 required maps: -1 -> -1, 0 -> 0, 1 -> 1
      final bytes = ByteData(8 + 2 + 3 * 4);
      int offset = 0;

      // Header
      bytes.setUint16(offset, 1, Endian.big); // majorVersion
      offset += 2;
      bytes.setUint16(offset, 0, Endian.big); // minorVersion
      offset += 2;
      bytes.setUint16(offset, 0, Endian.big); // reserved
      offset += 2;
      bytes.setUint16(offset, 1, Endian.big); // axisCount
      offset += 2;

      // SegmentMap for axis 0
      bytes.setUint16(offset, 3, Endian.big); // positionMapCount
      offset += 2;

      // Map 0: -1 -> -1 (F2DOT14: -1.0 = 0xC000)
      bytes.setInt16(offset, -0x4000, Endian.big); // -1.0 in F2DOT14
      offset += 2;
      bytes.setInt16(offset, -0x4000, Endian.big); // -1.0 in F2DOT14
      offset += 2;

      // Map 1: 0 -> 0
      bytes.setInt16(offset, 0, Endian.big);
      offset += 2;
      bytes.setInt16(offset, 0, Endian.big);
      offset += 2;

      // Map 2: 1 -> 1 (F2DOT14: 1.0 = 0x4000)
      bytes.setInt16(offset, 0x4000, Endian.big); // 1.0 in F2DOT14
      offset += 2;
      bytes.setInt16(offset, 0x4000, Endian.big); // 1.0 in F2DOT14

      final reader = ByteOrderSwappingBinaryReader(
        bytes.buffer.asUint8List(),
      );

      final avar = AVar();
      avar.readContentFrom(reader);

      expect(avar.majorVersion, 1);
      expect(avar.minorVersion, 0);
      expect(avar.axisCount, 1);
      expect(avar.axisSegmentMaps.length, 1);
      expect(avar.axisSegmentMaps[0].axisValueMaps.length, 3);

      // Check map values
      expect(avar.axisSegmentMaps[0].axisValueMaps[0].fromCoordinate, closeTo(-1.0, 0.001));
      expect(avar.axisSegmentMaps[0].axisValueMaps[0].toCoordinate, closeTo(-1.0, 0.001));
      expect(avar.axisSegmentMaps[0].axisValueMaps[1].fromCoordinate, closeTo(0.0, 0.001));
      expect(avar.axisSegmentMaps[0].axisValueMaps[1].toCoordinate, closeTo(0.0, 0.001));
      expect(avar.axisSegmentMaps[0].axisValueMaps[2].fromCoordinate, closeTo(1.0, 0.001));
      expect(avar.axisSegmentMaps[0].axisValueMaps[2].toCoordinate, closeTo(1.0, 0.001));
    });

    test('reads avar table with modified segment map', () {
      // Create an avar table that modifies normalization
      // Maps: -1 -> -1, 0 -> 0, 0.5 -> 0.7, 1 -> 1
      final bytes = ByteData(8 + 2 + 4 * 4);
      int offset = 0;

      // Header
      bytes.setUint16(offset, 1, Endian.big);
      offset += 2;
      bytes.setUint16(offset, 0, Endian.big);
      offset += 2;
      bytes.setUint16(offset, 0, Endian.big);
      offset += 2;
      bytes.setUint16(offset, 1, Endian.big);
      offset += 2;

      // SegmentMap
      bytes.setUint16(offset, 4, Endian.big);
      offset += 2;

      // -1 -> -1
      bytes.setInt16(offset, -0x4000, Endian.big);
      offset += 2;
      bytes.setInt16(offset, -0x4000, Endian.big);
      offset += 2;

      // 0 -> 0
      bytes.setInt16(offset, 0, Endian.big);
      offset += 2;
      bytes.setInt16(offset, 0, Endian.big);
      offset += 2;

      // 0.5 -> 0.7 (0.5 = 0x2000, 0.7 ≈ 0x2CCC in F2DOT14)
      bytes.setInt16(offset, 0x2000, Endian.big);
      offset += 2;
      bytes.setInt16(offset, 0x2CCC, Endian.big);
      offset += 2;

      // 1 -> 1
      bytes.setInt16(offset, 0x4000, Endian.big);
      offset += 2;
      bytes.setInt16(offset, 0x4000, Endian.big);

      final reader = ByteOrderSwappingBinaryReader(
        bytes.buffer.asUint8List(),
      );

      final avar = AVar();
      avar.readContentFrom(reader);

      expect(avar.axisSegmentMaps.length, 1);
      expect(avar.axisSegmentMaps[0].axisValueMaps.length, 4);
    });

    test('applySegmentMap with identity mapping', () {
      final bytes = ByteData(8 + 2 + 3 * 4);
      int offset = 0;

      bytes.setUint16(offset, 1, Endian.big);
      offset += 2;
      bytes.setUint16(offset, 0, Endian.big);
      offset += 2;
      bytes.setUint16(offset, 0, Endian.big);
      offset += 2;
      bytes.setUint16(offset, 1, Endian.big);
      offset += 2;

      bytes.setUint16(offset, 3, Endian.big);
      offset += 2;

      // Identity map: -1 -> -1, 0 -> 0, 1 -> 1
      bytes.setInt16(offset, -0x4000, Endian.big);
      offset += 2;
      bytes.setInt16(offset, -0x4000, Endian.big);
      offset += 2;
      bytes.setInt16(offset, 0, Endian.big);
      offset += 2;
      bytes.setInt16(offset, 0, Endian.big);
      offset += 2;
      bytes.setInt16(offset, 0x4000, Endian.big);
      offset += 2;
      bytes.setInt16(offset, 0x4000, Endian.big);

      final reader = ByteOrderSwappingBinaryReader(
        bytes.buffer.asUint8List(),
      );

      final avar = AVar();
      avar.readContentFrom(reader);

      // Test that identity mapping returns same values
      expect(avar.applySegmentMap(0, -1.0), closeTo(-1.0, 0.001));
      expect(avar.applySegmentMap(0, 0.0), closeTo(0.0, 0.001));
      expect(avar.applySegmentMap(0, 0.5), closeTo(0.5, 0.001));
      expect(avar.applySegmentMap(0, 1.0), closeTo(1.0, 0.001));
      expect(avar.applySegmentMap(0, -0.5), closeTo(-0.5, 0.001));
    });

    test('applySegmentMap with modified mapping', () {
      final bytes = ByteData(8 + 2 + 4 * 4);
      int offset = 0;

      bytes.setUint16(offset, 1, Endian.big);
      offset += 2;
      bytes.setUint16(offset, 0, Endian.big);
      offset += 2;
      bytes.setUint16(offset, 0, Endian.big);
      offset += 2;
      bytes.setUint16(offset, 1, Endian.big);
      offset += 2;

      bytes.setUint16(offset, 4, Endian.big);
      offset += 2;

      // Map: -1 -> -1, 0 -> 0, 0.5 -> 0.75, 1 -> 1
      // 0.75 in F2DOT14 = 0x3000
      bytes.setInt16(offset, -0x4000, Endian.big);
      offset += 2;
      bytes.setInt16(offset, -0x4000, Endian.big);
      offset += 2;
      bytes.setInt16(offset, 0, Endian.big);
      offset += 2;
      bytes.setInt16(offset, 0, Endian.big);
      offset += 2;
      bytes.setInt16(offset, 0x2000, Endian.big); // 0.5
      offset += 2;
      bytes.setInt16(offset, 0x3000, Endian.big); // 0.75
      offset += 2;
      bytes.setInt16(offset, 0x4000, Endian.big);
      offset += 2;
      bytes.setInt16(offset, 0x4000, Endian.big);

      final reader = ByteOrderSwappingBinaryReader(
        bytes.buffer.asUint8List(),
      );

      final avar = AVar();
      avar.readContentFrom(reader);

      // At 0.5, should map to 0.75
      expect(avar.applySegmentMap(0, 0.5), closeTo(0.75, 0.01));

      // At 0.25, should interpolate between 0 and 0.5 -> 0 and 0.75
      // t = 0.25/0.5 = 0.5, result = 0 + 0.5 * (0.75 - 0) = 0.375
      expect(avar.applySegmentMap(0, 0.25), closeTo(0.375, 0.01));

      // At 0.75, should interpolate between 0.5 and 1 -> 0.75 and 1
      // t = (0.75-0.5)/(1-0.5) = 0.5, result = 0.75 + 0.5 * (1 - 0.75) = 0.875
      expect(avar.applySegmentMap(0, 0.75), closeTo(0.875, 0.01));
    });

    test('applySegmentMap with invalid axis returns unchanged value', () {
      final bytes = ByteData(8 + 2 + 3 * 4);
      int offset = 0;

      bytes.setUint16(offset, 1, Endian.big);
      offset += 2;
      bytes.setUint16(offset, 0, Endian.big);
      offset += 2;
      bytes.setUint16(offset, 0, Endian.big);
      offset += 2;
      bytes.setUint16(offset, 1, Endian.big);
      offset += 2;
      bytes.setUint16(offset, 3, Endian.big);
      offset += 2;
      bytes.setInt16(offset, -0x4000, Endian.big);
      offset += 2;
      bytes.setInt16(offset, -0x4000, Endian.big);
      offset += 2;
      bytes.setInt16(offset, 0, Endian.big);
      offset += 2;
      bytes.setInt16(offset, 0, Endian.big);
      offset += 2;
      bytes.setInt16(offset, 0x4000, Endian.big);
      offset += 2;
      bytes.setInt16(offset, 0x4000, Endian.big);

      final reader = ByteOrderSwappingBinaryReader(
        bytes.buffer.asUint8List(),
      );

      final avar = AVar();
      avar.readContentFrom(reader);

      // Invalid axis index returns unchanged
      expect(avar.applySegmentMap(-1, 0.5), 0.5);
      expect(avar.applySegmentMap(1, 0.5), 0.5);
      expect(avar.applySegmentMap(999, 0.5), 0.5);
    });

    test('reads avar with multiple axes', () {
      // 2 axes, each with 3 maps
      final bytes = ByteData(8 + 2 * (2 + 3 * 4));
      int offset = 0;

      bytes.setUint16(offset, 1, Endian.big);
      offset += 2;
      bytes.setUint16(offset, 0, Endian.big);
      offset += 2;
      bytes.setUint16(offset, 0, Endian.big);
      offset += 2;
      bytes.setUint16(offset, 2, Endian.big); // 2 axes
      offset += 2;

      // Axis 0 segment map
      bytes.setUint16(offset, 3, Endian.big);
      offset += 2;
      bytes.setInt16(offset, -0x4000, Endian.big);
      offset += 2;
      bytes.setInt16(offset, -0x4000, Endian.big);
      offset += 2;
      bytes.setInt16(offset, 0, Endian.big);
      offset += 2;
      bytes.setInt16(offset, 0, Endian.big);
      offset += 2;
      bytes.setInt16(offset, 0x4000, Endian.big);
      offset += 2;
      bytes.setInt16(offset, 0x4000, Endian.big);
      offset += 2;

      // Axis 1 segment map
      bytes.setUint16(offset, 3, Endian.big);
      offset += 2;
      bytes.setInt16(offset, -0x4000, Endian.big);
      offset += 2;
      bytes.setInt16(offset, -0x4000, Endian.big);
      offset += 2;
      bytes.setInt16(offset, 0, Endian.big);
      offset += 2;
      bytes.setInt16(offset, 0, Endian.big);
      offset += 2;
      bytes.setInt16(offset, 0x4000, Endian.big);
      offset += 2;
      bytes.setInt16(offset, 0x4000, Endian.big);

      final reader = ByteOrderSwappingBinaryReader(
        bytes.buffer.asUint8List(),
      );

      final avar = AVar();
      avar.readContentFrom(reader);

      expect(avar.axisCount, 2);
      expect(avar.axisSegmentMaps.length, 2);
      expect(avar.axisSegmentMaps[0].axisValueMaps.length, 3);
      expect(avar.axisSegmentMaps[1].axisValueMaps.length, 3);
    });
  });

  group('CVar table', () {
    test('reads basic cvar header', () {
      // Minimal cvar header
      final bytes = ByteData(8);
      int offset = 0;

      bytes.setUint16(offset, 1, Endian.big); // majorVersion
      offset += 2;
      bytes.setUint16(offset, 0, Endian.big); // minorVersion
      offset += 2;
      bytes.setUint16(offset, 0, Endian.big); // tupleVariationCount (0)
      offset += 2;
      bytes.setUint16(offset, 0, Endian.big); // dataOffset (0 = no data)
      offset += 2;

      final reader = ByteOrderSwappingBinaryReader(
        bytes.buffer.asUint8List(),
      );

      final cvar = CVar();
      cvar.readContentFrom(reader);

      expect(cvar.majorVersion, 1);
      expect(cvar.minorVersion, 0);
      expect(cvar.tupleVariationCount, 0);
      expect(cvar.tupleVariationHeaders.length, 0);
    });

    test('reads cvar with tuple variation headers', () {
      // cvar with 1 tuple variation header
      final bytes = ByteData(8 + 4); // header + 1 tuple header
      int offset = 0;

      bytes.setUint16(offset, 1, Endian.big); // majorVersion
      offset += 2;
      bytes.setUint16(offset, 0, Endian.big); // minorVersion
      offset += 2;
      bytes.setUint16(offset, 1, Endian.big); // tupleVariationCount (1)
      offset += 2;
      bytes.setUint16(offset, 0, Endian.big); // dataOffset (0)
      offset += 2;

      // TupleVariationHeader
      bytes.setUint16(offset, 10, Endian.big); // variationDataSize
      offset += 2;
      bytes.setUint16(offset, 0x0001, Endian.big); // tupleIndex (index 1, no flags)
      offset += 2;

      final reader = ByteOrderSwappingBinaryReader(
        bytes.buffer.asUint8List(),
      );

      final cvar = CVar();
      cvar.readContentFrom(reader);

      expect(cvar.majorVersion, 1);
      expect(cvar.tupleVariationCount, 1);
      expect(cvar.tupleVariationHeaders.length, 1);
      expect(cvar.tupleVariationHeaders[0].variationDataSize, 10);
      expect(cvar.tupleVariationHeaders[0].tupleIndexValue, 1);
    });

    test('reads cvar with shared point numbers flag', () {
      // 8 bytes header + 4 bytes for 1 tuple header = 12 bytes
      final bytes = ByteData(12);
      int offset = 0;

      bytes.setUint16(offset, 1, Endian.big);
      offset += 2;
      bytes.setUint16(offset, 0, Endian.big);
      offset += 2;
      bytes.setUint16(offset, 0x8001, Endian.big); // SHARED_POINT_NUMBERS flag + count 1
      offset += 2;
      bytes.setUint16(offset, 0, Endian.big);
      offset += 2;

      // TupleVariationHeader for the 1 tuple
      bytes.setUint16(offset, 0, Endian.big); // variationDataSize
      offset += 2;
      bytes.setUint16(offset, 0, Endian.big); // tupleIndex
      offset += 2;

      final reader = ByteOrderSwappingBinaryReader(
        bytes.buffer.asUint8List(),
      );

      final cvar = CVar();
      cvar.readContentFrom(reader);

      // Check that the shared point numbers flag is set
      expect(cvar.hasSharedPointNumbers, isTrue);
      expect(cvar.tupleVariationCount, 1);
    });
  });

  group('TupleVariationHeader', () {
    test('parses flags correctly', () {
      final bytes = ByteData(4);
      bytes.setUint16(0, 20, Endian.big); // variationDataSize
      // Flags: EMBEDDED_PEAK_TUPLE (0x8000) | INTERMEDIATE_REGION (0x4000) | index 5
      bytes.setUint16(2, 0x8000 | 0x4000 | 5, Endian.big);

      final reader = ByteOrderSwappingBinaryReader(
        bytes.buffer.asUint8List(),
      );

      final header = TupleVariationHeader.readFrom(reader);

      expect(header.variationDataSize, 20);
      expect(header.hasEmbeddedPeakTuple, isTrue);
      expect(header.hasIntermediateRegion, isTrue);
      expect(header.hasPrivatePointNumbers, isFalse);
      expect(header.tupleIndexValue, 5);
    });

    test('parses private point numbers flag', () {
      final bytes = ByteData(4);
      bytes.setUint16(0, 15, Endian.big);
      bytes.setUint16(2, 0x2000 | 3, Endian.big); // PRIVATE_POINT_NUMBERS | index 3

      final reader = ByteOrderSwappingBinaryReader(
        bytes.buffer.asUint8List(),
      );

      final header = TupleVariationHeader.readFrom(reader);

      expect(header.hasPrivatePointNumbers, isTrue);
      expect(header.hasEmbeddedPeakTuple, isFalse);
      expect(header.hasIntermediateRegion, isFalse);
      expect(header.tupleIndexValue, 3);
    });
  });

  group('SegmentMapRecord', () {
    test('applyMapping handles empty map', () {
      final record = SegmentMapRecord();
      record.axisValueMaps = [];

      // Should return unchanged value
      expect(record.applyMapping(0.5), 0.5);
    });

    test('applyMapping clamps values outside range', () {
      final record = SegmentMapRecord();
      record.axisValueMaps = [
        AxisValueMap(-1.0, -1.0),
        AxisValueMap(0.0, 0.0),
        AxisValueMap(1.0, 1.0),
      ];

      // Values outside range should clamp to endpoints
      expect(record.applyMapping(-2.0), closeTo(-1.0, 0.001));
      expect(record.applyMapping(2.0), closeTo(1.0, 0.001));
    });
  });

  group('AxisValueMap', () {
    test('toString formats correctly', () {
      final map = AxisValueMap(0.5, 0.75);
      expect(map.toString(), contains('0.5'));
      expect(map.toString(), contains('0.75'));
    });
  });
}
