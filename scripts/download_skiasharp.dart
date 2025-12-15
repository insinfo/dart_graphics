// ignore_for_file: avoid_print
/// Script simplificado para baixar as DLLs do SkiaSharp do NuGet
/// e gerar bindings Dart básicos.
///
/// Uso: dart run tool/download_skiasharp.dart
///
/// Dependências necessárias no pubspec.yaml:
///   http: ^1.1.0
///   archive: ^3.4.0
///   path: ^1.8.0

import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

const version = '3.119.1';

const packages = {
  'win-x64': {
    'package': 'SkiaSharp.NativeAssets.Win32',
    'path': 'runtimes/win-x64/native/libSkiaSharp.dll',
    'output': 'libSkiaSharp.dll',
  },
  'linux-x64': {
    'package': 'SkiaSharp.NativeAssets.Linux',
    'path': 'runtimes/linux-x64/native/libSkiaSharp.so',
    'output': 'libSkiaSharp.so',
  },
  'linux-musl-x64': {
    'package': 'SkiaSharp.NativeAssets.Linux',
    'path': 'runtimes/linux-musl-x64/native/libSkiaSharp.so',
    'output': 'libSkiaSharp-musl.so',
  },
  'osx-x64': {
    'package': 'SkiaSharp.NativeAssets.macOS',
    'path': 'runtimes/osx/native/libSkiaSharp.dylib',
    'output': 'libSkiaSharp.dylib',
  },
};

Future<void> main(List<String> args) async {
  print('═══════════════════════════════════════════════════════════════');
  print('  SkiaSharp Native Libraries Downloader');
  print('  Version: $version');
  print('═══════════════════════════════════════════════════════════════');
  print('');

  final outputDir = p.join(Directory.current.path, 'native', 'libs', 'bin');
  await Directory(outputDir).create(recursive: true);

  // Parse arguments
  final platformsToDownload = args.isEmpty 
      ? packages.keys.toList()
      : args.where((a) => packages.containsKey(a)).toList();

  if (platformsToDownload.isEmpty) {
    print('Plataformas disponíveis: ${packages.keys.join(', ')}');
    print('');
    print('Uso: dart run tool/download_skiasharp.dart [plataformas]');
    print('Exemplo: dart run tool/download_skiasharp.dart win-x64 linux-x64');
    print('');
    print('Baixando todas as plataformas...');
    platformsToDownload.addAll(packages.keys);
  }

  final cache = <String, Uint8List>{};

  for (final platform in platformsToDownload) {
    final config = packages[platform]!;
    final packageName = config['package']!;
    final internalPath = config['path']!;
    final outputName = config['output']!;

    print('');
    print('📦 [$platform] $packageName');

    try {
      // Check cache
      Uint8List packageBytes;
      if (cache.containsKey(packageName)) {
        print('   📋 Usando cache do pacote...');
        packageBytes = cache[packageName]!;
      } else {
        print('   ⬇️  Baixando de nuget.org...');
        final url = 'https://www.nuget.org/api/v2/package/$packageName/$version';
        
        final response = await http.get(Uri.parse(url));
        if (response.statusCode != 200) {
          throw Exception('HTTP ${response.statusCode}');
        }
        
        packageBytes = response.bodyBytes;
        cache[packageName] = packageBytes;
        print('   ✅ Download completo (${(packageBytes.length / 1024 / 1024).toStringAsFixed(2)} MB)');
      }

      print('   📂 Extraindo $internalPath...');
      final archive = ZipDecoder().decodeBytes(packageBytes);
      
      ArchiveFile? targetFile;
      for (final file in archive) {
        if (file.name == internalPath || file.name.endsWith(internalPath)) {
          targetFile = file;
          break;
        }
      }

      if (targetFile == null) {
        print('   ⚠️  Arquivo não encontrado no pacote: $internalPath');
        print('   📋 Arquivos disponíveis:');
        for (final file in archive.where((f) => f.name.contains('libSkiaSharp'))) {
          print('      - ${file.name}');
        }
        continue;
      }

      final outputPath = p.join(outputDir, outputName);
      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(targetFile.content as List<int>);

      final fileSize = await outputFile.length();
      print('   ✅ Salvo: $outputPath (${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB)');

    } catch (e) {
      print('   ❌ Erro: $e');
    }
  }

  print('');
  print('═══════════════════════════════════════════════════════════════');
  print('  Download concluído!');
  print('');
  print('  Arquivos salvos em: $outputDir');
  print('═══════════════════════════════════════════════════════════════');
}
