import '../../clipper.dart';
import '../clipper_internal.dart';

import 'out_pt_2.dart';

class RectClip64 {
  RectClip64({required this.rect}) : mp = rect.midPoint, rectPath = rect.asPath;

  final Rect64 rect;
  final Point64 mp;
  final Path64 rectPath;
  final results = <OutPt2?>[];
  final edges = List.generate(8, (_) => <OutPt2>[]);
  var currIdx = -1;
  late Rect64 pathBounds;

  OutPt2 add(Point64 pt, {bool startingNewPath = false}) {
    // this method is only called by internalExecute.
    // Later splitting and rejoining won't create additional op's,
    // though they will change the (non-storage) fResults count.
    var currIdx = results.length;
    if (currIdx == 0 || startingNewPath) {
      final result = OutPt2(pt: pt, ownerIdx: currIdx);
      results.add(result);
      return result;
    }
    currIdx--;
    OutPt2? prevOp = results[currIdx];
    if (prevOp!.pt == pt) {
      return prevOp;
    }
    final result = OutPt2(
      pt: pt,
      ownerIdx: currIdx,
      next: prevOp.next,
      prev: prevOp,
    );
    prevOp.next.prev = result;
    prevOp.next = result;
    results[currIdx] = result;
    return result;
  }

  static bool _isClockwise(
    Location prev,
    Location curr,
    Point64 prevPt,
    Point64 currPt,
    Point64 rectMidPoint,
  ) {
    if (_areOpposites(prev, curr)) {
      return crossProduct(prevPt, rectMidPoint, currPt) < 0;
    }
    return _headingClockwise(prev, curr);
  }

  static bool _areOpposites(Location prev, Location curr) =>
      (prev.index - curr.index).abs() == 2;

  static bool _headingClockwise(Location prev, Location curr) =>
      (prev.index + 1) % Location.values.length == curr.index;

  static Location _getAdjacentLocation(Location loc, bool isClockwise) =>
      Location.values[(loc.index + (isClockwise ? 1 : 3)) %
          Location.values.length];

  static int _getEdgesForPt(Point64 pt, Rect64 rec) {
    var result = 0;
    if (pt.x == rec.left) {
      result = 1;
    } else if (pt.x == rec.right) {
      result = 4;
    }
    if (pt.y == rec.top) {
      result += 2;
    } else if (pt.y == rec.bottom) {
      result += 8;
    }
    return result;
  }

  static bool _isHeadingClockwise(Point64 pt1, Point64 pt2, int edgeIdx) {
    return switch (edgeIdx) {
      0 => pt2.y < pt1.y,
      1 => pt2.x > pt1.x,
      2 => pt2.y > pt1.y,
      _ => pt2.x < pt1.x,
    };
  }

  static bool _hasHorzOverlap(
    Point64 left1,
    Point64 right1,
    Point64 left2,
    Point64 right2,
  ) => (left1.x < right2.x) && (right1.x > left2.x);

  static bool _hasVertOverlap(
    Point64 top1,
    Point64 bottom1,
    Point64 top2,
    Point64 bottom2,
  ) => (top1.y < bottom2.y) && (bottom1.y > top2.y);

  static void _addToEdge(List<OutPt2?> edge, OutPt2 op) {
    if (op.edge != null) {
      return;
    }
    op.edge = edge;
    edge.add(op);
  }

  void _addCorner(Location prev, Location curr) {
    add(
      _headingClockwise(prev, curr)
          ? rectPath[prev.index]
          : rectPath[curr.index],
    );
  }

  Location _addCornerRelative(Location loc, bool isClockwise) {
    if (isClockwise) {
      add(rectPath[loc.index]);
      loc = _getAdjacentLocation(loc, true);
    } else {
      loc = _getAdjacentLocation(loc, false);
      add(rectPath[loc.index]);
    }
    return loc;
  }

