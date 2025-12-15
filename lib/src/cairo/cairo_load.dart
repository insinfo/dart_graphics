import 'dart:ffi' as ffi;
import 'dart:io';
import 'generated/ffi.dart';

/// Loads the Cairo native library
/// 
/// [libraryPath] - Optional custom path to the Cairo library. If not provided,
/// the library will be searched in common system locations.
CairoBindings loadCairo({String? libraryPath}) {
  // If custom path provided, use it directly
  if (libraryPath != null) {
    return CairoBindings(ffi.DynamicLibrary.open(libraryPath));
  }
  
  if (Platform.isWindows) {
    // Try common locations for cairo DLL on Windows
    final possiblePaths = [
      'cairo-2.dll',
      'cairo.dll',
      'libcairo-2.dll',
      'C:/msys64/mingw64/bin/libcairo-2.dll',
      'C:/vcpkg/installed/x64-windows/bin/cairo.dll',
      'C:/vcpkg/installed/x64-windows/bin/cairo-2.dll',
      r'C:/Windows/System32/cairo-2.dll',
      '${Directory.current.path}/cairo-2.dll',
      '${Directory.current.path}/cairo.dll',
      '${Directory.current.path}/libcairo-2.dll',
    ];

    for (final path in possiblePaths) {
      try {
        return CairoBindings(ffi.DynamicLibrary.open(path));
      } catch (_) {
        continue;
      }
    }
    throw UnsupportedError(
        'Could not find Cairo library. Please ensure cairo.dll or libcairo-2.dll is in your PATH or current directory.');
  } else if (Platform.isLinux) {
    return CairoBindings(ffi.DynamicLibrary.open('libcairo.so.2'));
  } else if (Platform.isMacOS) {
    return CairoBindings(ffi.DynamicLibrary.open('libcairo.dylib'));
  } else {
    throw UnsupportedError('Cairo is not supported on this platform');
  }
}
