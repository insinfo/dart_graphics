import 'package:dart_graphics/src/dart_graphics/vertex_source/path_commands.dart';
import 'package:dart_graphics/src/dart_graphics/vertex_source/vertex_data.dart';
import 'package:dart_graphics/src/shared/ref_param.dart';

abstract class IVertexSource {
  void rewind([int pathId = 0]);
  FlagsAndCommand vertex(RefParam<double> x, RefParam<double> y);
  int getLongHashCode([int hash = 0xcbf29ce484222325]);
  Iterable<VertexData> vertices();
}