  static (bool, Location) getLocation(Rect64 rec, Point64 pt) {
    if (pt.x == rec.left && pt.y >= rec.top && pt.y <= rec.bottom) {
      return (false, Location.left); // pt on rec
    }
    if (pt.x == rec.right && pt.y >= rec.top && pt.y <= rec.bottom) {
      return (false, Location.right); // pt on rec
    }
    if (pt.y == rec.top && pt.x >= rec.left && pt.x <= rec.right) {
      return (false, Location.top); // pt on rec
    }
    if (pt.y == rec.bottom && pt.x >= rec.left && pt.x <= rec.right) {
      return (false, Location.bottom); // pt on rec
    }
    if (pt.x < rec.left) {
      return (true, Location.left);
    } else if (pt.x > rec.right) {
      return (true, Location.right);
    } else if (pt.y < rec.top) {
      return (true, Location.top);
    } else if (pt.y > rec.bottom) {
      return (true, Location.bottom);
    }
    return (true, Location.inside);
  }

  static bool _isHorizontal(Point64 pt1, Point64 pt2) {
    return pt1.y == pt2.y;
  }

  static (bool, Point64) _getSegmentIntersection(
    Point64 p1,
    Point64 p2,
    Point64 p3,
    Point64 p4,
  ) {
    final res1 = crossProduct(p1, p3, p4);
    final res2 = crossProduct(p2, p3, p4);
    if (res1 == 0) {
      if (res2 == 0) {
        // segments are collinear
        return (false, p1);
      }
      if (p1 == p3 || p1 == p4) {
        return (true, p1);
      }
      //else if (p2 == p3 || p2 == p4) { ip = p2; return true; }
      if (_isHorizontal(p3, p4)) {
        return ((p1.x > p3.x) == (p1.x < p4.x), p1);
      }
      return ((p1.y > p3.y) == (p1.y < p4.y), p1);
    }
    if (res2 == 0) {
      if (p2 == p3 || p2 == p4) {
        return (true, p2);
      }
      if (_isHorizontal(p3, p4)) {
        return ((p2.x > p3.x) == (p2.x < p4.x), p2);
      }
      return ((p2.y > p3.y) == (p2.y < p4.y), p2);
    }

    if ((res1 > 0) == (res2 > 0)) {
      return (false, Point64(0, 0));
    }

    final res3 = crossProduct(p3, p1, p2);
    final res4 = crossProduct(p4, p1, p2);
    if (res3 == 0) {
      if (p3 == p1 || p3 == p2) {
        return (true, p3);
      }
      if (_isHorizontal(p1, p2)) {
        return ((p3.x > p1.x) == (p3.x < p2.x), p3);
      }
      return ((p3.y > p1.y) == (p3.y < p2.y), p3);
    }
    if (res4 == 0) {
      if (p4 == p1 || p4 == p2) {
        return (true, p4);
      }
      if (_isHorizontal(p1, p2)) {
        return ((p4.x > p1.x) == (p4.x < p2.x), p4);
      }
      return ((p4.y > p1.y) == (p4.y < p2.y), p4);
    }
    if ((res3 > 0) == (res4 > 0)) {
      return (false, Point64(0, 0));
    }

    // segments must intersect to get here
    final ip = getSegmentIntersectPt(p1, p2, p3, p4);
    return (ip != null, ip ?? Point64(0, 0));
  }

