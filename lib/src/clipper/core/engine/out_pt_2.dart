import '../../clipper.dart';

class OutPt2 {
  OutPt2({
    required this.pt,
    required this.ownerIdx,
    OutPt2? next,
    OutPt2? prev,
  }) {
    this.next = next ?? this;
    this.prev = prev ?? this;
  }

  late OutPt2 next;
  late OutPt2 prev;
  Point64 pt;
  int ownerIdx;
  List<OutPt2?>? edge;

  OutPt2? unlink() {
    if (next == this) {
      return null;
    }
    prev.next = next;
    next.prev = prev;
    return next;
  }

  OutPt2? unlinkBack() {
    if (next == this) {
      return null;
    }
    prev.next = next;
    next.prev = prev;
    return prev;
  }

  void uncoupleEdge() {
    if (edge == null) {
      return;
    }
    for (int i = 0; i < edge!.length; i++) {
      OutPt2? op2 = edge![i];
      if (op2 != this) {
        continue;
      }
      edge![i] = null;
      break;
    }
    edge = null;
  }

  void setNewOwner(int newIdx) {
    ownerIdx = newIdx;
    var op2 = next;
    while (op2 != this) {
      op2.ownerIdx = newIdx;
      op2 = op2.next;
    }
  }
}
