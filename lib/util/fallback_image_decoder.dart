import "dart:isolate";
import "dart:typed_data";

import "package:image/image.dart" as img;
import "package:miria/rust/api/image_codec.dart" as rust;
import "package:miria/util/rust_initialization.dart";

/// Skiaが読めなかった画像をDart側で読み直してPNGに焼き直す
///
/// Flutterの画像デコードはプラットフォーム任せなので、読める形式が
/// 環境によって違う。iOSとmacOSはImageIOが、AndroidはSkiaと
/// プラットフォームのコーデックが面倒を見るが、LinuxとWindowsは
/// Skiaが持っているものしか読めない。
/// ここではその差を package:image で埋める。
///
/// 読めなければ null を返す。
Future<Uint8List?> decodeFallbackImage(Uint8List bytes) async {
  final byDart = await Isolate.run(() => decodeFallbackImageSync(bytes));
  if (byDart != null) return byDart;
  return _decodeWithRust(bytes);
}

/// Dartだけで読める分を読む
///
/// Rust側は非同期にしか呼べないのでここには含まれない。
Uint8List? decodeFallbackImageSync(Uint8List bytes) {
  final image = _decode(bytes);
  if (image == null) return null;
  try {
    return img.encodePng(image);
  } catch (_) {
    return null;
  }
}

/// 上から順に試す。package:image が読めるものはそれに任せ、
/// 残りだけを自前で補う。
final _decoders = <img.Image? Function(Uint8List)>[
  (bytes) => img.findDecoderForData(bytes)?.decode(bytes),
  decodePbm,
  decodeVips,
  decodeMngFirstFrame,
];

img.Image? _decode(Uint8List bytes) {
  for (final decode in _decoders) {
    try {
      final decoded = decode(bytes);
      if (decoded != null) return decoded;
    } catch (_) {
      // 次の手に進む
    }
  }
  return null;
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

/// vipsのネイティブ形式（.v）を読む
///
/// ヘッダ64バイトの後ろに画素がそのまま並んでいるだけなので、
/// libvipsを持ってこなくても読める。ヘッダの後ろにvipsが書く
/// メタデータのXMLがぶら下がっているが、画素より後ろなので無視してよい。
///
/// 非圧縮・uchar・1/3/4バンドのものだけを対象にする。
/// それ以外（float、LABQ、RAD等）はnullを返す。
img.Image? decodeVips(Uint8List bytes) {
  const headerSize = 64;
  if (bytes.length < headerSize) return null;

  // Intelで書かれたものは b6 a6 f2 08 で始まる
  final Endian endian;
  if (bytes[0] == 0xb6 &&
      bytes[1] == 0xa6 &&
      bytes[2] == 0xf2 &&
      bytes[3] == 0x08) {
    endian = Endian.little;
  } else if (bytes[0] == 0x08 &&
      bytes[1] == 0xf2 &&
      bytes[2] == 0xa6 &&
      bytes[3] == 0xb6) {
    endian = Endian.big;
  } else {
    return null;
  }

  final header = ByteData.sublistView(bytes);
  final width = header.getUint32(4, endian);
  final height = header.getUint32(8, endian);
  final bands = header.getUint32(12, endian);
  final bandFormat = header.getUint32(20, endian);
  final coding = header.getUint32(24, endian);

  if (coding != 0) return null; // 0 = 非圧縮
  if (bandFormat != 0) return null; // 0 = uchar
  if (bands != 1 && bands != 3 && bands != 4) return null;
  if (width <= 0 || height <= 0 || width > 16383 || height > 16383) return null;
  if (bytes.length - headerSize < width * height * bands) return null;

  final image = img.Image(
    width: width,
    height: height,
    numChannels: bands == 4 ? 4 : 3,
  );
  var pos = headerSize;
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      switch (bands) {
        case 1:
          image.setPixelRgb(x, y, bytes[pos], bytes[pos], bytes[pos]);
        case 3:
          image.setPixelRgb(x, y, bytes[pos], bytes[pos + 1], bytes[pos + 2]);
        case 4:
          image.setPixelRgba(
            x,
            y,
            bytes[pos],
            bytes[pos + 1],
            bytes[pos + 2],
            bytes[pos + 3],
          );
      }
      pos += bands;
    }
  }
  return image;
}

/// MNGの最初のフレームだけを取り出す
///
/// MNGはPNGと同じチャンク構造なので、最初の IHDR から IEND までを
/// PNGとして組み直せば静止画として表示できる。
/// アニメーションもデルタフレームもJNGも扱わない。
img.Image? decodeMngFirstFrame(Uint8List bytes) {
  const signature = [0x8a, 0x4d, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a];
  if (bytes.length < signature.length) return null;
  for (var i = 0; i < signature.length; i++) {
    if (bytes[i] != signature[i]) return null;
  }

  // PNGとして意味のあるチャンクだけを拾う。MNG固有のもの（MHDR、
  // DEFI、TERM等）は捨てる。
  const pngChunks = {
    "IHDR",
    "PLTE",
    "tRNS",
    "gAMA",
    "cHRM",
    "sRGB",
    "iCCP",
    "bKGD",
    "pHYs",
    "tIME",
    "IDAT",
    "IEND",
  };

  final png = <int>[0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a];
  final chunks = ByteData.sublistView(bytes);
  var pos = signature.length;
  var started = false;

  while (pos + 8 <= bytes.length) {
    final length = chunks.getUint32(pos, Endian.big);
    final end = pos + 12 + length;
    if (length > bytes.length || end > bytes.length) return null;
    final type = String.fromCharCodes(bytes, pos + 4, pos + 8);

    if (type == "IHDR") started = true;
    if (started && pngChunks.contains(type)) {
      png.addAll(bytes.sublist(pos, end));
    }
    if (started && type == "IEND") break;
    pos = end;
  }

  if (!started) return null;
  return img.PngDecoder().decode(Uint8List.fromList(png));
}

/// Rust側のデコーダに回す
///
/// frb の呼び出しは専用のワーカースレッドで走るので、ここをアイソレートに
/// 逃がす必要はない。PNGへの焼き直しだけは重いので逃がす。
Future<Uint8List?> _decodeWithRust(Uint8List bytes) async {
  try {
    await ensureRustInitialized();
    for (final decode in [
      rust.decodeJpegXl,
      rust.decodeJpegXr,
      rust.decodeJpeg2000,
    ]) {
      final decoded = await decode(bytes: bytes);
      if (decoded != null) {
        return await Isolate.run(() => _encodePng(decoded));
      }
    }
    return null;
  } catch (_) {
    return null;
  }
}

Uint8List? _encodePng(rust.DecodedImage decoded) {
  try {
    return img.encodePng(
      img.Image.fromBytes(
        width: decoded.width,
        height: decoded.height,
        bytes: decoded.rgba.buffer,
        numChannels: 4,
      ),
    );
  } catch (_) {
    return null;
  }
}
