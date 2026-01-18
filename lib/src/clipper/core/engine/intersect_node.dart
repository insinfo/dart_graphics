import '../../clipper.dart';

import 'active.dart';

// IntersectNode: a structure representing 2 intersecting edges.
// Intersections must be sorted so they are processed from the largest
// Y coordinates to the smallest while keeping edges adjacent.
class IntersectNode {
  const IntersectNode({
    required this.pt,
    required this.edge1,
    required this.edge2,
  });

  final Point64 pt;
  final Active edge1;
  final Active edge2;

  bool get edgesAdjacentInAEL =>
      edge1.nextInAEL == edge2 || edge1.prevInAEL == edge2;

  static int compare(IntersectNode a, IntersectNode b) {
    if (a.pt.y != b.pt.y) {
      return (a.pt.y > b.pt.y) ? -1 : 1;
    }
    if (a.pt.x == b.pt.x) {
      return 0;
    }
    return (a.pt.x < b.pt.x) ? -1 : 1;
  }
}
