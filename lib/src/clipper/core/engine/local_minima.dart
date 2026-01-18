import '../../clipper.dart';

import 'vertex.dart';

class LocalMinima {
  const LocalMinima({
    required this.vertex,
    required this.polytype,
    required this.isOpen,
  });

  final Vertex vertex;
  final PathType polytype;
  final bool isOpen;

  @override
  bool operator ==(Object other) =>
      other is LocalMinima && identical(vertex, other.vertex);

  @override
  int get hashCode => vertex.hashCode;

  static int compare(LocalMinima a, LocalMinima b) {
    return b.vertex.pt.y.compareTo(a.vertex.pt.y);
  }
}