  static (bool, Location, Point64) getIntersection(
    Path64 rectPath,
    Point64 p,
    Point64 p2,
    Location loc,
  ) {
    // gets the pt of intersection between rectPath and segment(p, p2) that's closest to 'p'
    // when result == false, loc will remain unchanged
    switch (loc) {
      case Location.left:
        var (ok, ip) = _getSegmentIntersection(p, p2, rectPath[0], rectPath[3]);
        if (ok) {
          return (true, loc, ip);
        }
        if (p.y < rectPath[0].y) {
          (ok, ip) = _getSegmentIntersection(p, p2, rectPath[0], rectPath[1]);
          if (ok) {
            return (true, Location.top, ip);
          }
        }

        (ok, ip) = _getSegmentIntersection(p, p2, rectPath[2], rectPath[3]);
        if (!ok) return (false, loc, ip);
        return (true, Location.bottom, ip);

      case Location.right:
        var (ok, ip) = _getSegmentIntersection(p, p2, rectPath[1], rectPath[2]);
        if (ok) {
          return (true, loc, ip);
        }
        if (p.y < rectPath[0].y) {
          (ok, ip) = _getSegmentIntersection(p, p2, rectPath[0], rectPath[1]);
          if (ok) {
            return (true, Location.top, ip);
          }
        }

        (ok, ip) = _getSegmentIntersection(p, p2, rectPath[2], rectPath[3]);
        if (!ok) {
          return (false, loc, ip);
        }
        return (true, Location.bottom, ip);

      case Location.top:
        var (ok, ip) = _getSegmentIntersection(p, p2, rectPath[0], rectPath[1]);
        if (ok) {
          return (true, loc, ip);
        }
        if (p.x < rectPath[0].x) {
          (ok, ip) = _getSegmentIntersection(p, p2, rectPath[0], rectPath[3]);
          if (ok) {
            return (true, Location.left, ip);
          }
        }

        if (p.x <= rectPath[1].x) {
          return (false, loc, ip);
        }
        (ok, ip) = _getSegmentIntersection(p, p2, rectPath[1], rectPath[2]);
        if (!ok) {
          return (false, loc, ip);
        }
        return (true, Location.right, ip);

      case Location.bottom:
        var (ok, ip) = _getSegmentIntersection(p, p2, rectPath[2], rectPath[3]);
        if (ok) {
          return (true, loc, ip);
        }
        if (p.x < rectPath[3].x) {
          (ok, ip) = _getSegmentIntersection(p, p2, rectPath[0], rectPath[3]);
          if (ok) {
            return (true, Location.left, ip);
          }
        }

        if (p.x <= rectPath[2].x) {
          return (false, loc, ip);
        }
        (ok, ip) = _getSegmentIntersection(p, p2, rectPath[1], rectPath[2]);
        if (!ok) {
          return (false, loc, ip);
        }
        return (true, Location.right, ip);

      default:
        var (ok, ip) = _getSegmentIntersection(p, p2, rectPath[0], rectPath[3]);
        if (ok) {
          return (true, Location.left, ip);
        }
        (ok, ip) = _getSegmentIntersection(p, p2, rectPath[0], rectPath[1]);
        if (ok) {
          return (true, Location.top, ip);
        }
        (ok, ip) = _getSegmentIntersection(p, p2, rectPath[1], rectPath[2]);
        if (ok) {
          return (true, Location.right, ip);
        }

        (ok, ip) = _getSegmentIntersection(p, p2, rectPath[2], rectPath[3]);
        if (!ok) {
          return (false, loc, ip);
        }
        return (true, Location.bottom, ip);
    }
  }

  (Location, int) getNextLocation(Path64 path, Location loc, int i, int highI) {
    switch (loc) {
      case Location.left:
        {
          while (i <= highI && path[i].x <= rect.left) {
            i++;
          }
          if (i > highI) {
            break;
          }
          if (path[i].x >= rect.right) {
            loc = Location.right;
          } else if (path[i].y <= rect.top) {
            loc = Location.top;
          } else if (path[i].y >= rect.bottom) {
            loc = Location.bottom;
          } else {
            loc = Location.inside;
          }
        }
        break;

      case Location.top:
        {
          while (i <= highI && path[i].y <= rect.top) {
            i++;
          }
          if (i > highI) {
            break;
          }
          if (path[i].y >= rect.bottom) {
            loc = Location.bottom;
          } else if (path[i].x <= rect.left) {
            loc = Location.left;
          } else if (path[i].x >= rect.right) {
            loc = Location.right;
          } else {
            loc = Location.inside;
          }
        }
        break;

      case Location.right:
        {
          while (i <= highI && path[i].x >= rect.right) {
            i++;
          }
          if (i > highI) {
            break;
          }
          if (path[i].x <= rect.left) {
            loc = Location.left;
          } else if (path[i].y <= rect.top) {
            loc = Location.top;
          } else if (path[i].y >= rect.bottom) {
            loc = Location.bottom;
          } else {
            loc = Location.inside;
          }
        }
        break;

      case Location.bottom:
        {
          while (i <= highI && path[i].y >= rect.bottom) {
            i++;
          }
          if (i > highI) {
            break;
          }
          if (path[i].y <= rect.top) {
            loc = Location.top;
          } else if (path[i].x <= rect.left) {
            loc = Location.left;
          } else if (path[i].x >= rect.right) {
            loc = Location.right;
          } else {
            loc = Location.inside;
          }
        }
        break;

      case Location.inside:
        {
          while (i <= highI) {
            if (path[i].x < rect.left) {
              loc = Location.left;
            } else if (path[i].x > rect.right) {
              loc = Location.right;
            } else if (path[i].y > rect.bottom) {
              loc = Location.bottom;
            } else if (path[i].y < rect.top) {
              loc = Location.top;
            } else {
              add(path[i]);
              i++;
              continue;
            }
            break;
          }
        }
        break;
    }
    return (loc, i);
  }

