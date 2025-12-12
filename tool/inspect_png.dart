import 'dart:io';

import 'package:image/image.dart' as img;

img.Image _decode(String path) {
  final bytes = File(path).readAsBytesSync();
  final decoded = img.decodePng(bytes);
  if (decoded == null) throw StateError('Failed to decode PNG: $path');
  return decoded;
}

void _printPixel(img.Image im, int x, int y) {
  final p = im.getPixel(x, y);
  stdout.writeln('($x,$y): r=${p.r.toInt()} g=${p.g.toInt()} b=${p.b.toInt()} a=${p.a.toInt()}');
}

void main(List<String> args) {
  if (args.length != 2) {
    stderr.writeln('Usage: dart run tool/inspect_png.dart <a.png> <b.png>');
    exitCode = 64;
    return;
  }

  final aPath = args[0];
  final bPath = args[1];

  final a = _decode(aPath);
  final b = _decode(bPath);

  stdout.writeln('A: $aPath (${a.width}x${a.height})');
  stdout.writeln('B: $bPath (${b.width}x${b.height})');

  final samplePoints = <List<int>>[
    [0, 0],
    [a.width - 1, 0],
    [0, a.height - 1],
    [a.width - 1, a.height - 1],
    [a.width ~/ 2, a.height ~/ 2],
  ];

  for (final pt in samplePoints) {
    final x = pt[0];
    final y = pt[1];
    stdout.writeln('--- sample ($x,$y) ---');
    stdout.write('A ');
    _printPixel(a, x, y);
    stdout.write('B ');
    _printPixel(b, x, y);
  }
}
