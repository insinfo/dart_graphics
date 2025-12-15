// ignore_for_file: avoid_print
/// Gerador de bindings Dart a partir do código C# do SkiaSharp.
///
/// Este script analisa o arquivo SkiaApi.generated.cs e gera:
/// - Typedefs para tipos opacos (handles)
/// - Bindings FFI para todas as funções exportadas
/// - Enums e structs
///
/// Uso: dart run tool/generate_skiasharp_bindings.dart

import 'dart:io';
import 'package:path/path.dart' as p;

const skiaSharpPath = 'referencias/SkiaSharp-main';
const outputPath = 'lib/src/skia/generated';

/// Função principal
Future<void> main() async {
  print('═══════════════════════════════════════════════════════════════');
  print('  SkiaSharp Bindings Generator for Dart');
  print('═══════════════════════════════════════════════════════════════');
  print('');

  final projectRoot = Directory.current.path;
  
  // Ler o arquivo fonte
  final apiFile = File(p.join(projectRoot, skiaSharpPath, 'binding/SkiaSharp/SkiaApi.generated.cs'));
  
  if (!await apiFile.exists()) {
    print('❌ Arquivo não encontrado: ${apiFile.path}');
    print('');
    print('Certifique-se de que o repositório SkiaSharp está em:');
    print('  $skiaSharpPath');
    exit(1);
  }

  print('📖 Lendo SkiaApi.generated.cs...');
  final source = await apiFile.readAsString();

  print('🔍 Analisando código C#...');
  final parser = CSharpParser(source);
  await parser.parse();

  print('   📋 ${parser.typeAliases.length} tipos opacos');
  print('   📋 ${parser.functions.length} funções');
  print('   📋 ${parser.enums.length} enums');
  print('   📋 ${parser.structs.length} structs');

  print('');
  print('🔧 Gerando código Dart...');

  // Criar diretório de saída
  final outDir = Directory(p.join(projectRoot, outputPath));
  await outDir.create(recursive: true);

  // Gerar arquivo principal de bindings
  final bindingsCode = generateBindings(parser);
  final bindingsFile = File(p.join(outDir.path, 'skiasharp_bindings.dart'));
  await bindingsFile.writeAsString(bindingsCode);
  print('   ✅ ${bindingsFile.path}');

  // Gerar arquivo de tipos
  final typesCode = generateTypes(parser);
  final typesFile = File(p.join(outDir.path, 'skiasharp_types.dart'));
  await typesFile.writeAsString(typesCode);
  print('   ✅ ${typesFile.path}');

  // Gerar arquivo de enums
  final enumsCode = generateEnums(parser);
  final enumsFile = File(p.join(outDir.path, 'skiasharp_enums.dart'));
  await enumsFile.writeAsString(enumsCode);
  print('   ✅ ${enumsFile.path}');

  // Gerar arquivo barrel
  final barrelCode = generateBarrel();
  final barrelFile = File(p.join(outDir.path, 'skiasharp.dart'));
  await barrelFile.writeAsString(barrelCode);
  print('   ✅ ${barrelFile.path}');

  print('');
  print('═══════════════════════════════════════════════════════════════');
  print('  Bindings gerados com sucesso!');
  print('═══════════════════════════════════════════════════════════════');
}

/// Parser do código C#
class CSharpParser {
  final String source;
  
  final Map<String, String> typeAliases = {};
  final List<FunctionDef> functions = [];
  final List<EnumDef> enums = [];
  final List<StructDef> structs = [];

  CSharpParser(this.source);

  Future<void> parse() async {
    _parseTypeAliases();
    _parseFunctions();
    _parseEnums();
    _parseStructs();
  }

  void _parseTypeAliases() {
    // Parse: using sk_canvas_t = System.IntPtr;
    final regex = RegExp(r'using\s+(\w+_t)\s*=\s*System\.IntPtr;');
    for (final match in regex.allMatches(source)) {
      final name = match.group(1)!;
      typeAliases[name] = 'IntPtr';
    }
  }

