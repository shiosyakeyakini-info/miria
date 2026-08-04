import "dart:async";

import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/reversi/reversi_game.dart";
import "package:miria/model/reversi/reversi_maps.dart";
import "package:miria/model/reversi/reversi_notation.dart";
import "package:miria/providers.dart";
import "package:miria/state_notifier/reversi/reversi_game_notifier.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/common/error_detail.dart";
import "package:miria/view/games_page/reversi/reversi_board.dart";
import "package:misskey_dart/misskey_dart.dart";

/// リバーシの対局画面。
///
/// 盤面はサーバーから送られてくるのではなく、移植したルールエンジンが
/// `log` イベントを積み上げて再現している。詳しくは
/// `lib/state_notifier/reversi/reversi_game_notifier.dart` を参照。
@RoutePage()
class ReversiGamePage extends ConsumerWidget implements AutoRouteWrapper {
  const ReversiGamePage({
    required this.accountContext,
    required this.gameId,
    super.key,
  });

  final AccountContext accountContext;
  final String gameId;

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  /// 投了は取り返しがつかないので、押し間違いを確認で止める。
  Future<void> _surrender(BuildContext context, WidgetRef ref) async {
    final result = await ref
        .read(dialogStateProvider.notifier)
        .showDialog(
          message: (context) => S.of(context).reversiConfirmSurrender,
          actions: (context) => [
            S.of(context).reversiSurrender,
            S.of(context).cancel,
          ],
        );
    if (result != 0) return;

    await ref.read(reversiGameProvider(gameId).notifier).surrender();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 開始前に相手が取り消したら、黙って固まらないよう知らせて一覧へ戻す。
    ref.listen(reversiGameProvider(gameId), (previous, next) {
      if (previous?.value?.canceled ?? true) return;
      if (!(next.value?.canceled ?? false)) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).reversiGameCanceled)),
      );
      unawaited(context.maybePop());
    });

    final state = ref.watch(reversiGameProvider(gameId));

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).reversi),
        actions: [
          if (state.value?.game.isStarted ?? false)
            if (!(state.value?.game.isEnded ?? true))
              TextButton(
                onPressed: () async => _surrender(context, ref),
                child: Text(S.of(context).reversiSurrender),
              ),
        ],
      ),
      body: switch (state) {
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
        AsyncError(:final error, :final stackTrace) => Center(
          child: ErrorDetail(error: error, stackTrace: stackTrace),
        ),
        AsyncData(:final value) => _ReversiGameBody(
          state: value,
          gameId: gameId,
        ),
      },
    );
  }
}

class _ReversiGameBody extends ConsumerWidget {
  const _ReversiGameBody({required this.state, required this.gameId});

  final ReversiGameState state;
  final String gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 棋譜を見ている間は巻き戻した盤面を出す。
    final engine = state.displayEngine;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            S
                .of(context)
                .reversiVersus(state.opponent.name ?? state.opponent.username),
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          _StatusLine(state: state),
          if (state.desynced) ...[
            const SizedBox(height: 8),
            Text(
              S.of(context).reversiDesynced,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 16),
          if (engine == null)
            _SettingsPanel(state: state, gameId: gameId)
          else ...[
            _ScoreLine(state: state, engine: engine),
            const SizedBox(height: 12),
            ReversiBoard(
              game: engine,
              lastPos: engine.prevPos == -1 ? null : engine.prevPos,
              // 石を持ち主のアバターにする。どちらの色が誰かは上のスコア行で
              // 示しているので、盤面だけ見ても持ち主が追える。
              blackAvatarUrl: state.blackUser?.avatarUrl,
              whiteAvatarUrl: state.whiteUser?.avatarUrl,
              // 印を出すのは自分の手番のときだけ。相手の手番や棋譜の再生中に
              // 着手可能マスを出すと誤操作しか生まない。
              puttable: !state.isReviewing && state.isMyTurn
                  ? engine.getPuttablePlaces(engine.turn!)
                  : const [],
              onTapCell: (pos) =>
                  ref.read(reversiGameProvider(gameId).notifier).putStone(pos),
            ),
            if (state.moveCount > 0) ...[
              const SizedBox(height: 16),
              _KifuPanel(state: state, gameId: gameId),
            ],
          ],
        ],
      ),
    );
  }
}

