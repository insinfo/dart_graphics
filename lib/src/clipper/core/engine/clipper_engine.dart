import '../../clipper.dart';

import 'local_minima.dart';
import 'vertex.dart';

///////////////////////////////////////////////////////////////////
// Important: UP and DOWN here are premised on Y-axis positive down
// displays, which is the orientation used in Clipper's development.
///////////////////////////////////////////////////////////////////

void addPathsToVertexList({
  required Paths64 paths,
  required PathType polytype,
  required bool isOpen,
  required List<LocalMinima> minimaList,
  required List<Vertex> vertexList,
}) {
  for (final path in paths) {
    Vertex? v0;
    Vertex? prevV;
    for (final pt in path) {
      if (v0 == null) {
        v0 = Vertex(pt: pt);
        vertexList.add(v0);
        prevV = v0;
      } else if (prevV!.pt != pt) {
        // ie skips duplicates
        final currV = Vertex(pt: pt, prev: prevV);
        vertexList.add(currV);
        prevV.next = currV;
        prevV = currV;
      }
    }
    if (prevV == null || prevV.prev == null) {
      continue;
    }
    if (!isOpen && prevV.pt == v0!.pt) {
      prevV = prevV.prev;
    }
    prevV!.next = v0;
    v0!.prev = prevV;
    if (!isOpen && prevV.next == prevV) {
      continue;
    }

    // OK, we have a valid path
    bool goingUp;
    if (isOpen) {
      var currV = v0.next;
      while (currV != v0 && currV!.pt.y == v0.pt.y) {
        currV = currV.next;
      }
      goingUp = currV!.pt.y <= v0.pt.y;
      if (goingUp) {
        v0.flags = VertexFlag.openStart;
        v0.addLocMin(polytype: polytype, isOpen: true, minimaList: minimaList);
      } else {
        v0.flags = VertexFlag.openStart | VertexFlag.localMax;
      }
    } else {
      // closed path
      prevV = v0.prev;
      while (prevV != v0 && prevV!.pt.y == v0.pt.y) {
        prevV = prevV.prev;
      }
      if (prevV == v0) {
        // only open paths can be completely flat
        continue;
      }
      goingUp = prevV!.pt.y > v0.pt.y;
    }

    final goingUp0 = goingUp;
    prevV = v0;
    var currV = v0.next;
    while (currV != v0) {
      if (currV!.pt.y > prevV!.pt.y && goingUp) {
        prevV.flags |= VertexFlag.localMax;
        goingUp = false;
      } else if (currV.pt.y < prevV.pt.y && !goingUp) {
        goingUp = true;
        prevV.addLocMin(
          polytype: polytype,
          isOpen: isOpen,
          minimaList: minimaList,
        );
      }
      prevV = currV;
      currV = currV.next;
    }

    if (isOpen) {
      prevV!.flags |= VertexFlag.openEnd;
      if (goingUp) {
        prevV.flags |= VertexFlag.localMax;
      } else {
        prevV.addLocMin(
          polytype: polytype,
          isOpen: isOpen,
          minimaList: minimaList,
        );
      }
    } else if (goingUp != goingUp0) {
      if (goingUp0) {
        prevV!.addLocMin(
          polytype: polytype,
          isOpen: false,
          minimaList: minimaList,
        );
      } else {
        prevV!.flags |= VertexFlag.localMax;
      }
    }
  }
}