  void _parseFunctions() {
    final functionNames = <String>{};
    
    // Helper to normalize return type (remove comments like /* size_t */)
    String normalizeReturnType(String type) {
      // Remove inline comments like /* size_t */
      var result = type.replaceAll(RegExp(r'/\*[^*]*\*/'), '').trim();
      // Normalize pointer types
      result = result.replaceAll(RegExp(r'\s*\*'), '*');
      return result;
    }
    
    // Strategy 1: Parse from comment + internal static partial
    // Format: internal static partial returnType functionName (params);
    // Handles pointer return types like Byte*, void*, and comments like /* size_t */
    final partialRegex = RegExp(
      r'internal\s+static\s+partial\s+(/\*[^*]*\*/\s*)?(\w+\*?)\s+(\w+)\s*\(([^;]*)\);',
      multiLine: true,
    );

    for (final match in partialRegex.allMatches(source)) {
      final comment = match.group(1) ?? '';
      var returnType = match.group(2)!;
      final name = match.group(3)!;
      var paramsStr = match.group(4) ?? '';
      
      // If there's a comment like /* size_t */, use IntPtr
      if (comment.contains('size_t')) {
        returnType = 'IntPtr';
      }
      returnType = normalizeReturnType(returnType);
      
      // Normalize whitespace in params (multi-line to single line)
      paramsStr = paramsStr.replaceAll(RegExp(r'\s+'), ' ').trim();

      if (!functionNames.contains(name)) {
        functionNames.add(name);
        functions.add(FunctionDef(
          name: name,
          returnType: returnType,
          parameters: _parseParams(paramsStr),
        ));
      }
    }

    // Strategy 2: Parse from DllImport + extern
    // Handles pointer return types like Byte*, void*, and comments like /* size_t */
    final externRegex = RegExp(
      r'internal\s+static\s+extern\s+(/\*[^*]*\*/\s*)?(\w+\*?)\s+(\w+)\s*\(([^;]*)\);',
      multiLine: true,
    );

    for (final match in externRegex.allMatches(source)) {
      final comment = match.group(1) ?? '';
      var returnType = match.group(2)!;
      final name = match.group(3)!;
      var paramsStr = match.group(4) ?? '';
      
      // If there's a comment like /* size_t */, use IntPtr
      if (comment.contains('size_t')) {
        returnType = 'IntPtr';
      }
      returnType = normalizeReturnType(returnType);
      
      // Normalize whitespace in params
      paramsStr = paramsStr.replaceAll(RegExp(r'\s+'), ' ').trim();

      if (!functionNames.contains(name)) {
        functionNames.add(name);
        functions.add(FunctionDef(
          name: name,
          returnType: returnType,
          parameters: _parseParams(paramsStr),
        ));
      }
    }

    // Strategy 3: Parse from delegate declarations (most reliable)
    // Format: internal delegate returnType functionName (params);
    // Handles pointer return types like Byte*, void*, and comments like /* size_t */
    final delegateRegex = RegExp(
      r'internal\s+delegate\s+(/\*[^*]*\*/\s*)?(\w+\*?)\s+(\w+)\s*\(([^;]*)\);',
      multiLine: true,
    );

    for (final match in delegateRegex.allMatches(source)) {
      final comment = match.group(1) ?? '';
      var returnType = match.group(2)!;
      final name = match.group(3)!;
      var paramsStr = match.group(4) ?? '';
      
      // If there's a comment like /* size_t */, use IntPtr
      if (comment.contains('size_t')) {
        returnType = 'IntPtr';
      }
      returnType = normalizeReturnType(returnType);
      
      // Normalize whitespace in params
      paramsStr = paramsStr.replaceAll(RegExp(r'\s+'), ' ').trim();

      if (!functionNames.contains(name)) {
        functionNames.add(name);
        functions.add(FunctionDef(
          name: name,
          returnType: returnType,
          parameters: _parseParams(paramsStr),
        ));
      }
    }
    
    print('   Found ${functions.length} unique functions');
  }