/// どちらの色が誰か、いま何対何かを出す。
///
/// 石を持ち主のアバターにした以上、色とユーザーの対応がどこかに要る。
/// 石とまったく同じ [ReversiStone] を並べているので、盤面の石と見比べれば
/// どちらの持ち物か分かる。
class _ScoreLine extends StatelessWidget {
  const _ScoreLine({required this.state, required this.engine});

  final ReversiGameState state;
  final ReversiGame engine;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PlayerScore(
          user: state.blackUser,
          color: Colors.black,
          count: engine.blackCount,
          isTurn: !state.isReviewing && engine.turn == reversiBlack,
          remain: state.turnRemain,
        ),
        const SizedBox(height: 4),
        _PlayerScore(
          user: state.whiteUser,
          color: Colors.white,
          count: engine.whiteCount,
          isTurn: !state.isReviewing && engine.turn == reversiWhite,
          remain: state.turnRemain,
        ),
      ],
    );
  }
}

class _PlayerScore extends StatelessWidget {
  const _PlayerScore({
    required this.user,
    required this.color,
    required this.count,
    required this.isTurn,
    required this.remain,
  });

  final UserLite? user;
  final Color color;
  final int count;
  final bool isTurn;

  /// 手番の残り秒。制限時間が無ければ null。手番の側だけに出す。
  final int? remain;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = this.user;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isTurn ? theme.colorScheme.primaryContainer : null,
      ),
      child: Row(
        children: [
          ReversiStone(diameter: 28, color: color, avatarUrl: user?.avatarUrl),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              user?.name ?? user?.username ?? "",
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isTurn && remain != null) ...[
            const SizedBox(width: 8),
            Text(
              S.of(context).reversiSeconds(remain!),
              style: theme.textTheme.bodySmall?.copyWith(
                // 残りわずかなときだけ色で急かす。
                color: remain! <= 10 ? theme.colorScheme.error : null,
              ),
            ),
          ],
          const SizedBox(width: 8),
          Text("$count", style: theme.textTheme.titleLarge),
        ],
      ),
    );
  }
}

/// 棋譜。打たれた手を並べ、選んだところまで盤面を巻き戻して見せる。
///
/// 盤面はサーバーから来た `logs` を移植したエンジンで打ち直して作っている
/// （`ReversiGameNotifier.review`）ので、対局に参加していなくても、アプリを
/// 再起動したあとでも同じように再生できる。
class _KifuPanel extends ConsumerWidget {
  const _KifuPanel({required this.state, required this.gameId});

  final ReversiGameState state;
  final String gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(reversiGameProvider(gameId).notifier);
    final current = state.reviewIndex ?? state.moveCount;
    final moves = state.moves;
    final mapWidth = state.displayEngine?.mapWidth ?? 8;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              S.of(context).reversiKifu,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const Spacer(),
            Text(
              key: const Key("reversi-kifu-progress"),
              S.of(context).reversiKifuProgress(current, state.moveCount),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              key: const Key("reversi-kifu-first"),
              icon: const Icon(Icons.first_page),
              tooltip: S.of(context).reversiKifuFirst,
              onPressed: current == 0 ? null : () => notifier.review(0),
            ),
            IconButton(
              key: const Key("reversi-kifu-prev"),
              icon: const Icon(Icons.chevron_left),
              tooltip: S.of(context).reversiKifuPrevious,
              onPressed: current == 0 ? null : () => notifier.reviewBy(-1),
            ),
            IconButton(
              key: const Key("reversi-kifu-next"),
              icon: const Icon(Icons.chevron_right),
              tooltip: S.of(context).reversiKifuNext,
              onPressed: current >= state.moveCount
                  ? null
                  : () => notifier.reviewBy(1),
            ),
            IconButton(
              key: const Key("reversi-kifu-last"),
              icon: const Icon(Icons.last_page),
              tooltip: S.of(context).reversiKifuLast,
              onPressed: current >= state.moveCount
                  ? null
                  : () => notifier.review(state.moveCount),
            ),
            if (state.isReviewing)
              // 巻き戻したままだと対局中の盤面が見えなくなるので、戻る道を
              // 明示的に用意する。最終手まで進めるのとは別物。
              TextButton(
                key: const Key("reversi-kifu-latest"),
                onPressed: () => notifier.review(null),
                child: Text(S.of(context).reversiKifuLatest),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            _KifuChip(
              index: 0,
              label: S.of(context).reversiKifuStart,
              selected: current == 0,
              onTap: () => notifier.review(0),
            ),
            for (var i = 0; i < moves.length; i++)
              _KifuChip(
                index: i + 1,
                label:
                    "${i + 1} ${moves[i].player ? "●" : "○"}"
                    "${reversiPosLabel(moves[i].pos, mapWidth)}",
                selected: current == i + 1,
                onTap: () => notifier.review(i + 1),
              ),
          ],
        ),
      ],
    );
  }
}

