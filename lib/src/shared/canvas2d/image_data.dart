/// HTML5 ImageData Interface
/// 
/// Reference: https://developer.mozilla.org/en-US/docs/Web/API/ImageData

import 'dart:typed_data';

/// Abstract ImageData Interface
/// 
/// Represents the underlying pixel data of an area of a canvas.
abstract class IImageData {
  /// Width of the image data in pixels
  int get width;
  
  /// Height of the image data in pixels
  int get height;
  
  /// A one-dimensional array containing the data in RGBA order
  /// Values are integers in the range 0-255
  Uint8ClampedList get data;
  
  /// The color space of the image data
  String get colorSpace;
}

/// Default implementation of ImageData
class ImageData implements IImageData {
  @override
  final int width;
  
  @override
  final int height;
  
  @override
  final Uint8ClampedList data;
  
  @override
  final String colorSpace;
  
  /// Creates a new ImageData with the specified dimensions
  /// Pixels are initialized to transparent black (0, 0, 0, 0)
  ImageData(this.width, this.height, {this.colorSpace = 'srgb'})
      : data = Uint8ClampedList(width * height * 4);
  
  /// Creates an ImageData from existing data
  ImageData.fromData(this.width, this.height, this.data, {this.colorSpace = 'srgb'});
  
  /// Gets the RGBA values at the specified pixel
  ({int r, int g, int b, int a}) getPixel(int x, int y) {
    if (x < 0 || x >= width || y < 0 || y >= height) {
      return (r: 0, g: 0, b: 0, a: 0);
    }
    final index = (y * width + x) * 4;
    return (
      r: data[index],
      g: data[index + 1],
      b: data[index + 2],
      a: data[index + 3],
    );
  }
  
  /// Sets the RGBA values at the specified pixel
  void setPixel(int x, int y, int r, int g, int b, int a) {
    if (x < 0 || x >= width || y < 0 || y >= height) return;
    final index = (y * width + x) * 4;
    data[index] = r;
    data[index + 1] = g;
    data[index + 2] = b;
    data[index + 3] = a;
  }
  
  /// Creates a copy of this ImageData
  ImageData clone() {
    return ImageData.fromData(width, height, Uint8ClampedList.fromList(data), colorSpace: colorSpace);
  }
}
