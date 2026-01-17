import 'dart:typed_data';
import 'package:dart_graphics/src/agg/image/rgba.dart';
import 'package:dart_graphics/src/agg/primitives/color.dart';

/// Blender that only updates a single color channel of the destination buffer.
///
/// The [channelIndex] argument follows RGBA ordering: 0 for red, 1 for green,
/// 2 for blue, and 3 for alpha. All other channels are left unmodified.
class BlenderSingleChannel implements IRecieveBlenderByte {
  BlenderSingleChannel(int channelIndex)
      : assert(channelIndex >= 0 && channelIndex <= 3),
        _channelIndex = channelIndex;

  final int _channelIndex;

  @override
  int get numPixelBits => 32;

  @override
  Color pixelToColor(Uint8List buffer, int bufferOffset) {
    final int r = buffer[bufferOffset];
    final int g = buffer[bufferOffset + 1];
    final int b = buffer[bufferOffset + 2];
    final int a = buffer[bufferOffset + 3];
    return Color.fromRgba(r, g, b, a);
  }

  int _valueForChannel(Color color) {
    switch (_channelIndex) {
      case 0:
        return color.red;
      case 1:
        return color.green;
      case 2:
        return color.blue;
      case 3:
        return color.alpha;
      default:
        return color.red;
    }
  }

  void _blendOne(Uint8List buffer, int bufferOffset, int value, int alpha) {
    final int channelOffset = bufferOffset + _channelIndex;

    if (alpha <= 0) {
      return;
    }

    if (alpha >= 255) {
      buffer[channelOffset] = value;
      if (_channelIndex == 3) {
        // When writing alpha we also ensure the stored alpha matches.
        buffer[bufferOffset + 3] = value;
      }
      return;
    }

    final int dst = buffer[channelOffset];
    final int blended = ((value * alpha) + (dst * (255 - alpha)) + 127) ~/ 255;
    buffer[channelOffset] = blended;
    if (_channelIndex == 3) {
      buffer[bufferOffset + 3] = blended;
    }
  }

  @override
  void copyPixels(
      Uint8List buffer, int bufferOffset, Color sourceColor, int count) {
    final int value = _valueForChannel(sourceColor);
    final int alpha = sourceColor.alpha;
    for (int i = 0; i < count; i++) {
      _blendOne(buffer, bufferOffset + i * 4, value, alpha);
    }
  }

  @override
  void blendPixel(Uint8List buffer, int bufferOffset, Color sourceColor) {
    _blendOne(
        buffer, bufferOffset, _valueForChannel(sourceColor), sourceColor.alpha);
  }

  @override
  void blendPixels(
    Uint8List buffer,
    int bufferOffset,
    List<Color> sourceColors,
    int sourceColorsOffset,
    Uint8List sourceCovers,
    int sourceCoversOffset,
    bool firstCoverForAll,
    int count,
  ) {
    if (count <= 0) {
      return;
    }

    if (firstCoverForAll) {
      final int cover = sourceCovers[sourceCoversOffset];
      for (int i = 0; i < count; i++) {
        final color = sourceColors[sourceColorsOffset + i];
        final int alpha = (color.alpha * cover + 127) ~/ 255;
        _blendOne(buffer, bufferOffset + i * 4, _valueForChannel(color), alpha);
      }
    } else {
      for (int i = 0; i < count; i++) {
        final color = sourceColors[sourceColorsOffset + i];
        final int cover = sourceCovers[sourceCoversOffset + i];
        final int alpha = (color.alpha * cover + 127) ~/ 255;
        _blendOne(buffer, bufferOffset + i * 4, _valueForChannel(color), alpha);
      }
    }
  }

  @override
  Color blend(Color start, Color blend) {
    final result = Color.fromColor(start);
    final int alpha = blend.alpha;
    final int value = _valueForChannel(blend);

    int startComponent;
    switch (_channelIndex) {
      case 0:
        startComponent = start.red;
        break;
      case 1:
        startComponent = start.green;
        break;
      case 2:
        startComponent = start.blue;
        break;
      case 3:
        startComponent = start.alpha;
        break;
      default:
        startComponent = start.red;
        break;
    }

    int blendedValue;
    if (alpha <= 0) {
      blendedValue = startComponent;
    } else if (alpha >= 255) {
      blendedValue = value;
    } else {
      blendedValue =
          ((value * alpha) + (startComponent * (255 - alpha)) + 127) ~/ 255;
    }

    switch (_channelIndex) {
      case 0:
        result.red = blendedValue;
        break;
      case 1:
        result.green = blendedValue;
        break;
      case 2:
        result.blue = blendedValue;
        break;
      case 3:
        result.alpha = blendedValue;
        break;
    }

    return result;
  }
}
