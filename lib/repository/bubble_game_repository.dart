import "package:miria/model/bubble_game/drop_and_fusion_game.dart";
import "package:miria/model/bubble_game/mono.dart";
import "package:miria/providers.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod/riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "bubble_game_repository.g.dart";

/// ハイスコアを保存しているレジストリのスコープ。本家と合わせている。
const _registryScope = ["dropAndFusionGame"];

/// バブルゲームのスコアまわりのAPI。
///
/// `bubble-game/ranking`はmisskey_dartにあるが、
/// `bubble-game/register`と`i/registry/*`は無いのでエンドポイントを直接叩く。
class BubbleGameRepository {
  const BubbleGameRepository(this._misskey);

  final Misskey _misskey;

  /// サーバー内ランキングを取得する。
  Future<List<BubbleGameRankingResponse>> ranking(
    BubbleGameMode gameMode,
  ) async {
    final response = await _misskey.bubbleGame.show(
      BubbleGameRankingRequest(gameMode: gameMode.apiValue),
    );
    return response.toList();
  }

  /// スコアをサーバーに登録する。
  ///
  /// サーバー側はシードの発行から5時間以内かどうかを見ているので、
  /// ゲーム開始時のシードをそのまま渡す必要がある。
  Future<void> register({
    required String seed,
    required int score,
    required BubbleGameMode gameMode,
    required List<BubbleGameLog> logs,
  }) async {
    await _misskey.apiService.post<dynamic>("bubble-game/register", {
      "seed": seed,
      "score": score,
      "gameMode": gameMode.apiValue,
      "gameVersion": DropAndFusionGame.gameVersion,
      "logs": DropAndFusionGame.serializeLogs(logs),
    });
  }

  /// 自分のハイスコアを取得する。まだ無ければnull。
  Future<int?> highScore(BubbleGameMode gameMode) async {
    try {
      final response = await _misskey.apiService.post<dynamic>(
        "i/registry/get",
        {"scope": _registryScope, "key": "highScore:${gameMode.apiValue}"},
      );
      return response is int ? response : null;
    } on MisskeyException catch (_) {
      // 未登録のときはNO_SUCH_KEYが返る
      return null;
    }
  }

  /// 自分のハイスコアを更新する。
  Future<void> setHighScore(BubbleGameMode gameMode, int score) async {
    await _misskey.apiService.post<dynamic>("i/registry/set", {
      "scope": _registryScope,
      "key": "highScore:${gameMode.apiValue}",
      "value": score,
    });
  }
}

@Riverpod(dependencies: [misskeyPostContext])
BubbleGameRepository bubbleGameRepository(Ref ref) =>
    BubbleGameRepository(ref.read(misskeyPostContextProvider));