class _KifuChip extends StatelessWidget {
  const _KifuChip({
    required this.index,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final int index;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ActionChip(
      key: Key("reversi-kifu-move-$index"),
      label: Text(label),
      labelStyle: theme.textTheme.bodySmall?.copyWith(
        color: selected ? theme.colorScheme.onPrimary : null,
      ),
      backgroundColor: selected ? theme.colorScheme.primary : null,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: onTap,
    );
  }
}

/// 今なにが起きているかを 1 行で出す。
class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.state});

  final ReversiGameState state;

  @override
  Widget build(BuildContext context) {
    final String text;
    if (state.game.isEnded) {
      text = switch (state.isWinner) {
        true => S.of(context).reversiWin,
        false => S.of(context).reversiLose,
        null => S.of(context).reversiDraw,
      };
    } else if (!state.game.isStarted) {
      text = state.isMyReady
          ? S.of(context).reversiWaitingOpponent
          : S.of(context).reversiStarting;
    } else {
      text = state.isMyTurn
          ? S.of(context).reversiYourTurn
          : S.of(context).reversiOpponentTurn;
    }

    return Text(
      text,
      key: const Key("reversi-status"),
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}

/// 対局開始前の設定と準備完了。
///
/// 設定は `updateSettings` でその場で相手にも飛ぶ。サーバーは準備完了した
/// 側からの変更を弾く（`ReversiService.updateSettings`）ので、こちらも
/// 準備完了中は触れないようにしてある。
class _SettingsPanel extends ConsumerWidget {
  const _SettingsPanel({required this.state, required this.gameId});

  final ReversiGameState state;
  final String gameId;

  /// 制限時間の選択肢。本家と同じ。
  static const _timeLimits = [5, 10, 30, 60, 90, 120, 180, 3600];

  Future<void> _chooseMap(BuildContext context, WidgetRef ref) async {
    final categories = reversiMaps.map((e) => e.category).toSet().toList();

    final selected = await showModalBottomSheet<ReversiMap>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final category in categories) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Text(
                  category,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              for (final map in reversiMaps.where(
                (e) => e.category == category,
              ))
                ListTile(
                  key: Key("reversi-map-${map.name}"),
                  title: Text(map.name),
                  subtitle: map.author == null ? null : Text(map.author!),
                  onTap: () => Navigator.of(context).pop(map),
                ),
            ],
          ],
        ),
      ),
    );
    if (selected == null) return;

    ref
        .read(reversiGameProvider(gameId).notifier)
        .updateSettings("map", selected.data);
  }

  Future<void> _cancelGame(BuildContext context, WidgetRef ref) async {
    final result = await ref
        .read(dialogStateProvider.notifier)
        .showDialog(
          message: (context) => S.of(context).reversiConfirmCancelGame,
          actions: (context) => [
            S.of(context).reversiCancelGame,
            S.of(context).cancel,
          ],
        );
    if (result != 0) return;

    ref.read(reversiGameProvider(gameId).notifier).cancelGame();
    if (context.mounted) await context.maybePop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(reversiGameProvider(gameId).notifier);
    final game = state.game;
    // 準備完了のあいだはサーバーが変更を受け付けない。
    final locked = state.isMyReady;
    final mapName = findReversiMap(game.map)?.name;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.opponentChangedSettings)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              S.of(context).reversiOpponentChangedSettings,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
          ),
        Text(
          "${game.user1.username}: ${game.user1Ready ? "OK" : "..."} / "
          "${game.user2.username}: ${game.user2Ready ? "OK" : "..."}",
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          S.of(context).reversiGameSettings,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        ListTile(
          key: const Key("reversi-setting-map"),
          enabled: !locked,
          title: Text(S.of(context).reversiMap),
          trailing: Text(mapName ?? S.of(context).reversiMapCustom),
          onTap: locked ? null : () async => _chooseMap(context, ref),
        ),
        ListTile(
          enabled: !locked,
          title: Text(S.of(context).reversiBlackOrWhite),
          trailing: DropdownButton<String>(
            key: const Key("reversi-setting-bw"),
            value: game.bw,
            onChanged: locked
                ? null
                : (value) {
                    if (value != null) notifier.updateSettings("bw", value);
                  },
            items: [
              DropdownMenuItem(
                value: "random",
                child: Text(S.of(context).reversiBlackIsRandom),
              ),
              DropdownMenuItem(
                value: "1",
                child: Text(S.of(context).reversiBlackIs(game.user1.username)),
              ),
              DropdownMenuItem(
                value: "2",
                child: Text(S.of(context).reversiBlackIs(game.user2.username)),
              ),
            ],
          ),
        ),
        ListTile(
          enabled: !locked,
          title: Text(S.of(context).reversiTimeLimitForEachTurn),
          trailing: DropdownButton<int>(
            key: const Key("reversi-setting-timelimit"),
            value: _timeLimits.contains(game.timeLimitForEachTurn)
                ? game.timeLimitForEachTurn
                : null,
            onChanged: locked
                ? null
                : (value) {
                    if (value != null) {
                      notifier.updateSettings("timeLimitForEachTurn", value);
                    }
                  },
            items: [
              for (final seconds in _timeLimits)
                DropdownMenuItem(
                  value: seconds,
                  child: Text(S.of(context).reversiSeconds(seconds)),
                ),
            ],
          ),
        ),
        SwitchListTile(
          key: const Key("reversi-setting-llotheo"),
          title: Text(S.of(context).reversiIsLlotheo),
          value: game.isLlotheo,
          onChanged: locked
              ? null
              : (value) => notifier.updateSettings("isLlotheo", value),
        ),
        SwitchListTile(
          key: const Key("reversi-setting-looped"),
          title: Text(S.of(context).reversiLoopedMap),
          value: game.loopedBoard,
          onChanged: locked
              ? null
              : (value) => notifier.updateSettings("loopedBoard", value),
        ),
        SwitchListTile(
          key: const Key("reversi-setting-anywhere"),
          title: Text(S.of(context).reversiCanPutEverywhere),
          value: game.canPutEverywhere,
          onChanged: locked
              ? null
              : (value) => notifier.updateSettings("canPutEverywhere", value),
        ),
        if (locked)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              S.of(context).reversiSettingsLockedWhenReady,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        const SizedBox(height: 16),
        ElevatedButton(
          key: const Key("reversi-ready"),
          onPressed: () => notifier.ready(value: !state.isMyReady),
          child: Text(
            state.isMyReady
                ? S.of(context).reversiCancelReady
                : S.of(context).reversiReady,
          ),
        ),
        TextButton(
          key: const Key("reversi-cancel-game"),
          onPressed: () async => _cancelGame(context, ref),
          child: Text(S.of(context).reversiCancelGame),
        ),
      ],
    );
  }
}
