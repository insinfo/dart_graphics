/// Debug: Verificar vértices gerados para a letra "o"

import 'dart:io';
import 'package:dart_graphics/src/shared/ref_param.dart';
import 'package:dart_graphics/src/agg/vertex_source/glyph_vertex_source.dart';
import 'package:dart_graphics/src/agg/vertex_source/flatten_curve.dart';

import 'package:dart_graphics/src/typography/openfont/open_font_reader.dart';


void main() async {
  // Carregar fonte
  final fontData = await File('resources/fonts/liberation-fonts-ttf-1.07.0/LiberationSans-Regular.ttf').readAsBytes();
  final reader = OpenFontReader();
  final typeface = reader.read(fontData)!;

  // Obter glifo da letra "o"
  final glyphIndex = typeface.getGlyphIndex('o'.codeUnitAt(0));
  print('Glyph index para "o": $glyphIndex');

  final glyph = typeface.getGlyph(glyphIndex);
  print('Contours: ${glyph.contourEndPoints?.length ?? 0}');
  print('Points: ${glyph.glyphPoints?.length ?? 0}');

  // Mostrar pontos do glifo
  if (glyph.glyphPoints != null) {
    print('\nPontos do glifo:');
    for (var i = 0; i < glyph.glyphPoints!.length; i++) {
      final p = glyph.glyphPoints![i];
      print('  [$i] x=${p.x.toStringAsFixed(2)}, y=${p.y.toStringAsFixed(2)}, onCurve=${p.onCurve}');
    }
  }

  if (glyph.contourEndPoints != null) {
    print('\nEnd points dos contornos: ${glyph.contourEndPoints}');
  }

  // Gerar vértices SEM flatten
  print('\n--- Vértices do GlyphVertexSource (sem flatten) ---');
  final source = GlyphVertexSource(glyph);
  var x = RefParam(0.0);
  var y = RefParam(0.0);
  int count = 0;
  int curve3Count = 0;

  source.rewind();
  while (true) {
    final cmd = source.vertex(x, y);
    if (cmd.isStop) break;

    String cmdName = 'Unknown';
    if (cmd.isMoveTo) cmdName = 'MoveTo';
    else if (cmd.isLineTo) cmdName = 'LineTo';
    else if (cmd.isCurve3) {
      cmdName = 'Curve3';
      curve3Count++;
    }
    else if (cmd.isEndPoly) cmdName = 'EndPoly';

    print('  $cmdName: (${x.value.toStringAsFixed(2)}, ${y.value.toStringAsFixed(2)})');
    count++;
    if (count > 100) {
      print('  ... (truncado)');
      break;
    }
  }
  print('Total de comandos: $count (Curve3: $curve3Count)');

  // Gerar vértices COM flatten
  print('\n--- Vértices com FlattenCurve ---');
  final flattened = FlattenCurve(GlyphVertexSource(glyph));
  int flatCount = 0;
  int lineToCount = 0;

  flattened.rewind();
  while (true) {
    final cmd = flattened.vertex(x, y);
    if (cmd.isStop) break;

    String cmdName = 'Unknown';
    if (cmd.isMoveTo) cmdName = 'MoveTo';
    else if (cmd.isLineTo) {
      cmdName = 'LineTo';
      lineToCount++;
    }
    else if (cmd.isCurve3) cmdName = 'Curve3 (BUG!)';
    else if (cmd.isEndPoly) cmdName = 'EndPoly';

    print('  $cmdName: (${x.value.toStringAsFixed(2)}, ${y.value.toStringAsFixed(2)})');
    flatCount++;
    if (flatCount > 100) {
      print('  ... (truncado)');
      break;
    }
  }
  print('Total de comandos: $flatCount (LineTo: $lineToCount)');
}
