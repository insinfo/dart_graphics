import 'dart:math' as math;
import 'package:dart_graphics/src/agg/vertex_source/vertex_storage.dart';

class SvgPathParser {
  static VertexStorage parse(String d) {
    final vs = VertexStorage();
    int i = 0;
    double cx = 0, cy = 0;
    double sx = 0, sy = 0;
    double lastCx = 0, lastCy = 0;

    while (i < d.length) {
      final ch = d[i];
      if (_isSkip(ch)) {
        i++;
        continue;
      }
      i++;

      switch (ch) {
        case 'M':
        case 'm':
          final nums = _readPoint(d, i);
          i = nums.nextIndex;
          cx = ch == 'm' ? cx + nums.x : nums.x;
          cy = ch == 'm' ? cy + nums.y : nums.y;
          vs.moveTo(cx, cy);
          sx = cx;
          sy = cy;
          lastCx = cx;
          lastCy = cy;

          while (true) {
            int nextI = _skipWhitespace(d, i);
            if (nextI >= d.length || _isCommandLetter(d[nextI])) break;
            final pt = _readPoint(d, nextI);
            i = pt.nextIndex;
            cx = ch == 'm' ? cx + pt.x : pt.x;
            cy = ch == 'm' ? cy + pt.y : pt.y;
            vs.lineTo(cx, cy);
            lastCx = cx;
            lastCy = cy;
          }
          break;
        case 'L':
        case 'l':
          while (true) {
            int nextI = _skipWhitespace(d, i);
            if (nextI >= d.length || _isCommandLetter(d[nextI])) break;
            final pt = _readPoint(d, nextI);
            i = pt.nextIndex;
            cx = ch == 'l' ? cx + pt.x : pt.x;
            cy = ch == 'l' ? cy + pt.y : pt.y;
            vs.lineTo(cx, cy);
            lastCx = cx;
            lastCy = cy;
          }
          break;
        case 'H':
        case 'h':
          while (true) {
            int nextI = _skipWhitespace(d, i);
            if (nextI >= d.length || _isCommandLetter(d[nextI])) break;
            final val = _readNumber(d, nextI);
            i = val.nextIndex;
            cx = ch == 'h' ? cx + val.value : val.value;
            vs.lineTo(cx, cy);
            lastCx = cx;
            lastCy = cy;
          }
          break;
        case 'V':
        case 'v':
          while (true) {
            int nextI = _skipWhitespace(d, i);
            if (nextI >= d.length || _isCommandLetter(d[nextI])) break;
            final val = _readNumber(d, nextI);
            i = val.nextIndex;
            cy = ch == 'v' ? cy + val.value : val.value;
            vs.lineTo(cx, cy);
            lastCx = cx;
            lastCy = cy;
          }
          break;
        case 'C':
        case 'c':
          while (true) {
            int nextI = _skipWhitespace(d, i);
            if (nextI >= d.length || _isCommandLetter(d[nextI])) break;
            final p1 = _readPoint(d, nextI);
            final p2 = _readPoint(d, p1.nextIndex);
            final p3 = _readPoint(d, p2.nextIndex);
            i = p3.nextIndex;

            final c1x = ch == 'c' ? cx + p1.x : p1.x;
            final c1y = ch == 'c' ? cy + p1.y : p1.y;
            final c2x = ch == 'c' ? cx + p2.x : p2.x;
            final c2y = ch == 'c' ? cy + p2.y : p2.y;
            final ex = ch == 'c' ? cx + p3.x : p3.x;
            final ey = ch == 'c' ? cy + p3.y : p3.y;

            vs.curve4(c1x, c1y, c2x, c2y, ex, ey);
            cx = ex;
            cy = ey;
            lastCx = c2x;
            lastCy = c2y;
          }
          break;
        case 'S':
        case 's':
          while (true) {
            int nextI = _skipWhitespace(d, i);
            if (nextI >= d.length || _isCommandLetter(d[nextI])) break;
            final p2 = _readPoint(d, nextI);
            final p3 = _readPoint(d, p2.nextIndex);
            i = p3.nextIndex;

            double c1x = 2 * cx - lastCx;
            double c1y = 2 * cy - lastCy;

            final c2x = ch == 's' ? cx + p2.x : p2.x;
            final c2y = ch == 's' ? cy + p2.y : p2.y;
            final ex = ch == 's' ? cx + p3.x : p3.x;
            final ey = ch == 's' ? cy + p3.y : p3.y;

            vs.curve4(c1x, c1y, c2x, c2y, ex, ey);
            cx = ex;
            cy = ey;
            lastCx = c2x;
            lastCy = c2y;
          }
          break;
        case 'Q':
        case 'q':
          while (true) {
            int nextI = _skipWhitespace(d, i);
            if (nextI >= d.length || _isCommandLetter(d[nextI])) break;
            final cp = _readPoint(d, nextI);
            final ep = _readPoint(d, cp.nextIndex);
            i = ep.nextIndex;

            final cpx = ch == 'q' ? cx + cp.x : cp.x;
            final cpy = ch == 'q' ? cy + cp.y : cp.y;
            final ex = ch == 'q' ? cx + ep.x : ep.x;
            final ey = ch == 'q' ? cy + ep.y : ep.y;

            vs.curve3(cpx, cpy, ex, ey);
            cx = ex;
            cy = ey;
            lastCx = cpx;
            lastCy = cpy;
          }
          break;
        case 'T':
        case 't':
          while (true) {
            int nextI = _skipWhitespace(d, i);
            if (nextI >= d.length || _isCommandLetter(d[nextI])) break;
            final ep = _readPoint(d, nextI);
            i = ep.nextIndex;

            double cpx = 2 * cx - lastCx;
            double cpy = 2 * cy - lastCy;

            final ex = ch == 't' ? cx + ep.x : ep.x;
            final ey = ch == 't' ? cy + ep.y : ep.y;

            vs.curve3(cpx, cpy, ex, ey);
            cx = ex;
            cy = ey;
            lastCx = cpx;
            lastCy = cpy;
          }
          break;
        case 'A':
        case 'a':
          while (true) {
            int nextI = _skipWhitespace(d, i);
            if (nextI >= d.length || _isCommandLetter(d[nextI])) break;

            final rxRead = _readNumber(d, nextI);
            final ryRead = _readNumber(d, rxRead.nextIndex);
            final rotRead = _readNumber(d, ryRead.nextIndex);
            final largeArcRead = _readFlag(d, rotRead.nextIndex);
            final sweepRead = _readFlag(d, largeArcRead.nextIndex);
            final xRead = _readNumber(d, sweepRead.nextIndex);
            final yRead = _readNumber(d, xRead.nextIndex);

            i = yRead.nextIndex;

            double rx = rxRead.value.abs();
            double ry = ryRead.value.abs();
            double rot = rotRead.value;
            bool largeArc = largeArcRead.value != 0.0;
            bool sweep = sweepRead.value != 0.0;
            double x = ch == 'a' ? cx + xRead.value : xRead.value;
            double y = ch == 'a' ? cy + yRead.value : yRead.value;

            _arcToBezier(vs, cx, cy, rx, ry, rot, largeArc, sweep, x, y);

            cx = x;
            cy = y;
            lastCx = cx;
            lastCy = cy;
          }
          break;
        case 'Z':
        case 'z':
          vs.closePath();
          cx = sx;
          cy = sy;
          lastCx = cx;
          lastCy = cy;
          break;
        default:
          break;
      }
    }
    return vs;
  }

