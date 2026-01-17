import 'dart:io';
import 'dart:typed_data';

import 'package:dart_graphics/src/typography/openfont/open_font_reader.dart';
import 'package:dart_graphics/src/typography/openfont/webfont/woff_reader.dart';
import 'package:dart_graphics/src/typography/openfont/webfont/woff2_reader.dart';
import 'package:dart_graphics/src/typography/io/byte_order_swapping_reader.dart';

void main(List<String> args) {
  final fontPath = args.isNotEmpty
      ? args.first
      : 'resources/fonts/Satoshi_Complete/Fonts/WEB/fonts/Satoshi-Regular.woff';
  final bytes = File(fontPath).readAsBytesSync();
  try {
    final headerReader = ByteOrderSwappingBinaryReader(Uint8List.fromList(bytes));
    final signature = headerReader.readUInt32();
    final flavor = headerReader.readUInt32();
    final length = headerReader.readUInt32();
    final numTables = headerReader.readUInt16();
    headerReader.readUInt16();
    final totalSfntSize = headerReader.readUInt32();
    final compressedSize = headerReader.readUInt32();
    print('Header signature: 0x${signature.toRadixString(16)}');
    print('Flavor: 0x${flavor.toRadixString(16)}, length: $length, tables: $numTables');
    print('Total sfnt size: $totalSfntSize, compressed size: $compressedSize');

    final reader = OpenFontReader();
    final typeface = reader.read(Uint8List.fromList(bytes));
    print('OpenFontReader read => ${typeface == null ? 'null' : typeface.name}');

    final br = ByteOrderSwappingBinaryReader(Uint8List.fromList(bytes));
    final woffReader = WoffReader();
    final fromWoff = woffReader.read(br);
    print('WoffReader read => ${fromWoff == null ? 'null' : fromWoff.name}');

    final br2 = ByteOrderSwappingBinaryReader(Uint8List.fromList(bytes));
    final woff2Reader = Woff2Reader();
    final fromWoff2 = woff2Reader.read(br2);
    print('Woff2Reader read => ${fromWoff2 == null ? 'null' : fromWoff2.name}');
  } catch (e, st) {
    print('Exception: $e');
    print(st);
  }
}
