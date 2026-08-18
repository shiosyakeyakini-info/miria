import "dart:async";

import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/bubble_game/drop_and_fusion_game.dart";
import "package:miria/model/bubble_game/mono.dart";
import "package:miria/providers.dart";
import "package:miria/repository/bubble_game_repository.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/common/error_dialog_handler.dart";
import "package:miria/view/games_page/bubble_game/bubble_game_mode_extension.dart";
import "package:miria/view/games_page/bubble_game/bubble_game_painter.dart";
import "package:miria/view/games_page/bubble_game/bubble_game_sounds.dart";
import "package:miria/view/games_page/bubble_game/mono_textures.dart";
import "package:misskey_dart/misskey_dart.dart";

/// バブルゲーム(ドロップ&フュージョン)の本体。
@RoutePage()
class BubbleGamePlayPage extends ConsumerStatefulWidget
    implements AutoRouteWrapper {
  const BubbleGamePlayPage({
    required this.accountContext,
    required this.gameMode,
    super.key,
  });

  final AccountContext accountContext;
  final BubbleGameMode gameMode;

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  ConsumerState<BubbleGamePlayPage> createState() => _BubbleGamePlayPageState();
}

class _BubbleGamePlayPageState extends ConsumerState<BubbleGamePlayPage>
    with SingleTickerProviderStateMixin {
  /// 物理演算1ステップぶんの時間。本家と同じく60fps固定。
  static const _step = Duration(microseconds: 1000000 ~/ 60);

  /// 1フレームでまとめて進める上限。
  /// 端末が重いときにここが無いと際限なく追いつこうとしてさらに重くなる。
  static const _maxStepsPerFrame = 4;

  late DropAndFusionGame _game;
  late final Ticker _ticker;
  final _repaint = ValueNotifier<int>(0);

  MonoTextures? _textures;
  BubbleGameSounds? _sounds;
  Duration _lastElapsed = Duration.zero;
  Duration _accumulated = Duration.zero;

  double _dropperX = DropAndFusionGame.gameWidth / 2;
  int _score = 0;
  int _combo = 0;
  int? _highScore;
  bool _isGameOver = false;
  bool _isRegistering = false;

  @override
  void initState() {
    super.initState();
    _game = _createGame();
    _ticker = createTicker(_onTick)..start();
    unawaited(_loadTextures());
    unawaited(_loadSounds());
    unawaited(_loadHighScore());
  }

  @override
  void dispose() {
    _ticker.dispose();
    _repaint.dispose();
    _game.dispose();
    _textures?.dispose();
    unawaited(_sounds?.dispose());
    super.dispose();
  }

  DropAndFusionGame _createGame() {
    // シードは本家と同じく開始時刻。サーバーは発行から5時間以内かを見ている。
    final game = DropAndFusionGame(
      seed: DateTime.now().millisecondsSinceEpoch.toString(),
      gameMode: widget.gameMode,
    );

    game.onChangeScore = (score) {
      if (score != _score) setState(() => _score = score);
    };
    // コンボは毎フレーム通知されるので、変わったときだけ拾う
    game.onChangeCombo = (combo) {
      if (combo != _combo) setState(() => _combo = combo);
    };
    game.onChangeStock = (_) => setState(() {});
    game.onChangeHolding = (holding) {
      setState(() {});
      if (holding != null) _sounds?.playHold();
    };
    game.onDropped = (x) => _sounds?.playDrop(_pan(x));
    game.onFusioned = (fusion) {
      final next = fusion.next;
      if (next == null) return;
      _sounds?.playFusion(
        pan: _pan(fusion.x),
        pitch: next.sfxPitch,
        isYen: widget.gameMode == BubbleGameMode.yen,
      );
    };
    game.onCollision = (collision) => _sounds?.playCollision(
      energy: collision.energy,
      pan: _pan(collision.x),
      isYen: widget.gameMode == BubbleGameMode.yen,
    );
    game.onGameOver = _onGameOver;

    return game..start();
  }

  Future<void> _loadTextures() async {
    final account = widget.accountContext.postAccount;
    final textures = await MonoTextures.load(
      dio: ref.read(dioProvider),
      // httpのサーバーもあるので、アカウントのスキームをそのまま使う
      host: Uri(
        scheme: account.scheme ?? "https",
        host: account.host,
        port: account.port,
      ),
      monos: _game.monoDefinitions,
    );
    if (!mounted) {
      textures.dispose();
      return;
    }
    setState(() => _textures = textures);
  }

  Future<void> _loadSounds() async {
    final account = widget.accountContext.postAccount;
    final settings = ref.read(generalSettingsRepositoryProvider).settings;
    final sounds = await BubbleGameSounds.load(
      cacheManager: ref.read(cacheManagerProvider),
      host: Uri(
        scheme: account.scheme ?? "https",
        host: account.host,
        port: account.port,
      ),
      gameMode: widget.gameMode,
    );
    if (!mounted) {
      await sounds.dispose();
      return;
    }
    sounds
      ..bgmVolume = settings.bubbleGameBgmVolume
      ..sfxVolume = settings.bubbleGameSfxVolume;
    setState(() => _sounds = sounds);
    if (!_isGameOver) await sounds.startBgm();
  }

  /// ゲーム内のx座標を、左右の振り分け (-1〜1) に直す。
  double _pan(double x) {
    const margin = DropAndFusionGame.playareaMargin;
    const width = DropAndFusionGame.gameWidth - margin - margin;
    return ((x - margin) / width - 0.5) * 2;
  }

  Future<void> _loadHighScore() async {
    // ハイスコアが取れなくてもゲームは遊べるので、失敗しても黙って諦める
    final int? highScore;
    try {
      highScore = await ref
          .read(bubbleGameRepositoryProvider)
          .highScore(widget.gameMode);
    } catch (_) {
      return;
    }
    if (!mounted) return;
    setState(() => _highScore = highScore);
  }

  void _onTick(Duration elapsed) {
    _accumulated += elapsed - _lastElapsed;
    _lastElapsed = elapsed;

    var steps = 0;
    while (_accumulated >= _step && steps < _maxStepsPerFrame) {
      _accumulated -= _step;
      steps++;
      if (!_game.tick()) break;
    }
    if (_accumulated >= _step * _maxStepsPerFrame) {
      // 追いつけないぶんは捨てる
      _accumulated = Duration.zero;
    }

    if (steps > 0) _repaint.value++;
  }

  void _onGameOver() {
    _ticker.stop();
    setState(() => _isGameOver = true);
    _sounds?.playGameOver(isYen: widget.gameMode == BubbleGameMode.yen);
    unawaited(_sounds?.stopBgm());
    unawaited(_registerScore());
  }

  Future<void> _registerScore() async {
    final score = _game.score;
    final repository = ref.read(bubbleGameRepositoryProvider);
    final rateLimitMessage = S.of(context).bubbleGameScoreRateLimited;

    setState(() => _isRegistering = true);
    await ref.read(dialogStateProvider.notifier).guard(() async {
      try {
        await repository.register(
          seed: _game.seed,
          score: score,
          gameMode: widget.gameMode,
          logs: _game.getLogs(),
        );
      } on MisskeyException catch (e) {
        // スコアの登録は30秒に1回までなので、短い勝負を続けると弾かれる。
        // 何が起きたか分かる文言にしておく。
        if (e.code != "RATE_LIMIT_EXCEEDED") rethrow;
        throw SpecifiedException(rateLimitMessage);
      }
      if (score > (_highScore ?? 0)) {
        await repository.setHighScore(widget.gameMode, score);
      }
    });
    if (!mounted) return;
    setState(() {
      _isRegistering = false;
      if (score > (_highScore ?? 0)) _highScore = score;
    });
  }

  void _restart() {
    _game.dispose();
    setState(() {
      _game = _createGame();
      _score = 0;
      _combo = 0;
      _isGameOver = false;
      _dropperX = DropAndFusionGame.gameWidth / 2;
    });
    // Tickerを止めて再開すると経過時間が0に戻るので、こちらも合わせる
    _accumulated = Duration.zero;
    _lastElapsed = Duration.zero;
    _ticker.start();
    unawaited(_sounds?.startBgm());
  }

  /// 音量の調整。変えた値は次に遊ぶときのために覚えておく。
  Future<void> _showVolumeSheet() async {
    final repository = ref.read(generalSettingsRepositoryProvider);

    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          final settings = repository.settings;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).bubbleGameVolume,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  for (final entry in [
                    (
                      S.of(context).bubbleGameBgmVolume,
                      settings.bubbleGameBgmVolume,
                      (double value) async {
                        await repository.update(
                          settings.copyWith(bubbleGameBgmVolume: value),
                        );
                        await _sounds?.setBgmVolume(value);
                      },
                    ),
                    (
                      S.of(context).bubbleGameSfxVolume,
                      settings.bubbleGameSfxVolume,
                      (double value) async {
                        await repository.update(
                          settings.copyWith(bubbleGameSfxVolume: value),
                        );
                        _sounds?.sfxVolume = value;
                      },
                    ),
                  ])
                    Row(
                      children: [
                        SizedBox(width: 64, child: Text(entry.$1)),
                        Expanded(
                          child: Slider(
                            value: entry.$2,
                            onChanged: (value) async {
                              await entry.$3(value);
                              setSheetState(() {});
                              if (mounted) setState(() {});
                            },
                          ),
                        ),
                        Text("${(entry.$2 * 100).round()}%"),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _surrender() async {
    final result = await ref
        .read(dialogStateProvider.notifier)
        .showDialog(
          message: (context) => S.of(context).bubbleGameSurrenderConfirm,
          actions: (context) => [
            S.of(context).bubbleGameSurrender,
            S.of(context).cancel,
          ],
        );
    if (result == 0) _game.surrender();
  }

  /// タップ位置をゲーム内座標に直す。
  void _moveDropper(Offset localPosition, Size size) {
    final x = localPosition.dx / size.width * DropAndFusionGame.gameWidth;
    setState(() => _dropperX = x);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameMode.displayName(context)),
        actions: [
          IconButton(
            onPressed: _showVolumeSheet,
            icon: Icon(
              _sounds != null && _sounds!.bgmVolume + _sounds!.sfxVolume > 0
                  ? Icons.volume_up
                  : Icons.volume_off,
            ),
            tooltip: S.of(context).bubbleGameVolume,
          ),
          IconButton(
            onPressed: _isGameOver ? null : _surrender,
            icon: const Icon(Icons.flag),
            tooltip: S.of(context).bubbleGameSurrender,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _ScoreBoard(
              score: _score,
              combo: _combo,
              highScore: _highScore,
              gameMode: widget.gameMode,
            ),
            _StockView(game: _game, textures: _textures),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: AspectRatio(
                    aspectRatio:
                        DropAndFusionGame.gameWidth /
                        DropAndFusionGame.gameHeight,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final size = constraints.biggest;
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapDown: (details) =>
                              _moveDropper(details.localPosition, size),
                          onTapUp: (_) => _game.drop(_dropperX),
                          onHorizontalDragStart: (details) =>
                              _moveDropper(details.localPosition, size),
                          onHorizontalDragUpdate: (details) =>
                              _moveDropper(details.localPosition, size),
                          onHorizontalDragEnd: (_) => _game.drop(_dropperX),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CustomPaint(
                                painter: BubbleGamePainter(
                                  game: _game,
                                  textures: _textures,
                                  dropperX: _dropperX,
                                  canDrop: _game.canDrop,
                                  colorScheme: Theme.of(context).colorScheme,
                                  repaint: _repaint,
                                ),
                              ),
                              if (_isGameOver)
                                _GameOverOverlay(
                                  score: _score,
                                  gameMode: widget.gameMode,
                                  isRegistering: _isRegistering,
                                  onRetry: _restart,
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      S.of(context).bubbleGameHowToPlay,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.tonalIcon(
                    onPressed: _isGameOver ? null : () => _game.hold(),
                    icon: const Icon(Icons.swap_horiz),
                    label: Text(S.of(context).bubbleGameHold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreBoard extends StatelessWidget {
  const _ScoreBoard({
    required this.score,
    required this.combo,
    required this.highScore,
    required this.gameMode,
  });

  final int score;
  final int combo;
  final int? highScore;
  final BubbleGameMode gameMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).bubbleGameScore,
                style: theme.textTheme.labelSmall,
              ),
              Text(
                "$score${gameMode.scoreUnit}",
                style: theme.textTheme.headlineSmall,
              ),
            ],
          ),
          const SizedBox(width: 24),
          if (highScore != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).bubbleGameHighScore,
                  style: theme.textTheme.labelSmall,
                ),
                Text(
                  "$highScore${gameMode.scoreUnit}",
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          const Spacer(),
          if (combo > 1)
            Text(
              "$combo ${S.of(context).bubbleGameCombo}",
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
        ],
      ),
    );
  }
}

/// 次に落ちてくるモノとホールド中のモノ。
class _StockView extends StatelessWidget {
  const _StockView({required this.game, required this.textures});

  final DropAndFusionGame game;
  final MonoTextures? textures;

  @override
  Widget build(BuildContext context) {
    final stock = game.stock;
    final holding = game.holding;

    return SizedBox(
      height: 48,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Text(
              S.of(context).bubbleGameNext,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(width: 8),
            for (final item in stock.take(4))
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: _MonoIcon(mono: item.mono, textures: textures),
              ),
            const Spacer(),
            if (holding != null) ...[
              Text(
                S.of(context).bubbleGameHold,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(width: 8),
              _MonoIcon(mono: holding.mono, textures: textures),
            ],
          ],
        ),
      ),
    );
  }
}

class _MonoIcon extends StatelessWidget {
  const _MonoIcon({required this.mono, required this.textures});

  final Mono mono;
  final MonoTextures? textures;

  @override
  Widget build(BuildContext context) {
    final image = textures?[mono];

    return SizedBox(
      width: 32,
      height: 32,
      child: image == null
          ? DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
            )
          : RawImage(image: image, fit: BoxFit.contain),
    );
  }
}

class _GameOverOverlay extends StatelessWidget {
  const _GameOverOverlay({
    required this.score,
    required this.gameMode,
    required this.isRegistering,
    required this.onRetry,
  });

  final int score;
  final BubbleGameMode gameMode;
  final bool isRegistering;
  final void Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ColoredBox(
      color: theme.colorScheme.scrim.withValues(alpha: 0.5),
      child: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  S.of(context).bubbleGameOver,
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  "$score${gameMode.scoreUnit}",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                if (isRegistering)
                  const CircularProgressIndicator.adaptive()
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      FilledButton(
                        onPressed: onRetry,
                        child: Text(S.of(context).bubbleGameRetry),
                      ),
                      FilledButton.tonal(
                        onPressed: () => Navigator.of(context).maybePop(),
                        child: Text(S.of(context).bubbleGameBackToTitle),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