  static bool _isSkip(String ch) =>
      ch == ' ' || ch == '\n' || ch == '\t' || ch == ',';

  static int _skipWhitespace(String s, int index) {
    while (index < s.length && _isSkip(s[index])) index++;
    return index;
  }

  static _PointRead _readPoint(String s, int index) {
    final x = _readNumber(s, index);
    final y = _readNumber(s, x.nextIndex);
    return _PointRead(x.value, y.value, y.nextIndex);
  }

  static _NumberRead _readNumber(String s, int index) {
    while (index < s.length && _isSkip(s[index])) index++;
    final start = index;
    bool hasDot = false;
    bool hasE = false;

    if (index < s.length && (s[index] == '+' || s[index] == '-')) index++;

    while (index < s.length) {
      final ch = s[index];
      if (_isDigit(ch)) {
        index++;
      } else if (ch == '.') {
        if (hasDot || hasE) break;
        hasDot = true;
        index++;
      } else if (ch == 'e' || ch == 'E') {
        if (hasE) break;
        hasE = true;
        index++;
        if (index < s.length && (s[index] == '+' || s[index] == '-')) index++;
      } else {
        break;
      }
    }
    final str = s.substring(start, index);
    try {
      return _NumberRead(double.parse(str), index);
    } catch (e) {
      return _NumberRead(0.0, index);
    }
  }

  static _NumberRead _readFlag(String s, int index) {
    while (index < s.length && _isSkip(s[index])) index++;
    if (index < s.length) {
      final ch = s[index];
      if (ch == '0' || ch == '1') {
        return _NumberRead(double.parse(ch), index + 1);
      }
    }
    return _NumberRead(0.0, index);
  }

  static bool _isDigit(String ch) {
    if (ch.isEmpty) return false;
    final code = ch.codeUnitAt(0);
    return code >= 48 && code <= 57;
  }

  static bool _isCommandLetter(String ch) {
    if (ch.length != 1) return false;
    final code = ch.codeUnitAt(0);
    return (code >= 65 && code <= 90) || (code >= 97 && code <= 122);
  }

