// GENERATED CODE - DO NOT MODIFY BY HAND
// Source: SkiaSharp SkiaApi.generated.cs
// Generated: 2025-12-14T21:17:41.209498

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


  // ══════════════════════════════════════════════════════════
  // GR Functions
  // ══════════════════════════════════════════════════════════

  /// void gr_backendrendertarget_delete(gr_backendrendertarget_t rendertarget)
  void gr_backendrendertarget_delete(
    ffi.Pointer<ffi.Void> rendertarget,
  ) {
    return _gr_backendrendertarget_delete(
      rendertarget,
    );
  }

  late final _gr_backendrendertarget_deletePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('gr_backendrendertarget_delete');
  late final _gr_backendrendertarget_delete =
      _gr_backendrendertarget_deletePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// GRBackendNative gr_backendrendertarget_get_backend(gr_backendrendertarget_t rendertarget)
  int gr_backendrendertarget_get_backend(
    ffi.Pointer<ffi.Void> rendertarget,
  ) {
    return _gr_backendrendertarget_get_backend(
      rendertarget,
    );
  }

  late final _gr_backendrendertarget_get_backendPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('gr_backendrendertarget_get_backend');
  late final _gr_backendrendertarget_get_backend =
      _gr_backendrendertarget_get_backendPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// bool gr_backendrendertarget_get_gl_framebufferinfo(gr_backendrendertarget_t rendertarget, GRGlFramebufferInfo* glInfo)
  bool gr_backendrendertarget_get_gl_framebufferinfo(
    ffi.Pointer<ffi.Void> rendertarget,
    ffi.Pointer<ffi.Void> glInfo,
  ) {
    return _gr_backendrendertarget_get_gl_framebufferinfo(
      rendertarget,
      glInfo,
    );
  }

  late final _gr_backendrendertarget_get_gl_framebufferinfoPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('gr_backendrendertarget_get_gl_framebufferinfo');
  late final _gr_backendrendertarget_get_gl_framebufferinfo =
      _gr_backendrendertarget_get_gl_framebufferinfoPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// Int32 gr_backendrendertarget_get_height(gr_backendrendertarget_t rendertarget)
  int gr_backendrendertarget_get_height(
    ffi.Pointer<ffi.Void> rendertarget,
  ) {
    return _gr_backendrendertarget_get_height(
      rendertarget,
    );
  }

  late final _gr_backendrendertarget_get_heightPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('gr_backendrendertarget_get_height');
  late final _gr_backendrendertarget_get_height =
      _gr_backendrendertarget_get_heightPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 gr_backendrendertarget_get_samples(gr_backendrendertarget_t rendertarget)
  int gr_backendrendertarget_get_samples(
    ffi.Pointer<ffi.Void> rendertarget,
  ) {
    return _gr_backendrendertarget_get_samples(
      rendertarget,
    );
  }

  late final _gr_backendrendertarget_get_samplesPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('gr_backendrendertarget_get_samples');
  late final _gr_backendrendertarget_get_samples =
      _gr_backendrendertarget_get_samplesPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 gr_backendrendertarget_get_stencils(gr_backendrendertarget_t rendertarget)
  int gr_backendrendertarget_get_stencils(
    ffi.Pointer<ffi.Void> rendertarget,
  ) {
    return _gr_backendrendertarget_get_stencils(
      rendertarget,
    );
  }

  late final _gr_backendrendertarget_get_stencilsPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('gr_backendrendertarget_get_stencils');
  late final _gr_backendrendertarget_get_stencils =
      _gr_backendrendertarget_get_stencilsPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 gr_backendrendertarget_get_width(gr_backendrendertarget_t rendertarget)
  int gr_backendrendertarget_get_width(
    ffi.Pointer<ffi.Void> rendertarget,
  ) {
    return _gr_backendrendertarget_get_width(
      rendertarget,
    );
  }

  late final _gr_backendrendertarget_get_widthPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('gr_backendrendertarget_get_width');
  late final _gr_backendrendertarget_get_width =
      _gr_backendrendertarget_get_widthPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// bool gr_backendrendertarget_is_valid(gr_backendrendertarget_t rendertarget)
  bool gr_backendrendertarget_is_valid(
    ffi.Pointer<ffi.Void> rendertarget,
  ) {
    return _gr_backendrendertarget_is_valid(
      rendertarget,
    );
  }

  late final _gr_backendrendertarget_is_validPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('gr_backendrendertarget_is_valid');
  late final _gr_backendrendertarget_is_valid =
      _gr_backendrendertarget_is_validPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// gr_backendrendertarget_t gr_backendrendertarget_new_direct3d(Int32 width, Int32 height, GRD3DTextureResourceInfoNative* d3dInfo)
  ffi.Pointer<ffi.Void> gr_backendrendertarget_new_direct3d(
    int width,
    int height,
    ffi.Pointer<ffi.Void> d3dInfo,
  ) {
    return _gr_backendrendertarget_new_direct3d(
      width,
      height,
      d3dInfo,
    );
  }

  late final _gr_backendrendertarget_new_direct3dPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>)>>('gr_backendrendertarget_new_direct3d');
  late final _gr_backendrendertarget_new_direct3d =
      _gr_backendrendertarget_new_direct3dPtr.asFunction<ffi.Pointer<ffi.Void> Function(int, int, ffi.Pointer<ffi.Void>)>();

  /// gr_backendrendertarget_t gr_backendrendertarget_new_gl(Int32 width, Int32 height, Int32 samples, Int32 stencils, GRGlFramebufferInfo* glInfo)
  ffi.Pointer<ffi.Void> gr_backendrendertarget_new_gl(
    int width,
    int height,
    int samples,
    int stencils,
    ffi.Pointer<ffi.Void> glInfo,
  ) {
    return _gr_backendrendertarget_new_gl(
      width,
      height,
      samples,
      stencils,
      glInfo,
    );
  }

  late final _gr_backendrendertarget_new_glPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Int32, ffi.Int32, ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>)>>('gr_backendrendertarget_new_gl');
  late final _gr_backendrendertarget_new_gl =
      _gr_backendrendertarget_new_glPtr.asFunction<ffi.Pointer<ffi.Void> Function(int, int, int, int, ffi.Pointer<ffi.Void>)>();

  /// gr_backendrendertarget_t gr_backendrendertarget_new_metal(Int32 width, Int32 height, GRMtlTextureInfoNative* mtlInfo)
  ffi.Pointer<ffi.Void> gr_backendrendertarget_new_metal(
    int width,
    int height,
    ffi.Pointer<ffi.Void> mtlInfo,
  ) {
    return _gr_backendrendertarget_new_metal(
      width,
      height,
      mtlInfo,
    );
  }

  late final _gr_backendrendertarget_new_metalPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>)>>('gr_backendrendertarget_new_metal');
  late final _gr_backendrendertarget_new_metal =
      _gr_backendrendertarget_new_metalPtr.asFunction<ffi.Pointer<ffi.Void> Function(int, int, ffi.Pointer<ffi.Void>)>();

  /// gr_backendrendertarget_t gr_backendrendertarget_new_vulkan(Int32 width, Int32 height, GRVkImageInfo* vkImageInfo)
  ffi.Pointer<ffi.Void> gr_backendrendertarget_new_vulkan(
    int width,
    int height,
    ffi.Pointer<ffi.Void> vkImageInfo,
  ) {
    return _gr_backendrendertarget_new_vulkan(
      width,
      height,
      vkImageInfo,
    );
  }

  late final _gr_backendrendertarget_new_vulkanPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>)>>('gr_backendrendertarget_new_vulkan');
  late final _gr_backendrendertarget_new_vulkan =
      _gr_backendrendertarget_new_vulkanPtr.asFunction<ffi.Pointer<ffi.Void> Function(int, int, ffi.Pointer<ffi.Void>)>();

  /// void gr_backendtexture_delete(gr_backendtexture_t texture)
  void gr_backendtexture_delete(
    ffi.Pointer<ffi.Void> texture,
  ) {
    return _gr_backendtexture_delete(
      texture,
    );
  }

  late final _gr_backendtexture_deletePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('gr_backendtexture_delete');
  late final _gr_backendtexture_delete =
      _gr_backendtexture_deletePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// GRBackendNative gr_backendtexture_get_backend(gr_backendtexture_t texture)
  int gr_backendtexture_get_backend(
    ffi.Pointer<ffi.Void> texture,
  ) {
    return _gr_backendtexture_get_backend(
      texture,
    );
  }

  late final _gr_backendtexture_get_backendPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('gr_backendtexture_get_backend');
  late final _gr_backendtexture_get_backend =
      _gr_backendtexture_get_backendPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// bool gr_backendtexture_get_gl_textureinfo(gr_backendtexture_t texture, GRGlTextureInfo* glInfo)
  bool gr_backendtexture_get_gl_textureinfo(
    ffi.Pointer<ffi.Void> texture,
    ffi.Pointer<ffi.Void> glInfo,
  ) {
    return _gr_backendtexture_get_gl_textureinfo(
      texture,
      glInfo,
    );
  }

  late final _gr_backendtexture_get_gl_textureinfoPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('gr_backendtexture_get_gl_textureinfo');
  late final _gr_backendtexture_get_gl_textureinfo =
      _gr_backendtexture_get_gl_textureinfoPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// Int32 gr_backendtexture_get_height(gr_backendtexture_t texture)
  int gr_backendtexture_get_height(
    ffi.Pointer<ffi.Void> texture,
  ) {
    return _gr_backendtexture_get_height(
      texture,
    );
  }

  late final _gr_backendtexture_get_heightPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('gr_backendtexture_get_height');
  late final _gr_backendtexture_get_height =
      _gr_backendtexture_get_heightPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 gr_backendtexture_get_width(gr_backendtexture_t texture)
  int gr_backendtexture_get_width(
    ffi.Pointer<ffi.Void> texture,
  ) {
    return _gr_backendtexture_get_width(
      texture,
    );
  }

  late final _gr_backendtexture_get_widthPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('gr_backendtexture_get_width');
  late final _gr_backendtexture_get_width =
      _gr_backendtexture_get_widthPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// bool gr_backendtexture_has_mipmaps(gr_backendtexture_t texture)
  bool gr_backendtexture_has_mipmaps(
    ffi.Pointer<ffi.Void> texture,
  ) {
    return _gr_backendtexture_has_mipmaps(
      texture,
    );
  }

  late final _gr_backendtexture_has_mipmapsPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('gr_backendtexture_has_mipmaps');
  late final _gr_backendtexture_has_mipmaps =
      _gr_backendtexture_has_mipmapsPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// bool gr_backendtexture_is_valid(gr_backendtexture_t texture)
  bool gr_backendtexture_is_valid(
    ffi.Pointer<ffi.Void> texture,
  ) {
    return _gr_backendtexture_is_valid(
      texture,
    );
  }

  late final _gr_backendtexture_is_validPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('gr_backendtexture_is_valid');
  late final _gr_backendtexture_is_valid =
      _gr_backendtexture_is_validPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// gr_backendtexture_t gr_backendtexture_new_direct3d(Int32 width, Int32 height, GRD3DTextureResourceInfoNative* d3dInfo)
  ffi.Pointer<ffi.Void> gr_backendtexture_new_direct3d(
    int width,
    int height,
    ffi.Pointer<ffi.Void> d3dInfo,
  ) {
    return _gr_backendtexture_new_direct3d(
      width,
      height,
      d3dInfo,
    );
  }

  late final _gr_backendtexture_new_direct3dPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>)>>('gr_backendtexture_new_direct3d');
  late final _gr_backendtexture_new_direct3d =
      _gr_backendtexture_new_direct3dPtr.asFunction<ffi.Pointer<ffi.Void> Function(int, int, ffi.Pointer<ffi.Void>)>();

  /// gr_backendtexture_t gr_backendtexture_new_gl(Int32 width, Int32 height, bool mipmapped, GRGlTextureInfo* glInfo)
  ffi.Pointer<ffi.Void> gr_backendtexture_new_gl(
    int width,
    int height,
    bool mipmapped,
    ffi.Pointer<ffi.Void> glInfo,
  ) {
    return _gr_backendtexture_new_gl(
      width,
      height,
      mipmapped,
      glInfo,
    );
  }

  late final _gr_backendtexture_new_glPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Int32, ffi.Int32, ffi.Bool, ffi.Pointer<ffi.Void>)>>('gr_backendtexture_new_gl');
  late final _gr_backendtexture_new_gl =
      _gr_backendtexture_new_glPtr.asFunction<ffi.Pointer<ffi.Void> Function(int, int, bool, ffi.Pointer<ffi.Void>)>();

  /// gr_backendtexture_t gr_backendtexture_new_metal(Int32 width, Int32 height, bool mipmapped, GRMtlTextureInfoNative* mtlInfo)
  ffi.Pointer<ffi.Void> gr_backendtexture_new_metal(
    int width,
    int height,
    bool mipmapped,
    ffi.Pointer<ffi.Void> mtlInfo,
  ) {
    return _gr_backendtexture_new_metal(
      width,
      height,
      mipmapped,
      mtlInfo,
    );
  }

  late final _gr_backendtexture_new_metalPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Int32, ffi.Int32, ffi.Bool, ffi.Pointer<ffi.Void>)>>('gr_backendtexture_new_metal');
  late final _gr_backendtexture_new_metal =
      _gr_backendtexture_new_metalPtr.asFunction<ffi.Pointer<ffi.Void> Function(int, int, bool, ffi.Pointer<ffi.Void>)>();

  /// gr_backendtexture_t gr_backendtexture_new_vulkan(Int32 width, Int32 height, GRVkImageInfo* vkInfo)
  ffi.Pointer<ffi.Void> gr_backendtexture_new_vulkan(
    int width,
    int height,
    ffi.Pointer<ffi.Void> vkInfo,
  ) {
    return _gr_backendtexture_new_vulkan(
      width,
      height,
      vkInfo,
    );
  }

  late final _gr_backendtexture_new_vulkanPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>)>>('gr_backendtexture_new_vulkan');
  late final _gr_backendtexture_new_vulkan =
      _gr_backendtexture_new_vulkanPtr.asFunction<ffi.Pointer<ffi.Void> Function(int, int, ffi.Pointer<ffi.Void>)>();

  /// void gr_direct_context_abandon_context(gr_direct_context_t context)
  void gr_direct_context_abandon_context(
    ffi.Pointer<ffi.Void> context,
  ) {
    return _gr_direct_context_abandon_context(
      context,
    );
  }

  late final _gr_direct_context_abandon_contextPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('gr_direct_context_abandon_context');
  late final _gr_direct_context_abandon_context =
      _gr_direct_context_abandon_contextPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void gr_direct_context_dump_memory_statistics(gr_direct_context_t context, sk_tracememorydump_t dump)
  void gr_direct_context_dump_memory_statistics(
    ffi.Pointer<ffi.Void> context,
    ffi.Pointer<ffi.Void> dump,
  ) {
    return _gr_direct_context_dump_memory_statistics(
      context,
      dump,
    );
  }

  late final _gr_direct_context_dump_memory_statisticsPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('gr_direct_context_dump_memory_statistics');
  late final _gr_direct_context_dump_memory_statistics =
      _gr_direct_context_dump_memory_statisticsPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void gr_direct_context_flush(gr_direct_context_t context)
  void gr_direct_context_flush(
    ffi.Pointer<ffi.Void> context,
  ) {
    return _gr_direct_context_flush(
      context,
    );
  }

  late final _gr_direct_context_flushPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('gr_direct_context_flush');
  late final _gr_direct_context_flush =
      _gr_direct_context_flushPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void gr_direct_context_flush_and_submit(gr_direct_context_t context, bool syncCpu)
  void gr_direct_context_flush_and_submit(
    ffi.Pointer<ffi.Void> context,
    bool syncCpu,
  ) {
    return _gr_direct_context_flush_and_submit(
      context,
      syncCpu,
    );
  }

  late final _gr_direct_context_flush_and_submitPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Bool)>>('gr_direct_context_flush_and_submit');
  late final _gr_direct_context_flush_and_submit =
      _gr_direct_context_flush_and_submitPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, bool)>();

  /// void gr_direct_context_flush_image(gr_direct_context_t context, sk_image_t image)
  void gr_direct_context_flush_image(
    ffi.Pointer<ffi.Void> context,
    ffi.Pointer<ffi.Void> image,
  ) {
    return _gr_direct_context_flush_image(
      context,
      image,
    );
  }

  late final _gr_direct_context_flush_imagePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('gr_direct_context_flush_image');
  late final _gr_direct_context_flush_image =
      _gr_direct_context_flush_imagePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void gr_direct_context_flush_surface(gr_direct_context_t context, sk_surface_t surface)
  void gr_direct_context_flush_surface(
    ffi.Pointer<ffi.Void> context,
    ffi.Pointer<ffi.Void> surface,
  ) {
    return _gr_direct_context_flush_surface(
      context,
      surface,
    );
  }

  late final _gr_direct_context_flush_surfacePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('gr_direct_context_flush_surface');
  late final _gr_direct_context_flush_surface =
      _gr_direct_context_flush_surfacePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void gr_direct_context_free_gpu_resources(gr_direct_context_t context)
  void gr_direct_context_free_gpu_resources(
    ffi.Pointer<ffi.Void> context,
  ) {
    return _gr_direct_context_free_gpu_resources(
      context,
    );
  }

  late final _gr_direct_context_free_gpu_resourcesPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('gr_direct_context_free_gpu_resources');
  late final _gr_direct_context_free_gpu_resources =
      _gr_direct_context_free_gpu_resourcesPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// IntPtr gr_direct_context_get_resource_cache_limit(gr_direct_context_t context)
  ffi.Pointer<ffi.Void> gr_direct_context_get_resource_cache_limit(
    ffi.Pointer<ffi.Void> context,
  ) {
    return _gr_direct_context_get_resource_cache_limit(
      context,
    );
  }

  late final _gr_direct_context_get_resource_cache_limitPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('gr_direct_context_get_resource_cache_limit');
  late final _gr_direct_context_get_resource_cache_limit =
      _gr_direct_context_get_resource_cache_limitPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void gr_direct_context_get_resource_cache_usage(gr_direct_context_t context, Int32* maxResources, IntPtr* maxResourceBytes)
  void gr_direct_context_get_resource_cache_usage(
    ffi.Pointer<ffi.Void> context,
    ffi.Pointer<ffi.Int32> maxResources,
    ffi.Pointer<ffi.Void> maxResourceBytes,
  ) {
    return _gr_direct_context_get_resource_cache_usage(
      context,
      maxResources,
      maxResourceBytes,
    );
  }

  late final _gr_direct_context_get_resource_cache_usagePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Int32>, ffi.Pointer<ffi.Void>)>>('gr_direct_context_get_resource_cache_usage');
  late final _gr_direct_context_get_resource_cache_usage =
      _gr_direct_context_get_resource_cache_usagePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Int32>, ffi.Pointer<ffi.Void>)>();

  /// bool gr_direct_context_is_abandoned(gr_direct_context_t context)
  bool gr_direct_context_is_abandoned(
    ffi.Pointer<ffi.Void> context,
  ) {
    return _gr_direct_context_is_abandoned(
      context,
    );
  }

  late final _gr_direct_context_is_abandonedPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('gr_direct_context_is_abandoned');
  late final _gr_direct_context_is_abandoned =
      _gr_direct_context_is_abandonedPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// gr_direct_context_t gr_direct_context_make_direct3d(GRD3DBackendContextNative d3dBackendContext)
  ffi.Pointer<ffi.Void> gr_direct_context_make_direct3d(
    ffi.Pointer<ffi.Void> d3dBackendContext,
  ) {
    return _gr_direct_context_make_direct3d(
      d3dBackendContext,
    );
  }

  late final _gr_direct_context_make_direct3dPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('gr_direct_context_make_direct3d');
  late final _gr_direct_context_make_direct3d =
      _gr_direct_context_make_direct3dPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// gr_direct_context_t gr_direct_context_make_direct3d_with_options(GRD3DBackendContextNative d3dBackendContext, GRContextOptionsNative* options)
  ffi.Pointer<ffi.Void> gr_direct_context_make_direct3d_with_options(
    ffi.Pointer<ffi.Void> d3dBackendContext,
    ffi.Pointer<ffi.Void> options,
  ) {
    return _gr_direct_context_make_direct3d_with_options(
      d3dBackendContext,
      options,
    );
  }

  late final _gr_direct_context_make_direct3d_with_optionsPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('gr_direct_context_make_direct3d_with_options');
  late final _gr_direct_context_make_direct3d_with_options =
      _gr_direct_context_make_direct3d_with_optionsPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// gr_direct_context_t gr_direct_context_make_gl(gr_glinterface_t glInterface)
  ffi.Pointer<ffi.Void> gr_direct_context_make_gl(
    ffi.Pointer<ffi.Void> glInterface,
  ) {
    return _gr_direct_context_make_gl(
      glInterface,
    );
  }

  late final _gr_direct_context_make_glPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('gr_direct_context_make_gl');
  late final _gr_direct_context_make_gl =
      _gr_direct_context_make_glPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// gr_direct_context_t gr_direct_context_make_gl_with_options(gr_glinterface_t glInterface, GRContextOptionsNative* options)
  ffi.Pointer<ffi.Void> gr_direct_context_make_gl_with_options(
    ffi.Pointer<ffi.Void> glInterface,
    ffi.Pointer<ffi.Void> options,
  ) {
    return _gr_direct_context_make_gl_with_options(
      glInterface,
      options,
    );
  }

  late final _gr_direct_context_make_gl_with_optionsPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('gr_direct_context_make_gl_with_options');
  late final _gr_direct_context_make_gl_with_options =
      _gr_direct_context_make_gl_with_optionsPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// gr_direct_context_t gr_direct_context_make_metal(void* device, void* queue)
  ffi.Pointer<ffi.Void> gr_direct_context_make_metal(
    ffi.Pointer<ffi.Void> device,
    ffi.Pointer<ffi.Void> queue,
  ) {
    return _gr_direct_context_make_metal(
      device,
      queue,
    );
  }

  late final _gr_direct_context_make_metalPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('gr_direct_context_make_metal');
  late final _gr_direct_context_make_metal =
      _gr_direct_context_make_metalPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// gr_direct_context_t gr_direct_context_make_metal_with_options(void* device, void* queue, GRContextOptionsNative* options)
  ffi.Pointer<ffi.Void> gr_direct_context_make_metal_with_options(
    ffi.Pointer<ffi.Void> device,
    ffi.Pointer<ffi.Void> queue,
    ffi.Pointer<ffi.Void> options,
  ) {
    return _gr_direct_context_make_metal_with_options(
      device,
      queue,
      options,
    );
  }

  late final _gr_direct_context_make_metal_with_optionsPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('gr_direct_context_make_metal_with_options');
  late final _gr_direct_context_make_metal_with_options =
      _gr_direct_context_make_metal_with_optionsPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// gr_direct_context_t gr_direct_context_make_vulkan(GRVkBackendContextNative vkBackendContext)
  ffi.Pointer<ffi.Void> gr_direct_context_make_vulkan(
    ffi.Pointer<ffi.Void> vkBackendContext,
  ) {
    return _gr_direct_context_make_vulkan(
      vkBackendContext,
    );
  }

  late final _gr_direct_context_make_vulkanPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('gr_direct_context_make_vulkan');
  late final _gr_direct_context_make_vulkan =
      _gr_direct_context_make_vulkanPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// gr_direct_context_t gr_direct_context_make_vulkan_with_options(GRVkBackendContextNative vkBackendContext, GRContextOptionsNative* options)
  ffi.Pointer<ffi.Void> gr_direct_context_make_vulkan_with_options(
    ffi.Pointer<ffi.Void> vkBackendContext,
    ffi.Pointer<ffi.Void> options,
  ) {
    return _gr_direct_context_make_vulkan_with_options(
      vkBackendContext,
      options,
    );
  }

  late final _gr_direct_context_make_vulkan_with_optionsPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('gr_direct_context_make_vulkan_with_options');
  late final _gr_direct_context_make_vulkan_with_options =
      _gr_direct_context_make_vulkan_with_optionsPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void gr_direct_context_perform_deferred_cleanup(gr_direct_context_t context, Int64 ms)
  void gr_direct_context_perform_deferred_cleanup(
    ffi.Pointer<ffi.Void> context,
    int ms,
  ) {
    return _gr_direct_context_perform_deferred_cleanup(
      context,
      ms,
    );
  }

  late final _gr_direct_context_perform_deferred_cleanupPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Int64)>>('gr_direct_context_perform_deferred_cleanup');
  late final _gr_direct_context_perform_deferred_cleanup =
      _gr_direct_context_perform_deferred_cleanupPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int)>();

  /// void gr_direct_context_purge_unlocked_resources(gr_direct_context_t context, bool scratchResourcesOnly)
  void gr_direct_context_purge_unlocked_resources(
    ffi.Pointer<ffi.Void> context,
    bool scratchResourcesOnly,
  ) {
    return _gr_direct_context_purge_unlocked_resources(
      context,
      scratchResourcesOnly,
    );
  }

  late final _gr_direct_context_purge_unlocked_resourcesPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Bool)>>('gr_direct_context_purge_unlocked_resources');
  late final _gr_direct_context_purge_unlocked_resources =
      _gr_direct_context_purge_unlocked_resourcesPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, bool)>();

  /// void gr_direct_context_purge_unlocked_resources_bytes(gr_direct_context_t context, IntPtr bytesToPurge, bool preferScratchResources)
  void gr_direct_context_purge_unlocked_resources_bytes(
    ffi.Pointer<ffi.Void> context,
    ffi.Pointer<ffi.Void> bytesToPurge,
    bool preferScratchResources,
  ) {
    return _gr_direct_context_purge_unlocked_resources_bytes(
      context,
      bytesToPurge,
      preferScratchResources,
    );
  }

  late final _gr_direct_context_purge_unlocked_resources_bytesPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Bool)>>('gr_direct_context_purge_unlocked_resources_bytes');
  late final _gr_direct_context_purge_unlocked_resources_bytes =
      _gr_direct_context_purge_unlocked_resources_bytesPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, bool)>();

  /// void gr_direct_context_release_resources_and_abandon_context(gr_direct_context_t context)
  void gr_direct_context_release_resources_and_abandon_context(
    ffi.Pointer<ffi.Void> context,
  ) {
    return _gr_direct_context_release_resources_and_abandon_context(
      context,
    );
  }

  late final _gr_direct_context_release_resources_and_abandon_contextPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('gr_direct_context_release_resources_and_abandon_context');
  late final _gr_direct_context_release_resources_and_abandon_context =
      _gr_direct_context_release_resources_and_abandon_contextPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void gr_direct_context_reset_context(gr_direct_context_t context, UInt32 state)
  void gr_direct_context_reset_context(
    ffi.Pointer<ffi.Void> context,
    int state,
  ) {
    return _gr_direct_context_reset_context(
      context,
      state,
    );
  }

  late final _gr_direct_context_reset_contextPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Uint32)>>('gr_direct_context_reset_context');
  late final _gr_direct_context_reset_context =
      _gr_direct_context_reset_contextPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int)>();

  /// void gr_direct_context_set_resource_cache_limit(gr_direct_context_t context, IntPtr maxResourceBytes)
  void gr_direct_context_set_resource_cache_limit(
    ffi.Pointer<ffi.Void> context,
    ffi.Pointer<ffi.Void> maxResourceBytes,
  ) {
    return _gr_direct_context_set_resource_cache_limit(
      context,
      maxResourceBytes,
    );
  }

  late final _gr_direct_context_set_resource_cache_limitPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('gr_direct_context_set_resource_cache_limit');
  late final _gr_direct_context_set_resource_cache_limit =
      _gr_direct_context_set_resource_cache_limitPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool gr_direct_context_submit(gr_direct_context_t context, bool syncCpu)
  bool gr_direct_context_submit(
    ffi.Pointer<ffi.Void> context,
    bool syncCpu,
  ) {
    return _gr_direct_context_submit(
      context,
      syncCpu,
    );
  }

  late final _gr_direct_context_submitPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Bool)>>('gr_direct_context_submit');
  late final _gr_direct_context_submit =
      _gr_direct_context_submitPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, bool)>();

  /// gr_glinterface_t gr_glinterface_assemble_gl_interface(void* ctx, void* get)
  ffi.Pointer<ffi.Void> gr_glinterface_assemble_gl_interface(
    ffi.Pointer<ffi.Void> ctx,
    ffi.Pointer<ffi.Void> get,
  ) {
    return _gr_glinterface_assemble_gl_interface(
      ctx,
      get,
    );
  }

  late final _gr_glinterface_assemble_gl_interfacePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('gr_glinterface_assemble_gl_interface');
  late final _gr_glinterface_assemble_gl_interface =
      _gr_glinterface_assemble_gl_interfacePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// gr_glinterface_t gr_glinterface_assemble_gles_interface(void* ctx, void* get)
  ffi.Pointer<ffi.Void> gr_glinterface_assemble_gles_interface(
    ffi.Pointer<ffi.Void> ctx,
    ffi.Pointer<ffi.Void> get,
  ) {
    return _gr_glinterface_assemble_gles_interface(
      ctx,
      get,
    );
  }

  late final _gr_glinterface_assemble_gles_interfacePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('gr_glinterface_assemble_gles_interface');
  late final _gr_glinterface_assemble_gles_interface =
      _gr_glinterface_assemble_gles_interfacePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// gr_glinterface_t gr_glinterface_assemble_interface(void* ctx, void* get)
  ffi.Pointer<ffi.Void> gr_glinterface_assemble_interface(
    ffi.Pointer<ffi.Void> ctx,
    ffi.Pointer<ffi.Void> get,
  ) {
    return _gr_glinterface_assemble_interface(
      ctx,
      get,
    );
  }

  late final _gr_glinterface_assemble_interfacePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('gr_glinterface_assemble_interface');
  late final _gr_glinterface_assemble_interface =
      _gr_glinterface_assemble_interfacePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// gr_glinterface_t gr_glinterface_assemble_webgl_interface(void* ctx, void* get)
  ffi.Pointer<ffi.Void> gr_glinterface_assemble_webgl_interface(
    ffi.Pointer<ffi.Void> ctx,
    ffi.Pointer<ffi.Void> get,
  ) {
    return _gr_glinterface_assemble_webgl_interface(
      ctx,
      get,
    );
  }

  late final _gr_glinterface_assemble_webgl_interfacePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('gr_glinterface_assemble_webgl_interface');
  late final _gr_glinterface_assemble_webgl_interface =
      _gr_glinterface_assemble_webgl_interfacePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// gr_glinterface_t gr_glinterface_create_native_interface()
  ffi.Pointer<ffi.Void> gr_glinterface_create_native_interface() {
    return _gr_glinterface_create_native_interface();
  }

  late final _gr_glinterface_create_native_interfacePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('gr_glinterface_create_native_interface');
  late final _gr_glinterface_create_native_interface =
      _gr_glinterface_create_native_interfacePtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// bool gr_glinterface_has_extension(gr_glinterface_t glInterface, String extension)
  bool gr_glinterface_has_extension(
    ffi.Pointer<ffi.Void> glInterface,
    ffi.Pointer<ffi.Void> extension,
  ) {
    return _gr_glinterface_has_extension(
      glInterface,
      extension,
    );
  }

  late final _gr_glinterface_has_extensionPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('gr_glinterface_has_extension');
  late final _gr_glinterface_has_extension =
      _gr_glinterface_has_extensionPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void gr_glinterface_unref(gr_glinterface_t glInterface)
  void gr_glinterface_unref(
    ffi.Pointer<ffi.Void> glInterface,
  ) {
    return _gr_glinterface_unref(
      glInterface,
    );
  }

  late final _gr_glinterface_unrefPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('gr_glinterface_unref');
  late final _gr_glinterface_unref =
      _gr_glinterface_unrefPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// bool gr_glinterface_validate(gr_glinterface_t glInterface)
  bool gr_glinterface_validate(
    ffi.Pointer<ffi.Void> glInterface,
  ) {
    return _gr_glinterface_validate(
      glInterface,
    );
  }

  late final _gr_glinterface_validatePtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('gr_glinterface_validate');
  late final _gr_glinterface_validate =
      _gr_glinterface_validatePtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// GRBackendNative gr_recording_context_get_backend(gr_recording_context_t context)
  int gr_recording_context_get_backend(
    ffi.Pointer<ffi.Void> context,
  ) {
    return _gr_recording_context_get_backend(
      context,
    );
  }

  late final _gr_recording_context_get_backendPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('gr_recording_context_get_backend');
  late final _gr_recording_context_get_backend =
      _gr_recording_context_get_backendPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// gr_direct_context_t gr_recording_context_get_direct_context(gr_recording_context_t context)
  ffi.Pointer<ffi.Void> gr_recording_context_get_direct_context(
    ffi.Pointer<ffi.Void> context,
  ) {
    return _gr_recording_context_get_direct_context(
      context,
    );
  }

  late final _gr_recording_context_get_direct_contextPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('gr_recording_context_get_direct_context');
  late final _gr_recording_context_get_direct_context =
      _gr_recording_context_get_direct_contextPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 gr_recording_context_get_max_surface_sample_count_for_color_type(gr_recording_context_t context, SKColorTypeNative colorType)
  int gr_recording_context_get_max_surface_sample_count_for_color_type(
    ffi.Pointer<ffi.Void> context,
    int colorType,
  ) {
    return _gr_recording_context_get_max_surface_sample_count_for_color_type(
      context,
      colorType,
    );
  }

  late final _gr_recording_context_get_max_surface_sample_count_for_color_typePtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>, ffi.Int32)>>('gr_recording_context_get_max_surface_sample_count_for_color_type');
  late final _gr_recording_context_get_max_surface_sample_count_for_color_type =
      _gr_recording_context_get_max_surface_sample_count_for_color_typePtr.asFunction<int Function(ffi.Pointer<ffi.Void>, int)>();

  /// bool gr_recording_context_is_abandoned(gr_recording_context_t context)
  bool gr_recording_context_is_abandoned(
    ffi.Pointer<ffi.Void> context,
  ) {
    return _gr_recording_context_is_abandoned(
      context,
    );
  }

  late final _gr_recording_context_is_abandonedPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('gr_recording_context_is_abandoned');
  late final _gr_recording_context_is_abandoned =
      _gr_recording_context_is_abandonedPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 gr_recording_context_max_render_target_size(gr_recording_context_t context)
  int gr_recording_context_max_render_target_size(
    ffi.Pointer<ffi.Void> context,
  ) {
    return _gr_recording_context_max_render_target_size(
      context,
    );
  }

  late final _gr_recording_context_max_render_target_sizePtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('gr_recording_context_max_render_target_size');
  late final _gr_recording_context_max_render_target_size =
      _gr_recording_context_max_render_target_sizePtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 gr_recording_context_max_texture_size(gr_recording_context_t context)
  int gr_recording_context_max_texture_size(
    ffi.Pointer<ffi.Void> context,
  ) {
    return _gr_recording_context_max_texture_size(
      context,
    );
  }

  late final _gr_recording_context_max_texture_sizePtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('gr_recording_context_max_texture_size');
  late final _gr_recording_context_max_texture_size =
      _gr_recording_context_max_texture_sizePtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// void gr_recording_context_unref(gr_recording_context_t context)
  void gr_recording_context_unref(
    ffi.Pointer<ffi.Void> context,
  ) {
    return _gr_recording_context_unref(
      context,
    );
  }

  late final _gr_recording_context_unrefPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('gr_recording_context_unref');
  late final _gr_recording_context_unref =
      _gr_recording_context_unrefPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void gr_vk_extensions_delete(gr_vk_extensions_t extensions)
  void gr_vk_extensions_delete(
    ffi.Pointer<ffi.Void> extensions,
  ) {
    return _gr_vk_extensions_delete(
      extensions,
    );
  }

  late final _gr_vk_extensions_deletePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('gr_vk_extensions_delete');
  late final _gr_vk_extensions_delete =
      _gr_vk_extensions_deletePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// bool gr_vk_extensions_has_extension(gr_vk_extensions_t extensions, String ext, UInt32 minVersion)
  bool gr_vk_extensions_has_extension(
    ffi.Pointer<ffi.Void> extensions,
    ffi.Pointer<ffi.Void> ext,
    int minVersion,
  ) {
    return _gr_vk_extensions_has_extension(
      extensions,
      ext,
      minVersion,
    );
  }

  late final _gr_vk_extensions_has_extensionPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Uint32)>>('gr_vk_extensions_has_extension');
  late final _gr_vk_extensions_has_extension =
      _gr_vk_extensions_has_extensionPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int)>();

  /// void gr_vk_extensions_init(gr_vk_extensions_t extensions, void* getProc, void* userData, vk_instance_t instance, vk_physical_device_t physDev, UInt32 instanceExtensionCount, String[] instanceExtensions, UInt32 deviceExtensionCount, String[] deviceExtensions)
  void gr_vk_extensions_init(
    ffi.Pointer<ffi.Void> extensions,
    ffi.Pointer<ffi.Void> getProc,
    ffi.Pointer<ffi.Void> userData,
    ffi.Pointer<ffi.Void> instance,
    ffi.Pointer<ffi.Void> physDev,
    int instanceExtensionCount,
    ffi.Pointer<ffi.Void> instanceExtensions,
    int deviceExtensionCount,
    ffi.Pointer<ffi.Void> deviceExtensions,
  ) {
    return _gr_vk_extensions_init(
      extensions,
      getProc,
      userData,
      instance,
      physDev,
      instanceExtensionCount,
      instanceExtensions,
      deviceExtensionCount,
      deviceExtensions,
    );
  }

  late final _gr_vk_extensions_initPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Uint32, ffi.Pointer<ffi.Void>, ffi.Uint32, ffi.Pointer<ffi.Void>)>>('gr_vk_extensions_init');
  late final _gr_vk_extensions_init =
      _gr_vk_extensions_initPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>)>();

  /// gr_vk_extensions_t gr_vk_extensions_new()
  ffi.Pointer<ffi.Void> gr_vk_extensions_new() {
    return _gr_vk_extensions_new();
  }

  late final _gr_vk_extensions_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('gr_vk_extensions_new');
  late final _gr_vk_extensions_new =
      _gr_vk_extensions_newPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  // ══════════════════════════════════════════════════════════
  // SK Functions
  // ══════════════════════════════════════════════════════════

  /// void sk_bitmap_destructor(sk_bitmap_t cbitmap)
  void sk_bitmap_destructor(
    ffi.Pointer<ffi.Void> cbitmap,
  ) {
    return _sk_bitmap_destructor(
      cbitmap,
    );
  }

  late final _sk_bitmap_destructorPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_bitmap_destructor');
  late final _sk_bitmap_destructor =
      _sk_bitmap_destructorPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_bitmap_erase(sk_bitmap_t cbitmap, UInt32 color)
  void sk_bitmap_erase(
    ffi.Pointer<ffi.Void> cbitmap,
    int color,
  ) {
    return _sk_bitmap_erase(
      cbitmap,
      color,
    );
  }

  late final _sk_bitmap_erasePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Uint32)>>('sk_bitmap_erase');
  late final _sk_bitmap_erase =
      _sk_bitmap_erasePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int)>();

  /// void sk_bitmap_erase_rect(sk_bitmap_t cbitmap, UInt32 color, SKRectI* rect)
  void sk_bitmap_erase_rect(
    ffi.Pointer<ffi.Void> cbitmap,
    int color,
    ffi.Pointer<ffi.Void> rect,
  ) {
    return _sk_bitmap_erase_rect(
      cbitmap,
      color,
      rect,
    );
  }

  late final _sk_bitmap_erase_rectPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Uint32, ffi.Pointer<ffi.Void>)>>('sk_bitmap_erase_rect');
  late final _sk_bitmap_erase_rect =
      _sk_bitmap_erase_rectPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>)>();

  /// bool sk_bitmap_extract_alpha(sk_bitmap_t cbitmap, sk_bitmap_t dst, sk_paint_t paint, SKPointI* offset)
  bool sk_bitmap_extract_alpha(
    ffi.Pointer<ffi.Void> cbitmap,
    ffi.Pointer<ffi.Void> dst,
    ffi.Pointer<ffi.Void> paint,
    ffi.Pointer<ffi.Void> offset,
  ) {
    return _sk_bitmap_extract_alpha(
      cbitmap,
      dst,
      paint,
      offset,
    );
  }

  late final _sk_bitmap_extract_alphaPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_bitmap_extract_alpha');
  late final _sk_bitmap_extract_alpha =
      _sk_bitmap_extract_alphaPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_bitmap_extract_subset(sk_bitmap_t cbitmap, sk_bitmap_t dst, SKRectI* subset)
  bool sk_bitmap_extract_subset(
    ffi.Pointer<ffi.Void> cbitmap,
    ffi.Pointer<ffi.Void> dst,
    ffi.Pointer<ffi.Void> subset,
  ) {
    return _sk_bitmap_extract_subset(
      cbitmap,
      dst,
      subset,
    );
  }

  late final _sk_bitmap_extract_subsetPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_bitmap_extract_subset');
  late final _sk_bitmap_extract_subset =
      _sk_bitmap_extract_subsetPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void* sk_bitmap_get_addr(sk_bitmap_t cbitmap, Int32 x, Int32 y)
  ffi.Pointer<ffi.Void> sk_bitmap_get_addr(
    ffi.Pointer<ffi.Void> cbitmap,
    int x,
    int y,
  ) {
    return _sk_bitmap_get_addr(
      cbitmap,
      x,
      y,
    );
  }

  late final _sk_bitmap_get_addrPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32)>>('sk_bitmap_get_addr');
  late final _sk_bitmap_get_addr =
      _sk_bitmap_get_addrPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, int, int)>();

  /// UInt16* sk_bitmap_get_addr_16(sk_bitmap_t cbitmap, Int32 x, Int32 y)
  ffi.Pointer<ffi.Uint16> sk_bitmap_get_addr_16(
    ffi.Pointer<ffi.Void> cbitmap,
    int x,
    int y,
  ) {
    return _sk_bitmap_get_addr_16(
      cbitmap,
      x,
      y,
    );
  }

  late final _sk_bitmap_get_addr_16Ptr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Uint16> Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32)>>('sk_bitmap_get_addr_16');
  late final _sk_bitmap_get_addr_16 =
      _sk_bitmap_get_addr_16Ptr.asFunction<ffi.Pointer<ffi.Uint16> Function(ffi.Pointer<ffi.Void>, int, int)>();

  /// UInt32* sk_bitmap_get_addr_32(sk_bitmap_t cbitmap, Int32 x, Int32 y)
  ffi.Pointer<ffi.Uint32> sk_bitmap_get_addr_32(
    ffi.Pointer<ffi.Void> cbitmap,
    int x,
    int y,
  ) {
    return _sk_bitmap_get_addr_32(
      cbitmap,
      x,
      y,
    );
  }

  late final _sk_bitmap_get_addr_32Ptr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Uint32> Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32)>>('sk_bitmap_get_addr_32');
  late final _sk_bitmap_get_addr_32 =
      _sk_bitmap_get_addr_32Ptr.asFunction<ffi.Pointer<ffi.Uint32> Function(ffi.Pointer<ffi.Void>, int, int)>();

  /// Byte* sk_bitmap_get_addr_8(sk_bitmap_t cbitmap, Int32 x, Int32 y)
  ffi.Pointer<ffi.Uint8> sk_bitmap_get_addr_8(
    ffi.Pointer<ffi.Void> cbitmap,
    int x,
    int y,
  ) {
    return _sk_bitmap_get_addr_8(
      cbitmap,
      x,
      y,
    );
  }

  late final _sk_bitmap_get_addr_8Ptr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Uint8> Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32)>>('sk_bitmap_get_addr_8');
  late final _sk_bitmap_get_addr_8 =
      _sk_bitmap_get_addr_8Ptr.asFunction<ffi.Pointer<ffi.Uint8> Function(ffi.Pointer<ffi.Void>, int, int)>();

  /// IntPtr sk_bitmap_get_byte_count(sk_bitmap_t cbitmap)
  ffi.Pointer<ffi.Void> sk_bitmap_get_byte_count(
    ffi.Pointer<ffi.Void> cbitmap,
  ) {
    return _sk_bitmap_get_byte_count(
      cbitmap,
    );
  }

  late final _sk_bitmap_get_byte_countPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_bitmap_get_byte_count');
  late final _sk_bitmap_get_byte_count =
      _sk_bitmap_get_byte_countPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_bitmap_get_info(sk_bitmap_t cbitmap, SKImageInfoNative* info)
  void sk_bitmap_get_info(
    ffi.Pointer<ffi.Void> cbitmap,
    ffi.Pointer<ffi.Void> info,
  ) {
    return _sk_bitmap_get_info(
      cbitmap,
      info,
    );
  }

  late final _sk_bitmap_get_infoPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_bitmap_get_info');
  late final _sk_bitmap_get_info =
      _sk_bitmap_get_infoPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// UInt32 sk_bitmap_get_pixel_color(sk_bitmap_t cbitmap, Int32 x, Int32 y)
  int sk_bitmap_get_pixel_color(
    ffi.Pointer<ffi.Void> cbitmap,
    int x,
    int y,
  ) {
    return _sk_bitmap_get_pixel_color(
      cbitmap,
      x,
      y,
    );
  }

  late final _sk_bitmap_get_pixel_colorPtr = _lookup<
      ffi.NativeFunction<ffi.Uint32 Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32)>>('sk_bitmap_get_pixel_color');
  late final _sk_bitmap_get_pixel_color =
      _sk_bitmap_get_pixel_colorPtr.asFunction<int Function(ffi.Pointer<ffi.Void>, int, int)>();

  /// void sk_bitmap_get_pixel_colors(sk_bitmap_t cbitmap, UInt32* colors)
  void sk_bitmap_get_pixel_colors(
    ffi.Pointer<ffi.Void> cbitmap,
    ffi.Pointer<ffi.Uint32> colors,
  ) {
    return _sk_bitmap_get_pixel_colors(
      cbitmap,
      colors,
    );
  }

  late final _sk_bitmap_get_pixel_colorsPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint32>)>>('sk_bitmap_get_pixel_colors');
  late final _sk_bitmap_get_pixel_colors =
      _sk_bitmap_get_pixel_colorsPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint32>)>();

  /// void* sk_bitmap_get_pixels(sk_bitmap_t cbitmap, IntPtr* length)
  ffi.Pointer<ffi.Void> sk_bitmap_get_pixels(
    ffi.Pointer<ffi.Void> cbitmap,
    ffi.Pointer<ffi.Void> length,
  ) {
    return _sk_bitmap_get_pixels(
      cbitmap,
      length,
    );
  }

  late final _sk_bitmap_get_pixelsPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_bitmap_get_pixels');
  late final _sk_bitmap_get_pixels =
      _sk_bitmap_get_pixelsPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// IntPtr sk_bitmap_get_row_bytes(sk_bitmap_t cbitmap)
  ffi.Pointer<ffi.Void> sk_bitmap_get_row_bytes(
    ffi.Pointer<ffi.Void> cbitmap,
  ) {
    return _sk_bitmap_get_row_bytes(
      cbitmap,
    );
  }

  late final _sk_bitmap_get_row_bytesPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_bitmap_get_row_bytes');
  late final _sk_bitmap_get_row_bytes =
      _sk_bitmap_get_row_bytesPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_bitmap_install_pixels(sk_bitmap_t cbitmap, SKImageInfoNative* cinfo, void* pixels, IntPtr rowBytes, void* releaseProc, void* context)
  bool sk_bitmap_install_pixels(
    ffi.Pointer<ffi.Void> cbitmap,
    ffi.Pointer<ffi.Void> cinfo,
    ffi.Pointer<ffi.Void> pixels,
    ffi.Pointer<ffi.Void> rowBytes,
    ffi.Pointer<ffi.Void> releaseProc,
    ffi.Pointer<ffi.Void> context,
  ) {
    return _sk_bitmap_install_pixels(
      cbitmap,
      cinfo,
      pixels,
      rowBytes,
      releaseProc,
      context,
    );
  }

  late final _sk_bitmap_install_pixelsPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_bitmap_install_pixels');
  late final _sk_bitmap_install_pixels =
      _sk_bitmap_install_pixelsPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_bitmap_install_pixels_with_pixmap(sk_bitmap_t cbitmap, sk_pixmap_t cpixmap)
  bool sk_bitmap_install_pixels_with_pixmap(
    ffi.Pointer<ffi.Void> cbitmap,
    ffi.Pointer<ffi.Void> cpixmap,
  ) {
    return _sk_bitmap_install_pixels_with_pixmap(
      cbitmap,
      cpixmap,
    );
  }

  late final _sk_bitmap_install_pixels_with_pixmapPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_bitmap_install_pixels_with_pixmap');
  late final _sk_bitmap_install_pixels_with_pixmap =
      _sk_bitmap_install_pixels_with_pixmapPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_bitmap_is_immutable(sk_bitmap_t cbitmap)
  bool sk_bitmap_is_immutable(
    ffi.Pointer<ffi.Void> cbitmap,
  ) {
    return _sk_bitmap_is_immutable(
      cbitmap,
    );
  }

  late final _sk_bitmap_is_immutablePtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_bitmap_is_immutable');
  late final _sk_bitmap_is_immutable =
      _sk_bitmap_is_immutablePtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_bitmap_is_null(sk_bitmap_t cbitmap)
  bool sk_bitmap_is_null(
    ffi.Pointer<ffi.Void> cbitmap,
  ) {
    return _sk_bitmap_is_null(
      cbitmap,
    );
  }

  late final _sk_bitmap_is_nullPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_bitmap_is_null');
  late final _sk_bitmap_is_null =
      _sk_bitmap_is_nullPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// sk_shader_t sk_bitmap_make_shader(sk_bitmap_t cbitmap, SKShaderTileMode tmx, SKShaderTileMode tmy, SKSamplingOptions* sampling, SKMatrix* cmatrix)
  ffi.Pointer<ffi.Void> sk_bitmap_make_shader(
    ffi.Pointer<ffi.Void> cbitmap,
    int tmx,
    int tmy,
    ffi.Pointer<ffi.Void> sampling,
    ffi.Pointer<ffi.Void> cmatrix,
  ) {
    return _sk_bitmap_make_shader(
      cbitmap,
      tmx,
      tmy,
      sampling,
      cmatrix,
    );
  }

  late final _sk_bitmap_make_shaderPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_bitmap_make_shader');
  late final _sk_bitmap_make_shader =
      _sk_bitmap_make_shaderPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, int, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_bitmap_t sk_bitmap_new()
  ffi.Pointer<ffi.Void> sk_bitmap_new() {
    return _sk_bitmap_new();
  }

  late final _sk_bitmap_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_bitmap_new');
  late final _sk_bitmap_new =
      _sk_bitmap_newPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// void sk_bitmap_notify_pixels_changed(sk_bitmap_t cbitmap)
  void sk_bitmap_notify_pixels_changed(
    ffi.Pointer<ffi.Void> cbitmap,
  ) {
    return _sk_bitmap_notify_pixels_changed(
      cbitmap,
    );
  }

  late final _sk_bitmap_notify_pixels_changedPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_bitmap_notify_pixels_changed');
  late final _sk_bitmap_notify_pixels_changed =
      _sk_bitmap_notify_pixels_changedPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_bitmap_peek_pixels(sk_bitmap_t cbitmap, sk_pixmap_t cpixmap)
  bool sk_bitmap_peek_pixels(
    ffi.Pointer<ffi.Void> cbitmap,
    ffi.Pointer<ffi.Void> cpixmap,
  ) {
    return _sk_bitmap_peek_pixels(
      cbitmap,
      cpixmap,
    );
  }

  late final _sk_bitmap_peek_pixelsPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_bitmap_peek_pixels');
  late final _sk_bitmap_peek_pixels =
      _sk_bitmap_peek_pixelsPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_bitmap_ready_to_draw(sk_bitmap_t cbitmap)
  bool sk_bitmap_ready_to_draw(
    ffi.Pointer<ffi.Void> cbitmap,
  ) {
    return _sk_bitmap_ready_to_draw(
      cbitmap,
    );
  }

  late final _sk_bitmap_ready_to_drawPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_bitmap_ready_to_draw');
  late final _sk_bitmap_ready_to_draw =
      _sk_bitmap_ready_to_drawPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_bitmap_reset(sk_bitmap_t cbitmap)
  void sk_bitmap_reset(
    ffi.Pointer<ffi.Void> cbitmap,
  ) {
    return _sk_bitmap_reset(
      cbitmap,
    );
  }

  late final _sk_bitmap_resetPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_bitmap_reset');
  late final _sk_bitmap_reset =
      _sk_bitmap_resetPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_bitmap_set_immutable(sk_bitmap_t cbitmap)
  void sk_bitmap_set_immutable(
    ffi.Pointer<ffi.Void> cbitmap,
  ) {
    return _sk_bitmap_set_immutable(
      cbitmap,
    );
  }

  late final _sk_bitmap_set_immutablePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_bitmap_set_immutable');
  late final _sk_bitmap_set_immutable =
      _sk_bitmap_set_immutablePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_bitmap_set_pixels(sk_bitmap_t cbitmap, void* pixels)
  void sk_bitmap_set_pixels(
    ffi.Pointer<ffi.Void> cbitmap,
    ffi.Pointer<ffi.Void> pixels,
  ) {
    return _sk_bitmap_set_pixels(
      cbitmap,
      pixels,
    );
  }

  late final _sk_bitmap_set_pixelsPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_bitmap_set_pixels');
  late final _sk_bitmap_set_pixels =
      _sk_bitmap_set_pixelsPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_bitmap_swap(sk_bitmap_t cbitmap, sk_bitmap_t cother)
  void sk_bitmap_swap(
    ffi.Pointer<ffi.Void> cbitmap,
    ffi.Pointer<ffi.Void> cother,
  ) {
    return _sk_bitmap_swap(
      cbitmap,
      cother,
    );
  }

  late final _sk_bitmap_swapPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_bitmap_swap');
  late final _sk_bitmap_swap =
      _sk_bitmap_swapPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_bitmap_try_alloc_pixels(sk_bitmap_t cbitmap, SKImageInfoNative* requestedInfo, IntPtr rowBytes)
  bool sk_bitmap_try_alloc_pixels(
    ffi.Pointer<ffi.Void> cbitmap,
    ffi.Pointer<ffi.Void> requestedInfo,
    ffi.Pointer<ffi.Void> rowBytes,
  ) {
    return _sk_bitmap_try_alloc_pixels(
      cbitmap,
      requestedInfo,
      rowBytes,
    );
  }

  late final _sk_bitmap_try_alloc_pixelsPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_bitmap_try_alloc_pixels');
  late final _sk_bitmap_try_alloc_pixels =
      _sk_bitmap_try_alloc_pixelsPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_bitmap_try_alloc_pixels_with_flags(sk_bitmap_t cbitmap, SKImageInfoNative* requestedInfo, UInt32 flags)
  bool sk_bitmap_try_alloc_pixels_with_flags(
    ffi.Pointer<ffi.Void> cbitmap,
    ffi.Pointer<ffi.Void> requestedInfo,
    int flags,
  ) {
    return _sk_bitmap_try_alloc_pixels_with_flags(
      cbitmap,
      requestedInfo,
      flags,
    );
  }

  late final _sk_bitmap_try_alloc_pixels_with_flagsPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Uint32)>>('sk_bitmap_try_alloc_pixels_with_flags');
  late final _sk_bitmap_try_alloc_pixels_with_flags =
      _sk_bitmap_try_alloc_pixels_with_flagsPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int)>();

  /// sk_blender_t sk_blender_new_arithmetic(Single k1, Single k2, Single k3, Single k4, bool enforcePremul)
  ffi.Pointer<ffi.Void> sk_blender_new_arithmetic(
    double k1,
    double k2,
    double k3,
    double k4,
    bool enforcePremul,
  ) {
    return _sk_blender_new_arithmetic(
      k1,
      k2,
      k3,
      k4,
      enforcePremul,
    );
  }

  late final _sk_blender_new_arithmeticPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Float, ffi.Float, ffi.Float, ffi.Float, ffi.Bool)>>('sk_blender_new_arithmetic');
  late final _sk_blender_new_arithmetic =
      _sk_blender_new_arithmeticPtr.asFunction<ffi.Pointer<ffi.Void> Function(double, double, double, double, bool)>();

  /// sk_blender_t sk_blender_new_mode(SKBlendMode mode)
  ffi.Pointer<ffi.Void> sk_blender_new_mode(
    int mode,
  ) {
    return _sk_blender_new_mode(
      mode,
    );
  }

  late final _sk_blender_new_modePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Int32)>>('sk_blender_new_mode');
  late final _sk_blender_new_mode =
      _sk_blender_new_modePtr.asFunction<ffi.Pointer<ffi.Void> Function(int)>();

  /// void sk_blender_ref(sk_blender_t blender)
  void sk_blender_ref(
    ffi.Pointer<ffi.Void> blender,
  ) {
    return _sk_blender_ref(
      blender,
    );
  }

  late final _sk_blender_refPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_blender_ref');
  late final _sk_blender_ref =
      _sk_blender_refPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_blender_unref(sk_blender_t blender)
  void sk_blender_unref(
    ffi.Pointer<ffi.Void> blender,
  ) {
    return _sk_blender_unref(
      blender,
    );
  }

  late final _sk_blender_unrefPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_blender_unref');
  late final _sk_blender_unref =
      _sk_blender_unrefPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_clear(sk_canvas_t ccanvas, UInt32 color)
  void sk_canvas_clear(
    ffi.Pointer<ffi.Void> ccanvas,
    int color,
  ) {
    return _sk_canvas_clear(
      ccanvas,
      color,
    );
  }

  late final _sk_canvas_clearPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Uint32)>>('sk_canvas_clear');
  late final _sk_canvas_clear =
      _sk_canvas_clearPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int)>();

  /// void sk_canvas_clear_color4f(sk_canvas_t ccanvas, SKColorF color)
  void sk_canvas_clear_color4f(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> color,
  ) {
    return _sk_canvas_clear_color4f(
      ccanvas,
      color,
    );
  }

  late final _sk_canvas_clear_color4fPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_clear_color4f');
  late final _sk_canvas_clear_color4f =
      _sk_canvas_clear_color4fPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_clip_path_with_operation(sk_canvas_t ccanvas, sk_path_t cpath, SKClipOperation op, bool doAA)
  void sk_canvas_clip_path_with_operation(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> cpath,
    ffi.Pointer<ffi.Void> op,
    bool doAA,
  ) {
    return _sk_canvas_clip_path_with_operation(
      ccanvas,
      cpath,
      op,
      doAA,
    );
  }

  late final _sk_canvas_clip_path_with_operationPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Bool)>>('sk_canvas_clip_path_with_operation');
  late final _sk_canvas_clip_path_with_operation =
      _sk_canvas_clip_path_with_operationPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, bool)>();

  /// void sk_canvas_clip_rect_with_operation(sk_canvas_t ccanvas, SKRect* crect, SKClipOperation op, bool doAA)
  void sk_canvas_clip_rect_with_operation(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> crect,
    ffi.Pointer<ffi.Void> op,
    bool doAA,
  ) {
    return _sk_canvas_clip_rect_with_operation(
      ccanvas,
      crect,
      op,
      doAA,
    );
  }

  late final _sk_canvas_clip_rect_with_operationPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Bool)>>('sk_canvas_clip_rect_with_operation');
  late final _sk_canvas_clip_rect_with_operation =
      _sk_canvas_clip_rect_with_operationPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, bool)>();

  /// void sk_canvas_clip_region(sk_canvas_t ccanvas, sk_region_t region, SKClipOperation op)
  void sk_canvas_clip_region(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> region,
    ffi.Pointer<ffi.Void> op,
  ) {
    return _sk_canvas_clip_region(
      ccanvas,
      region,
      op,
    );
  }

  late final _sk_canvas_clip_regionPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_clip_region');
  late final _sk_canvas_clip_region =
      _sk_canvas_clip_regionPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_clip_rrect_with_operation(sk_canvas_t ccanvas, sk_rrect_t crect, SKClipOperation op, bool doAA)
  void sk_canvas_clip_rrect_with_operation(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> crect,
    ffi.Pointer<ffi.Void> op,
    bool doAA,
  ) {
    return _sk_canvas_clip_rrect_with_operation(
      ccanvas,
      crect,
      op,
      doAA,
    );
  }

  late final _sk_canvas_clip_rrect_with_operationPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Bool)>>('sk_canvas_clip_rrect_with_operation');
  late final _sk_canvas_clip_rrect_with_operation =
      _sk_canvas_clip_rrect_with_operationPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, bool)>();

  /// void sk_canvas_concat(sk_canvas_t ccanvas, SKMatrix44* cmatrix)
  void sk_canvas_concat(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> cmatrix,
  ) {
    return _sk_canvas_concat(
      ccanvas,
      cmatrix,
    );
  }

  late final _sk_canvas_concatPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_concat');
  late final _sk_canvas_concat =
      _sk_canvas_concatPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_destroy(sk_canvas_t ccanvas)
  void sk_canvas_destroy(
    ffi.Pointer<ffi.Void> ccanvas,
  ) {
    return _sk_canvas_destroy(
      ccanvas,
    );
  }

  late final _sk_canvas_destroyPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_canvas_destroy');
  late final _sk_canvas_destroy =
      _sk_canvas_destroyPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_discard(sk_canvas_t ccanvas)
  void sk_canvas_discard(
    ffi.Pointer<ffi.Void> ccanvas,
  ) {
    return _sk_canvas_discard(
      ccanvas,
    );
  }

  late final _sk_canvas_discardPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_canvas_discard');
  late final _sk_canvas_discard =
      _sk_canvas_discardPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_annotation(sk_canvas_t t, SKRect* rect, void* key, sk_data_t value)
  void sk_canvas_draw_annotation(
    ffi.Pointer<ffi.Void> t,
    ffi.Pointer<ffi.Void> rect,
    ffi.Pointer<ffi.Void> key,
    ffi.Pointer<ffi.Void> value,
  ) {
    return _sk_canvas_draw_annotation(
      t,
      rect,
      key,
      value,
    );
  }

  late final _sk_canvas_draw_annotationPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_annotation');
  late final _sk_canvas_draw_annotation =
      _sk_canvas_draw_annotationPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_arc(sk_canvas_t ccanvas, SKRect* oval, Single startAngle, Single sweepAngle, bool useCenter, sk_paint_t paint)
  void sk_canvas_draw_arc(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> oval,
    double startAngle,
    double sweepAngle,
    bool useCenter,
    ffi.Pointer<ffi.Void> paint,
  ) {
    return _sk_canvas_draw_arc(
      ccanvas,
      oval,
      startAngle,
      sweepAngle,
      useCenter,
      paint,
    );
  }

  late final _sk_canvas_draw_arcPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Bool, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_arc');
  late final _sk_canvas_draw_arc =
      _sk_canvas_draw_arcPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, double, double, bool, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_atlas(sk_canvas_t ccanvas, sk_image_t atlas, SKRotationScaleMatrix* xform, SKRect* tex, UInt32* colors, Int32 count, SKBlendMode mode, SKSamplingOptions* sampling, SKRect* cullRect, sk_paint_t paint)
  void sk_canvas_draw_atlas(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> atlas,
    ffi.Pointer<ffi.Void> xform,
    ffi.Pointer<ffi.Void> tex,
    ffi.Pointer<ffi.Uint32> colors,
    int count,
    int mode,
    ffi.Pointer<ffi.Void> sampling,
    ffi.Pointer<ffi.Void> cullRect,
    ffi.Pointer<ffi.Void> paint,
  ) {
    return _sk_canvas_draw_atlas(
      ccanvas,
      atlas,
      xform,
      tex,
      colors,
      count,
      mode,
      sampling,
      cullRect,
      paint,
    );
  }

  late final _sk_canvas_draw_atlasPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint32>, ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_atlas');
  late final _sk_canvas_draw_atlas =
      _sk_canvas_draw_atlasPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint32>, int, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_circle(sk_canvas_t ccanvas, Single cx, Single cy, Single rad, sk_paint_t cpaint)
  void sk_canvas_draw_circle(
    ffi.Pointer<ffi.Void> ccanvas,
    double cx,
    double cy,
    double rad,
    ffi.Pointer<ffi.Void> cpaint,
  ) {
    return _sk_canvas_draw_circle(
      ccanvas,
      cx,
      cy,
      rad,
      cpaint,
    );
  }

  late final _sk_canvas_draw_circlePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_circle');
  late final _sk_canvas_draw_circle =
      _sk_canvas_draw_circlePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, double, double, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_color(sk_canvas_t ccanvas, UInt32 color, SKBlendMode cmode)
  void sk_canvas_draw_color(
    ffi.Pointer<ffi.Void> ccanvas,
    int color,
    int cmode,
  ) {
    return _sk_canvas_draw_color(
      ccanvas,
      color,
      cmode,
    );
  }

  late final _sk_canvas_draw_colorPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Uint32, ffi.Int32)>>('sk_canvas_draw_color');
  late final _sk_canvas_draw_color =
      _sk_canvas_draw_colorPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int, int)>();

  /// void sk_canvas_draw_color4f(sk_canvas_t ccanvas, SKColorF color, SKBlendMode cmode)
  void sk_canvas_draw_color4f(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> color,
    int cmode,
  ) {
    return _sk_canvas_draw_color4f(
      ccanvas,
      color,
      cmode,
    );
  }

  late final _sk_canvas_draw_color4fPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_canvas_draw_color4f');
  late final _sk_canvas_draw_color4f =
      _sk_canvas_draw_color4fPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int)>();

  /// void sk_canvas_draw_drawable(sk_canvas_t ccanvas, sk_drawable_t cdrawable, SKMatrix* cmatrix)
  void sk_canvas_draw_drawable(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> cdrawable,
    ffi.Pointer<ffi.Void> cmatrix,
  ) {
    return _sk_canvas_draw_drawable(
      ccanvas,
      cdrawable,
      cmatrix,
    );
  }

  late final _sk_canvas_draw_drawablePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_drawable');
  late final _sk_canvas_draw_drawable =
      _sk_canvas_draw_drawablePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_drrect(sk_canvas_t ccanvas, sk_rrect_t outer, sk_rrect_t inner, sk_paint_t paint)
  void sk_canvas_draw_drrect(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> outer,
    ffi.Pointer<ffi.Void> inner,
    ffi.Pointer<ffi.Void> paint,
  ) {
    return _sk_canvas_draw_drrect(
      ccanvas,
      outer,
      inner,
      paint,
    );
  }

  late final _sk_canvas_draw_drrectPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_drrect');
  late final _sk_canvas_draw_drrect =
      _sk_canvas_draw_drrectPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_image(sk_canvas_t ccanvas, sk_image_t cimage, Single x, Single y, SKSamplingOptions* sampling, sk_paint_t cpaint)
  void sk_canvas_draw_image(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> cimage,
    double x,
    double y,
    ffi.Pointer<ffi.Void> sampling,
    ffi.Pointer<ffi.Void> cpaint,
  ) {
    return _sk_canvas_draw_image(
      ccanvas,
      cimage,
      x,
      y,
      sampling,
      cpaint,
    );
  }

  late final _sk_canvas_draw_imagePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_image');
  late final _sk_canvas_draw_image =
      _sk_canvas_draw_imagePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, double, double, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_image_lattice(sk_canvas_t ccanvas, sk_image_t image, SKLatticeInternal* lattice, SKRect* dst, SKFilterMode mode, sk_paint_t paint)
  void sk_canvas_draw_image_lattice(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> image,
    ffi.Pointer<ffi.Void> lattice,
    ffi.Pointer<ffi.Void> dst,
    int mode,
    ffi.Pointer<ffi.Void> paint,
  ) {
    return _sk_canvas_draw_image_lattice(
      ccanvas,
      image,
      lattice,
      dst,
      mode,
      paint,
    );
  }

  late final _sk_canvas_draw_image_latticePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_image_lattice');
  late final _sk_canvas_draw_image_lattice =
      _sk_canvas_draw_image_latticePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_image_nine(sk_canvas_t ccanvas, sk_image_t image, SKRectI* center, SKRect* dst, SKFilterMode mode, sk_paint_t paint)
  void sk_canvas_draw_image_nine(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> image,
    ffi.Pointer<ffi.Void> center,
    ffi.Pointer<ffi.Void> dst,
    int mode,
    ffi.Pointer<ffi.Void> paint,
  ) {
    return _sk_canvas_draw_image_nine(
      ccanvas,
      image,
      center,
      dst,
      mode,
      paint,
    );
  }

  late final _sk_canvas_draw_image_ninePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_image_nine');
  late final _sk_canvas_draw_image_nine =
      _sk_canvas_draw_image_ninePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_image_rect(sk_canvas_t ccanvas, sk_image_t cimage, SKRect* csrcR, SKRect* cdstR, SKSamplingOptions* sampling, sk_paint_t cpaint)
  void sk_canvas_draw_image_rect(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> cimage,
    ffi.Pointer<ffi.Void> csrcR,
    ffi.Pointer<ffi.Void> cdstR,
    ffi.Pointer<ffi.Void> sampling,
    ffi.Pointer<ffi.Void> cpaint,
  ) {
    return _sk_canvas_draw_image_rect(
      ccanvas,
      cimage,
      csrcR,
      cdstR,
      sampling,
      cpaint,
    );
  }

  late final _sk_canvas_draw_image_rectPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_image_rect');
  late final _sk_canvas_draw_image_rect =
      _sk_canvas_draw_image_rectPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_line(sk_canvas_t ccanvas, Single x0, Single y0, Single x1, Single y1, sk_paint_t cpaint)
  void sk_canvas_draw_line(
    ffi.Pointer<ffi.Void> ccanvas,
    double x0,
    double y0,
    double x1,
    double y1,
    ffi.Pointer<ffi.Void> cpaint,
  ) {
    return _sk_canvas_draw_line(
      ccanvas,
      x0,
      y0,
      x1,
      y1,
      cpaint,
    );
  }

  late final _sk_canvas_draw_linePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_line');
  late final _sk_canvas_draw_line =
      _sk_canvas_draw_linePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, double, double, double, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_link_destination_annotation(sk_canvas_t t, SKRect* rect, sk_data_t value)
  void sk_canvas_draw_link_destination_annotation(
    ffi.Pointer<ffi.Void> t,
    ffi.Pointer<ffi.Void> rect,
    ffi.Pointer<ffi.Void> value,
  ) {
    return _sk_canvas_draw_link_destination_annotation(
      t,
      rect,
      value,
    );
  }

  late final _sk_canvas_draw_link_destination_annotationPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_link_destination_annotation');
  late final _sk_canvas_draw_link_destination_annotation =
      _sk_canvas_draw_link_destination_annotationPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_named_destination_annotation(sk_canvas_t t, SKPoint* point, sk_data_t value)
  void sk_canvas_draw_named_destination_annotation(
    ffi.Pointer<ffi.Void> t,
    ffi.Pointer<ffi.Void> point,
    ffi.Pointer<ffi.Void> value,
  ) {
    return _sk_canvas_draw_named_destination_annotation(
      t,
      point,
      value,
    );
  }

  late final _sk_canvas_draw_named_destination_annotationPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_named_destination_annotation');
  late final _sk_canvas_draw_named_destination_annotation =
      _sk_canvas_draw_named_destination_annotationPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_oval(sk_canvas_t ccanvas, SKRect* crect, sk_paint_t cpaint)
  void sk_canvas_draw_oval(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> crect,
    ffi.Pointer<ffi.Void> cpaint,
  ) {
    return _sk_canvas_draw_oval(
      ccanvas,
      crect,
      cpaint,
    );
  }

  late final _sk_canvas_draw_ovalPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_oval');
  late final _sk_canvas_draw_oval =
      _sk_canvas_draw_ovalPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_paint(sk_canvas_t ccanvas, sk_paint_t cpaint)
  void sk_canvas_draw_paint(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> cpaint,
  ) {
    return _sk_canvas_draw_paint(
      ccanvas,
      cpaint,
    );
  }

  late final _sk_canvas_draw_paintPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_paint');
  late final _sk_canvas_draw_paint =
      _sk_canvas_draw_paintPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_patch(sk_canvas_t ccanvas, SKPoint* cubics, UInt32* colors, SKPoint* texCoords, SKBlendMode mode, sk_paint_t paint)
  void sk_canvas_draw_patch(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> cubics,
    ffi.Pointer<ffi.Uint32> colors,
    ffi.Pointer<ffi.Void> texCoords,
    int mode,
    ffi.Pointer<ffi.Void> paint,
  ) {
    return _sk_canvas_draw_patch(
      ccanvas,
      cubics,
      colors,
      texCoords,
      mode,
      paint,
    );
  }

  late final _sk_canvas_draw_patchPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint32>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_patch');
  late final _sk_canvas_draw_patch =
      _sk_canvas_draw_patchPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint32>, ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_path(sk_canvas_t ccanvas, sk_path_t cpath, sk_paint_t cpaint)
  void sk_canvas_draw_path(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> cpath,
    ffi.Pointer<ffi.Void> cpaint,
  ) {
    return _sk_canvas_draw_path(
      ccanvas,
      cpath,
      cpaint,
    );
  }

  late final _sk_canvas_draw_pathPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_path');
  late final _sk_canvas_draw_path =
      _sk_canvas_draw_pathPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_picture(sk_canvas_t ccanvas, sk_picture_t cpicture, SKMatrix* cmatrix, sk_paint_t cpaint)
  void sk_canvas_draw_picture(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> cpicture,
    ffi.Pointer<ffi.Void> cmatrix,
    ffi.Pointer<ffi.Void> cpaint,
  ) {
    return _sk_canvas_draw_picture(
      ccanvas,
      cpicture,
      cmatrix,
      cpaint,
    );
  }

  late final _sk_canvas_draw_picturePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_picture');
  late final _sk_canvas_draw_picture =
      _sk_canvas_draw_picturePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_point(sk_canvas_t ccanvas, Single x, Single y, sk_paint_t cpaint)
  void sk_canvas_draw_point(
    ffi.Pointer<ffi.Void> ccanvas,
    double x,
    double y,
    ffi.Pointer<ffi.Void> cpaint,
  ) {
    return _sk_canvas_draw_point(
      ccanvas,
      x,
      y,
      cpaint,
    );
  }

  late final _sk_canvas_draw_pointPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_point');
  late final _sk_canvas_draw_point =
      _sk_canvas_draw_pointPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, double, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_points(sk_canvas_t ccanvas, SKPointMode pointMode, IntPtr count, SKPoint* points, sk_paint_t cpaint)
  void sk_canvas_draw_points(
    ffi.Pointer<ffi.Void> ccanvas,
    int pointMode,
    ffi.Pointer<ffi.Void> count,
    ffi.Pointer<ffi.Void> points,
    ffi.Pointer<ffi.Void> cpaint,
  ) {
    return _sk_canvas_draw_points(
      ccanvas,
      pointMode,
      count,
      points,
      cpaint,
    );
  }

  late final _sk_canvas_draw_pointsPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_points');
  late final _sk_canvas_draw_points =
      _sk_canvas_draw_pointsPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_rect(sk_canvas_t ccanvas, SKRect* crect, sk_paint_t cpaint)
  void sk_canvas_draw_rect(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> crect,
    ffi.Pointer<ffi.Void> cpaint,
  ) {
    return _sk_canvas_draw_rect(
      ccanvas,
      crect,
      cpaint,
    );
  }

  late final _sk_canvas_draw_rectPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_rect');
  late final _sk_canvas_draw_rect =
      _sk_canvas_draw_rectPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_region(sk_canvas_t ccanvas, sk_region_t cregion, sk_paint_t cpaint)
  void sk_canvas_draw_region(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> cregion,
    ffi.Pointer<ffi.Void> cpaint,
  ) {
    return _sk_canvas_draw_region(
      ccanvas,
      cregion,
      cpaint,
    );
  }

  late final _sk_canvas_draw_regionPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_region');
  late final _sk_canvas_draw_region =
      _sk_canvas_draw_regionPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_round_rect(sk_canvas_t ccanvas, SKRect* crect, Single rx, Single ry, sk_paint_t cpaint)
  void sk_canvas_draw_round_rect(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> crect,
    double rx,
    double ry,
    ffi.Pointer<ffi.Void> cpaint,
  ) {
    return _sk_canvas_draw_round_rect(
      ccanvas,
      crect,
      rx,
      ry,
      cpaint,
    );
  }

  late final _sk_canvas_draw_round_rectPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_round_rect');
  late final _sk_canvas_draw_round_rect =
      _sk_canvas_draw_round_rectPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, double, double, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_rrect(sk_canvas_t ccanvas, sk_rrect_t crect, sk_paint_t cpaint)
  void sk_canvas_draw_rrect(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> crect,
    ffi.Pointer<ffi.Void> cpaint,
  ) {
    return _sk_canvas_draw_rrect(
      ccanvas,
      crect,
      cpaint,
    );
  }

  late final _sk_canvas_draw_rrectPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_rrect');
  late final _sk_canvas_draw_rrect =
      _sk_canvas_draw_rrectPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_simple_text(sk_canvas_t ccanvas, void* text, IntPtr byte_length, SKTextEncoding encoding, Single x, Single y, sk_font_t cfont, sk_paint_t cpaint)
  void sk_canvas_draw_simple_text(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> text,
    ffi.Pointer<ffi.Void> byte_length,
    int encoding,
    double x,
    double y,
    ffi.Pointer<ffi.Void> cfont,
    ffi.Pointer<ffi.Void> cpaint,
  ) {
    return _sk_canvas_draw_simple_text(
      ccanvas,
      text,
      byte_length,
      encoding,
      x,
      y,
      cfont,
      cpaint,
    );
  }

  late final _sk_canvas_draw_simple_textPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_simple_text');
  late final _sk_canvas_draw_simple_text =
      _sk_canvas_draw_simple_textPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, double, double, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_text_blob(sk_canvas_t ccanvas, sk_textblob_t text, Single x, Single y, sk_paint_t cpaint)
  void sk_canvas_draw_text_blob(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> text,
    double x,
    double y,
    ffi.Pointer<ffi.Void> cpaint,
  ) {
    return _sk_canvas_draw_text_blob(
      ccanvas,
      text,
      x,
      y,
      cpaint,
    );
  }

  late final _sk_canvas_draw_text_blobPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_text_blob');
  late final _sk_canvas_draw_text_blob =
      _sk_canvas_draw_text_blobPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, double, double, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_url_annotation(sk_canvas_t t, SKRect* rect, sk_data_t value)
  void sk_canvas_draw_url_annotation(
    ffi.Pointer<ffi.Void> t,
    ffi.Pointer<ffi.Void> rect,
    ffi.Pointer<ffi.Void> value,
  ) {
    return _sk_canvas_draw_url_annotation(
      t,
      rect,
      value,
    );
  }

  late final _sk_canvas_draw_url_annotationPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_url_annotation');
  late final _sk_canvas_draw_url_annotation =
      _sk_canvas_draw_url_annotationPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_draw_vertices(sk_canvas_t ccanvas, sk_vertices_t vertices, SKBlendMode mode, sk_paint_t paint)
  void sk_canvas_draw_vertices(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> vertices,
    int mode,
    ffi.Pointer<ffi.Void> paint,
  ) {
    return _sk_canvas_draw_vertices(
      ccanvas,
      vertices,
      mode,
      paint,
    );
  }

  late final _sk_canvas_draw_verticesPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Pointer<ffi.Void>)>>('sk_canvas_draw_vertices');
  late final _sk_canvas_draw_vertices =
      _sk_canvas_draw_verticesPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>)>();

  /// bool sk_canvas_get_device_clip_bounds(sk_canvas_t ccanvas, SKRectI* cbounds)
  bool sk_canvas_get_device_clip_bounds(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> cbounds,
  ) {
    return _sk_canvas_get_device_clip_bounds(
      ccanvas,
      cbounds,
    );
  }

  late final _sk_canvas_get_device_clip_boundsPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_get_device_clip_bounds');
  late final _sk_canvas_get_device_clip_bounds =
      _sk_canvas_get_device_clip_boundsPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_canvas_get_local_clip_bounds(sk_canvas_t ccanvas, SKRect* cbounds)
  bool sk_canvas_get_local_clip_bounds(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> cbounds,
  ) {
    return _sk_canvas_get_local_clip_bounds(
      ccanvas,
      cbounds,
    );
  }

  late final _sk_canvas_get_local_clip_boundsPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_get_local_clip_bounds');
  late final _sk_canvas_get_local_clip_bounds =
      _sk_canvas_get_local_clip_boundsPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_get_matrix(sk_canvas_t ccanvas, SKMatrix44* cmatrix)
  void sk_canvas_get_matrix(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> cmatrix,
  ) {
    return _sk_canvas_get_matrix(
      ccanvas,
      cmatrix,
    );
  }

  late final _sk_canvas_get_matrixPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_get_matrix');
  late final _sk_canvas_get_matrix =
      _sk_canvas_get_matrixPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_canvas_get_save_count(sk_canvas_t ccanvas)
  int sk_canvas_get_save_count(
    ffi.Pointer<ffi.Void> ccanvas,
  ) {
    return _sk_canvas_get_save_count(
      ccanvas,
    );
  }

  late final _sk_canvas_get_save_countPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_canvas_get_save_count');
  late final _sk_canvas_get_save_count =
      _sk_canvas_get_save_countPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_canvas_is_clip_empty(sk_canvas_t ccanvas)
  bool sk_canvas_is_clip_empty(
    ffi.Pointer<ffi.Void> ccanvas,
  ) {
    return _sk_canvas_is_clip_empty(
      ccanvas,
    );
  }

  late final _sk_canvas_is_clip_emptyPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_canvas_is_clip_empty');
  late final _sk_canvas_is_clip_empty =
      _sk_canvas_is_clip_emptyPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_canvas_is_clip_rect(sk_canvas_t ccanvas)
  bool sk_canvas_is_clip_rect(
    ffi.Pointer<ffi.Void> ccanvas,
  ) {
    return _sk_canvas_is_clip_rect(
      ccanvas,
    );
  }

  late final _sk_canvas_is_clip_rectPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_canvas_is_clip_rect');
  late final _sk_canvas_is_clip_rect =
      _sk_canvas_is_clip_rectPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// sk_canvas_t sk_canvas_new_from_bitmap(sk_bitmap_t bitmap)
  ffi.Pointer<ffi.Void> sk_canvas_new_from_bitmap(
    ffi.Pointer<ffi.Void> bitmap,
  ) {
    return _sk_canvas_new_from_bitmap(
      bitmap,
    );
  }

  late final _sk_canvas_new_from_bitmapPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_canvas_new_from_bitmap');
  late final _sk_canvas_new_from_bitmap =
      _sk_canvas_new_from_bitmapPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_canvas_t sk_canvas_new_from_raster(SKImageInfoNative* cinfo, void* pixels, IntPtr rowBytes, sk_surfaceprops_t props)
  ffi.Pointer<ffi.Void> sk_canvas_new_from_raster(
    ffi.Pointer<ffi.Void> cinfo,
    ffi.Pointer<ffi.Void> pixels,
    ffi.Pointer<ffi.Void> rowBytes,
    ffi.Pointer<ffi.Void> props,
  ) {
    return _sk_canvas_new_from_raster(
      cinfo,
      pixels,
      rowBytes,
      props,
    );
  }

  late final _sk_canvas_new_from_rasterPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_new_from_raster');
  late final _sk_canvas_new_from_raster =
      _sk_canvas_new_from_rasterPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_canvas_quick_reject(sk_canvas_t ccanvas, SKRect* crect)
  bool sk_canvas_quick_reject(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> crect,
  ) {
    return _sk_canvas_quick_reject(
      ccanvas,
      crect,
    );
  }

  late final _sk_canvas_quick_rejectPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_quick_reject');
  late final _sk_canvas_quick_reject =
      _sk_canvas_quick_rejectPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_reset_matrix(sk_canvas_t ccanvas)
  void sk_canvas_reset_matrix(
    ffi.Pointer<ffi.Void> ccanvas,
  ) {
    return _sk_canvas_reset_matrix(
      ccanvas,
    );
  }

  late final _sk_canvas_reset_matrixPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_canvas_reset_matrix');
  late final _sk_canvas_reset_matrix =
      _sk_canvas_reset_matrixPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_restore(sk_canvas_t ccanvas)
  void sk_canvas_restore(
    ffi.Pointer<ffi.Void> ccanvas,
  ) {
    return _sk_canvas_restore(
      ccanvas,
    );
  }

  late final _sk_canvas_restorePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_canvas_restore');
  late final _sk_canvas_restore =
      _sk_canvas_restorePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_restore_to_count(sk_canvas_t ccanvas, Int32 saveCount)
  void sk_canvas_restore_to_count(
    ffi.Pointer<ffi.Void> ccanvas,
    int saveCount,
  ) {
    return _sk_canvas_restore_to_count(
      ccanvas,
      saveCount,
    );
  }

  late final _sk_canvas_restore_to_countPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_canvas_restore_to_count');
  late final _sk_canvas_restore_to_count =
      _sk_canvas_restore_to_countPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int)>();

  /// void sk_canvas_rotate_degrees(sk_canvas_t ccanvas, Single degrees)
  void sk_canvas_rotate_degrees(
    ffi.Pointer<ffi.Void> ccanvas,
    double degrees,
  ) {
    return _sk_canvas_rotate_degrees(
      ccanvas,
      degrees,
    );
  }

  late final _sk_canvas_rotate_degreesPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float)>>('sk_canvas_rotate_degrees');
  late final _sk_canvas_rotate_degrees =
      _sk_canvas_rotate_degreesPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double)>();

  /// void sk_canvas_rotate_radians(sk_canvas_t ccanvas, Single radians)
  void sk_canvas_rotate_radians(
    ffi.Pointer<ffi.Void> ccanvas,
    double radians,
  ) {
    return _sk_canvas_rotate_radians(
      ccanvas,
      radians,
    );
  }

  late final _sk_canvas_rotate_radiansPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float)>>('sk_canvas_rotate_radians');
  late final _sk_canvas_rotate_radians =
      _sk_canvas_rotate_radiansPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double)>();

  /// Int32 sk_canvas_save(sk_canvas_t ccanvas)
  int sk_canvas_save(
    ffi.Pointer<ffi.Void> ccanvas,
  ) {
    return _sk_canvas_save(
      ccanvas,
    );
  }

  late final _sk_canvas_savePtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_canvas_save');
  late final _sk_canvas_save =
      _sk_canvas_savePtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_canvas_save_layer(sk_canvas_t ccanvas, SKRect* crect, sk_paint_t cpaint)
  int sk_canvas_save_layer(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> crect,
    ffi.Pointer<ffi.Void> cpaint,
  ) {
    return _sk_canvas_save_layer(
      ccanvas,
      crect,
      cpaint,
    );
  }

  late final _sk_canvas_save_layerPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_save_layer');
  late final _sk_canvas_save_layer =
      _sk_canvas_save_layerPtr.asFunction<int Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_canvas_save_layer_rec(sk_canvas_t ccanvas, SKCanvasSaveLayerRecNative* crec)
  int sk_canvas_save_layer_rec(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> crec,
  ) {
    return _sk_canvas_save_layer_rec(
      ccanvas,
      crec,
    );
  }

  late final _sk_canvas_save_layer_recPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_save_layer_rec');
  late final _sk_canvas_save_layer_rec =
      _sk_canvas_save_layer_recPtr.asFunction<int Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_scale(sk_canvas_t ccanvas, Single sx, Single sy)
  void sk_canvas_scale(
    ffi.Pointer<ffi.Void> ccanvas,
    double sx,
    double sy,
  ) {
    return _sk_canvas_scale(
      ccanvas,
      sx,
      sy,
    );
  }

  late final _sk_canvas_scalePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float)>>('sk_canvas_scale');
  late final _sk_canvas_scale =
      _sk_canvas_scalePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, double)>();

  /// void sk_canvas_set_matrix(sk_canvas_t ccanvas, SKMatrix44* cmatrix)
  void sk_canvas_set_matrix(
    ffi.Pointer<ffi.Void> ccanvas,
    ffi.Pointer<ffi.Void> cmatrix,
  ) {
    return _sk_canvas_set_matrix(
      ccanvas,
      cmatrix,
    );
  }

  late final _sk_canvas_set_matrixPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_canvas_set_matrix');
  late final _sk_canvas_set_matrix =
      _sk_canvas_set_matrixPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_canvas_skew(sk_canvas_t ccanvas, Single sx, Single sy)
  void sk_canvas_skew(
    ffi.Pointer<ffi.Void> ccanvas,
    double sx,
    double sy,
  ) {
    return _sk_canvas_skew(
      ccanvas,
      sx,
      sy,
    );
  }

  late final _sk_canvas_skewPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float)>>('sk_canvas_skew');
  late final _sk_canvas_skew =
      _sk_canvas_skewPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, double)>();

  /// void sk_canvas_translate(sk_canvas_t ccanvas, Single dx, Single dy)
  void sk_canvas_translate(
    ffi.Pointer<ffi.Void> ccanvas,
    double dx,
    double dy,
  ) {
    return _sk_canvas_translate(
      ccanvas,
      dx,
      dy,
    );
  }

  late final _sk_canvas_translatePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float)>>('sk_canvas_translate');
  late final _sk_canvas_translate =
      _sk_canvas_translatePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, double)>();

  /// gr_recording_context_t sk_get_recording_context(sk_canvas_t canvas)
  ffi.Pointer<ffi.Void> sk_get_recording_context(
    ffi.Pointer<ffi.Void> canvas,
  ) {
    return _sk_get_recording_context(
      canvas,
    );
  }

  late final _sk_get_recording_contextPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_get_recording_context');
  late final _sk_get_recording_context =
      _sk_get_recording_contextPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_surface_t sk_get_surface(sk_canvas_t canvas)
  ffi.Pointer<ffi.Void> sk_get_surface(
    ffi.Pointer<ffi.Void> canvas,
  ) {
    return _sk_get_surface(
      canvas,
    );
  }

  late final _sk_get_surfacePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_get_surface');
  late final _sk_get_surface =
      _sk_get_surfacePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_nodraw_canvas_destroy(sk_nodraw_canvas_t t)
  void sk_nodraw_canvas_destroy(
    ffi.Pointer<ffi.Void> t,
  ) {
    return _sk_nodraw_canvas_destroy(
      t,
    );
  }

  late final _sk_nodraw_canvas_destroyPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_nodraw_canvas_destroy');
  late final _sk_nodraw_canvas_destroy =
      _sk_nodraw_canvas_destroyPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// sk_nodraw_canvas_t sk_nodraw_canvas_new(Int32 width, Int32 height)
  ffi.Pointer<ffi.Void> sk_nodraw_canvas_new(
    int width,
    int height,
  ) {
    return _sk_nodraw_canvas_new(
      width,
      height,
    );
  }

  late final _sk_nodraw_canvas_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Int32, ffi.Int32)>>('sk_nodraw_canvas_new');
  late final _sk_nodraw_canvas_new =
      _sk_nodraw_canvas_newPtr.asFunction<ffi.Pointer<ffi.Void> Function(int, int)>();

  /// void sk_nway_canvas_add_canvas(sk_nway_canvas_t t, sk_canvas_t canvas)
  void sk_nway_canvas_add_canvas(
    ffi.Pointer<ffi.Void> t,
    ffi.Pointer<ffi.Void> canvas,
  ) {
    return _sk_nway_canvas_add_canvas(
      t,
      canvas,
    );
  }

  late final _sk_nway_canvas_add_canvasPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_nway_canvas_add_canvas');
  late final _sk_nway_canvas_add_canvas =
      _sk_nway_canvas_add_canvasPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_nway_canvas_destroy(sk_nway_canvas_t t)
  void sk_nway_canvas_destroy(
    ffi.Pointer<ffi.Void> t,
  ) {
    return _sk_nway_canvas_destroy(
      t,
    );
  }

  late final _sk_nway_canvas_destroyPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_nway_canvas_destroy');
  late final _sk_nway_canvas_destroy =
      _sk_nway_canvas_destroyPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// sk_nway_canvas_t sk_nway_canvas_new(Int32 width, Int32 height)
  ffi.Pointer<ffi.Void> sk_nway_canvas_new(
    int width,
    int height,
  ) {
    return _sk_nway_canvas_new(
      width,
      height,
    );
  }

  late final _sk_nway_canvas_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Int32, ffi.Int32)>>('sk_nway_canvas_new');
  late final _sk_nway_canvas_new =
      _sk_nway_canvas_newPtr.asFunction<ffi.Pointer<ffi.Void> Function(int, int)>();

  /// void sk_nway_canvas_remove_all(sk_nway_canvas_t t)
  void sk_nway_canvas_remove_all(
    ffi.Pointer<ffi.Void> t,
  ) {
    return _sk_nway_canvas_remove_all(
      t,
    );
  }

  late final _sk_nway_canvas_remove_allPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_nway_canvas_remove_all');
  late final _sk_nway_canvas_remove_all =
      _sk_nway_canvas_remove_allPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_nway_canvas_remove_canvas(sk_nway_canvas_t t, sk_canvas_t canvas)
  void sk_nway_canvas_remove_canvas(
    ffi.Pointer<ffi.Void> t,
    ffi.Pointer<ffi.Void> canvas,
  ) {
    return _sk_nway_canvas_remove_canvas(
      t,
      canvas,
    );
  }

  late final _sk_nway_canvas_remove_canvasPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_nway_canvas_remove_canvas');
  late final _sk_nway_canvas_remove_canvas =
      _sk_nway_canvas_remove_canvasPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_overdraw_canvas_destroy(sk_overdraw_canvas_t canvas)
  void sk_overdraw_canvas_destroy(
    ffi.Pointer<ffi.Void> canvas,
  ) {
    return _sk_overdraw_canvas_destroy(
      canvas,
    );
  }

  late final _sk_overdraw_canvas_destroyPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_overdraw_canvas_destroy');
  late final _sk_overdraw_canvas_destroy =
      _sk_overdraw_canvas_destroyPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// sk_overdraw_canvas_t sk_overdraw_canvas_new(sk_canvas_t canvas)
  ffi.Pointer<ffi.Void> sk_overdraw_canvas_new(
    ffi.Pointer<ffi.Void> canvas,
  ) {
    return _sk_overdraw_canvas_new(
      canvas,
    );
  }

  late final _sk_overdraw_canvas_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_overdraw_canvas_new');
  late final _sk_overdraw_canvas_new =
      _sk_overdraw_canvas_newPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_codec_destroy(sk_codec_t codec)
  void sk_codec_destroy(
    ffi.Pointer<ffi.Void> codec,
  ) {
    return _sk_codec_destroy(
      codec,
    );
  }

  late final _sk_codec_destroyPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_codec_destroy');
  late final _sk_codec_destroy =
      _sk_codec_destroyPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// SKEncodedImageFormat sk_codec_get_encoded_format(sk_codec_t codec)
  int sk_codec_get_encoded_format(
    ffi.Pointer<ffi.Void> codec,
  ) {
    return _sk_codec_get_encoded_format(
      codec,
    );
  }

  late final _sk_codec_get_encoded_formatPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_codec_get_encoded_format');
  late final _sk_codec_get_encoded_format =
      _sk_codec_get_encoded_formatPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_codec_get_frame_count(sk_codec_t codec)
  int sk_codec_get_frame_count(
    ffi.Pointer<ffi.Void> codec,
  ) {
    return _sk_codec_get_frame_count(
      codec,
    );
  }

  late final _sk_codec_get_frame_countPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_codec_get_frame_count');
  late final _sk_codec_get_frame_count =
      _sk_codec_get_frame_countPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_codec_get_frame_info(sk_codec_t codec, SKCodecFrameInfo* frameInfo)
  void sk_codec_get_frame_info(
    ffi.Pointer<ffi.Void> codec,
    ffi.Pointer<ffi.Void> frameInfo,
  ) {
    return _sk_codec_get_frame_info(
      codec,
      frameInfo,
    );
  }

  late final _sk_codec_get_frame_infoPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_codec_get_frame_info');
  late final _sk_codec_get_frame_info =
      _sk_codec_get_frame_infoPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_codec_get_frame_info_for_index(sk_codec_t codec, Int32 index, SKCodecFrameInfo* frameInfo)
  bool sk_codec_get_frame_info_for_index(
    ffi.Pointer<ffi.Void> codec,
    int index,
    ffi.Pointer<ffi.Void> frameInfo,
  ) {
    return _sk_codec_get_frame_info_for_index(
      codec,
      index,
      frameInfo,
    );
  }

  late final _sk_codec_get_frame_info_for_indexPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Pointer<ffi.Void>)>>('sk_codec_get_frame_info_for_index');
  late final _sk_codec_get_frame_info_for_index =
      _sk_codec_get_frame_info_for_indexPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>)>();

  /// void sk_codec_get_info(sk_codec_t codec, SKImageInfoNative* info)
  void sk_codec_get_info(
    ffi.Pointer<ffi.Void> codec,
    ffi.Pointer<ffi.Void> info,
  ) {
    return _sk_codec_get_info(
      codec,
      info,
    );
  }

  late final _sk_codec_get_infoPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_codec_get_info');
  late final _sk_codec_get_info =
      _sk_codec_get_infoPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// SKEncodedOrigin sk_codec_get_origin(sk_codec_t codec)
  ffi.Pointer<ffi.Void> sk_codec_get_origin(
    ffi.Pointer<ffi.Void> codec,
  ) {
    return _sk_codec_get_origin(
      codec,
    );
  }

  late final _sk_codec_get_originPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_codec_get_origin');
  late final _sk_codec_get_origin =
      _sk_codec_get_originPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// SKCodecResult sk_codec_get_pixels(sk_codec_t codec, SKImageInfoNative* info, void* pixels, IntPtr rowBytes, SKCodecOptionsInternal* options)
  int sk_codec_get_pixels(
    ffi.Pointer<ffi.Void> codec,
    ffi.Pointer<ffi.Void> info,
    ffi.Pointer<ffi.Void> pixels,
    ffi.Pointer<ffi.Void> rowBytes,
    ffi.Pointer<ffi.Void> options,
  ) {
    return _sk_codec_get_pixels(
      codec,
      info,
      pixels,
      rowBytes,
      options,
    );
  }

  late final _sk_codec_get_pixelsPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_codec_get_pixels');
  late final _sk_codec_get_pixels =
      _sk_codec_get_pixelsPtr.asFunction<int Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_codec_get_repetition_count(sk_codec_t codec)
  int sk_codec_get_repetition_count(
    ffi.Pointer<ffi.Void> codec,
  ) {
    return _sk_codec_get_repetition_count(
      codec,
    );
  }

  late final _sk_codec_get_repetition_countPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_codec_get_repetition_count');
  late final _sk_codec_get_repetition_count =
      _sk_codec_get_repetition_countPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_codec_get_scaled_dimensions(sk_codec_t codec, Single desiredScale, SKSizeI* dimensions)
  void sk_codec_get_scaled_dimensions(
    ffi.Pointer<ffi.Void> codec,
    double desiredScale,
    ffi.Pointer<ffi.Void> dimensions,
  ) {
    return _sk_codec_get_scaled_dimensions(
      codec,
      desiredScale,
      dimensions,
    );
  }

  late final _sk_codec_get_scaled_dimensionsPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Pointer<ffi.Void>)>>('sk_codec_get_scaled_dimensions');
  late final _sk_codec_get_scaled_dimensions =
      _sk_codec_get_scaled_dimensionsPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, ffi.Pointer<ffi.Void>)>();

  /// SKCodecScanlineOrder sk_codec_get_scanline_order(sk_codec_t codec)
  ffi.Pointer<ffi.Void> sk_codec_get_scanline_order(
    ffi.Pointer<ffi.Void> codec,
  ) {
    return _sk_codec_get_scanline_order(
      codec,
    );
  }

  late final _sk_codec_get_scanline_orderPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_codec_get_scanline_order');
  late final _sk_codec_get_scanline_order =
      _sk_codec_get_scanline_orderPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_codec_get_scanlines(sk_codec_t codec, void* dst, Int32 countLines, IntPtr rowBytes)
  int sk_codec_get_scanlines(
    ffi.Pointer<ffi.Void> codec,
    ffi.Pointer<ffi.Void> dst,
    int countLines,
    ffi.Pointer<ffi.Void> rowBytes,
  ) {
    return _sk_codec_get_scanlines(
      codec,
      dst,
      countLines,
      rowBytes,
    );
  }

  late final _sk_codec_get_scanlinesPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Pointer<ffi.Void>)>>('sk_codec_get_scanlines');
  late final _sk_codec_get_scanlines =
      _sk_codec_get_scanlinesPtr.asFunction<int Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>)>();

  /// bool sk_codec_get_valid_subset(sk_codec_t codec, SKRectI* desiredSubset)
  bool sk_codec_get_valid_subset(
    ffi.Pointer<ffi.Void> codec,
    ffi.Pointer<ffi.Void> desiredSubset,
  ) {
    return _sk_codec_get_valid_subset(
      codec,
      desiredSubset,
    );
  }

  late final _sk_codec_get_valid_subsetPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_codec_get_valid_subset');
  late final _sk_codec_get_valid_subset =
      _sk_codec_get_valid_subsetPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// SKCodecResult sk_codec_incremental_decode(sk_codec_t codec, Int32* rowsDecoded)
  int sk_codec_incremental_decode(
    ffi.Pointer<ffi.Void> codec,
    ffi.Pointer<ffi.Int32> rowsDecoded,
  ) {
    return _sk_codec_incremental_decode(
      codec,
      rowsDecoded,
    );
  }

  late final _sk_codec_incremental_decodePtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Int32>)>>('sk_codec_incremental_decode');
  late final _sk_codec_incremental_decode =
      _sk_codec_incremental_decodePtr.asFunction<int Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Int32>)>();

  /// IntPtr sk_codec_min_buffered_bytes_needed()
  ffi.Pointer<ffi.Void> sk_codec_min_buffered_bytes_needed() {
    return _sk_codec_min_buffered_bytes_needed();
  }

  late final _sk_codec_min_buffered_bytes_neededPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_codec_min_buffered_bytes_needed');
  late final _sk_codec_min_buffered_bytes_needed =
      _sk_codec_min_buffered_bytes_neededPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// sk_codec_t sk_codec_new_from_data(sk_data_t data)
  ffi.Pointer<ffi.Void> sk_codec_new_from_data(
    ffi.Pointer<ffi.Void> data,
  ) {
    return _sk_codec_new_from_data(
      data,
    );
  }

  late final _sk_codec_new_from_dataPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_codec_new_from_data');
  late final _sk_codec_new_from_data =
      _sk_codec_new_from_dataPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_codec_t sk_codec_new_from_stream(sk_stream_t stream, SKCodecResult* result)
  ffi.Pointer<ffi.Void> sk_codec_new_from_stream(
    ffi.Pointer<ffi.Void> stream,
    ffi.Pointer<ffi.Int32> result,
  ) {
    return _sk_codec_new_from_stream(
      stream,
      result,
    );
  }

  late final _sk_codec_new_from_streamPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Int32>)>>('sk_codec_new_from_stream');
  late final _sk_codec_new_from_stream =
      _sk_codec_new_from_streamPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Int32>)>();

  /// Int32 sk_codec_next_scanline(sk_codec_t codec)
  int sk_codec_next_scanline(
    ffi.Pointer<ffi.Void> codec,
  ) {
    return _sk_codec_next_scanline(
      codec,
    );
  }

  late final _sk_codec_next_scanlinePtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_codec_next_scanline');
  late final _sk_codec_next_scanline =
      _sk_codec_next_scanlinePtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_codec_output_scanline(sk_codec_t codec, Int32 inputScanline)
  int sk_codec_output_scanline(
    ffi.Pointer<ffi.Void> codec,
    int inputScanline,
  ) {
    return _sk_codec_output_scanline(
      codec,
      inputScanline,
    );
  }

  late final _sk_codec_output_scanlinePtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_codec_output_scanline');
  late final _sk_codec_output_scanline =
      _sk_codec_output_scanlinePtr.asFunction<int Function(ffi.Pointer<ffi.Void>, int)>();

  /// bool sk_codec_skip_scanlines(sk_codec_t codec, Int32 countLines)
  bool sk_codec_skip_scanlines(
    ffi.Pointer<ffi.Void> codec,
    int countLines,
  ) {
    return _sk_codec_skip_scanlines(
      codec,
      countLines,
    );
  }

  late final _sk_codec_skip_scanlinesPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_codec_skip_scanlines');
  late final _sk_codec_skip_scanlines =
      _sk_codec_skip_scanlinesPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, int)>();

  /// SKCodecResult sk_codec_start_incremental_decode(sk_codec_t codec, SKImageInfoNative* info, void* pixels, IntPtr rowBytes, SKCodecOptionsInternal* options)
  int sk_codec_start_incremental_decode(
    ffi.Pointer<ffi.Void> codec,
    ffi.Pointer<ffi.Void> info,
    ffi.Pointer<ffi.Void> pixels,
    ffi.Pointer<ffi.Void> rowBytes,
    ffi.Pointer<ffi.Void> options,
  ) {
    return _sk_codec_start_incremental_decode(
      codec,
      info,
      pixels,
      rowBytes,
      options,
    );
  }

  late final _sk_codec_start_incremental_decodePtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_codec_start_incremental_decode');
  late final _sk_codec_start_incremental_decode =
      _sk_codec_start_incremental_decodePtr.asFunction<int Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// SKCodecResult sk_codec_start_scanline_decode(sk_codec_t codec, SKImageInfoNative* info, SKCodecOptionsInternal* options)
  int sk_codec_start_scanline_decode(
    ffi.Pointer<ffi.Void> codec,
    ffi.Pointer<ffi.Void> info,
    ffi.Pointer<ffi.Void> options,
  ) {
    return _sk_codec_start_scanline_decode(
      codec,
      info,
      options,
    );
  }

  late final _sk_codec_start_scanline_decodePtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_codec_start_scanline_decode');
  late final _sk_codec_start_scanline_decode =
      _sk_codec_start_scanline_decodePtr.asFunction<int Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_colorfilter_t sk_colorfilter_new_color_matrix(Single* array)
  ffi.Pointer<ffi.Void> sk_colorfilter_new_color_matrix(
    ffi.Pointer<ffi.Float> array,
  ) {
    return _sk_colorfilter_new_color_matrix(
      array,
    );
  }

  late final _sk_colorfilter_new_color_matrixPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Float>)>>('sk_colorfilter_new_color_matrix');
  late final _sk_colorfilter_new_color_matrix =
      _sk_colorfilter_new_color_matrixPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Float>)>();

  /// sk_colorfilter_t sk_colorfilter_new_compose(sk_colorfilter_t outer, sk_colorfilter_t inner)
  ffi.Pointer<ffi.Void> sk_colorfilter_new_compose(
    ffi.Pointer<ffi.Void> outer,
    ffi.Pointer<ffi.Void> inner,
  ) {
    return _sk_colorfilter_new_compose(
      outer,
      inner,
    );
  }

  late final _sk_colorfilter_new_composePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_colorfilter_new_compose');
  late final _sk_colorfilter_new_compose =
      _sk_colorfilter_new_composePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_colorfilter_t sk_colorfilter_new_high_contrast(SKHighContrastConfig* config)
  ffi.Pointer<ffi.Void> sk_colorfilter_new_high_contrast(
    ffi.Pointer<ffi.Void> config,
  ) {
    return _sk_colorfilter_new_high_contrast(
      config,
    );
  }

  late final _sk_colorfilter_new_high_contrastPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_colorfilter_new_high_contrast');
  late final _sk_colorfilter_new_high_contrast =
      _sk_colorfilter_new_high_contrastPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_colorfilter_t sk_colorfilter_new_hsla_matrix(Single* array)
  ffi.Pointer<ffi.Void> sk_colorfilter_new_hsla_matrix(
    ffi.Pointer<ffi.Float> array,
  ) {
    return _sk_colorfilter_new_hsla_matrix(
      array,
    );
  }

  late final _sk_colorfilter_new_hsla_matrixPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Float>)>>('sk_colorfilter_new_hsla_matrix');
  late final _sk_colorfilter_new_hsla_matrix =
      _sk_colorfilter_new_hsla_matrixPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Float>)>();

  /// sk_colorfilter_t sk_colorfilter_new_lerp(Single weight, sk_colorfilter_t filter0, sk_colorfilter_t filter1)
  ffi.Pointer<ffi.Void> sk_colorfilter_new_lerp(
    double weight,
    ffi.Pointer<ffi.Void> filter0,
    ffi.Pointer<ffi.Void> filter1,
  ) {
    return _sk_colorfilter_new_lerp(
      weight,
      filter0,
      filter1,
    );
  }

  late final _sk_colorfilter_new_lerpPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Float, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_colorfilter_new_lerp');
  late final _sk_colorfilter_new_lerp =
      _sk_colorfilter_new_lerpPtr.asFunction<ffi.Pointer<ffi.Void> Function(double, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_colorfilter_t sk_colorfilter_new_lighting(UInt32 mul, UInt32 add)
  ffi.Pointer<ffi.Void> sk_colorfilter_new_lighting(
    int mul,
    int add,
  ) {
    return _sk_colorfilter_new_lighting(
      mul,
      add,
    );
  }

  late final _sk_colorfilter_new_lightingPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Uint32, ffi.Uint32)>>('sk_colorfilter_new_lighting');
  late final _sk_colorfilter_new_lighting =
      _sk_colorfilter_new_lightingPtr.asFunction<ffi.Pointer<ffi.Void> Function(int, int)>();

  /// sk_colorfilter_t sk_colorfilter_new_linear_to_srgb_gamma()
  ffi.Pointer<ffi.Void> sk_colorfilter_new_linear_to_srgb_gamma() {
    return _sk_colorfilter_new_linear_to_srgb_gamma();
  }

  late final _sk_colorfilter_new_linear_to_srgb_gammaPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_colorfilter_new_linear_to_srgb_gamma');
  late final _sk_colorfilter_new_linear_to_srgb_gamma =
      _sk_colorfilter_new_linear_to_srgb_gammaPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// sk_colorfilter_t sk_colorfilter_new_luma_color()
  ffi.Pointer<ffi.Void> sk_colorfilter_new_luma_color() {
    return _sk_colorfilter_new_luma_color();
  }

  late final _sk_colorfilter_new_luma_colorPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_colorfilter_new_luma_color');
  late final _sk_colorfilter_new_luma_color =
      _sk_colorfilter_new_luma_colorPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// sk_colorfilter_t sk_colorfilter_new_mode(UInt32 c, SKBlendMode mode)
  ffi.Pointer<ffi.Void> sk_colorfilter_new_mode(
    int c,
    int mode,
  ) {
    return _sk_colorfilter_new_mode(
      c,
      mode,
    );
  }

  late final _sk_colorfilter_new_modePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Uint32, ffi.Int32)>>('sk_colorfilter_new_mode');
  late final _sk_colorfilter_new_mode =
      _sk_colorfilter_new_modePtr.asFunction<ffi.Pointer<ffi.Void> Function(int, int)>();

  /// sk_colorfilter_t sk_colorfilter_new_srgb_to_linear_gamma()
  ffi.Pointer<ffi.Void> sk_colorfilter_new_srgb_to_linear_gamma() {
    return _sk_colorfilter_new_srgb_to_linear_gamma();
  }

  late final _sk_colorfilter_new_srgb_to_linear_gammaPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_colorfilter_new_srgb_to_linear_gamma');
  late final _sk_colorfilter_new_srgb_to_linear_gamma =
      _sk_colorfilter_new_srgb_to_linear_gammaPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// sk_colorfilter_t sk_colorfilter_new_table(Byte* table)
  ffi.Pointer<ffi.Void> sk_colorfilter_new_table(
    ffi.Pointer<ffi.Uint8> table,
  ) {
    return _sk_colorfilter_new_table(
      table,
    );
  }

  late final _sk_colorfilter_new_tablePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Uint8>)>>('sk_colorfilter_new_table');
  late final _sk_colorfilter_new_table =
      _sk_colorfilter_new_tablePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Uint8>)>();

  /// sk_colorfilter_t sk_colorfilter_new_table_argb(Byte* tableA, Byte* tableR, Byte* tableG, Byte* tableB)
  ffi.Pointer<ffi.Void> sk_colorfilter_new_table_argb(
    ffi.Pointer<ffi.Uint8> tableA,
    ffi.Pointer<ffi.Uint8> tableR,
    ffi.Pointer<ffi.Uint8> tableG,
    ffi.Pointer<ffi.Uint8> tableB,
  ) {
    return _sk_colorfilter_new_table_argb(
      tableA,
      tableR,
      tableG,
      tableB,
    );
  }

  late final _sk_colorfilter_new_table_argbPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Uint8>, ffi.Pointer<ffi.Uint8>, ffi.Pointer<ffi.Uint8>, ffi.Pointer<ffi.Uint8>)>>('sk_colorfilter_new_table_argb');
  late final _sk_colorfilter_new_table_argb =
      _sk_colorfilter_new_table_argbPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Uint8>, ffi.Pointer<ffi.Uint8>, ffi.Pointer<ffi.Uint8>, ffi.Pointer<ffi.Uint8>)>();

  /// void sk_colorfilter_unref(sk_colorfilter_t filter)
  void sk_colorfilter_unref(
    ffi.Pointer<ffi.Void> filter,
  ) {
    return _sk_colorfilter_unref(
      filter,
    );
  }

  late final _sk_colorfilter_unrefPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_colorfilter_unref');
  late final _sk_colorfilter_unref =
      _sk_colorfilter_unrefPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_color4f_from_color(UInt32 color, SKColorF* color4f)
  void sk_color4f_from_color(
    int color,
    ffi.Pointer<ffi.Void> color4f,
  ) {
    return _sk_color4f_from_color(
      color,
      color4f,
    );
  }

  late final _sk_color4f_from_colorPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Uint32, ffi.Pointer<ffi.Void>)>>('sk_color4f_from_color');
  late final _sk_color4f_from_color =
      _sk_color4f_from_colorPtr.asFunction<void Function(int, ffi.Pointer<ffi.Void>)>();

  /// UInt32 sk_color4f_to_color(SKColorF* color4f)
  int sk_color4f_to_color(
    ffi.Pointer<ffi.Void> color4f,
  ) {
    return _sk_color4f_to_color(
      color4f,
    );
  }

  late final _sk_color4f_to_colorPtr = _lookup<
      ffi.NativeFunction<ffi.Uint32 Function(ffi.Pointer<ffi.Void>)>>('sk_color4f_to_color');
  late final _sk_color4f_to_color =
      _sk_color4f_to_colorPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_colorspace_equals(sk_colorspace_t src, sk_colorspace_t dst)
  bool sk_colorspace_equals(
    ffi.Pointer<ffi.Void> src,
    ffi.Pointer<ffi.Void> dst,
  ) {
    return _sk_colorspace_equals(
      src,
      dst,
    );
  }

  late final _sk_colorspace_equalsPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_colorspace_equals');
  late final _sk_colorspace_equals =
      _sk_colorspace_equalsPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_colorspace_gamma_close_to_srgb(sk_colorspace_t colorspace)
  bool sk_colorspace_gamma_close_to_srgb(
    ffi.Pointer<ffi.Void> colorspace,
  ) {
    return _sk_colorspace_gamma_close_to_srgb(
      colorspace,
    );
  }

  late final _sk_colorspace_gamma_close_to_srgbPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_colorspace_gamma_close_to_srgb');
  late final _sk_colorspace_gamma_close_to_srgb =
      _sk_colorspace_gamma_close_to_srgbPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_colorspace_gamma_is_linear(sk_colorspace_t colorspace)
  bool sk_colorspace_gamma_is_linear(
    ffi.Pointer<ffi.Void> colorspace,
  ) {
    return _sk_colorspace_gamma_is_linear(
      colorspace,
    );
  }

  late final _sk_colorspace_gamma_is_linearPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_colorspace_gamma_is_linear');
  late final _sk_colorspace_gamma_is_linear =
      _sk_colorspace_gamma_is_linearPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_colorspace_icc_profile_delete(sk_colorspace_icc_profile_t profile)
  void sk_colorspace_icc_profile_delete(
    ffi.Pointer<ffi.Void> profile,
  ) {
    return _sk_colorspace_icc_profile_delete(
      profile,
    );
  }

  late final _sk_colorspace_icc_profile_deletePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_colorspace_icc_profile_delete');
  late final _sk_colorspace_icc_profile_delete =
      _sk_colorspace_icc_profile_deletePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// Byte* sk_colorspace_icc_profile_get_buffer(sk_colorspace_icc_profile_t profile, UInt32* size)
  ffi.Pointer<ffi.Uint8> sk_colorspace_icc_profile_get_buffer(
    ffi.Pointer<ffi.Void> profile,
    ffi.Pointer<ffi.Uint32> size,
  ) {
    return _sk_colorspace_icc_profile_get_buffer(
      profile,
      size,
    );
  }

  late final _sk_colorspace_icc_profile_get_bufferPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Uint8> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint32>)>>('sk_colorspace_icc_profile_get_buffer');
  late final _sk_colorspace_icc_profile_get_buffer =
      _sk_colorspace_icc_profile_get_bufferPtr.asFunction<ffi.Pointer<ffi.Uint8> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint32>)>();

  /// bool sk_colorspace_icc_profile_get_to_xyzd50(sk_colorspace_icc_profile_t profile, SKColorSpaceXyz* toXYZD50)
  bool sk_colorspace_icc_profile_get_to_xyzd50(
    ffi.Pointer<ffi.Void> profile,
    ffi.Pointer<ffi.Void> toXYZD50,
  ) {
    return _sk_colorspace_icc_profile_get_to_xyzd50(
      profile,
      toXYZD50,
    );
  }

  late final _sk_colorspace_icc_profile_get_to_xyzd50Ptr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_colorspace_icc_profile_get_to_xyzd50');
  late final _sk_colorspace_icc_profile_get_to_xyzd50 =
      _sk_colorspace_icc_profile_get_to_xyzd50Ptr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_colorspace_icc_profile_t sk_colorspace_icc_profile_new()
  ffi.Pointer<ffi.Void> sk_colorspace_icc_profile_new() {
    return _sk_colorspace_icc_profile_new();
  }

  late final _sk_colorspace_icc_profile_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_colorspace_icc_profile_new');
  late final _sk_colorspace_icc_profile_new =
      _sk_colorspace_icc_profile_newPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// bool sk_colorspace_icc_profile_parse(void* buffer, IntPtr length, sk_colorspace_icc_profile_t profile)
  bool sk_colorspace_icc_profile_parse(
    ffi.Pointer<ffi.Void> buffer,
    ffi.Pointer<ffi.Void> length,
    ffi.Pointer<ffi.Void> profile,
  ) {
    return _sk_colorspace_icc_profile_parse(
      buffer,
      length,
      profile,
    );
  }

  late final _sk_colorspace_icc_profile_parsePtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_colorspace_icc_profile_parse');
  late final _sk_colorspace_icc_profile_parse =
      _sk_colorspace_icc_profile_parsePtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_colorspace_is_numerical_transfer_fn(sk_colorspace_t colorspace, SKColorSpaceTransferFn* transferFn)
  bool sk_colorspace_is_numerical_transfer_fn(
    ffi.Pointer<ffi.Void> colorspace,
    ffi.Pointer<ffi.Void> transferFn,
  ) {
    return _sk_colorspace_is_numerical_transfer_fn(
      colorspace,
      transferFn,
    );
  }

  late final _sk_colorspace_is_numerical_transfer_fnPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_colorspace_is_numerical_transfer_fn');
  late final _sk_colorspace_is_numerical_transfer_fn =
      _sk_colorspace_is_numerical_transfer_fnPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_colorspace_is_srgb(sk_colorspace_t colorspace)
  bool sk_colorspace_is_srgb(
    ffi.Pointer<ffi.Void> colorspace,
  ) {
    return _sk_colorspace_is_srgb(
      colorspace,
    );
  }

  late final _sk_colorspace_is_srgbPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_colorspace_is_srgb');
  late final _sk_colorspace_is_srgb =
      _sk_colorspace_is_srgbPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// sk_colorspace_t sk_colorspace_make_linear_gamma(sk_colorspace_t colorspace)
  ffi.Pointer<ffi.Void> sk_colorspace_make_linear_gamma(
    ffi.Pointer<ffi.Void> colorspace,
  ) {
    return _sk_colorspace_make_linear_gamma(
      colorspace,
    );
  }

  late final _sk_colorspace_make_linear_gammaPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_colorspace_make_linear_gamma');
  late final _sk_colorspace_make_linear_gamma =
      _sk_colorspace_make_linear_gammaPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_colorspace_t sk_colorspace_make_srgb_gamma(sk_colorspace_t colorspace)
  ffi.Pointer<ffi.Void> sk_colorspace_make_srgb_gamma(
    ffi.Pointer<ffi.Void> colorspace,
  ) {
    return _sk_colorspace_make_srgb_gamma(
      colorspace,
    );
  }

  late final _sk_colorspace_make_srgb_gammaPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_colorspace_make_srgb_gamma');
  late final _sk_colorspace_make_srgb_gamma =
      _sk_colorspace_make_srgb_gammaPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_colorspace_t sk_colorspace_new_icc(sk_colorspace_icc_profile_t profile)
  ffi.Pointer<ffi.Void> sk_colorspace_new_icc(
    ffi.Pointer<ffi.Void> profile,
  ) {
    return _sk_colorspace_new_icc(
      profile,
    );
  }

  late final _sk_colorspace_new_iccPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_colorspace_new_icc');
  late final _sk_colorspace_new_icc =
      _sk_colorspace_new_iccPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_colorspace_t sk_colorspace_new_rgb(SKColorSpaceTransferFn* transferFn, SKColorSpaceXyz* toXYZD50)
  ffi.Pointer<ffi.Void> sk_colorspace_new_rgb(
    ffi.Pointer<ffi.Void> transferFn,
    ffi.Pointer<ffi.Void> toXYZD50,
  ) {
    return _sk_colorspace_new_rgb(
      transferFn,
      toXYZD50,
    );
  }

  late final _sk_colorspace_new_rgbPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_colorspace_new_rgb');
  late final _sk_colorspace_new_rgb =
      _sk_colorspace_new_rgbPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_colorspace_t sk_colorspace_new_srgb()
  ffi.Pointer<ffi.Void> sk_colorspace_new_srgb() {
    return _sk_colorspace_new_srgb();
  }

  late final _sk_colorspace_new_srgbPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_colorspace_new_srgb');
  late final _sk_colorspace_new_srgb =
      _sk_colorspace_new_srgbPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// sk_colorspace_t sk_colorspace_new_srgb_linear()
  ffi.Pointer<ffi.Void> sk_colorspace_new_srgb_linear() {
    return _sk_colorspace_new_srgb_linear();
  }

  late final _sk_colorspace_new_srgb_linearPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_colorspace_new_srgb_linear');
  late final _sk_colorspace_new_srgb_linear =
      _sk_colorspace_new_srgb_linearPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// bool sk_colorspace_primaries_to_xyzd50(SKColorSpacePrimaries* primaries, SKColorSpaceXyz* toXYZD50)
  bool sk_colorspace_primaries_to_xyzd50(
    ffi.Pointer<ffi.Void> primaries,
    ffi.Pointer<ffi.Void> toXYZD50,
  ) {
    return _sk_colorspace_primaries_to_xyzd50(
      primaries,
      toXYZD50,
    );
  }

  late final _sk_colorspace_primaries_to_xyzd50Ptr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_colorspace_primaries_to_xyzd50');
  late final _sk_colorspace_primaries_to_xyzd50 =
      _sk_colorspace_primaries_to_xyzd50Ptr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_colorspace_ref(sk_colorspace_t colorspace)
  void sk_colorspace_ref(
    ffi.Pointer<ffi.Void> colorspace,
  ) {
    return _sk_colorspace_ref(
      colorspace,
    );
  }

  late final _sk_colorspace_refPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_colorspace_ref');
  late final _sk_colorspace_ref =
      _sk_colorspace_refPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_colorspace_to_profile(sk_colorspace_t colorspace, sk_colorspace_icc_profile_t profile)
  void sk_colorspace_to_profile(
    ffi.Pointer<ffi.Void> colorspace,
    ffi.Pointer<ffi.Void> profile,
  ) {
    return _sk_colorspace_to_profile(
      colorspace,
      profile,
    );
  }

  late final _sk_colorspace_to_profilePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_colorspace_to_profile');
  late final _sk_colorspace_to_profile =
      _sk_colorspace_to_profilePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_colorspace_to_xyzd50(sk_colorspace_t colorspace, SKColorSpaceXyz* toXYZD50)
  bool sk_colorspace_to_xyzd50(
    ffi.Pointer<ffi.Void> colorspace,
    ffi.Pointer<ffi.Void> toXYZD50,
  ) {
    return _sk_colorspace_to_xyzd50(
      colorspace,
      toXYZD50,
    );
  }

  late final _sk_colorspace_to_xyzd50Ptr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_colorspace_to_xyzd50');
  late final _sk_colorspace_to_xyzd50 =
      _sk_colorspace_to_xyzd50Ptr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// Single sk_colorspace_transfer_fn_eval(SKColorSpaceTransferFn* transferFn, Single x)
  double sk_colorspace_transfer_fn_eval(
    ffi.Pointer<ffi.Void> transferFn,
    double x,
  ) {
    return _sk_colorspace_transfer_fn_eval(
      transferFn,
      x,
    );
  }

  late final _sk_colorspace_transfer_fn_evalPtr = _lookup<
      ffi.NativeFunction<ffi.Float Function(ffi.Pointer<ffi.Void>, ffi.Float)>>('sk_colorspace_transfer_fn_eval');
  late final _sk_colorspace_transfer_fn_eval =
      _sk_colorspace_transfer_fn_evalPtr.asFunction<double Function(ffi.Pointer<ffi.Void>, double)>();

  /// bool sk_colorspace_transfer_fn_invert(SKColorSpaceTransferFn* src, SKColorSpaceTransferFn* dst)
  bool sk_colorspace_transfer_fn_invert(
    ffi.Pointer<ffi.Void> src,
    ffi.Pointer<ffi.Void> dst,
  ) {
    return _sk_colorspace_transfer_fn_invert(
      src,
      dst,
    );
  }

  late final _sk_colorspace_transfer_fn_invertPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_colorspace_transfer_fn_invert');
  late final _sk_colorspace_transfer_fn_invert =
      _sk_colorspace_transfer_fn_invertPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_colorspace_transfer_fn_named_2dot2(SKColorSpaceTransferFn* transferFn)
  void sk_colorspace_transfer_fn_named_2dot2(
    ffi.Pointer<ffi.Void> transferFn,
  ) {
    return _sk_colorspace_transfer_fn_named_2dot2(
      transferFn,
    );
  }

  late final _sk_colorspace_transfer_fn_named_2dot2Ptr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_colorspace_transfer_fn_named_2dot2');
  late final _sk_colorspace_transfer_fn_named_2dot2 =
      _sk_colorspace_transfer_fn_named_2dot2Ptr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_colorspace_transfer_fn_named_hlg(SKColorSpaceTransferFn* transferFn)
  void sk_colorspace_transfer_fn_named_hlg(
    ffi.Pointer<ffi.Void> transferFn,
  ) {
    return _sk_colorspace_transfer_fn_named_hlg(
      transferFn,
    );
  }

  late final _sk_colorspace_transfer_fn_named_hlgPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_colorspace_transfer_fn_named_hlg');
  late final _sk_colorspace_transfer_fn_named_hlg =
      _sk_colorspace_transfer_fn_named_hlgPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_colorspace_transfer_fn_named_linear(SKColorSpaceTransferFn* transferFn)
  void sk_colorspace_transfer_fn_named_linear(
    ffi.Pointer<ffi.Void> transferFn,
  ) {
    return _sk_colorspace_transfer_fn_named_linear(
      transferFn,
    );
  }

  late final _sk_colorspace_transfer_fn_named_linearPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_colorspace_transfer_fn_named_linear');
  late final _sk_colorspace_transfer_fn_named_linear =
      _sk_colorspace_transfer_fn_named_linearPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_colorspace_transfer_fn_named_pq(SKColorSpaceTransferFn* transferFn)
  void sk_colorspace_transfer_fn_named_pq(
    ffi.Pointer<ffi.Void> transferFn,
  ) {
    return _sk_colorspace_transfer_fn_named_pq(
      transferFn,
    );
  }

  late final _sk_colorspace_transfer_fn_named_pqPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_colorspace_transfer_fn_named_pq');
  late final _sk_colorspace_transfer_fn_named_pq =
      _sk_colorspace_transfer_fn_named_pqPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_colorspace_transfer_fn_named_rec2020(SKColorSpaceTransferFn* transferFn)
  void sk_colorspace_transfer_fn_named_rec2020(
    ffi.Pointer<ffi.Void> transferFn,
  ) {
    return _sk_colorspace_transfer_fn_named_rec2020(
      transferFn,
    );
  }

  late final _sk_colorspace_transfer_fn_named_rec2020Ptr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_colorspace_transfer_fn_named_rec2020');
  late final _sk_colorspace_transfer_fn_named_rec2020 =
      _sk_colorspace_transfer_fn_named_rec2020Ptr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_colorspace_transfer_fn_named_srgb(SKColorSpaceTransferFn* transferFn)
  void sk_colorspace_transfer_fn_named_srgb(
    ffi.Pointer<ffi.Void> transferFn,
  ) {
    return _sk_colorspace_transfer_fn_named_srgb(
      transferFn,
    );
  }

  late final _sk_colorspace_transfer_fn_named_srgbPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_colorspace_transfer_fn_named_srgb');
  late final _sk_colorspace_transfer_fn_named_srgb =
      _sk_colorspace_transfer_fn_named_srgbPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_colorspace_unref(sk_colorspace_t colorspace)
  void sk_colorspace_unref(
    ffi.Pointer<ffi.Void> colorspace,
  ) {
    return _sk_colorspace_unref(
      colorspace,
    );
  }

  late final _sk_colorspace_unrefPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_colorspace_unref');
  late final _sk_colorspace_unref =
      _sk_colorspace_unrefPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_colorspace_xyz_concat(SKColorSpaceXyz* a, SKColorSpaceXyz* b, SKColorSpaceXyz* result)
  void sk_colorspace_xyz_concat(
    ffi.Pointer<ffi.Void> a,
    ffi.Pointer<ffi.Void> b,
    ffi.Pointer<ffi.Void> result,
  ) {
    return _sk_colorspace_xyz_concat(
      a,
      b,
      result,
    );
  }

  late final _sk_colorspace_xyz_concatPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_colorspace_xyz_concat');
  late final _sk_colorspace_xyz_concat =
      _sk_colorspace_xyz_concatPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_colorspace_xyz_invert(SKColorSpaceXyz* src, SKColorSpaceXyz* dst)
  bool sk_colorspace_xyz_invert(
    ffi.Pointer<ffi.Void> src,
    ffi.Pointer<ffi.Void> dst,
  ) {
    return _sk_colorspace_xyz_invert(
      src,
      dst,
    );
  }

  late final _sk_colorspace_xyz_invertPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_colorspace_xyz_invert');
  late final _sk_colorspace_xyz_invert =
      _sk_colorspace_xyz_invertPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_colorspace_xyz_named_adobe_rgb(SKColorSpaceXyz* xyz)
  void sk_colorspace_xyz_named_adobe_rgb(
    ffi.Pointer<ffi.Void> xyz,
  ) {
    return _sk_colorspace_xyz_named_adobe_rgb(
      xyz,
    );
  }

  late final _sk_colorspace_xyz_named_adobe_rgbPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_colorspace_xyz_named_adobe_rgb');
  late final _sk_colorspace_xyz_named_adobe_rgb =
      _sk_colorspace_xyz_named_adobe_rgbPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_colorspace_xyz_named_display_p3(SKColorSpaceXyz* xyz)
  void sk_colorspace_xyz_named_display_p3(
    ffi.Pointer<ffi.Void> xyz,
  ) {
    return _sk_colorspace_xyz_named_display_p3(
      xyz,
    );
  }

  late final _sk_colorspace_xyz_named_display_p3Ptr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_colorspace_xyz_named_display_p3');
  late final _sk_colorspace_xyz_named_display_p3 =
      _sk_colorspace_xyz_named_display_p3Ptr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_colorspace_xyz_named_rec2020(SKColorSpaceXyz* xyz)
  void sk_colorspace_xyz_named_rec2020(
    ffi.Pointer<ffi.Void> xyz,
  ) {
    return _sk_colorspace_xyz_named_rec2020(
      xyz,
    );
  }

  late final _sk_colorspace_xyz_named_rec2020Ptr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_colorspace_xyz_named_rec2020');
  late final _sk_colorspace_xyz_named_rec2020 =
      _sk_colorspace_xyz_named_rec2020Ptr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_colorspace_xyz_named_srgb(SKColorSpaceXyz* xyz)
  void sk_colorspace_xyz_named_srgb(
    ffi.Pointer<ffi.Void> xyz,
  ) {
    return _sk_colorspace_xyz_named_srgb(
      xyz,
    );
  }

  late final _sk_colorspace_xyz_named_srgbPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_colorspace_xyz_named_srgb');
  late final _sk_colorspace_xyz_named_srgb =
      _sk_colorspace_xyz_named_srgbPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_colorspace_xyz_named_xyz(SKColorSpaceXyz* xyz)
  void sk_colorspace_xyz_named_xyz(
    ffi.Pointer<ffi.Void> xyz,
  ) {
    return _sk_colorspace_xyz_named_xyz(
      xyz,
    );
  }

  late final _sk_colorspace_xyz_named_xyzPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_colorspace_xyz_named_xyz');
  late final _sk_colorspace_xyz_named_xyz =
      _sk_colorspace_xyz_named_xyzPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// Byte* sk_data_get_bytes(sk_data_t param0)
  ffi.Pointer<ffi.Uint8> sk_data_get_bytes(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_data_get_bytes(
      param0,
    );
  }

  late final _sk_data_get_bytesPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Uint8> Function(ffi.Pointer<ffi.Void>)>>('sk_data_get_bytes');
  late final _sk_data_get_bytes =
      _sk_data_get_bytesPtr.asFunction<ffi.Pointer<ffi.Uint8> Function(ffi.Pointer<ffi.Void>)>();

  /// void* sk_data_get_data(sk_data_t param0)
  ffi.Pointer<ffi.Void> sk_data_get_data(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_data_get_data(
      param0,
    );
  }

  late final _sk_data_get_dataPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_data_get_data');
  late final _sk_data_get_data =
      _sk_data_get_dataPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// IntPtr sk_data_get_size(sk_data_t param0)
  ffi.Pointer<ffi.Void> sk_data_get_size(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_data_get_size(
      param0,
    );
  }

  late final _sk_data_get_sizePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_data_get_size');
  late final _sk_data_get_size =
      _sk_data_get_sizePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_data_t sk_data_new_empty()
  ffi.Pointer<ffi.Void> sk_data_new_empty() {
    return _sk_data_new_empty();
  }

  late final _sk_data_new_emptyPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_data_new_empty');
  late final _sk_data_new_empty =
      _sk_data_new_emptyPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// sk_data_t sk_data_new_from_file(void* path)
  ffi.Pointer<ffi.Void> sk_data_new_from_file(
    ffi.Pointer<ffi.Void> path,
  ) {
    return _sk_data_new_from_file(
      path,
    );
  }

  late final _sk_data_new_from_filePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_data_new_from_file');
  late final _sk_data_new_from_file =
      _sk_data_new_from_filePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_data_t sk_data_new_from_stream(sk_stream_t stream, IntPtr length)
  ffi.Pointer<ffi.Void> sk_data_new_from_stream(
    ffi.Pointer<ffi.Void> stream,
    ffi.Pointer<ffi.Void> length,
  ) {
    return _sk_data_new_from_stream(
      stream,
      length,
    );
  }

  late final _sk_data_new_from_streamPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_data_new_from_stream');
  late final _sk_data_new_from_stream =
      _sk_data_new_from_streamPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_data_t sk_data_new_subset(sk_data_t src, IntPtr offset, IntPtr length)
  ffi.Pointer<ffi.Void> sk_data_new_subset(
    ffi.Pointer<ffi.Void> src,
    ffi.Pointer<ffi.Void> offset,
    ffi.Pointer<ffi.Void> length,
  ) {
    return _sk_data_new_subset(
      src,
      offset,
      length,
    );
  }

  late final _sk_data_new_subsetPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_data_new_subset');
  late final _sk_data_new_subset =
      _sk_data_new_subsetPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_data_t sk_data_new_uninitialized(IntPtr size)
  ffi.Pointer<ffi.Void> sk_data_new_uninitialized(
    ffi.Pointer<ffi.Void> size,
  ) {
    return _sk_data_new_uninitialized(
      size,
    );
  }

  late final _sk_data_new_uninitializedPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_data_new_uninitialized');
  late final _sk_data_new_uninitialized =
      _sk_data_new_uninitializedPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_data_t sk_data_new_with_copy(void* src, IntPtr length)
  ffi.Pointer<ffi.Void> sk_data_new_with_copy(
    ffi.Pointer<ffi.Void> src,
    ffi.Pointer<ffi.Void> length,
  ) {
    return _sk_data_new_with_copy(
      src,
      length,
    );
  }

  late final _sk_data_new_with_copyPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_data_new_with_copy');
  late final _sk_data_new_with_copy =
      _sk_data_new_with_copyPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_data_t sk_data_new_with_proc(void* ptr, IntPtr length, void* proc, void* ctx)
  ffi.Pointer<ffi.Void> sk_data_new_with_proc(
    ffi.Pointer<ffi.Void> ptr,
    ffi.Pointer<ffi.Void> length,
    ffi.Pointer<ffi.Void> proc,
    ffi.Pointer<ffi.Void> ctx,
  ) {
    return _sk_data_new_with_proc(
      ptr,
      length,
      proc,
      ctx,
    );
  }

  late final _sk_data_new_with_procPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_data_new_with_proc');
  late final _sk_data_new_with_proc =
      _sk_data_new_with_procPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_data_ref(sk_data_t param0)
  void sk_data_ref(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_data_ref(
      param0,
    );
  }

  late final _sk_data_refPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_data_ref');
  late final _sk_data_ref =
      _sk_data_refPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_data_unref(sk_data_t param0)
  void sk_data_unref(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_data_unref(
      param0,
    );
  }

  late final _sk_data_unrefPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_data_unref');
  late final _sk_data_unref =
      _sk_data_unrefPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_document_abort(sk_document_t document)
  void sk_document_abort(
    ffi.Pointer<ffi.Void> document,
  ) {
    return _sk_document_abort(
      document,
    );
  }

  late final _sk_document_abortPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_document_abort');
  late final _sk_document_abort =
      _sk_document_abortPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// sk_canvas_t sk_document_begin_page(sk_document_t document, Single width, Single height, SKRect* content)
  ffi.Pointer<ffi.Void> sk_document_begin_page(
    ffi.Pointer<ffi.Void> document,
    double width,
    double height,
    ffi.Pointer<ffi.Void> content,
  ) {
    return _sk_document_begin_page(
      document,
      width,
      height,
      content,
    );
  }

  late final _sk_document_begin_pagePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>)>>('sk_document_begin_page');
  late final _sk_document_begin_page =
      _sk_document_begin_pagePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, double, double, ffi.Pointer<ffi.Void>)>();

  /// void sk_document_close(sk_document_t document)
  void sk_document_close(
    ffi.Pointer<ffi.Void> document,
  ) {
    return _sk_document_close(
      document,
    );
  }

  late final _sk_document_closePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_document_close');
  late final _sk_document_close =
      _sk_document_closePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// sk_document_t sk_document_create_pdf_from_stream(sk_wstream_t stream)
  ffi.Pointer<ffi.Void> sk_document_create_pdf_from_stream(
    ffi.Pointer<ffi.Void> stream,
  ) {
    return _sk_document_create_pdf_from_stream(
      stream,
    );
  }

  late final _sk_document_create_pdf_from_streamPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_document_create_pdf_from_stream');
  late final _sk_document_create_pdf_from_stream =
      _sk_document_create_pdf_from_streamPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_document_t sk_document_create_pdf_from_stream_with_metadata(sk_wstream_t stream, SKDocumentPdfMetadataInternal* metadata)
  ffi.Pointer<ffi.Void> sk_document_create_pdf_from_stream_with_metadata(
    ffi.Pointer<ffi.Void> stream,
    ffi.Pointer<ffi.Void> metadata,
  ) {
    return _sk_document_create_pdf_from_stream_with_metadata(
      stream,
      metadata,
    );
  }

  late final _sk_document_create_pdf_from_stream_with_metadataPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_document_create_pdf_from_stream_with_metadata');
  late final _sk_document_create_pdf_from_stream_with_metadata =
      _sk_document_create_pdf_from_stream_with_metadataPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_document_t sk_document_create_xps_from_stream(sk_wstream_t stream, Single dpi)
  ffi.Pointer<ffi.Void> sk_document_create_xps_from_stream(
    ffi.Pointer<ffi.Void> stream,
    double dpi,
  ) {
    return _sk_document_create_xps_from_stream(
      stream,
      dpi,
    );
  }

  late final _sk_document_create_xps_from_streamPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Float)>>('sk_document_create_xps_from_stream');
  late final _sk_document_create_xps_from_stream =
      _sk_document_create_xps_from_streamPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, double)>();

  /// void sk_document_end_page(sk_document_t document)
  void sk_document_end_page(
    ffi.Pointer<ffi.Void> document,
  ) {
    return _sk_document_end_page(
      document,
    );
  }

  late final _sk_document_end_pagePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_document_end_page');
  late final _sk_document_end_page =
      _sk_document_end_pagePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_document_unref(sk_document_t document)
  void sk_document_unref(
    ffi.Pointer<ffi.Void> document,
  ) {
    return _sk_document_unref(
      document,
    );
  }

  late final _sk_document_unrefPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_document_unref');
  late final _sk_document_unref =
      _sk_document_unrefPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// IntPtr sk_drawable_approximate_bytes_used(sk_drawable_t param0)
  ffi.Pointer<ffi.Void> sk_drawable_approximate_bytes_used(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_drawable_approximate_bytes_used(
      param0,
    );
  }

  late final _sk_drawable_approximate_bytes_usedPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_drawable_approximate_bytes_used');
  late final _sk_drawable_approximate_bytes_used =
      _sk_drawable_approximate_bytes_usedPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_drawable_draw(sk_drawable_t param0, sk_canvas_t param1, SKMatrix* param2)
  void sk_drawable_draw(
    ffi.Pointer<ffi.Void> param0,
    ffi.Pointer<ffi.Void> param1,
    ffi.Pointer<ffi.Void> param2,
  ) {
    return _sk_drawable_draw(
      param0,
      param1,
      param2,
    );
  }

  late final _sk_drawable_drawPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_drawable_draw');
  late final _sk_drawable_draw =
      _sk_drawable_drawPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_drawable_get_bounds(sk_drawable_t param0, SKRect* param1)
  void sk_drawable_get_bounds(
    ffi.Pointer<ffi.Void> param0,
    ffi.Pointer<ffi.Void> param1,
  ) {
    return _sk_drawable_get_bounds(
      param0,
      param1,
    );
  }

  late final _sk_drawable_get_boundsPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_drawable_get_bounds');
  late final _sk_drawable_get_bounds =
      _sk_drawable_get_boundsPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// UInt32 sk_drawable_get_generation_id(sk_drawable_t param0)
  int sk_drawable_get_generation_id(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_drawable_get_generation_id(
      param0,
    );
  }

  late final _sk_drawable_get_generation_idPtr = _lookup<
      ffi.NativeFunction<ffi.Uint32 Function(ffi.Pointer<ffi.Void>)>>('sk_drawable_get_generation_id');
  late final _sk_drawable_get_generation_id =
      _sk_drawable_get_generation_idPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// sk_picture_t sk_drawable_new_picture_snapshot(sk_drawable_t param0)
  ffi.Pointer<ffi.Void> sk_drawable_new_picture_snapshot(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_drawable_new_picture_snapshot(
      param0,
    );
  }

  late final _sk_drawable_new_picture_snapshotPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_drawable_new_picture_snapshot');
  late final _sk_drawable_new_picture_snapshot =
      _sk_drawable_new_picture_snapshotPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_drawable_notify_drawing_changed(sk_drawable_t param0)
  void sk_drawable_notify_drawing_changed(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_drawable_notify_drawing_changed(
      param0,
    );
  }

  late final _sk_drawable_notify_drawing_changedPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_drawable_notify_drawing_changed');
  late final _sk_drawable_notify_drawing_changed =
      _sk_drawable_notify_drawing_changedPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_drawable_unref(sk_drawable_t param0)
  void sk_drawable_unref(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_drawable_unref(
      param0,
    );
  }

  late final _sk_drawable_unrefPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_drawable_unref');
  late final _sk_drawable_unref =
      _sk_drawable_unrefPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// IntPtr sk_font_break_text(sk_font_t font, void* text, IntPtr byteLength, SKTextEncoding encoding, Single maxWidth, Single* measuredWidth, sk_paint_t paint)
  ffi.Pointer<ffi.Void> sk_font_break_text(
    ffi.Pointer<ffi.Void> font,
    ffi.Pointer<ffi.Void> text,
    ffi.Pointer<ffi.Void> byteLength,
    int encoding,
    double maxWidth,
    ffi.Pointer<ffi.Float> measuredWidth,
    ffi.Pointer<ffi.Void> paint,
  ) {
    return _sk_font_break_text(
      font,
      text,
      byteLength,
      encoding,
      maxWidth,
      measuredWidth,
      paint,
    );
  }

  late final _sk_font_break_textPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Float, ffi.Pointer<ffi.Float>, ffi.Pointer<ffi.Void>)>>('sk_font_break_text');
  late final _sk_font_break_text =
      _sk_font_break_textPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, double, ffi.Pointer<ffi.Float>, ffi.Pointer<ffi.Void>)>();

  /// void sk_font_delete(sk_font_t font)
  void sk_font_delete(
    ffi.Pointer<ffi.Void> font,
  ) {
    return _sk_font_delete(
      font,
    );
  }

  late final _sk_font_deletePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_font_delete');
  late final _sk_font_delete =
      _sk_font_deletePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// SKFontEdging sk_font_get_edging(sk_font_t font)
  ffi.Pointer<ffi.Void> sk_font_get_edging(
    ffi.Pointer<ffi.Void> font,
  ) {
    return _sk_font_get_edging(
      font,
    );
  }

  late final _sk_font_get_edgingPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_font_get_edging');
  late final _sk_font_get_edging =
      _sk_font_get_edgingPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// SKFontHinting sk_font_get_hinting(sk_font_t font)
  ffi.Pointer<ffi.Void> sk_font_get_hinting(
    ffi.Pointer<ffi.Void> font,
  ) {
    return _sk_font_get_hinting(
      font,
    );
  }

  late final _sk_font_get_hintingPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_font_get_hinting');
  late final _sk_font_get_hinting =
      _sk_font_get_hintingPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// Single sk_font_get_metrics(sk_font_t font, SKFontMetrics* metrics)
  double sk_font_get_metrics(
    ffi.Pointer<ffi.Void> font,
    ffi.Pointer<ffi.Void> metrics,
  ) {
    return _sk_font_get_metrics(
      font,
      metrics,
    );
  }

  late final _sk_font_get_metricsPtr = _lookup<
      ffi.NativeFunction<ffi.Float Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_font_get_metrics');
  late final _sk_font_get_metrics =
      _sk_font_get_metricsPtr.asFunction<double Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_font_get_path(sk_font_t font, UInt16 glyph, sk_path_t path)
  bool sk_font_get_path(
    ffi.Pointer<ffi.Void> font,
    int glyph,
    ffi.Pointer<ffi.Void> path,
  ) {
    return _sk_font_get_path(
      font,
      glyph,
      path,
    );
  }

  late final _sk_font_get_pathPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Uint16, ffi.Pointer<ffi.Void>)>>('sk_font_get_path');
  late final _sk_font_get_path =
      _sk_font_get_pathPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>)>();

  /// void sk_font_get_paths(sk_font_t font, UInt16* glyphs, Int32 count, void* glyphPathProc, void* context)
  void sk_font_get_paths(
    ffi.Pointer<ffi.Void> font,
    ffi.Pointer<ffi.Uint16> glyphs,
    int count,
    ffi.Pointer<ffi.Void> glyphPathProc,
    ffi.Pointer<ffi.Void> context,
  ) {
    return _sk_font_get_paths(
      font,
      glyphs,
      count,
      glyphPathProc,
      context,
    );
  }

  late final _sk_font_get_pathsPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint16>, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_font_get_paths');
  late final _sk_font_get_paths =
      _sk_font_get_pathsPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint16>, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_font_get_pos(sk_font_t font, UInt16* glyphs, Int32 count, SKPoint* pos, SKPoint* origin)
  void sk_font_get_pos(
    ffi.Pointer<ffi.Void> font,
    ffi.Pointer<ffi.Uint16> glyphs,
    int count,
    ffi.Pointer<ffi.Void> pos,
    ffi.Pointer<ffi.Void> origin,
  ) {
    return _sk_font_get_pos(
      font,
      glyphs,
      count,
      pos,
      origin,
    );
  }

  late final _sk_font_get_posPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint16>, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_font_get_pos');
  late final _sk_font_get_pos =
      _sk_font_get_posPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint16>, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// Single sk_font_get_scale_x(sk_font_t font)
  double sk_font_get_scale_x(
    ffi.Pointer<ffi.Void> font,
  ) {
    return _sk_font_get_scale_x(
      font,
    );
  }

  late final _sk_font_get_scale_xPtr = _lookup<
      ffi.NativeFunction<ffi.Float Function(ffi.Pointer<ffi.Void>)>>('sk_font_get_scale_x');
  late final _sk_font_get_scale_x =
      _sk_font_get_scale_xPtr.asFunction<double Function(ffi.Pointer<ffi.Void>)>();

  /// Single sk_font_get_size(sk_font_t font)
  double sk_font_get_size(
    ffi.Pointer<ffi.Void> font,
  ) {
    return _sk_font_get_size(
      font,
    );
  }

  late final _sk_font_get_sizePtr = _lookup<
      ffi.NativeFunction<ffi.Float Function(ffi.Pointer<ffi.Void>)>>('sk_font_get_size');
  late final _sk_font_get_size =
      _sk_font_get_sizePtr.asFunction<double Function(ffi.Pointer<ffi.Void>)>();

  /// Single sk_font_get_skew_x(sk_font_t font)
  double sk_font_get_skew_x(
    ffi.Pointer<ffi.Void> font,
  ) {
    return _sk_font_get_skew_x(
      font,
    );
  }

  late final _sk_font_get_skew_xPtr = _lookup<
      ffi.NativeFunction<ffi.Float Function(ffi.Pointer<ffi.Void>)>>('sk_font_get_skew_x');
  late final _sk_font_get_skew_x =
      _sk_font_get_skew_xPtr.asFunction<double Function(ffi.Pointer<ffi.Void>)>();

  /// sk_typeface_t sk_font_get_typeface(sk_font_t font)
  ffi.Pointer<ffi.Void> sk_font_get_typeface(
    ffi.Pointer<ffi.Void> font,
  ) {
    return _sk_font_get_typeface(
      font,
    );
  }

  late final _sk_font_get_typefacePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_font_get_typeface');
  late final _sk_font_get_typeface =
      _sk_font_get_typefacePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_font_get_widths_bounds(sk_font_t font, UInt16* glyphs, Int32 count, Single* widths, SKRect* bounds, sk_paint_t paint)
  void sk_font_get_widths_bounds(
    ffi.Pointer<ffi.Void> font,
    ffi.Pointer<ffi.Uint16> glyphs,
    int count,
    ffi.Pointer<ffi.Float> widths,
    ffi.Pointer<ffi.Void> bounds,
    ffi.Pointer<ffi.Void> paint,
  ) {
    return _sk_font_get_widths_bounds(
      font,
      glyphs,
      count,
      widths,
      bounds,
      paint,
    );
  }

  late final _sk_font_get_widths_boundsPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint16>, ffi.Int32, ffi.Pointer<ffi.Float>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_font_get_widths_bounds');
  late final _sk_font_get_widths_bounds =
      _sk_font_get_widths_boundsPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint16>, int, ffi.Pointer<ffi.Float>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_font_get_xpos(sk_font_t font, UInt16* glyphs, Int32 count, Single* xpos, Single origin)
  void sk_font_get_xpos(
    ffi.Pointer<ffi.Void> font,
    ffi.Pointer<ffi.Uint16> glyphs,
    int count,
    ffi.Pointer<ffi.Float> xpos,
    double origin,
  ) {
    return _sk_font_get_xpos(
      font,
      glyphs,
      count,
      xpos,
      origin,
    );
  }

  late final _sk_font_get_xposPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint16>, ffi.Int32, ffi.Pointer<ffi.Float>, ffi.Float)>>('sk_font_get_xpos');
  late final _sk_font_get_xpos =
      _sk_font_get_xposPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint16>, int, ffi.Pointer<ffi.Float>, double)>();

  /// bool sk_font_is_baseline_snap(sk_font_t font)
  bool sk_font_is_baseline_snap(
    ffi.Pointer<ffi.Void> font,
  ) {
    return _sk_font_is_baseline_snap(
      font,
    );
  }

  late final _sk_font_is_baseline_snapPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_font_is_baseline_snap');
  late final _sk_font_is_baseline_snap =
      _sk_font_is_baseline_snapPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_font_is_embedded_bitmaps(sk_font_t font)
  bool sk_font_is_embedded_bitmaps(
    ffi.Pointer<ffi.Void> font,
  ) {
    return _sk_font_is_embedded_bitmaps(
      font,
    );
  }

  late final _sk_font_is_embedded_bitmapsPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_font_is_embedded_bitmaps');
  late final _sk_font_is_embedded_bitmaps =
      _sk_font_is_embedded_bitmapsPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_font_is_embolden(sk_font_t font)
  bool sk_font_is_embolden(
    ffi.Pointer<ffi.Void> font,
  ) {
    return _sk_font_is_embolden(
      font,
    );
  }

  late final _sk_font_is_emboldenPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_font_is_embolden');
  late final _sk_font_is_embolden =
      _sk_font_is_emboldenPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_font_is_force_auto_hinting(sk_font_t font)
  bool sk_font_is_force_auto_hinting(
    ffi.Pointer<ffi.Void> font,
  ) {
    return _sk_font_is_force_auto_hinting(
      font,
    );
  }

  late final _sk_font_is_force_auto_hintingPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_font_is_force_auto_hinting');
  late final _sk_font_is_force_auto_hinting =
      _sk_font_is_force_auto_hintingPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_font_is_linear_metrics(sk_font_t font)
  bool sk_font_is_linear_metrics(
    ffi.Pointer<ffi.Void> font,
  ) {
    return _sk_font_is_linear_metrics(
      font,
    );
  }

  late final _sk_font_is_linear_metricsPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_font_is_linear_metrics');
  late final _sk_font_is_linear_metrics =
      _sk_font_is_linear_metricsPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_font_is_subpixel(sk_font_t font)
  bool sk_font_is_subpixel(
    ffi.Pointer<ffi.Void> font,
  ) {
    return _sk_font_is_subpixel(
      font,
    );
  }

  late final _sk_font_is_subpixelPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_font_is_subpixel');
  late final _sk_font_is_subpixel =
      _sk_font_is_subpixelPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// Single sk_font_measure_text(sk_font_t font, void* text, IntPtr byteLength, SKTextEncoding encoding, SKRect* bounds, sk_paint_t paint)
  double sk_font_measure_text(
    ffi.Pointer<ffi.Void> font,
    ffi.Pointer<ffi.Void> text,
    ffi.Pointer<ffi.Void> byteLength,
    int encoding,
    ffi.Pointer<ffi.Void> bounds,
    ffi.Pointer<ffi.Void> paint,
  ) {
    return _sk_font_measure_text(
      font,
      text,
      byteLength,
      encoding,
      bounds,
      paint,
    );
  }

  late final _sk_font_measure_textPtr = _lookup<
      ffi.NativeFunction<ffi.Float Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_font_measure_text');
  late final _sk_font_measure_text =
      _sk_font_measure_textPtr.asFunction<double Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_font_measure_text_no_return(sk_font_t font, void* text, IntPtr byteLength, SKTextEncoding encoding, SKRect* bounds, sk_paint_t paint, Single* measuredWidth)
  void sk_font_measure_text_no_return(
    ffi.Pointer<ffi.Void> font,
    ffi.Pointer<ffi.Void> text,
    ffi.Pointer<ffi.Void> byteLength,
    int encoding,
    ffi.Pointer<ffi.Void> bounds,
    ffi.Pointer<ffi.Void> paint,
    ffi.Pointer<ffi.Float> measuredWidth,
  ) {
    return _sk_font_measure_text_no_return(
      font,
      text,
      byteLength,
      encoding,
      bounds,
      paint,
      measuredWidth,
    );
  }

  late final _sk_font_measure_text_no_returnPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Float>)>>('sk_font_measure_text_no_return');
  late final _sk_font_measure_text_no_return =
      _sk_font_measure_text_no_returnPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Float>)>();

  /// sk_font_t sk_font_new()
  ffi.Pointer<ffi.Void> sk_font_new() {
    return _sk_font_new();
  }

  late final _sk_font_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_font_new');
  late final _sk_font_new =
      _sk_font_newPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// sk_font_t sk_font_new_with_values(sk_typeface_t typeface, Single size, Single scaleX, Single skewX)
  ffi.Pointer<ffi.Void> sk_font_new_with_values(
    ffi.Pointer<ffi.Void> typeface,
    double size,
    double scaleX,
    double skewX,
  ) {
    return _sk_font_new_with_values(
      typeface,
      size,
      scaleX,
      skewX,
    );
  }

  late final _sk_font_new_with_valuesPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Float)>>('sk_font_new_with_values');
  late final _sk_font_new_with_values =
      _sk_font_new_with_valuesPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, double, double, double)>();

  /// void sk_font_set_baseline_snap(sk_font_t font, bool value)
  void sk_font_set_baseline_snap(
    ffi.Pointer<ffi.Void> font,
    bool value,
  ) {
    return _sk_font_set_baseline_snap(
      font,
      value,
    );
  }

  late final _sk_font_set_baseline_snapPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Bool)>>('sk_font_set_baseline_snap');
  late final _sk_font_set_baseline_snap =
      _sk_font_set_baseline_snapPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, bool)>();

  /// void sk_font_set_edging(sk_font_t font, SKFontEdging value)
  void sk_font_set_edging(
    ffi.Pointer<ffi.Void> font,
    ffi.Pointer<ffi.Void> value,
  ) {
    return _sk_font_set_edging(
      font,
      value,
    );
  }

  late final _sk_font_set_edgingPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_font_set_edging');
  late final _sk_font_set_edging =
      _sk_font_set_edgingPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_font_set_embedded_bitmaps(sk_font_t font, bool value)
  void sk_font_set_embedded_bitmaps(
    ffi.Pointer<ffi.Void> font,
    bool value,
  ) {
    return _sk_font_set_embedded_bitmaps(
      font,
      value,
    );
  }

  late final _sk_font_set_embedded_bitmapsPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Bool)>>('sk_font_set_embedded_bitmaps');
  late final _sk_font_set_embedded_bitmaps =
      _sk_font_set_embedded_bitmapsPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, bool)>();

  /// void sk_font_set_embolden(sk_font_t font, bool value)
  void sk_font_set_embolden(
    ffi.Pointer<ffi.Void> font,
    bool value,
  ) {
    return _sk_font_set_embolden(
      font,
      value,
    );
  }

  late final _sk_font_set_emboldenPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Bool)>>('sk_font_set_embolden');
  late final _sk_font_set_embolden =
      _sk_font_set_emboldenPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, bool)>();

  /// void sk_font_set_force_auto_hinting(sk_font_t font, bool value)
  void sk_font_set_force_auto_hinting(
    ffi.Pointer<ffi.Void> font,
    bool value,
  ) {
    return _sk_font_set_force_auto_hinting(
      font,
      value,
    );
  }

  late final _sk_font_set_force_auto_hintingPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Bool)>>('sk_font_set_force_auto_hinting');
  late final _sk_font_set_force_auto_hinting =
      _sk_font_set_force_auto_hintingPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, bool)>();

  /// void sk_font_set_hinting(sk_font_t font, SKFontHinting value)
  void sk_font_set_hinting(
    ffi.Pointer<ffi.Void> font,
    ffi.Pointer<ffi.Void> value,
  ) {
    return _sk_font_set_hinting(
      font,
      value,
    );
  }

  late final _sk_font_set_hintingPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_font_set_hinting');
  late final _sk_font_set_hinting =
      _sk_font_set_hintingPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_font_set_linear_metrics(sk_font_t font, bool value)
  void sk_font_set_linear_metrics(
    ffi.Pointer<ffi.Void> font,
    bool value,
  ) {
    return _sk_font_set_linear_metrics(
      font,
      value,
    );
  }

  late final _sk_font_set_linear_metricsPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Bool)>>('sk_font_set_linear_metrics');
  late final _sk_font_set_linear_metrics =
      _sk_font_set_linear_metricsPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, bool)>();

  /// void sk_font_set_scale_x(sk_font_t font, Single value)
  void sk_font_set_scale_x(
    ffi.Pointer<ffi.Void> font,
    double value,
  ) {
    return _sk_font_set_scale_x(
      font,
      value,
    );
  }

  late final _sk_font_set_scale_xPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float)>>('sk_font_set_scale_x');
  late final _sk_font_set_scale_x =
      _sk_font_set_scale_xPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double)>();

  /// void sk_font_set_size(sk_font_t font, Single value)
  void sk_font_set_size(
    ffi.Pointer<ffi.Void> font,
    double value,
  ) {
    return _sk_font_set_size(
      font,
      value,
    );
  }

  late final _sk_font_set_sizePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float)>>('sk_font_set_size');
  late final _sk_font_set_size =
      _sk_font_set_sizePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double)>();

  /// void sk_font_set_skew_x(sk_font_t font, Single value)
  void sk_font_set_skew_x(
    ffi.Pointer<ffi.Void> font,
    double value,
  ) {
    return _sk_font_set_skew_x(
      font,
      value,
    );
  }

  late final _sk_font_set_skew_xPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float)>>('sk_font_set_skew_x');
  late final _sk_font_set_skew_x =
      _sk_font_set_skew_xPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double)>();

  /// void sk_font_set_subpixel(sk_font_t font, bool value)
  void sk_font_set_subpixel(
    ffi.Pointer<ffi.Void> font,
    bool value,
  ) {
    return _sk_font_set_subpixel(
      font,
      value,
    );
  }

  late final _sk_font_set_subpixelPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Bool)>>('sk_font_set_subpixel');
  late final _sk_font_set_subpixel =
      _sk_font_set_subpixelPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, bool)>();

  /// void sk_font_set_typeface(sk_font_t font, sk_typeface_t value)
  void sk_font_set_typeface(
    ffi.Pointer<ffi.Void> font,
    ffi.Pointer<ffi.Void> value,
  ) {
    return _sk_font_set_typeface(
      font,
      value,
    );
  }

  late final _sk_font_set_typefacePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_font_set_typeface');
  late final _sk_font_set_typeface =
      _sk_font_set_typefacePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_font_text_to_glyphs(sk_font_t font, void* text, IntPtr byteLength, SKTextEncoding encoding, UInt16* glyphs, Int32 maxGlyphCount)
  int sk_font_text_to_glyphs(
    ffi.Pointer<ffi.Void> font,
    ffi.Pointer<ffi.Void> text,
    ffi.Pointer<ffi.Void> byteLength,
    int encoding,
    ffi.Pointer<ffi.Uint16> glyphs,
    int maxGlyphCount,
  ) {
    return _sk_font_text_to_glyphs(
      font,
      text,
      byteLength,
      encoding,
      glyphs,
      maxGlyphCount,
    );
  }

  late final _sk_font_text_to_glyphsPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Pointer<ffi.Uint16>, ffi.Int32)>>('sk_font_text_to_glyphs');
  late final _sk_font_text_to_glyphs =
      _sk_font_text_to_glyphsPtr.asFunction<int Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Uint16>, int)>();

  /// UInt16 sk_font_unichar_to_glyph(sk_font_t font, Int32 uni)
  int sk_font_unichar_to_glyph(
    ffi.Pointer<ffi.Void> font,
    int uni,
  ) {
    return _sk_font_unichar_to_glyph(
      font,
      uni,
    );
  }

  late final _sk_font_unichar_to_glyphPtr = _lookup<
      ffi.NativeFunction<ffi.Uint16 Function(ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_font_unichar_to_glyph');
  late final _sk_font_unichar_to_glyph =
      _sk_font_unichar_to_glyphPtr.asFunction<int Function(ffi.Pointer<ffi.Void>, int)>();

  /// void sk_font_unichars_to_glyphs(sk_font_t font, Int32* uni, Int32 count, UInt16* glyphs)
  void sk_font_unichars_to_glyphs(
    ffi.Pointer<ffi.Void> font,
    ffi.Pointer<ffi.Int32> uni,
    int count,
    ffi.Pointer<ffi.Uint16> glyphs,
  ) {
    return _sk_font_unichars_to_glyphs(
      font,
      uni,
      count,
      glyphs,
    );
  }

  late final _sk_font_unichars_to_glyphsPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Int32>, ffi.Int32, ffi.Pointer<ffi.Uint16>)>>('sk_font_unichars_to_glyphs');
  late final _sk_font_unichars_to_glyphs =
      _sk_font_unichars_to_glyphsPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Int32>, int, ffi.Pointer<ffi.Uint16>)>();

  /// void sk_text_utils_get_path(void* text, IntPtr length, SKTextEncoding encoding, Single x, Single y, sk_font_t font, sk_path_t path)
  void sk_text_utils_get_path(
    ffi.Pointer<ffi.Void> text,
    ffi.Pointer<ffi.Void> length,
    int encoding,
    double x,
    double y,
    ffi.Pointer<ffi.Void> font,
    ffi.Pointer<ffi.Void> path,
  ) {
    return _sk_text_utils_get_path(
      text,
      length,
      encoding,
      x,
      y,
      font,
      path,
    );
  }

  late final _sk_text_utils_get_pathPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_text_utils_get_path');
  late final _sk_text_utils_get_path =
      _sk_text_utils_get_pathPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, double, double, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_text_utils_get_pos_path(void* text, IntPtr length, SKTextEncoding encoding, SKPoint* pos, sk_font_t font, sk_path_t path)
  void sk_text_utils_get_pos_path(
    ffi.Pointer<ffi.Void> text,
    ffi.Pointer<ffi.Void> length,
    int encoding,
    ffi.Pointer<ffi.Void> pos,
    ffi.Pointer<ffi.Void> font,
    ffi.Pointer<ffi.Void> path,
  ) {
    return _sk_text_utils_get_pos_path(
      text,
      length,
      encoding,
      pos,
      font,
      path,
    );
  }

  late final _sk_text_utils_get_pos_pathPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_text_utils_get_pos_path');
  late final _sk_text_utils_get_pos_path =
      _sk_text_utils_get_pos_pathPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// SKColorTypeNative sk_colortype_get_default_8888()
  int sk_colortype_get_default_8888() {
    return _sk_colortype_get_default_8888();
  }

  late final _sk_colortype_get_default_8888Ptr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function()>>('sk_colortype_get_default_8888');
  late final _sk_colortype_get_default_8888 =
      _sk_colortype_get_default_8888Ptr.asFunction<int Function()>();

  /// Int32 sk_nvrefcnt_get_ref_count(sk_nvrefcnt_t refcnt)
  int sk_nvrefcnt_get_ref_count(
    ffi.Pointer<ffi.Void> refcnt,
  ) {
    return _sk_nvrefcnt_get_ref_count(
      refcnt,
    );
  }

  late final _sk_nvrefcnt_get_ref_countPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_nvrefcnt_get_ref_count');
  late final _sk_nvrefcnt_get_ref_count =
      _sk_nvrefcnt_get_ref_countPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_nvrefcnt_safe_ref(sk_nvrefcnt_t refcnt)
  void sk_nvrefcnt_safe_ref(
    ffi.Pointer<ffi.Void> refcnt,
  ) {
    return _sk_nvrefcnt_safe_ref(
      refcnt,
    );
  }

  late final _sk_nvrefcnt_safe_refPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_nvrefcnt_safe_ref');
  late final _sk_nvrefcnt_safe_ref =
      _sk_nvrefcnt_safe_refPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_nvrefcnt_safe_unref(sk_nvrefcnt_t refcnt)
  void sk_nvrefcnt_safe_unref(
    ffi.Pointer<ffi.Void> refcnt,
  ) {
    return _sk_nvrefcnt_safe_unref(
      refcnt,
    );
  }

  late final _sk_nvrefcnt_safe_unrefPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_nvrefcnt_safe_unref');
  late final _sk_nvrefcnt_safe_unref =
      _sk_nvrefcnt_safe_unrefPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_nvrefcnt_unique(sk_nvrefcnt_t refcnt)
  bool sk_nvrefcnt_unique(
    ffi.Pointer<ffi.Void> refcnt,
  ) {
    return _sk_nvrefcnt_unique(
      refcnt,
    );
  }

  late final _sk_nvrefcnt_uniquePtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_nvrefcnt_unique');
  late final _sk_nvrefcnt_unique =
      _sk_nvrefcnt_uniquePtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_refcnt_get_ref_count(sk_refcnt_t refcnt)
  int sk_refcnt_get_ref_count(
    ffi.Pointer<ffi.Void> refcnt,
  ) {
    return _sk_refcnt_get_ref_count(
      refcnt,
    );
  }

  late final _sk_refcnt_get_ref_countPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_refcnt_get_ref_count');
  late final _sk_refcnt_get_ref_count =
      _sk_refcnt_get_ref_countPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_refcnt_safe_ref(sk_refcnt_t refcnt)
  void sk_refcnt_safe_ref(
    ffi.Pointer<ffi.Void> refcnt,
  ) {
    return _sk_refcnt_safe_ref(
      refcnt,
    );
  }

  late final _sk_refcnt_safe_refPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_refcnt_safe_ref');
  late final _sk_refcnt_safe_ref =
      _sk_refcnt_safe_refPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_refcnt_safe_unref(sk_refcnt_t refcnt)
  void sk_refcnt_safe_unref(
    ffi.Pointer<ffi.Void> refcnt,
  ) {
    return _sk_refcnt_safe_unref(
      refcnt,
    );
  }

  late final _sk_refcnt_safe_unrefPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_refcnt_safe_unref');
  late final _sk_refcnt_safe_unref =
      _sk_refcnt_safe_unrefPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_refcnt_unique(sk_refcnt_t refcnt)
  bool sk_refcnt_unique(
    ffi.Pointer<ffi.Void> refcnt,
  ) {
    return _sk_refcnt_unique(
      refcnt,
    );
  }

  late final _sk_refcnt_uniquePtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_refcnt_unique');
  late final _sk_refcnt_unique =
      _sk_refcnt_uniquePtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_version_get_increment()
  int sk_version_get_increment() {
    return _sk_version_get_increment();
  }

  late final _sk_version_get_incrementPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function()>>('sk_version_get_increment');
  late final _sk_version_get_increment =
      _sk_version_get_incrementPtr.asFunction<int Function()>();

  /// Int32 sk_version_get_milestone()
  int sk_version_get_milestone() {
    return _sk_version_get_milestone();
  }

  late final _sk_version_get_milestonePtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function()>>('sk_version_get_milestone');
  late final _sk_version_get_milestone =
      _sk_version_get_milestonePtr.asFunction<int Function()>();

  /// void* sk_version_get_string()
  ffi.Pointer<ffi.Void> sk_version_get_string() {
    return _sk_version_get_string();
  }

  late final _sk_version_get_stringPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_version_get_string');
  late final _sk_version_get_string =
      _sk_version_get_stringPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// void sk_graphics_dump_memory_statistics(sk_tracememorydump_t dump)
  void sk_graphics_dump_memory_statistics(
    ffi.Pointer<ffi.Void> dump,
  ) {
    return _sk_graphics_dump_memory_statistics(
      dump,
    );
  }

  late final _sk_graphics_dump_memory_statisticsPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_graphics_dump_memory_statistics');
  late final _sk_graphics_dump_memory_statistics =
      _sk_graphics_dump_memory_statisticsPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_graphics_get_font_cache_count_limit()
  int sk_graphics_get_font_cache_count_limit() {
    return _sk_graphics_get_font_cache_count_limit();
  }

  late final _sk_graphics_get_font_cache_count_limitPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function()>>('sk_graphics_get_font_cache_count_limit');
  late final _sk_graphics_get_font_cache_count_limit =
      _sk_graphics_get_font_cache_count_limitPtr.asFunction<int Function()>();

  /// Int32 sk_graphics_get_font_cache_count_used()
  int sk_graphics_get_font_cache_count_used() {
    return _sk_graphics_get_font_cache_count_used();
  }

  late final _sk_graphics_get_font_cache_count_usedPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function()>>('sk_graphics_get_font_cache_count_used');
  late final _sk_graphics_get_font_cache_count_used =
      _sk_graphics_get_font_cache_count_usedPtr.asFunction<int Function()>();

  /// IntPtr sk_graphics_get_font_cache_limit()
  ffi.Pointer<ffi.Void> sk_graphics_get_font_cache_limit() {
    return _sk_graphics_get_font_cache_limit();
  }

  late final _sk_graphics_get_font_cache_limitPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_graphics_get_font_cache_limit');
  late final _sk_graphics_get_font_cache_limit =
      _sk_graphics_get_font_cache_limitPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// IntPtr sk_graphics_get_font_cache_used()
  ffi.Pointer<ffi.Void> sk_graphics_get_font_cache_used() {
    return _sk_graphics_get_font_cache_used();
  }

  late final _sk_graphics_get_font_cache_usedPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_graphics_get_font_cache_used');
  late final _sk_graphics_get_font_cache_used =
      _sk_graphics_get_font_cache_usedPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// IntPtr sk_graphics_get_resource_cache_single_allocation_byte_limit()
  ffi.Pointer<ffi.Void> sk_graphics_get_resource_cache_single_allocation_byte_limit() {
    return _sk_graphics_get_resource_cache_single_allocation_byte_limit();
  }

  late final _sk_graphics_get_resource_cache_single_allocation_byte_limitPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_graphics_get_resource_cache_single_allocation_byte_limit');
  late final _sk_graphics_get_resource_cache_single_allocation_byte_limit =
      _sk_graphics_get_resource_cache_single_allocation_byte_limitPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// IntPtr sk_graphics_get_resource_cache_total_byte_limit()
  ffi.Pointer<ffi.Void> sk_graphics_get_resource_cache_total_byte_limit() {
    return _sk_graphics_get_resource_cache_total_byte_limit();
  }

  late final _sk_graphics_get_resource_cache_total_byte_limitPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_graphics_get_resource_cache_total_byte_limit');
  late final _sk_graphics_get_resource_cache_total_byte_limit =
      _sk_graphics_get_resource_cache_total_byte_limitPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// IntPtr sk_graphics_get_resource_cache_total_bytes_used()
  ffi.Pointer<ffi.Void> sk_graphics_get_resource_cache_total_bytes_used() {
    return _sk_graphics_get_resource_cache_total_bytes_used();
  }

  late final _sk_graphics_get_resource_cache_total_bytes_usedPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_graphics_get_resource_cache_total_bytes_used');
  late final _sk_graphics_get_resource_cache_total_bytes_used =
      _sk_graphics_get_resource_cache_total_bytes_usedPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// void sk_graphics_init()
  void sk_graphics_init() {
    return _sk_graphics_init();
  }

  late final _sk_graphics_initPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function()>>('sk_graphics_init');
  late final _sk_graphics_init =
      _sk_graphics_initPtr.asFunction<void Function()>();

  /// void sk_graphics_purge_all_caches()
  void sk_graphics_purge_all_caches() {
    return _sk_graphics_purge_all_caches();
  }

  late final _sk_graphics_purge_all_cachesPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function()>>('sk_graphics_purge_all_caches');
  late final _sk_graphics_purge_all_caches =
      _sk_graphics_purge_all_cachesPtr.asFunction<void Function()>();

  /// void sk_graphics_purge_font_cache()
  void sk_graphics_purge_font_cache() {
    return _sk_graphics_purge_font_cache();
  }

  late final _sk_graphics_purge_font_cachePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function()>>('sk_graphics_purge_font_cache');
  late final _sk_graphics_purge_font_cache =
      _sk_graphics_purge_font_cachePtr.asFunction<void Function()>();

  /// void sk_graphics_purge_resource_cache()
  void sk_graphics_purge_resource_cache() {
    return _sk_graphics_purge_resource_cache();
  }

  late final _sk_graphics_purge_resource_cachePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function()>>('sk_graphics_purge_resource_cache');
  late final _sk_graphics_purge_resource_cache =
      _sk_graphics_purge_resource_cachePtr.asFunction<void Function()>();

  /// Int32 sk_graphics_set_font_cache_count_limit(Int32 count)
  int sk_graphics_set_font_cache_count_limit(
    int count,
  ) {
    return _sk_graphics_set_font_cache_count_limit(
      count,
    );
  }

  late final _sk_graphics_set_font_cache_count_limitPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Int32)>>('sk_graphics_set_font_cache_count_limit');
  late final _sk_graphics_set_font_cache_count_limit =
      _sk_graphics_set_font_cache_count_limitPtr.asFunction<int Function(int)>();

  /// IntPtr sk_graphics_set_font_cache_limit(IntPtr bytes)
  ffi.Pointer<ffi.Void> sk_graphics_set_font_cache_limit(
    ffi.Pointer<ffi.Void> bytes,
  ) {
    return _sk_graphics_set_font_cache_limit(
      bytes,
    );
  }

  late final _sk_graphics_set_font_cache_limitPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_graphics_set_font_cache_limit');
  late final _sk_graphics_set_font_cache_limit =
      _sk_graphics_set_font_cache_limitPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// IntPtr sk_graphics_set_resource_cache_single_allocation_byte_limit(IntPtr newLimit)
  ffi.Pointer<ffi.Void> sk_graphics_set_resource_cache_single_allocation_byte_limit(
    ffi.Pointer<ffi.Void> newLimit,
  ) {
    return _sk_graphics_set_resource_cache_single_allocation_byte_limit(
      newLimit,
    );
  }

  late final _sk_graphics_set_resource_cache_single_allocation_byte_limitPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_graphics_set_resource_cache_single_allocation_byte_limit');
  late final _sk_graphics_set_resource_cache_single_allocation_byte_limit =
      _sk_graphics_set_resource_cache_single_allocation_byte_limitPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// IntPtr sk_graphics_set_resource_cache_total_byte_limit(IntPtr newLimit)
  ffi.Pointer<ffi.Void> sk_graphics_set_resource_cache_total_byte_limit(
    ffi.Pointer<ffi.Void> newLimit,
  ) {
    return _sk_graphics_set_resource_cache_total_byte_limit(
      newLimit,
    );
  }

  late final _sk_graphics_set_resource_cache_total_byte_limitPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_graphics_set_resource_cache_total_byte_limit');
  late final _sk_graphics_set_resource_cache_total_byte_limit =
      _sk_graphics_set_resource_cache_total_byte_limitPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// SKAlphaType sk_image_get_alpha_type(sk_image_t image)
  int sk_image_get_alpha_type(
    ffi.Pointer<ffi.Void> image,
  ) {
    return _sk_image_get_alpha_type(
      image,
    );
  }

  late final _sk_image_get_alpha_typePtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_image_get_alpha_type');
  late final _sk_image_get_alpha_type =
      _sk_image_get_alpha_typePtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// SKColorTypeNative sk_image_get_color_type(sk_image_t image)
  int sk_image_get_color_type(
    ffi.Pointer<ffi.Void> image,
  ) {
    return _sk_image_get_color_type(
      image,
    );
  }

  late final _sk_image_get_color_typePtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_image_get_color_type');
  late final _sk_image_get_color_type =
      _sk_image_get_color_typePtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// sk_colorspace_t sk_image_get_colorspace(sk_image_t image)
  ffi.Pointer<ffi.Void> sk_image_get_colorspace(
    ffi.Pointer<ffi.Void> image,
  ) {
    return _sk_image_get_colorspace(
      image,
    );
  }

  late final _sk_image_get_colorspacePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_image_get_colorspace');
  late final _sk_image_get_colorspace =
      _sk_image_get_colorspacePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_image_get_height(sk_image_t cimage)
  int sk_image_get_height(
    ffi.Pointer<ffi.Void> cimage,
  ) {
    return _sk_image_get_height(
      cimage,
    );
  }

  late final _sk_image_get_heightPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_image_get_height');
  late final _sk_image_get_height =
      _sk_image_get_heightPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// UInt32 sk_image_get_unique_id(sk_image_t cimage)
  int sk_image_get_unique_id(
    ffi.Pointer<ffi.Void> cimage,
  ) {
    return _sk_image_get_unique_id(
      cimage,
    );
  }

  late final _sk_image_get_unique_idPtr = _lookup<
      ffi.NativeFunction<ffi.Uint32 Function(ffi.Pointer<ffi.Void>)>>('sk_image_get_unique_id');
  late final _sk_image_get_unique_id =
      _sk_image_get_unique_idPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_image_get_width(sk_image_t cimage)
  int sk_image_get_width(
    ffi.Pointer<ffi.Void> cimage,
  ) {
    return _sk_image_get_width(
      cimage,
    );
  }

  late final _sk_image_get_widthPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_image_get_width');
  late final _sk_image_get_width =
      _sk_image_get_widthPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_image_is_alpha_only(sk_image_t image)
  bool sk_image_is_alpha_only(
    ffi.Pointer<ffi.Void> image,
  ) {
    return _sk_image_is_alpha_only(
      image,
    );
  }

  late final _sk_image_is_alpha_onlyPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_image_is_alpha_only');
  late final _sk_image_is_alpha_only =
      _sk_image_is_alpha_onlyPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_image_is_lazy_generated(sk_image_t image)
  bool sk_image_is_lazy_generated(
    ffi.Pointer<ffi.Void> image,
  ) {
    return _sk_image_is_lazy_generated(
      image,
    );
  }

  late final _sk_image_is_lazy_generatedPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_image_is_lazy_generated');
  late final _sk_image_is_lazy_generated =
      _sk_image_is_lazy_generatedPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_image_is_texture_backed(sk_image_t image)
  bool sk_image_is_texture_backed(
    ffi.Pointer<ffi.Void> image,
  ) {
    return _sk_image_is_texture_backed(
      image,
    );
  }

  late final _sk_image_is_texture_backedPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_image_is_texture_backed');
  late final _sk_image_is_texture_backed =
      _sk_image_is_texture_backedPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_image_is_valid(sk_image_t image, gr_recording_context_t context)
  bool sk_image_is_valid(
    ffi.Pointer<ffi.Void> image,
    ffi.Pointer<ffi.Void> context,
  ) {
    return _sk_image_is_valid(
      image,
      context,
    );
  }

  late final _sk_image_is_validPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_image_is_valid');
  late final _sk_image_is_valid =
      _sk_image_is_validPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_image_t sk_image_make_non_texture_image(sk_image_t cimage)
  ffi.Pointer<ffi.Void> sk_image_make_non_texture_image(
    ffi.Pointer<ffi.Void> cimage,
  ) {
    return _sk_image_make_non_texture_image(
      cimage,
    );
  }

  late final _sk_image_make_non_texture_imagePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_image_make_non_texture_image');
  late final _sk_image_make_non_texture_image =
      _sk_image_make_non_texture_imagePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_image_t sk_image_make_raster_image(sk_image_t cimage)
  ffi.Pointer<ffi.Void> sk_image_make_raster_image(
    ffi.Pointer<ffi.Void> cimage,
  ) {
    return _sk_image_make_raster_image(
      cimage,
    );
  }

  late final _sk_image_make_raster_imagePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_image_make_raster_image');
  late final _sk_image_make_raster_image =
      _sk_image_make_raster_imagePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_shader_t sk_image_make_raw_shader(sk_image_t image, SKShaderTileMode tileX, SKShaderTileMode tileY, SKSamplingOptions* sampling, SKMatrix* cmatrix)
  ffi.Pointer<ffi.Void> sk_image_make_raw_shader(
    ffi.Pointer<ffi.Void> image,
    int tileX,
    int tileY,
    ffi.Pointer<ffi.Void> sampling,
    ffi.Pointer<ffi.Void> cmatrix,
  ) {
    return _sk_image_make_raw_shader(
      image,
      tileX,
      tileY,
      sampling,
      cmatrix,
    );
  }

  late final _sk_image_make_raw_shaderPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_image_make_raw_shader');
  late final _sk_image_make_raw_shader =
      _sk_image_make_raw_shaderPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, int, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_shader_t sk_image_make_shader(sk_image_t image, SKShaderTileMode tileX, SKShaderTileMode tileY, SKSamplingOptions* sampling, SKMatrix* cmatrix)
  ffi.Pointer<ffi.Void> sk_image_make_shader(
    ffi.Pointer<ffi.Void> image,
    int tileX,
    int tileY,
    ffi.Pointer<ffi.Void> sampling,
    ffi.Pointer<ffi.Void> cmatrix,
  ) {
    return _sk_image_make_shader(
      image,
      tileX,
      tileY,
      sampling,
      cmatrix,
    );
  }

  late final _sk_image_make_shaderPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_image_make_shader');
  late final _sk_image_make_shader =
      _sk_image_make_shaderPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, int, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_image_t sk_image_make_subset(sk_image_t cimage, gr_direct_context_t context, SKRectI* subset)
  ffi.Pointer<ffi.Void> sk_image_make_subset(
    ffi.Pointer<ffi.Void> cimage,
    ffi.Pointer<ffi.Void> context,
    ffi.Pointer<ffi.Void> subset,
  ) {
    return _sk_image_make_subset(
      cimage,
      context,
      subset,
    );
  }

  late final _sk_image_make_subsetPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_image_make_subset');
  late final _sk_image_make_subset =
      _sk_image_make_subsetPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_image_t sk_image_make_subset_raster(sk_image_t cimage, SKRectI* subset)
  ffi.Pointer<ffi.Void> sk_image_make_subset_raster(
    ffi.Pointer<ffi.Void> cimage,
    ffi.Pointer<ffi.Void> subset,
  ) {
    return _sk_image_make_subset_raster(
      cimage,
      subset,
    );
  }

  late final _sk_image_make_subset_rasterPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_image_make_subset_raster');
  late final _sk_image_make_subset_raster =
      _sk_image_make_subset_rasterPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_image_t sk_image_make_texture_image(sk_image_t cimage, gr_direct_context_t context, bool mipmapped, bool budgeted)
  ffi.Pointer<ffi.Void> sk_image_make_texture_image(
    ffi.Pointer<ffi.Void> cimage,
    ffi.Pointer<ffi.Void> context,
    bool mipmapped,
    bool budgeted,
  ) {
    return _sk_image_make_texture_image(
      cimage,
      context,
      mipmapped,
      budgeted,
    );
  }

  late final _sk_image_make_texture_imagePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Bool, ffi.Bool)>>('sk_image_make_texture_image');
  late final _sk_image_make_texture_image =
      _sk_image_make_texture_imagePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, bool, bool)>();

  /// sk_image_t sk_image_make_with_filter(sk_image_t cimage, gr_recording_context_t context, sk_imagefilter_t filter, SKRectI* subset, SKRectI* clipBounds, SKRectI* outSubset, SKPointI* outOffset)
  ffi.Pointer<ffi.Void> sk_image_make_with_filter(
    ffi.Pointer<ffi.Void> cimage,
    ffi.Pointer<ffi.Void> context,
    ffi.Pointer<ffi.Void> filter,
    ffi.Pointer<ffi.Void> subset,
    ffi.Pointer<ffi.Void> clipBounds,
    ffi.Pointer<ffi.Void> outSubset,
    ffi.Pointer<ffi.Void> outOffset,
  ) {
    return _sk_image_make_with_filter(
      cimage,
      context,
      filter,
      subset,
      clipBounds,
      outSubset,
      outOffset,
    );
  }

  late final _sk_image_make_with_filterPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_image_make_with_filter');
  late final _sk_image_make_with_filter =
      _sk_image_make_with_filterPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_image_t sk_image_make_with_filter_raster(sk_image_t cimage, sk_imagefilter_t filter, SKRectI* subset, SKRectI* clipBounds, SKRectI* outSubset, SKPointI* outOffset)
  ffi.Pointer<ffi.Void> sk_image_make_with_filter_raster(
    ffi.Pointer<ffi.Void> cimage,
    ffi.Pointer<ffi.Void> filter,
    ffi.Pointer<ffi.Void> subset,
    ffi.Pointer<ffi.Void> clipBounds,
    ffi.Pointer<ffi.Void> outSubset,
    ffi.Pointer<ffi.Void> outOffset,
  ) {
    return _sk_image_make_with_filter_raster(
      cimage,
      filter,
      subset,
      clipBounds,
      outSubset,
      outOffset,
    );
  }

  late final _sk_image_make_with_filter_rasterPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_image_make_with_filter_raster');
  late final _sk_image_make_with_filter_raster =
      _sk_image_make_with_filter_rasterPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_image_t sk_image_new_from_adopted_texture(gr_recording_context_t context, gr_backendtexture_t texture, GRSurfaceOrigin origin, SKColorTypeNative colorType, SKAlphaType alpha, sk_colorspace_t colorSpace)
  ffi.Pointer<ffi.Void> sk_image_new_from_adopted_texture(
    ffi.Pointer<ffi.Void> context,
    ffi.Pointer<ffi.Void> texture,
    int origin,
    int colorType,
    int alpha,
    ffi.Pointer<ffi.Void> colorSpace,
  ) {
    return _sk_image_new_from_adopted_texture(
      context,
      texture,
      origin,
      colorType,
      alpha,
      colorSpace,
    );
  }

  late final _sk_image_new_from_adopted_texturePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>)>>('sk_image_new_from_adopted_texture');
  late final _sk_image_new_from_adopted_texture =
      _sk_image_new_from_adopted_texturePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, int, int, ffi.Pointer<ffi.Void>)>();

  /// sk_image_t sk_image_new_from_bitmap(sk_bitmap_t cbitmap)
  ffi.Pointer<ffi.Void> sk_image_new_from_bitmap(
    ffi.Pointer<ffi.Void> cbitmap,
  ) {
    return _sk_image_new_from_bitmap(
      cbitmap,
    );
  }

  late final _sk_image_new_from_bitmapPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_image_new_from_bitmap');
  late final _sk_image_new_from_bitmap =
      _sk_image_new_from_bitmapPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_image_t sk_image_new_from_encoded(sk_data_t cdata)
  ffi.Pointer<ffi.Void> sk_image_new_from_encoded(
    ffi.Pointer<ffi.Void> cdata,
  ) {
    return _sk_image_new_from_encoded(
      cdata,
    );
  }

  late final _sk_image_new_from_encodedPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_image_new_from_encoded');
  late final _sk_image_new_from_encoded =
      _sk_image_new_from_encodedPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_image_t sk_image_new_from_picture(sk_picture_t picture, SKSizeI* dimensions, SKMatrix* cmatrix, sk_paint_t paint, bool useFloatingPointBitDepth, sk_colorspace_t colorSpace, sk_surfaceprops_t props)
  ffi.Pointer<ffi.Void> sk_image_new_from_picture(
    ffi.Pointer<ffi.Void> picture,
    ffi.Pointer<ffi.Void> dimensions,
    ffi.Pointer<ffi.Void> cmatrix,
    ffi.Pointer<ffi.Void> paint,
    bool useFloatingPointBitDepth,
    ffi.Pointer<ffi.Void> colorSpace,
    ffi.Pointer<ffi.Void> props,
  ) {
    return _sk_image_new_from_picture(
      picture,
      dimensions,
      cmatrix,
      paint,
      useFloatingPointBitDepth,
      colorSpace,
      props,
    );
  }

  late final _sk_image_new_from_picturePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Bool, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_image_new_from_picture');
  late final _sk_image_new_from_picture =
      _sk_image_new_from_picturePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, bool, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_image_t sk_image_new_from_texture(gr_recording_context_t context, gr_backendtexture_t texture, GRSurfaceOrigin origin, SKColorTypeNative colorType, SKAlphaType alpha, sk_colorspace_t colorSpace, void* releaseProc, void* releaseContext)
  ffi.Pointer<ffi.Void> sk_image_new_from_texture(
    ffi.Pointer<ffi.Void> context,
    ffi.Pointer<ffi.Void> texture,
    int origin,
    int colorType,
    int alpha,
    ffi.Pointer<ffi.Void> colorSpace,
    ffi.Pointer<ffi.Void> releaseProc,
    ffi.Pointer<ffi.Void> releaseContext,
  ) {
    return _sk_image_new_from_texture(
      context,
      texture,
      origin,
      colorType,
      alpha,
      colorSpace,
      releaseProc,
      releaseContext,
    );
  }

  late final _sk_image_new_from_texturePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_image_new_from_texture');
  late final _sk_image_new_from_texture =
      _sk_image_new_from_texturePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, int, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_image_t sk_image_new_raster(sk_pixmap_t pixmap, void* releaseProc, void* context)
  ffi.Pointer<ffi.Void> sk_image_new_raster(
    ffi.Pointer<ffi.Void> pixmap,
    ffi.Pointer<ffi.Void> releaseProc,
    ffi.Pointer<ffi.Void> context,
  ) {
    return _sk_image_new_raster(
      pixmap,
      releaseProc,
      context,
    );
  }

  late final _sk_image_new_rasterPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_image_new_raster');
  late final _sk_image_new_raster =
      _sk_image_new_rasterPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_image_t sk_image_new_raster_copy(SKImageInfoNative* cinfo, void* pixels, IntPtr rowBytes)
  ffi.Pointer<ffi.Void> sk_image_new_raster_copy(
    ffi.Pointer<ffi.Void> cinfo,
    ffi.Pointer<ffi.Void> pixels,
    ffi.Pointer<ffi.Void> rowBytes,
  ) {
    return _sk_image_new_raster_copy(
      cinfo,
      pixels,
      rowBytes,
    );
  }

  late final _sk_image_new_raster_copyPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_image_new_raster_copy');
  late final _sk_image_new_raster_copy =
      _sk_image_new_raster_copyPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_image_t sk_image_new_raster_copy_with_pixmap(sk_pixmap_t pixmap)
  ffi.Pointer<ffi.Void> sk_image_new_raster_copy_with_pixmap(
    ffi.Pointer<ffi.Void> pixmap,
  ) {
    return _sk_image_new_raster_copy_with_pixmap(
      pixmap,
    );
  }

  late final _sk_image_new_raster_copy_with_pixmapPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_image_new_raster_copy_with_pixmap');
  late final _sk_image_new_raster_copy_with_pixmap =
      _sk_image_new_raster_copy_with_pixmapPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_image_t sk_image_new_raster_data(SKImageInfoNative* cinfo, sk_data_t pixels, IntPtr rowBytes)
  ffi.Pointer<ffi.Void> sk_image_new_raster_data(
    ffi.Pointer<ffi.Void> cinfo,
    ffi.Pointer<ffi.Void> pixels,
    ffi.Pointer<ffi.Void> rowBytes,
  ) {
    return _sk_image_new_raster_data(
      cinfo,
      pixels,
      rowBytes,
    );
  }

  late final _sk_image_new_raster_dataPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_image_new_raster_data');
  late final _sk_image_new_raster_data =
      _sk_image_new_raster_dataPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_image_peek_pixels(sk_image_t image, sk_pixmap_t pixmap)
  bool sk_image_peek_pixels(
    ffi.Pointer<ffi.Void> image,
    ffi.Pointer<ffi.Void> pixmap,
  ) {
    return _sk_image_peek_pixels(
      image,
      pixmap,
    );
  }

  late final _sk_image_peek_pixelsPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_image_peek_pixels');
  late final _sk_image_peek_pixels =
      _sk_image_peek_pixelsPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_image_read_pixels(sk_image_t image, SKImageInfoNative* dstInfo, void* dstPixels, IntPtr dstRowBytes, Int32 srcX, Int32 srcY, SKImageCachingHint cachingHint)
  bool sk_image_read_pixels(
    ffi.Pointer<ffi.Void> image,
    ffi.Pointer<ffi.Void> dstInfo,
    ffi.Pointer<ffi.Void> dstPixels,
    ffi.Pointer<ffi.Void> dstRowBytes,
    int srcX,
    int srcY,
    int cachingHint,
  ) {
    return _sk_image_read_pixels(
      image,
      dstInfo,
      dstPixels,
      dstRowBytes,
      srcX,
      srcY,
      cachingHint,
    );
  }

  late final _sk_image_read_pixelsPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32, ffi.Int32)>>('sk_image_read_pixels');
  late final _sk_image_read_pixels =
      _sk_image_read_pixelsPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, int, int)>();

  /// bool sk_image_read_pixels_into_pixmap(sk_image_t image, sk_pixmap_t dst, Int32 srcX, Int32 srcY, SKImageCachingHint cachingHint)
  bool sk_image_read_pixels_into_pixmap(
    ffi.Pointer<ffi.Void> image,
    ffi.Pointer<ffi.Void> dst,
    int srcX,
    int srcY,
    int cachingHint,
  ) {
    return _sk_image_read_pixels_into_pixmap(
      image,
      dst,
      srcX,
      srcY,
      cachingHint,
    );
  }

  late final _sk_image_read_pixels_into_pixmapPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32, ffi.Int32)>>('sk_image_read_pixels_into_pixmap');
  late final _sk_image_read_pixels_into_pixmap =
      _sk_image_read_pixels_into_pixmapPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, int, int)>();

  /// void sk_image_ref(sk_image_t cimage)
  void sk_image_ref(
    ffi.Pointer<ffi.Void> cimage,
  ) {
    return _sk_image_ref(
      cimage,
    );
  }

  late final _sk_image_refPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_image_ref');
  late final _sk_image_ref =
      _sk_image_refPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// sk_data_t sk_image_ref_encoded(sk_image_t cimage)
  ffi.Pointer<ffi.Void> sk_image_ref_encoded(
    ffi.Pointer<ffi.Void> cimage,
  ) {
    return _sk_image_ref_encoded(
      cimage,
    );
  }

  late final _sk_image_ref_encodedPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_image_ref_encoded');
  late final _sk_image_ref_encoded =
      _sk_image_ref_encodedPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_image_scale_pixels(sk_image_t image, sk_pixmap_t dst, SKSamplingOptions* sampling, SKImageCachingHint cachingHint)
  bool sk_image_scale_pixels(
    ffi.Pointer<ffi.Void> image,
    ffi.Pointer<ffi.Void> dst,
    ffi.Pointer<ffi.Void> sampling,
    int cachingHint,
  ) {
    return _sk_image_scale_pixels(
      image,
      dst,
      sampling,
      cachingHint,
    );
  }

  late final _sk_image_scale_pixelsPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_image_scale_pixels');
  late final _sk_image_scale_pixels =
      _sk_image_scale_pixelsPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int)>();

  /// void sk_image_unref(sk_image_t cimage)
  void sk_image_unref(
    ffi.Pointer<ffi.Void> cimage,
  ) {
    return _sk_image_unref(
      cimage,
    );
  }

  late final _sk_image_unrefPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_image_unref');
  late final _sk_image_unref =
      _sk_image_unrefPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_arithmetic(Single k1, Single k2, Single k3, Single k4, bool enforcePMColor, sk_imagefilter_t background, sk_imagefilter_t foreground, SKRect* cropRect)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_arithmetic(
    double k1,
    double k2,
    double k3,
    double k4,
    bool enforcePMColor,
    ffi.Pointer<ffi.Void> background,
    ffi.Pointer<ffi.Void> foreground,
    ffi.Pointer<ffi.Void> cropRect,
  ) {
    return _sk_imagefilter_new_arithmetic(
      k1,
      k2,
      k3,
      k4,
      enforcePMColor,
      background,
      foreground,
      cropRect,
    );
  }

  late final _sk_imagefilter_new_arithmeticPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Float, ffi.Float, ffi.Float, ffi.Float, ffi.Bool, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_arithmetic');
  late final _sk_imagefilter_new_arithmetic =
      _sk_imagefilter_new_arithmeticPtr.asFunction<ffi.Pointer<ffi.Void> Function(double, double, double, double, bool, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_blend(SKBlendMode mode, sk_imagefilter_t background, sk_imagefilter_t foreground, SKRect* cropRect)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_blend(
    int mode,
    ffi.Pointer<ffi.Void> background,
    ffi.Pointer<ffi.Void> foreground,
    ffi.Pointer<ffi.Void> cropRect,
  ) {
    return _sk_imagefilter_new_blend(
      mode,
      background,
      foreground,
      cropRect,
    );
  }

  late final _sk_imagefilter_new_blendPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_blend');
  late final _sk_imagefilter_new_blend =
      _sk_imagefilter_new_blendPtr.asFunction<ffi.Pointer<ffi.Void> Function(int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_blender(sk_blender_t blender, sk_imagefilter_t background, sk_imagefilter_t foreground, SKRect* cropRect)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_blender(
    ffi.Pointer<ffi.Void> blender,
    ffi.Pointer<ffi.Void> background,
    ffi.Pointer<ffi.Void> foreground,
    ffi.Pointer<ffi.Void> cropRect,
  ) {
    return _sk_imagefilter_new_blender(
      blender,
      background,
      foreground,
      cropRect,
    );
  }

  late final _sk_imagefilter_new_blenderPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_blender');
  late final _sk_imagefilter_new_blender =
      _sk_imagefilter_new_blenderPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_blur(Single sigmaX, Single sigmaY, SKShaderTileMode tileMode, sk_imagefilter_t input, SKRect* cropRect)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_blur(
    double sigmaX,
    double sigmaY,
    int tileMode,
    ffi.Pointer<ffi.Void> input,
    ffi.Pointer<ffi.Void> cropRect,
  ) {
    return _sk_imagefilter_new_blur(
      sigmaX,
      sigmaY,
      tileMode,
      input,
      cropRect,
    );
  }

  late final _sk_imagefilter_new_blurPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Float, ffi.Float, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_blur');
  late final _sk_imagefilter_new_blur =
      _sk_imagefilter_new_blurPtr.asFunction<ffi.Pointer<ffi.Void> Function(double, double, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_color_filter(sk_colorfilter_t cf, sk_imagefilter_t input, SKRect* cropRect)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_color_filter(
    ffi.Pointer<ffi.Void> cf,
    ffi.Pointer<ffi.Void> input,
    ffi.Pointer<ffi.Void> cropRect,
  ) {
    return _sk_imagefilter_new_color_filter(
      cf,
      input,
      cropRect,
    );
  }

  late final _sk_imagefilter_new_color_filterPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_color_filter');
  late final _sk_imagefilter_new_color_filter =
      _sk_imagefilter_new_color_filterPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_compose(sk_imagefilter_t outer, sk_imagefilter_t inner)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_compose(
    ffi.Pointer<ffi.Void> outer,
    ffi.Pointer<ffi.Void> inner,
  ) {
    return _sk_imagefilter_new_compose(
      outer,
      inner,
    );
  }

  late final _sk_imagefilter_new_composePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_compose');
  late final _sk_imagefilter_new_compose =
      _sk_imagefilter_new_composePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_dilate(Single radiusX, Single radiusY, sk_imagefilter_t input, SKRect* cropRect)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_dilate(
    double radiusX,
    double radiusY,
    ffi.Pointer<ffi.Void> input,
    ffi.Pointer<ffi.Void> cropRect,
  ) {
    return _sk_imagefilter_new_dilate(
      radiusX,
      radiusY,
      input,
      cropRect,
    );
  }

  late final _sk_imagefilter_new_dilatePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_dilate');
  late final _sk_imagefilter_new_dilate =
      _sk_imagefilter_new_dilatePtr.asFunction<ffi.Pointer<ffi.Void> Function(double, double, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_displacement_map_effect(SKColorChannel xChannelSelector, SKColorChannel yChannelSelector, Single scale, sk_imagefilter_t displacement, sk_imagefilter_t color, SKRect* cropRect)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_displacement_map_effect(
    ffi.Pointer<ffi.Void> xChannelSelector,
    ffi.Pointer<ffi.Void> yChannelSelector,
    double scale,
    ffi.Pointer<ffi.Void> displacement,
    ffi.Pointer<ffi.Void> color,
    ffi.Pointer<ffi.Void> cropRect,
  ) {
    return _sk_imagefilter_new_displacement_map_effect(
      xChannelSelector,
      yChannelSelector,
      scale,
      displacement,
      color,
      cropRect,
    );
  }

  late final _sk_imagefilter_new_displacement_map_effectPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Float, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_displacement_map_effect');
  late final _sk_imagefilter_new_displacement_map_effect =
      _sk_imagefilter_new_displacement_map_effectPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, double, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_distant_lit_diffuse(SKPoint3* direction, UInt32 lightColor, Single surfaceScale, Single kd, sk_imagefilter_t input, SKRect* cropRect)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_distant_lit_diffuse(
    ffi.Pointer<ffi.Void> direction,
    int lightColor,
    double surfaceScale,
    double kd,
    ffi.Pointer<ffi.Void> input,
    ffi.Pointer<ffi.Void> cropRect,
  ) {
    return _sk_imagefilter_new_distant_lit_diffuse(
      direction,
      lightColor,
      surfaceScale,
      kd,
      input,
      cropRect,
    );
  }

  late final _sk_imagefilter_new_distant_lit_diffusePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Uint32, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_distant_lit_diffuse');
  late final _sk_imagefilter_new_distant_lit_diffuse =
      _sk_imagefilter_new_distant_lit_diffusePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, int, double, double, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_distant_lit_specular(SKPoint3* direction, UInt32 lightColor, Single surfaceScale, Single ks, Single shininess, sk_imagefilter_t input, SKRect* cropRect)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_distant_lit_specular(
    ffi.Pointer<ffi.Void> direction,
    int lightColor,
    double surfaceScale,
    double ks,
    double shininess,
    ffi.Pointer<ffi.Void> input,
    ffi.Pointer<ffi.Void> cropRect,
  ) {
    return _sk_imagefilter_new_distant_lit_specular(
      direction,
      lightColor,
      surfaceScale,
      ks,
      shininess,
      input,
      cropRect,
    );
  }

  late final _sk_imagefilter_new_distant_lit_specularPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Uint32, ffi.Float, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_distant_lit_specular');
  late final _sk_imagefilter_new_distant_lit_specular =
      _sk_imagefilter_new_distant_lit_specularPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, int, double, double, double, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_drop_shadow(Single dx, Single dy, Single sigmaX, Single sigmaY, UInt32 color, sk_imagefilter_t input, SKRect* cropRect)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_drop_shadow(
    double dx,
    double dy,
    double sigmaX,
    double sigmaY,
    int color,
    ffi.Pointer<ffi.Void> input,
    ffi.Pointer<ffi.Void> cropRect,
  ) {
    return _sk_imagefilter_new_drop_shadow(
      dx,
      dy,
      sigmaX,
      sigmaY,
      color,
      input,
      cropRect,
    );
  }

  late final _sk_imagefilter_new_drop_shadowPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Float, ffi.Float, ffi.Float, ffi.Float, ffi.Uint32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_drop_shadow');
  late final _sk_imagefilter_new_drop_shadow =
      _sk_imagefilter_new_drop_shadowPtr.asFunction<ffi.Pointer<ffi.Void> Function(double, double, double, double, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_drop_shadow_only(Single dx, Single dy, Single sigmaX, Single sigmaY, UInt32 color, sk_imagefilter_t input, SKRect* cropRect)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_drop_shadow_only(
    double dx,
    double dy,
    double sigmaX,
    double sigmaY,
    int color,
    ffi.Pointer<ffi.Void> input,
    ffi.Pointer<ffi.Void> cropRect,
  ) {
    return _sk_imagefilter_new_drop_shadow_only(
      dx,
      dy,
      sigmaX,
      sigmaY,
      color,
      input,
      cropRect,
    );
  }

  late final _sk_imagefilter_new_drop_shadow_onlyPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Float, ffi.Float, ffi.Float, ffi.Float, ffi.Uint32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_drop_shadow_only');
  late final _sk_imagefilter_new_drop_shadow_only =
      _sk_imagefilter_new_drop_shadow_onlyPtr.asFunction<ffi.Pointer<ffi.Void> Function(double, double, double, double, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_erode(Single radiusX, Single radiusY, sk_imagefilter_t input, SKRect* cropRect)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_erode(
    double radiusX,
    double radiusY,
    ffi.Pointer<ffi.Void> input,
    ffi.Pointer<ffi.Void> cropRect,
  ) {
    return _sk_imagefilter_new_erode(
      radiusX,
      radiusY,
      input,
      cropRect,
    );
  }

  late final _sk_imagefilter_new_erodePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_erode');
  late final _sk_imagefilter_new_erode =
      _sk_imagefilter_new_erodePtr.asFunction<ffi.Pointer<ffi.Void> Function(double, double, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_image(sk_image_t image, SKRect* srcRect, SKRect* dstRect, SKSamplingOptions* sampling)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_image(
    ffi.Pointer<ffi.Void> image,
    ffi.Pointer<ffi.Void> srcRect,
    ffi.Pointer<ffi.Void> dstRect,
    ffi.Pointer<ffi.Void> sampling,
  ) {
    return _sk_imagefilter_new_image(
      image,
      srcRect,
      dstRect,
      sampling,
    );
  }

  late final _sk_imagefilter_new_imagePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_image');
  late final _sk_imagefilter_new_image =
      _sk_imagefilter_new_imagePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_image_simple(sk_image_t image, SKSamplingOptions* sampling)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_image_simple(
    ffi.Pointer<ffi.Void> image,
    ffi.Pointer<ffi.Void> sampling,
  ) {
    return _sk_imagefilter_new_image_simple(
      image,
      sampling,
    );
  }

  late final _sk_imagefilter_new_image_simplePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_image_simple');
  late final _sk_imagefilter_new_image_simple =
      _sk_imagefilter_new_image_simplePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_magnifier(SKRect* lensBounds, Single zoomAmount, Single inset, SKSamplingOptions* sampling, sk_imagefilter_t input, SKRect* cropRect)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_magnifier(
    ffi.Pointer<ffi.Void> lensBounds,
    double zoomAmount,
    double inset,
    ffi.Pointer<ffi.Void> sampling,
    ffi.Pointer<ffi.Void> input,
    ffi.Pointer<ffi.Void> cropRect,
  ) {
    return _sk_imagefilter_new_magnifier(
      lensBounds,
      zoomAmount,
      inset,
      sampling,
      input,
      cropRect,
    );
  }

  late final _sk_imagefilter_new_magnifierPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_magnifier');
  late final _sk_imagefilter_new_magnifier =
      _sk_imagefilter_new_magnifierPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, double, double, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_matrix_convolution(SKSizeI* kernelSize, Single* kernel, Single gain, Single bias, SKPointI* kernelOffset, SKShaderTileMode ctileMode, bool convolveAlpha, sk_imagefilter_t input, SKRect* cropRect)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_matrix_convolution(
    ffi.Pointer<ffi.Void> kernelSize,
    ffi.Pointer<ffi.Float> kernel,
    double gain,
    double bias,
    ffi.Pointer<ffi.Void> kernelOffset,
    int ctileMode,
    bool convolveAlpha,
    ffi.Pointer<ffi.Void> input,
    ffi.Pointer<ffi.Void> cropRect,
  ) {
    return _sk_imagefilter_new_matrix_convolution(
      kernelSize,
      kernel,
      gain,
      bias,
      kernelOffset,
      ctileMode,
      convolveAlpha,
      input,
      cropRect,
    );
  }

  late final _sk_imagefilter_new_matrix_convolutionPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Float>, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Bool, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_matrix_convolution');
  late final _sk_imagefilter_new_matrix_convolution =
      _sk_imagefilter_new_matrix_convolutionPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Float>, double, double, ffi.Pointer<ffi.Void>, int, bool, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_matrix_transform(SKMatrix* cmatrix, SKSamplingOptions* sampling, sk_imagefilter_t input)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_matrix_transform(
    ffi.Pointer<ffi.Void> cmatrix,
    ffi.Pointer<ffi.Void> sampling,
    ffi.Pointer<ffi.Void> input,
  ) {
    return _sk_imagefilter_new_matrix_transform(
      cmatrix,
      sampling,
      input,
    );
  }

  late final _sk_imagefilter_new_matrix_transformPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_matrix_transform');
  late final _sk_imagefilter_new_matrix_transform =
      _sk_imagefilter_new_matrix_transformPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_merge(sk_imagefilter_t* cfilters, Int32 count, SKRect* cropRect)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_merge(
    ffi.Pointer<ffi.Void> cfilters,
    int count,
    ffi.Pointer<ffi.Void> cropRect,
  ) {
    return _sk_imagefilter_new_merge(
      cfilters,
      count,
      cropRect,
    );
  }

  late final _sk_imagefilter_new_mergePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_merge');
  late final _sk_imagefilter_new_merge =
      _sk_imagefilter_new_mergePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_merge_simple(sk_imagefilter_t first, sk_imagefilter_t second, SKRect* cropRect)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_merge_simple(
    ffi.Pointer<ffi.Void> first,
    ffi.Pointer<ffi.Void> second,
    ffi.Pointer<ffi.Void> cropRect,
  ) {
    return _sk_imagefilter_new_merge_simple(
      first,
      second,
      cropRect,
    );
  }

  late final _sk_imagefilter_new_merge_simplePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_merge_simple');
  late final _sk_imagefilter_new_merge_simple =
      _sk_imagefilter_new_merge_simplePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_offset(Single dx, Single dy, sk_imagefilter_t input, SKRect* cropRect)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_offset(
    double dx,
    double dy,
    ffi.Pointer<ffi.Void> input,
    ffi.Pointer<ffi.Void> cropRect,
  ) {
    return _sk_imagefilter_new_offset(
      dx,
      dy,
      input,
      cropRect,
    );
  }

  late final _sk_imagefilter_new_offsetPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_offset');
  late final _sk_imagefilter_new_offset =
      _sk_imagefilter_new_offsetPtr.asFunction<ffi.Pointer<ffi.Void> Function(double, double, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_picture(sk_picture_t picture)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_picture(
    ffi.Pointer<ffi.Void> picture,
  ) {
    return _sk_imagefilter_new_picture(
      picture,
    );
  }

  late final _sk_imagefilter_new_picturePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_picture');
  late final _sk_imagefilter_new_picture =
      _sk_imagefilter_new_picturePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_picture_with_rect(sk_picture_t picture, SKRect* targetRect)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_picture_with_rect(
    ffi.Pointer<ffi.Void> picture,
    ffi.Pointer<ffi.Void> targetRect,
  ) {
    return _sk_imagefilter_new_picture_with_rect(
      picture,
      targetRect,
    );
  }

  late final _sk_imagefilter_new_picture_with_rectPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_picture_with_rect');
  late final _sk_imagefilter_new_picture_with_rect =
      _sk_imagefilter_new_picture_with_rectPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_point_lit_diffuse(SKPoint3* location, UInt32 lightColor, Single surfaceScale, Single kd, sk_imagefilter_t input, SKRect* cropRect)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_point_lit_diffuse(
    ffi.Pointer<ffi.Void> location,
    int lightColor,
    double surfaceScale,
    double kd,
    ffi.Pointer<ffi.Void> input,
    ffi.Pointer<ffi.Void> cropRect,
  ) {
    return _sk_imagefilter_new_point_lit_diffuse(
      location,
      lightColor,
      surfaceScale,
      kd,
      input,
      cropRect,
    );
  }

  late final _sk_imagefilter_new_point_lit_diffusePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Uint32, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_point_lit_diffuse');
  late final _sk_imagefilter_new_point_lit_diffuse =
      _sk_imagefilter_new_point_lit_diffusePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, int, double, double, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_point_lit_specular(SKPoint3* location, UInt32 lightColor, Single surfaceScale, Single ks, Single shininess, sk_imagefilter_t input, SKRect* cropRect)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_point_lit_specular(
    ffi.Pointer<ffi.Void> location,
    int lightColor,
    double surfaceScale,
    double ks,
    double shininess,
    ffi.Pointer<ffi.Void> input,
    ffi.Pointer<ffi.Void> cropRect,
  ) {
    return _sk_imagefilter_new_point_lit_specular(
      location,
      lightColor,
      surfaceScale,
      ks,
      shininess,
      input,
      cropRect,
    );
  }

  late final _sk_imagefilter_new_point_lit_specularPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Uint32, ffi.Float, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_point_lit_specular');
  late final _sk_imagefilter_new_point_lit_specular =
      _sk_imagefilter_new_point_lit_specularPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, int, double, double, double, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_shader(sk_shader_t shader, bool dither, SKRect* cropRect)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_shader(
    ffi.Pointer<ffi.Void> shader,
    bool dither,
    ffi.Pointer<ffi.Void> cropRect,
  ) {
    return _sk_imagefilter_new_shader(
      shader,
      dither,
      cropRect,
    );
  }

  late final _sk_imagefilter_new_shaderPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Bool, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_shader');
  late final _sk_imagefilter_new_shader =
      _sk_imagefilter_new_shaderPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, bool, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_spot_lit_diffuse(SKPoint3* location, SKPoint3* target, Single specularExponent, Single cutoffAngle, UInt32 lightColor, Single surfaceScale, Single kd, sk_imagefilter_t input, SKRect* cropRect)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_spot_lit_diffuse(
    ffi.Pointer<ffi.Void> location,
    ffi.Pointer<ffi.Void> target,
    double specularExponent,
    double cutoffAngle,
    int lightColor,
    double surfaceScale,
    double kd,
    ffi.Pointer<ffi.Void> input,
    ffi.Pointer<ffi.Void> cropRect,
  ) {
    return _sk_imagefilter_new_spot_lit_diffuse(
      location,
      target,
      specularExponent,
      cutoffAngle,
      lightColor,
      surfaceScale,
      kd,
      input,
      cropRect,
    );
  }

  late final _sk_imagefilter_new_spot_lit_diffusePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Uint32, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_spot_lit_diffuse');
  late final _sk_imagefilter_new_spot_lit_diffuse =
      _sk_imagefilter_new_spot_lit_diffusePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, double, double, int, double, double, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_spot_lit_specular(SKPoint3* location, SKPoint3* target, Single specularExponent, Single cutoffAngle, UInt32 lightColor, Single surfaceScale, Single ks, Single shininess, sk_imagefilter_t input, SKRect* cropRect)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_spot_lit_specular(
    ffi.Pointer<ffi.Void> location,
    ffi.Pointer<ffi.Void> target,
    double specularExponent,
    double cutoffAngle,
    int lightColor,
    double surfaceScale,
    double ks,
    double shininess,
    ffi.Pointer<ffi.Void> input,
    ffi.Pointer<ffi.Void> cropRect,
  ) {
    return _sk_imagefilter_new_spot_lit_specular(
      location,
      target,
      specularExponent,
      cutoffAngle,
      lightColor,
      surfaceScale,
      ks,
      shininess,
      input,
      cropRect,
    );
  }

  late final _sk_imagefilter_new_spot_lit_specularPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Uint32, ffi.Float, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_spot_lit_specular');
  late final _sk_imagefilter_new_spot_lit_specular =
      _sk_imagefilter_new_spot_lit_specularPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, double, double, int, double, double, double, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_imagefilter_new_tile(SKRect* src, SKRect* dst, sk_imagefilter_t input)
  ffi.Pointer<ffi.Void> sk_imagefilter_new_tile(
    ffi.Pointer<ffi.Void> src,
    ffi.Pointer<ffi.Void> dst,
    ffi.Pointer<ffi.Void> input,
  ) {
    return _sk_imagefilter_new_tile(
      src,
      dst,
      input,
    );
  }

  late final _sk_imagefilter_new_tilePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_imagefilter_new_tile');
  late final _sk_imagefilter_new_tile =
      _sk_imagefilter_new_tilePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_imagefilter_unref(sk_imagefilter_t cfilter)
  void sk_imagefilter_unref(
    ffi.Pointer<ffi.Void> cfilter,
  ) {
    return _sk_imagefilter_unref(
      cfilter,
    );
  }

  late final _sk_imagefilter_unrefPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_imagefilter_unref');
  late final _sk_imagefilter_unref =
      _sk_imagefilter_unrefPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_linker_keep_alive()
  void sk_linker_keep_alive() {
    return _sk_linker_keep_alive();
  }

  late final _sk_linker_keep_alivePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function()>>('sk_linker_keep_alive');
  late final _sk_linker_keep_alive =
      _sk_linker_keep_alivePtr.asFunction<void Function()>();

  /// sk_maskfilter_t sk_maskfilter_new_blur(SKBlurStyle param0, Single sigma)
  ffi.Pointer<ffi.Void> sk_maskfilter_new_blur(
    ffi.Pointer<ffi.Void> param0,
    double sigma,
  ) {
    return _sk_maskfilter_new_blur(
      param0,
      sigma,
    );
  }

  late final _sk_maskfilter_new_blurPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Float)>>('sk_maskfilter_new_blur');
  late final _sk_maskfilter_new_blur =
      _sk_maskfilter_new_blurPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, double)>();

  /// sk_maskfilter_t sk_maskfilter_new_blur_with_flags(SKBlurStyle param0, Single sigma, bool respectCTM)
  ffi.Pointer<ffi.Void> sk_maskfilter_new_blur_with_flags(
    ffi.Pointer<ffi.Void> param0,
    double sigma,
    bool respectCTM,
  ) {
    return _sk_maskfilter_new_blur_with_flags(
      param0,
      sigma,
      respectCTM,
    );
  }

  late final _sk_maskfilter_new_blur_with_flagsPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Bool)>>('sk_maskfilter_new_blur_with_flags');
  late final _sk_maskfilter_new_blur_with_flags =
      _sk_maskfilter_new_blur_with_flagsPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, double, bool)>();

  /// sk_maskfilter_t sk_maskfilter_new_clip(Byte min, Byte max)
  ffi.Pointer<ffi.Void> sk_maskfilter_new_clip(
    int min,
    int max,
  ) {
    return _sk_maskfilter_new_clip(
      min,
      max,
    );
  }

  late final _sk_maskfilter_new_clipPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Uint8, ffi.Uint8)>>('sk_maskfilter_new_clip');
  late final _sk_maskfilter_new_clip =
      _sk_maskfilter_new_clipPtr.asFunction<ffi.Pointer<ffi.Void> Function(int, int)>();

  /// sk_maskfilter_t sk_maskfilter_new_gamma(Single gamma)
  ffi.Pointer<ffi.Void> sk_maskfilter_new_gamma(
    double gamma,
  ) {
    return _sk_maskfilter_new_gamma(
      gamma,
    );
  }

  late final _sk_maskfilter_new_gammaPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Float)>>('sk_maskfilter_new_gamma');
  late final _sk_maskfilter_new_gamma =
      _sk_maskfilter_new_gammaPtr.asFunction<ffi.Pointer<ffi.Void> Function(double)>();

  /// sk_maskfilter_t sk_maskfilter_new_shader(sk_shader_t cshader)
  ffi.Pointer<ffi.Void> sk_maskfilter_new_shader(
    ffi.Pointer<ffi.Void> cshader,
  ) {
    return _sk_maskfilter_new_shader(
      cshader,
    );
  }

  late final _sk_maskfilter_new_shaderPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_maskfilter_new_shader');
  late final _sk_maskfilter_new_shader =
      _sk_maskfilter_new_shaderPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_maskfilter_t sk_maskfilter_new_table(Byte* table)
  ffi.Pointer<ffi.Void> sk_maskfilter_new_table(
    ffi.Pointer<ffi.Uint8> table,
  ) {
    return _sk_maskfilter_new_table(
      table,
    );
  }

  late final _sk_maskfilter_new_tablePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Uint8>)>>('sk_maskfilter_new_table');
  late final _sk_maskfilter_new_table =
      _sk_maskfilter_new_tablePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Uint8>)>();

  /// void sk_maskfilter_ref(sk_maskfilter_t param0)
  void sk_maskfilter_ref(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_maskfilter_ref(
      param0,
    );
  }

  late final _sk_maskfilter_refPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_maskfilter_ref');
  late final _sk_maskfilter_ref =
      _sk_maskfilter_refPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_maskfilter_unref(sk_maskfilter_t param0)
  void sk_maskfilter_unref(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_maskfilter_unref(
      param0,
    );
  }

  late final _sk_maskfilter_unrefPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_maskfilter_unref');
  late final _sk_maskfilter_unref =
      _sk_maskfilter_unrefPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_matrix_concat(SKMatrix* result, SKMatrix* first, SKMatrix* second)
  void sk_matrix_concat(
    ffi.Pointer<ffi.Void> result,
    ffi.Pointer<ffi.Void> first,
    ffi.Pointer<ffi.Void> second,
  ) {
    return _sk_matrix_concat(
      result,
      first,
      second,
    );
  }

  late final _sk_matrix_concatPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_matrix_concat');
  late final _sk_matrix_concat =
      _sk_matrix_concatPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_matrix_map_points(SKMatrix* matrix, SKPoint* dst, SKPoint* src, Int32 count)
  void sk_matrix_map_points(
    ffi.Pointer<ffi.Void> matrix,
    ffi.Pointer<ffi.Void> dst,
    ffi.Pointer<ffi.Void> src,
    int count,
  ) {
    return _sk_matrix_map_points(
      matrix,
      dst,
      src,
      count,
    );
  }

  late final _sk_matrix_map_pointsPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_matrix_map_points');
  late final _sk_matrix_map_points =
      _sk_matrix_map_pointsPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int)>();

  /// Single sk_matrix_map_radius(SKMatrix* matrix, Single radius)
  double sk_matrix_map_radius(
    ffi.Pointer<ffi.Void> matrix,
    double radius,
  ) {
    return _sk_matrix_map_radius(
      matrix,
      radius,
    );
  }

  late final _sk_matrix_map_radiusPtr = _lookup<
      ffi.NativeFunction<ffi.Float Function(ffi.Pointer<ffi.Void>, ffi.Float)>>('sk_matrix_map_radius');
  late final _sk_matrix_map_radius =
      _sk_matrix_map_radiusPtr.asFunction<double Function(ffi.Pointer<ffi.Void>, double)>();

  /// void sk_matrix_map_rect(SKMatrix* matrix, SKRect* dest, SKRect* source)
  void sk_matrix_map_rect(
    ffi.Pointer<ffi.Void> matrix,
    ffi.Pointer<ffi.Void> dest,
    ffi.Pointer<ffi.Void> source,
  ) {
    return _sk_matrix_map_rect(
      matrix,
      dest,
      source,
    );
  }

  late final _sk_matrix_map_rectPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_matrix_map_rect');
  late final _sk_matrix_map_rect =
      _sk_matrix_map_rectPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_matrix_map_vector(SKMatrix* matrix, Single x, Single y, SKPoint* result)
  void sk_matrix_map_vector(
    ffi.Pointer<ffi.Void> matrix,
    double x,
    double y,
    ffi.Pointer<ffi.Void> result,
  ) {
    return _sk_matrix_map_vector(
      matrix,
      x,
      y,
      result,
    );
  }

  late final _sk_matrix_map_vectorPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>)>>('sk_matrix_map_vector');
  late final _sk_matrix_map_vector =
      _sk_matrix_map_vectorPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, double, ffi.Pointer<ffi.Void>)>();

  /// void sk_matrix_map_vectors(SKMatrix* matrix, SKPoint* dst, SKPoint* src, Int32 count)
  void sk_matrix_map_vectors(
    ffi.Pointer<ffi.Void> matrix,
    ffi.Pointer<ffi.Void> dst,
    ffi.Pointer<ffi.Void> src,
    int count,
  ) {
    return _sk_matrix_map_vectors(
      matrix,
      dst,
      src,
      count,
    );
  }

  late final _sk_matrix_map_vectorsPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_matrix_map_vectors');
  late final _sk_matrix_map_vectors =
      _sk_matrix_map_vectorsPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int)>();

  /// void sk_matrix_map_xy(SKMatrix* matrix, Single x, Single y, SKPoint* result)
  void sk_matrix_map_xy(
    ffi.Pointer<ffi.Void> matrix,
    double x,
    double y,
    ffi.Pointer<ffi.Void> result,
  ) {
    return _sk_matrix_map_xy(
      matrix,
      x,
      y,
      result,
    );
  }

  late final _sk_matrix_map_xyPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>)>>('sk_matrix_map_xy');
  late final _sk_matrix_map_xy =
      _sk_matrix_map_xyPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, double, ffi.Pointer<ffi.Void>)>();

  /// void sk_matrix_post_concat(SKMatrix* result, SKMatrix* matrix)
  void sk_matrix_post_concat(
    ffi.Pointer<ffi.Void> result,
    ffi.Pointer<ffi.Void> matrix,
  ) {
    return _sk_matrix_post_concat(
      result,
      matrix,
    );
  }

  late final _sk_matrix_post_concatPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_matrix_post_concat');
  late final _sk_matrix_post_concat =
      _sk_matrix_post_concatPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_matrix_pre_concat(SKMatrix* result, SKMatrix* matrix)
  void sk_matrix_pre_concat(
    ffi.Pointer<ffi.Void> result,
    ffi.Pointer<ffi.Void> matrix,
  ) {
    return _sk_matrix_pre_concat(
      result,
      matrix,
    );
  }

  late final _sk_matrix_pre_concatPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_matrix_pre_concat');
  late final _sk_matrix_pre_concat =
      _sk_matrix_pre_concatPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_matrix_try_invert(SKMatrix* matrix, SKMatrix* result)
  bool sk_matrix_try_invert(
    ffi.Pointer<ffi.Void> matrix,
    ffi.Pointer<ffi.Void> result,
  ) {
    return _sk_matrix_try_invert(
      matrix,
      result,
    );
  }

  late final _sk_matrix_try_invertPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_matrix_try_invert');
  late final _sk_matrix_try_invert =
      _sk_matrix_try_invertPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_paint_t sk_paint_clone(sk_paint_t param0)
  ffi.Pointer<ffi.Void> sk_paint_clone(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_paint_clone(
      param0,
    );
  }

  late final _sk_paint_clonePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_paint_clone');
  late final _sk_paint_clone =
      _sk_paint_clonePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_paint_delete(sk_paint_t param0)
  void sk_paint_delete(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_paint_delete(
      param0,
    );
  }

  late final _sk_paint_deletePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_paint_delete');
  late final _sk_paint_delete =
      _sk_paint_deletePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// sk_blender_t sk_paint_get_blender(sk_paint_t cpaint)
  ffi.Pointer<ffi.Void> sk_paint_get_blender(
    ffi.Pointer<ffi.Void> cpaint,
  ) {
    return _sk_paint_get_blender(
      cpaint,
    );
  }

  late final _sk_paint_get_blenderPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_paint_get_blender');
  late final _sk_paint_get_blender =
      _sk_paint_get_blenderPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// SKBlendMode sk_paint_get_blendmode(sk_paint_t param0)
  int sk_paint_get_blendmode(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_paint_get_blendmode(
      param0,
    );
  }

  late final _sk_paint_get_blendmodePtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_paint_get_blendmode');
  late final _sk_paint_get_blendmode =
      _sk_paint_get_blendmodePtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// UInt32 sk_paint_get_color(sk_paint_t param0)
  int sk_paint_get_color(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_paint_get_color(
      param0,
    );
  }

  late final _sk_paint_get_colorPtr = _lookup<
      ffi.NativeFunction<ffi.Uint32 Function(ffi.Pointer<ffi.Void>)>>('sk_paint_get_color');
  late final _sk_paint_get_color =
      _sk_paint_get_colorPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_paint_get_color4f(sk_paint_t paint, SKColorF* color)
  void sk_paint_get_color4f(
    ffi.Pointer<ffi.Void> paint,
    ffi.Pointer<ffi.Void> color,
  ) {
    return _sk_paint_get_color4f(
      paint,
      color,
    );
  }

  late final _sk_paint_get_color4fPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_paint_get_color4f');
  late final _sk_paint_get_color4f =
      _sk_paint_get_color4fPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_colorfilter_t sk_paint_get_colorfilter(sk_paint_t param0)
  ffi.Pointer<ffi.Void> sk_paint_get_colorfilter(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_paint_get_colorfilter(
      param0,
    );
  }

  late final _sk_paint_get_colorfilterPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_paint_get_colorfilter');
  late final _sk_paint_get_colorfilter =
      _sk_paint_get_colorfilterPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_paint_get_fill_path(sk_paint_t cpaint, sk_path_t src, sk_path_t dst, SKRect* cullRect, SKMatrix* cmatrix)
  bool sk_paint_get_fill_path(
    ffi.Pointer<ffi.Void> cpaint,
    ffi.Pointer<ffi.Void> src,
    ffi.Pointer<ffi.Void> dst,
    ffi.Pointer<ffi.Void> cullRect,
    ffi.Pointer<ffi.Void> cmatrix,
  ) {
    return _sk_paint_get_fill_path(
      cpaint,
      src,
      dst,
      cullRect,
      cmatrix,
    );
  }

  late final _sk_paint_get_fill_pathPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_paint_get_fill_path');
  late final _sk_paint_get_fill_path =
      _sk_paint_get_fill_pathPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_imagefilter_t sk_paint_get_imagefilter(sk_paint_t param0)
  ffi.Pointer<ffi.Void> sk_paint_get_imagefilter(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_paint_get_imagefilter(
      param0,
    );
  }

  late final _sk_paint_get_imagefilterPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_paint_get_imagefilter');
  late final _sk_paint_get_imagefilter =
      _sk_paint_get_imagefilterPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_maskfilter_t sk_paint_get_maskfilter(sk_paint_t param0)
  ffi.Pointer<ffi.Void> sk_paint_get_maskfilter(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_paint_get_maskfilter(
      param0,
    );
  }

  late final _sk_paint_get_maskfilterPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_paint_get_maskfilter');
  late final _sk_paint_get_maskfilter =
      _sk_paint_get_maskfilterPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_path_effect_t sk_paint_get_path_effect(sk_paint_t cpaint)
  ffi.Pointer<ffi.Void> sk_paint_get_path_effect(
    ffi.Pointer<ffi.Void> cpaint,
  ) {
    return _sk_paint_get_path_effect(
      cpaint,
    );
  }

  late final _sk_paint_get_path_effectPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_paint_get_path_effect');
  late final _sk_paint_get_path_effect =
      _sk_paint_get_path_effectPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_shader_t sk_paint_get_shader(sk_paint_t param0)
  ffi.Pointer<ffi.Void> sk_paint_get_shader(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_paint_get_shader(
      param0,
    );
  }

  late final _sk_paint_get_shaderPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_paint_get_shader');
  late final _sk_paint_get_shader =
      _sk_paint_get_shaderPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// SKStrokeCap sk_paint_get_stroke_cap(sk_paint_t param0)
  int sk_paint_get_stroke_cap(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_paint_get_stroke_cap(
      param0,
    );
  }

  late final _sk_paint_get_stroke_capPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_paint_get_stroke_cap');
  late final _sk_paint_get_stroke_cap =
      _sk_paint_get_stroke_capPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// SKStrokeJoin sk_paint_get_stroke_join(sk_paint_t param0)
  int sk_paint_get_stroke_join(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_paint_get_stroke_join(
      param0,
    );
  }

  late final _sk_paint_get_stroke_joinPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_paint_get_stroke_join');
  late final _sk_paint_get_stroke_join =
      _sk_paint_get_stroke_joinPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// Single sk_paint_get_stroke_miter(sk_paint_t param0)
  double sk_paint_get_stroke_miter(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_paint_get_stroke_miter(
      param0,
    );
  }

  late final _sk_paint_get_stroke_miterPtr = _lookup<
      ffi.NativeFunction<ffi.Float Function(ffi.Pointer<ffi.Void>)>>('sk_paint_get_stroke_miter');
  late final _sk_paint_get_stroke_miter =
      _sk_paint_get_stroke_miterPtr.asFunction<double Function(ffi.Pointer<ffi.Void>)>();

  /// Single sk_paint_get_stroke_width(sk_paint_t param0)
  double sk_paint_get_stroke_width(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_paint_get_stroke_width(
      param0,
    );
  }

  late final _sk_paint_get_stroke_widthPtr = _lookup<
      ffi.NativeFunction<ffi.Float Function(ffi.Pointer<ffi.Void>)>>('sk_paint_get_stroke_width');
  late final _sk_paint_get_stroke_width =
      _sk_paint_get_stroke_widthPtr.asFunction<double Function(ffi.Pointer<ffi.Void>)>();

  /// SKPaintStyle sk_paint_get_style(sk_paint_t param0)
  int sk_paint_get_style(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_paint_get_style(
      param0,
    );
  }

  late final _sk_paint_get_stylePtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_paint_get_style');
  late final _sk_paint_get_style =
      _sk_paint_get_stylePtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_paint_is_antialias(sk_paint_t param0)
  bool sk_paint_is_antialias(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_paint_is_antialias(
      param0,
    );
  }

  late final _sk_paint_is_antialiasPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_paint_is_antialias');
  late final _sk_paint_is_antialias =
      _sk_paint_is_antialiasPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_paint_is_dither(sk_paint_t param0)
  bool sk_paint_is_dither(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_paint_is_dither(
      param0,
    );
  }

  late final _sk_paint_is_ditherPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_paint_is_dither');
  late final _sk_paint_is_dither =
      _sk_paint_is_ditherPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// sk_paint_t sk_paint_new()
  ffi.Pointer<ffi.Void> sk_paint_new() {
    return _sk_paint_new();
  }

  late final _sk_paint_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_paint_new');
  late final _sk_paint_new =
      _sk_paint_newPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// void sk_paint_reset(sk_paint_t param0)
  void sk_paint_reset(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_paint_reset(
      param0,
    );
  }

  late final _sk_paint_resetPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_paint_reset');
  late final _sk_paint_reset =
      _sk_paint_resetPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_paint_set_antialias(sk_paint_t param0, bool param1)
  void sk_paint_set_antialias(
    ffi.Pointer<ffi.Void> param0,
    bool param1,
  ) {
    return _sk_paint_set_antialias(
      param0,
      param1,
    );
  }

  late final _sk_paint_set_antialiasPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Bool)>>('sk_paint_set_antialias');
  late final _sk_paint_set_antialias =
      _sk_paint_set_antialiasPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, bool)>();

  /// void sk_paint_set_blender(sk_paint_t paint, sk_blender_t blender)
  void sk_paint_set_blender(
    ffi.Pointer<ffi.Void> paint,
    ffi.Pointer<ffi.Void> blender,
  ) {
    return _sk_paint_set_blender(
      paint,
      blender,
    );
  }

  late final _sk_paint_set_blenderPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_paint_set_blender');
  late final _sk_paint_set_blender =
      _sk_paint_set_blenderPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_paint_set_blendmode(sk_paint_t param0, SKBlendMode param1)
  void sk_paint_set_blendmode(
    ffi.Pointer<ffi.Void> param0,
    int param1,
  ) {
    return _sk_paint_set_blendmode(
      param0,
      param1,
    );
  }

  late final _sk_paint_set_blendmodePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_paint_set_blendmode');
  late final _sk_paint_set_blendmode =
      _sk_paint_set_blendmodePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int)>();

  /// void sk_paint_set_color(sk_paint_t param0, UInt32 param1)
  void sk_paint_set_color(
    ffi.Pointer<ffi.Void> param0,
    int param1,
  ) {
    return _sk_paint_set_color(
      param0,
      param1,
    );
  }

  late final _sk_paint_set_colorPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Uint32)>>('sk_paint_set_color');
  late final _sk_paint_set_color =
      _sk_paint_set_colorPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int)>();

  /// void sk_paint_set_color4f(sk_paint_t paint, SKColorF* color, sk_colorspace_t colorspace)
  void sk_paint_set_color4f(
    ffi.Pointer<ffi.Void> paint,
    ffi.Pointer<ffi.Void> color,
    ffi.Pointer<ffi.Void> colorspace,
  ) {
    return _sk_paint_set_color4f(
      paint,
      color,
      colorspace,
    );
  }

  late final _sk_paint_set_color4fPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_paint_set_color4f');
  late final _sk_paint_set_color4f =
      _sk_paint_set_color4fPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_paint_set_colorfilter(sk_paint_t param0, sk_colorfilter_t param1)
  void sk_paint_set_colorfilter(
    ffi.Pointer<ffi.Void> param0,
    ffi.Pointer<ffi.Void> param1,
  ) {
    return _sk_paint_set_colorfilter(
      param0,
      param1,
    );
  }

  late final _sk_paint_set_colorfilterPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_paint_set_colorfilter');
  late final _sk_paint_set_colorfilter =
      _sk_paint_set_colorfilterPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_paint_set_dither(sk_paint_t param0, bool param1)
  void sk_paint_set_dither(
    ffi.Pointer<ffi.Void> param0,
    bool param1,
  ) {
    return _sk_paint_set_dither(
      param0,
      param1,
    );
  }

  late final _sk_paint_set_ditherPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Bool)>>('sk_paint_set_dither');
  late final _sk_paint_set_dither =
      _sk_paint_set_ditherPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, bool)>();

  /// void sk_paint_set_imagefilter(sk_paint_t param0, sk_imagefilter_t param1)
  void sk_paint_set_imagefilter(
    ffi.Pointer<ffi.Void> param0,
    ffi.Pointer<ffi.Void> param1,
  ) {
    return _sk_paint_set_imagefilter(
      param0,
      param1,
    );
  }

  late final _sk_paint_set_imagefilterPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_paint_set_imagefilter');
  late final _sk_paint_set_imagefilter =
      _sk_paint_set_imagefilterPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_paint_set_maskfilter(sk_paint_t param0, sk_maskfilter_t param1)
  void sk_paint_set_maskfilter(
    ffi.Pointer<ffi.Void> param0,
    ffi.Pointer<ffi.Void> param1,
  ) {
    return _sk_paint_set_maskfilter(
      param0,
      param1,
    );
  }

  late final _sk_paint_set_maskfilterPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_paint_set_maskfilter');
  late final _sk_paint_set_maskfilter =
      _sk_paint_set_maskfilterPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_paint_set_path_effect(sk_paint_t cpaint, sk_path_effect_t effect)
  void sk_paint_set_path_effect(
    ffi.Pointer<ffi.Void> cpaint,
    ffi.Pointer<ffi.Void> effect,
  ) {
    return _sk_paint_set_path_effect(
      cpaint,
      effect,
    );
  }

  late final _sk_paint_set_path_effectPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_paint_set_path_effect');
  late final _sk_paint_set_path_effect =
      _sk_paint_set_path_effectPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_paint_set_shader(sk_paint_t param0, sk_shader_t param1)
  void sk_paint_set_shader(
    ffi.Pointer<ffi.Void> param0,
    ffi.Pointer<ffi.Void> param1,
  ) {
    return _sk_paint_set_shader(
      param0,
      param1,
    );
  }

  late final _sk_paint_set_shaderPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_paint_set_shader');
  late final _sk_paint_set_shader =
      _sk_paint_set_shaderPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_paint_set_stroke_cap(sk_paint_t param0, SKStrokeCap param1)
  void sk_paint_set_stroke_cap(
    ffi.Pointer<ffi.Void> param0,
    int param1,
  ) {
    return _sk_paint_set_stroke_cap(
      param0,
      param1,
    );
  }

  late final _sk_paint_set_stroke_capPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_paint_set_stroke_cap');
  late final _sk_paint_set_stroke_cap =
      _sk_paint_set_stroke_capPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int)>();

  /// void sk_paint_set_stroke_join(sk_paint_t param0, SKStrokeJoin param1)
  void sk_paint_set_stroke_join(
    ffi.Pointer<ffi.Void> param0,
    int param1,
  ) {
    return _sk_paint_set_stroke_join(
      param0,
      param1,
    );
  }

  late final _sk_paint_set_stroke_joinPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_paint_set_stroke_join');
  late final _sk_paint_set_stroke_join =
      _sk_paint_set_stroke_joinPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int)>();

  /// void sk_paint_set_stroke_miter(sk_paint_t param0, Single miter)
  void sk_paint_set_stroke_miter(
    ffi.Pointer<ffi.Void> param0,
    double miter,
  ) {
    return _sk_paint_set_stroke_miter(
      param0,
      miter,
    );
  }

  late final _sk_paint_set_stroke_miterPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float)>>('sk_paint_set_stroke_miter');
  late final _sk_paint_set_stroke_miter =
      _sk_paint_set_stroke_miterPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double)>();

  /// void sk_paint_set_stroke_width(sk_paint_t param0, Single width)
  void sk_paint_set_stroke_width(
    ffi.Pointer<ffi.Void> param0,
    double width,
  ) {
    return _sk_paint_set_stroke_width(
      param0,
      width,
    );
  }

  late final _sk_paint_set_stroke_widthPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float)>>('sk_paint_set_stroke_width');
  late final _sk_paint_set_stroke_width =
      _sk_paint_set_stroke_widthPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double)>();

  /// void sk_paint_set_style(sk_paint_t param0, SKPaintStyle param1)
  void sk_paint_set_style(
    ffi.Pointer<ffi.Void> param0,
    int param1,
  ) {
    return _sk_paint_set_style(
      param0,
      param1,
    );
  }

  late final _sk_paint_set_stylePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_paint_set_style');
  late final _sk_paint_set_style =
      _sk_paint_set_stylePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int)>();

  /// void sk_opbuilder_add(sk_opbuilder_t builder, sk_path_t path, SKPathOp op)
  void sk_opbuilder_add(
    ffi.Pointer<ffi.Void> builder,
    ffi.Pointer<ffi.Void> path,
    int op,
  ) {
    return _sk_opbuilder_add(
      builder,
      path,
      op,
    );
  }

  late final _sk_opbuilder_addPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_opbuilder_add');
  late final _sk_opbuilder_add =
      _sk_opbuilder_addPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int)>();

  /// void sk_opbuilder_destroy(sk_opbuilder_t builder)
  void sk_opbuilder_destroy(
    ffi.Pointer<ffi.Void> builder,
  ) {
    return _sk_opbuilder_destroy(
      builder,
    );
  }

  late final _sk_opbuilder_destroyPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_opbuilder_destroy');
  late final _sk_opbuilder_destroy =
      _sk_opbuilder_destroyPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// sk_opbuilder_t sk_opbuilder_new()
  ffi.Pointer<ffi.Void> sk_opbuilder_new() {
    return _sk_opbuilder_new();
  }

  late final _sk_opbuilder_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_opbuilder_new');
  late final _sk_opbuilder_new =
      _sk_opbuilder_newPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// bool sk_opbuilder_resolve(sk_opbuilder_t builder, sk_path_t result)
  bool sk_opbuilder_resolve(
    ffi.Pointer<ffi.Void> builder,
    ffi.Pointer<ffi.Void> result,
  ) {
    return _sk_opbuilder_resolve(
      builder,
      result,
    );
  }

  late final _sk_opbuilder_resolvePtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_opbuilder_resolve');
  late final _sk_opbuilder_resolve =
      _sk_opbuilder_resolvePtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_path_add_arc(sk_path_t cpath, SKRect* crect, Single startAngle, Single sweepAngle)
  void sk_path_add_arc(
    ffi.Pointer<ffi.Void> cpath,
    ffi.Pointer<ffi.Void> crect,
    double startAngle,
    double sweepAngle,
  ) {
    return _sk_path_add_arc(
      cpath,
      crect,
      startAngle,
      sweepAngle,
    );
  }

  late final _sk_path_add_arcPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float)>>('sk_path_add_arc');
  late final _sk_path_add_arc =
      _sk_path_add_arcPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, double, double)>();

  /// void sk_path_add_circle(sk_path_t param0, Single x, Single y, Single radius, SKPathDirection dir)
  void sk_path_add_circle(
    ffi.Pointer<ffi.Void> param0,
    double x,
    double y,
    double radius,
    int dir,
  ) {
    return _sk_path_add_circle(
      param0,
      x,
      y,
      radius,
      dir,
    );
  }

  late final _sk_path_add_circlePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Float, ffi.Int32)>>('sk_path_add_circle');
  late final _sk_path_add_circle =
      _sk_path_add_circlePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, double, double, int)>();

  /// void sk_path_add_oval(sk_path_t param0, SKRect* param1, SKPathDirection param2)
  void sk_path_add_oval(
    ffi.Pointer<ffi.Void> param0,
    ffi.Pointer<ffi.Void> param1,
    int param2,
  ) {
    return _sk_path_add_oval(
      param0,
      param1,
      param2,
    );
  }

  late final _sk_path_add_ovalPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_path_add_oval');
  late final _sk_path_add_oval =
      _sk_path_add_ovalPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int)>();

  /// void sk_path_add_path(sk_path_t cpath, sk_path_t other, SKPathAddMode add_mode)
  void sk_path_add_path(
    ffi.Pointer<ffi.Void> cpath,
    ffi.Pointer<ffi.Void> other,
    ffi.Pointer<ffi.Void> add_mode,
  ) {
    return _sk_path_add_path(
      cpath,
      other,
      add_mode,
    );
  }

  late final _sk_path_add_pathPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_path_add_path');
  late final _sk_path_add_path =
      _sk_path_add_pathPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_path_add_path_matrix(sk_path_t cpath, sk_path_t other, SKMatrix* matrix, SKPathAddMode add_mode)
  void sk_path_add_path_matrix(
    ffi.Pointer<ffi.Void> cpath,
    ffi.Pointer<ffi.Void> other,
    ffi.Pointer<ffi.Void> matrix,
    ffi.Pointer<ffi.Void> add_mode,
  ) {
    return _sk_path_add_path_matrix(
      cpath,
      other,
      matrix,
      add_mode,
    );
  }

  late final _sk_path_add_path_matrixPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_path_add_path_matrix');
  late final _sk_path_add_path_matrix =
      _sk_path_add_path_matrixPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_path_add_path_offset(sk_path_t cpath, sk_path_t other, Single dx, Single dy, SKPathAddMode add_mode)
  void sk_path_add_path_offset(
    ffi.Pointer<ffi.Void> cpath,
    ffi.Pointer<ffi.Void> other,
    double dx,
    double dy,
    ffi.Pointer<ffi.Void> add_mode,
  ) {
    return _sk_path_add_path_offset(
      cpath,
      other,
      dx,
      dy,
      add_mode,
    );
  }

  late final _sk_path_add_path_offsetPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>)>>('sk_path_add_path_offset');
  late final _sk_path_add_path_offset =
      _sk_path_add_path_offsetPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, double, double, ffi.Pointer<ffi.Void>)>();

  /// void sk_path_add_path_reverse(sk_path_t cpath, sk_path_t other)
  void sk_path_add_path_reverse(
    ffi.Pointer<ffi.Void> cpath,
    ffi.Pointer<ffi.Void> other,
  ) {
    return _sk_path_add_path_reverse(
      cpath,
      other,
    );
  }

  late final _sk_path_add_path_reversePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_path_add_path_reverse');
  late final _sk_path_add_path_reverse =
      _sk_path_add_path_reversePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_path_add_poly(sk_path_t cpath, SKPoint* points, Int32 count, bool close)
  void sk_path_add_poly(
    ffi.Pointer<ffi.Void> cpath,
    ffi.Pointer<ffi.Void> points,
    int count,
    bool close,
  ) {
    return _sk_path_add_poly(
      cpath,
      points,
      count,
      close,
    );
  }

  late final _sk_path_add_polyPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Bool)>>('sk_path_add_poly');
  late final _sk_path_add_poly =
      _sk_path_add_polyPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, bool)>();

  /// void sk_path_add_rect(sk_path_t param0, SKRect* param1, SKPathDirection param2)
  void sk_path_add_rect(
    ffi.Pointer<ffi.Void> param0,
    ffi.Pointer<ffi.Void> param1,
    int param2,
  ) {
    return _sk_path_add_rect(
      param0,
      param1,
      param2,
    );
  }

  late final _sk_path_add_rectPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_path_add_rect');
  late final _sk_path_add_rect =
      _sk_path_add_rectPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int)>();

  /// void sk_path_add_rect_start(sk_path_t cpath, SKRect* crect, SKPathDirection cdir, UInt32 startIndex)
  void sk_path_add_rect_start(
    ffi.Pointer<ffi.Void> cpath,
    ffi.Pointer<ffi.Void> crect,
    int cdir,
    int startIndex,
  ) {
    return _sk_path_add_rect_start(
      cpath,
      crect,
      cdir,
      startIndex,
    );
  }

  late final _sk_path_add_rect_startPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Uint32)>>('sk_path_add_rect_start');
  late final _sk_path_add_rect_start =
      _sk_path_add_rect_startPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, int)>();

  /// void sk_path_add_rounded_rect(sk_path_t param0, SKRect* param1, Single param2, Single param3, SKPathDirection param4)
  void sk_path_add_rounded_rect(
    ffi.Pointer<ffi.Void> param0,
    ffi.Pointer<ffi.Void> param1,
    double param2,
    double param3,
    int param4,
  ) {
    return _sk_path_add_rounded_rect(
      param0,
      param1,
      param2,
      param3,
      param4,
    );
  }

  late final _sk_path_add_rounded_rectPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Int32)>>('sk_path_add_rounded_rect');
  late final _sk_path_add_rounded_rect =
      _sk_path_add_rounded_rectPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, double, double, int)>();

  /// void sk_path_add_rrect(sk_path_t param0, sk_rrect_t param1, SKPathDirection param2)
  void sk_path_add_rrect(
    ffi.Pointer<ffi.Void> param0,
    ffi.Pointer<ffi.Void> param1,
    int param2,
  ) {
    return _sk_path_add_rrect(
      param0,
      param1,
      param2,
    );
  }

  late final _sk_path_add_rrectPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_path_add_rrect');
  late final _sk_path_add_rrect =
      _sk_path_add_rrectPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int)>();

  /// void sk_path_add_rrect_start(sk_path_t param0, sk_rrect_t param1, SKPathDirection param2, UInt32 param3)
  void sk_path_add_rrect_start(
    ffi.Pointer<ffi.Void> param0,
    ffi.Pointer<ffi.Void> param1,
    int param2,
    int param3,
  ) {
    return _sk_path_add_rrect_start(
      param0,
      param1,
      param2,
      param3,
    );
  }

  late final _sk_path_add_rrect_startPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Uint32)>>('sk_path_add_rrect_start');
  late final _sk_path_add_rrect_start =
      _sk_path_add_rrect_startPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, int)>();

  /// void sk_path_arc_to(sk_path_t param0, Single rx, Single ry, Single xAxisRotate, SKPathArcSize largeArc, SKPathDirection sweep, Single x, Single y)
  void sk_path_arc_to(
    ffi.Pointer<ffi.Void> param0,
    double rx,
    double ry,
    double xAxisRotate,
    int largeArc,
    int sweep,
    double x,
    double y,
  ) {
    return _sk_path_arc_to(
      param0,
      rx,
      ry,
      xAxisRotate,
      largeArc,
      sweep,
      x,
      y,
    );
  }

  late final _sk_path_arc_toPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Float, ffi.Int32, ffi.Int32, ffi.Float, ffi.Float)>>('sk_path_arc_to');
  late final _sk_path_arc_to =
      _sk_path_arc_toPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, double, double, int, int, double, double)>();

  /// void sk_path_arc_to_with_oval(sk_path_t param0, SKRect* oval, Single startAngle, Single sweepAngle, bool forceMoveTo)
  void sk_path_arc_to_with_oval(
    ffi.Pointer<ffi.Void> param0,
    ffi.Pointer<ffi.Void> oval,
    double startAngle,
    double sweepAngle,
    bool forceMoveTo,
  ) {
    return _sk_path_arc_to_with_oval(
      param0,
      oval,
      startAngle,
      sweepAngle,
      forceMoveTo,
    );
  }

  late final _sk_path_arc_to_with_ovalPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Bool)>>('sk_path_arc_to_with_oval');
  late final _sk_path_arc_to_with_oval =
      _sk_path_arc_to_with_ovalPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, double, double, bool)>();

  /// void sk_path_arc_to_with_points(sk_path_t param0, Single x1, Single y1, Single x2, Single y2, Single radius)
  void sk_path_arc_to_with_points(
    ffi.Pointer<ffi.Void> param0,
    double x1,
    double y1,
    double x2,
    double y2,
    double radius,
  ) {
    return _sk_path_arc_to_with_points(
      param0,
      x1,
      y1,
      x2,
      y2,
      radius,
    );
  }

  late final _sk_path_arc_to_with_pointsPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Float, ffi.Float, ffi.Float)>>('sk_path_arc_to_with_points');
  late final _sk_path_arc_to_with_points =
      _sk_path_arc_to_with_pointsPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, double, double, double, double)>();

  /// sk_path_t sk_path_clone(sk_path_t cpath)
  ffi.Pointer<ffi.Void> sk_path_clone(
    ffi.Pointer<ffi.Void> cpath,
  ) {
    return _sk_path_clone(
      cpath,
    );
  }

  late final _sk_path_clonePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_path_clone');
  late final _sk_path_clone =
      _sk_path_clonePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_path_close(sk_path_t param0)
  void sk_path_close(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_path_close(
      param0,
    );
  }

  late final _sk_path_closePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_path_close');
  late final _sk_path_close =
      _sk_path_closePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_path_compute_tight_bounds(sk_path_t param0, SKRect* param1)
  void sk_path_compute_tight_bounds(
    ffi.Pointer<ffi.Void> param0,
    ffi.Pointer<ffi.Void> param1,
  ) {
    return _sk_path_compute_tight_bounds(
      param0,
      param1,
    );
  }

  late final _sk_path_compute_tight_boundsPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_path_compute_tight_bounds');
  late final _sk_path_compute_tight_bounds =
      _sk_path_compute_tight_boundsPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_path_conic_to(sk_path_t param0, Single x0, Single y0, Single x1, Single y1, Single w)
  void sk_path_conic_to(
    ffi.Pointer<ffi.Void> param0,
    double x0,
    double y0,
    double x1,
    double y1,
    double w,
  ) {
    return _sk_path_conic_to(
      param0,
      x0,
      y0,
      x1,
      y1,
      w,
    );
  }

  late final _sk_path_conic_toPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Float, ffi.Float, ffi.Float)>>('sk_path_conic_to');
  late final _sk_path_conic_to =
      _sk_path_conic_toPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, double, double, double, double)>();

  /// bool sk_path_contains(sk_path_t cpath, Single x, Single y)
  bool sk_path_contains(
    ffi.Pointer<ffi.Void> cpath,
    double x,
    double y,
  ) {
    return _sk_path_contains(
      cpath,
      x,
      y,
    );
  }

  late final _sk_path_containsPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float)>>('sk_path_contains');
  late final _sk_path_contains =
      _sk_path_containsPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, double, double)>();

  /// Int32 sk_path_convert_conic_to_quads(SKPoint* p0, SKPoint* p1, SKPoint* p2, Single w, SKPoint* pts, Int32 pow2)
  int sk_path_convert_conic_to_quads(
    ffi.Pointer<ffi.Void> p0,
    ffi.Pointer<ffi.Void> p1,
    ffi.Pointer<ffi.Void> p2,
    double w,
    ffi.Pointer<ffi.Void> pts,
    int pow2,
  ) {
    return _sk_path_convert_conic_to_quads(
      p0,
      p1,
      p2,
      w,
      pts,
      pow2,
    );
  }

  late final _sk_path_convert_conic_to_quadsPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Float, ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_path_convert_conic_to_quads');
  late final _sk_path_convert_conic_to_quads =
      _sk_path_convert_conic_to_quadsPtr.asFunction<int Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, double, ffi.Pointer<ffi.Void>, int)>();

  /// Int32 sk_path_count_points(sk_path_t cpath)
  int sk_path_count_points(
    ffi.Pointer<ffi.Void> cpath,
  ) {
    return _sk_path_count_points(
      cpath,
    );
  }

  late final _sk_path_count_pointsPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_path_count_points');
  late final _sk_path_count_points =
      _sk_path_count_pointsPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_path_count_verbs(sk_path_t cpath)
  int sk_path_count_verbs(
    ffi.Pointer<ffi.Void> cpath,
  ) {
    return _sk_path_count_verbs(
      cpath,
    );
  }

  late final _sk_path_count_verbsPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_path_count_verbs');
  late final _sk_path_count_verbs =
      _sk_path_count_verbsPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// sk_path_iterator_t sk_path_create_iter(sk_path_t cpath, Int32 forceClose)
  ffi.Pointer<ffi.Void> sk_path_create_iter(
    ffi.Pointer<ffi.Void> cpath,
    int forceClose,
  ) {
    return _sk_path_create_iter(
      cpath,
      forceClose,
    );
  }

  late final _sk_path_create_iterPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_path_create_iter');
  late final _sk_path_create_iter =
      _sk_path_create_iterPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, int)>();

  /// sk_path_rawiterator_t sk_path_create_rawiter(sk_path_t cpath)
  ffi.Pointer<ffi.Void> sk_path_create_rawiter(
    ffi.Pointer<ffi.Void> cpath,
  ) {
    return _sk_path_create_rawiter(
      cpath,
    );
  }

  late final _sk_path_create_rawiterPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_path_create_rawiter');
  late final _sk_path_create_rawiter =
      _sk_path_create_rawiterPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_path_cubic_to(sk_path_t param0, Single x0, Single y0, Single x1, Single y1, Single x2, Single y2)
  void sk_path_cubic_to(
    ffi.Pointer<ffi.Void> param0,
    double x0,
    double y0,
    double x1,
    double y1,
    double x2,
    double y2,
  ) {
    return _sk_path_cubic_to(
      param0,
      x0,
      y0,
      x1,
      y1,
      x2,
      y2,
    );
  }

  late final _sk_path_cubic_toPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Float, ffi.Float, ffi.Float, ffi.Float)>>('sk_path_cubic_to');
  late final _sk_path_cubic_to =
      _sk_path_cubic_toPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, double, double, double, double, double)>();

  /// void sk_path_delete(sk_path_t param0)
  void sk_path_delete(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_path_delete(
      param0,
    );
  }

  late final _sk_path_deletePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_path_delete');
  late final _sk_path_delete =
      _sk_path_deletePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_path_get_bounds(sk_path_t param0, SKRect* param1)
  void sk_path_get_bounds(
    ffi.Pointer<ffi.Void> param0,
    ffi.Pointer<ffi.Void> param1,
  ) {
    return _sk_path_get_bounds(
      param0,
      param1,
    );
  }

  late final _sk_path_get_boundsPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_path_get_bounds');
  late final _sk_path_get_bounds =
      _sk_path_get_boundsPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// SKPathFillType sk_path_get_filltype(sk_path_t param0)
  int sk_path_get_filltype(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_path_get_filltype(
      param0,
    );
  }

  late final _sk_path_get_filltypePtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_path_get_filltype');
  late final _sk_path_get_filltype =
      _sk_path_get_filltypePtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_path_get_last_point(sk_path_t cpath, SKPoint* point)
  bool sk_path_get_last_point(
    ffi.Pointer<ffi.Void> cpath,
    ffi.Pointer<ffi.Void> point,
  ) {
    return _sk_path_get_last_point(
      cpath,
      point,
    );
  }

  late final _sk_path_get_last_pointPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_path_get_last_point');
  late final _sk_path_get_last_point =
      _sk_path_get_last_pointPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_path_get_point(sk_path_t cpath, Int32 index, SKPoint* point)
  void sk_path_get_point(
    ffi.Pointer<ffi.Void> cpath,
    int index,
    ffi.Pointer<ffi.Void> point,
  ) {
    return _sk_path_get_point(
      cpath,
      index,
      point,
    );
  }

  late final _sk_path_get_pointPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Pointer<ffi.Void>)>>('sk_path_get_point');
  late final _sk_path_get_point =
      _sk_path_get_pointPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_path_get_points(sk_path_t cpath, SKPoint* points, Int32 max)
  int sk_path_get_points(
    ffi.Pointer<ffi.Void> cpath,
    ffi.Pointer<ffi.Void> points,
    int max,
  ) {
    return _sk_path_get_points(
      cpath,
      points,
      max,
    );
  }

  late final _sk_path_get_pointsPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_path_get_points');
  late final _sk_path_get_points =
      _sk_path_get_pointsPtr.asFunction<int Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int)>();

  /// UInt32 sk_path_get_segment_masks(sk_path_t cpath)
  int sk_path_get_segment_masks(
    ffi.Pointer<ffi.Void> cpath,
  ) {
    return _sk_path_get_segment_masks(
      cpath,
    );
  }

  late final _sk_path_get_segment_masksPtr = _lookup<
      ffi.NativeFunction<ffi.Uint32 Function(ffi.Pointer<ffi.Void>)>>('sk_path_get_segment_masks');
  late final _sk_path_get_segment_masks =
      _sk_path_get_segment_masksPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_path_is_convex(sk_path_t cpath)
  bool sk_path_is_convex(
    ffi.Pointer<ffi.Void> cpath,
  ) {
    return _sk_path_is_convex(
      cpath,
    );
  }

  late final _sk_path_is_convexPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_path_is_convex');
  late final _sk_path_is_convex =
      _sk_path_is_convexPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_path_is_line(sk_path_t cpath, SKPoint* line)
  bool sk_path_is_line(
    ffi.Pointer<ffi.Void> cpath,
    ffi.Pointer<ffi.Void> line,
  ) {
    return _sk_path_is_line(
      cpath,
      line,
    );
  }

  late final _sk_path_is_linePtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_path_is_line');
  late final _sk_path_is_line =
      _sk_path_is_linePtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_path_is_oval(sk_path_t cpath, SKRect* bounds)
  bool sk_path_is_oval(
    ffi.Pointer<ffi.Void> cpath,
    ffi.Pointer<ffi.Void> bounds,
  ) {
    return _sk_path_is_oval(
      cpath,
      bounds,
    );
  }

  late final _sk_path_is_ovalPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_path_is_oval');
  late final _sk_path_is_oval =
      _sk_path_is_ovalPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_path_is_rect(sk_path_t cpath, SKRect* rect, Byte* isClosed, SKPathDirection* direction)
  bool sk_path_is_rect(
    ffi.Pointer<ffi.Void> cpath,
    ffi.Pointer<ffi.Void> rect,
    ffi.Pointer<ffi.Uint8> isClosed,
    ffi.Pointer<ffi.Int32> direction,
  ) {
    return _sk_path_is_rect(
      cpath,
      rect,
      isClosed,
      direction,
    );
  }

  late final _sk_path_is_rectPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint8>, ffi.Pointer<ffi.Int32>)>>('sk_path_is_rect');
  late final _sk_path_is_rect =
      _sk_path_is_rectPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint8>, ffi.Pointer<ffi.Int32>)>();

  /// bool sk_path_is_rrect(sk_path_t cpath, sk_rrect_t bounds)
  bool sk_path_is_rrect(
    ffi.Pointer<ffi.Void> cpath,
    ffi.Pointer<ffi.Void> bounds,
  ) {
    return _sk_path_is_rrect(
      cpath,
      bounds,
    );
  }

  late final _sk_path_is_rrectPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_path_is_rrect');
  late final _sk_path_is_rrect =
      _sk_path_is_rrectPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// Single sk_path_iter_conic_weight(sk_path_iterator_t iterator)
  double sk_path_iter_conic_weight(
    ffi.Pointer<ffi.Void> iterator,
  ) {
    return _sk_path_iter_conic_weight(
      iterator,
    );
  }

  late final _sk_path_iter_conic_weightPtr = _lookup<
      ffi.NativeFunction<ffi.Float Function(ffi.Pointer<ffi.Void>)>>('sk_path_iter_conic_weight');
  late final _sk_path_iter_conic_weight =
      _sk_path_iter_conic_weightPtr.asFunction<double Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_path_iter_destroy(sk_path_iterator_t iterator)
  void sk_path_iter_destroy(
    ffi.Pointer<ffi.Void> iterator,
  ) {
    return _sk_path_iter_destroy(
      iterator,
    );
  }

  late final _sk_path_iter_destroyPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_path_iter_destroy');
  late final _sk_path_iter_destroy =
      _sk_path_iter_destroyPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_path_iter_is_close_line(sk_path_iterator_t iterator)
  int sk_path_iter_is_close_line(
    ffi.Pointer<ffi.Void> iterator,
  ) {
    return _sk_path_iter_is_close_line(
      iterator,
    );
  }

  late final _sk_path_iter_is_close_linePtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_path_iter_is_close_line');
  late final _sk_path_iter_is_close_line =
      _sk_path_iter_is_close_linePtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_path_iter_is_closed_contour(sk_path_iterator_t iterator)
  int sk_path_iter_is_closed_contour(
    ffi.Pointer<ffi.Void> iterator,
  ) {
    return _sk_path_iter_is_closed_contour(
      iterator,
    );
  }

  late final _sk_path_iter_is_closed_contourPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_path_iter_is_closed_contour');
  late final _sk_path_iter_is_closed_contour =
      _sk_path_iter_is_closed_contourPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// SKPathVerb sk_path_iter_next(sk_path_iterator_t iterator, SKPoint* points)
  int sk_path_iter_next(
    ffi.Pointer<ffi.Void> iterator,
    ffi.Pointer<ffi.Void> points,
  ) {
    return _sk_path_iter_next(
      iterator,
      points,
    );
  }

  late final _sk_path_iter_nextPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_path_iter_next');
  late final _sk_path_iter_next =
      _sk_path_iter_nextPtr.asFunction<int Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_path_line_to(sk_path_t param0, Single x, Single y)
  void sk_path_line_to(
    ffi.Pointer<ffi.Void> param0,
    double x,
    double y,
  ) {
    return _sk_path_line_to(
      param0,
      x,
      y,
    );
  }

  late final _sk_path_line_toPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float)>>('sk_path_line_to');
  late final _sk_path_line_to =
      _sk_path_line_toPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, double)>();

  /// void sk_path_move_to(sk_path_t param0, Single x, Single y)
  void sk_path_move_to(
    ffi.Pointer<ffi.Void> param0,
    double x,
    double y,
  ) {
    return _sk_path_move_to(
      param0,
      x,
      y,
    );
  }

  late final _sk_path_move_toPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float)>>('sk_path_move_to');
  late final _sk_path_move_to =
      _sk_path_move_toPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, double)>();

  /// sk_path_t sk_path_new()
  ffi.Pointer<ffi.Void> sk_path_new() {
    return _sk_path_new();
  }

  late final _sk_path_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_path_new');
  late final _sk_path_new =
      _sk_path_newPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// bool sk_path_parse_svg_string(sk_path_t cpath, String str)
  bool sk_path_parse_svg_string(
    ffi.Pointer<ffi.Void> cpath,
    ffi.Pointer<ffi.Void> str,
  ) {
    return _sk_path_parse_svg_string(
      cpath,
      str,
    );
  }

  late final _sk_path_parse_svg_stringPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_path_parse_svg_string');
  late final _sk_path_parse_svg_string =
      _sk_path_parse_svg_stringPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_path_quad_to(sk_path_t param0, Single x0, Single y0, Single x1, Single y1)
  void sk_path_quad_to(
    ffi.Pointer<ffi.Void> param0,
    double x0,
    double y0,
    double x1,
    double y1,
  ) {
    return _sk_path_quad_to(
      param0,
      x0,
      y0,
      x1,
      y1,
    );
  }

  late final _sk_path_quad_toPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Float, ffi.Float)>>('sk_path_quad_to');
  late final _sk_path_quad_to =
      _sk_path_quad_toPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, double, double, double)>();

  /// void sk_path_rarc_to(sk_path_t param0, Single rx, Single ry, Single xAxisRotate, SKPathArcSize largeArc, SKPathDirection sweep, Single x, Single y)
  void sk_path_rarc_to(
    ffi.Pointer<ffi.Void> param0,
    double rx,
    double ry,
    double xAxisRotate,
    int largeArc,
    int sweep,
    double x,
    double y,
  ) {
    return _sk_path_rarc_to(
      param0,
      rx,
      ry,
      xAxisRotate,
      largeArc,
      sweep,
      x,
      y,
    );
  }

  late final _sk_path_rarc_toPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Float, ffi.Int32, ffi.Int32, ffi.Float, ffi.Float)>>('sk_path_rarc_to');
  late final _sk_path_rarc_to =
      _sk_path_rarc_toPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, double, double, int, int, double, double)>();

  /// Single sk_path_rawiter_conic_weight(sk_path_rawiterator_t iterator)
  double sk_path_rawiter_conic_weight(
    ffi.Pointer<ffi.Void> iterator,
  ) {
    return _sk_path_rawiter_conic_weight(
      iterator,
    );
  }

  late final _sk_path_rawiter_conic_weightPtr = _lookup<
      ffi.NativeFunction<ffi.Float Function(ffi.Pointer<ffi.Void>)>>('sk_path_rawiter_conic_weight');
  late final _sk_path_rawiter_conic_weight =
      _sk_path_rawiter_conic_weightPtr.asFunction<double Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_path_rawiter_destroy(sk_path_rawiterator_t iterator)
  void sk_path_rawiter_destroy(
    ffi.Pointer<ffi.Void> iterator,
  ) {
    return _sk_path_rawiter_destroy(
      iterator,
    );
  }

  late final _sk_path_rawiter_destroyPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_path_rawiter_destroy');
  late final _sk_path_rawiter_destroy =
      _sk_path_rawiter_destroyPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// SKPathVerb sk_path_rawiter_next(sk_path_rawiterator_t iterator, SKPoint* points)
  int sk_path_rawiter_next(
    ffi.Pointer<ffi.Void> iterator,
    ffi.Pointer<ffi.Void> points,
  ) {
    return _sk_path_rawiter_next(
      iterator,
      points,
    );
  }

  late final _sk_path_rawiter_nextPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_path_rawiter_next');
  late final _sk_path_rawiter_next =
      _sk_path_rawiter_nextPtr.asFunction<int Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// SKPathVerb sk_path_rawiter_peek(sk_path_rawiterator_t iterator)
  int sk_path_rawiter_peek(
    ffi.Pointer<ffi.Void> iterator,
  ) {
    return _sk_path_rawiter_peek(
      iterator,
    );
  }

  late final _sk_path_rawiter_peekPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_path_rawiter_peek');
  late final _sk_path_rawiter_peek =
      _sk_path_rawiter_peekPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_path_rconic_to(sk_path_t param0, Single dx0, Single dy0, Single dx1, Single dy1, Single w)
  void sk_path_rconic_to(
    ffi.Pointer<ffi.Void> param0,
    double dx0,
    double dy0,
    double dx1,
    double dy1,
    double w,
  ) {
    return _sk_path_rconic_to(
      param0,
      dx0,
      dy0,
      dx1,
      dy1,
      w,
    );
  }

  late final _sk_path_rconic_toPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Float, ffi.Float, ffi.Float)>>('sk_path_rconic_to');
  late final _sk_path_rconic_to =
      _sk_path_rconic_toPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, double, double, double, double)>();

  /// void sk_path_rcubic_to(sk_path_t param0, Single dx0, Single dy0, Single dx1, Single dy1, Single dx2, Single dy2)
  void sk_path_rcubic_to(
    ffi.Pointer<ffi.Void> param0,
    double dx0,
    double dy0,
    double dx1,
    double dy1,
    double dx2,
    double dy2,
  ) {
    return _sk_path_rcubic_to(
      param0,
      dx0,
      dy0,
      dx1,
      dy1,
      dx2,
      dy2,
    );
  }

  late final _sk_path_rcubic_toPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Float, ffi.Float, ffi.Float, ffi.Float)>>('sk_path_rcubic_to');
  late final _sk_path_rcubic_to =
      _sk_path_rcubic_toPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, double, double, double, double, double)>();

  /// void sk_path_reset(sk_path_t cpath)
  void sk_path_reset(
    ffi.Pointer<ffi.Void> cpath,
  ) {
    return _sk_path_reset(
      cpath,
    );
  }

  late final _sk_path_resetPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_path_reset');
  late final _sk_path_reset =
      _sk_path_resetPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_path_rewind(sk_path_t cpath)
  void sk_path_rewind(
    ffi.Pointer<ffi.Void> cpath,
  ) {
    return _sk_path_rewind(
      cpath,
    );
  }

  late final _sk_path_rewindPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_path_rewind');
  late final _sk_path_rewind =
      _sk_path_rewindPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_path_rline_to(sk_path_t param0, Single dx, Single yd)
  void sk_path_rline_to(
    ffi.Pointer<ffi.Void> param0,
    double dx,
    double yd,
  ) {
    return _sk_path_rline_to(
      param0,
      dx,
      yd,
    );
  }

  late final _sk_path_rline_toPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float)>>('sk_path_rline_to');
  late final _sk_path_rline_to =
      _sk_path_rline_toPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, double)>();

  /// void sk_path_rmove_to(sk_path_t param0, Single dx, Single dy)
  void sk_path_rmove_to(
    ffi.Pointer<ffi.Void> param0,
    double dx,
    double dy,
  ) {
    return _sk_path_rmove_to(
      param0,
      dx,
      dy,
    );
  }

  late final _sk_path_rmove_toPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float)>>('sk_path_rmove_to');
  late final _sk_path_rmove_to =
      _sk_path_rmove_toPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, double)>();

  /// void sk_path_rquad_to(sk_path_t param0, Single dx0, Single dy0, Single dx1, Single dy1)
  void sk_path_rquad_to(
    ffi.Pointer<ffi.Void> param0,
    double dx0,
    double dy0,
    double dx1,
    double dy1,
  ) {
    return _sk_path_rquad_to(
      param0,
      dx0,
      dy0,
      dx1,
      dy1,
    );
  }

  late final _sk_path_rquad_toPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Float, ffi.Float)>>('sk_path_rquad_to');
  late final _sk_path_rquad_to =
      _sk_path_rquad_toPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, double, double, double)>();

  /// void sk_path_set_filltype(sk_path_t param0, SKPathFillType param1)
  void sk_path_set_filltype(
    ffi.Pointer<ffi.Void> param0,
    int param1,
  ) {
    return _sk_path_set_filltype(
      param0,
      param1,
    );
  }

  late final _sk_path_set_filltypePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_path_set_filltype');
  late final _sk_path_set_filltype =
      _sk_path_set_filltypePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int)>();

  /// void sk_path_to_svg_string(sk_path_t cpath, sk_string_t str)
  void sk_path_to_svg_string(
    ffi.Pointer<ffi.Void> cpath,
    ffi.Pointer<ffi.Void> str,
  ) {
    return _sk_path_to_svg_string(
      cpath,
      str,
    );
  }

  late final _sk_path_to_svg_stringPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_path_to_svg_string');
  late final _sk_path_to_svg_string =
      _sk_path_to_svg_stringPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_path_transform(sk_path_t cpath, SKMatrix* cmatrix)
  void sk_path_transform(
    ffi.Pointer<ffi.Void> cpath,
    ffi.Pointer<ffi.Void> cmatrix,
  ) {
    return _sk_path_transform(
      cpath,
      cmatrix,
    );
  }

  late final _sk_path_transformPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_path_transform');
  late final _sk_path_transform =
      _sk_path_transformPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_path_transform_to_dest(sk_path_t cpath, SKMatrix* cmatrix, sk_path_t destination)
  void sk_path_transform_to_dest(
    ffi.Pointer<ffi.Void> cpath,
    ffi.Pointer<ffi.Void> cmatrix,
    ffi.Pointer<ffi.Void> destination,
  ) {
    return _sk_path_transform_to_dest(
      cpath,
      cmatrix,
      destination,
    );
  }

  late final _sk_path_transform_to_destPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_path_transform_to_dest');
  late final _sk_path_transform_to_dest =
      _sk_path_transform_to_destPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_pathmeasure_destroy(sk_pathmeasure_t pathMeasure)
  void sk_pathmeasure_destroy(
    ffi.Pointer<ffi.Void> pathMeasure,
  ) {
    return _sk_pathmeasure_destroy(
      pathMeasure,
    );
  }

  late final _sk_pathmeasure_destroyPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_pathmeasure_destroy');
  late final _sk_pathmeasure_destroy =
      _sk_pathmeasure_destroyPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// Single sk_pathmeasure_get_length(sk_pathmeasure_t pathMeasure)
  double sk_pathmeasure_get_length(
    ffi.Pointer<ffi.Void> pathMeasure,
  ) {
    return _sk_pathmeasure_get_length(
      pathMeasure,
    );
  }

  late final _sk_pathmeasure_get_lengthPtr = _lookup<
      ffi.NativeFunction<ffi.Float Function(ffi.Pointer<ffi.Void>)>>('sk_pathmeasure_get_length');
  late final _sk_pathmeasure_get_length =
      _sk_pathmeasure_get_lengthPtr.asFunction<double Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_pathmeasure_get_matrix(sk_pathmeasure_t pathMeasure, Single distance, SKMatrix* matrix, SKPathMeasureMatrixFlags flags)
  bool sk_pathmeasure_get_matrix(
    ffi.Pointer<ffi.Void> pathMeasure,
    double distance,
    ffi.Pointer<ffi.Void> matrix,
    int flags,
  ) {
    return _sk_pathmeasure_get_matrix(
      pathMeasure,
      distance,
      matrix,
      flags,
    );
  }

  late final _sk_pathmeasure_get_matrixPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_pathmeasure_get_matrix');
  late final _sk_pathmeasure_get_matrix =
      _sk_pathmeasure_get_matrixPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, double, ffi.Pointer<ffi.Void>, int)>();

  /// bool sk_pathmeasure_get_pos_tan(sk_pathmeasure_t pathMeasure, Single distance, SKPoint* position, SKPoint* tangent)
  bool sk_pathmeasure_get_pos_tan(
    ffi.Pointer<ffi.Void> pathMeasure,
    double distance,
    ffi.Pointer<ffi.Void> position,
    ffi.Pointer<ffi.Void> tangent,
  ) {
    return _sk_pathmeasure_get_pos_tan(
      pathMeasure,
      distance,
      position,
      tangent,
    );
  }

  late final _sk_pathmeasure_get_pos_tanPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_pathmeasure_get_pos_tan');
  late final _sk_pathmeasure_get_pos_tan =
      _sk_pathmeasure_get_pos_tanPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, double, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_pathmeasure_get_segment(sk_pathmeasure_t pathMeasure, Single start, Single stop, sk_path_t dst, bool startWithMoveTo)
  bool sk_pathmeasure_get_segment(
    ffi.Pointer<ffi.Void> pathMeasure,
    double start,
    double stop,
    ffi.Pointer<ffi.Void> dst,
    bool startWithMoveTo,
  ) {
    return _sk_pathmeasure_get_segment(
      pathMeasure,
      start,
      stop,
      dst,
      startWithMoveTo,
    );
  }

  late final _sk_pathmeasure_get_segmentPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>, ffi.Bool)>>('sk_pathmeasure_get_segment');
  late final _sk_pathmeasure_get_segment =
      _sk_pathmeasure_get_segmentPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, double, double, ffi.Pointer<ffi.Void>, bool)>();

  /// bool sk_pathmeasure_is_closed(sk_pathmeasure_t pathMeasure)
  bool sk_pathmeasure_is_closed(
    ffi.Pointer<ffi.Void> pathMeasure,
  ) {
    return _sk_pathmeasure_is_closed(
      pathMeasure,
    );
  }

  late final _sk_pathmeasure_is_closedPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_pathmeasure_is_closed');
  late final _sk_pathmeasure_is_closed =
      _sk_pathmeasure_is_closedPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// sk_pathmeasure_t sk_pathmeasure_new()
  ffi.Pointer<ffi.Void> sk_pathmeasure_new() {
    return _sk_pathmeasure_new();
  }

  late final _sk_pathmeasure_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_pathmeasure_new');
  late final _sk_pathmeasure_new =
      _sk_pathmeasure_newPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// sk_pathmeasure_t sk_pathmeasure_new_with_path(sk_path_t path, bool forceClosed, Single resScale)
  ffi.Pointer<ffi.Void> sk_pathmeasure_new_with_path(
    ffi.Pointer<ffi.Void> path,
    bool forceClosed,
    double resScale,
  ) {
    return _sk_pathmeasure_new_with_path(
      path,
      forceClosed,
      resScale,
    );
  }

  late final _sk_pathmeasure_new_with_pathPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Bool, ffi.Float)>>('sk_pathmeasure_new_with_path');
  late final _sk_pathmeasure_new_with_path =
      _sk_pathmeasure_new_with_pathPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, bool, double)>();

  /// bool sk_pathmeasure_next_contour(sk_pathmeasure_t pathMeasure)
  bool sk_pathmeasure_next_contour(
    ffi.Pointer<ffi.Void> pathMeasure,
  ) {
    return _sk_pathmeasure_next_contour(
      pathMeasure,
    );
  }

  late final _sk_pathmeasure_next_contourPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_pathmeasure_next_contour');
  late final _sk_pathmeasure_next_contour =
      _sk_pathmeasure_next_contourPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_pathmeasure_set_path(sk_pathmeasure_t pathMeasure, sk_path_t path, bool forceClosed)
  void sk_pathmeasure_set_path(
    ffi.Pointer<ffi.Void> pathMeasure,
    ffi.Pointer<ffi.Void> path,
    bool forceClosed,
  ) {
    return _sk_pathmeasure_set_path(
      pathMeasure,
      path,
      forceClosed,
    );
  }

  late final _sk_pathmeasure_set_pathPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Bool)>>('sk_pathmeasure_set_path');
  late final _sk_pathmeasure_set_path =
      _sk_pathmeasure_set_pathPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, bool)>();

  /// bool sk_pathop_as_winding(sk_path_t path, sk_path_t result)
  bool sk_pathop_as_winding(
    ffi.Pointer<ffi.Void> path,
    ffi.Pointer<ffi.Void> result,
  ) {
    return _sk_pathop_as_winding(
      path,
      result,
    );
  }

  late final _sk_pathop_as_windingPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_pathop_as_winding');
  late final _sk_pathop_as_winding =
      _sk_pathop_as_windingPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_pathop_op(sk_path_t one, sk_path_t two, SKPathOp op, sk_path_t result)
  bool sk_pathop_op(
    ffi.Pointer<ffi.Void> one,
    ffi.Pointer<ffi.Void> two,
    int op,
    ffi.Pointer<ffi.Void> result,
  ) {
    return _sk_pathop_op(
      one,
      two,
      op,
      result,
    );
  }

  late final _sk_pathop_opPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Pointer<ffi.Void>)>>('sk_pathop_op');
  late final _sk_pathop_op =
      _sk_pathop_opPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>)>();

  /// bool sk_pathop_simplify(sk_path_t path, sk_path_t result)
  bool sk_pathop_simplify(
    ffi.Pointer<ffi.Void> path,
    ffi.Pointer<ffi.Void> result,
  ) {
    return _sk_pathop_simplify(
      path,
      result,
    );
  }

  late final _sk_pathop_simplifyPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_pathop_simplify');
  late final _sk_pathop_simplify =
      _sk_pathop_simplifyPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_pathop_tight_bounds(sk_path_t path, SKRect* result)
  bool sk_pathop_tight_bounds(
    ffi.Pointer<ffi.Void> path,
    ffi.Pointer<ffi.Void> result,
  ) {
    return _sk_pathop_tight_bounds(
      path,
      result,
    );
  }

  late final _sk_pathop_tight_boundsPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_pathop_tight_bounds');
  late final _sk_pathop_tight_bounds =
      _sk_pathop_tight_boundsPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_path_effect_t sk_path_effect_create_1d_path(sk_path_t path, Single advance, Single phase, SKPath1DPathEffectStyle style)
  ffi.Pointer<ffi.Void> sk_path_effect_create_1d_path(
    ffi.Pointer<ffi.Void> path,
    double advance,
    double phase,
    ffi.Pointer<ffi.Void> style,
  ) {
    return _sk_path_effect_create_1d_path(
      path,
      advance,
      phase,
      style,
    );
  }

  late final _sk_path_effect_create_1d_pathPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>)>>('sk_path_effect_create_1d_path');
  late final _sk_path_effect_create_1d_path =
      _sk_path_effect_create_1d_pathPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, double, double, ffi.Pointer<ffi.Void>)>();

  /// sk_path_effect_t sk_path_effect_create_2d_line(Single width, SKMatrix* matrix)
  ffi.Pointer<ffi.Void> sk_path_effect_create_2d_line(
    double width,
    ffi.Pointer<ffi.Void> matrix,
  ) {
    return _sk_path_effect_create_2d_line(
      width,
      matrix,
    );
  }

  late final _sk_path_effect_create_2d_linePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Float, ffi.Pointer<ffi.Void>)>>('sk_path_effect_create_2d_line');
  late final _sk_path_effect_create_2d_line =
      _sk_path_effect_create_2d_linePtr.asFunction<ffi.Pointer<ffi.Void> Function(double, ffi.Pointer<ffi.Void>)>();

  /// sk_path_effect_t sk_path_effect_create_2d_path(SKMatrix* matrix, sk_path_t path)
  ffi.Pointer<ffi.Void> sk_path_effect_create_2d_path(
    ffi.Pointer<ffi.Void> matrix,
    ffi.Pointer<ffi.Void> path,
  ) {
    return _sk_path_effect_create_2d_path(
      matrix,
      path,
    );
  }

  late final _sk_path_effect_create_2d_pathPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_path_effect_create_2d_path');
  late final _sk_path_effect_create_2d_path =
      _sk_path_effect_create_2d_pathPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_path_effect_t sk_path_effect_create_compose(sk_path_effect_t outer, sk_path_effect_t inner)
  ffi.Pointer<ffi.Void> sk_path_effect_create_compose(
    ffi.Pointer<ffi.Void> outer,
    ffi.Pointer<ffi.Void> inner,
  ) {
    return _sk_path_effect_create_compose(
      outer,
      inner,
    );
  }

  late final _sk_path_effect_create_composePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_path_effect_create_compose');
  late final _sk_path_effect_create_compose =
      _sk_path_effect_create_composePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_path_effect_t sk_path_effect_create_corner(Single radius)
  ffi.Pointer<ffi.Void> sk_path_effect_create_corner(
    double radius,
  ) {
    return _sk_path_effect_create_corner(
      radius,
    );
  }

  late final _sk_path_effect_create_cornerPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Float)>>('sk_path_effect_create_corner');
  late final _sk_path_effect_create_corner =
      _sk_path_effect_create_cornerPtr.asFunction<ffi.Pointer<ffi.Void> Function(double)>();

  /// sk_path_effect_t sk_path_effect_create_dash(Single* intervals, Int32 count, Single phase)
  ffi.Pointer<ffi.Void> sk_path_effect_create_dash(
    ffi.Pointer<ffi.Float> intervals,
    int count,
    double phase,
  ) {
    return _sk_path_effect_create_dash(
      intervals,
      count,
      phase,
    );
  }

  late final _sk_path_effect_create_dashPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Float>, ffi.Int32, ffi.Float)>>('sk_path_effect_create_dash');
  late final _sk_path_effect_create_dash =
      _sk_path_effect_create_dashPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Float>, int, double)>();

  /// sk_path_effect_t sk_path_effect_create_discrete(Single segLength, Single deviation, UInt32 seedAssist)
  ffi.Pointer<ffi.Void> sk_path_effect_create_discrete(
    double segLength,
    double deviation,
    int seedAssist,
  ) {
    return _sk_path_effect_create_discrete(
      segLength,
      deviation,
      seedAssist,
    );
  }

  late final _sk_path_effect_create_discretePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Float, ffi.Float, ffi.Uint32)>>('sk_path_effect_create_discrete');
  late final _sk_path_effect_create_discrete =
      _sk_path_effect_create_discretePtr.asFunction<ffi.Pointer<ffi.Void> Function(double, double, int)>();

  /// sk_path_effect_t sk_path_effect_create_sum(sk_path_effect_t first, sk_path_effect_t second)
  ffi.Pointer<ffi.Void> sk_path_effect_create_sum(
    ffi.Pointer<ffi.Void> first,
    ffi.Pointer<ffi.Void> second,
  ) {
    return _sk_path_effect_create_sum(
      first,
      second,
    );
  }

  late final _sk_path_effect_create_sumPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_path_effect_create_sum');
  late final _sk_path_effect_create_sum =
      _sk_path_effect_create_sumPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_path_effect_t sk_path_effect_create_trim(Single start, Single stop, SKTrimPathEffectMode mode)
  ffi.Pointer<ffi.Void> sk_path_effect_create_trim(
    double start,
    double stop,
    int mode,
  ) {
    return _sk_path_effect_create_trim(
      start,
      stop,
      mode,
    );
  }

  late final _sk_path_effect_create_trimPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Float, ffi.Float, ffi.Int32)>>('sk_path_effect_create_trim');
  late final _sk_path_effect_create_trim =
      _sk_path_effect_create_trimPtr.asFunction<ffi.Pointer<ffi.Void> Function(double, double, int)>();

  /// void sk_path_effect_unref(sk_path_effect_t t)
  void sk_path_effect_unref(
    ffi.Pointer<ffi.Void> t,
  ) {
    return _sk_path_effect_unref(
      t,
    );
  }

  late final _sk_path_effect_unrefPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_path_effect_unref');
  late final _sk_path_effect_unref =
      _sk_path_effect_unrefPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// IntPtr sk_picture_approximate_bytes_used(sk_picture_t picture)
  ffi.Pointer<ffi.Void> sk_picture_approximate_bytes_used(
    ffi.Pointer<ffi.Void> picture,
  ) {
    return _sk_picture_approximate_bytes_used(
      picture,
    );
  }

  late final _sk_picture_approximate_bytes_usedPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_picture_approximate_bytes_used');
  late final _sk_picture_approximate_bytes_used =
      _sk_picture_approximate_bytes_usedPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_picture_approximate_op_count(sk_picture_t picture, bool nested)
  int sk_picture_approximate_op_count(
    ffi.Pointer<ffi.Void> picture,
    bool nested,
  ) {
    return _sk_picture_approximate_op_count(
      picture,
      nested,
    );
  }

  late final _sk_picture_approximate_op_countPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>, ffi.Bool)>>('sk_picture_approximate_op_count');
  late final _sk_picture_approximate_op_count =
      _sk_picture_approximate_op_countPtr.asFunction<int Function(ffi.Pointer<ffi.Void>, bool)>();

  /// sk_picture_t sk_picture_deserialize_from_data(sk_data_t data)
  ffi.Pointer<ffi.Void> sk_picture_deserialize_from_data(
    ffi.Pointer<ffi.Void> data,
  ) {
    return _sk_picture_deserialize_from_data(
      data,
    );
  }

  late final _sk_picture_deserialize_from_dataPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_picture_deserialize_from_data');
  late final _sk_picture_deserialize_from_data =
      _sk_picture_deserialize_from_dataPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_picture_t sk_picture_deserialize_from_memory(void* buffer, IntPtr length)
  ffi.Pointer<ffi.Void> sk_picture_deserialize_from_memory(
    ffi.Pointer<ffi.Void> buffer,
    ffi.Pointer<ffi.Void> length,
  ) {
    return _sk_picture_deserialize_from_memory(
      buffer,
      length,
    );
  }

  late final _sk_picture_deserialize_from_memoryPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_picture_deserialize_from_memory');
  late final _sk_picture_deserialize_from_memory =
      _sk_picture_deserialize_from_memoryPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_picture_t sk_picture_deserialize_from_stream(sk_stream_t stream)
  ffi.Pointer<ffi.Void> sk_picture_deserialize_from_stream(
    ffi.Pointer<ffi.Void> stream,
  ) {
    return _sk_picture_deserialize_from_stream(
      stream,
    );
  }

  late final _sk_picture_deserialize_from_streamPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_picture_deserialize_from_stream');
  late final _sk_picture_deserialize_from_stream =
      _sk_picture_deserialize_from_streamPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_picture_get_cull_rect(sk_picture_t param0, SKRect* param1)
  void sk_picture_get_cull_rect(
    ffi.Pointer<ffi.Void> param0,
    ffi.Pointer<ffi.Void> param1,
  ) {
    return _sk_picture_get_cull_rect(
      param0,
      param1,
    );
  }

  late final _sk_picture_get_cull_rectPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_picture_get_cull_rect');
  late final _sk_picture_get_cull_rect =
      _sk_picture_get_cull_rectPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_canvas_t sk_picture_get_recording_canvas(sk_picture_recorder_t crec)
  ffi.Pointer<ffi.Void> sk_picture_get_recording_canvas(
    ffi.Pointer<ffi.Void> crec,
  ) {
    return _sk_picture_get_recording_canvas(
      crec,
    );
  }

  late final _sk_picture_get_recording_canvasPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_picture_get_recording_canvas');
  late final _sk_picture_get_recording_canvas =
      _sk_picture_get_recording_canvasPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// UInt32 sk_picture_get_unique_id(sk_picture_t param0)
  int sk_picture_get_unique_id(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_picture_get_unique_id(
      param0,
    );
  }

  late final _sk_picture_get_unique_idPtr = _lookup<
      ffi.NativeFunction<ffi.Uint32 Function(ffi.Pointer<ffi.Void>)>>('sk_picture_get_unique_id');
  late final _sk_picture_get_unique_id =
      _sk_picture_get_unique_idPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// sk_shader_t sk_picture_make_shader(sk_picture_t src, SKShaderTileMode tmx, SKShaderTileMode tmy, SKFilterMode mode, SKMatrix* localMatrix, SKRect* tile)
  ffi.Pointer<ffi.Void> sk_picture_make_shader(
    ffi.Pointer<ffi.Void> src,
    int tmx,
    int tmy,
    int mode,
    ffi.Pointer<ffi.Void> localMatrix,
    ffi.Pointer<ffi.Void> tile,
  ) {
    return _sk_picture_make_shader(
      src,
      tmx,
      tmy,
      mode,
      localMatrix,
      tile,
    );
  }

  late final _sk_picture_make_shaderPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_picture_make_shader');
  late final _sk_picture_make_shader =
      _sk_picture_make_shaderPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, int, int, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_picture_playback(sk_picture_t picture, sk_canvas_t canvas)
  void sk_picture_playback(
    ffi.Pointer<ffi.Void> picture,
    ffi.Pointer<ffi.Void> canvas,
  ) {
    return _sk_picture_playback(
      picture,
      canvas,
    );
  }

  late final _sk_picture_playbackPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_picture_playback');
  late final _sk_picture_playback =
      _sk_picture_playbackPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_canvas_t sk_picture_recorder_begin_recording(sk_picture_recorder_t param0, SKRect* param1)
  ffi.Pointer<ffi.Void> sk_picture_recorder_begin_recording(
    ffi.Pointer<ffi.Void> param0,
    ffi.Pointer<ffi.Void> param1,
  ) {
    return _sk_picture_recorder_begin_recording(
      param0,
      param1,
    );
  }

  late final _sk_picture_recorder_begin_recordingPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_picture_recorder_begin_recording');
  late final _sk_picture_recorder_begin_recording =
      _sk_picture_recorder_begin_recordingPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_canvas_t sk_picture_recorder_begin_recording_with_bbh_factory(sk_picture_recorder_t param0, SKRect* param1, sk_bbh_factory_t param2)
  ffi.Pointer<ffi.Void> sk_picture_recorder_begin_recording_with_bbh_factory(
    ffi.Pointer<ffi.Void> param0,
    ffi.Pointer<ffi.Void> param1,
    ffi.Pointer<ffi.Void> param2,
  ) {
    return _sk_picture_recorder_begin_recording_with_bbh_factory(
      param0,
      param1,
      param2,
    );
  }

  late final _sk_picture_recorder_begin_recording_with_bbh_factoryPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_picture_recorder_begin_recording_with_bbh_factory');
  late final _sk_picture_recorder_begin_recording_with_bbh_factory =
      _sk_picture_recorder_begin_recording_with_bbh_factoryPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_picture_recorder_delete(sk_picture_recorder_t param0)
  void sk_picture_recorder_delete(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_picture_recorder_delete(
      param0,
    );
  }

  late final _sk_picture_recorder_deletePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_picture_recorder_delete');
  late final _sk_picture_recorder_delete =
      _sk_picture_recorder_deletePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// sk_picture_t sk_picture_recorder_end_recording(sk_picture_recorder_t param0)
  ffi.Pointer<ffi.Void> sk_picture_recorder_end_recording(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_picture_recorder_end_recording(
      param0,
    );
  }

  late final _sk_picture_recorder_end_recordingPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_picture_recorder_end_recording');
  late final _sk_picture_recorder_end_recording =
      _sk_picture_recorder_end_recordingPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_drawable_t sk_picture_recorder_end_recording_as_drawable(sk_picture_recorder_t param0)
  ffi.Pointer<ffi.Void> sk_picture_recorder_end_recording_as_drawable(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_picture_recorder_end_recording_as_drawable(
      param0,
    );
  }

  late final _sk_picture_recorder_end_recording_as_drawablePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_picture_recorder_end_recording_as_drawable');
  late final _sk_picture_recorder_end_recording_as_drawable =
      _sk_picture_recorder_end_recording_as_drawablePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_picture_recorder_t sk_picture_recorder_new()
  ffi.Pointer<ffi.Void> sk_picture_recorder_new() {
    return _sk_picture_recorder_new();
  }

  late final _sk_picture_recorder_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_picture_recorder_new');
  late final _sk_picture_recorder_new =
      _sk_picture_recorder_newPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// void sk_picture_ref(sk_picture_t param0)
  void sk_picture_ref(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_picture_ref(
      param0,
    );
  }

  late final _sk_picture_refPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_picture_ref');
  late final _sk_picture_ref =
      _sk_picture_refPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// sk_data_t sk_picture_serialize_to_data(sk_picture_t picture)
  ffi.Pointer<ffi.Void> sk_picture_serialize_to_data(
    ffi.Pointer<ffi.Void> picture,
  ) {
    return _sk_picture_serialize_to_data(
      picture,
    );
  }

  late final _sk_picture_serialize_to_dataPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_picture_serialize_to_data');
  late final _sk_picture_serialize_to_data =
      _sk_picture_serialize_to_dataPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_picture_serialize_to_stream(sk_picture_t picture, sk_wstream_t stream)
  void sk_picture_serialize_to_stream(
    ffi.Pointer<ffi.Void> picture,
    ffi.Pointer<ffi.Void> stream,
  ) {
    return _sk_picture_serialize_to_stream(
      picture,
      stream,
    );
  }

  late final _sk_picture_serialize_to_streamPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_picture_serialize_to_stream');
  late final _sk_picture_serialize_to_stream =
      _sk_picture_serialize_to_streamPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_picture_unref(sk_picture_t param0)
  void sk_picture_unref(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_picture_unref(
      param0,
    );
  }

  late final _sk_picture_unrefPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_picture_unref');
  late final _sk_picture_unref =
      _sk_picture_unrefPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_rtree_factory_delete(sk_rtree_factory_t param0)
  void sk_rtree_factory_delete(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_rtree_factory_delete(
      param0,
    );
  }

  late final _sk_rtree_factory_deletePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_rtree_factory_delete');
  late final _sk_rtree_factory_delete =
      _sk_rtree_factory_deletePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// sk_rtree_factory_t sk_rtree_factory_new()
  ffi.Pointer<ffi.Void> sk_rtree_factory_new() {
    return _sk_rtree_factory_new();
  }

  late final _sk_rtree_factory_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_rtree_factory_new');
  late final _sk_rtree_factory_new =
      _sk_rtree_factory_newPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// void sk_color_get_bit_shift(Int32* a, Int32* r, Int32* g, Int32* b)
  void sk_color_get_bit_shift(
    ffi.Pointer<ffi.Int32> a,
    ffi.Pointer<ffi.Int32> r,
    ffi.Pointer<ffi.Int32> g,
    ffi.Pointer<ffi.Int32> b,
  ) {
    return _sk_color_get_bit_shift(
      a,
      r,
      g,
      b,
    );
  }

  late final _sk_color_get_bit_shiftPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Int32>, ffi.Pointer<ffi.Int32>, ffi.Pointer<ffi.Int32>, ffi.Pointer<ffi.Int32>)>>('sk_color_get_bit_shift');
  late final _sk_color_get_bit_shift =
      _sk_color_get_bit_shiftPtr.asFunction<void Function(ffi.Pointer<ffi.Int32>, ffi.Pointer<ffi.Int32>, ffi.Pointer<ffi.Int32>, ffi.Pointer<ffi.Int32>)>();

  /// UInt32 sk_color_premultiply(UInt32 color)
  int sk_color_premultiply(
    int color,
  ) {
    return _sk_color_premultiply(
      color,
    );
  }

  late final _sk_color_premultiplyPtr = _lookup<
      ffi.NativeFunction<ffi.Uint32 Function(ffi.Uint32)>>('sk_color_premultiply');
  late final _sk_color_premultiply =
      _sk_color_premultiplyPtr.asFunction<int Function(int)>();

  /// void sk_color_premultiply_array(UInt32* colors, Int32 size, UInt32* pmcolors)
  void sk_color_premultiply_array(
    ffi.Pointer<ffi.Uint32> colors,
    int size,
    ffi.Pointer<ffi.Uint32> pmcolors,
  ) {
    return _sk_color_premultiply_array(
      colors,
      size,
      pmcolors,
    );
  }

  late final _sk_color_premultiply_arrayPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Uint32>, ffi.Int32, ffi.Pointer<ffi.Uint32>)>>('sk_color_premultiply_array');
  late final _sk_color_premultiply_array =
      _sk_color_premultiply_arrayPtr.asFunction<void Function(ffi.Pointer<ffi.Uint32>, int, ffi.Pointer<ffi.Uint32>)>();

  /// UInt32 sk_color_unpremultiply(UInt32 pmcolor)
  int sk_color_unpremultiply(
    int pmcolor,
  ) {
    return _sk_color_unpremultiply(
      pmcolor,
    );
  }

  late final _sk_color_unpremultiplyPtr = _lookup<
      ffi.NativeFunction<ffi.Uint32 Function(ffi.Uint32)>>('sk_color_unpremultiply');
  late final _sk_color_unpremultiply =
      _sk_color_unpremultiplyPtr.asFunction<int Function(int)>();

  /// void sk_color_unpremultiply_array(UInt32* pmcolors, Int32 size, UInt32* colors)
  void sk_color_unpremultiply_array(
    ffi.Pointer<ffi.Uint32> pmcolors,
    int size,
    ffi.Pointer<ffi.Uint32> colors,
  ) {
    return _sk_color_unpremultiply_array(
      pmcolors,
      size,
      colors,
    );
  }

  late final _sk_color_unpremultiply_arrayPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Uint32>, ffi.Int32, ffi.Pointer<ffi.Uint32>)>>('sk_color_unpremultiply_array');
  late final _sk_color_unpremultiply_array =
      _sk_color_unpremultiply_arrayPtr.asFunction<void Function(ffi.Pointer<ffi.Uint32>, int, ffi.Pointer<ffi.Uint32>)>();

  /// bool sk_jpegencoder_encode(sk_wstream_t dst, sk_pixmap_t src, SKJpegEncoderOptions* options)
  bool sk_jpegencoder_encode(
    ffi.Pointer<ffi.Void> dst,
    ffi.Pointer<ffi.Void> src,
    ffi.Pointer<ffi.Void> options,
  ) {
    return _sk_jpegencoder_encode(
      dst,
      src,
      options,
    );
  }

  late final _sk_jpegencoder_encodePtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_jpegencoder_encode');
  late final _sk_jpegencoder_encode =
      _sk_jpegencoder_encodePtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_pixmap_compute_is_opaque(sk_pixmap_t cpixmap)
  bool sk_pixmap_compute_is_opaque(
    ffi.Pointer<ffi.Void> cpixmap,
  ) {
    return _sk_pixmap_compute_is_opaque(
      cpixmap,
    );
  }

  late final _sk_pixmap_compute_is_opaquePtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_pixmap_compute_is_opaque');
  late final _sk_pixmap_compute_is_opaque =
      _sk_pixmap_compute_is_opaquePtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_pixmap_destructor(sk_pixmap_t cpixmap)
  void sk_pixmap_destructor(
    ffi.Pointer<ffi.Void> cpixmap,
  ) {
    return _sk_pixmap_destructor(
      cpixmap,
    );
  }

  late final _sk_pixmap_destructorPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_pixmap_destructor');
  late final _sk_pixmap_destructor =
      _sk_pixmap_destructorPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_pixmap_erase_color(sk_pixmap_t cpixmap, UInt32 color, SKRectI* subset)
  bool sk_pixmap_erase_color(
    ffi.Pointer<ffi.Void> cpixmap,
    int color,
    ffi.Pointer<ffi.Void> subset,
  ) {
    return _sk_pixmap_erase_color(
      cpixmap,
      color,
      subset,
    );
  }

  late final _sk_pixmap_erase_colorPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Uint32, ffi.Pointer<ffi.Void>)>>('sk_pixmap_erase_color');
  late final _sk_pixmap_erase_color =
      _sk_pixmap_erase_colorPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>)>();

  /// bool sk_pixmap_erase_color4f(sk_pixmap_t cpixmap, SKColorF* color, SKRectI* subset)
  bool sk_pixmap_erase_color4f(
    ffi.Pointer<ffi.Void> cpixmap,
    ffi.Pointer<ffi.Void> color,
    ffi.Pointer<ffi.Void> subset,
  ) {
    return _sk_pixmap_erase_color4f(
      cpixmap,
      color,
      subset,
    );
  }

  late final _sk_pixmap_erase_color4fPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_pixmap_erase_color4f');
  late final _sk_pixmap_erase_color4f =
      _sk_pixmap_erase_color4fPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_pixmap_extract_subset(sk_pixmap_t cpixmap, sk_pixmap_t result, SKRectI* subset)
  bool sk_pixmap_extract_subset(
    ffi.Pointer<ffi.Void> cpixmap,
    ffi.Pointer<ffi.Void> result,
    ffi.Pointer<ffi.Void> subset,
  ) {
    return _sk_pixmap_extract_subset(
      cpixmap,
      result,
      subset,
    );
  }

  late final _sk_pixmap_extract_subsetPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_pixmap_extract_subset');
  late final _sk_pixmap_extract_subset =
      _sk_pixmap_extract_subsetPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_colorspace_t sk_pixmap_get_colorspace(sk_pixmap_t cpixmap)
  ffi.Pointer<ffi.Void> sk_pixmap_get_colorspace(
    ffi.Pointer<ffi.Void> cpixmap,
  ) {
    return _sk_pixmap_get_colorspace(
      cpixmap,
    );
  }

  late final _sk_pixmap_get_colorspacePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_pixmap_get_colorspace');
  late final _sk_pixmap_get_colorspace =
      _sk_pixmap_get_colorspacePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_pixmap_get_info(sk_pixmap_t cpixmap, SKImageInfoNative* cinfo)
  void sk_pixmap_get_info(
    ffi.Pointer<ffi.Void> cpixmap,
    ffi.Pointer<ffi.Void> cinfo,
  ) {
    return _sk_pixmap_get_info(
      cpixmap,
      cinfo,
    );
  }

  late final _sk_pixmap_get_infoPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_pixmap_get_info');
  late final _sk_pixmap_get_info =
      _sk_pixmap_get_infoPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// Single sk_pixmap_get_pixel_alphaf(sk_pixmap_t cpixmap, Int32 x, Int32 y)
  double sk_pixmap_get_pixel_alphaf(
    ffi.Pointer<ffi.Void> cpixmap,
    int x,
    int y,
  ) {
    return _sk_pixmap_get_pixel_alphaf(
      cpixmap,
      x,
      y,
    );
  }

  late final _sk_pixmap_get_pixel_alphafPtr = _lookup<
      ffi.NativeFunction<ffi.Float Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32)>>('sk_pixmap_get_pixel_alphaf');
  late final _sk_pixmap_get_pixel_alphaf =
      _sk_pixmap_get_pixel_alphafPtr.asFunction<double Function(ffi.Pointer<ffi.Void>, int, int)>();

  /// UInt32 sk_pixmap_get_pixel_color(sk_pixmap_t cpixmap, Int32 x, Int32 y)
  int sk_pixmap_get_pixel_color(
    ffi.Pointer<ffi.Void> cpixmap,
    int x,
    int y,
  ) {
    return _sk_pixmap_get_pixel_color(
      cpixmap,
      x,
      y,
    );
  }

  late final _sk_pixmap_get_pixel_colorPtr = _lookup<
      ffi.NativeFunction<ffi.Uint32 Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32)>>('sk_pixmap_get_pixel_color');
  late final _sk_pixmap_get_pixel_color =
      _sk_pixmap_get_pixel_colorPtr.asFunction<int Function(ffi.Pointer<ffi.Void>, int, int)>();

  /// void sk_pixmap_get_pixel_color4f(sk_pixmap_t cpixmap, Int32 x, Int32 y, SKColorF* color)
  void sk_pixmap_get_pixel_color4f(
    ffi.Pointer<ffi.Void> cpixmap,
    int x,
    int y,
    ffi.Pointer<ffi.Void> color,
  ) {
    return _sk_pixmap_get_pixel_color4f(
      cpixmap,
      x,
      y,
      color,
    );
  }

  late final _sk_pixmap_get_pixel_color4fPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>)>>('sk_pixmap_get_pixel_color4f');
  late final _sk_pixmap_get_pixel_color4f =
      _sk_pixmap_get_pixel_color4fPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int, int, ffi.Pointer<ffi.Void>)>();

  /// IntPtr sk_pixmap_get_row_bytes(sk_pixmap_t cpixmap)
  ffi.Pointer<ffi.Void> sk_pixmap_get_row_bytes(
    ffi.Pointer<ffi.Void> cpixmap,
  ) {
    return _sk_pixmap_get_row_bytes(
      cpixmap,
    );
  }

  late final _sk_pixmap_get_row_bytesPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_pixmap_get_row_bytes');
  late final _sk_pixmap_get_row_bytes =
      _sk_pixmap_get_row_bytesPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void* sk_pixmap_get_writable_addr(sk_pixmap_t cpixmap)
  ffi.Pointer<ffi.Void> sk_pixmap_get_writable_addr(
    ffi.Pointer<ffi.Void> cpixmap,
  ) {
    return _sk_pixmap_get_writable_addr(
      cpixmap,
    );
  }

  late final _sk_pixmap_get_writable_addrPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_pixmap_get_writable_addr');
  late final _sk_pixmap_get_writable_addr =
      _sk_pixmap_get_writable_addrPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void* sk_pixmap_get_writeable_addr_with_xy(sk_pixmap_t cpixmap, Int32 x, Int32 y)
  ffi.Pointer<ffi.Void> sk_pixmap_get_writeable_addr_with_xy(
    ffi.Pointer<ffi.Void> cpixmap,
    int x,
    int y,
  ) {
    return _sk_pixmap_get_writeable_addr_with_xy(
      cpixmap,
      x,
      y,
    );
  }

  late final _sk_pixmap_get_writeable_addr_with_xyPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32)>>('sk_pixmap_get_writeable_addr_with_xy');
  late final _sk_pixmap_get_writeable_addr_with_xy =
      _sk_pixmap_get_writeable_addr_with_xyPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, int, int)>();

  /// sk_pixmap_t sk_pixmap_new()
  ffi.Pointer<ffi.Void> sk_pixmap_new() {
    return _sk_pixmap_new();
  }

  late final _sk_pixmap_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_pixmap_new');
  late final _sk_pixmap_new =
      _sk_pixmap_newPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// sk_pixmap_t sk_pixmap_new_with_params(SKImageInfoNative* cinfo, void* addr, IntPtr rowBytes)
  ffi.Pointer<ffi.Void> sk_pixmap_new_with_params(
    ffi.Pointer<ffi.Void> cinfo,
    ffi.Pointer<ffi.Void> addr,
    ffi.Pointer<ffi.Void> rowBytes,
  ) {
    return _sk_pixmap_new_with_params(
      cinfo,
      addr,
      rowBytes,
    );
  }

  late final _sk_pixmap_new_with_paramsPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_pixmap_new_with_params');
  late final _sk_pixmap_new_with_params =
      _sk_pixmap_new_with_paramsPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_pixmap_read_pixels(sk_pixmap_t cpixmap, SKImageInfoNative* dstInfo, void* dstPixels, IntPtr dstRowBytes, Int32 srcX, Int32 srcY)
  bool sk_pixmap_read_pixels(
    ffi.Pointer<ffi.Void> cpixmap,
    ffi.Pointer<ffi.Void> dstInfo,
    ffi.Pointer<ffi.Void> dstPixels,
    ffi.Pointer<ffi.Void> dstRowBytes,
    int srcX,
    int srcY,
  ) {
    return _sk_pixmap_read_pixels(
      cpixmap,
      dstInfo,
      dstPixels,
      dstRowBytes,
      srcX,
      srcY,
    );
  }

  late final _sk_pixmap_read_pixelsPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32)>>('sk_pixmap_read_pixels');
  late final _sk_pixmap_read_pixels =
      _sk_pixmap_read_pixelsPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, int)>();

  /// void sk_pixmap_reset(sk_pixmap_t cpixmap)
  void sk_pixmap_reset(
    ffi.Pointer<ffi.Void> cpixmap,
  ) {
    return _sk_pixmap_reset(
      cpixmap,
    );
  }

  late final _sk_pixmap_resetPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_pixmap_reset');
  late final _sk_pixmap_reset =
      _sk_pixmap_resetPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_pixmap_reset_with_params(sk_pixmap_t cpixmap, SKImageInfoNative* cinfo, void* addr, IntPtr rowBytes)
  void sk_pixmap_reset_with_params(
    ffi.Pointer<ffi.Void> cpixmap,
    ffi.Pointer<ffi.Void> cinfo,
    ffi.Pointer<ffi.Void> addr,
    ffi.Pointer<ffi.Void> rowBytes,
  ) {
    return _sk_pixmap_reset_with_params(
      cpixmap,
      cinfo,
      addr,
      rowBytes,
    );
  }

  late final _sk_pixmap_reset_with_paramsPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_pixmap_reset_with_params');
  late final _sk_pixmap_reset_with_params =
      _sk_pixmap_reset_with_paramsPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_pixmap_scale_pixels(sk_pixmap_t cpixmap, sk_pixmap_t dst, SKSamplingOptions* sampling)
  bool sk_pixmap_scale_pixels(
    ffi.Pointer<ffi.Void> cpixmap,
    ffi.Pointer<ffi.Void> dst,
    ffi.Pointer<ffi.Void> sampling,
  ) {
    return _sk_pixmap_scale_pixels(
      cpixmap,
      dst,
      sampling,
    );
  }

  late final _sk_pixmap_scale_pixelsPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_pixmap_scale_pixels');
  late final _sk_pixmap_scale_pixels =
      _sk_pixmap_scale_pixelsPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_pixmap_set_colorspace(sk_pixmap_t cpixmap, sk_colorspace_t colorspace)
  void sk_pixmap_set_colorspace(
    ffi.Pointer<ffi.Void> cpixmap,
    ffi.Pointer<ffi.Void> colorspace,
  ) {
    return _sk_pixmap_set_colorspace(
      cpixmap,
      colorspace,
    );
  }

  late final _sk_pixmap_set_colorspacePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_pixmap_set_colorspace');
  late final _sk_pixmap_set_colorspace =
      _sk_pixmap_set_colorspacePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_pngencoder_encode(sk_wstream_t dst, sk_pixmap_t src, SKPngEncoderOptions* options)
  bool sk_pngencoder_encode(
    ffi.Pointer<ffi.Void> dst,
    ffi.Pointer<ffi.Void> src,
    ffi.Pointer<ffi.Void> options,
  ) {
    return _sk_pngencoder_encode(
      dst,
      src,
      options,
    );
  }

  late final _sk_pngencoder_encodePtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_pngencoder_encode');
  late final _sk_pngencoder_encode =
      _sk_pngencoder_encodePtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_swizzle_swap_rb(UInt32* dest, UInt32* src, Int32 count)
  void sk_swizzle_swap_rb(
    ffi.Pointer<ffi.Uint32> dest,
    ffi.Pointer<ffi.Uint32> src,
    int count,
  ) {
    return _sk_swizzle_swap_rb(
      dest,
      src,
      count,
    );
  }

  late final _sk_swizzle_swap_rbPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Uint32>, ffi.Pointer<ffi.Uint32>, ffi.Int32)>>('sk_swizzle_swap_rb');
  late final _sk_swizzle_swap_rb =
      _sk_swizzle_swap_rbPtr.asFunction<void Function(ffi.Pointer<ffi.Uint32>, ffi.Pointer<ffi.Uint32>, int)>();

  /// bool sk_webpencoder_encode(sk_wstream_t dst, sk_pixmap_t src, SKWebpEncoderOptions* options)
  bool sk_webpencoder_encode(
    ffi.Pointer<ffi.Void> dst,
    ffi.Pointer<ffi.Void> src,
    ffi.Pointer<ffi.Void> options,
  ) {
    return _sk_webpencoder_encode(
      dst,
      src,
      options,
    );
  }

  late final _sk_webpencoder_encodePtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_webpencoder_encode');
  late final _sk_webpencoder_encode =
      _sk_webpencoder_encodePtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_region_cliperator_delete(sk_region_cliperator_t iter)
  void sk_region_cliperator_delete(
    ffi.Pointer<ffi.Void> iter,
  ) {
    return _sk_region_cliperator_delete(
      iter,
    );
  }

  late final _sk_region_cliperator_deletePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_region_cliperator_delete');
  late final _sk_region_cliperator_delete =
      _sk_region_cliperator_deletePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_region_cliperator_done(sk_region_cliperator_t iter)
  bool sk_region_cliperator_done(
    ffi.Pointer<ffi.Void> iter,
  ) {
    return _sk_region_cliperator_done(
      iter,
    );
  }

  late final _sk_region_cliperator_donePtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_region_cliperator_done');
  late final _sk_region_cliperator_done =
      _sk_region_cliperator_donePtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// sk_region_cliperator_t sk_region_cliperator_new(sk_region_t region, SKRectI* clip)
  ffi.Pointer<ffi.Void> sk_region_cliperator_new(
    ffi.Pointer<ffi.Void> region,
    ffi.Pointer<ffi.Void> clip,
  ) {
    return _sk_region_cliperator_new(
      region,
      clip,
    );
  }

  late final _sk_region_cliperator_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_region_cliperator_new');
  late final _sk_region_cliperator_new =
      _sk_region_cliperator_newPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_region_cliperator_next(sk_region_cliperator_t iter)
  void sk_region_cliperator_next(
    ffi.Pointer<ffi.Void> iter,
  ) {
    return _sk_region_cliperator_next(
      iter,
    );
  }

  late final _sk_region_cliperator_nextPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_region_cliperator_next');
  late final _sk_region_cliperator_next =
      _sk_region_cliperator_nextPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_region_cliperator_rect(sk_region_cliperator_t iter, SKRectI* rect)
  void sk_region_cliperator_rect(
    ffi.Pointer<ffi.Void> iter,
    ffi.Pointer<ffi.Void> rect,
  ) {
    return _sk_region_cliperator_rect(
      iter,
      rect,
    );
  }

  late final _sk_region_cliperator_rectPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_region_cliperator_rect');
  late final _sk_region_cliperator_rect =
      _sk_region_cliperator_rectPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_region_contains(sk_region_t r, sk_region_t region)
  bool sk_region_contains(
    ffi.Pointer<ffi.Void> r,
    ffi.Pointer<ffi.Void> region,
  ) {
    return _sk_region_contains(
      r,
      region,
    );
  }

  late final _sk_region_containsPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_region_contains');
  late final _sk_region_contains =
      _sk_region_containsPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_region_contains_point(sk_region_t r, Int32 x, Int32 y)
  bool sk_region_contains_point(
    ffi.Pointer<ffi.Void> r,
    int x,
    int y,
  ) {
    return _sk_region_contains_point(
      r,
      x,
      y,
    );
  }

  late final _sk_region_contains_pointPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32)>>('sk_region_contains_point');
  late final _sk_region_contains_point =
      _sk_region_contains_pointPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, int, int)>();

  /// bool sk_region_contains_rect(sk_region_t r, SKRectI* rect)
  bool sk_region_contains_rect(
    ffi.Pointer<ffi.Void> r,
    ffi.Pointer<ffi.Void> rect,
  ) {
    return _sk_region_contains_rect(
      r,
      rect,
    );
  }

  late final _sk_region_contains_rectPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_region_contains_rect');
  late final _sk_region_contains_rect =
      _sk_region_contains_rectPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_region_delete(sk_region_t r)
  void sk_region_delete(
    ffi.Pointer<ffi.Void> r,
  ) {
    return _sk_region_delete(
      r,
    );
  }

  late final _sk_region_deletePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_region_delete');
  late final _sk_region_delete =
      _sk_region_deletePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_region_get_boundary_path(sk_region_t r, sk_path_t path)
  bool sk_region_get_boundary_path(
    ffi.Pointer<ffi.Void> r,
    ffi.Pointer<ffi.Void> path,
  ) {
    return _sk_region_get_boundary_path(
      r,
      path,
    );
  }

  late final _sk_region_get_boundary_pathPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_region_get_boundary_path');
  late final _sk_region_get_boundary_path =
      _sk_region_get_boundary_pathPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_region_get_bounds(sk_region_t r, SKRectI* rect)
  void sk_region_get_bounds(
    ffi.Pointer<ffi.Void> r,
    ffi.Pointer<ffi.Void> rect,
  ) {
    return _sk_region_get_bounds(
      r,
      rect,
    );
  }

  late final _sk_region_get_boundsPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_region_get_bounds');
  late final _sk_region_get_bounds =
      _sk_region_get_boundsPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_region_intersects(sk_region_t r, sk_region_t src)
  bool sk_region_intersects(
    ffi.Pointer<ffi.Void> r,
    ffi.Pointer<ffi.Void> src,
  ) {
    return _sk_region_intersects(
      r,
      src,
    );
  }

  late final _sk_region_intersectsPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_region_intersects');
  late final _sk_region_intersects =
      _sk_region_intersectsPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_region_intersects_rect(sk_region_t r, SKRectI* rect)
  bool sk_region_intersects_rect(
    ffi.Pointer<ffi.Void> r,
    ffi.Pointer<ffi.Void> rect,
  ) {
    return _sk_region_intersects_rect(
      r,
      rect,
    );
  }

  late final _sk_region_intersects_rectPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_region_intersects_rect');
  late final _sk_region_intersects_rect =
      _sk_region_intersects_rectPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_region_is_complex(sk_region_t r)
  bool sk_region_is_complex(
    ffi.Pointer<ffi.Void> r,
  ) {
    return _sk_region_is_complex(
      r,
    );
  }

  late final _sk_region_is_complexPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_region_is_complex');
  late final _sk_region_is_complex =
      _sk_region_is_complexPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_region_is_empty(sk_region_t r)
  bool sk_region_is_empty(
    ffi.Pointer<ffi.Void> r,
  ) {
    return _sk_region_is_empty(
      r,
    );
  }

  late final _sk_region_is_emptyPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_region_is_empty');
  late final _sk_region_is_empty =
      _sk_region_is_emptyPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_region_is_rect(sk_region_t r)
  bool sk_region_is_rect(
    ffi.Pointer<ffi.Void> r,
  ) {
    return _sk_region_is_rect(
      r,
    );
  }

  late final _sk_region_is_rectPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_region_is_rect');
  late final _sk_region_is_rect =
      _sk_region_is_rectPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_region_iterator_delete(sk_region_iterator_t iter)
  void sk_region_iterator_delete(
    ffi.Pointer<ffi.Void> iter,
  ) {
    return _sk_region_iterator_delete(
      iter,
    );
  }

  late final _sk_region_iterator_deletePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_region_iterator_delete');
  late final _sk_region_iterator_delete =
      _sk_region_iterator_deletePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_region_iterator_done(sk_region_iterator_t iter)
  bool sk_region_iterator_done(
    ffi.Pointer<ffi.Void> iter,
  ) {
    return _sk_region_iterator_done(
      iter,
    );
  }

  late final _sk_region_iterator_donePtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_region_iterator_done');
  late final _sk_region_iterator_done =
      _sk_region_iterator_donePtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// sk_region_iterator_t sk_region_iterator_new(sk_region_t region)
  ffi.Pointer<ffi.Void> sk_region_iterator_new(
    ffi.Pointer<ffi.Void> region,
  ) {
    return _sk_region_iterator_new(
      region,
    );
  }

  late final _sk_region_iterator_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_region_iterator_new');
  late final _sk_region_iterator_new =
      _sk_region_iterator_newPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_region_iterator_next(sk_region_iterator_t iter)
  void sk_region_iterator_next(
    ffi.Pointer<ffi.Void> iter,
  ) {
    return _sk_region_iterator_next(
      iter,
    );
  }

  late final _sk_region_iterator_nextPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_region_iterator_next');
  late final _sk_region_iterator_next =
      _sk_region_iterator_nextPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_region_iterator_rect(sk_region_iterator_t iter, SKRectI* rect)
  void sk_region_iterator_rect(
    ffi.Pointer<ffi.Void> iter,
    ffi.Pointer<ffi.Void> rect,
  ) {
    return _sk_region_iterator_rect(
      iter,
      rect,
    );
  }

  late final _sk_region_iterator_rectPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_region_iterator_rect');
  late final _sk_region_iterator_rect =
      _sk_region_iterator_rectPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_region_iterator_rewind(sk_region_iterator_t iter)
  bool sk_region_iterator_rewind(
    ffi.Pointer<ffi.Void> iter,
  ) {
    return _sk_region_iterator_rewind(
      iter,
    );
  }

  late final _sk_region_iterator_rewindPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_region_iterator_rewind');
  late final _sk_region_iterator_rewind =
      _sk_region_iterator_rewindPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// sk_region_t sk_region_new()
  ffi.Pointer<ffi.Void> sk_region_new() {
    return _sk_region_new();
  }

  late final _sk_region_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_region_new');
  late final _sk_region_new =
      _sk_region_newPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// bool sk_region_op(sk_region_t r, sk_region_t region, SKRegionOperation op)
  bool sk_region_op(
    ffi.Pointer<ffi.Void> r,
    ffi.Pointer<ffi.Void> region,
    int op,
  ) {
    return _sk_region_op(
      r,
      region,
      op,
    );
  }

  late final _sk_region_opPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_region_op');
  late final _sk_region_op =
      _sk_region_opPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int)>();

  /// bool sk_region_op_rect(sk_region_t r, SKRectI* rect, SKRegionOperation op)
  bool sk_region_op_rect(
    ffi.Pointer<ffi.Void> r,
    ffi.Pointer<ffi.Void> rect,
    int op,
  ) {
    return _sk_region_op_rect(
      r,
      rect,
      op,
    );
  }

  late final _sk_region_op_rectPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_region_op_rect');
  late final _sk_region_op_rect =
      _sk_region_op_rectPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int)>();

  /// bool sk_region_quick_contains(sk_region_t r, SKRectI* rect)
  bool sk_region_quick_contains(
    ffi.Pointer<ffi.Void> r,
    ffi.Pointer<ffi.Void> rect,
  ) {
    return _sk_region_quick_contains(
      r,
      rect,
    );
  }

  late final _sk_region_quick_containsPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_region_quick_contains');
  late final _sk_region_quick_contains =
      _sk_region_quick_containsPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_region_quick_reject(sk_region_t r, sk_region_t region)
  bool sk_region_quick_reject(
    ffi.Pointer<ffi.Void> r,
    ffi.Pointer<ffi.Void> region,
  ) {
    return _sk_region_quick_reject(
      r,
      region,
    );
  }

  late final _sk_region_quick_rejectPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_region_quick_reject');
  late final _sk_region_quick_reject =
      _sk_region_quick_rejectPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_region_quick_reject_rect(sk_region_t r, SKRectI* rect)
  bool sk_region_quick_reject_rect(
    ffi.Pointer<ffi.Void> r,
    ffi.Pointer<ffi.Void> rect,
  ) {
    return _sk_region_quick_reject_rect(
      r,
      rect,
    );
  }

  late final _sk_region_quick_reject_rectPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_region_quick_reject_rect');
  late final _sk_region_quick_reject_rect =
      _sk_region_quick_reject_rectPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_region_set_empty(sk_region_t r)
  bool sk_region_set_empty(
    ffi.Pointer<ffi.Void> r,
  ) {
    return _sk_region_set_empty(
      r,
    );
  }

  late final _sk_region_set_emptyPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_region_set_empty');
  late final _sk_region_set_empty =
      _sk_region_set_emptyPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_region_set_path(sk_region_t r, sk_path_t t, sk_region_t clip)
  bool sk_region_set_path(
    ffi.Pointer<ffi.Void> r,
    ffi.Pointer<ffi.Void> t,
    ffi.Pointer<ffi.Void> clip,
  ) {
    return _sk_region_set_path(
      r,
      t,
      clip,
    );
  }

  late final _sk_region_set_pathPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_region_set_path');
  late final _sk_region_set_path =
      _sk_region_set_pathPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_region_set_rect(sk_region_t r, SKRectI* rect)
  bool sk_region_set_rect(
    ffi.Pointer<ffi.Void> r,
    ffi.Pointer<ffi.Void> rect,
  ) {
    return _sk_region_set_rect(
      r,
      rect,
    );
  }

  late final _sk_region_set_rectPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_region_set_rect');
  late final _sk_region_set_rect =
      _sk_region_set_rectPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_region_set_rects(sk_region_t r, SKRectI* rects, Int32 count)
  bool sk_region_set_rects(
    ffi.Pointer<ffi.Void> r,
    ffi.Pointer<ffi.Void> rects,
    int count,
  ) {
    return _sk_region_set_rects(
      r,
      rects,
      count,
    );
  }

  late final _sk_region_set_rectsPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_region_set_rects');
  late final _sk_region_set_rects =
      _sk_region_set_rectsPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int)>();

  /// bool sk_region_set_region(sk_region_t r, sk_region_t region)
  bool sk_region_set_region(
    ffi.Pointer<ffi.Void> r,
    ffi.Pointer<ffi.Void> region,
  ) {
    return _sk_region_set_region(
      r,
      region,
    );
  }

  late final _sk_region_set_regionPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_region_set_region');
  late final _sk_region_set_region =
      _sk_region_set_regionPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_region_spanerator_delete(sk_region_spanerator_t iter)
  void sk_region_spanerator_delete(
    ffi.Pointer<ffi.Void> iter,
  ) {
    return _sk_region_spanerator_delete(
      iter,
    );
  }

  late final _sk_region_spanerator_deletePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_region_spanerator_delete');
  late final _sk_region_spanerator_delete =
      _sk_region_spanerator_deletePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// sk_region_spanerator_t sk_region_spanerator_new(sk_region_t region, Int32 y, Int32 left, Int32 right)
  ffi.Pointer<ffi.Void> sk_region_spanerator_new(
    ffi.Pointer<ffi.Void> region,
    int y,
    int left,
    int right,
  ) {
    return _sk_region_spanerator_new(
      region,
      y,
      left,
      right,
    );
  }

  late final _sk_region_spanerator_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32, ffi.Int32)>>('sk_region_spanerator_new');
  late final _sk_region_spanerator_new =
      _sk_region_spanerator_newPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, int, int, int)>();

  /// bool sk_region_spanerator_next(sk_region_spanerator_t iter, Int32* left, Int32* right)
  bool sk_region_spanerator_next(
    ffi.Pointer<ffi.Void> iter,
    ffi.Pointer<ffi.Int32> left,
    ffi.Pointer<ffi.Int32> right,
  ) {
    return _sk_region_spanerator_next(
      iter,
      left,
      right,
    );
  }

  late final _sk_region_spanerator_nextPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Int32>, ffi.Pointer<ffi.Int32>)>>('sk_region_spanerator_next');
  late final _sk_region_spanerator_next =
      _sk_region_spanerator_nextPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Int32>, ffi.Pointer<ffi.Int32>)>();

  /// void sk_region_translate(sk_region_t r, Int32 x, Int32 y)
  void sk_region_translate(
    ffi.Pointer<ffi.Void> r,
    int x,
    int y,
  ) {
    return _sk_region_translate(
      r,
      x,
      y,
    );
  }

  late final _sk_region_translatePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32)>>('sk_region_translate');
  late final _sk_region_translate =
      _sk_region_translatePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int, int)>();

  /// bool sk_rrect_contains(sk_rrect_t rrect, SKRect* rect)
  bool sk_rrect_contains(
    ffi.Pointer<ffi.Void> rrect,
    ffi.Pointer<ffi.Void> rect,
  ) {
    return _sk_rrect_contains(
      rrect,
      rect,
    );
  }

  late final _sk_rrect_containsPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_rrect_contains');
  late final _sk_rrect_contains =
      _sk_rrect_containsPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_rrect_delete(sk_rrect_t rrect)
  void sk_rrect_delete(
    ffi.Pointer<ffi.Void> rrect,
  ) {
    return _sk_rrect_delete(
      rrect,
    );
  }

  late final _sk_rrect_deletePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_rrect_delete');
  late final _sk_rrect_delete =
      _sk_rrect_deletePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// Single sk_rrect_get_height(sk_rrect_t rrect)
  double sk_rrect_get_height(
    ffi.Pointer<ffi.Void> rrect,
  ) {
    return _sk_rrect_get_height(
      rrect,
    );
  }

  late final _sk_rrect_get_heightPtr = _lookup<
      ffi.NativeFunction<ffi.Float Function(ffi.Pointer<ffi.Void>)>>('sk_rrect_get_height');
  late final _sk_rrect_get_height =
      _sk_rrect_get_heightPtr.asFunction<double Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_rrect_get_radii(sk_rrect_t rrect, SKRoundRectCorner corner, SKPoint* radii)
  void sk_rrect_get_radii(
    ffi.Pointer<ffi.Void> rrect,
    ffi.Pointer<ffi.Void> corner,
    ffi.Pointer<ffi.Void> radii,
  ) {
    return _sk_rrect_get_radii(
      rrect,
      corner,
      radii,
    );
  }

  late final _sk_rrect_get_radiiPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_rrect_get_radii');
  late final _sk_rrect_get_radii =
      _sk_rrect_get_radiiPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_rrect_get_rect(sk_rrect_t rrect, SKRect* rect)
  void sk_rrect_get_rect(
    ffi.Pointer<ffi.Void> rrect,
    ffi.Pointer<ffi.Void> rect,
  ) {
    return _sk_rrect_get_rect(
      rrect,
      rect,
    );
  }

  late final _sk_rrect_get_rectPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_rrect_get_rect');
  late final _sk_rrect_get_rect =
      _sk_rrect_get_rectPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// SKRoundRectType sk_rrect_get_type(sk_rrect_t rrect)
  ffi.Pointer<ffi.Void> sk_rrect_get_type(
    ffi.Pointer<ffi.Void> rrect,
  ) {
    return _sk_rrect_get_type(
      rrect,
    );
  }

  late final _sk_rrect_get_typePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_rrect_get_type');
  late final _sk_rrect_get_type =
      _sk_rrect_get_typePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// Single sk_rrect_get_width(sk_rrect_t rrect)
  double sk_rrect_get_width(
    ffi.Pointer<ffi.Void> rrect,
  ) {
    return _sk_rrect_get_width(
      rrect,
    );
  }

  late final _sk_rrect_get_widthPtr = _lookup<
      ffi.NativeFunction<ffi.Float Function(ffi.Pointer<ffi.Void>)>>('sk_rrect_get_width');
  late final _sk_rrect_get_width =
      _sk_rrect_get_widthPtr.asFunction<double Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_rrect_inset(sk_rrect_t rrect, Single dx, Single dy)
  void sk_rrect_inset(
    ffi.Pointer<ffi.Void> rrect,
    double dx,
    double dy,
  ) {
    return _sk_rrect_inset(
      rrect,
      dx,
      dy,
    );
  }

  late final _sk_rrect_insetPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float)>>('sk_rrect_inset');
  late final _sk_rrect_inset =
      _sk_rrect_insetPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, double)>();

  /// bool sk_rrect_is_valid(sk_rrect_t rrect)
  bool sk_rrect_is_valid(
    ffi.Pointer<ffi.Void> rrect,
  ) {
    return _sk_rrect_is_valid(
      rrect,
    );
  }

  late final _sk_rrect_is_validPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_rrect_is_valid');
  late final _sk_rrect_is_valid =
      _sk_rrect_is_validPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// sk_rrect_t sk_rrect_new()
  ffi.Pointer<ffi.Void> sk_rrect_new() {
    return _sk_rrect_new();
  }

  late final _sk_rrect_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_rrect_new');
  late final _sk_rrect_new =
      _sk_rrect_newPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// sk_rrect_t sk_rrect_new_copy(sk_rrect_t rrect)
  ffi.Pointer<ffi.Void> sk_rrect_new_copy(
    ffi.Pointer<ffi.Void> rrect,
  ) {
    return _sk_rrect_new_copy(
      rrect,
    );
  }

  late final _sk_rrect_new_copyPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_rrect_new_copy');
  late final _sk_rrect_new_copy =
      _sk_rrect_new_copyPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_rrect_offset(sk_rrect_t rrect, Single dx, Single dy)
  void sk_rrect_offset(
    ffi.Pointer<ffi.Void> rrect,
    double dx,
    double dy,
  ) {
    return _sk_rrect_offset(
      rrect,
      dx,
      dy,
    );
  }

  late final _sk_rrect_offsetPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float)>>('sk_rrect_offset');
  late final _sk_rrect_offset =
      _sk_rrect_offsetPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, double)>();

  /// void sk_rrect_outset(sk_rrect_t rrect, Single dx, Single dy)
  void sk_rrect_outset(
    ffi.Pointer<ffi.Void> rrect,
    double dx,
    double dy,
  ) {
    return _sk_rrect_outset(
      rrect,
      dx,
      dy,
    );
  }

  late final _sk_rrect_outsetPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float)>>('sk_rrect_outset');
  late final _sk_rrect_outset =
      _sk_rrect_outsetPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, double, double)>();

  /// void sk_rrect_set_empty(sk_rrect_t rrect)
  void sk_rrect_set_empty(
    ffi.Pointer<ffi.Void> rrect,
  ) {
    return _sk_rrect_set_empty(
      rrect,
    );
  }

  late final _sk_rrect_set_emptyPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_rrect_set_empty');
  late final _sk_rrect_set_empty =
      _sk_rrect_set_emptyPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_rrect_set_nine_patch(sk_rrect_t rrect, SKRect* rect, Single leftRad, Single topRad, Single rightRad, Single bottomRad)
  void sk_rrect_set_nine_patch(
    ffi.Pointer<ffi.Void> rrect,
    ffi.Pointer<ffi.Void> rect,
    double leftRad,
    double topRad,
    double rightRad,
    double bottomRad,
  ) {
    return _sk_rrect_set_nine_patch(
      rrect,
      rect,
      leftRad,
      topRad,
      rightRad,
      bottomRad,
    );
  }

  late final _sk_rrect_set_nine_patchPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Float, ffi.Float)>>('sk_rrect_set_nine_patch');
  late final _sk_rrect_set_nine_patch =
      _sk_rrect_set_nine_patchPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, double, double, double, double)>();

  /// void sk_rrect_set_oval(sk_rrect_t rrect, SKRect* rect)
  void sk_rrect_set_oval(
    ffi.Pointer<ffi.Void> rrect,
    ffi.Pointer<ffi.Void> rect,
  ) {
    return _sk_rrect_set_oval(
      rrect,
      rect,
    );
  }

  late final _sk_rrect_set_ovalPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_rrect_set_oval');
  late final _sk_rrect_set_oval =
      _sk_rrect_set_ovalPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_rrect_set_rect(sk_rrect_t rrect, SKRect* rect)
  void sk_rrect_set_rect(
    ffi.Pointer<ffi.Void> rrect,
    ffi.Pointer<ffi.Void> rect,
  ) {
    return _sk_rrect_set_rect(
      rrect,
      rect,
    );
  }

  late final _sk_rrect_set_rectPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_rrect_set_rect');
  late final _sk_rrect_set_rect =
      _sk_rrect_set_rectPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_rrect_set_rect_radii(sk_rrect_t rrect, SKRect* rect, SKPoint* radii)
  void sk_rrect_set_rect_radii(
    ffi.Pointer<ffi.Void> rrect,
    ffi.Pointer<ffi.Void> rect,
    ffi.Pointer<ffi.Void> radii,
  ) {
    return _sk_rrect_set_rect_radii(
      rrect,
      rect,
      radii,
    );
  }

  late final _sk_rrect_set_rect_radiiPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_rrect_set_rect_radii');
  late final _sk_rrect_set_rect_radii =
      _sk_rrect_set_rect_radiiPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_rrect_set_rect_xy(sk_rrect_t rrect, SKRect* rect, Single xRad, Single yRad)
  void sk_rrect_set_rect_xy(
    ffi.Pointer<ffi.Void> rrect,
    ffi.Pointer<ffi.Void> rect,
    double xRad,
    double yRad,
  ) {
    return _sk_rrect_set_rect_xy(
      rrect,
      rect,
      xRad,
      yRad,
    );
  }

  late final _sk_rrect_set_rect_xyPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float)>>('sk_rrect_set_rect_xy');
  late final _sk_rrect_set_rect_xy =
      _sk_rrect_set_rect_xyPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, double, double)>();

  /// bool sk_rrect_transform(sk_rrect_t rrect, SKMatrix* matrix, sk_rrect_t dest)
  bool sk_rrect_transform(
    ffi.Pointer<ffi.Void> rrect,
    ffi.Pointer<ffi.Void> matrix,
    ffi.Pointer<ffi.Void> dest,
  ) {
    return _sk_rrect_transform(
      rrect,
      matrix,
      dest,
    );
  }

  late final _sk_rrect_transformPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_rrect_transform');
  late final _sk_rrect_transform =
      _sk_rrect_transformPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_runtimeeffect_get_child_from_index(sk_runtimeeffect_t effect, Int32 index, SKRuntimeEffectChildNative* cchild)
  void sk_runtimeeffect_get_child_from_index(
    ffi.Pointer<ffi.Void> effect,
    int index,
    ffi.Pointer<ffi.Void> cchild,
  ) {
    return _sk_runtimeeffect_get_child_from_index(
      effect,
      index,
      cchild,
    );
  }

  late final _sk_runtimeeffect_get_child_from_indexPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Pointer<ffi.Void>)>>('sk_runtimeeffect_get_child_from_index');
  late final _sk_runtimeeffect_get_child_from_index =
      _sk_runtimeeffect_get_child_from_indexPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>)>();

  /// void sk_runtimeeffect_get_child_from_name(sk_runtimeeffect_t effect, void* name, IntPtr len, SKRuntimeEffectChildNative* cchild)
  void sk_runtimeeffect_get_child_from_name(
    ffi.Pointer<ffi.Void> effect,
    ffi.Pointer<ffi.Void> name,
    ffi.Pointer<ffi.Void> len,
    ffi.Pointer<ffi.Void> cchild,
  ) {
    return _sk_runtimeeffect_get_child_from_name(
      effect,
      name,
      len,
      cchild,
    );
  }

  late final _sk_runtimeeffect_get_child_from_namePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_runtimeeffect_get_child_from_name');
  late final _sk_runtimeeffect_get_child_from_name =
      _sk_runtimeeffect_get_child_from_namePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_runtimeeffect_get_child_name(sk_runtimeeffect_t effect, Int32 index, sk_string_t name)
  void sk_runtimeeffect_get_child_name(
    ffi.Pointer<ffi.Void> effect,
    int index,
    ffi.Pointer<ffi.Void> name,
  ) {
    return _sk_runtimeeffect_get_child_name(
      effect,
      index,
      name,
    );
  }

  late final _sk_runtimeeffect_get_child_namePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Pointer<ffi.Void>)>>('sk_runtimeeffect_get_child_name');
  late final _sk_runtimeeffect_get_child_name =
      _sk_runtimeeffect_get_child_namePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>)>();

  /// IntPtr sk_runtimeeffect_get_children_size(sk_runtimeeffect_t effect)
  ffi.Pointer<ffi.Void> sk_runtimeeffect_get_children_size(
    ffi.Pointer<ffi.Void> effect,
  ) {
    return _sk_runtimeeffect_get_children_size(
      effect,
    );
  }

  late final _sk_runtimeeffect_get_children_sizePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_runtimeeffect_get_children_size');
  late final _sk_runtimeeffect_get_children_size =
      _sk_runtimeeffect_get_children_sizePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// IntPtr sk_runtimeeffect_get_uniform_byte_size(sk_runtimeeffect_t effect)
  ffi.Pointer<ffi.Void> sk_runtimeeffect_get_uniform_byte_size(
    ffi.Pointer<ffi.Void> effect,
  ) {
    return _sk_runtimeeffect_get_uniform_byte_size(
      effect,
    );
  }

  late final _sk_runtimeeffect_get_uniform_byte_sizePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_runtimeeffect_get_uniform_byte_size');
  late final _sk_runtimeeffect_get_uniform_byte_size =
      _sk_runtimeeffect_get_uniform_byte_sizePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_runtimeeffect_get_uniform_from_index(sk_runtimeeffect_t effect, Int32 index, SKRuntimeEffectUniformNative* cuniform)
  void sk_runtimeeffect_get_uniform_from_index(
    ffi.Pointer<ffi.Void> effect,
    int index,
    ffi.Pointer<ffi.Void> cuniform,
  ) {
    return _sk_runtimeeffect_get_uniform_from_index(
      effect,
      index,
      cuniform,
    );
  }

  late final _sk_runtimeeffect_get_uniform_from_indexPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Pointer<ffi.Void>)>>('sk_runtimeeffect_get_uniform_from_index');
  late final _sk_runtimeeffect_get_uniform_from_index =
      _sk_runtimeeffect_get_uniform_from_indexPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>)>();

  /// void sk_runtimeeffect_get_uniform_from_name(sk_runtimeeffect_t effect, void* name, IntPtr len, SKRuntimeEffectUniformNative* cuniform)
  void sk_runtimeeffect_get_uniform_from_name(
    ffi.Pointer<ffi.Void> effect,
    ffi.Pointer<ffi.Void> name,
    ffi.Pointer<ffi.Void> len,
    ffi.Pointer<ffi.Void> cuniform,
  ) {
    return _sk_runtimeeffect_get_uniform_from_name(
      effect,
      name,
      len,
      cuniform,
    );
  }

  late final _sk_runtimeeffect_get_uniform_from_namePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_runtimeeffect_get_uniform_from_name');
  late final _sk_runtimeeffect_get_uniform_from_name =
      _sk_runtimeeffect_get_uniform_from_namePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_runtimeeffect_get_uniform_name(sk_runtimeeffect_t effect, Int32 index, sk_string_t name)
  void sk_runtimeeffect_get_uniform_name(
    ffi.Pointer<ffi.Void> effect,
    int index,
    ffi.Pointer<ffi.Void> name,
  ) {
    return _sk_runtimeeffect_get_uniform_name(
      effect,
      index,
      name,
    );
  }

  late final _sk_runtimeeffect_get_uniform_namePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Pointer<ffi.Void>)>>('sk_runtimeeffect_get_uniform_name');
  late final _sk_runtimeeffect_get_uniform_name =
      _sk_runtimeeffect_get_uniform_namePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>)>();

  /// IntPtr sk_runtimeeffect_get_uniforms_size(sk_runtimeeffect_t effect)
  ffi.Pointer<ffi.Void> sk_runtimeeffect_get_uniforms_size(
    ffi.Pointer<ffi.Void> effect,
  ) {
    return _sk_runtimeeffect_get_uniforms_size(
      effect,
    );
  }

  late final _sk_runtimeeffect_get_uniforms_sizePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_runtimeeffect_get_uniforms_size');
  late final _sk_runtimeeffect_get_uniforms_size =
      _sk_runtimeeffect_get_uniforms_sizePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_blender_t sk_runtimeeffect_make_blender(sk_runtimeeffect_t effect, sk_data_t uniforms, sk_flattenable_t* children, IntPtr childCount)
  ffi.Pointer<ffi.Void> sk_runtimeeffect_make_blender(
    ffi.Pointer<ffi.Void> effect,
    ffi.Pointer<ffi.Void> uniforms,
    ffi.Pointer<ffi.Void> children,
    ffi.Pointer<ffi.Void> childCount,
  ) {
    return _sk_runtimeeffect_make_blender(
      effect,
      uniforms,
      children,
      childCount,
    );
  }

  late final _sk_runtimeeffect_make_blenderPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_runtimeeffect_make_blender');
  late final _sk_runtimeeffect_make_blender =
      _sk_runtimeeffect_make_blenderPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_colorfilter_t sk_runtimeeffect_make_color_filter(sk_runtimeeffect_t effect, sk_data_t uniforms, sk_flattenable_t* children, IntPtr childCount)
  ffi.Pointer<ffi.Void> sk_runtimeeffect_make_color_filter(
    ffi.Pointer<ffi.Void> effect,
    ffi.Pointer<ffi.Void> uniforms,
    ffi.Pointer<ffi.Void> children,
    ffi.Pointer<ffi.Void> childCount,
  ) {
    return _sk_runtimeeffect_make_color_filter(
      effect,
      uniforms,
      children,
      childCount,
    );
  }

  late final _sk_runtimeeffect_make_color_filterPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_runtimeeffect_make_color_filter');
  late final _sk_runtimeeffect_make_color_filter =
      _sk_runtimeeffect_make_color_filterPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_runtimeeffect_t sk_runtimeeffect_make_for_blender(sk_string_t sksl, sk_string_t error)
  ffi.Pointer<ffi.Void> sk_runtimeeffect_make_for_blender(
    ffi.Pointer<ffi.Void> sksl,
    ffi.Pointer<ffi.Void> error,
  ) {
    return _sk_runtimeeffect_make_for_blender(
      sksl,
      error,
    );
  }

  late final _sk_runtimeeffect_make_for_blenderPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_runtimeeffect_make_for_blender');
  late final _sk_runtimeeffect_make_for_blender =
      _sk_runtimeeffect_make_for_blenderPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_runtimeeffect_t sk_runtimeeffect_make_for_color_filter(sk_string_t sksl, sk_string_t error)
  ffi.Pointer<ffi.Void> sk_runtimeeffect_make_for_color_filter(
    ffi.Pointer<ffi.Void> sksl,
    ffi.Pointer<ffi.Void> error,
  ) {
    return _sk_runtimeeffect_make_for_color_filter(
      sksl,
      error,
    );
  }

  late final _sk_runtimeeffect_make_for_color_filterPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_runtimeeffect_make_for_color_filter');
  late final _sk_runtimeeffect_make_for_color_filter =
      _sk_runtimeeffect_make_for_color_filterPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_runtimeeffect_t sk_runtimeeffect_make_for_shader(sk_string_t sksl, sk_string_t error)
  ffi.Pointer<ffi.Void> sk_runtimeeffect_make_for_shader(
    ffi.Pointer<ffi.Void> sksl,
    ffi.Pointer<ffi.Void> error,
  ) {
    return _sk_runtimeeffect_make_for_shader(
      sksl,
      error,
    );
  }

  late final _sk_runtimeeffect_make_for_shaderPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_runtimeeffect_make_for_shader');
  late final _sk_runtimeeffect_make_for_shader =
      _sk_runtimeeffect_make_for_shaderPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_shader_t sk_runtimeeffect_make_shader(sk_runtimeeffect_t effect, sk_data_t uniforms, sk_flattenable_t* children, IntPtr childCount, SKMatrix* localMatrix)
  ffi.Pointer<ffi.Void> sk_runtimeeffect_make_shader(
    ffi.Pointer<ffi.Void> effect,
    ffi.Pointer<ffi.Void> uniforms,
    ffi.Pointer<ffi.Void> children,
    ffi.Pointer<ffi.Void> childCount,
    ffi.Pointer<ffi.Void> localMatrix,
  ) {
    return _sk_runtimeeffect_make_shader(
      effect,
      uniforms,
      children,
      childCount,
      localMatrix,
    );
  }

  late final _sk_runtimeeffect_make_shaderPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_runtimeeffect_make_shader');
  late final _sk_runtimeeffect_make_shader =
      _sk_runtimeeffect_make_shaderPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_runtimeeffect_unref(sk_runtimeeffect_t effect)
  void sk_runtimeeffect_unref(
    ffi.Pointer<ffi.Void> effect,
  ) {
    return _sk_runtimeeffect_unref(
      effect,
    );
  }

  late final _sk_runtimeeffect_unrefPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_runtimeeffect_unref');
  late final _sk_runtimeeffect_unref =
      _sk_runtimeeffect_unrefPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// sk_shader_t sk_shader_new_blend(SKBlendMode mode, sk_shader_t dst, sk_shader_t src)
  ffi.Pointer<ffi.Void> sk_shader_new_blend(
    int mode,
    ffi.Pointer<ffi.Void> dst,
    ffi.Pointer<ffi.Void> src,
  ) {
    return _sk_shader_new_blend(
      mode,
      dst,
      src,
    );
  }

  late final _sk_shader_new_blendPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_shader_new_blend');
  late final _sk_shader_new_blend =
      _sk_shader_new_blendPtr.asFunction<ffi.Pointer<ffi.Void> Function(int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_shader_t sk_shader_new_blender(sk_blender_t blender, sk_shader_t dst, sk_shader_t src)
  ffi.Pointer<ffi.Void> sk_shader_new_blender(
    ffi.Pointer<ffi.Void> blender,
    ffi.Pointer<ffi.Void> dst,
    ffi.Pointer<ffi.Void> src,
  ) {
    return _sk_shader_new_blender(
      blender,
      dst,
      src,
    );
  }

  late final _sk_shader_new_blenderPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_shader_new_blender');
  late final _sk_shader_new_blender =
      _sk_shader_new_blenderPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_shader_t sk_shader_new_color(UInt32 color)
  ffi.Pointer<ffi.Void> sk_shader_new_color(
    int color,
  ) {
    return _sk_shader_new_color(
      color,
    );
  }

  late final _sk_shader_new_colorPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Uint32)>>('sk_shader_new_color');
  late final _sk_shader_new_color =
      _sk_shader_new_colorPtr.asFunction<ffi.Pointer<ffi.Void> Function(int)>();

  /// sk_shader_t sk_shader_new_color4f(SKColorF* color, sk_colorspace_t colorspace)
  ffi.Pointer<ffi.Void> sk_shader_new_color4f(
    ffi.Pointer<ffi.Void> color,
    ffi.Pointer<ffi.Void> colorspace,
  ) {
    return _sk_shader_new_color4f(
      color,
      colorspace,
    );
  }

  late final _sk_shader_new_color4fPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_shader_new_color4f');
  late final _sk_shader_new_color4f =
      _sk_shader_new_color4fPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_shader_t sk_shader_new_empty()
  ffi.Pointer<ffi.Void> sk_shader_new_empty() {
    return _sk_shader_new_empty();
  }

  late final _sk_shader_new_emptyPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_shader_new_empty');
  late final _sk_shader_new_empty =
      _sk_shader_new_emptyPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// sk_shader_t sk_shader_new_linear_gradient(SKPoint* points, UInt32* colors, Single* colorPos, Int32 colorCount, SKShaderTileMode tileMode, SKMatrix* localMatrix)
  ffi.Pointer<ffi.Void> sk_shader_new_linear_gradient(
    ffi.Pointer<ffi.Void> points,
    ffi.Pointer<ffi.Uint32> colors,
    ffi.Pointer<ffi.Float> colorPos,
    int colorCount,
    int tileMode,
    ffi.Pointer<ffi.Void> localMatrix,
  ) {
    return _sk_shader_new_linear_gradient(
      points,
      colors,
      colorPos,
      colorCount,
      tileMode,
      localMatrix,
    );
  }

  late final _sk_shader_new_linear_gradientPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint32>, ffi.Pointer<ffi.Float>, ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>)>>('sk_shader_new_linear_gradient');
  late final _sk_shader_new_linear_gradient =
      _sk_shader_new_linear_gradientPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint32>, ffi.Pointer<ffi.Float>, int, int, ffi.Pointer<ffi.Void>)>();

  /// sk_shader_t sk_shader_new_linear_gradient_color4f(SKPoint* points, SKColorF* colors, sk_colorspace_t colorspace, Single* colorPos, Int32 colorCount, SKShaderTileMode tileMode, SKMatrix* localMatrix)
  ffi.Pointer<ffi.Void> sk_shader_new_linear_gradient_color4f(
    ffi.Pointer<ffi.Void> points,
    ffi.Pointer<ffi.Void> colors,
    ffi.Pointer<ffi.Void> colorspace,
    ffi.Pointer<ffi.Float> colorPos,
    int colorCount,
    int tileMode,
    ffi.Pointer<ffi.Void> localMatrix,
  ) {
    return _sk_shader_new_linear_gradient_color4f(
      points,
      colors,
      colorspace,
      colorPos,
      colorCount,
      tileMode,
      localMatrix,
    );
  }

  late final _sk_shader_new_linear_gradient_color4fPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Float>, ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>)>>('sk_shader_new_linear_gradient_color4f');
  late final _sk_shader_new_linear_gradient_color4f =
      _sk_shader_new_linear_gradient_color4fPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Float>, int, int, ffi.Pointer<ffi.Void>)>();

  /// sk_shader_t sk_shader_new_perlin_noise_fractal_noise(Single baseFrequencyX, Single baseFrequencyY, Int32 numOctaves, Single seed, SKSizeI* tileSize)
  ffi.Pointer<ffi.Void> sk_shader_new_perlin_noise_fractal_noise(
    double baseFrequencyX,
    double baseFrequencyY,
    int numOctaves,
    double seed,
    ffi.Pointer<ffi.Void> tileSize,
  ) {
    return _sk_shader_new_perlin_noise_fractal_noise(
      baseFrequencyX,
      baseFrequencyY,
      numOctaves,
      seed,
      tileSize,
    );
  }

  late final _sk_shader_new_perlin_noise_fractal_noisePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Float, ffi.Float, ffi.Int32, ffi.Float, ffi.Pointer<ffi.Void>)>>('sk_shader_new_perlin_noise_fractal_noise');
  late final _sk_shader_new_perlin_noise_fractal_noise =
      _sk_shader_new_perlin_noise_fractal_noisePtr.asFunction<ffi.Pointer<ffi.Void> Function(double, double, int, double, ffi.Pointer<ffi.Void>)>();

  /// sk_shader_t sk_shader_new_perlin_noise_turbulence(Single baseFrequencyX, Single baseFrequencyY, Int32 numOctaves, Single seed, SKSizeI* tileSize)
  ffi.Pointer<ffi.Void> sk_shader_new_perlin_noise_turbulence(
    double baseFrequencyX,
    double baseFrequencyY,
    int numOctaves,
    double seed,
    ffi.Pointer<ffi.Void> tileSize,
  ) {
    return _sk_shader_new_perlin_noise_turbulence(
      baseFrequencyX,
      baseFrequencyY,
      numOctaves,
      seed,
      tileSize,
    );
  }

  late final _sk_shader_new_perlin_noise_turbulencePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Float, ffi.Float, ffi.Int32, ffi.Float, ffi.Pointer<ffi.Void>)>>('sk_shader_new_perlin_noise_turbulence');
  late final _sk_shader_new_perlin_noise_turbulence =
      _sk_shader_new_perlin_noise_turbulencePtr.asFunction<ffi.Pointer<ffi.Void> Function(double, double, int, double, ffi.Pointer<ffi.Void>)>();

  /// sk_shader_t sk_shader_new_radial_gradient(SKPoint* center, Single radius, UInt32* colors, Single* colorPos, Int32 colorCount, SKShaderTileMode tileMode, SKMatrix* localMatrix)
  ffi.Pointer<ffi.Void> sk_shader_new_radial_gradient(
    ffi.Pointer<ffi.Void> center,
    double radius,
    ffi.Pointer<ffi.Uint32> colors,
    ffi.Pointer<ffi.Float> colorPos,
    int colorCount,
    int tileMode,
    ffi.Pointer<ffi.Void> localMatrix,
  ) {
    return _sk_shader_new_radial_gradient(
      center,
      radius,
      colors,
      colorPos,
      colorCount,
      tileMode,
      localMatrix,
    );
  }

  late final _sk_shader_new_radial_gradientPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Pointer<ffi.Uint32>, ffi.Pointer<ffi.Float>, ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>)>>('sk_shader_new_radial_gradient');
  late final _sk_shader_new_radial_gradient =
      _sk_shader_new_radial_gradientPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, double, ffi.Pointer<ffi.Uint32>, ffi.Pointer<ffi.Float>, int, int, ffi.Pointer<ffi.Void>)>();

  /// sk_shader_t sk_shader_new_radial_gradient_color4f(SKPoint* center, Single radius, SKColorF* colors, sk_colorspace_t colorspace, Single* colorPos, Int32 colorCount, SKShaderTileMode tileMode, SKMatrix* localMatrix)
  ffi.Pointer<ffi.Void> sk_shader_new_radial_gradient_color4f(
    ffi.Pointer<ffi.Void> center,
    double radius,
    ffi.Pointer<ffi.Void> colors,
    ffi.Pointer<ffi.Void> colorspace,
    ffi.Pointer<ffi.Float> colorPos,
    int colorCount,
    int tileMode,
    ffi.Pointer<ffi.Void> localMatrix,
  ) {
    return _sk_shader_new_radial_gradient_color4f(
      center,
      radius,
      colors,
      colorspace,
      colorPos,
      colorCount,
      tileMode,
      localMatrix,
    );
  }

  late final _sk_shader_new_radial_gradient_color4fPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Float>, ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>)>>('sk_shader_new_radial_gradient_color4f');
  late final _sk_shader_new_radial_gradient_color4f =
      _sk_shader_new_radial_gradient_color4fPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, double, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Float>, int, int, ffi.Pointer<ffi.Void>)>();

  /// sk_shader_t sk_shader_new_sweep_gradient(SKPoint* center, UInt32* colors, Single* colorPos, Int32 colorCount, SKShaderTileMode tileMode, Single startAngle, Single endAngle, SKMatrix* localMatrix)
  ffi.Pointer<ffi.Void> sk_shader_new_sweep_gradient(
    ffi.Pointer<ffi.Void> center,
    ffi.Pointer<ffi.Uint32> colors,
    ffi.Pointer<ffi.Float> colorPos,
    int colorCount,
    int tileMode,
    double startAngle,
    double endAngle,
    ffi.Pointer<ffi.Void> localMatrix,
  ) {
    return _sk_shader_new_sweep_gradient(
      center,
      colors,
      colorPos,
      colorCount,
      tileMode,
      startAngle,
      endAngle,
      localMatrix,
    );
  }

  late final _sk_shader_new_sweep_gradientPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint32>, ffi.Pointer<ffi.Float>, ffi.Int32, ffi.Int32, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>)>>('sk_shader_new_sweep_gradient');
  late final _sk_shader_new_sweep_gradient =
      _sk_shader_new_sweep_gradientPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint32>, ffi.Pointer<ffi.Float>, int, int, double, double, ffi.Pointer<ffi.Void>)>();

  /// sk_shader_t sk_shader_new_sweep_gradient_color4f(SKPoint* center, SKColorF* colors, sk_colorspace_t colorspace, Single* colorPos, Int32 colorCount, SKShaderTileMode tileMode, Single startAngle, Single endAngle, SKMatrix* localMatrix)
  ffi.Pointer<ffi.Void> sk_shader_new_sweep_gradient_color4f(
    ffi.Pointer<ffi.Void> center,
    ffi.Pointer<ffi.Void> colors,
    ffi.Pointer<ffi.Void> colorspace,
    ffi.Pointer<ffi.Float> colorPos,
    int colorCount,
    int tileMode,
    double startAngle,
    double endAngle,
    ffi.Pointer<ffi.Void> localMatrix,
  ) {
    return _sk_shader_new_sweep_gradient_color4f(
      center,
      colors,
      colorspace,
      colorPos,
      colorCount,
      tileMode,
      startAngle,
      endAngle,
      localMatrix,
    );
  }

  late final _sk_shader_new_sweep_gradient_color4fPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Float>, ffi.Int32, ffi.Int32, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>)>>('sk_shader_new_sweep_gradient_color4f');
  late final _sk_shader_new_sweep_gradient_color4f =
      _sk_shader_new_sweep_gradient_color4fPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Float>, int, int, double, double, ffi.Pointer<ffi.Void>)>();

  /// sk_shader_t sk_shader_new_two_point_conical_gradient(SKPoint* start, Single startRadius, SKPoint* end, Single endRadius, UInt32* colors, Single* colorPos, Int32 colorCount, SKShaderTileMode tileMode, SKMatrix* localMatrix)
  ffi.Pointer<ffi.Void> sk_shader_new_two_point_conical_gradient(
    ffi.Pointer<ffi.Void> start,
    double startRadius,
    ffi.Pointer<ffi.Void> end,
    double endRadius,
    ffi.Pointer<ffi.Uint32> colors,
    ffi.Pointer<ffi.Float> colorPos,
    int colorCount,
    int tileMode,
    ffi.Pointer<ffi.Void> localMatrix,
  ) {
    return _sk_shader_new_two_point_conical_gradient(
      start,
      startRadius,
      end,
      endRadius,
      colors,
      colorPos,
      colorCount,
      tileMode,
      localMatrix,
    );
  }

  late final _sk_shader_new_two_point_conical_gradientPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Pointer<ffi.Void>, ffi.Float, ffi.Pointer<ffi.Uint32>, ffi.Pointer<ffi.Float>, ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>)>>('sk_shader_new_two_point_conical_gradient');
  late final _sk_shader_new_two_point_conical_gradient =
      _sk_shader_new_two_point_conical_gradientPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, double, ffi.Pointer<ffi.Void>, double, ffi.Pointer<ffi.Uint32>, ffi.Pointer<ffi.Float>, int, int, ffi.Pointer<ffi.Void>)>();

  /// sk_shader_t sk_shader_new_two_point_conical_gradient_color4f(SKPoint* start, Single startRadius, SKPoint* end, Single endRadius, SKColorF* colors, sk_colorspace_t colorspace, Single* colorPos, Int32 colorCount, SKShaderTileMode tileMode, SKMatrix* localMatrix)
  ffi.Pointer<ffi.Void> sk_shader_new_two_point_conical_gradient_color4f(
    ffi.Pointer<ffi.Void> start,
    double startRadius,
    ffi.Pointer<ffi.Void> end,
    double endRadius,
    ffi.Pointer<ffi.Void> colors,
    ffi.Pointer<ffi.Void> colorspace,
    ffi.Pointer<ffi.Float> colorPos,
    int colorCount,
    int tileMode,
    ffi.Pointer<ffi.Void> localMatrix,
  ) {
    return _sk_shader_new_two_point_conical_gradient_color4f(
      start,
      startRadius,
      end,
      endRadius,
      colors,
      colorspace,
      colorPos,
      colorCount,
      tileMode,
      localMatrix,
    );
  }

  late final _sk_shader_new_two_point_conical_gradient_color4fPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Float, ffi.Pointer<ffi.Void>, ffi.Float, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Float>, ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>)>>('sk_shader_new_two_point_conical_gradient_color4f');
  late final _sk_shader_new_two_point_conical_gradient_color4f =
      _sk_shader_new_two_point_conical_gradient_color4fPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, double, ffi.Pointer<ffi.Void>, double, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Float>, int, int, ffi.Pointer<ffi.Void>)>();

  /// void sk_shader_ref(sk_shader_t shader)
  void sk_shader_ref(
    ffi.Pointer<ffi.Void> shader,
  ) {
    return _sk_shader_ref(
      shader,
    );
  }

  late final _sk_shader_refPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_shader_ref');
  late final _sk_shader_ref =
      _sk_shader_refPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_shader_unref(sk_shader_t shader)
  void sk_shader_unref(
    ffi.Pointer<ffi.Void> shader,
  ) {
    return _sk_shader_unref(
      shader,
    );
  }

  late final _sk_shader_unrefPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_shader_unref');
  late final _sk_shader_unref =
      _sk_shader_unrefPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// sk_shader_t sk_shader_with_color_filter(sk_shader_t shader, sk_colorfilter_t filter)
  ffi.Pointer<ffi.Void> sk_shader_with_color_filter(
    ffi.Pointer<ffi.Void> shader,
    ffi.Pointer<ffi.Void> filter,
  ) {
    return _sk_shader_with_color_filter(
      shader,
      filter,
    );
  }

  late final _sk_shader_with_color_filterPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_shader_with_color_filter');
  late final _sk_shader_with_color_filter =
      _sk_shader_with_color_filterPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_shader_t sk_shader_with_local_matrix(sk_shader_t shader, SKMatrix* localMatrix)
  ffi.Pointer<ffi.Void> sk_shader_with_local_matrix(
    ffi.Pointer<ffi.Void> shader,
    ffi.Pointer<ffi.Void> localMatrix,
  ) {
    return _sk_shader_with_local_matrix(
      shader,
      localMatrix,
    );
  }

  late final _sk_shader_with_local_matrixPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_shader_with_local_matrix');
  late final _sk_shader_with_local_matrix =
      _sk_shader_with_local_matrixPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_dynamicmemorywstream_copy_to(sk_wstream_dynamicmemorystream_t cstream, void* data)
  void sk_dynamicmemorywstream_copy_to(
    ffi.Pointer<ffi.Void> cstream,
    ffi.Pointer<ffi.Void> data,
  ) {
    return _sk_dynamicmemorywstream_copy_to(
      cstream,
      data,
    );
  }

  late final _sk_dynamicmemorywstream_copy_toPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_dynamicmemorywstream_copy_to');
  late final _sk_dynamicmemorywstream_copy_to =
      _sk_dynamicmemorywstream_copy_toPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_dynamicmemorywstream_destroy(sk_wstream_dynamicmemorystream_t cstream)
  void sk_dynamicmemorywstream_destroy(
    ffi.Pointer<ffi.Void> cstream,
  ) {
    return _sk_dynamicmemorywstream_destroy(
      cstream,
    );
  }

  late final _sk_dynamicmemorywstream_destroyPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_dynamicmemorywstream_destroy');
  late final _sk_dynamicmemorywstream_destroy =
      _sk_dynamicmemorywstream_destroyPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// sk_data_t sk_dynamicmemorywstream_detach_as_data(sk_wstream_dynamicmemorystream_t cstream)
  ffi.Pointer<ffi.Void> sk_dynamicmemorywstream_detach_as_data(
    ffi.Pointer<ffi.Void> cstream,
  ) {
    return _sk_dynamicmemorywstream_detach_as_data(
      cstream,
    );
  }

  late final _sk_dynamicmemorywstream_detach_as_dataPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_dynamicmemorywstream_detach_as_data');
  late final _sk_dynamicmemorywstream_detach_as_data =
      _sk_dynamicmemorywstream_detach_as_dataPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_stream_asset_t sk_dynamicmemorywstream_detach_as_stream(sk_wstream_dynamicmemorystream_t cstream)
  ffi.Pointer<ffi.Void> sk_dynamicmemorywstream_detach_as_stream(
    ffi.Pointer<ffi.Void> cstream,
  ) {
    return _sk_dynamicmemorywstream_detach_as_stream(
      cstream,
    );
  }

  late final _sk_dynamicmemorywstream_detach_as_streamPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_dynamicmemorywstream_detach_as_stream');
  late final _sk_dynamicmemorywstream_detach_as_stream =
      _sk_dynamicmemorywstream_detach_as_streamPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_wstream_dynamicmemorystream_t sk_dynamicmemorywstream_new()
  ffi.Pointer<ffi.Void> sk_dynamicmemorywstream_new() {
    return _sk_dynamicmemorywstream_new();
  }

  late final _sk_dynamicmemorywstream_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_dynamicmemorywstream_new');
  late final _sk_dynamicmemorywstream_new =
      _sk_dynamicmemorywstream_newPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// bool sk_dynamicmemorywstream_write_to_stream(sk_wstream_dynamicmemorystream_t cstream, sk_wstream_t dst)
  bool sk_dynamicmemorywstream_write_to_stream(
    ffi.Pointer<ffi.Void> cstream,
    ffi.Pointer<ffi.Void> dst,
  ) {
    return _sk_dynamicmemorywstream_write_to_stream(
      cstream,
      dst,
    );
  }

  late final _sk_dynamicmemorywstream_write_to_streamPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_dynamicmemorywstream_write_to_stream');
  late final _sk_dynamicmemorywstream_write_to_stream =
      _sk_dynamicmemorywstream_write_to_streamPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_filestream_destroy(sk_stream_filestream_t cstream)
  void sk_filestream_destroy(
    ffi.Pointer<ffi.Void> cstream,
  ) {
    return _sk_filestream_destroy(
      cstream,
    );
  }

  late final _sk_filestream_destroyPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_filestream_destroy');
  late final _sk_filestream_destroy =
      _sk_filestream_destroyPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_filestream_is_valid(sk_stream_filestream_t cstream)
  bool sk_filestream_is_valid(
    ffi.Pointer<ffi.Void> cstream,
  ) {
    return _sk_filestream_is_valid(
      cstream,
    );
  }

  late final _sk_filestream_is_validPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_filestream_is_valid');
  late final _sk_filestream_is_valid =
      _sk_filestream_is_validPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// sk_stream_filestream_t sk_filestream_new(void* path)
  ffi.Pointer<ffi.Void> sk_filestream_new(
    ffi.Pointer<ffi.Void> path,
  ) {
    return _sk_filestream_new(
      path,
    );
  }

  late final _sk_filestream_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_filestream_new');
  late final _sk_filestream_new =
      _sk_filestream_newPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_filewstream_destroy(sk_wstream_filestream_t cstream)
  void sk_filewstream_destroy(
    ffi.Pointer<ffi.Void> cstream,
  ) {
    return _sk_filewstream_destroy(
      cstream,
    );
  }

  late final _sk_filewstream_destroyPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_filewstream_destroy');
  late final _sk_filewstream_destroy =
      _sk_filewstream_destroyPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_filewstream_is_valid(sk_wstream_filestream_t cstream)
  bool sk_filewstream_is_valid(
    ffi.Pointer<ffi.Void> cstream,
  ) {
    return _sk_filewstream_is_valid(
      cstream,
    );
  }

  late final _sk_filewstream_is_validPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_filewstream_is_valid');
  late final _sk_filewstream_is_valid =
      _sk_filewstream_is_validPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// sk_wstream_filestream_t sk_filewstream_new(void* path)
  ffi.Pointer<ffi.Void> sk_filewstream_new(
    ffi.Pointer<ffi.Void> path,
  ) {
    return _sk_filewstream_new(
      path,
    );
  }

  late final _sk_filewstream_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_filewstream_new');
  late final _sk_filewstream_new =
      _sk_filewstream_newPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_memorystream_destroy(sk_stream_memorystream_t cstream)
  void sk_memorystream_destroy(
    ffi.Pointer<ffi.Void> cstream,
  ) {
    return _sk_memorystream_destroy(
      cstream,
    );
  }

  late final _sk_memorystream_destroyPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_memorystream_destroy');
  late final _sk_memorystream_destroy =
      _sk_memorystream_destroyPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// sk_stream_memorystream_t sk_memorystream_new()
  ffi.Pointer<ffi.Void> sk_memorystream_new() {
    return _sk_memorystream_new();
  }

  late final _sk_memorystream_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_memorystream_new');
  late final _sk_memorystream_new =
      _sk_memorystream_newPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// sk_stream_memorystream_t sk_memorystream_new_with_data(void* data, IntPtr length, bool copyData)
  ffi.Pointer<ffi.Void> sk_memorystream_new_with_data(
    ffi.Pointer<ffi.Void> data,
    ffi.Pointer<ffi.Void> length,
    bool copyData,
  ) {
    return _sk_memorystream_new_with_data(
      data,
      length,
      copyData,
    );
  }

  late final _sk_memorystream_new_with_dataPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Bool)>>('sk_memorystream_new_with_data');
  late final _sk_memorystream_new_with_data =
      _sk_memorystream_new_with_dataPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, bool)>();

  /// sk_stream_memorystream_t sk_memorystream_new_with_length(IntPtr length)
  ffi.Pointer<ffi.Void> sk_memorystream_new_with_length(
    ffi.Pointer<ffi.Void> length,
  ) {
    return _sk_memorystream_new_with_length(
      length,
    );
  }

  late final _sk_memorystream_new_with_lengthPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_memorystream_new_with_length');
  late final _sk_memorystream_new_with_length =
      _sk_memorystream_new_with_lengthPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_stream_memorystream_t sk_memorystream_new_with_skdata(sk_data_t data)
  ffi.Pointer<ffi.Void> sk_memorystream_new_with_skdata(
    ffi.Pointer<ffi.Void> data,
  ) {
    return _sk_memorystream_new_with_skdata(
      data,
    );
  }

  late final _sk_memorystream_new_with_skdataPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_memorystream_new_with_skdata');
  late final _sk_memorystream_new_with_skdata =
      _sk_memorystream_new_with_skdataPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_memorystream_set_memory(sk_stream_memorystream_t cmemorystream, void* data, IntPtr length, bool copyData)
  void sk_memorystream_set_memory(
    ffi.Pointer<ffi.Void> cmemorystream,
    ffi.Pointer<ffi.Void> data,
    ffi.Pointer<ffi.Void> length,
    bool copyData,
  ) {
    return _sk_memorystream_set_memory(
      cmemorystream,
      data,
      length,
      copyData,
    );
  }

  late final _sk_memorystream_set_memoryPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Bool)>>('sk_memorystream_set_memory');
  late final _sk_memorystream_set_memory =
      _sk_memorystream_set_memoryPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, bool)>();

  /// void sk_stream_asset_destroy(sk_stream_asset_t cstream)
  void sk_stream_asset_destroy(
    ffi.Pointer<ffi.Void> cstream,
  ) {
    return _sk_stream_asset_destroy(
      cstream,
    );
  }

  late final _sk_stream_asset_destroyPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_stream_asset_destroy');
  late final _sk_stream_asset_destroy =
      _sk_stream_asset_destroyPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_stream_destroy(sk_stream_t cstream)
  void sk_stream_destroy(
    ffi.Pointer<ffi.Void> cstream,
  ) {
    return _sk_stream_destroy(
      cstream,
    );
  }

  late final _sk_stream_destroyPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_stream_destroy');
  late final _sk_stream_destroy =
      _sk_stream_destroyPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// sk_stream_t sk_stream_duplicate(sk_stream_t cstream)
  ffi.Pointer<ffi.Void> sk_stream_duplicate(
    ffi.Pointer<ffi.Void> cstream,
  ) {
    return _sk_stream_duplicate(
      cstream,
    );
  }

  late final _sk_stream_duplicatePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_stream_duplicate');
  late final _sk_stream_duplicate =
      _sk_stream_duplicatePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_stream_t sk_stream_fork(sk_stream_t cstream)
  ffi.Pointer<ffi.Void> sk_stream_fork(
    ffi.Pointer<ffi.Void> cstream,
  ) {
    return _sk_stream_fork(
      cstream,
    );
  }

  late final _sk_stream_forkPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_stream_fork');
  late final _sk_stream_fork =
      _sk_stream_forkPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// IntPtr sk_stream_get_length(sk_stream_t cstream)
  ffi.Pointer<ffi.Void> sk_stream_get_length(
    ffi.Pointer<ffi.Void> cstream,
  ) {
    return _sk_stream_get_length(
      cstream,
    );
  }

  late final _sk_stream_get_lengthPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_stream_get_length');
  late final _sk_stream_get_length =
      _sk_stream_get_lengthPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void* sk_stream_get_memory_base(sk_stream_t cstream)
  ffi.Pointer<ffi.Void> sk_stream_get_memory_base(
    ffi.Pointer<ffi.Void> cstream,
  ) {
    return _sk_stream_get_memory_base(
      cstream,
    );
  }

  late final _sk_stream_get_memory_basePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_stream_get_memory_base');
  late final _sk_stream_get_memory_base =
      _sk_stream_get_memory_basePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// IntPtr sk_stream_get_position(sk_stream_t cstream)
  ffi.Pointer<ffi.Void> sk_stream_get_position(
    ffi.Pointer<ffi.Void> cstream,
  ) {
    return _sk_stream_get_position(
      cstream,
    );
  }

  late final _sk_stream_get_positionPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_stream_get_position');
  late final _sk_stream_get_position =
      _sk_stream_get_positionPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_stream_has_length(sk_stream_t cstream)
  bool sk_stream_has_length(
    ffi.Pointer<ffi.Void> cstream,
  ) {
    return _sk_stream_has_length(
      cstream,
    );
  }

  late final _sk_stream_has_lengthPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_stream_has_length');
  late final _sk_stream_has_length =
      _sk_stream_has_lengthPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_stream_has_position(sk_stream_t cstream)
  bool sk_stream_has_position(
    ffi.Pointer<ffi.Void> cstream,
  ) {
    return _sk_stream_has_position(
      cstream,
    );
  }

  late final _sk_stream_has_positionPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_stream_has_position');
  late final _sk_stream_has_position =
      _sk_stream_has_positionPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_stream_is_at_end(sk_stream_t cstream)
  bool sk_stream_is_at_end(
    ffi.Pointer<ffi.Void> cstream,
  ) {
    return _sk_stream_is_at_end(
      cstream,
    );
  }

  late final _sk_stream_is_at_endPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_stream_is_at_end');
  late final _sk_stream_is_at_end =
      _sk_stream_is_at_endPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_stream_move(sk_stream_t cstream, Int32 offset)
  bool sk_stream_move(
    ffi.Pointer<ffi.Void> cstream,
    int offset,
  ) {
    return _sk_stream_move(
      cstream,
      offset,
    );
  }

  late final _sk_stream_movePtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_stream_move');
  late final _sk_stream_move =
      _sk_stream_movePtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, int)>();

  /// IntPtr sk_stream_peek(sk_stream_t cstream, void* buffer, IntPtr size)
  ffi.Pointer<ffi.Void> sk_stream_peek(
    ffi.Pointer<ffi.Void> cstream,
    ffi.Pointer<ffi.Void> buffer,
    ffi.Pointer<ffi.Void> size,
  ) {
    return _sk_stream_peek(
      cstream,
      buffer,
      size,
    );
  }

  late final _sk_stream_peekPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_stream_peek');
  late final _sk_stream_peek =
      _sk_stream_peekPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// IntPtr sk_stream_read(sk_stream_t cstream, void* buffer, IntPtr size)
  ffi.Pointer<ffi.Void> sk_stream_read(
    ffi.Pointer<ffi.Void> cstream,
    ffi.Pointer<ffi.Void> buffer,
    ffi.Pointer<ffi.Void> size,
  ) {
    return _sk_stream_read(
      cstream,
      buffer,
      size,
    );
  }

  late final _sk_stream_readPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_stream_read');
  late final _sk_stream_read =
      _sk_stream_readPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_stream_read_bool(sk_stream_t cstream, Byte* buffer)
  bool sk_stream_read_bool(
    ffi.Pointer<ffi.Void> cstream,
    ffi.Pointer<ffi.Uint8> buffer,
  ) {
    return _sk_stream_read_bool(
      cstream,
      buffer,
    );
  }

  late final _sk_stream_read_boolPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint8>)>>('sk_stream_read_bool');
  late final _sk_stream_read_bool =
      _sk_stream_read_boolPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint8>)>();

  /// bool sk_stream_read_s16(sk_stream_t cstream, Int16* buffer)
  bool sk_stream_read_s16(
    ffi.Pointer<ffi.Void> cstream,
    ffi.Pointer<ffi.Int16> buffer,
  ) {
    return _sk_stream_read_s16(
      cstream,
      buffer,
    );
  }

  late final _sk_stream_read_s16Ptr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Int16>)>>('sk_stream_read_s16');
  late final _sk_stream_read_s16 =
      _sk_stream_read_s16Ptr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Int16>)>();

  /// bool sk_stream_read_s32(sk_stream_t cstream, Int32* buffer)
  bool sk_stream_read_s32(
    ffi.Pointer<ffi.Void> cstream,
    ffi.Pointer<ffi.Int32> buffer,
  ) {
    return _sk_stream_read_s32(
      cstream,
      buffer,
    );
  }

  late final _sk_stream_read_s32Ptr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Int32>)>>('sk_stream_read_s32');
  late final _sk_stream_read_s32 =
      _sk_stream_read_s32Ptr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Int32>)>();

  /// bool sk_stream_read_s8(sk_stream_t cstream, SByte* buffer)
  bool sk_stream_read_s8(
    ffi.Pointer<ffi.Void> cstream,
    ffi.Pointer<ffi.Int8> buffer,
  ) {
    return _sk_stream_read_s8(
      cstream,
      buffer,
    );
  }

  late final _sk_stream_read_s8Ptr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Int8>)>>('sk_stream_read_s8');
  late final _sk_stream_read_s8 =
      _sk_stream_read_s8Ptr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Int8>)>();

  /// bool sk_stream_read_u16(sk_stream_t cstream, UInt16* buffer)
  bool sk_stream_read_u16(
    ffi.Pointer<ffi.Void> cstream,
    ffi.Pointer<ffi.Uint16> buffer,
  ) {
    return _sk_stream_read_u16(
      cstream,
      buffer,
    );
  }

  late final _sk_stream_read_u16Ptr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint16>)>>('sk_stream_read_u16');
  late final _sk_stream_read_u16 =
      _sk_stream_read_u16Ptr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint16>)>();

  /// bool sk_stream_read_u32(sk_stream_t cstream, UInt32* buffer)
  bool sk_stream_read_u32(
    ffi.Pointer<ffi.Void> cstream,
    ffi.Pointer<ffi.Uint32> buffer,
  ) {
    return _sk_stream_read_u32(
      cstream,
      buffer,
    );
  }

  late final _sk_stream_read_u32Ptr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint32>)>>('sk_stream_read_u32');
  late final _sk_stream_read_u32 =
      _sk_stream_read_u32Ptr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint32>)>();

  /// bool sk_stream_read_u8(sk_stream_t cstream, Byte* buffer)
  bool sk_stream_read_u8(
    ffi.Pointer<ffi.Void> cstream,
    ffi.Pointer<ffi.Uint8> buffer,
  ) {
    return _sk_stream_read_u8(
      cstream,
      buffer,
    );
  }

  late final _sk_stream_read_u8Ptr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint8>)>>('sk_stream_read_u8');
  late final _sk_stream_read_u8 =
      _sk_stream_read_u8Ptr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint8>)>();

  /// bool sk_stream_rewind(sk_stream_t cstream)
  bool sk_stream_rewind(
    ffi.Pointer<ffi.Void> cstream,
  ) {
    return _sk_stream_rewind(
      cstream,
    );
  }

  late final _sk_stream_rewindPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_stream_rewind');
  late final _sk_stream_rewind =
      _sk_stream_rewindPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_stream_seek(sk_stream_t cstream, IntPtr position)
  bool sk_stream_seek(
    ffi.Pointer<ffi.Void> cstream,
    ffi.Pointer<ffi.Void> position,
  ) {
    return _sk_stream_seek(
      cstream,
      position,
    );
  }

  late final _sk_stream_seekPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_stream_seek');
  late final _sk_stream_seek =
      _sk_stream_seekPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// IntPtr sk_stream_skip(sk_stream_t cstream, IntPtr size)
  ffi.Pointer<ffi.Void> sk_stream_skip(
    ffi.Pointer<ffi.Void> cstream,
    ffi.Pointer<ffi.Void> size,
  ) {
    return _sk_stream_skip(
      cstream,
      size,
    );
  }

  late final _sk_stream_skipPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_stream_skip');
  late final _sk_stream_skip =
      _sk_stream_skipPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// IntPtr sk_wstream_bytes_written(sk_wstream_t cstream)
  ffi.Pointer<ffi.Void> sk_wstream_bytes_written(
    ffi.Pointer<ffi.Void> cstream,
  ) {
    return _sk_wstream_bytes_written(
      cstream,
    );
  }

  late final _sk_wstream_bytes_writtenPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_wstream_bytes_written');
  late final _sk_wstream_bytes_written =
      _sk_wstream_bytes_writtenPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_wstream_flush(sk_wstream_t cstream)
  void sk_wstream_flush(
    ffi.Pointer<ffi.Void> cstream,
  ) {
    return _sk_wstream_flush(
      cstream,
    );
  }

  late final _sk_wstream_flushPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_wstream_flush');
  late final _sk_wstream_flush =
      _sk_wstream_flushPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_wstream_get_size_of_packed_uint(IntPtr value)
  int sk_wstream_get_size_of_packed_uint(
    ffi.Pointer<ffi.Void> value,
  ) {
    return _sk_wstream_get_size_of_packed_uint(
      value,
    );
  }

  late final _sk_wstream_get_size_of_packed_uintPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_wstream_get_size_of_packed_uint');
  late final _sk_wstream_get_size_of_packed_uint =
      _sk_wstream_get_size_of_packed_uintPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_wstream_newline(sk_wstream_t cstream)
  bool sk_wstream_newline(
    ffi.Pointer<ffi.Void> cstream,
  ) {
    return _sk_wstream_newline(
      cstream,
    );
  }

  late final _sk_wstream_newlinePtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_wstream_newline');
  late final _sk_wstream_newline =
      _sk_wstream_newlinePtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_wstream_write(sk_wstream_t cstream, void* buffer, IntPtr size)
  bool sk_wstream_write(
    ffi.Pointer<ffi.Void> cstream,
    ffi.Pointer<ffi.Void> buffer,
    ffi.Pointer<ffi.Void> size,
  ) {
    return _sk_wstream_write(
      cstream,
      buffer,
      size,
    );
  }

  late final _sk_wstream_writePtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_wstream_write');
  late final _sk_wstream_write =
      _sk_wstream_writePtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_wstream_write_16(sk_wstream_t cstream, UInt16 value)
  bool sk_wstream_write_16(
    ffi.Pointer<ffi.Void> cstream,
    int value,
  ) {
    return _sk_wstream_write_16(
      cstream,
      value,
    );
  }

  late final _sk_wstream_write_16Ptr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Uint16)>>('sk_wstream_write_16');
  late final _sk_wstream_write_16 =
      _sk_wstream_write_16Ptr.asFunction<bool Function(ffi.Pointer<ffi.Void>, int)>();

  /// bool sk_wstream_write_32(sk_wstream_t cstream, UInt32 value)
  bool sk_wstream_write_32(
    ffi.Pointer<ffi.Void> cstream,
    int value,
  ) {
    return _sk_wstream_write_32(
      cstream,
      value,
    );
  }

  late final _sk_wstream_write_32Ptr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Uint32)>>('sk_wstream_write_32');
  late final _sk_wstream_write_32 =
      _sk_wstream_write_32Ptr.asFunction<bool Function(ffi.Pointer<ffi.Void>, int)>();

  /// bool sk_wstream_write_8(sk_wstream_t cstream, Byte value)
  bool sk_wstream_write_8(
    ffi.Pointer<ffi.Void> cstream,
    int value,
  ) {
    return _sk_wstream_write_8(
      cstream,
      value,
    );
  }

  late final _sk_wstream_write_8Ptr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Uint8)>>('sk_wstream_write_8');
  late final _sk_wstream_write_8 =
      _sk_wstream_write_8Ptr.asFunction<bool Function(ffi.Pointer<ffi.Void>, int)>();

  /// bool sk_wstream_write_bigdec_as_text(sk_wstream_t cstream, Int64 value, Int32 minDigits)
  bool sk_wstream_write_bigdec_as_text(
    ffi.Pointer<ffi.Void> cstream,
    int value,
    int minDigits,
  ) {
    return _sk_wstream_write_bigdec_as_text(
      cstream,
      value,
      minDigits,
    );
  }

  late final _sk_wstream_write_bigdec_as_textPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Int64, ffi.Int32)>>('sk_wstream_write_bigdec_as_text');
  late final _sk_wstream_write_bigdec_as_text =
      _sk_wstream_write_bigdec_as_textPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, int, int)>();

  /// bool sk_wstream_write_bool(sk_wstream_t cstream, bool value)
  bool sk_wstream_write_bool(
    ffi.Pointer<ffi.Void> cstream,
    bool value,
  ) {
    return _sk_wstream_write_bool(
      cstream,
      value,
    );
  }

  late final _sk_wstream_write_boolPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Bool)>>('sk_wstream_write_bool');
  late final _sk_wstream_write_bool =
      _sk_wstream_write_boolPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, bool)>();

  /// bool sk_wstream_write_dec_as_text(sk_wstream_t cstream, Int32 value)
  bool sk_wstream_write_dec_as_text(
    ffi.Pointer<ffi.Void> cstream,
    int value,
  ) {
    return _sk_wstream_write_dec_as_text(
      cstream,
      value,
    );
  }

  late final _sk_wstream_write_dec_as_textPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_wstream_write_dec_as_text');
  late final _sk_wstream_write_dec_as_text =
      _sk_wstream_write_dec_as_textPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, int)>();

  /// bool sk_wstream_write_hex_as_text(sk_wstream_t cstream, UInt32 value, Int32 minDigits)
  bool sk_wstream_write_hex_as_text(
    ffi.Pointer<ffi.Void> cstream,
    int value,
    int minDigits,
  ) {
    return _sk_wstream_write_hex_as_text(
      cstream,
      value,
      minDigits,
    );
  }

  late final _sk_wstream_write_hex_as_textPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Uint32, ffi.Int32)>>('sk_wstream_write_hex_as_text');
  late final _sk_wstream_write_hex_as_text =
      _sk_wstream_write_hex_as_textPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, int, int)>();

  /// bool sk_wstream_write_packed_uint(sk_wstream_t cstream, IntPtr value)
  bool sk_wstream_write_packed_uint(
    ffi.Pointer<ffi.Void> cstream,
    ffi.Pointer<ffi.Void> value,
  ) {
    return _sk_wstream_write_packed_uint(
      cstream,
      value,
    );
  }

  late final _sk_wstream_write_packed_uintPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_wstream_write_packed_uint');
  late final _sk_wstream_write_packed_uint =
      _sk_wstream_write_packed_uintPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_wstream_write_scalar(sk_wstream_t cstream, Single value)
  bool sk_wstream_write_scalar(
    ffi.Pointer<ffi.Void> cstream,
    double value,
  ) {
    return _sk_wstream_write_scalar(
      cstream,
      value,
    );
  }

  late final _sk_wstream_write_scalarPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Float)>>('sk_wstream_write_scalar');
  late final _sk_wstream_write_scalar =
      _sk_wstream_write_scalarPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, double)>();

  /// bool sk_wstream_write_scalar_as_text(sk_wstream_t cstream, Single value)
  bool sk_wstream_write_scalar_as_text(
    ffi.Pointer<ffi.Void> cstream,
    double value,
  ) {
    return _sk_wstream_write_scalar_as_text(
      cstream,
      value,
    );
  }

  late final _sk_wstream_write_scalar_as_textPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Float)>>('sk_wstream_write_scalar_as_text');
  late final _sk_wstream_write_scalar_as_text =
      _sk_wstream_write_scalar_as_textPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, double)>();

  /// bool sk_wstream_write_stream(sk_wstream_t cstream, sk_stream_t input, IntPtr length)
  bool sk_wstream_write_stream(
    ffi.Pointer<ffi.Void> cstream,
    ffi.Pointer<ffi.Void> input,
    ffi.Pointer<ffi.Void> length,
  ) {
    return _sk_wstream_write_stream(
      cstream,
      input,
      length,
    );
  }

  late final _sk_wstream_write_streamPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_wstream_write_stream');
  late final _sk_wstream_write_stream =
      _sk_wstream_write_streamPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_wstream_write_text(sk_wstream_t cstream, String value)
  bool sk_wstream_write_text(
    ffi.Pointer<ffi.Void> cstream,
    ffi.Pointer<ffi.Void> value,
  ) {
    return _sk_wstream_write_text(
      cstream,
      value,
    );
  }

  late final _sk_wstream_write_textPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_wstream_write_text');
  late final _sk_wstream_write_text =
      _sk_wstream_write_textPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_string_destructor(sk_string_t param0)
  void sk_string_destructor(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_string_destructor(
      param0,
    );
  }

  late final _sk_string_destructorPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_string_destructor');
  late final _sk_string_destructor =
      _sk_string_destructorPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void* sk_string_get_c_str(sk_string_t param0)
  ffi.Pointer<ffi.Void> sk_string_get_c_str(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_string_get_c_str(
      param0,
    );
  }

  late final _sk_string_get_c_strPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_string_get_c_str');
  late final _sk_string_get_c_str =
      _sk_string_get_c_strPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// IntPtr sk_string_get_size(sk_string_t param0)
  ffi.Pointer<ffi.Void> sk_string_get_size(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_string_get_size(
      param0,
    );
  }

  late final _sk_string_get_sizePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_string_get_size');
  late final _sk_string_get_size =
      _sk_string_get_sizePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_string_t sk_string_new_empty()
  ffi.Pointer<ffi.Void> sk_string_new_empty() {
    return _sk_string_new_empty();
  }

  late final _sk_string_new_emptyPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_string_new_empty');
  late final _sk_string_new_empty =
      _sk_string_new_emptyPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// sk_string_t sk_string_new_with_copy(void* src, IntPtr length)
  ffi.Pointer<ffi.Void> sk_string_new_with_copy(
    ffi.Pointer<ffi.Void> src,
    ffi.Pointer<ffi.Void> length,
  ) {
    return _sk_string_new_with_copy(
      src,
      length,
    );
  }

  late final _sk_string_new_with_copyPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_string_new_with_copy');
  late final _sk_string_new_with_copy =
      _sk_string_new_with_copyPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_surface_draw(sk_surface_t surface, sk_canvas_t canvas, Single x, Single y, sk_paint_t paint)
  void sk_surface_draw(
    ffi.Pointer<ffi.Void> surface,
    ffi.Pointer<ffi.Void> canvas,
    double x,
    double y,
    ffi.Pointer<ffi.Void> paint,
  ) {
    return _sk_surface_draw(
      surface,
      canvas,
      x,
      y,
      paint,
    );
  }

  late final _sk_surface_drawPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>)>>('sk_surface_draw');
  late final _sk_surface_draw =
      _sk_surface_drawPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, double, double, ffi.Pointer<ffi.Void>)>();

  /// sk_canvas_t sk_surface_get_canvas(sk_surface_t param0)
  ffi.Pointer<ffi.Void> sk_surface_get_canvas(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_surface_get_canvas(
      param0,
    );
  }

  late final _sk_surface_get_canvasPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_surface_get_canvas');
  late final _sk_surface_get_canvas =
      _sk_surface_get_canvasPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_surfaceprops_t sk_surface_get_props(sk_surface_t surface)
  ffi.Pointer<ffi.Void> sk_surface_get_props(
    ffi.Pointer<ffi.Void> surface,
  ) {
    return _sk_surface_get_props(
      surface,
    );
  }

  late final _sk_surface_get_propsPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_surface_get_props');
  late final _sk_surface_get_props =
      _sk_surface_get_propsPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// gr_recording_context_t sk_surface_get_recording_context(sk_surface_t surface)
  ffi.Pointer<ffi.Void> sk_surface_get_recording_context(
    ffi.Pointer<ffi.Void> surface,
  ) {
    return _sk_surface_get_recording_context(
      surface,
    );
  }

  late final _sk_surface_get_recording_contextPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_surface_get_recording_context');
  late final _sk_surface_get_recording_context =
      _sk_surface_get_recording_contextPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_surface_t sk_surface_new_backend_render_target(gr_recording_context_t context, gr_backendrendertarget_t target, GRSurfaceOrigin origin, SKColorTypeNative colorType, sk_colorspace_t colorspace, sk_surfaceprops_t props)
  ffi.Pointer<ffi.Void> sk_surface_new_backend_render_target(
    ffi.Pointer<ffi.Void> context,
    ffi.Pointer<ffi.Void> target,
    int origin,
    int colorType,
    ffi.Pointer<ffi.Void> colorspace,
    ffi.Pointer<ffi.Void> props,
  ) {
    return _sk_surface_new_backend_render_target(
      context,
      target,
      origin,
      colorType,
      colorspace,
      props,
    );
  }

  late final _sk_surface_new_backend_render_targetPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_surface_new_backend_render_target');
  late final _sk_surface_new_backend_render_target =
      _sk_surface_new_backend_render_targetPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_surface_t sk_surface_new_backend_texture(gr_recording_context_t context, gr_backendtexture_t texture, GRSurfaceOrigin origin, Int32 samples, SKColorTypeNative colorType, sk_colorspace_t colorspace, sk_surfaceprops_t props)
  ffi.Pointer<ffi.Void> sk_surface_new_backend_texture(
    ffi.Pointer<ffi.Void> context,
    ffi.Pointer<ffi.Void> texture,
    int origin,
    int samples,
    int colorType,
    ffi.Pointer<ffi.Void> colorspace,
    ffi.Pointer<ffi.Void> props,
  ) {
    return _sk_surface_new_backend_texture(
      context,
      texture,
      origin,
      samples,
      colorType,
      colorspace,
      props,
    );
  }

  late final _sk_surface_new_backend_texturePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_surface_new_backend_texture');
  late final _sk_surface_new_backend_texture =
      _sk_surface_new_backend_texturePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, int, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_image_t sk_surface_new_image_snapshot(sk_surface_t param0)
  ffi.Pointer<ffi.Void> sk_surface_new_image_snapshot(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_surface_new_image_snapshot(
      param0,
    );
  }

  late final _sk_surface_new_image_snapshotPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_surface_new_image_snapshot');
  late final _sk_surface_new_image_snapshot =
      _sk_surface_new_image_snapshotPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_image_t sk_surface_new_image_snapshot_with_crop(sk_surface_t surface, SKRectI* bounds)
  ffi.Pointer<ffi.Void> sk_surface_new_image_snapshot_with_crop(
    ffi.Pointer<ffi.Void> surface,
    ffi.Pointer<ffi.Void> bounds,
  ) {
    return _sk_surface_new_image_snapshot_with_crop(
      surface,
      bounds,
    );
  }

  late final _sk_surface_new_image_snapshot_with_cropPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_surface_new_image_snapshot_with_crop');
  late final _sk_surface_new_image_snapshot_with_crop =
      _sk_surface_new_image_snapshot_with_cropPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_surface_t sk_surface_new_metal_layer(gr_recording_context_t context, void* layer, GRSurfaceOrigin origin, Int32 sampleCount, SKColorTypeNative colorType, sk_colorspace_t colorspace, sk_surfaceprops_t props, void** drawable)
  ffi.Pointer<ffi.Void> sk_surface_new_metal_layer(
    ffi.Pointer<ffi.Void> context,
    ffi.Pointer<ffi.Void> layer,
    int origin,
    int sampleCount,
    int colorType,
    ffi.Pointer<ffi.Void> colorspace,
    ffi.Pointer<ffi.Void> props,
    ffi.Pointer<ffi.Void> drawable,
  ) {
    return _sk_surface_new_metal_layer(
      context,
      layer,
      origin,
      sampleCount,
      colorType,
      colorspace,
      props,
      drawable,
    );
  }

  late final _sk_surface_new_metal_layerPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_surface_new_metal_layer');
  late final _sk_surface_new_metal_layer =
      _sk_surface_new_metal_layerPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, int, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_surface_t sk_surface_new_metal_view(gr_recording_context_t context, void* mtkView, GRSurfaceOrigin origin, Int32 sampleCount, SKColorTypeNative colorType, sk_colorspace_t colorspace, sk_surfaceprops_t props)
  ffi.Pointer<ffi.Void> sk_surface_new_metal_view(
    ffi.Pointer<ffi.Void> context,
    ffi.Pointer<ffi.Void> mtkView,
    int origin,
    int sampleCount,
    int colorType,
    ffi.Pointer<ffi.Void> colorspace,
    ffi.Pointer<ffi.Void> props,
  ) {
    return _sk_surface_new_metal_view(
      context,
      mtkView,
      origin,
      sampleCount,
      colorType,
      colorspace,
      props,
    );
  }

  late final _sk_surface_new_metal_viewPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_surface_new_metal_view');
  late final _sk_surface_new_metal_view =
      _sk_surface_new_metal_viewPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, int, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_surface_t sk_surface_new_null(Int32 width, Int32 height)
  ffi.Pointer<ffi.Void> sk_surface_new_null(
    int width,
    int height,
  ) {
    return _sk_surface_new_null(
      width,
      height,
    );
  }

  late final _sk_surface_new_nullPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Int32, ffi.Int32)>>('sk_surface_new_null');
  late final _sk_surface_new_null =
      _sk_surface_new_nullPtr.asFunction<ffi.Pointer<ffi.Void> Function(int, int)>();

  /// sk_surface_t sk_surface_new_raster(SKImageInfoNative* param0, IntPtr rowBytes, sk_surfaceprops_t param2)
  ffi.Pointer<ffi.Void> sk_surface_new_raster(
    ffi.Pointer<ffi.Void> param0,
    ffi.Pointer<ffi.Void> rowBytes,
    ffi.Pointer<ffi.Void> param2,
  ) {
    return _sk_surface_new_raster(
      param0,
      rowBytes,
      param2,
    );
  }

  late final _sk_surface_new_rasterPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_surface_new_raster');
  late final _sk_surface_new_raster =
      _sk_surface_new_rasterPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_surface_t sk_surface_new_raster_direct(SKImageInfoNative* param0, void* pixels, IntPtr rowBytes, void* releaseProc, void* context, sk_surfaceprops_t props)
  ffi.Pointer<ffi.Void> sk_surface_new_raster_direct(
    ffi.Pointer<ffi.Void> param0,
    ffi.Pointer<ffi.Void> pixels,
    ffi.Pointer<ffi.Void> rowBytes,
    ffi.Pointer<ffi.Void> releaseProc,
    ffi.Pointer<ffi.Void> context,
    ffi.Pointer<ffi.Void> props,
  ) {
    return _sk_surface_new_raster_direct(
      param0,
      pixels,
      rowBytes,
      releaseProc,
      context,
      props,
    );
  }

  late final _sk_surface_new_raster_directPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_surface_new_raster_direct');
  late final _sk_surface_new_raster_direct =
      _sk_surface_new_raster_directPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_surface_t sk_surface_new_render_target(gr_recording_context_t context, bool budgeted, SKImageInfoNative* cinfo, Int32 sampleCount, GRSurfaceOrigin origin, sk_surfaceprops_t props, bool shouldCreateWithMips)
  ffi.Pointer<ffi.Void> sk_surface_new_render_target(
    ffi.Pointer<ffi.Void> context,
    bool budgeted,
    ffi.Pointer<ffi.Void> cinfo,
    int sampleCount,
    int origin,
    ffi.Pointer<ffi.Void> props,
    bool shouldCreateWithMips,
  ) {
    return _sk_surface_new_render_target(
      context,
      budgeted,
      cinfo,
      sampleCount,
      origin,
      props,
      shouldCreateWithMips,
    );
  }

  late final _sk_surface_new_render_targetPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Bool, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Bool)>>('sk_surface_new_render_target');
  late final _sk_surface_new_render_target =
      _sk_surface_new_render_targetPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, bool, ffi.Pointer<ffi.Void>, int, int, ffi.Pointer<ffi.Void>, bool)>();

  /// bool sk_surface_peek_pixels(sk_surface_t surface, sk_pixmap_t pixmap)
  bool sk_surface_peek_pixels(
    ffi.Pointer<ffi.Void> surface,
    ffi.Pointer<ffi.Void> pixmap,
  ) {
    return _sk_surface_peek_pixels(
      surface,
      pixmap,
    );
  }

  late final _sk_surface_peek_pixelsPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_surface_peek_pixels');
  late final _sk_surface_peek_pixels =
      _sk_surface_peek_pixelsPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// bool sk_surface_read_pixels(sk_surface_t surface, SKImageInfoNative* dstInfo, void* dstPixels, IntPtr dstRowBytes, Int32 srcX, Int32 srcY)
  bool sk_surface_read_pixels(
    ffi.Pointer<ffi.Void> surface,
    ffi.Pointer<ffi.Void> dstInfo,
    ffi.Pointer<ffi.Void> dstPixels,
    ffi.Pointer<ffi.Void> dstRowBytes,
    int srcX,
    int srcY,
  ) {
    return _sk_surface_read_pixels(
      surface,
      dstInfo,
      dstPixels,
      dstRowBytes,
      srcX,
      srcY,
    );
  }

  late final _sk_surface_read_pixelsPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32)>>('sk_surface_read_pixels');
  late final _sk_surface_read_pixels =
      _sk_surface_read_pixelsPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, int)>();

  /// void sk_surface_unref(sk_surface_t param0)
  void sk_surface_unref(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_surface_unref(
      param0,
    );
  }

  late final _sk_surface_unrefPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_surface_unref');
  late final _sk_surface_unref =
      _sk_surface_unrefPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_surfaceprops_delete(sk_surfaceprops_t props)
  void sk_surfaceprops_delete(
    ffi.Pointer<ffi.Void> props,
  ) {
    return _sk_surfaceprops_delete(
      props,
    );
  }

  late final _sk_surfaceprops_deletePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_surfaceprops_delete');
  late final _sk_surfaceprops_delete =
      _sk_surfaceprops_deletePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// UInt32 sk_surfaceprops_get_flags(sk_surfaceprops_t props)
  int sk_surfaceprops_get_flags(
    ffi.Pointer<ffi.Void> props,
  ) {
    return _sk_surfaceprops_get_flags(
      props,
    );
  }

  late final _sk_surfaceprops_get_flagsPtr = _lookup<
      ffi.NativeFunction<ffi.Uint32 Function(ffi.Pointer<ffi.Void>)>>('sk_surfaceprops_get_flags');
  late final _sk_surfaceprops_get_flags =
      _sk_surfaceprops_get_flagsPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// SKPixelGeometry sk_surfaceprops_get_pixel_geometry(sk_surfaceprops_t props)
  int sk_surfaceprops_get_pixel_geometry(
    ffi.Pointer<ffi.Void> props,
  ) {
    return _sk_surfaceprops_get_pixel_geometry(
      props,
    );
  }

  late final _sk_surfaceprops_get_pixel_geometryPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_surfaceprops_get_pixel_geometry');
  late final _sk_surfaceprops_get_pixel_geometry =
      _sk_surfaceprops_get_pixel_geometryPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// sk_surfaceprops_t sk_surfaceprops_new(UInt32 flags, SKPixelGeometry geometry)
  ffi.Pointer<ffi.Void> sk_surfaceprops_new(
    int flags,
    int geometry,
  ) {
    return _sk_surfaceprops_new(
      flags,
      geometry,
    );
  }

  late final _sk_surfaceprops_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Uint32, ffi.Int32)>>('sk_surfaceprops_new');
  late final _sk_surfaceprops_new =
      _sk_surfaceprops_newPtr.asFunction<ffi.Pointer<ffi.Void> Function(int, int)>();

  /// sk_canvas_t sk_svgcanvas_create_with_stream(SKRect* bounds, sk_wstream_t stream)
  ffi.Pointer<ffi.Void> sk_svgcanvas_create_with_stream(
    ffi.Pointer<ffi.Void> bounds,
    ffi.Pointer<ffi.Void> stream,
  ) {
    return _sk_svgcanvas_create_with_stream(
      bounds,
      stream,
    );
  }

  late final _sk_svgcanvas_create_with_streamPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_svgcanvas_create_with_stream');
  late final _sk_svgcanvas_create_with_stream =
      _sk_svgcanvas_create_with_streamPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_textblob_builder_alloc_run(sk_textblob_builder_t builder, sk_font_t font, Int32 count, Single x, Single y, SKRect* bounds, SKRunBufferInternal* runbuffer)
  void sk_textblob_builder_alloc_run(
    ffi.Pointer<ffi.Void> builder,
    ffi.Pointer<ffi.Void> font,
    int count,
    double x,
    double y,
    ffi.Pointer<ffi.Void> bounds,
    ffi.Pointer<ffi.Void> runbuffer,
  ) {
    return _sk_textblob_builder_alloc_run(
      builder,
      font,
      count,
      x,
      y,
      bounds,
      runbuffer,
    );
  }

  late final _sk_textblob_builder_alloc_runPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Float, ffi.Float, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_textblob_builder_alloc_run');
  late final _sk_textblob_builder_alloc_run =
      _sk_textblob_builder_alloc_runPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, double, double, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_textblob_builder_alloc_run_pos(sk_textblob_builder_t builder, sk_font_t font, Int32 count, SKRect* bounds, SKRunBufferInternal* runbuffer)
  void sk_textblob_builder_alloc_run_pos(
    ffi.Pointer<ffi.Void> builder,
    ffi.Pointer<ffi.Void> font,
    int count,
    ffi.Pointer<ffi.Void> bounds,
    ffi.Pointer<ffi.Void> runbuffer,
  ) {
    return _sk_textblob_builder_alloc_run_pos(
      builder,
      font,
      count,
      bounds,
      runbuffer,
    );
  }

  late final _sk_textblob_builder_alloc_run_posPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_textblob_builder_alloc_run_pos');
  late final _sk_textblob_builder_alloc_run_pos =
      _sk_textblob_builder_alloc_run_posPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_textblob_builder_alloc_run_pos_h(sk_textblob_builder_t builder, sk_font_t font, Int32 count, Single y, SKRect* bounds, SKRunBufferInternal* runbuffer)
  void sk_textblob_builder_alloc_run_pos_h(
    ffi.Pointer<ffi.Void> builder,
    ffi.Pointer<ffi.Void> font,
    int count,
    double y,
    ffi.Pointer<ffi.Void> bounds,
    ffi.Pointer<ffi.Void> runbuffer,
  ) {
    return _sk_textblob_builder_alloc_run_pos_h(
      builder,
      font,
      count,
      y,
      bounds,
      runbuffer,
    );
  }

  late final _sk_textblob_builder_alloc_run_pos_hPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Float, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_textblob_builder_alloc_run_pos_h');
  late final _sk_textblob_builder_alloc_run_pos_h =
      _sk_textblob_builder_alloc_run_pos_hPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, double, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_textblob_builder_alloc_run_rsxform(sk_textblob_builder_t builder, sk_font_t font, Int32 count, SKRect* bounds, SKRunBufferInternal* runbuffer)
  void sk_textblob_builder_alloc_run_rsxform(
    ffi.Pointer<ffi.Void> builder,
    ffi.Pointer<ffi.Void> font,
    int count,
    ffi.Pointer<ffi.Void> bounds,
    ffi.Pointer<ffi.Void> runbuffer,
  ) {
    return _sk_textblob_builder_alloc_run_rsxform(
      builder,
      font,
      count,
      bounds,
      runbuffer,
    );
  }

  late final _sk_textblob_builder_alloc_run_rsxformPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_textblob_builder_alloc_run_rsxform');
  late final _sk_textblob_builder_alloc_run_rsxform =
      _sk_textblob_builder_alloc_run_rsxformPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_textblob_builder_alloc_run_text(sk_textblob_builder_t builder, sk_font_t font, Int32 count, Single x, Single y, Int32 textByteCount, SKRect* bounds, SKRunBufferInternal* runbuffer)
  void sk_textblob_builder_alloc_run_text(
    ffi.Pointer<ffi.Void> builder,
    ffi.Pointer<ffi.Void> font,
    int count,
    double x,
    double y,
    int textByteCount,
    ffi.Pointer<ffi.Void> bounds,
    ffi.Pointer<ffi.Void> runbuffer,
  ) {
    return _sk_textblob_builder_alloc_run_text(
      builder,
      font,
      count,
      x,
      y,
      textByteCount,
      bounds,
      runbuffer,
    );
  }

  late final _sk_textblob_builder_alloc_run_textPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Float, ffi.Float, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_textblob_builder_alloc_run_text');
  late final _sk_textblob_builder_alloc_run_text =
      _sk_textblob_builder_alloc_run_textPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, double, double, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_textblob_builder_alloc_run_text_pos(sk_textblob_builder_t builder, sk_font_t font, Int32 count, Int32 textByteCount, SKRect* bounds, SKRunBufferInternal* runbuffer)
  void sk_textblob_builder_alloc_run_text_pos(
    ffi.Pointer<ffi.Void> builder,
    ffi.Pointer<ffi.Void> font,
    int count,
    int textByteCount,
    ffi.Pointer<ffi.Void> bounds,
    ffi.Pointer<ffi.Void> runbuffer,
  ) {
    return _sk_textblob_builder_alloc_run_text_pos(
      builder,
      font,
      count,
      textByteCount,
      bounds,
      runbuffer,
    );
  }

  late final _sk_textblob_builder_alloc_run_text_posPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_textblob_builder_alloc_run_text_pos');
  late final _sk_textblob_builder_alloc_run_text_pos =
      _sk_textblob_builder_alloc_run_text_posPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_textblob_builder_alloc_run_text_pos_h(sk_textblob_builder_t builder, sk_font_t font, Int32 count, Single y, Int32 textByteCount, SKRect* bounds, SKRunBufferInternal* runbuffer)
  void sk_textblob_builder_alloc_run_text_pos_h(
    ffi.Pointer<ffi.Void> builder,
    ffi.Pointer<ffi.Void> font,
    int count,
    double y,
    int textByteCount,
    ffi.Pointer<ffi.Void> bounds,
    ffi.Pointer<ffi.Void> runbuffer,
  ) {
    return _sk_textblob_builder_alloc_run_text_pos_h(
      builder,
      font,
      count,
      y,
      textByteCount,
      bounds,
      runbuffer,
    );
  }

  late final _sk_textblob_builder_alloc_run_text_pos_hPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Float, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_textblob_builder_alloc_run_text_pos_h');
  late final _sk_textblob_builder_alloc_run_text_pos_h =
      _sk_textblob_builder_alloc_run_text_pos_hPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, double, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_textblob_builder_alloc_run_text_rsxform(sk_textblob_builder_t builder, sk_font_t font, Int32 count, Int32 textByteCount, SKRect* bounds, SKRunBufferInternal* runbuffer)
  void sk_textblob_builder_alloc_run_text_rsxform(
    ffi.Pointer<ffi.Void> builder,
    ffi.Pointer<ffi.Void> font,
    int count,
    int textByteCount,
    ffi.Pointer<ffi.Void> bounds,
    ffi.Pointer<ffi.Void> runbuffer,
  ) {
    return _sk_textblob_builder_alloc_run_text_rsxform(
      builder,
      font,
      count,
      textByteCount,
      bounds,
      runbuffer,
    );
  }

  late final _sk_textblob_builder_alloc_run_text_rsxformPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_textblob_builder_alloc_run_text_rsxform');
  late final _sk_textblob_builder_alloc_run_text_rsxform =
      _sk_textblob_builder_alloc_run_text_rsxformPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_textblob_builder_delete(sk_textblob_builder_t builder)
  void sk_textblob_builder_delete(
    ffi.Pointer<ffi.Void> builder,
  ) {
    return _sk_textblob_builder_delete(
      builder,
    );
  }

  late final _sk_textblob_builder_deletePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_textblob_builder_delete');
  late final _sk_textblob_builder_delete =
      _sk_textblob_builder_deletePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// sk_textblob_t sk_textblob_builder_make(sk_textblob_builder_t builder)
  ffi.Pointer<ffi.Void> sk_textblob_builder_make(
    ffi.Pointer<ffi.Void> builder,
  ) {
    return _sk_textblob_builder_make(
      builder,
    );
  }

  late final _sk_textblob_builder_makePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_textblob_builder_make');
  late final _sk_textblob_builder_make =
      _sk_textblob_builder_makePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_textblob_builder_t sk_textblob_builder_new()
  ffi.Pointer<ffi.Void> sk_textblob_builder_new() {
    return _sk_textblob_builder_new();
  }

  late final _sk_textblob_builder_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_textblob_builder_new');
  late final _sk_textblob_builder_new =
      _sk_textblob_builder_newPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// void sk_textblob_get_bounds(sk_textblob_t blob, SKRect* bounds)
  void sk_textblob_get_bounds(
    ffi.Pointer<ffi.Void> blob,
    ffi.Pointer<ffi.Void> bounds,
  ) {
    return _sk_textblob_get_bounds(
      blob,
      bounds,
    );
  }

  late final _sk_textblob_get_boundsPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_textblob_get_bounds');
  late final _sk_textblob_get_bounds =
      _sk_textblob_get_boundsPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_textblob_get_intercepts(sk_textblob_t blob, Single* bounds, Single* intervals, sk_paint_t paint)
  int sk_textblob_get_intercepts(
    ffi.Pointer<ffi.Void> blob,
    ffi.Pointer<ffi.Float> bounds,
    ffi.Pointer<ffi.Float> intervals,
    ffi.Pointer<ffi.Void> paint,
  ) {
    return _sk_textblob_get_intercepts(
      blob,
      bounds,
      intervals,
      paint,
    );
  }

  late final _sk_textblob_get_interceptsPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Float>, ffi.Pointer<ffi.Float>, ffi.Pointer<ffi.Void>)>>('sk_textblob_get_intercepts');
  late final _sk_textblob_get_intercepts =
      _sk_textblob_get_interceptsPtr.asFunction<int Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Float>, ffi.Pointer<ffi.Float>, ffi.Pointer<ffi.Void>)>();

  /// UInt32 sk_textblob_get_unique_id(sk_textblob_t blob)
  int sk_textblob_get_unique_id(
    ffi.Pointer<ffi.Void> blob,
  ) {
    return _sk_textblob_get_unique_id(
      blob,
    );
  }

  late final _sk_textblob_get_unique_idPtr = _lookup<
      ffi.NativeFunction<ffi.Uint32 Function(ffi.Pointer<ffi.Void>)>>('sk_textblob_get_unique_id');
  late final _sk_textblob_get_unique_id =
      _sk_textblob_get_unique_idPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_textblob_ref(sk_textblob_t blob)
  void sk_textblob_ref(
    ffi.Pointer<ffi.Void> blob,
  ) {
    return _sk_textblob_ref(
      blob,
    );
  }

  late final _sk_textblob_refPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_textblob_ref');
  late final _sk_textblob_ref =
      _sk_textblob_refPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_textblob_unref(sk_textblob_t blob)
  void sk_textblob_unref(
    ffi.Pointer<ffi.Void> blob,
  ) {
    return _sk_textblob_unref(
      blob,
    );
  }

  late final _sk_textblob_unrefPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_textblob_unref');
  late final _sk_textblob_unref =
      _sk_textblob_unrefPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_fontmgr_count_families(sk_fontmgr_t param0)
  int sk_fontmgr_count_families(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_fontmgr_count_families(
      param0,
    );
  }

  late final _sk_fontmgr_count_familiesPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_fontmgr_count_families');
  late final _sk_fontmgr_count_families =
      _sk_fontmgr_count_familiesPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// sk_fontmgr_t sk_fontmgr_create_default()
  ffi.Pointer<ffi.Void> sk_fontmgr_create_default() {
    return _sk_fontmgr_create_default();
  }

  late final _sk_fontmgr_create_defaultPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_fontmgr_create_default');
  late final _sk_fontmgr_create_default =
      _sk_fontmgr_create_defaultPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// sk_typeface_t sk_fontmgr_create_from_data(sk_fontmgr_t param0, sk_data_t data, Int32 index)
  ffi.Pointer<ffi.Void> sk_fontmgr_create_from_data(
    ffi.Pointer<ffi.Void> param0,
    ffi.Pointer<ffi.Void> data,
    int index,
  ) {
    return _sk_fontmgr_create_from_data(
      param0,
      data,
      index,
    );
  }

  late final _sk_fontmgr_create_from_dataPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_fontmgr_create_from_data');
  late final _sk_fontmgr_create_from_data =
      _sk_fontmgr_create_from_dataPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int)>();

  /// sk_typeface_t sk_fontmgr_create_from_file(sk_fontmgr_t param0, void* path, Int32 index)
  ffi.Pointer<ffi.Void> sk_fontmgr_create_from_file(
    ffi.Pointer<ffi.Void> param0,
    ffi.Pointer<ffi.Void> path,
    int index,
  ) {
    return _sk_fontmgr_create_from_file(
      param0,
      path,
      index,
    );
  }

  late final _sk_fontmgr_create_from_filePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_fontmgr_create_from_file');
  late final _sk_fontmgr_create_from_file =
      _sk_fontmgr_create_from_filePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int)>();

  /// sk_typeface_t sk_fontmgr_create_from_stream(sk_fontmgr_t param0, sk_stream_asset_t stream, Int32 index)
  ffi.Pointer<ffi.Void> sk_fontmgr_create_from_stream(
    ffi.Pointer<ffi.Void> param0,
    ffi.Pointer<ffi.Void> stream,
    int index,
  ) {
    return _sk_fontmgr_create_from_stream(
      param0,
      stream,
      index,
    );
  }

  late final _sk_fontmgr_create_from_streamPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_fontmgr_create_from_stream');
  late final _sk_fontmgr_create_from_stream =
      _sk_fontmgr_create_from_streamPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int)>();

  /// sk_fontstyleset_t sk_fontmgr_create_styleset(sk_fontmgr_t param0, Int32 index)
  ffi.Pointer<ffi.Void> sk_fontmgr_create_styleset(
    ffi.Pointer<ffi.Void> param0,
    int index,
  ) {
    return _sk_fontmgr_create_styleset(
      param0,
      index,
    );
  }

  late final _sk_fontmgr_create_stylesetPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_fontmgr_create_styleset');
  late final _sk_fontmgr_create_styleset =
      _sk_fontmgr_create_stylesetPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, int)>();

  /// void sk_fontmgr_get_family_name(sk_fontmgr_t param0, Int32 index, sk_string_t familyName)
  void sk_fontmgr_get_family_name(
    ffi.Pointer<ffi.Void> param0,
    int index,
    ffi.Pointer<ffi.Void> familyName,
  ) {
    return _sk_fontmgr_get_family_name(
      param0,
      index,
      familyName,
    );
  }

  late final _sk_fontmgr_get_family_namePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Pointer<ffi.Void>)>>('sk_fontmgr_get_family_name');
  late final _sk_fontmgr_get_family_name =
      _sk_fontmgr_get_family_namePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>)>();

  /// sk_fontstyleset_t sk_fontmgr_match_family(sk_fontmgr_t param0, IntPtr familyName)
  ffi.Pointer<ffi.Void> sk_fontmgr_match_family(
    ffi.Pointer<ffi.Void> param0,
    ffi.Pointer<ffi.Void> familyName,
  ) {
    return _sk_fontmgr_match_family(
      param0,
      familyName,
    );
  }

  late final _sk_fontmgr_match_familyPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_fontmgr_match_family');
  late final _sk_fontmgr_match_family =
      _sk_fontmgr_match_familyPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_typeface_t sk_fontmgr_match_family_style(sk_fontmgr_t param0, IntPtr familyName, sk_fontstyle_t style)
  ffi.Pointer<ffi.Void> sk_fontmgr_match_family_style(
    ffi.Pointer<ffi.Void> param0,
    ffi.Pointer<ffi.Void> familyName,
    ffi.Pointer<ffi.Void> style,
  ) {
    return _sk_fontmgr_match_family_style(
      param0,
      familyName,
      style,
    );
  }

  late final _sk_fontmgr_match_family_stylePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_fontmgr_match_family_style');
  late final _sk_fontmgr_match_family_style =
      _sk_fontmgr_match_family_stylePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_typeface_t sk_fontmgr_match_family_style_character(sk_fontmgr_t param0, IntPtr familyName, sk_fontstyle_t style, String[] bcp47, Int32 bcp47Count, Int32 character)
  ffi.Pointer<ffi.Void> sk_fontmgr_match_family_style_character(
    ffi.Pointer<ffi.Void> param0,
    ffi.Pointer<ffi.Void> familyName,
    ffi.Pointer<ffi.Void> style,
    ffi.Pointer<ffi.Void> bcp47,
    int bcp47Count,
    int character,
  ) {
    return _sk_fontmgr_match_family_style_character(
      param0,
      familyName,
      style,
      bcp47,
      bcp47Count,
      character,
    );
  }

  late final _sk_fontmgr_match_family_style_characterPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32)>>('sk_fontmgr_match_family_style_character');
  late final _sk_fontmgr_match_family_style_character =
      _sk_fontmgr_match_family_style_characterPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int, int)>();

  /// sk_fontmgr_t sk_fontmgr_ref_default()
  ffi.Pointer<ffi.Void> sk_fontmgr_ref_default() {
    return _sk_fontmgr_ref_default();
  }

  late final _sk_fontmgr_ref_defaultPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_fontmgr_ref_default');
  late final _sk_fontmgr_ref_default =
      _sk_fontmgr_ref_defaultPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// void sk_fontmgr_unref(sk_fontmgr_t param0)
  void sk_fontmgr_unref(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_fontmgr_unref(
      param0,
    );
  }

  late final _sk_fontmgr_unrefPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_fontmgr_unref');
  late final _sk_fontmgr_unref =
      _sk_fontmgr_unrefPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_fontstyle_delete(sk_fontstyle_t fs)
  void sk_fontstyle_delete(
    ffi.Pointer<ffi.Void> fs,
  ) {
    return _sk_fontstyle_delete(
      fs,
    );
  }

  late final _sk_fontstyle_deletePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_fontstyle_delete');
  late final _sk_fontstyle_delete =
      _sk_fontstyle_deletePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// SKFontStyleSlant sk_fontstyle_get_slant(sk_fontstyle_t fs)
  int sk_fontstyle_get_slant(
    ffi.Pointer<ffi.Void> fs,
  ) {
    return _sk_fontstyle_get_slant(
      fs,
    );
  }

  late final _sk_fontstyle_get_slantPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_fontstyle_get_slant');
  late final _sk_fontstyle_get_slant =
      _sk_fontstyle_get_slantPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_fontstyle_get_weight(sk_fontstyle_t fs)
  int sk_fontstyle_get_weight(
    ffi.Pointer<ffi.Void> fs,
  ) {
    return _sk_fontstyle_get_weight(
      fs,
    );
  }

  late final _sk_fontstyle_get_weightPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_fontstyle_get_weight');
  late final _sk_fontstyle_get_weight =
      _sk_fontstyle_get_weightPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_fontstyle_get_width(sk_fontstyle_t fs)
  int sk_fontstyle_get_width(
    ffi.Pointer<ffi.Void> fs,
  ) {
    return _sk_fontstyle_get_width(
      fs,
    );
  }

  late final _sk_fontstyle_get_widthPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_fontstyle_get_width');
  late final _sk_fontstyle_get_width =
      _sk_fontstyle_get_widthPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// sk_fontstyle_t sk_fontstyle_new(Int32 weight, Int32 width, SKFontStyleSlant slant)
  ffi.Pointer<ffi.Void> sk_fontstyle_new(
    int weight,
    int width,
    int slant,
  ) {
    return _sk_fontstyle_new(
      weight,
      width,
      slant,
    );
  }

  late final _sk_fontstyle_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Int32, ffi.Int32, ffi.Int32)>>('sk_fontstyle_new');
  late final _sk_fontstyle_new =
      _sk_fontstyle_newPtr.asFunction<ffi.Pointer<ffi.Void> Function(int, int, int)>();

  /// sk_fontstyleset_t sk_fontstyleset_create_empty()
  ffi.Pointer<ffi.Void> sk_fontstyleset_create_empty() {
    return _sk_fontstyleset_create_empty();
  }

  late final _sk_fontstyleset_create_emptyPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_fontstyleset_create_empty');
  late final _sk_fontstyleset_create_empty =
      _sk_fontstyleset_create_emptyPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// sk_typeface_t sk_fontstyleset_create_typeface(sk_fontstyleset_t fss, Int32 index)
  ffi.Pointer<ffi.Void> sk_fontstyleset_create_typeface(
    ffi.Pointer<ffi.Void> fss,
    int index,
  ) {
    return _sk_fontstyleset_create_typeface(
      fss,
      index,
    );
  }

  late final _sk_fontstyleset_create_typefacePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_fontstyleset_create_typeface');
  late final _sk_fontstyleset_create_typeface =
      _sk_fontstyleset_create_typefacePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, int)>();

  /// Int32 sk_fontstyleset_get_count(sk_fontstyleset_t fss)
  int sk_fontstyleset_get_count(
    ffi.Pointer<ffi.Void> fss,
  ) {
    return _sk_fontstyleset_get_count(
      fss,
    );
  }

  late final _sk_fontstyleset_get_countPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_fontstyleset_get_count');
  late final _sk_fontstyleset_get_count =
      _sk_fontstyleset_get_countPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_fontstyleset_get_style(sk_fontstyleset_t fss, Int32 index, sk_fontstyle_t fs, sk_string_t style)
  void sk_fontstyleset_get_style(
    ffi.Pointer<ffi.Void> fss,
    int index,
    ffi.Pointer<ffi.Void> fs,
    ffi.Pointer<ffi.Void> style,
  ) {
    return _sk_fontstyleset_get_style(
      fss,
      index,
      fs,
      style,
    );
  }

  late final _sk_fontstyleset_get_stylePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_fontstyleset_get_style');
  late final _sk_fontstyleset_get_style =
      _sk_fontstyleset_get_stylePtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_typeface_t sk_fontstyleset_match_style(sk_fontstyleset_t fss, sk_fontstyle_t style)
  ffi.Pointer<ffi.Void> sk_fontstyleset_match_style(
    ffi.Pointer<ffi.Void> fss,
    ffi.Pointer<ffi.Void> style,
  ) {
    return _sk_fontstyleset_match_style(
      fss,
      style,
    );
  }

  late final _sk_fontstyleset_match_stylePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_fontstyleset_match_style');
  late final _sk_fontstyleset_match_style =
      _sk_fontstyleset_match_stylePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// void sk_fontstyleset_unref(sk_fontstyleset_t fss)
  void sk_fontstyleset_unref(
    ffi.Pointer<ffi.Void> fss,
  ) {
    return _sk_fontstyleset_unref(
      fss,
    );
  }

  late final _sk_fontstyleset_unrefPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_fontstyleset_unref');
  late final _sk_fontstyleset_unref =
      _sk_fontstyleset_unrefPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// sk_data_t sk_typeface_copy_table_data(sk_typeface_t typeface, UInt32 tag)
  ffi.Pointer<ffi.Void> sk_typeface_copy_table_data(
    ffi.Pointer<ffi.Void> typeface,
    int tag,
  ) {
    return _sk_typeface_copy_table_data(
      typeface,
      tag,
    );
  }

  late final _sk_typeface_copy_table_dataPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Uint32)>>('sk_typeface_copy_table_data');
  late final _sk_typeface_copy_table_data =
      _sk_typeface_copy_table_dataPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, int)>();

  /// Int32 sk_typeface_count_glyphs(sk_typeface_t typeface)
  int sk_typeface_count_glyphs(
    ffi.Pointer<ffi.Void> typeface,
  ) {
    return _sk_typeface_count_glyphs(
      typeface,
    );
  }

  late final _sk_typeface_count_glyphsPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_typeface_count_glyphs');
  late final _sk_typeface_count_glyphs =
      _sk_typeface_count_glyphsPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_typeface_count_tables(sk_typeface_t typeface)
  int sk_typeface_count_tables(
    ffi.Pointer<ffi.Void> typeface,
  ) {
    return _sk_typeface_count_tables(
      typeface,
    );
  }

  late final _sk_typeface_count_tablesPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_typeface_count_tables');
  late final _sk_typeface_count_tables =
      _sk_typeface_count_tablesPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// sk_typeface_t sk_typeface_create_default()
  ffi.Pointer<ffi.Void> sk_typeface_create_default() {
    return _sk_typeface_create_default();
  }

  late final _sk_typeface_create_defaultPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_typeface_create_default');
  late final _sk_typeface_create_default =
      _sk_typeface_create_defaultPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// sk_typeface_t sk_typeface_create_from_data(sk_data_t data, Int32 index)
  ffi.Pointer<ffi.Void> sk_typeface_create_from_data(
    ffi.Pointer<ffi.Void> data,
    int index,
  ) {
    return _sk_typeface_create_from_data(
      data,
      index,
    );
  }

  late final _sk_typeface_create_from_dataPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_typeface_create_from_data');
  late final _sk_typeface_create_from_data =
      _sk_typeface_create_from_dataPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, int)>();

  /// sk_typeface_t sk_typeface_create_from_file(void* path, Int32 index)
  ffi.Pointer<ffi.Void> sk_typeface_create_from_file(
    ffi.Pointer<ffi.Void> path,
    int index,
  ) {
    return _sk_typeface_create_from_file(
      path,
      index,
    );
  }

  late final _sk_typeface_create_from_filePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_typeface_create_from_file');
  late final _sk_typeface_create_from_file =
      _sk_typeface_create_from_filePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, int)>();

  /// sk_typeface_t sk_typeface_create_from_name(IntPtr familyName, sk_fontstyle_t style)
  ffi.Pointer<ffi.Void> sk_typeface_create_from_name(
    ffi.Pointer<ffi.Void> familyName,
    ffi.Pointer<ffi.Void> style,
  ) {
    return _sk_typeface_create_from_name(
      familyName,
      style,
    );
  }

  late final _sk_typeface_create_from_namePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_typeface_create_from_name');
  late final _sk_typeface_create_from_name =
      _sk_typeface_create_from_namePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// sk_typeface_t sk_typeface_create_from_stream(sk_stream_asset_t stream, Int32 index)
  ffi.Pointer<ffi.Void> sk_typeface_create_from_stream(
    ffi.Pointer<ffi.Void> stream,
    int index,
  ) {
    return _sk_typeface_create_from_stream(
      stream,
      index,
    );
  }

  late final _sk_typeface_create_from_streamPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_typeface_create_from_stream');
  late final _sk_typeface_create_from_stream =
      _sk_typeface_create_from_streamPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, int)>();

  /// sk_string_t sk_typeface_get_family_name(sk_typeface_t typeface)
  ffi.Pointer<ffi.Void> sk_typeface_get_family_name(
    ffi.Pointer<ffi.Void> typeface,
  ) {
    return _sk_typeface_get_family_name(
      typeface,
    );
  }

  late final _sk_typeface_get_family_namePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_typeface_get_family_name');
  late final _sk_typeface_get_family_name =
      _sk_typeface_get_family_namePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// SKFontStyleSlant sk_typeface_get_font_slant(sk_typeface_t typeface)
  int sk_typeface_get_font_slant(
    ffi.Pointer<ffi.Void> typeface,
  ) {
    return _sk_typeface_get_font_slant(
      typeface,
    );
  }

  late final _sk_typeface_get_font_slantPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_typeface_get_font_slant');
  late final _sk_typeface_get_font_slant =
      _sk_typeface_get_font_slantPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_typeface_get_font_weight(sk_typeface_t typeface)
  int sk_typeface_get_font_weight(
    ffi.Pointer<ffi.Void> typeface,
  ) {
    return _sk_typeface_get_font_weight(
      typeface,
    );
  }

  late final _sk_typeface_get_font_weightPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_typeface_get_font_weight');
  late final _sk_typeface_get_font_weight =
      _sk_typeface_get_font_weightPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_typeface_get_font_width(sk_typeface_t typeface)
  int sk_typeface_get_font_width(
    ffi.Pointer<ffi.Void> typeface,
  ) {
    return _sk_typeface_get_font_width(
      typeface,
    );
  }

  late final _sk_typeface_get_font_widthPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_typeface_get_font_width');
  late final _sk_typeface_get_font_width =
      _sk_typeface_get_font_widthPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// sk_fontstyle_t sk_typeface_get_fontstyle(sk_typeface_t typeface)
  ffi.Pointer<ffi.Void> sk_typeface_get_fontstyle(
    ffi.Pointer<ffi.Void> typeface,
  ) {
    return _sk_typeface_get_fontstyle(
      typeface,
    );
  }

  late final _sk_typeface_get_fontstylePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_typeface_get_fontstyle');
  late final _sk_typeface_get_fontstyle =
      _sk_typeface_get_fontstylePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_typeface_get_kerning_pair_adjustments(sk_typeface_t typeface, UInt16* glyphs, Int32 count, Int32* adjustments)
  bool sk_typeface_get_kerning_pair_adjustments(
    ffi.Pointer<ffi.Void> typeface,
    ffi.Pointer<ffi.Uint16> glyphs,
    int count,
    ffi.Pointer<ffi.Int32> adjustments,
  ) {
    return _sk_typeface_get_kerning_pair_adjustments(
      typeface,
      glyphs,
      count,
      adjustments,
    );
  }

  late final _sk_typeface_get_kerning_pair_adjustmentsPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint16>, ffi.Int32, ffi.Pointer<ffi.Int32>)>>('sk_typeface_get_kerning_pair_adjustments');
  late final _sk_typeface_get_kerning_pair_adjustments =
      _sk_typeface_get_kerning_pair_adjustmentsPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint16>, int, ffi.Pointer<ffi.Int32>)>();

  /// sk_string_t sk_typeface_get_post_script_name(sk_typeface_t typeface)
  ffi.Pointer<ffi.Void> sk_typeface_get_post_script_name(
    ffi.Pointer<ffi.Void> typeface,
  ) {
    return _sk_typeface_get_post_script_name(
      typeface,
    );
  }

  late final _sk_typeface_get_post_script_namePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_typeface_get_post_script_name');
  late final _sk_typeface_get_post_script_name =
      _sk_typeface_get_post_script_namePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// IntPtr sk_typeface_get_table_data(sk_typeface_t typeface, UInt32 tag, IntPtr offset, IntPtr length, void* data)
  ffi.Pointer<ffi.Void> sk_typeface_get_table_data(
    ffi.Pointer<ffi.Void> typeface,
    int tag,
    ffi.Pointer<ffi.Void> offset,
    ffi.Pointer<ffi.Void> length,
    ffi.Pointer<ffi.Void> data,
  ) {
    return _sk_typeface_get_table_data(
      typeface,
      tag,
      offset,
      length,
      data,
    );
  }

  late final _sk_typeface_get_table_dataPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Uint32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>('sk_typeface_get_table_data');
  late final _sk_typeface_get_table_data =
      _sk_typeface_get_table_dataPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// IntPtr sk_typeface_get_table_size(sk_typeface_t typeface, UInt32 tag)
  ffi.Pointer<ffi.Void> sk_typeface_get_table_size(
    ffi.Pointer<ffi.Void> typeface,
    int tag,
  ) {
    return _sk_typeface_get_table_size(
      typeface,
      tag,
    );
  }

  late final _sk_typeface_get_table_sizePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Uint32)>>('sk_typeface_get_table_size');
  late final _sk_typeface_get_table_size =
      _sk_typeface_get_table_sizePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, int)>();

  /// Int32 sk_typeface_get_table_tags(sk_typeface_t typeface, UInt32* tags)
  int sk_typeface_get_table_tags(
    ffi.Pointer<ffi.Void> typeface,
    ffi.Pointer<ffi.Uint32> tags,
  ) {
    return _sk_typeface_get_table_tags(
      typeface,
      tags,
    );
  }

  late final _sk_typeface_get_table_tagsPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint32>)>>('sk_typeface_get_table_tags');
  late final _sk_typeface_get_table_tags =
      _sk_typeface_get_table_tagsPtr.asFunction<int Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint32>)>();

  /// Int32 sk_typeface_get_units_per_em(sk_typeface_t typeface)
  int sk_typeface_get_units_per_em(
    ffi.Pointer<ffi.Void> typeface,
  ) {
    return _sk_typeface_get_units_per_em(
      typeface,
    );
  }

  late final _sk_typeface_get_units_per_emPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_typeface_get_units_per_em');
  late final _sk_typeface_get_units_per_em =
      _sk_typeface_get_units_per_emPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_typeface_is_fixed_pitch(sk_typeface_t typeface)
  bool sk_typeface_is_fixed_pitch(
    ffi.Pointer<ffi.Void> typeface,
  ) {
    return _sk_typeface_is_fixed_pitch(
      typeface,
    );
  }

  late final _sk_typeface_is_fixed_pitchPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_typeface_is_fixed_pitch');
  late final _sk_typeface_is_fixed_pitch =
      _sk_typeface_is_fixed_pitchPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// sk_stream_asset_t sk_typeface_open_stream(sk_typeface_t typeface, Int32* ttcIndex)
  ffi.Pointer<ffi.Void> sk_typeface_open_stream(
    ffi.Pointer<ffi.Void> typeface,
    ffi.Pointer<ffi.Int32> ttcIndex,
  ) {
    return _sk_typeface_open_stream(
      typeface,
      ttcIndex,
    );
  }

  late final _sk_typeface_open_streamPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Int32>)>>('sk_typeface_open_stream');
  late final _sk_typeface_open_stream =
      _sk_typeface_open_streamPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Int32>)>();

  /// sk_typeface_t sk_typeface_ref_default()
  ffi.Pointer<ffi.Void> sk_typeface_ref_default() {
    return _sk_typeface_ref_default();
  }

  late final _sk_typeface_ref_defaultPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_typeface_ref_default');
  late final _sk_typeface_ref_default =
      _sk_typeface_ref_defaultPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// UInt16 sk_typeface_unichar_to_glyph(sk_typeface_t typeface, Int32 unichar)
  int sk_typeface_unichar_to_glyph(
    ffi.Pointer<ffi.Void> typeface,
    int unichar,
  ) {
    return _sk_typeface_unichar_to_glyph(
      typeface,
      unichar,
    );
  }

  late final _sk_typeface_unichar_to_glyphPtr = _lookup<
      ffi.NativeFunction<ffi.Uint16 Function(ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_typeface_unichar_to_glyph');
  late final _sk_typeface_unichar_to_glyph =
      _sk_typeface_unichar_to_glyphPtr.asFunction<int Function(ffi.Pointer<ffi.Void>, int)>();

  /// void sk_typeface_unichars_to_glyphs(sk_typeface_t typeface, Int32* unichars, Int32 count, UInt16* glyphs)
  void sk_typeface_unichars_to_glyphs(
    ffi.Pointer<ffi.Void> typeface,
    ffi.Pointer<ffi.Int32> unichars,
    int count,
    ffi.Pointer<ffi.Uint16> glyphs,
  ) {
    return _sk_typeface_unichars_to_glyphs(
      typeface,
      unichars,
      count,
      glyphs,
    );
  }

  late final _sk_typeface_unichars_to_glyphsPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Int32>, ffi.Int32, ffi.Pointer<ffi.Uint16>)>>('sk_typeface_unichars_to_glyphs');
  late final _sk_typeface_unichars_to_glyphs =
      _sk_typeface_unichars_to_glyphsPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Int32>, int, ffi.Pointer<ffi.Uint16>)>();

  /// void sk_typeface_unref(sk_typeface_t typeface)
  void sk_typeface_unref(
    ffi.Pointer<ffi.Void> typeface,
  ) {
    return _sk_typeface_unref(
      typeface,
    );
  }

  late final _sk_typeface_unrefPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_typeface_unref');
  late final _sk_typeface_unref =
      _sk_typeface_unrefPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// sk_vertices_t sk_vertices_make_copy(SKVertexMode vmode, Int32 vertexCount, SKPoint* positions, SKPoint* texs, UInt32* colors, Int32 indexCount, UInt16* indices)
  ffi.Pointer<ffi.Void> sk_vertices_make_copy(
    int vmode,
    int vertexCount,
    ffi.Pointer<ffi.Void> positions,
    ffi.Pointer<ffi.Void> texs,
    ffi.Pointer<ffi.Uint32> colors,
    int indexCount,
    ffi.Pointer<ffi.Uint16> indices,
  ) {
    return _sk_vertices_make_copy(
      vmode,
      vertexCount,
      positions,
      texs,
      colors,
      indexCount,
      indices,
    );
  }

  late final _sk_vertices_make_copyPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint32>, ffi.Int32, ffi.Pointer<ffi.Uint16>)>>('sk_vertices_make_copy');
  late final _sk_vertices_make_copy =
      _sk_vertices_make_copyPtr.asFunction<ffi.Pointer<ffi.Void> Function(int, int, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Uint32>, int, ffi.Pointer<ffi.Uint16>)>();

  /// void sk_vertices_ref(sk_vertices_t cvertices)
  void sk_vertices_ref(
    ffi.Pointer<ffi.Void> cvertices,
  ) {
    return _sk_vertices_ref(
      cvertices,
    );
  }

  late final _sk_vertices_refPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_vertices_ref');
  late final _sk_vertices_ref =
      _sk_vertices_refPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_vertices_unref(sk_vertices_t cvertices)
  void sk_vertices_unref(
    ffi.Pointer<ffi.Void> cvertices,
  ) {
    return _sk_vertices_unref(
      cvertices,
    );
  }

  late final _sk_vertices_unrefPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_vertices_unref');
  late final _sk_vertices_unref =
      _sk_vertices_unrefPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// sk_compatpaint_t sk_compatpaint_clone(sk_compatpaint_t paint)
  ffi.Pointer<ffi.Void> sk_compatpaint_clone(
    ffi.Pointer<ffi.Void> paint,
  ) {
    return _sk_compatpaint_clone(
      paint,
    );
  }

  late final _sk_compatpaint_clonePtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_compatpaint_clone');
  late final _sk_compatpaint_clone =
      _sk_compatpaint_clonePtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_compatpaint_delete(sk_compatpaint_t paint)
  void sk_compatpaint_delete(
    ffi.Pointer<ffi.Void> paint,
  ) {
    return _sk_compatpaint_delete(
      paint,
    );
  }

  late final _sk_compatpaint_deletePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_compatpaint_delete');
  late final _sk_compatpaint_delete =
      _sk_compatpaint_deletePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// Int32 sk_compatpaint_get_filter_quality(sk_compatpaint_t paint)
  int sk_compatpaint_get_filter_quality(
    ffi.Pointer<ffi.Void> paint,
  ) {
    return _sk_compatpaint_get_filter_quality(
      paint,
    );
  }

  late final _sk_compatpaint_get_filter_qualityPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_compatpaint_get_filter_quality');
  late final _sk_compatpaint_get_filter_quality =
      _sk_compatpaint_get_filter_qualityPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// sk_font_t sk_compatpaint_get_font(sk_compatpaint_t paint)
  ffi.Pointer<ffi.Void> sk_compatpaint_get_font(
    ffi.Pointer<ffi.Void> paint,
  ) {
    return _sk_compatpaint_get_font(
      paint,
    );
  }

  late final _sk_compatpaint_get_fontPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_compatpaint_get_font');
  late final _sk_compatpaint_get_font =
      _sk_compatpaint_get_fontPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// bool sk_compatpaint_get_lcd_render_text(sk_compatpaint_t paint)
  bool sk_compatpaint_get_lcd_render_text(
    ffi.Pointer<ffi.Void> paint,
  ) {
    return _sk_compatpaint_get_lcd_render_text(
      paint,
    );
  }

  late final _sk_compatpaint_get_lcd_render_textPtr = _lookup<
      ffi.NativeFunction<ffi.Bool Function(ffi.Pointer<ffi.Void>)>>('sk_compatpaint_get_lcd_render_text');
  late final _sk_compatpaint_get_lcd_render_text =
      _sk_compatpaint_get_lcd_render_textPtr.asFunction<bool Function(ffi.Pointer<ffi.Void>)>();

  /// SKTextAlign sk_compatpaint_get_text_align(sk_compatpaint_t paint)
  int sk_compatpaint_get_text_align(
    ffi.Pointer<ffi.Void> paint,
  ) {
    return _sk_compatpaint_get_text_align(
      paint,
    );
  }

  late final _sk_compatpaint_get_text_alignPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_compatpaint_get_text_align');
  late final _sk_compatpaint_get_text_align =
      _sk_compatpaint_get_text_alignPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// SKTextEncoding sk_compatpaint_get_text_encoding(sk_compatpaint_t paint)
  int sk_compatpaint_get_text_encoding(
    ffi.Pointer<ffi.Void> paint,
  ) {
    return _sk_compatpaint_get_text_encoding(
      paint,
    );
  }

  late final _sk_compatpaint_get_text_encodingPtr = _lookup<
      ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Void>)>>('sk_compatpaint_get_text_encoding');
  late final _sk_compatpaint_get_text_encoding =
      _sk_compatpaint_get_text_encodingPtr.asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  /// sk_font_t sk_compatpaint_make_font(sk_compatpaint_t paint)
  ffi.Pointer<ffi.Void> sk_compatpaint_make_font(
    ffi.Pointer<ffi.Void> paint,
  ) {
    return _sk_compatpaint_make_font(
      paint,
    );
  }

  late final _sk_compatpaint_make_fontPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_compatpaint_make_font');
  late final _sk_compatpaint_make_font =
      _sk_compatpaint_make_fontPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// sk_compatpaint_t sk_compatpaint_new()
  ffi.Pointer<ffi.Void> sk_compatpaint_new() {
    return _sk_compatpaint_new();
  }

  late final _sk_compatpaint_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>('sk_compatpaint_new');
  late final _sk_compatpaint_new =
      _sk_compatpaint_newPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  /// sk_compatpaint_t sk_compatpaint_new_with_font(sk_font_t font)
  ffi.Pointer<ffi.Void> sk_compatpaint_new_with_font(
    ffi.Pointer<ffi.Void> font,
  ) {
    return _sk_compatpaint_new_with_font(
      font,
    );
  }

  late final _sk_compatpaint_new_with_fontPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_compatpaint_new_with_font');
  late final _sk_compatpaint_new_with_font =
      _sk_compatpaint_new_with_fontPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_compatpaint_reset(sk_compatpaint_t paint)
  void sk_compatpaint_reset(
    ffi.Pointer<ffi.Void> paint,
  ) {
    return _sk_compatpaint_reset(
      paint,
    );
  }

  late final _sk_compatpaint_resetPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_compatpaint_reset');
  late final _sk_compatpaint_reset =
      _sk_compatpaint_resetPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_compatpaint_set_filter_quality(sk_compatpaint_t paint, Int32 quality)
  void sk_compatpaint_set_filter_quality(
    ffi.Pointer<ffi.Void> paint,
    int quality,
  ) {
    return _sk_compatpaint_set_filter_quality(
      paint,
      quality,
    );
  }

  late final _sk_compatpaint_set_filter_qualityPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_compatpaint_set_filter_quality');
  late final _sk_compatpaint_set_filter_quality =
      _sk_compatpaint_set_filter_qualityPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int)>();

  /// void sk_compatpaint_set_is_antialias(sk_compatpaint_t paint, bool antialias)
  void sk_compatpaint_set_is_antialias(
    ffi.Pointer<ffi.Void> paint,
    bool antialias,
  ) {
    return _sk_compatpaint_set_is_antialias(
      paint,
      antialias,
    );
  }

  late final _sk_compatpaint_set_is_antialiasPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Bool)>>('sk_compatpaint_set_is_antialias');
  late final _sk_compatpaint_set_is_antialias =
      _sk_compatpaint_set_is_antialiasPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, bool)>();

  /// void sk_compatpaint_set_lcd_render_text(sk_compatpaint_t paint, bool lcdRenderText)
  void sk_compatpaint_set_lcd_render_text(
    ffi.Pointer<ffi.Void> paint,
    bool lcdRenderText,
  ) {
    return _sk_compatpaint_set_lcd_render_text(
      paint,
      lcdRenderText,
    );
  }

  late final _sk_compatpaint_set_lcd_render_textPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Bool)>>('sk_compatpaint_set_lcd_render_text');
  late final _sk_compatpaint_set_lcd_render_text =
      _sk_compatpaint_set_lcd_render_textPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, bool)>();

  /// void sk_compatpaint_set_text_align(sk_compatpaint_t paint, SKTextAlign align)
  void sk_compatpaint_set_text_align(
    ffi.Pointer<ffi.Void> paint,
    int align,
  ) {
    return _sk_compatpaint_set_text_align(
      paint,
      align,
    );
  }

  late final _sk_compatpaint_set_text_alignPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_compatpaint_set_text_align');
  late final _sk_compatpaint_set_text_align =
      _sk_compatpaint_set_text_alignPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int)>();

  /// void sk_compatpaint_set_text_encoding(sk_compatpaint_t paint, SKTextEncoding encoding)
  void sk_compatpaint_set_text_encoding(
    ffi.Pointer<ffi.Void> paint,
    int encoding,
  ) {
    return _sk_compatpaint_set_text_encoding(
      paint,
      encoding,
    );
  }

  late final _sk_compatpaint_set_text_encodingPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>, ffi.Int32)>>('sk_compatpaint_set_text_encoding');
  late final _sk_compatpaint_set_text_encoding =
      _sk_compatpaint_set_text_encodingPtr.asFunction<void Function(ffi.Pointer<ffi.Void>, int)>();

  /// sk_manageddrawable_t sk_manageddrawable_new(void* context)
  ffi.Pointer<ffi.Void> sk_manageddrawable_new(
    ffi.Pointer<ffi.Void> context,
  ) {
    return _sk_manageddrawable_new(
      context,
    );
  }

  late final _sk_manageddrawable_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_manageddrawable_new');
  late final _sk_manageddrawable_new =
      _sk_manageddrawable_newPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_manageddrawable_set_procs(SKManagedDrawableDelegates procs)
  void sk_manageddrawable_set_procs(
    ffi.Pointer<ffi.NativeFunction<ffi.Void Function()>> procs,
  ) {
    return _sk_manageddrawable_set_procs(
      procs,
    );
  }

  late final _sk_manageddrawable_set_procsPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.NativeFunction<ffi.Void Function()>>)>>('sk_manageddrawable_set_procs');
  late final _sk_manageddrawable_set_procs =
      _sk_manageddrawable_set_procsPtr.asFunction<void Function(ffi.Pointer<ffi.NativeFunction<ffi.Void Function()>>)>();

  /// void sk_manageddrawable_unref(sk_manageddrawable_t param0)
  void sk_manageddrawable_unref(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_manageddrawable_unref(
      param0,
    );
  }

  late final _sk_manageddrawable_unrefPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_manageddrawable_unref');
  late final _sk_manageddrawable_unref =
      _sk_manageddrawable_unrefPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_managedstream_destroy(sk_stream_managedstream_t s)
  void sk_managedstream_destroy(
    ffi.Pointer<ffi.Void> s,
  ) {
    return _sk_managedstream_destroy(
      s,
    );
  }

  late final _sk_managedstream_destroyPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_managedstream_destroy');
  late final _sk_managedstream_destroy =
      _sk_managedstream_destroyPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// sk_stream_managedstream_t sk_managedstream_new(void* context)
  ffi.Pointer<ffi.Void> sk_managedstream_new(
    ffi.Pointer<ffi.Void> context,
  ) {
    return _sk_managedstream_new(
      context,
    );
  }

  late final _sk_managedstream_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_managedstream_new');
  late final _sk_managedstream_new =
      _sk_managedstream_newPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_managedstream_set_procs(SKManagedStreamDelegates procs)
  void sk_managedstream_set_procs(
    ffi.Pointer<ffi.NativeFunction<ffi.Void Function()>> procs,
  ) {
    return _sk_managedstream_set_procs(
      procs,
    );
  }

  late final _sk_managedstream_set_procsPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.NativeFunction<ffi.Void Function()>>)>>('sk_managedstream_set_procs');
  late final _sk_managedstream_set_procs =
      _sk_managedstream_set_procsPtr.asFunction<void Function(ffi.Pointer<ffi.NativeFunction<ffi.Void Function()>>)>();

  /// void sk_managedwstream_destroy(sk_wstream_managedstream_t s)
  void sk_managedwstream_destroy(
    ffi.Pointer<ffi.Void> s,
  ) {
    return _sk_managedwstream_destroy(
      s,
    );
  }

  late final _sk_managedwstream_destroyPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_managedwstream_destroy');
  late final _sk_managedwstream_destroy =
      _sk_managedwstream_destroyPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// sk_wstream_managedstream_t sk_managedwstream_new(void* context)
  ffi.Pointer<ffi.Void> sk_managedwstream_new(
    ffi.Pointer<ffi.Void> context,
  ) {
    return _sk_managedwstream_new(
      context,
    );
  }

  late final _sk_managedwstream_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>>('sk_managedwstream_new');
  late final _sk_managedwstream_new =
      _sk_managedwstream_newPtr.asFunction<ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>();

  /// void sk_managedwstream_set_procs(SKManagedWStreamDelegates procs)
  void sk_managedwstream_set_procs(
    ffi.Pointer<ffi.NativeFunction<ffi.Void Function()>> procs,
  ) {
    return _sk_managedwstream_set_procs(
      procs,
    );
  }

  late final _sk_managedwstream_set_procsPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.NativeFunction<ffi.Void Function()>>)>>('sk_managedwstream_set_procs');
  late final _sk_managedwstream_set_procs =
      _sk_managedwstream_set_procsPtr.asFunction<void Function(ffi.Pointer<ffi.NativeFunction<ffi.Void Function()>>)>();

  /// void sk_managedtracememorydump_delete(sk_managedtracememorydump_t param0)
  void sk_managedtracememorydump_delete(
    ffi.Pointer<ffi.Void> param0,
  ) {
    return _sk_managedtracememorydump_delete(
      param0,
    );
  }

  late final _sk_managedtracememorydump_deletePtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_managedtracememorydump_delete');
  late final _sk_managedtracememorydump_delete =
      _sk_managedtracememorydump_deletePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// sk_managedtracememorydump_t sk_managedtracememorydump_new(bool detailed, bool dumpWrapped, void* context)
  ffi.Pointer<ffi.Void> sk_managedtracememorydump_new(
    bool detailed,
    bool dumpWrapped,
    ffi.Pointer<ffi.Void> context,
  ) {
    return _sk_managedtracememorydump_new(
      detailed,
      dumpWrapped,
      context,
    );
  }

  late final _sk_managedtracememorydump_newPtr = _lookup<
      ffi.NativeFunction<ffi.Pointer<ffi.Void> Function(ffi.Bool, ffi.Bool, ffi.Pointer<ffi.Void>)>>('sk_managedtracememorydump_new');
  late final _sk_managedtracememorydump_new =
      _sk_managedtracememorydump_newPtr.asFunction<ffi.Pointer<ffi.Void> Function(bool, bool, ffi.Pointer<ffi.Void>)>();

  /// void sk_managedtracememorydump_set_procs(SKManagedTraceMemoryDumpDelegates procs)
  void sk_managedtracememorydump_set_procs(
    ffi.Pointer<ffi.Void> procs,
  ) {
    return _sk_managedtracememorydump_set_procs(
      procs,
    );
  }

  late final _sk_managedtracememorydump_set_procsPtr = _lookup<
      ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>('sk_managedtracememorydump_set_procs');
  late final _sk_managedtracememorydump_set_procs =
      _sk_managedtracememorydump_set_procsPtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();
}
