

import 'dart:io';
import 'dart:typed_data';

import 'package:agg/src/agg/image/image_buffer.dart';

/// TGA file format I/O for reading and writing TGA images.
class ImageTgaIO {
  // TGA header size in bytes
  static const int _targaHeaderSize = 18;

  // Color channel offsets in BGR order (TGA uses BGR)
  static const int _rgbBlue = 0;
  static const int _rgbGreen = 1;
  static const int _rgbRed = 2;
  static const int _rgbaAlpha = 3;

  // RLE compression flags
  static const int _isPixelRun = 0x80;
  static const int _runLengthMask = 0x7f;

  /// TGA file header structure.
  static _TargaHeader _readTgaInfo(Uint8List data) {
    final header = _TargaHeader(
      postHeaderSkip: data[0],
      colorMapType: data[1],
      imageType: data[2],
      colorMapStart: _readUint16(data, 3),
      colorMapLength: _readUint16(data, 5),
      colorMapBits: data[7],
      xStart: _readUint16(data, 8),
      yStart: _readUint16(data, 10),
      width: _readUint16(data, 12),
      height: _readUint16(data, 14),
      bpp: data[16],
      descriptor: data[17],
    );

    // Validate header
    if (header.colorMapType != 0 ||
        (header.imageType != 2 && header.imageType != 10 && header.imageType != 9) ||
        (header.bpp != 24 && header.bpp != 32)) {
      throw FormatException('Unsupported TGA format: '
          'colorMapType=${header.colorMapType}, '
          'imageType=${header.imageType}, '
          'bpp=${header.bpp}');
    }

    return header;
  }

  static int _readUint16(Uint8List data, int offset) {
    return data[offset] | (data[offset + 1] << 8);
  }

  static void _writeUint16(ByteData data, int offset, int value) {
    data.setUint16(offset, value, Endian.little);
  }

  /// Convert 24-bit source to 32-bit destination.
  static void _do24To32Bit(Uint8List dest, int destOffset, Uint8List source, int sourceOffset, int width) {
    if (width > 0) {
      for (int i = 0; i < width; i++) {
        dest[destOffset + i * 4 + _rgbBlue] = source[sourceOffset + _rgbBlue];
        dest[destOffset + i * 4 + _rgbGreen] = source[sourceOffset + _rgbGreen];
        dest[destOffset + i * 4 + _rgbRed] = source[sourceOffset + _rgbRed];
        dest[destOffset + i * 4 + 3] = 255;
        sourceOffset += 3;
      }
    }
  }

  /// Convert 32-bit source to 32-bit destination.
  static void _do32To32Bit(Uint8List dest, int destOffset, Uint8List source, int sourceOffset, int width) {
    if (width > 0) {
      for (int i = 0; i < width; i++) {
        dest[destOffset + _rgbBlue] = source[sourceOffset + _rgbBlue];
        dest[destOffset + _rgbGreen] = source[sourceOffset + _rgbGreen];
        dest[destOffset + _rgbRed] = source[sourceOffset + _rgbRed];
        dest[destOffset + _rgbaAlpha] = source[sourceOffset + _rgbaAlpha];
        sourceOffset += 4;
        destOffset += 4;
      }
    }
  }