  static void _arcToBezier(VertexStorage vs, double cx, double cy, double rx,
      double ry, double rot, bool largeArc, bool sweep, double px, double py) {
    if (rx == 0 || ry == 0) {
      vs.lineTo(px, py);
      return;
    }

    final sinPhi = math.sin(rot * math.pi / 180.0);
    final cosPhi = math.cos(rot * math.pi / 180.0);

    final pxp = cosPhi * (cx - px) / 2.0 + sinPhi * (cy - py) / 2.0;
    final pyp = -sinPhi * (cx - px) / 2.0 + cosPhi * (cy - py) / 2.0;

    if (pxp == 0 && pyp == 0) {
      return;
    }

    double rxSq = rx * rx;
    double rySq = ry * ry;
    final pxpSq = pxp * pxp;
    final pypSq = pyp * pyp;

    double rad = pxpSq / rxSq + pypSq / rySq;

    if (rad > 1.0) {
      rad = math.sqrt(rad);
      rx *= rad;
      ry *= rad;
      rxSq = rx * rx;
      rySq = ry * ry;
    }

    double sign = (largeArc == sweep) ? -1.0 : 1.0;
    double numerator = rxSq * rySq - rxSq * pypSq - rySq * pxpSq;
    double root = 0.0;

    if (numerator > 0) {
      root = sign * math.sqrt(numerator / (rxSq * pypSq + rySq * pxpSq));
    }

    final cxp = root * rx * pyp / ry;
    final cyp = -root * ry * pxp / rx;

    final cxCenter = cosPhi * cxp - sinPhi * cyp + (cx + px) / 2.0;
    final cyCenter = sinPhi * cxp + cosPhi * cyp + (cy + py) / 2.0;

    final theta1 = _vectorAngle(1.0, 0.0, (pxp - cxp) / rx, (pyp - cyp) / ry);
    var dTheta = _vectorAngle((pxp - cxp) / rx, (pyp - cyp) / ry,
        (-pxp - cxp) / rx, (-pyp - cyp) / ry);

    if (!sweep && dTheta > 0) {
      dTheta -= 2.0 * math.pi;
    } else if (sweep && dTheta < 0) {
      dTheta += 2.0 * math.pi;
    }

    final segments = (dTheta.abs() * 2.0 / math.pi).ceil();
    final delta = dTheta / segments;
    final t = 8.0 /
        3.0 *
        math.sin(delta / 4.0) *
        math.sin(delta / 4.0) /
        math.sin(delta / 2.0);

    double x1 = cx, y1 = cy;

    for (int i = 0; i < segments; i++) {
      final cosTheta1 = math.cos(theta1 + i * delta);
      final sinTheta1 = math.sin(theta1 + i * delta);
      final theta2 = theta1 + (i + 1) * delta;
      final cosTheta2 = math.cos(theta2);
      final sinTheta2 = math.sin(theta2);

      final epx = cosPhi * rx * cosTheta2 - sinPhi * ry * sinTheta2 + cxCenter;
      final epy = sinPhi * rx * cosTheta2 + cosPhi * ry * sinTheta2 + cyCenter;

      final dx1 = t * (-cosPhi * rx * sinTheta1 - sinPhi * ry * cosTheta1);
      final dy1 = t * (-sinPhi * rx * sinTheta1 + cosPhi * ry * cosTheta1);

      final dx2 = t * (cosPhi * rx * sinTheta2 + sinPhi * ry * cosTheta2);
      final dy2 = t * (sinPhi * rx * sinTheta2 - cosPhi * ry * cosTheta2);

      vs.curve4(x1 + dx1, y1 + dy1, epx + dx2, epy + dy2, epx, epy);
      x1 = epx;
      y1 = epy;
    }
  }

  static double _vectorAngle(double u1, double v1, double u2, double v2) {
    // It should be u1 * v2 - u2 * v1 (cross product z-component)
    final dot = u1 * u2 + v1 * v2;
    final mag = math.sqrt(u1 * u1 + v1 * v1) * math.sqrt(u2 * u2 + v2 * v2);

    // Fix sign calculation
    final cross = u1 * v2 - u2 * v1;
    final sign2 = (cross < 0.0) ? -1.0 : 1.0;

    var arg = dot / mag;
    if (arg < -1.0) arg = -1.0;
    if (arg > 1.0) arg = 1.0;
    return sign2 * math.acos(arg);
  }
}

class _NumberRead {
  final double value;
  final int nextIndex;
  _NumberRead(this.value, this.nextIndex);
}

class _PointRead {
  final double x;
  final double y;
  final int nextIndex;
  _PointRead(this.x, this.y, this.nextIndex);
}
