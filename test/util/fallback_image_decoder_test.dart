import "dart:io";
import "dart:typed_data";

import "package:flutter_test/flutter_test.dart";
import "package:image/image.dart" as img;
import "package:miria/util/fallback_image_decoder.dart";

Uint8List read(String name) =>
    File("test/assets/images/formats/$name").readAsBytesSync();

void main() {
  group("decodeFallbackImageSync", () {
    // Skiaが読めない形式。エンジンの更新で読めるようになっても
    // 誰も教えてくれないので、ここで拾えることを固定しておく。
    for (final name in const [
      "sample.pgm",
      "sample.ppm",
      "sample.tga",
      "sample.tiff",
      "sample.pbm",
      "sample_ascii.pbm",
      "sample.v",
      "sample.mng",
    ]) {
      test("$name をPNGに焼き直せる", () {
        final png = decodeFallbackImageSync(read(name));
        expect(png, isNotNull);
        final decoded = img.decodePng(png!);
        expect(decoded, isNotNull);
        expect(decoded!.width, 8);
        expect(decoded.height, 8);
      });
    }

    test("Skiaが読める形式も通る", () {
      expect(decodeFallbackImageSync(read("sample.png")), isNotNull);
    });

    test("画像でないものはnullを返す", () {
      expect(
        decodeFallbackImageSync(
          Uint8List.fromList("this is not an image".codeUnits),
        ),
        isNull,
      );
    });
  });

  group("decodePbm", () {
    test("P1とP4で同じ絵になる", () {
      final binary = decodePbm(read("sample.pbm"));
      final ascii = decodePbm(read("sample_ascii.pbm"));
      expect(binary, isNotNull);
      expect(ascii, isNotNull);
      expect(ascii!.width, binary!.width);
      expect(ascii.height, binary.height);
      for (var y = 0; y < binary.height; y++) {
        for (var x = 0; x < binary.width; x++) {
          expect(
            ascii.getPixel(x, y).r,
            binary.getPixel(x, y).r,
            reason: "($x, $y) が一致しない",
          );
        }
      }
    });

    test("PBMでないものはnullを返す", () {
      expect(decodePbm(read("sample.png")), isNull);
    });

    test("寸法が壊れたヘッダはnullを返す", () {
      expect(
        decodePbm(Uint8List.fromList("P4\n99999999 99999999\n".codeUnits)),
        isNull,
      );
    });
  });

  group("decodeVips", () {
    test("vipsが書いた.vを読める", () {
      final image = decodeVips(read("sample.v"));
      expect(image, isNotNull);
      expect(image!.width, 8);
      expect(image.height, 8);
      // 地は白、対角線上だけ黒く塗ってある
      expect(image.getPixel(5, 2).r, greaterThan(200));
      expect(image.getPixel(4, 4).r, lessThan(100));
    });

    test("vipsでないものはnullを返す", () {
      expect(decodeVips(read("sample.png")), isNull);
    });

    test("バイト順を取り違えたヘッダはnullを返す", () {
      // SPARC側の並びに書き換える
      final bytes = Uint8List.fromList(read("sample.v"))
        ..setRange(0, 4, const [0x08, 0xf2, 0xa6, 0xb6]);
      // マジックは通るが、以降のフィールドがビッグエンディアンとして
      // 読まれるので、寸法の検査で弾かれる
      expect(decodeVips(bytes), isNull);
    });
  });

  group("decodeMngFirstFrame", () {
    test("MNGの最初のフレームを取り出せる", () {
      final image = decodeMngFirstFrame(read("sample.mng"));
      expect(image, isNotNull);
      expect(image!.width, 8);
      expect(image.height, 8);
    });

    test("MNGでないものはnullを返す", () {
      expect(decodeMngFirstFrame(read("sample.png")), isNull);
    });

    test("MHDRだけで中身のないMNGはnullを返す", () {
      final bytes = read("sample.mng");
      final ihdr = _indexOfChunk(bytes, "IHDR");
      expect(ihdr, isNot(-1));
      expect(decodeMngFirstFrame(bytes.sublist(0, ihdr)), isNull);
    });
  });

  group("decodeFallbackImage", () {
    test("JPEG XL は Rust 側で読める", () async {
      final png = await decodeFallbackImage(read("sample.jxl"));
      expect(png, isNotNull);
      final decoded = img.decodePng(png!);
      expect(decoded, isNotNull);
      expect(decoded!.width, 8);
      expect(decoded.height, 8);
      // 地は白、対角線上だけ黒く塗ってある
      expect(decoded.getPixel(5, 2).r, greaterThan(200));
      expect(decoded.getPixel(4, 4).r, lessThan(100));
    });

    test("JPEG XL は Dart 側だけでは読めない", () {
      expect(decodeFallbackImageSync(read("sample.jxl")), isNull);
    });
  });
}

int _indexOfChunk(Uint8List bytes, String type) {
  final needle = type.codeUnits;
  for (var i = 8; i + 4 <= bytes.length; i++) {
    if (bytes[i] == needle[0] &&
        bytes[i + 1] == needle[1] &&
        bytes[i + 2] == needle[2] &&
        bytes[i + 3] == needle[3]) {
      return i - 4;
    }
  }
  return -1;
}