  List<ParamDef> _parseParams(String paramsStr) {
    if (paramsStr.trim().isEmpty) return [];

    final params = <ParamDef>[];
    final parts = paramsStr.split(',');

    for (final part in parts) {
      var trimmed = part.trim();
      if (trimmed.isEmpty) continue;

      // Handle attributes like [MarshalAs(...)]
      trimmed = trimmed.replaceAll(RegExp(r'\[[^\]]+\]\s*'), '');

      // Parse "Type name" or "Type* name"
      final match = RegExp(r'(\S+)\s+(\w+)$').firstMatch(trimmed);
      if (match != null) {
        params.add(ParamDef(
          type: match.group(1)!,
          name: match.group(2)!,
        ));
      }
    }

    return params;
  }

  void _parseEnums() {
    // Parse enum definitions
    final regex = RegExp(
      r'(?:public\s+)?enum\s+(\w+)\s*(?::\s*\w+)?\s*\{([^}]+)\}',
      multiLine: true,
    );

    for (final match in regex.allMatches(source)) {
      final name = match.group(1)!;
      final body = match.group(2)!;

      final values = <EnumValue>[];
      // Match: Name = value, ou apenas Name,
      final valueRegex = RegExp(r'([A-Za-z_][A-Za-z0-9_]*)\s*(?:=\s*(-?\d+|0x[0-9a-fA-F]+))?\s*,?');

      for (final vm in valueRegex.allMatches(body)) {
        final valueName = vm.group(1)!;
        // Skip se não começa com letra ou underscore (identificador válido)
        if (!RegExp(r'^[A-Za-z_]').hasMatch(valueName)) continue;
        final valueStr = vm.group(2);
        int? value;
        if (valueStr != null) {
          if (valueStr.startsWith('0x')) {
            value = int.parse(valueStr.substring(2), radix: 16);
          } else {
            value = int.tryParse(valueStr);
          }
        }
        values.add(EnumValue(name: valueName, value: value));
      }

      enums.add(EnumDef(name: name, values: values));
    }
  }

  void _parseStructs() {
    // Parse struct definitions
    final regex = RegExp(
      r'(?:\[StructLayout[^\]]*\]\s*)?'
      r'(?:public\s+)?(?:partial\s+)?struct\s+(\w+)\s*\{([^}]+)\}',
      multiLine: true,
    );

    for (final match in regex.allMatches(source)) {
      final name = match.group(1)!;
      final body = match.group(2)!;

      final fields = <FieldDef>[];
      final fieldRegex = RegExp(r'public\s+(\S+)\s+(\w+)\s*;');

      for (final fm in fieldRegex.allMatches(body)) {
        fields.add(FieldDef(
          type: fm.group(1)!,
          name: fm.group(2)!,
        ));
      }

      if (fields.isNotEmpty) {
        structs.add(StructDef(name: name, fields: fields));
      }
    }
  }
}

class FunctionDef {
  final String name;
  final String returnType;
  final List<ParamDef> parameters;

  FunctionDef({
    required this.name,
    required this.returnType,
    required this.parameters,
  });
}

class ParamDef {
  final String type;
  final String name;

  ParamDef({required this.type, required this.name});
}

class EnumDef {
  final String name;
  final List<EnumValue> values;

  EnumDef({required this.name, required this.values});
}

class EnumValue {
  final String name;
  final int? value;

  EnumValue({required this.name, this.value});
}

class StructDef {
  final String name;
  final List<FieldDef> fields;

  StructDef({required this.name, required this.fields});
}

class FieldDef {
  final String type;
  final String name;

  FieldDef({required this.type, required this.name});
}

