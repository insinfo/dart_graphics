import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:dart_graphics/src/typography/io/byte_order_swapping_reader.dart';
import 'package:dart_graphics/src/typography/openfont/tables/variations/tuple_variation.dart';

void main() {
  group('TupleRecord', () {
    test('reads axis coordinates', () {
      final builder = BytesBuilder();

      // F2DOT14 values: -1.0, 0.5, 1.0 (3 axes)
      builder.add([0xC0, 0x00]); // -1.0
      builder.add([0x20, 0x00]); // 0.5
      builder.add([0x40, 0x00]); // 1.0

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final tuple = TupleRecord(3);
      tuple.readContent(reader);

      expect(tuple.coords.length, equals(3));
      expect(tuple.coords[0], closeTo(-1.0, 0.01));
      expect(tuple.coords[1], closeTo(0.5, 0.01));
      expect(tuple.coords[2], closeTo(1.0, 0.01));
    });

    test('reads single axis', () {
      final builder = BytesBuilder();

      // F2DOT14: 0.75
      builder.add([0x30, 0x00]); // 0.75

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final tuple = TupleRecord(1);
      tuple.readContent(reader);

      expect(tuple.coords.length, equals(1));
      expect(tuple.coords[0], closeTo(0.75, 0.01));
    });
  });

  group('TupleVariationHeader', () {
    test('reads basic header', () {
      final builder = BytesBuilder();

      builder.add([0x00, 0x20]); // variationDataSize: 32
      builder.add([0x00, 0x05]); // tupleIndex: 5 (no flags, index to shared tuple)

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final header = TupleVariationHeader();
      header.readContent(reader, 2);

      expect(header.variationDataSize, equals(32));
      expect(header.tupleIndex & TupleIndexFormat.TUPLE_INDEX_MASK, equals(5));
      expect(header.peakTuple, isNull);
      expect(header.intermediateStartTuple, isNull);
    });

    test('reads header with embedded peak tuple', () {
      final builder = BytesBuilder();

      builder.add([0x00, 0x40]); // variationDataSize: 64
      builder.add([0x80, 0x00]); // tupleIndex: EMBEDDED_PEAK_TUPLE flag set

      // Peak tuple (2 axes)
      builder.add([0xC0, 0x00]); // axis 0: -1.0
      builder.add([0x40, 0x00]); // axis 1: 1.0

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final header = TupleVariationHeader();
      header.readContent(reader, 2);

      expect(header.variationDataSize, equals(64));
      expect(header.peakTuple, isNotNull);
      expect(header.peakTuple!.coords[0], closeTo(-1.0, 0.01));
      expect(header.peakTuple!.coords[1], closeTo(1.0, 0.01));
    });

    test('reads header with intermediate region', () {
      final builder = BytesBuilder();

      builder.add([0x00, 0x10]); // variationDataSize: 16
      builder.add([0xC0, 0x00]); // tupleIndex: EMBEDDED_PEAK_TUPLE | INTERMEDIATE_REGION

      // Peak tuple (1 axis)
      builder.add([0x40, 0x00]); // peak: 1.0

      // Intermediate start tuple
      builder.add([0x20, 0x00]); // start: 0.5

      // Intermediate end tuple
      builder.add([0x40, 0x00]); // end: 1.0

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final header = TupleVariationHeader();
      header.readContent(reader, 1);

      expect(header.peakTuple, isNotNull);
      expect(header.peakTuple!.coords[0], closeTo(1.0, 0.01));

      expect(header.intermediateStartTuple, isNotNull);
      expect(header.intermediateStartTuple!.coords[0], closeTo(0.5, 0.01));

      expect(header.intermediateEndTuple, isNotNull);
      expect(header.intermediateEndTuple!.coords[0], closeTo(1.0, 0.01));
    });
  });

  group('PackedPointNumbers', () {
    test('reads small point count', () {
      final builder = BytesBuilder();

      builder.add([0x03]); // count: 3 (no high bit, so count is b0)
      // Run of 3 8-bit values (cumulative)
      builder.add([0x02]); // control: runCount=3, 8-bit values
      builder.add([0x05]); // point 0: 5 (cumulative)
      builder.add([0x03]); // point 1: 5 + 3 = 8
      builder.add([0x02]); // point 2: 8 + 2 = 10

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final points = PackedPointNumbers.readPointNumbers(reader);

      expect(points, isNotNull);
      expect(points!.length, equals(3));
      expect(points, equals([5, 8, 10]));
    });

    test('returns null for all points (b0 = 0)', () {
      final builder = BytesBuilder();
      builder.add([0x00]); // All points

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final points = PackedPointNumbers.readPointNumbers(reader);
      expect(points, isNull);
    });

    test('reads 16-bit point deltas', () {
      final builder = BytesBuilder();

      builder.add([0x02]); // count: 2
      // Run of 2 16-bit values
      builder.add([0x81]); // control: 0x80 | 1, runCount=2, 16-bit values
      builder.add([0x00, 0x64]); // point 0: 100
      builder.add([0x01, 0x00]); // point 1: 100 + 256 = 356

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final points = PackedPointNumbers.readPointNumbers(reader);

      expect(points, isNotNull);
      expect(points!.length, equals(2));
      expect(points, equals([100, 356]));
    });
  });

  group('PackedDeltas', () {
    test('reads zero deltas run', () {
      final builder = BytesBuilder();

      // Zero run: 5 zeros (control = 0x80 | (5-1) = 0x84)
      builder.add([0x84]); // 5 zeros

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final deltas = PackedDeltas.readDeltas(reader, 5);

      expect(deltas.length, equals(5));
      expect(deltas, equals([0, 0, 0, 0, 0]));
    });

    test('reads 8-bit deltas', () {
      final builder = BytesBuilder();

      // 8-bit run: 4 values (control = 0x03)
      builder.add([0x03]); // 4 8-bit values (runCount = 3+1 = 4)
      builder.add([0x0A]); // 10
      builder.add([0xF6]); // -10 (signed byte)
      builder.add([0x05]); // 5
      builder.add([0xFB]); // -5

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final deltas = PackedDeltas.readDeltas(reader, 4);

      expect(deltas.length, equals(4));
      expect(deltas, equals([10, -10, 5, -5]));
    });

    test('reads 16-bit deltas', () {
      final builder = BytesBuilder();

      // 16-bit run: 3 values (control = 0x40 | 0x02 = 0x42)
      builder.add([0x42]); // 3 16-bit values
      builder.add([0x00, 0xC8]); // 200
      builder.add([0xFF, 0x38]); // -200
      builder.add([0x01, 0x00]); // 256

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final deltas = PackedDeltas.readDeltas(reader, 3);

      expect(deltas.length, equals(3));
      expect(deltas, equals([200, -200, 256]));
    });

    test('reads mixed runs', () {
      final builder = BytesBuilder();

      // Run 1: 2 zeros
      builder.add([0x81]); // 2 zeros (0x80 | 1)

      // Run 2: 2 8-bit values
      builder.add([0x01]); // 2 8-bit values
      builder.add([0x64]); // 100
      builder.add([0x9C]); // -100

      // Run 3: 1 16-bit value
      builder.add([0x40]); // 1 16-bit value
      builder.add([0x03, 0xE8]); // 1000

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final deltas = PackedDeltas.readDeltas(reader, 5);

      expect(deltas.length, equals(5));
      expect(deltas, equals([0, 0, 100, -100, 1000]));
    });
  });

  group('TupleIndexFormat', () {
    test('has correct flag values', () {
      expect(TupleIndexFormat.EMBEDDED_PEAK_TUPLE, equals(0x8000));
      expect(TupleIndexFormat.INTERMEDIATE_REGION, equals(0x4000));
      expect(TupleIndexFormat.PRIVATE_POINT_NUMBERS, equals(0x2000));
      expect(TupleIndexFormat.Reserved, equals(0x1000));
      expect(TupleIndexFormat.TUPLE_INDEX_MASK, equals(0x0FFF));
    });
  });
}
