import 'dart:ffi' as ffi;
import 'dart:io';
import 'generated/freetype_ffi.dart';

/// Loads the FreeType native library
FreeTypeBindings loadFreeType() {
  if (Platform.isWindows) {
    final possiblePaths = [
      'freetype.dll',
      'libfreetype-6.dll',
      'freetype-6.dll',
      'C:/msys64/mingw64/bin/libfreetype-6.dll',
      'C:/vcpkg/installed/x64-windows/bin/freetype.dll',
      r'C:/Windows/System32/freetype.dll',
      '${Directory.current.path}/freetype.dll',
      '${Directory.current.path}/libfreetype-6.dll',
    ];

    for (final path in possiblePaths) {
      try {
        return FreeTypeBindings(ffi.DynamicLibrary.open(path));
      } catch (_) {
        continue;
      }
    }
    throw UnsupportedError(
        'Could not find FreeType library. Please ensure freetype.dll is in your PATH or current directory.');
  } else if (Platform.isLinux) {
    return FreeTypeBindings(ffi.DynamicLibrary.open('libfreetype.so.6'));
  } else if (Platform.isMacOS) {
    return FreeTypeBindings(ffi.DynamicLibrary.open('libfreetype.dylib'));
  } else {
    throw UnsupportedError('FreeType is not supported on this platform');
  }
}