// Lista de tipos conhecidos como enums (valores Int32)
const _enumTypes = {
  'GRBackendNative', 'GRSurfaceOrigin', 'SKAlphaType', 'SKBlendMode',
  'SKColorTypeNative', 'SKFilterMode', 'SKMipmapMode', 'SKPathOp',
  'SKPathFillType', 'SKPathDirection', 'SKPathArcSize', 'SKPathVerb',
  'SKEncodedImageFormat', 'SKFontStyleSlant', 'SKFontStyleWeight', 
  'SKFontStyleWidth', 'SKTextAlign', 'SKTextEncoding', 'SKFilterQuality',
  'SKClipOp', 'SKPointMode', 'SKPixelGeometry', 'SKPaintStyle',
  'SKStrokeCap', 'SKStrokeJoin', 'SKShaderTileMode', 'SKVertexMode',
  'SKImageCachingHint', 'SKLatticeRectType', 'SKTrimPathEffectMode',
  'SKPathMeasureMatrixFlags', 'SKRegionOperation', 'SKCodecResult',
  'SKCodecAnimationDisposalMethod', 'SKCodecAnimationBlend', 'SKTransferFunctionBehavior',
  'SKHighContrastConfigInvertStyle', 'SKBitmapAllocFlags', 'SKSurfacePropsFlags',
  // Tipos com Native suffix
  'SKColorSpaceType',
};

// Lista de tipos conhecidos como structs (passados por valor ou pointer)
const _structTypes = {
  'SKRect', 'SKRectI', 'SKPoint', 'SKPointI', 'SKPoint3', 'SKSize', 'SKSizeI',
  'SKMatrix', 'SKMatrix44', 'SKColor', 'SKColorF', 'SKImageInfo', 
  'GRGlFramebufferInfo', 'GRGlTextureInfo', 'GRVkImageInfo', 'GRVkBackendContextNative',
  'GRMtlTextureInfoNative', 'GRD3DTextureResourceInfoNative', 'GRD3DBackendContextNative',
  'GRContextOptionsNative', 'SKFontMetrics', 'SKTextBlobBuilderRunBuffer',
  'SKRuntimeEffectUniform', 'SKRuntimeEffectChild', 'SKColorSpacePrimaries',
  'SKColorSpaceTransferFn', 'SKHighContrastConfig', 'SKLattice', 'SKCodecOptions',
  'SKCodecFrameInfo', 'SKDocumentPdfMetadata', 'SKSamplingOptions',
  'SKWebpEncoderOptions', 'SKJpegEncoderOptions', 'SKPngEncoderOptions',
  // Tipos nativos
  'SKColorSpaceXyz',
};

// Tipos delegate (callbacks)
const _delegateTypes = {
  'GRGlGetProcProxyDelegate', 'GRVkGetProcProxyDelegate', 
  'SKGlyphPathProxyDelegate', 'SKImageRasterReleaseProxyDelegate',
  'SKImageTextureReleaseProxyDelegate', 'SKManagedDrawableDelegates',
  'SKManagedStreamDelegates', 'SKManagedWStreamDelegates',
  'SKBitmapReleaseProxyDelegate', 'SKDataReleaseProxyDelegate',
  'SKSurfaceRasterReleaseProxyDelegate',
};

