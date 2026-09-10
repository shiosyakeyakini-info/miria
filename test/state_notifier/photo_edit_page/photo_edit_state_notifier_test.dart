import "dart:typed_data";

import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:image/image.dart" as img;
import "package:miria/model/image_file.dart";
import "package:miria/providers.dart";
import "package:miria/state_notifier/photo_edit_page/photo_edit_state_notifier.dart";
import "package:miria/util/dart_image_editor.dart";

import "../../test_util/test_datas.dart";

/// 画像編集はimage_editorのネイティブ実装に乗っていて、テストの環境には
/// それがない。miriaが差し込むDart実装の上で編集画面が成立することを見る。
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;

  final source = () {
    final image = img.Image(width: 40, height: 20, numChannels: 4);
    for (final pixel in image) {
      pixel.setRgba(pixel.x < 20 ? 255 : 0, 0, pixel.y < 10 ? 255 : 0, 255);
    }
    return img.encodePng(image);
  }();

  setUpAll(registerDartImageEditor);

  setUp(() {
    final account = TestData.account;
    container = ProviderContainer(
      overrides: [
        accountContextProvider.overrideWithValue(
          AccountContext(getAccount: account, postAccount: account),
        ),
      ],
    );
  });

  tearDown(() => container.dispose());

  Future<PhotoEditStateNotifier> initialized() async {
    // 監視していないと非同期のあいだにproviderが捨てられる
    container.listen(photoEditStateProvider, (_, _) {});
    final notifier = container.read(photoEditStateProvider.notifier);
    await notifier.initialize(
      ImageFile(fileName: "test.png", data: Uint8List.fromList(source)),
    );
    return notifier;
  }

  test("Dart実装が刺さっていること", () {
    expect(isImageEditorAvailable, isTrue);
  });

  test("読み込むと元の大きさが入ること", () async {
    await initialized();
    final state = container.read(photoEditStateProvider);
    expect((
      state.defaultSize.width,
      state.defaultSize.height,
    ), equals((40.0, 20.0)));
    expect(state.editedImage, isNotNull);
  });

  test("回すと縦横が入れ替わること", () async {
    final notifier = await initialized();
    await notifier.rotate();

    final state = container.read(photoEditStateProvider);
    // 画面の回転は反時計回りで、時計回り270度として渡される
    expect(state.angle, equals(270));
    expect((
      state.defaultSize.width,
      state.defaultSize.height,
    ), equals((20.0, 40.0)));

    final rotated = img.decodeImage(state.editedImage!)!;
    expect((rotated.width, rotated.height), equals((20, 40)));
    // 左半分の赤が下半分へ移る
    expect(rotated.getPixel(0, 39).r, equals(255));
    expect(rotated.getPixel(0, 0).r, equals(0));
  });

  test("色調補正のプレビューが全種類つくられること", () async {
    final notifier = await initialized();
    await notifier.createPreviewImage();

    final previews = container
        .read(photoEditStateProvider)
        .colorFilterPreviewImages;
    expect(previews, isNotEmpty);
    expect(previews.every((preview) => preview.image != null), isTrue);
    // 300x300に収めた上で比率を保つので、40x20は300x150になる
    final preview = img.decodeImage(previews.first.image!)!;
    expect((preview.width, preview.height), equals((300, 150)));
  });

  test("色調補正を選ぶと編集結果が変わること", () async {
    final notifier = await initialized();
    final before = container.read(photoEditStateProvider).editedImage;

    await notifier.selectColorFilter("moon");

    final state = container.read(photoEditStateProvider);
    expect(state.adaptivePresets, contains("moon"));
    expect(state.editedImage, isNot(equals(before)));
    // moonはグレースケールを含むので、赤かったところの色が抜ける
    final filtered = img.decodeImage(state.editedImage!)!;
    final pixel = filtered.getPixel(0, 0);
    expect(pixel.r, closeTo(pixel.g, 8));
  });
}
