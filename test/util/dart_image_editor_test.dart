import "dart:typed_data";

import "package:flutter_test/flutter_test.dart";
import "package:image/image.dart" as img;
import "package:image_editor/image_editor.dart";
import "package:miria/util/dart_image_editor.dart";

/// 左上に赤、右上に緑、左下に青、右下に白を置いた 4x4 のpng
Uint8List fourSquares() {
  final image = img.Image(width: 4, height: 4, numChannels: 4);
  for (var y = 0; y < 4; y++) {
    for (var x = 0; x < 4; x++) {
      final color = switch ((x < 2, y < 2)) {
        (true, true) => (255, 0, 0),
        (false, true) => (0, 255, 0),
        (true, false) => (0, 0, 255),
        (false, false) => (255, 255, 255),
      };
      image.setPixelRgba(x, y, color.$1, color.$2, color.$3, 255);
    }
  }
  return img.encodePng(image);
}

Future<img.Image> edit(
  Uint8List source,
  void Function(ImageEditorOption option) build,
) async {
  final option = ImageEditorOption()..outputFormat = const OutputFormat.png();
  build(option);
  final result = await DartImageEditor().editImage(
    image: source,
    imageEditorOption: option,
  );
  return img.decodePng(result!)!;
}

void main() {
  final source = fourSquares();

  test("画像として壊れていれば null を返す", () async {
    final result = await DartImageEditor().editImage(
      image: Uint8List.fromList([0, 1, 2, 3]),
      imageEditorOption: ImageEditorOption()..addOption(const RotateOption(90)),
    );
    expect(result, isNull);
  });

  test("切り抜ける", () async {
    final result = await edit(
      source,
      (option) =>
          option.addOption(const ClipOption(x: 2, y: 0, width: 2, height: 2)),
    );
    expect((result.width, result.height), equals((2, 2)));
    // 右上の緑だけが残る
    expect(result.getPixel(0, 0).g, equals(255));
    expect(result.getPixel(1, 1).r, equals(0));
  });

  test("時計回りに回る", () async {
    final result = await edit(
      source,
      (option) => option.addOption(const RotateOption(90)),
    );
    // 左上の赤が右上へ
    expect(result.getPixel(3, 0).r, equals(255));
    expect(result.getPixel(3, 0).b, equals(0));
    // 左下の青が左上へ
    expect(result.getPixel(0, 0).b, equals(255));
  });

  test("比率を保って拡縮する", () async {
    final result = await edit(
      source,
      (option) => option.addOption(const ScaleOption(8, 100, keepRatio: true)),
    );
    expect((result.width, result.height), equals((8, 8)));
  });

  test("色行列の平行移動は0-255スケールで効く", () async {
    // 青に 50 足す。ネイティブと同じスケールなら 0 -> 50 になる。
    final result = await edit(
      source,
      (option) => option.addOption(
        ColorOption(
          matrix: [
            1, 0, 0, 0, 0, //
            0, 1, 0, 0, 0, //
            0, 0, 1, 0, 50, //
            0, 0, 0, 1, 0, //
          ],
        ),
      ),
    );
    expect(result.getPixel(0, 0).b, equals(50));
    expect(result.getPixel(0, 0).r, equals(255));
    // 飽和しても振り切れない
    expect(result.getPixel(0, 2).b, equals(255));
  });

  test("色行列は端まで飽和させる", () async {
    final result = await edit(
      source,
      (option) => option.addOption(
        ColorOption(
          matrix: [
            1, 0, 0, 0, -300, //
            0, 1, 0, 0, 300, //
            0, 0, 1, 0, 0, //
            0, 0, 0, 1, 0, //
          ],
        ),
      ),
    );
    expect(result.getPixel(0, 0).r, equals(0));
    expect(result.getPixel(0, 0).g, equals(255));
  });

  test("複数のオプションは並び順に適用される", () async {
    final result = await edit(source, (option) {
      option.addOptions([
        const RotateOption(90),
        const ClipOption(x: 0, y: 0, width: 2, height: 2),
      ]);
    });
    // 90度回すと左上は青、そこを切り抜く
    expect((result.width, result.height), equals((2, 2)));
    expect(result.getPixel(0, 0).b, equals(255));
    expect(result.getPixel(1, 1).b, equals(255));
  });

  test("何もしないオプションは飛ばされる", () async {
    final result = await edit(source, (option) {
      option.addOptions([
        const RotateOption(360),
        const FlipOption(horizontal: false),
      ]);
    });
    expect((result.width, result.height), equals((4, 4)));
    expect(result.getPixel(0, 0).r, equals(255));
  });

  test("未対応のオプションは黙って無視しない", () async {
    expect(
      () => edit(
        source,
        (option) => option.addOption(
          AddTextOption()
            ..addText(EditorText(text: "みりあ", offset: Offset.zero)),
        ),
      ),
      throwsA(isA<UnimplementedError>()),
    );
  });
}
