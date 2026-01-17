import 'package:test/test.dart';
import 'package:dart_graphics/src/agg/svg/svg_parser_new.dart';
import 'package:dart_graphics/src/agg/agg_basics.dart';

void main() {
  test('SVG Parser parses fill-rule correctly', () {
    const svg = '''
<svg>
  <path d="M0 0 L10 0 L10 10 Z" fill-rule="evenodd" />
  <path d="M0 0 L10 0 L10 10 Z" fill-rule="nonzero" />
  <path d="M0 0 L10 0 L10 10 Z" />
</svg>
''';

    final shapes = SvgParserNew.parse(svg);
    expect(shapes.length, equals(3));

    expect(shapes[0].fillRule, equals(filling_rule_e.fill_even_odd));
    expect(shapes[1].fillRule, equals(filling_rule_e.fill_non_zero));
    expect(shapes[2].fillRule, equals(filling_rule_e.fill_non_zero)); // Default
  });

  test('SVG Parser parses brasao_editado_1.svg structure', () {
    // We can't easily read the file here without dart:io, but we can test the parser with a snippet resembling the file.
    const svg = '''
<svg xmlns="http://www.w3.org/2000/svg" fill-rule="evenodd">
 <g>
  <path fill="#010401" fill-rule="nonzero" d="M257.73 0l11.1 0"/>
 </g>
</svg>
''';
    final shapes = SvgParserNew.parse(svg);
    expect(shapes.length, equals(1));
    expect(shapes[0].fillRule, equals(filling_rule_e.fill_non_zero));
  });
}
