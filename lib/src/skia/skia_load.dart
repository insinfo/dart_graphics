import 'dart:ffi' as ffi;
import 'dart:io';

import 'generated/skiasharp_bindings.dart';

/// Loads the SkiaSharp native library
///
/// [libraryPath] - Optional path to the Skia library (DLL/so/dylib).
/// If not provided, the library will be loaded from the default system path.
SkiaSharpBindings loadSkiaSharp({String? libraryPath}) {
  // If a specific path is provided, try it first
  if (libraryPath != null) {
    try {
      return SkiaSharpBindings(ffi.DynamicLibrary.open(libraryPath));
    } catch (e) {
      throw UnsupportedError(
          'Could not load SkiaSharp library from: $libraryPath. Error: $e');
    }
  }

  if (Platform.isWindows) {
    // Try common locations for libSkiaSharp DLL on Windows
    final possiblePaths = [
      'libSkiaSharp.dll',
      'native/libs/skiasharp/win-x64/libSkiaSharp.dll',
      '${Directory.current.path}/libSkiaSharp.dll',
      '${Directory.current.path}/native/libs/skiasharp/win-x64/libSkiaSharp.dll',
    ];

    for (final path in possiblePaths) {
      try {
        return SkiaSharpBindings(ffi.DynamicLibrary.open(path));
      } catch (_) {
        continue;
      }
    }
    throw UnsupportedError(
        'Could not find SkiaSharp library. Please ensure libSkiaSharp.dll is in your PATH or current directory.');
  } else if (Platform.isLinux) {
    final possiblePaths = [
      'libSkiaSharp.so',
      'native/libs/skiasharp/linux-x64/libSkiaSharp.so',
      '${Directory.current.path}/libSkiaSharp.so',
      '${Directory.current.path}/native/libs/skiasharp/linux-x64/libSkiaSharp.so',
    ];

    for (final path in possiblePaths) {
      try {
        return SkiaSharpBindings(ffi.DynamicLibrary.open(path));
      } catch (_) {
        continue;
      }
    }
    throw UnsupportedError(
        'Could not find SkiaSharp library. Please ensure libSkiaSharp.so is available.');
  } else if (Platform.isMacOS) {
    final possiblePaths = [
      'libSkiaSharp.dylib',
      'native/libs/skiasharp/osx-x64/libSkiaSharp.dylib',
      '${Directory.current.path}/libSkiaSharp.dylib',
      '${Directory.current.path}/native/libs/skiasharp/osx-x64/libSkiaSharp.dylib',
    ];

    for (final path in possiblePaths) {
      try {
        return SkiaSharpBindings(ffi.DynamicLibrary.open(path));
      } catch (_) {
        continue;
      }
    }
    throw UnsupportedError(
        'Could not find SkiaSharp library. Please ensure libSkiaSharp.dylib is available.');
  } else {
    throw UnsupportedError('SkiaSharp is not supported on this platform');
  }
}