/// Gera o arquivo de bindings principal (estilo ffigen)
String generateBindings(CSharpParser parser) {
  final sb = StringBuffer();

  sb.writeln('''
// GENERATED CODE - DO NOT MODIFY BY HAND
// Source: SkiaSharp SkiaApi.generated.cs
// Generated: ${DateTime.now().toIso8601String()}

// ignore_for_file: camel_case_types, non_constant_identifier_names
// ignore_for_file: constant_identifier_names, unused_element
// ignore_for_file: unused_field, lines_longer_than_80_chars
// ignore_for_file: unused_import, public_member_api_docs

import 'dart:ffi' as ffi;

import 'skiasharp_types.dart';
import 'skiasharp_enums.dart';
export 'skiasharp_types.dart';
export 'skiasharp_enums.dart';

/// Bindings to SkiaSharp native library.
///
/// Regenerate bindings with `dart run scripts/generate_skiasharp_bindings.dart`.
class SkiaSharpBindings {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  SkiaSharpBindings(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  SkiaSharpBindings.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;
''');

  // Group functions by prefix for organization
  final groups = <String, List<FunctionDef>>{};
  for (final func in parser.functions) {
    String prefix;
    if (func.name.startsWith('sk_')) prefix = 'sk';
    else if (func.name.startsWith('gr_')) prefix = 'gr';
    else if (func.name.startsWith('skottie_')) prefix = 'skottie';
    else if (func.name.startsWith('sksg_')) prefix = 'sksg';
    else if (func.name.startsWith('skresources_')) prefix = 'skresources';
    else prefix = 'other';

    groups.putIfAbsent(prefix, () => []).add(func);
  }

  for (final entry in groups.entries) {
    sb.writeln();
    sb.writeln('  // ══════════════════════════════════════════════════════════');
    sb.writeln('  // ${entry.key.toUpperCase()} Functions');
    sb.writeln('  // ══════════════════════════════════════════════════════════');

    for (final func in entry.value) {
      final nativeReturnType = mapTypeFfi(func.returnType, parser.typeAliases);
      final dartReturnType = mapDartTypeFfi(nativeReturnType);

      // Build native signature
      final nativeParamTypes = func.parameters
          .map((p) => mapTypeFfi(p.type, parser.typeAliases))
          .join(', ');

      // Build dart signature  
      final dartParamTypes = func.parameters
          .map((p) => mapDartTypeFfi(mapTypeFfi(p.type, parser.typeAliases)))
          .join(', ');

      // Build method parameters
      final methodParams = func.parameters
          .map((p) {
            final ffiType = mapTypeFfi(p.type, parser.typeAliases);
            final dartType = mapDartTypeFfi(ffiType);
            return '$dartType ${_sanitizeName(p.name)}';
          })
          .join(',\n    ');

      // Build call arguments
      final callArgs = func.parameters
          .map((p) => _sanitizeName(p.name))
          .join(',\n      ');

      sb.writeln();
      sb.writeln('  /// ${func.returnType} ${func.name}(${func.parameters.map((p) => '${p.type} ${p.name}').join(', ')})');
      
      // Method
      if (func.parameters.isEmpty) {
        sb.writeln('  $dartReturnType ${func.name}() {');
        sb.writeln('    return _${func.name}();');
      } else {
        sb.writeln('  $dartReturnType ${func.name}(');
        sb.writeln('    $methodParams,');
        sb.writeln('  ) {');
        sb.writeln('    return _${func.name}(');
        sb.writeln('      $callArgs,');
        sb.writeln('    );');
      }
      sb.writeln('  }');
      sb.writeln();
      
      // late final pointer lookup
      sb.writeln('  late final _${func.name}Ptr = _lookup<');
      sb.writeln('      ffi.NativeFunction<$nativeReturnType Function($nativeParamTypes)>>(\'${func.name}\');');
      
      // late final asFunction
      sb.writeln('  late final _${func.name} =');
      sb.writeln('      _${func.name}Ptr.asFunction<$dartReturnType Function($dartParamTypes)>();');
    }
  }

  sb.writeln('}');

  return sb.toString();
}

/// Mapeia tipos C# para tipos Dart FFI (com prefixo ffi.)
String mapTypeFfi(String csType, Map<String, String> typeAliases) {
  // Handle pointer types
  final isPointer = csType.endsWith('*');
  var baseType = csType.replaceAll('*', '').trim();

  // Type aliases (opaque handles)
  if (typeAliases.containsKey(baseType)) {
    return 'ffi.Pointer<ffi.Void>';
  }

  // Built-in type mappings
  final mapping = {
    'void': 'ffi.Void',
    'bool': 'ffi.Bool',
    'byte': 'ffi.Uint8',
    'Byte': 'ffi.Uint8',
    'sbyte': 'ffi.Int8',
    'SByte': 'ffi.Int8',
    'short': 'ffi.Int16',
    'Int16': 'ffi.Int16',
    'ushort': 'ffi.Uint16',
    'UInt16': 'ffi.Uint16',
    'int': 'ffi.Int32',
    'Int32': 'ffi.Int32',
    'uint': 'ffi.Uint32',
    'UInt32': 'ffi.Uint32',
    'long': 'ffi.Int64',
    'Int64': 'ffi.Int64',
    'ulong': 'ffi.Uint64',
    'UInt64': 'ffi.Uint64',
    'float': 'ffi.Float',
    'Single': 'ffi.Float',
    'double': 'ffi.Double',
    'Double': 'ffi.Double',
    'IntPtr': 'ffi.Pointer<ffi.Void>',
    'UIntPtr': 'ffi.Pointer<ffi.Void>',
  };

  final mapped = mapping[baseType];
  if (mapped != null) {
    if (isPointer && !mapped.startsWith('ffi.Pointer')) {
      return 'ffi.Pointer<$mapped>';
    }
    return mapped;
  }

  // Enum types são Int32
  if (_enumTypes.contains(baseType)) {
    if (isPointer) return 'ffi.Pointer<ffi.Int32>';
    return 'ffi.Int32';
  }

  // Struct types são tratados como Pointer<Void> (opaque)
  if (_structTypes.contains(baseType)) {
    if (isPointer) return 'ffi.Pointer<ffi.Void>';
    return 'ffi.Pointer<ffi.Void>';
  }

  // Delegate types são NativeFunction pointers
  if (_delegateTypes.contains(baseType)) {
    return 'ffi.Pointer<ffi.NativeFunction<ffi.Void Function()>>';
  }

  // Unknown type - assume it's a struct pointer
  if (isPointer) {
    return 'ffi.Pointer<ffi.Void>';
  }

  // Fallback para tipos desconhecidos: tratar como Pointer<Void>
  return 'ffi.Pointer<ffi.Void>';
}

