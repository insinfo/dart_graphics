/// A pure 2D graphics library inspired by AGG.
library dart_graphics;

export 'typography.dart';

// Canvas 2D API experimental ainda não esta pronto
// export 'src/dart_graphics/canvas/canvas.dart';
// export 'src/dart_graphics/primitives/pattern_repetition.dart';
// export 'src/shared/canvas2d/canvas_pattern.dart';

// Core
export 'src/dart_graphics/graphics2D.dart';
export 'src/dart_graphics/image/image_buffer.dart';
export 'src/dart_graphics/primitives/color.dart';
export 'src/dart_graphics/vertex_source/vertex_storage.dart';

// Small shared enums/utilities (kept public because higher-level integrations
// like PDF renderers need to control fill rules).
export 'src/dart_graphics/basics.dart' show FillingRuleE;
export 'src/dart_graphics/transform/affine.dart';

export 'src/dart_graphics/vertex_source/vertex_source.dart';
export 'src/dart_graphics/spans/span_generator.dart';
export 'src/dart_graphics/spans/span_gradient.dart';
export 'src/dart_graphics/image/iimage.dart';
export 'src/dart_graphics/rasterizer_compound_aa.dart';
export 'src/dart_graphics/primitives/pattern_repetition.dart';
export 'src/dart_graphics/primitives/rectangle_int.dart';


export 'src/dart_graphics/recording/graphics_commands.dart';
export 'src/dart_graphics/recording/path_utils.dart';
export 'src/dart_graphics/recording/clip_stack.dart';
export 'src/dart_graphics/recording/layer_stack.dart';
export 'src/dart_graphics/recording/image_graphics_backend.dart';