  static bool _startLocsAreClockwise(List<Location> startLocs) {
    var result = 0;
    for (var i = 1; i < startLocs.length; i++) {
      int d = startLocs[i].index - startLocs[i - 1].index;
      switch (d) {
        case -1:
          result -= 1;
        case 1:
          result += 1;
        case -3:
          result += 1;
        case 3:
          result -= 1;
      }
    }
    return result > 0;
  }

  void _executeInternal(Path64 path) {
    if (path.length < 3 || rect.isEmpty) {
      return;
    }
    final startLocs = <Location>[];

    var firstCross = Location.inside;
    var crossingLoc = firstCross;
    var prev = firstCross;
    Point64 ip;

    final highI = path.length - 1;
    var (ok, loc) = getLocation(rect, path[highI]);
    if (!ok) {
      var i = highI - 1;
      while (i >= 0) {
        final (ok, prev) = getLocation(rect, path[i]);
        if (ok) {
          break;
        }
        i--;
      }
      if (i < 0) {
        for (final pt in path) {
          add(pt);
        }
        return;
      }
      if (prev == Location.inside) {
        loc = Location.inside;
      }
    }
    final startingLoc = loc;

    ///////////////////////////////////////////////////
    var i = 0;
    while (i <= highI) {
      prev = loc;
      Location prevCrossLoc = crossingLoc;
      (loc, i) = getNextLocation(path, loc, i, highI);
      if (i > highI) {
        break;
      }

      Point64 prevPt = (i == 0) ? path[highI] : path[i - 1];
      (ok, crossingLoc, ip) = getIntersection(rectPath, path[i], prevPt, loc);
      if (!ok) {
        // ie remaining outside
        if (prevCrossLoc == Location.inside) {
          final isClockw = _isClockwise(prev, loc, prevPt, path[i], mp);
          do {
            startLocs.add(prev);
            prev = _getAdjacentLocation(prev, isClockw);
          } while (prev != loc);
          crossingLoc = prevCrossLoc; // still not crossed
        } else if (prev != Location.inside && prev != loc) {
          final isClockw = _isClockwise(prev, loc, prevPt, path[i], mp);
          do {
            prev = _addCornerRelative(prev, isClockw);
          } while (prev != loc);
        }
        i++;
        continue;
      }

      ////////////////////////////////////////////////////
      // we must be crossing the rect boundary to get here
      ////////////////////////////////////////////////////

      if (loc == Location.inside) // path must be entering rect
      {
        if (firstCross == Location.inside) {
          firstCross = crossingLoc;
          startLocs.add(prev);
        } else if (prev != crossingLoc) {
          final isClockw = _isClockwise(prev, crossingLoc, prevPt, path[i], mp);
          do {
            prev = _addCornerRelative(prev, isClockw);
          } while (prev != crossingLoc);
        }
      } else if (prev != Location.inside) {
        // passing right through rect. 'ip' here will be the second
        // intersect pt but we'll also need the first intersect pt (ip2)
        Point64 ip2;
        (_, loc, ip2) = getIntersection(rectPath, prevPt, path[i], prev);
        if (prevCrossLoc != Location.inside && prevCrossLoc != loc) {
          //#597
          _addCorner(prevCrossLoc, loc);
        }

        if (firstCross == Location.inside) {
          firstCross = loc;
          startLocs.add(prev);
        }

        loc = crossingLoc;
        add(ip2);
        if (ip == ip2) {
          // it's very likely that path[i] is on rect
          (_, loc) = getLocation(rect, path[i]);
          _addCorner(crossingLoc, loc);
          crossingLoc = loc;
          continue;
        }
      } else // path must be exiting rect
      {
        loc = crossingLoc;
        if (firstCross == Location.inside) {
          firstCross = crossingLoc;
        }
      }

      add(ip);
    } //while i <= highI
    ///////////////////////////////////////////////////

    if (firstCross == Location.inside) {
      // path never intersects
      if (startingLoc == Location.inside) {
        return;
      }
      if (!pathBounds.containsRect(rect) || !path.containsPath(rectPath)) {
        return;
      }
      final startLocsClockwise = _startLocsAreClockwise(startLocs);
      for (int j = 0; j < 4; j++) {
        int k = startLocsClockwise ? j : 3 - j; // ie reverse result path
        add(rectPath[k]);
        _addToEdge(edges[k * 2], results[0]!);
      }
    } else if (loc != Location.inside &&
        (loc != firstCross || startLocs.length > 2)) {
      if (startLocs.isNotEmpty) {
        prev = loc;
        for (final loc2 in startLocs) {
          if (prev == loc2) {
            continue;
          }
          prev = _addCornerRelative(prev, _headingClockwise(prev, loc2));
          prev = loc2;
        }
        loc = prev;
      }
      if (loc != firstCross) {
        loc = _addCornerRelative(loc, _headingClockwise(loc, firstCross));
      }
    }
  }