/// Mapeia tipo FFI para tipo Dart nativo
String mapDartTypeFfi(String ffiType) {
  if (ffiType == 'ffi.Void') return 'void';
  if (ffiType == 'ffi.Bool') return 'bool';
  // Importante: verificar Pointer primeiro, antes de Int/Uint
  if (ffiType.startsWith('ffi.Pointer')) return ffiType;
  // Tipos inteiros simples
  if (ffiType.contains('Int') || ffiType.contains('Uint')) return 'int';
  if (ffiType == 'ffi.Float' || ffiType == 'ffi.Double') return 'double';
  return ffiType;
}

/// Mapeia tipos C# para tipos Dart FFI (sem prefixo ffi. - para uso em types)
String mapTypeSimple(String csType, Map<String, String> typeAliases) {
  // Handle pointer types
  final isPointer = csType.endsWith('*');
  var baseType = csType.replaceAll('*', '').trim();

  // Type aliases (opaque handles)
  if (typeAliases.containsKey(baseType)) {
    return 'Pointer<Void>';
  }

  // Built-in type mappings
  final mapping = {
    'void': 'Void',
    'bool': 'Bool',
    'byte': 'Uint8',
    'Byte': 'Uint8',
    'sbyte': 'Int8',
    'SByte': 'Int8',
    'short': 'Int16',
    'Int16': 'Int16',
    'ushort': 'Uint16',
    'UInt16': 'Uint16',
    'int': 'Int32',
    'Int32': 'Int32',
    'uint': 'Uint32',
    'UInt32': 'Uint32',
    'long': 'Int64',
    'Int64': 'Int64',
    'ulong': 'Uint64',
    'UInt64': 'Uint64',
    'float': 'Float',
    'Single': 'Float',
    'double': 'Double',
    'Double': 'Double',
    'IntPtr': 'Pointer<Void>',
    'UIntPtr': 'Pointer<Void>',
  };

  final mapped = mapping[baseType];
  if (mapped != null) {
    if (isPointer && !mapped.startsWith('Pointer')) {
      return 'Pointer<$mapped>';
    }
    return mapped;
  }

  // Enum types são Int32
  if (_enumTypes.contains(baseType)) {
    if (isPointer) return 'Pointer<Int32>';
    return 'Int32';
  }

  // Struct types são tratados como Pointer<Void> (opaque)
  if (_structTypes.contains(baseType)) {
    return 'Pointer<Void>';
  }

  // Delegate types são NativeFunction pointers
  if (_delegateTypes.contains(baseType)) {
    return 'Pointer<NativeFunction<Void Function()>>';
  }

  if (isPointer) {
    return 'Pointer<Void>';
  }

  return 'Pointer<Void>';
}

