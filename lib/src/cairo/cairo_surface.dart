/// Cairo Surface re-exports
/// 
/// This file re-exports Cairo surface and canvas classes from the main API.
/// For new code, import 'cairo_api.dart' directly.
library cairo_surface;

export 'cairo_api.dart' show 
    Cairo,
    CairoSurfaceImpl,
    CairoCanvasImpl,
    CairoFreeTypeFaceImpl;
