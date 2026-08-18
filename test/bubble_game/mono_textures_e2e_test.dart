import "dart:io";

import "package:dio/dio.dart";
import "package:flutter_test/flutter_test.dart";
import "package:miria/model/bubble_game/mono.dart";
import "package:miria/model/bubble_game/monos.dart";
import "package:miria/view/games_page/bubble_game/mono_textures.dart";

/// モノの画像を実際のMisskeyから読めるかを確かめる。
///
/// 画像のパスは本家のフロントエンドの定義をそのまま使っているので、
/// サーバーの`/client-assets/`と食い違っていないかはここでしか分からない。
/// サーバーが要るので、環境変数が無いときは丸ごとスキップする。
///
/// ```
/// MISSKEY_HOST=localhost:3000 fvm flutter test \
///   test/bubble_game/mono_textures_e2e_test.dart
/// ```
void main() {
  // 画像のデコードにエンジンが要る
  TestWidgetsFlutterBinding.ensureInitialized();

  final host = Platform.environment["MISSKEY_HOST"];
  final scheme = Platform.environment["MISSKEY_SCHEME"] ?? "http";

  group(
    "MonoTextures",
    () {
      final uri = Uri.parse("$scheme://$host");

      for (final entry in {
        BubbleGameMode.normal: normalMonos,
        BubbleGameMode.yen: yenMonos,
        BubbleGameMode.square: squareMonos,
        BubbleGameMode.sweets: sweetsMonos,
      }.entries) {
        test("${entry.key.apiValue}モードの画像を全部読めること", () async {
          // flutter_testはHttpClientを差し替えて通信を止めるので、本物に戻す
          final textures = await HttpOverrides.runWithHttpOverrides(
            () => MonoTextures.load(dio: Dio(), host: uri, monos: entry.value),
            _RealHttpOverrides(),
          );
          addTearDown(textures.dispose);

          for (final mono in entry.value) {
            final image = textures[mono];
            expect(image, isNotNull, reason: "${mono.img} が読めていない");
            expect(image!.width, greaterThan(0));
            expect(image.height, greaterThan(0));
          }
        });
      }
    },
    skip: host == null ? "MISSKEY_HOST が要る (test/bubble_game/README.md)" : null,
  );
}

/// 何も上書きしない[HttpOverrides]は既定の (本物の) クライアントを返す。
class _RealHttpOverrides extends HttpOverrides {}
