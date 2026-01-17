import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:dart_graphics/src/typography/io/byte_order_swapping_reader.dart';
import 'package:dart_graphics/src/typography/openfont/tables/variations/fvar.dart';
import 'package:dart_graphics/src/typography/openfont/tables/table_entry.dart';

void main() {
  group('FVar Table', () {
    test('reads font variation axes and instances', () {
      final builder = BytesBuilder();

      // fvar header (16 bytes)
      builder.add([0x00, 0x01]); // majorVersion: 1
      builder.add([0x00, 0x00]); // minorVersion: 0
      builder.add([0x00, 0x10]); // axesArrayOffset: 16 (immediately after header)
      builder.add([0x00, 0x02]); // reserved: 2
      builder.add([0x00, 0x02]); // axisCount: 2
      builder.add([0x00, 0x14]); // axisSize: 20 bytes per axis
      builder.add([0x00, 0x02]); // instanceCount: 2
      builder.add([0x00, 0x0C]); // instanceSize: 12 (4 + 2*4) no postScriptNameID

      // Axis 0: wght (weight) at offset 16
      // axisTag (4 bytes): 'wght'
      builder.add([0x77, 0x67, 0x68, 0x74]); // 'wght'
      // minValue (Fixed 16.16): 100.0
      builder.add([0x00, 0x64, 0x00, 0x00]); // 100.0
      // defaultValue (Fixed 16.16): 400.0
      builder.add([0x01, 0x90, 0x00, 0x00]); // 400.0
      // maxValue (Fixed 16.16): 900.0
      builder.add([0x03, 0x84, 0x00, 0x00]); // 900.0
      // flags: 0
      builder.add([0x00, 0x00]);
      // axisNameID: 256
      builder.add([0x01, 0x00]);

      // Axis 1: wdth (width) at offset 36
      builder.add([0x77, 0x64, 0x74, 0x68]); // 'wdth'
      builder.add([0x00, 0x4B, 0x00, 0x00]); // 75.0
      builder.add([0x00, 0x64, 0x00, 0x00]); // 100.0
      builder.add([0x00, 0x7D, 0x00, 0x00]); // 125.0
      builder.add([0x00, 0x00]); // flags
      builder.add([0x01, 0x01]); // axisNameID: 257

      // Instance 0: "Light" at offset 56
      builder.add([0x01, 0x02]); // subfamilyNameID: 258
      builder.add([0x00, 0x00]); // flags: 0
      // coordinates[2]: wght=300.0, wdth=100.0
      builder.add([0x01, 0x2C, 0x00, 0x00]); // 300.0
      builder.add([0x00, 0x64, 0x00, 0x00]); // 100.0

      // Instance 1: "Bold" at offset 68
      builder.add([0x01, 0x03]); // subfamilyNameID: 259
      builder.add([0x00, 0x00]); // flags: 0
      // coordinates[2]: wght=700.0, wdth=100.0
      builder.add([0x02, 0xBC, 0x00, 0x00]); // 700.0
      builder.add([0x00, 0x64, 0x00, 0x00]); // 100.0

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final fvar = FVar();
      fvar.header = TableHeader(
          tag: 0x66766172, checkSum: 0, offset: 0, length: data.length);
      fvar.readContentFrom(reader);

      // Verify axes
      expect(fvar.variableAxisRecords, isNotNull);
      expect(fvar.variableAxisRecords!.length, equals(2));

      // Axis 0: wght
      expect(fvar.variableAxisRecords![0].axisTag, equals('wght'));
      expect(fvar.variableAxisRecords![0].minValue, closeTo(100.0, 0.01));
      expect(fvar.variableAxisRecords![0].defaultValue, closeTo(400.0, 0.01));
      expect(fvar.variableAxisRecords![0].maxValue, closeTo(900.0, 0.01));
      expect(fvar.variableAxisRecords![0].axisNameID, equals(256));

      // Axis 1: wdth
      expect(fvar.variableAxisRecords![1].axisTag, equals('wdth'));
      expect(fvar.variableAxisRecords![1].minValue, closeTo(75.0, 0.01));
      expect(fvar.variableAxisRecords![1].defaultValue, closeTo(100.0, 0.01));
      expect(fvar.variableAxisRecords![1].maxValue, closeTo(125.0, 0.01));
      expect(fvar.variableAxisRecords![1].axisNameID, equals(257));

      // Verify instances
      expect(fvar.instanceRecords, isNotNull);
      expect(fvar.instanceRecords!.length, equals(2));

      // Instance 0: Light
      expect(fvar.instanceRecords![0].subfamilyNameID, equals(258));
      expect(fvar.instanceRecords![0].coordinates!.length, equals(2));
      expect(fvar.instanceRecords![0].coordinates![0], closeTo(300.0, 0.01));
      expect(fvar.instanceRecords![0].coordinates![1], closeTo(100.0, 0.01));

      // Instance 1: Bold
      expect(fvar.instanceRecords![1].subfamilyNameID, equals(259));
      expect(fvar.instanceRecords![1].coordinates![0], closeTo(700.0, 0.01));
      expect(fvar.instanceRecords![1].coordinates![1], closeTo(100.0, 0.01));
    });

    test('reads instance with optional postScriptNameID', () {
      final builder = BytesBuilder();

      // fvar header
      builder.add([0x00, 0x01]); // majorVersion
      builder.add([0x00, 0x00]); // minorVersion
      builder.add([0x00, 0x10]); // axesArrayOffset: 16
      builder.add([0x00, 0x02]); // reserved
      builder.add([0x00, 0x01]); // axisCount: 1
      builder.add([0x00, 0x14]); // axisSize: 20
      builder.add([0x00, 0x01]); // instanceCount: 1
      builder.add([0x00, 0x0A]); // instanceSize: 10 (4 + 1*4 + 2 for postScriptNameID)

      // Axis 0: wght
      builder.add([0x77, 0x67, 0x68, 0x74]); // 'wght'
      builder.add([0x00, 0x64, 0x00, 0x00]); // 100.0
      builder.add([0x01, 0x90, 0x00, 0x00]); // 400.0
      builder.add([0x03, 0x84, 0x00, 0x00]); // 900.0
      builder.add([0x00, 0x00]); // flags
      builder.add([0x01, 0x00]); // axisNameID: 256

      // Instance with postScriptNameID
      builder.add([0x01, 0x02]); // subfamilyNameID: 258
      builder.add([0x00, 0x00]); // flags
      builder.add([0x02, 0xBC, 0x00, 0x00]); // wght=700.0
      builder.add([0x01, 0x04]); // postScriptNameID: 260

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final fvar = FVar();
      fvar.header = TableHeader(
          tag: 0x66766172, checkSum: 0, offset: 0, length: data.length);
      fvar.readContentFrom(reader);

      expect(fvar.instanceRecords![0].postScriptNameID, equals(260));
    });

    test('handles single axis font', () {
      final builder = BytesBuilder();

      // Minimal fvar with one axis and no instances
      builder.add([0x00, 0x01]); // majorVersion
      builder.add([0x00, 0x00]); // minorVersion
      builder.add([0x00, 0x10]); // axesArrayOffset: 16
      builder.add([0x00, 0x02]); // reserved
      builder.add([0x00, 0x01]); // axisCount: 1
      builder.add([0x00, 0x14]); // axisSize: 20
      builder.add([0x00, 0x00]); // instanceCount: 0
      builder.add([0x00, 0x00]); // instanceSize: 0

      // Axis: opsz (optical size)
      builder.add([0x6F, 0x70, 0x73, 0x7A]); // 'opsz'
      builder.add([0x00, 0x08, 0x00, 0x00]); // 8.0
      builder.add([0x00, 0x0C, 0x00, 0x00]); // 12.0
      builder.add([0x00, 0x48, 0x00, 0x00]); // 72.0
      builder.add([0x00, 0x00]); // flags
      builder.add([0x01, 0x05]); // axisNameID: 261

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final fvar = FVar();
      fvar.header = TableHeader(
          tag: 0x66766172, checkSum: 0, offset: 0, length: data.length);
      fvar.readContentFrom(reader);

      expect(fvar.variableAxisRecords!.length, equals(1));
      expect(fvar.variableAxisRecords![0].axisTag, equals('opsz'));
      expect(fvar.instanceRecords!.length, equals(0));
    });
  });

  group('VariableAxisRecord', () {
    test('reads axis with HIDDEN_AXIS flag', () {
      final builder = BytesBuilder();

      builder.add([0x73, 0x6C, 0x6E, 0x74]); // 'slnt' (slant)
      // Fixed 16.16 for -12.0: sign-extended: 0xFFF40000
      builder.add([0xFF, 0xF4, 0x00, 0x00]); // -12.0
      builder.add([0x00, 0x00, 0x00, 0x00]); // 0.0
      builder.add([0x00, 0x0C, 0x00, 0x00]); // 12.0
      builder.add([0x00, 0x01]); // flags: HIDDEN_AXIS (0x0001)
      builder.add([0x01, 0x06]); // axisNameID: 262

      final data = builder.toBytes();
      final reader = ByteOrderSwappingBinaryReader(data);

      final axis = VariableAxisRecord();
      axis.readContent(reader);

      expect(axis.axisTag, equals('slnt'));
      expect(axis.minValue, closeTo(-12.0, 0.01));
      expect(axis.defaultValue, closeTo(0.0, 0.01));
      expect(axis.maxValue, closeTo(12.0, 0.01));
      expect(axis.flags, equals(1)); // HIDDEN_AXIS
    });
  });
}
