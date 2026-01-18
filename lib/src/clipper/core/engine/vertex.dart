// Vertex: a pre-clipping data structure. It is used to separate polygons
// into ascending and descending 'bounds' (or sides) that start at local
// minima and ascend to a local maxima, before descending again.

import '../../clipper.dart';

import 'local_minima.dart';

class Vertex {
  Vertex({
    required this.pt,
    this.next,
    this.prev,
    this.flags = VertexFlag.none,
  });

  final Point64 pt;
  Vertex? next;
  Vertex? prev;
  VertexFlags flags;

  void addLocMin({
    required PathType polytype,
    required bool isOpen,
    required List<LocalMinima> minimaList,
  }) {
    if (flags.isLocalMin) {
      return;
    }
    flags |= VertexFlag.localMin;
    minimaList.add(
      LocalMinima(vertex: this, polytype: polytype, isOpen: isOpen),
    );
  }

  bool get isOpenEnd => flags.isOpenStart || flags.isOpenEnd;
  bool get isMaxima => flags.isLocalMax;
}

typedef VertexFlags = int;

extension VertexFlag on VertexFlags {
  static const none = 0;
  static const openStart = 1;
  static const openEnd = 2;
  static const localMax = 4;
  static const localMin = 8;

  bool get isOpenStart => (this & openStart) != 0;
  bool get isOpenEnd => (this & openEnd) != 0;
  bool get isLocalMax => (this & localMax) != 0;
  bool get isLocalMin => (this & localMin) != 0;
}