/// Mapeia tipo FFI para tipo Dart nativo (sem prefixo)
String mapDartTypeSimple(String ffiType) {
  if (ffiType == 'Void') return 'void';
  if (ffiType == 'Bool') return 'bool';
  if (ffiType.startsWith('Pointer')) return ffiType;
  if (ffiType.contains('Int') || ffiType.contains('Uint')) return 'int';
  if (ffiType == 'Float' || ffiType == 'Double') return 'double';
  return ffiType;
}

/// Gera o arquivo de tipos
String generateTypes(CSharpParser parser) {
  final sb = StringBuffer();

  sb.writeln('''
// GENERATED CODE - DO NOT MODIFY BY HAND
// Source: SkiaSharp SkiaApi.generated.cs
// Generated: ${DateTime.now().toIso8601String()}

// ignore_for_file: camel_case_types, non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'dart:ffi';

// ============================================================
// Opaque Types (Handles)
// ============================================================
''');

  for (final entry in parser.typeAliases.entries) {
    final name = entry.key;
    final dartName = _toPascalCase(name.replaceAll('_t', ''));
    sb.writeln('/// Handle for $name');
    sb.writeln('typedef $dartName = Pointer<Void>;');
    sb.writeln('typedef ${name} = Pointer<Void>;');
    sb.writeln();
  }

  sb.writeln('// ============================================================');
  sb.writeln('// Structs');
  sb.writeln('// ============================================================');
  sb.writeln();

  for (final struct in parser.structs) {
    sb.writeln('/// ${struct.name}');
    sb.writeln('final class ${struct.name} extends Struct {');
    for (final field in struct.fields) {
      final ffiType = mapTypeSimple(field.type, parser.typeAliases);
      if (ffiType.startsWith('Pointer')) {
        sb.writeln('  external $ffiType ${_sanitizeName(field.name)};');
      } else {
        sb.writeln('  @$ffiType()');
        sb.writeln('  external ${mapDartTypeSimple(ffiType)} ${_sanitizeName(field.name)};');
      }
    }
    sb.writeln('}');
    sb.writeln();
  }

  return sb.toString();
}

/// Gera o arquivo de enums
String generateEnums(CSharpParser parser) {
  final sb = StringBuffer();

  sb.writeln('''
// GENERATED CODE - DO NOT MODIFY BY HAND
// Source: SkiaSharp SkiaApi.generated.cs
// Generated: ${DateTime.now().toIso8601String()}

// ignore_for_file: camel_case_types, non_constant_identifier_names
// ignore_for_file: constant_identifier_names

// ============================================================
// Enums
// ============================================================
''');

  for (final enumDef in parser.enums) {
    sb.writeln('/// ${enumDef.name}');
    sb.writeln('abstract class ${enumDef.name} {');

    int nextValue = 0;
    final usedNames = <String>{};
    for (final value in enumDef.values) {
      final v = value.value ?? nextValue;
      // Evitar nomes duplicados
      if (!usedNames.contains(value.name)) {
        sb.writeln('  static const int ${value.name} = $v;');
        usedNames.add(value.name);
      }
      nextValue = v + 1;
    }

    sb.writeln('}');
    sb.writeln();
  }

  return sb.toString();
}

/// Gera o arquivo barrel
String generateBarrel() {
  return '''
// GENERATED CODE - DO NOT MODIFY BY HAND
// Barrel file for SkiaSharp bindings

library skiasharp;

export 'skiasharp_bindings.dart';
export 'skiasharp_types.dart';
export 'skiasharp_enums.dart';
''';
}

String _toPascalCase(String input) {
  return input.split('_').map((word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join();
}

String _sanitizeName(String name) {
  // Dart reserved words
  const reserved = {'in', 'out', 'is', 'as', 'if', 'else', 'for', 'while', 'do', 'switch', 'case', 'default', 'break', 'continue', 'return', 'throw', 'try', 'catch', 'finally', 'class', 'extends', 'implements', 'new', 'this', 'super', 'null', 'true', 'false', 'void', 'var', 'final', 'const', 'static', 'abstract', 'interface', 'enum'};
  
  if (reserved.contains(name)) {
    return '${name}_';
  }
  return name;
}