  Paths64 execute(Paths64 paths) {
    final result = <Path64>[];
    if (rect.isEmpty) {
      return result;
    }
    for (final path in paths) {
      if (path.length < 3) {
        continue;
      }
      pathBounds = path.bounds;
      if (!rect.intersects(pathBounds)) {
        // the path must be completely outside fRect
        continue;
      }
      if (rect.containsRect(pathBounds)) {
        // the path must be completely inside rect
        result.add(path);
        continue;
      }
      _executeInternal(path);
      _checkEdges();
      for (var i = 0; i < 4; i++) {
        _tidyEdgePair(i, edges[i * 2], edges[i * 2 + 1]);
      }
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

  void _checkEdges() {
    for (var i = 0; i < results.length; i++) {
      var op = results[i];
      var op2 = op;
      if (op == null) {
        continue;
      }
      do {
        if (isCollinear(op2!.prev.pt, op2.pt, op2.next.pt)) {
          if (op2 == op) {
            op2 = op2.unlinkBack();
            if (op2 == null) {
              break;
            }
            op = op2.prev;
          } else {
            op2 = op2.unlinkBack();
            if (op2 == null) {
              break;
            }
          }
        } else {
          op2 = op2.next;
        }
      } while (op2 != op);

      if (op2 == null) {
        results[i] = null;
        continue;
      }
      results[i] = op2; // safety first

      var edgeSet1 = _getEdgesForPt(op!.prev.pt, rect);
      op2 = op;
      do {
        final edgeSet2 = _getEdgesForPt(op2!.pt, rect);
        if (edgeSet2 != 0 && op2.edge == null) {
          final combinedSet = edgeSet1 & edgeSet2;
          for (int j = 0; j < 4; ++j) {
            if ((combinedSet & (1 << j)) == 0) {
              continue;
            }
            if (_isHeadingClockwise(op2.prev.pt, op2.pt, j)) {
              _addToEdge(edges[j * 2], op2);
            } else {
              _addToEdge(edges[j * 2 + 1], op2);
            }
          }
        }
        edgeSet1 = edgeSet2;
        op2 = op2.next;
      } while (op2 != op);
    }
  }

  void _tidyEdgePair(int idx, List<OutPt2?> cw, List<OutPt2?> ccw) {
    if (ccw.isEmpty) {
      return;
    }
    final isHorz = ((idx == 1) || (idx == 3));
    final cwIsTowardLarger = ((idx == 1) || (idx == 2));
    var i = 0;
    var j = 0;

    while (i < cw.length) {
      var p1 = cw[i];
      if (p1 == null || p1.next == p1.prev) {
        cw[i++] = null;
        j = 0;
        continue;
      }

      final jLim = ccw.length;
      while (j < jLim && (ccw[j] == null || ccw[j]!.next == ccw[j]!.prev)) {
        j++;
      }

      if (j == jLim) {
        i++;
        j = 0;
        continue;
      }

      OutPt2 p2;
      OutPt2 p1a;
      OutPt2 p2a;
      if (cwIsTowardLarger) {
        // p1 >>>> p1a;
        // p2 <<<< p2a;
        p1 = cw[i]!.prev;
        p1a = cw[i]!;
        p2 = ccw[j]!;
        p2a = ccw[j]!.prev;
      } else {
        // p1 <<<< p1a;
        // p2 >>>> p2a;
        p1 = cw[i];
        p1a = cw[i]!.prev;
        p2 = ccw[j]!.prev;
        p2a = ccw[j]!;
      }

      if ((isHorz && !_hasHorzOverlap(p1!.pt, p1a.pt, p2.pt, p2a.pt)) ||
          (!isHorz && !_hasVertOverlap(p1!.pt, p1a.pt, p2.pt, p2a.pt))) {
        j++;
        continue;
      }

      // to get here we're either splitting or rejoining
      final isRejoining = cw[i]!.ownerIdx != ccw[j]!.ownerIdx;

      if (isRejoining) {
        results[p2.ownerIdx] = null;
        p2.setNewOwner(p1!.ownerIdx);
      }

      // do the split or re-join
      if (cwIsTowardLarger) {
        // p1 >> | >> p1a;
        // p2 << | << p2a;
        p1!.next = p2;
        p2.prev = p1;
        p1a.prev = p2a;
        p2a.next = p1a;
      } else {
        // p1 << | << p1a;
        // p2 >> | >> p2a;
        p1!.prev = p2;
        p2.next = p1;
        p1a.next = p2a;
        p2a.prev = p1a;
      }

      if (!isRejoining) {
        final newIdx = results.length;
        results.add(p1a);
        p1a.setNewOwner(newIdx);
      }

      OutPt2 op;
      OutPt2 op2;
      if (cwIsTowardLarger) {
        op = p2;
        op2 = p1a;
      } else {
        op = p1;
        op2 = p2a;
      }
      results[op.ownerIdx] = op;
      results[op2.ownerIdx] = op2;

      // and now lots of work to get ready for the next loop

      bool opIsLarger, op2IsLarger;
      if (isHorz) // X
      {
        opIsLarger = op.pt.x > op.prev.pt.x;
        op2IsLarger = op2.pt.x > op2.prev.pt.x;
      } else // Y
      {
        opIsLarger = op.pt.y > op.prev.pt.y;
        op2IsLarger = op2.pt.y > op2.prev.pt.y;
      }

      if ((op.next == op.prev) || (op.pt == op.prev.pt)) {
        if (op2IsLarger == cwIsTowardLarger) {
          cw[i] = op2;
          ccw[j++] = null;
        } else {
          ccw[j] = op2;
          cw[i++] = null;
        }
      } else if ((op2.next == op2.prev) || (op2.pt == op2.prev.pt)) {
        if (opIsLarger == cwIsTowardLarger) {
          cw[i] = op;
          ccw[j++] = null;
        } else {
          ccw[j] = op;
          cw[i++] = null;
        }
      } else if (opIsLarger == op2IsLarger) {
        if (opIsLarger == cwIsTowardLarger) {
          cw[i] = op;
          op2.uncoupleEdge();
          _addToEdge(cw, op2);
          ccw[j++] = null;
        } else {
          cw[i++] = null;
          ccw[j] = op2;
          op.uncoupleEdge();
          _addToEdge(ccw, op);
          j = 0;
        }
      } else {
        if (opIsLarger == cwIsTowardLarger) {
          cw[i] = op;
        } else {
          ccw[j] = op;
        }
        if (op2IsLarger == cwIsTowardLarger) {
          cw[i] = op2;
        } else {
          ccw[j] = op2;
        }
      }
    }
  }

  static Path64 _getPath(OutPt2? op) {
    final result = <Point64>[];
    if (op == null || op.prev == op.next) {
      return result;
    }
    OutPt2? op2 = op.next;
    while (op2 != null && op2 != op) {
      if (isCollinear(op2.prev.pt, op2.pt, op2.next.pt)) {
        op = op2.prev;
        op2 = op2.unlink();
      } else {
        op2 = op2.next;
      }
    }
    if (op2 == null) {
      return result;
    }

    result.add(op!.pt);
    op2 = op.next;
    while (op2 != op) {
      result.add(op2!.pt);
      op2 = op2.next;
    }
    return result;
  }
}

enum Location { left, top, right, bottom, inside }
