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
}
