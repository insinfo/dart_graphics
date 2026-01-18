import '../../clipper.dart';

import 'out_pt_2.dart';
import 'rect_clip_64.dart';

class RectClipLines64 extends RectClip64 {
  RectClipLines64({required super.rect});

  @override
  Paths64 execute(Paths64 paths) {
    final result = <Path64>[];
    if (rect.isEmpty) {
      return result;
    }
    for (final path in paths) {
      if (path.length < 2) continue;
      pathBounds = path.bounds;
      if (!rect.intersects(pathBounds)) {
        // the path must be completely outside fRect
        // Apart from that, we can't be sure whether the path
        // is completely outside or completed inside or intersects
        // fRect, simply by comparing path bounds with fRect.
        continue;
      }
      _executeInternal(path);

      for (final op in results) {
        final tmp = _getPath(op);
        if (tmp.isNotEmpty) {
          result.add(tmp);
        }
      }

      //clean up after every loop
      results.clear();
      for (final e in edges) {
        e.clear();
      }
    }
    return result;
  }

  static Path64 _getPath(OutPt2? op) {
    Path64 result = <Point64>[];
    if (op == null || op == op.next) return result;
    op = op.next; // starting at path beginning
    result.add(op.pt);
    var op2 = op.next;
    while (op2 != op) {
      result.add(op2.pt);
      op2 = op2.next;
    }
    return result;
  }

  void _executeInternal(Path64 path) {
    results.clear();
    if (path.length < 2 || rect.isEmpty) {
      return;
    }

    var prev = Location.inside;
    var i = 1;
    final highI = path.length - 1;
    var (ok, loc) = RectClip64.getLocation(rect, path[0]);
    if (!ok) {
      while (i <= highI) {
        (ok, prev) = RectClip64.getLocation(rect, path[i]);
        if (ok) {
          break;
        }
        i++;
      }
      if (i > highI) {
        for (final pt in path) {
          add(pt);
        }
        return;
      }
      if (prev == Location.inside) loc = Location.inside;
      i = 1;
    }
    if (loc == Location.inside) {
      add(path[0]);
    }

    ///////////////////////////////////////////////////
    while (i <= highI) {
      (loc, i) = getNextLocation(path, prev, i, highI);
      if (i > highI) {
        break;
      }
      final prevPt = path[i - 1];

      final (ok, _, ip) = RectClip64.getIntersection(
        rectPath,
        path[i],
        prevPt,
        loc,
      );
      if (!ok) {
        // ie remaining outside (& crossingLoc still == loc)
        i++;
        continue;
      }

      ////////////////////////////////////////////////////
      // we must be crossing the rect boundary to get here
      ////////////////////////////////////////////////////

      if (loc == Location.inside) // path must be entering rect
      {
        add(ip, startingNewPath: true);
      } else if (prev != Location.inside) {
        // passing right through rect. 'ip' here will be the second
        // intersect pt but we'll also need the first intersect pt (ip2)
        final (ok, _, ip2) = RectClip64.getIntersection(
          rectPath,
          prevPt,
          path[i],
          prev,
        );
        add(ip2, startingNewPath: true);
        add(ip);
      } else // path must be exiting rect
      {
        add(ip);
      }
    } //while i <= highI
    ///////////////////////////////////////////////////
  }
}