  /// Decompress RLE encoded TGA data.
  static int _decompress(
    Uint8List decompressBits,
    Uint8List bitsToParse,
    int parseOffset,
    int width,
    int depth,
    int lineBeingRead,
  ) {
    int decompressOffset = 0;
    int total = 0;

    do {
      final numPixels = (bitsToParse[parseOffset] & _runLengthMask) + 1;
      total += numPixels;

      if ((bitsToParse[parseOffset++] & _isPixelRun) != 0) {
        // Decompress the run for NumPixels
        final b = bitsToParse[parseOffset++];
        final g = bitsToParse[parseOffset++];
        final r = bitsToParse[parseOffset++];

        switch (depth) {
          case 24:
            for (int i = 0; i < numPixels; i++) {
              decompressBits[decompressOffset++] = b;
              decompressBits[decompressOffset++] = g;
              decompressBits[decompressOffset++] = r;
            }
            break;

          case 32:
            final a = bitsToParse[parseOffset++];
            for (int i = 0; i < numPixels; i++) {
              decompressBits[decompressOffset++] = b;
              decompressBits[decompressOffset++] = g;
              decompressBits[decompressOffset++] = r;
              decompressBits[decompressOffset++] = a;
            }
            break;

          default:
            throw Exception('Bad bit depth: $depth');
        }
      } else {
        // Store NumPixels normally
        switch (depth) {
          case 24:
            for (int i = 0; i < numPixels * 3; i++) {
              decompressBits[decompressOffset++] = bitsToParse[parseOffset++];
            }
            break;

          case 32:
            for (int i = 0; i < numPixels * 4; i++) {
              decompressBits[decompressOffset++] = bitsToParse[parseOffset++];
            }
            break;

          default:
            throw Exception('Bad bit depth: $depth');
        }
      }
    } while (total < width);

    if (total > width) {
      throw Exception('The TGA you loaded is corrupt (line $lineBeingRead).');
    }

    return parseOffset;
  }

  /// Load TGA image from buffer and create a new ImageBuffer.
  /// Returns null if loading fails.
  static ImageBuffer? loadFromBuffer(Uint8List wholeFileBuffer) {
    try {
      final targaHeader = _readTgaInfo(wholeFileBuffer);
      
      // Create ImageBuffer with 32-bit depth
      final image = ImageBuffer(targaHeader.width, targaHeader.height);
      
      final bytesPerLine = targaHeader.width * 4; // Always 32-bit output
      
      Uint8List? bufferToDecompressTo;
      int fileReadOffset = _targaHeaderSize + targaHeader.postHeaderSkip;

      if (targaHeader.imageType == 10) {
        // 10 is RLE compressed
        final sourceBytesPerLine = targaHeader.width * (targaHeader.bpp ~/ 8);
        bufferToDecompressTo = Uint8List(sourceBytesPerLine * 2);
      }

      final imageBuffer = image.getBuffer();

      // Read all the lines
      for (int i = 0; i < targaHeader.height; i++) {
        Uint8List bufferToCopyFrom;
        int copyOffset = 0;
        int curReadLine;

        // Bit 5 tells us if the image is stored top to bottom or bottom to top
        if ((targaHeader.descriptor & 0x20) != 0) {
          // Bottom to top
          curReadLine = targaHeader.height - i - 1;
        } else {
          // Top to bottom
          curReadLine = i;
        }

        if (targaHeader.imageType == 10) {
          // 10 is RLE compressed
          fileReadOffset = _decompress(
            bufferToDecompressTo!,
            wholeFileBuffer,
            fileReadOffset,
            targaHeader.width,
            targaHeader.bpp,
            curReadLine,
          );
          bufferToCopyFrom = bufferToDecompressTo;
        } else {
          bufferToCopyFrom = wholeFileBuffer;
          copyOffset = fileReadOffset;
        }

        final destOffset = curReadLine * bytesPerLine;

        switch (targaHeader.bpp) {
          case 24:
            _do24To32Bit(imageBuffer, destOffset, bufferToCopyFrom, copyOffset, targaHeader.width);
            break;
          case 32:
            _do32To32Bit(imageBuffer, destOffset, bufferToCopyFrom, copyOffset, targaHeader.width);
            break;
        }

        if (targaHeader.imageType != 10) {
          // 10 is RLE compressed
          fileReadOffset += targaHeader.width * (targaHeader.bpp ~/ 8);
        }
      }

      return image;
    } catch (e) {
      return null;
    }
  }

  /// Save image to a file by path.
  static bool save(ImageBuffer image, String fileNameToSaveTo) {
    final file = File(fileNameToSaveTo);
    final sink = file.openSync(mode: FileMode.write);
    try {
      return saveToStream(image, sink);
    } finally {
      sink.closeSync();
    }
  }

