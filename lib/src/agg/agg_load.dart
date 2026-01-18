import 'dart:ffi' as ffi;
import 'dart:io';
import 'generated/ffi.dart';

/// Loads the Agg native library
/// 
/// [libraryPath] - Optional custom path to the Agg library. If not provided,
/// the library will be searched in common system locations.
AggBindings loadAgg({String? libraryPath}) {
  // If custom path provided, use it directly
  if (libraryPath != null) {
    return AggBindings(ffi.DynamicLibrary.open(libraryPath));
  }
  
  if (Platform.isWindows) {
    // Try common locations for agg_ffi DLL on Windows
    final possiblePaths = [
      'agg_ffi.dll',
      'native/libs/bin/agg_ffi.dll',
      '${Directory.current.path}/agg_ffi.dll',
      '${Directory.current.path}/native/libs/bin/agg_ffi.dll',
  
    ];

    for (final path in possiblePaths) {
      try {
        return AggBindings(ffi.DynamicLibrary.open(path));
      } catch (_) {
        continue;
      }
    }
    throw UnsupportedError(
        'Could not find Agg library (agg_ffi.dll). Please ensure it is in your PATH or current directory.');
  } else if (Platform.isLinux) {
    return AggBindings(ffi.DynamicLibrary.open('libagg_ffi.so'));
  } else if (Platform.isMacOS) {
    return AggBindings(ffi.DynamicLibrary.open('libagg_ffi.dylib'));
  } else {
    throw UnsupportedError('Agg is not supported on this platform');
  }
}
