import "dart:io";

import "package:flutter_test/flutter_test.dart";
import "package:miria/model/bubble_game/drop_and_fusion_game.dart";
import "package:miria/model/bubble_game/mono.dart";
import "package:miria/repository/bubble_game_repository.dart";
import "package:misskey_dart/misskey_dart.dart";

/// 実際のMisskeyサーバーに対してスコア送信が通るかを確かめる。
///
/// 立てかたは`test/bubble_game/README.md`を参照。
/// サーバーが要るので、環境変数が無いときは丸ごとスキップする。
///
/// ```
/// MISSKEY_HOST=localhost:3000 MISSKEY_TOKEN=xxx fvm flutter test \
///   test/bubble_game/register_e2e_test.dart
/// ```
void main() {
  final host = Platform.environment["MISSKEY_HOST"];
  final token = Platform.environment["MISSKEY_TOKEN"];
  final scheme = Platform.environment["MISSKEY_SCHEME"] ?? "http";

  group(
    "bubble-game/register",
    () {
      // Miriaの`misskeyProvider`と同じ組み立てかたでクライアントを作る
      final misskey = Misskey(
        token: token ?? "",
        host: host ?? "",
        apiUrl: scheme == "http" ? "http://$host/api/" : null,
        streamingUrl: scheme == "http" ? "ws://$host/streaming/" : null,
        socketConnectionTimeout: const Duration(seconds: 20),
      );
      final repository = BubbleGameRepository(misskey);

      /// スコアの登録は30秒に1回までなので、弾かれたら待ってから送り直す。
      /// (レート制限はサーバーが本番モードのときだけ効く)
      Future<void> register(PlayResult result, BubbleGameMode gameMode) async {
        for (var attempt = 0; ; attempt++) {
          try {
            await repository.register(
              seed: result.seed,
              score: result.score,
              gameMode: gameMode,
              logs: result.logs,
            );
            return;
          } on MisskeyException catch (e) {
            if (e.code != "RATE_LIMIT_EXCEEDED" || attempt >= 4) rethrow;
            await Future<void>.delayed(const Duration(seconds: 31));
          }
        }
      }

      for (final gameMode in BubbleGameMode.values) {
        test(
          "${gameMode.apiValue}モードのスコアを登録できること",
          timeout: const Timeout(Duration(minutes: 3)),
          () async {
            final result = playForTest(gameMode);

            printOnFailure(
              "score=${result.score} frames=${result.frames} "
              "operations=${result.logs.length} gameOver=${result.isGameOver}",
            );
            expect(
              result.score,
              greaterThan(0),
              reason: "合体が起きずスコアが0のままだと登録の確認にならない",
            );

            await register(result, gameMode);

            final ranking = await repository.ranking(gameMode);
            expect(
              ranking.map((x) => x.score),
              contains(result.score),
              reason: "登録したスコアがランキングに載っていない",
            );

            await repository.setHighScore(gameMode, result.score);
            expect(await repository.highScore(gameMode), result.score);
          },
        );
      }

      test(
        "未来のシードはサーバーに弾かれること",
        timeout: const Timeout(Duration(minutes: 3)),
        () async {
          final future = DateTime.now().add(const Duration(hours: 1));

          // レート制限に当たると別のエラーになるので、そちらは待ってやり直す
          for (var attempt = 0; ; attempt++) {
            try {
              await repository.register(
                seed: future.millisecondsSinceEpoch.toString(),
                score: 100,
                gameMode: BubbleGameMode.normal,
                logs: const [],
              );
              fail("未来のシードが受け付けられてしまった");
            } on MisskeyException catch (e) {
              if (e.code == "RATE_LIMIT_EXCEEDED" && attempt < 4) {
                await Future<void>.delayed(const Duration(seconds: 31));
                continue;
              }
              expect(e.code, "INVALID_SEED");
              return;
            }
          }
        },
      );
    },
    skip: host == null || token == null
        ? "MISSKEY_HOST と MISSKEY_TOKEN が要る (test/bubble_game/README.md)"
        : null,
  );
}

class PlayResult {
  const PlayResult({
    required this.seed,
    required this.score,
    required this.frames,
    required this.logs,
    required this.isGameOver,
  });

  final String seed;
  final int score;
  final int frames;
  final List<BubbleGameLog> logs;
  final bool isGameOver;
}

/// 実際にゲームを進めてスコアと操作ログを作る。
///
/// サーバーはシードが発行から5時間以内かを見ているので、
/// アプリと同じく開始時刻をシードにする。
PlayResult playForTest(BubbleGameMode gameMode) {
  final seed = DateTime.now().millisecondsSinceEpoch.toString();
  final game = DropAndFusionGame(seed: seed, gameMode: gameMode)..start();

  // 同じあたりに積んでいくと合体するので、ゲームオーバーになるまで落とし続ける
  const maxFrames = 6000;
  for (var frame = 0; frame < maxFrames; frame++) {
    if (game.canDrop) {
      game.drop(180 + (frame % 5) * 20);
    }
    if (!game.tick()) break;
  }

  if (!game.isGameOver) game.surrender();

  return PlayResult(
    seed: seed,
    score: game.score,
    frames: game.frame,
    logs: game.getLogs(),
    isGameOver: game.isGameOver,
  );
}
