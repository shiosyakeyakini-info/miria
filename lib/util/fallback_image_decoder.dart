import "dart:isolate";
import "dart:typed_data";

import "package:image/image.dart" as img;

/// Skiaが読めなかった画像をDart側で読み直してPNGに焼き直す
///
/// Flutterの画像デコードはプラットフォーム任せなので、読める形式が
/// 環境によって違う。iOSとmacOSはImageIOが、AndroidはSkiaと
/// プラットフォームのコーデックが面倒を見るが、LinuxとWindowsは
/// Skiaが持っているものしか読めない。
/// ここではその差を package:image で埋める。
///
/// 読めなければ null を返す。
Future<Uint8List?> decodeFallbackImage(Uint8List bytes) =>
    Isolate.run(() => decodeFallbackImageSync(bytes));

/// [decodeFallbackImage] の同期版（テスト用）
Uint8List? decodeFallbackImageSync(Uint8List bytes) {
  final image = _decode(bytes);
  if (image == null) return null;
  try {
    return img.encodePng(image);
  } catch (_) {
    return null;
  }
}

img.Image? _decode(Uint8List bytes) {
  try {
    final decoded = img.findDecoderForData(bytes)?.decode(bytes);
    if (decoded != null) return decoded;
  } catch (_) {
    // 次の手に進む
  }
  try {
    return decodePbm(bytes);
  } catch (_) {
    return null;
  }
}

bool _isSpace(int c) => c == 0x20 || (c >= 0x09 && c <= 0x0d); // 空白・タブ・改行の類

/// PBM（P1 / P4）を読む
///
/// package:image の PnmDecoder は P2/P3/P5/P6 しか扱わないので、
/// 1bitビットマップの P1 / P4 だけ自前で補う。
img.Image? decodePbm(Uint8List bytes) {
  if (bytes.length < 2 || bytes[0] != 0x50) return null; // 'P'
  final isBinary = switch (bytes[1]) {
    0x31 => false, // P1: ASCII
    0x34 => true, // P4: バイナリ
    _ => null,
  };
  if (isBinary == null) return null;

  var pos = 2;

  void skipSpaceAndComment() {
    while (pos < bytes.length) {
      if (_isSpace(bytes[pos])) {
        pos++;
      } else if (bytes[pos] == 0x23) {
        // '#' から行末までコメント
        while (pos < bytes.length && bytes[pos] != 0x0a) {
          pos++;
        }
      } else {
        break;
      }
    }
  }

  int? readInt() {
    skipSpaceAndComment();
    var value = 0;
    var digits = 0;
    while (pos < bytes.length && bytes[pos] >= 0x30 && bytes[pos] <= 0x39) {
      value = value * 10 + (bytes[pos] - 0x30);
      pos++;
      digits++;
      if (value > 1 << 24) return null;
    }
    return digits == 0 ? null : value;
  }

  final width = readInt();
  final height = readInt();
  if (width == null || height == null || width <= 0 || height <= 0) return null;
  // 壊れたヘッダで無闇にメモリを掴まないように
  if (width > 16383 || height > 16383) return null;

  final image = img.Image(width: width, height: height);

  if (isBinary) {
    // ヘッダの直後の空白1文字までがヘッダ
    if (pos < bytes.length && _isSpace(bytes[pos])) pos++;
    final rowBytes = (width + 7) ~/ 8;
    if (bytes.length - pos < rowBytes * height) return null;
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final bit = (bytes[pos + y * rowBytes + (x >> 3)] >> (7 - (x & 7))) & 1;
        final v = bit == 1 ? 0 : 255; // PBMは1が黒
        image.setPixelRgb(x, y, v, v, v);
      }
    }
  } else {
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        skipSpaceAndComment();
        if (pos >= bytes.length) return null;
        final c = bytes[pos++];
        if (c != 0x30 && c != 0x31) return null;
        final v = c == 0x31 ? 0 : 255;
        image.setPixelRgb(x, y, v, v, v);
      }
    }
  }

  return image;
}