  /// Save image to a stream.
  static bool saveToStream(ImageBuffer image, RandomAccessFile sink) {
    final sourceDepth = image.bitDepth;

    // Make sure there is something to save before writing
    if (image.width <= 0 || image.height <= 0) {
      return false;
    }

    // Set up the header
    final headerData = ByteData(_targaHeaderSize);

    headerData.setUint8(0, 0); // PostHeaderSkip
    headerData.setUint8(1, 0); // ColorMapType = RGB
    headerData.setUint8(2, 2); // ImageType = RGB (not RLE)
    _writeUint16(headerData, 3, 0); // ColorMapStart
    _writeUint16(headerData, 5, 0); // ColorMapLength
    headerData.setUint8(7, 0); // ColorMapBits
    _writeUint16(headerData, 8, 0); // XStart
    _writeUint16(headerData, 10, 0); // YStart
    _writeUint16(headerData, 12, image.width); // Width
    _writeUint16(headerData, 14, image.height); // Height
    headerData.setUint8(16, sourceDepth); // BPP
    headerData.setUint8(17, 0); // Descriptor

    sink.writeFromSync(headerData.buffer.asUint8List());

    final buffer = image.getBuffer();

    switch (sourceDepth) {
      case 24:
        for (int i = 0; i < image.height; i++) {
          final offset = image.getBufferOffsetY(i);
          sink.writeFromSync(buffer.buffer.asUint8List(
            buffer.offsetInBytes + offset,
            image.width * 3,
          ));
        }
        break;

      case 32:
        for (int i = 0; i < image.height; i++) {
          final offset = image.getBufferOffsetY(i);
          sink.writeFromSync(buffer.buffer.asUint8List(
            buffer.offsetInBytes + offset,
            image.width * 4,
          ));
        }
        break;

      default:
        throw UnsupportedError('Unsupported bit depth: $sourceDepth');
    }

    return true;
  }

  /// Load TGA image from file.
  static ImageBuffer? loadImageData(String fileName) {
    final file = File(fileName);
    if (file.existsSync()) {
      final data = file.readAsBytesSync();
      return loadFromBuffer(data);
    }
    return null;
  }

  /// Load TGA image from bytes.
  static ImageBuffer? loadImageDataFromBytes(Uint8List bytes) {
    return loadFromBuffer(bytes);
  }

  /// Get bit depth from file.
  static int getBitDepthFromFile(String fileName) {
    final file = File(fileName);
    if (file.existsSync()) {
      final headerData = file.openSync().readSync(_targaHeaderSize);
      try {
        final header = _readTgaInfo(headerData);
        return header.bpp;
      } catch (e) {
        return 0;
      }
    }
    return 0;
  }

  /// Get dimensions from file.
  static ({int width, int height})? getDimensionsFromFile(String fileName) {
    final file = File(fileName);
    if (file.existsSync()) {
      final headerData = file.openSync().readSync(_targaHeaderSize);
      try {
        final header = _readTgaInfo(headerData);
        return (width: header.width, height: header.height);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}

/// TGA file header structure.
class _TargaHeader {
  final int postHeaderSkip;
  final int colorMapType; // 0 = RGB, 1 = Palette
  final int imageType; // 1 = Palette, 2 = RGB, 3 = mono, 9 = RLE Palette, 10 = RLE RGB, 11 RLE mono
  final int colorMapStart;
  final int colorMapLength;
  final int colorMapBits;
  final int xStart; // Offsets the image would like to have (ignored)
  final int yStart; // Offsets the image would like to have (ignored)
  final int width;
  final int height;
  final int bpp; // Bit depth of the image
  final int descriptor;

  _TargaHeader({
    required this.postHeaderSkip,
    required this.colorMapType,
    required this.imageType,
    required this.colorMapStart,
    required this.colorMapLength,
    required this.colorMapBits,
    required this.xStart,
    required this.yStart,
    required this.width,
    required this.height,
    required this.bpp,
    required this.descriptor,
  });
}
