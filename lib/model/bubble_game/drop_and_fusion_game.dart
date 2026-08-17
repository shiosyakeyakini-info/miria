/// Misskey本家の`packages/misskey-bubble-game`の`DropAndFusionGame`の移植。
///
/// スコアはシードと操作ログとともにサーバーへ送るため、
/// 同じシード・同じ操作からは同じ結果にならなければならない。
/// そのため本家と同じ順序で乱数を消費し、同じ物理演算 (matter-js) を回している。
library;

import "dart:math" as math;

import "package:miria/model/bubble_game/mono.dart";
import "package:miria/model/bubble_game/monos.dart";
import "package:miria/util/matter/body.dart";
import "package:miria/util/matter/collision.dart";
import "package:miria/util/matter/engine.dart";
import "package:miria/util/matter/geometry.dart";
import "package:miria/util/seedrandom.dart";

/// 操作ログの種類。
enum BubbleGameOperation {
  drop(0),
  hold(1),
  surrender(2);

  const BubbleGameOperation(this.serialized);

  final int serialized;
}

/// 操作ログ1件。
class BubbleGameLog {
  const BubbleGameLog({
    required this.frame,
    required this.operation,
    this.x = 0,
  });

  final int frame;
  final BubbleGameOperation operation;
  final int x;
}

/// ストック (次に落ちてくるモノ) の1件。
class BubbleGameStockItem {
  const BubbleGameStockItem({required this.id, required this.mono});

  final String id;
  final Mono mono;
}

/// 描画用に切り出したボディの状態。
class BubbleGameBodyState {
  const BubbleGameBodyState({
    required this.id,
    required this.mono,
    required this.x,
    required this.y,
    required this.angle,
    required this.vertices,
  });

  final int id;
  final Mono mono;
  final double x;
  final double y;
  final double angle;

  /// [MonoShape.custom]などで実際に使われている頂点 (絶対座標)。
  final List<MatterVector> vertices;
}

/// 合体が起きたときの情報。
class BubbleGameFusion {
  const BubbleGameFusion({
    required this.x,
    required this.y,
    required this.next,
    required this.scoreDelta,
  });

  final double x;
  final double y;
  final Mono? next;
  final int scoreDelta;
}

class DropAndFusionGame {
  DropAndFusionGame({required this.seed, required this.gameMode})
    : _rng = SeedRandom(seed) {
    // sweetsモードは重いため精度を落とす (本家と同じ)
    final physicsQualityFactor = gameMode == BubbleGameMode.sweets
        ? 4
        : _physicsQualityFactor;

    _engine = MatterEngine(
      positionIterations: 6 * physicsQualityFactor,
      velocityIterations: 4 * physicsQualityFactor,
      gravity: MatterVector(0, gameMode == BubbleGameMode.space ? 0.0125 : 1),
      timeScale: 2,
    );

    final wallOptions = MatterBodyOptions(
      label: _wallLabel,
      isStatic: true,
      friction: 0.7,
      slop: gameMode == BubbleGameMode.space ? 0.01 : 0.7,
    );

    const thickness = 100.0;
    MatterComposite.addAll(_engine.world, [
      MatterBodies.rectangle(
        gameWidth / 2,
        gameHeight + (thickness / 2) - playareaMargin,
        gameWidth,
        thickness,
        wallOptions,
      ),
      MatterBodies.rectangle(
        gameWidth + (thickness / 2) - playareaMargin,
        gameHeight / 2,
        thickness,
        gameHeight,
        wallOptions,
      ),
      MatterBodies.rectangle(
        -((thickness / 2) - playareaMargin),
        gameHeight / 2,
        thickness,
        gameHeight,
        wallOptions,
      ),
    ]);

    _overflowCollider = MatterBodies.rectangle(
      gameWidth / 2,
      0,
      gameWidth,
      200,
      const MatterBodyOptions(
        label: _overflowLabel,
        isStatic: true,
        isSensor: true,
      ),
    );
    MatterComposite.add(_engine.world, _overflowCollider);
  }

  /// サーバーに送るゲームのバージョン。本家と一致している必要がある。
  static const int gameVersion = 3;

  static const double gameWidth = 450;
  static const double gameHeight = 600;
  static const int dropCooltime = 30; // frame
  static const double playareaMargin = 25;

  static const String _wallLabel = "_wall_";
  static const String _overflowLabel = "_overflow_";

  static const int _physicsQualityFactor = 16;
  static const int _comboInterval = 60; // frame
  static const int _stockMax = 4;
  static const double _tickDelta = 1000 / 60; // 60fps

  final String seed;
  final BubbleGameMode gameMode;

  final SeedRandom _rng;
  late final MatterEngine _engine;
  late final MatterBody _overflowCollider;

  int frame = 0;
  bool _isGameOver = false;
  final List<BubbleGameLog> _logs = [];
  List<_TickCallback> _tickCallbackQueue = [];

  /// フィールドに出ていて、かつ合体の対象となるモノ
  List<int> _fusionReadyBodyIds = [];
  List<int> _gameOverReadyBodyIds = [];

  /// 合体予約中のペア
  List<_BodyPair> _fusionReservedPairs = [];

  int _latestDroppedAt = 0; // frame
  int _latestFusionedAt = 0; // frame
  List<BubbleGameStockItem> _stock = [];
  BubbleGameStockItem? _holding;

  int _combo = 0;
  int _score = 0;

  void Function(int score)? onChangeScore;
  void Function(int combo)? onChangeCombo;
  void Function(List<BubbleGameStockItem> stock)? onChangeStock;
  void Function(BubbleGameStockItem? holding)? onChangeHolding;
  void Function(double x)? onDropped;
  void Function(BubbleGameFusion fusion)? onFusioned;
  void Function(double energy, Mono? mono)? onCollision;
  void Function(Mono mono)? onMonoAdded;
  void Function()? onGameOver;

  int get score => _score;
  int get combo => _combo;
  bool get isGameOver => _isGameOver;

  /// いま落とせるかどうか。落としてから[dropCooltime]フレームは落とせない。
  bool get canDrop => !_isGameOver && frame - _latestDroppedAt >= dropCooltime;
  List<BubbleGameStockItem> get stock => List.unmodifiable(_stock);
  BubbleGameStockItem? get holding => _holding;

  List<Mono> get monoDefinitions => switch (gameMode) {
    BubbleGameMode.normal => normalMonos,
    BubbleGameMode.yen => yenMonos,
    BubbleGameMode.square => squareMonos,
    BubbleGameMode.sweets => sweetsMonos,
    // spaceモードはnormalと同じモノを使う
    BubbleGameMode.space => normalMonos,
  };

  List<Mono> get _dropCandidates =>
      monoDefinitions.where((x) => x.dropCandidate).toList();

  int msToFrame(double ms) => _jsRound(ms / _tickDelta);

  double frameToMs(int frame) => frame * _tickDelta;

  set _scoreValue(int value) {
    _score = value;
    onChangeScore?.call(value);
  }

  set _comboValue(int value) {
    _combo = value;
    onChangeCombo?.call(value);
  }

  MatterBody _createBody(Mono mono, double x, double y) {
    final isSpace = gameMode == BubbleGameMode.space;
    final options = MatterBodyOptions(
      label: mono.id,
      density: isSpace ? 0.01 : ((mono.sizeX * mono.sizeY) / 10000),
      restitution: isSpace ? 0.5 : 0.2,
      frictionAir: isSpace ? 0 : 0.01,
      friction: isSpace ? 0.5 : 0.7,
      frictionStatic: isSpace ? 0 : 5,
      slop: isSpace ? 0.01 : 0.7,
    );

    switch (mono.shape) {
      case MonoShape.circle:
        return MatterBodies.circle(x, y, mono.sizeX / 2, options);
      case MonoShape.rectangle:
        return MatterBodies.rectangle(x, y, mono.sizeX, mono.sizeY, options);
      case MonoShape.custom:
        final verticesSize = mono.verticesSize!;
        return MatterBodies.fromVertices(x, y, [
          for (final set in mono.vertices!)
            [
              for (final vertex in set)
                MatterVector(
                  (vertex.x / verticesSize) * mono.sizeX,
                  (vertex.y / verticesSize) * mono.sizeY,
                ),
            ],
        ], options);
    }
  }

  void _fusion(MatterBody bodyA, MatterBody bodyB) {
    if (_latestFusionedAt > frame - _comboInterval) {
      _comboValue = _combo + 1;
    } else {
      _comboValue = 1;
    }
    _latestFusionedAt = frame;

    final newX = (bodyA.position.x + bodyB.position.x) / 2;
    final newY = (bodyA.position.y + bodyB.position.y) / 2;

    _fusionReadyBodyIds = _fusionReadyBodyIds
        .where((x) => x != bodyA.id && x != bodyB.id)
        .toList();
    _gameOverReadyBodyIds = _gameOverReadyBodyIds
        .where((x) => x != bodyA.id && x != bodyB.id)
        .toList();
    MatterComposite.removeAll(_engine.world, [bodyA, bodyB]);

    final currentMono = monoDefinitions.firstWhere(
      (y) => y.id == bodyA.label,
      orElse: () => throw StateError("Current Mono Not Found"),
    );

    final nextMono = monoDefinitions
        .where((x) => x.level == currentMono.level + 1)
        .firstOrNull;

    if (nextMono != null) {
      final body = _createBody(nextMono, newX, newY);
      MatterComposite.add(_engine.world, body);

      // 連鎖してfusionした場合の分かりやすさのため少し間を置いてから合体対象にする
      _tickCallbackQueue.add(
        _TickCallback(frame + msToFrame(100), () {
          _fusionReadyBodyIds.add(body.id);
        }),
      );

      onMonoAdded?.call(nextMono);
    }

    final hasComboBonus =
        gameMode != BubbleGameMode.yen && gameMode != BubbleGameMode.sweets;
    final comboBonus = hasComboBonus ? 1 + ((_combo - 1) / 5) : 1.0;
    final additionalScore = _jsRound(currentMono.score * comboBonus);
    _scoreValue = _score + additionalScore;

    onFusioned?.call(
      BubbleGameFusion(
        x: newX,
        y: newY,
        next: nextMono,
        scoreDelta: additionalScore,
      ),
    );
  }

  void _onCollision(List<MatterPair> pairs) {
    for (final pair in pairs) {
      final bodyA = pair.bodyA;
      final bodyB = pair.bodyB;

      final shouldFusion =
          bodyA.label == bodyB.label &&
          !_fusionReservedPairs.any(
            (x) =>
                x.bodyA.id == bodyA.id ||
                x.bodyA.id == bodyB.id ||
                x.bodyB.id == bodyA.id ||
                x.bodyB.id == bodyB.id,
          );

      if (shouldFusion) {
        if (_fusionReadyBodyIds.contains(bodyA.id) &&
            _fusionReadyBodyIds.contains(bodyB.id)) {
          _fusion(bodyA, bodyB);
        } else {
          _fusionReservedPairs.add(_BodyPair(bodyA, bodyB));
          _tickCallbackQueue.add(
            _TickCallback(frame + msToFrame(100), () {
              _fusionReservedPairs = _fusionReservedPairs
                  .where(
                    (x) => x.bodyA.id != bodyA.id && x.bodyB.id != bodyB.id,
                  )
                  .toList();
              _fusion(bodyA, bodyB);
            }),
          );
        }
      } else {
        final energy = pair.collision.depth;

        if (bodyA.label == _overflowLabel || bodyB.label == _overflowLabel) {
          continue;
        }

        if (bodyA.label != _wallLabel && bodyB.label != _wallLabel) {
          if (!_gameOverReadyBodyIds.contains(bodyA.id)) {
            _gameOverReadyBodyIds.add(bodyA.id);
          }
          if (!_gameOverReadyBodyIds.contains(bodyB.id)) {
            _gameOverReadyBodyIds.add(bodyB.id);
          }
        }

        onCollision?.call(
          energy,
          monoDefinitions.where((x) => x.id == bodyA.label).firstOrNull ??
              monoDefinitions.where((x) => x.id == bodyB.label).firstOrNull,
        );
      }
    }
  }

  void _onCollisionActive(List<MatterPair> pairs) {
    for (final pair in pairs) {
      final bodyA = pair.bodyA;
      final bodyB = pair.bodyB;

      // ハコからあふれたかどうかの判定
      if (bodyA.id == _overflowCollider.id ||
          bodyB.id == _overflowCollider.id) {
        if (_gameOverReadyBodyIds.contains(bodyA.id) ||
            _gameOverReadyBodyIds.contains(bodyB.id)) {
          _gameOver();
          break;
        }
        continue;
      }
    }
  }

  void surrender() {
    _logs.add(
      BubbleGameLog(frame: frame, operation: BubbleGameOperation.surrender),
    );
    _gameOver();
  }

  void _gameOver() {
    _isGameOver = true;
    onGameOver?.call();
  }

  void start() {
    for (var i = 0; i < _stockMax; i++) {
      _stock.add(_nextStockItem());
    }
    onChangeStock?.call(stock);

    _engine.onCollisionStart = _onCollision;
    _engine.onCollisionActive = _onCollisionActive;
  }

  /// 本家と同じ順序で乱数を消費する (idを先、モノの抽選を後)。
  BubbleGameStockItem _nextStockItem() {
    final id = _jsNumberToString(_rng.nextDouble());
    final candidates = _dropCandidates;
    final mono = candidates[(_rng.nextDouble() * candidates.length).floor()];
    return BubbleGameStockItem(id: id, mono: mono);
  }

  List<BubbleGameLog> getLogs() => List.unmodifiable(_logs);

  /// 1フレーム進める。まだ続く場合はtrueを返す。
  bool tick() {
    frame++;

    if (_latestFusionedAt < frame - _comboInterval) {
      _comboValue = 0;
    }

    // 本家は`filter`のコールバック内で`callback()`を呼び、その結果を代入し直している。
    // `filter`が走査する範囲は開始時の長さで固定されるうえ、
    // 走査後に配列ごと差し替えられるため、
    // コールバックの中から積まれた予約はこのフレームで捨てられる。
    // 挙動を合わせるためここでも同じことをしている。
    final queue = _tickCallbackQueue;
    final queueLength = queue.length;
    final retained = <_TickCallback>[];
    for (var i = 0; i < queueLength; i++) {
      final entry = queue[i];
      if (entry.frame == frame) {
        entry.callback();
      } else {
        retained.add(entry);
      }
    }
    _tickCallbackQueue = retained;

    MatterEngine.update(_engine, _tickDelta);

    return !_isGameOver;
  }

  /// 現在フィールドにあるモノの一覧。
  List<Mono> getActiveMonos() => [
    for (final body in _engine.world.bodies)
      ...monoDefinitions.where((mono) => mono.id == body.label),
  ];

  /// 本家との突き合わせ用に、ワールドのボディをそのまま取り出す。
  List<MatterBody> get debugBodies => List.unmodifiable(_engine.world.bodies);

  /// 本家との突き合わせ用に物理エンジンを取り出す。
  MatterEngine get debugEngine => _engine;

  /// 描画用のボディ一覧。
  List<BubbleGameBodyState> getBodyStates() => [
    for (final body in _engine.world.bodies)
      if (monoDefinitions.where((mono) => mono.id == body.label).firstOrNull
          case final mono?)
        BubbleGameBodyState(
          id: body.id,
          mono: mono,
          x: body.position.x,
          y: body.position.y,
          angle: body.angle,
          // 頂点は物理演算で書き換わるのでコピーしておく
          vertices: mono.shape == MonoShape.custom
              ? [for (final vertex in body.vertices) vertex.clone()]
              : const [],
        ),
  ];

  void drop(double rawX) {
    if (_isGameOver) return;
    if (frame - _latestDroppedAt < dropCooltime) return;

    if (_stock.isEmpty) return;
    final head = _stock.removeAt(0);

    _stock.add(_nextStockItem());
    onChangeStock?.call(stock);

    final inputX = _jsRound(rawX);
    final x = math.min(
      gameWidth - playareaMargin - (head.mono.sizeX / 2),
      math.max(playareaMargin + (head.mono.sizeX / 2), inputX.toDouble()),
    );
    final body = _createBody(head.mono, x, 50 + head.mono.sizeY / 2);
    _logs.add(
      BubbleGameLog(
        frame: frame,
        operation: BubbleGameOperation.drop,
        x: inputX,
      ),
    );

    if (gameMode == BubbleGameMode.space) {
      MatterBody.applyForce(
        body,
        body.position,
        MatterVector(0, (math.pi * head.mono.sizeX * head.mono.sizeY) / 65536),
      );
    }

    MatterComposite.add(_engine.world, body);

    _fusionReadyBodyIds.add(body.id);
    _latestDroppedAt = frame;

    onDropped?.call(x);
    onMonoAdded?.call(head.mono);
  }

  void hold() {
    if (_isGameOver) return;

    _logs.add(BubbleGameLog(frame: frame, operation: BubbleGameOperation.hold));

    if (_stock.isEmpty) return;

    final holding = _holding;
    if (holding != null) {
      final head = _stock.removeAt(0);
      _stock.insert(0, holding);
      _holding = head;
    } else {
      final head = _stock.removeAt(0);
      _holding = head;
      _stock.add(_nextStockItem());
    }
    onChangeHolding?.call(_holding);
    onChangeStock?.call(stock);
  }

  /// サーバーに送る形式にログを圧縮する。
  static List<List<int>> serializeLogs(List<BubbleGameLog> logs) {
    final serialized = <List<int>>[];

    for (var i = 0; i < logs.length; i++) {
      final log = logs[i];
      final frameDelta = i == 0 ? log.frame : log.frame - logs[i - 1].frame;

      switch (log.operation) {
        case BubbleGameOperation.drop:
          serialized.add([frameDelta, 0, log.x]);
        case BubbleGameOperation.hold:
          serialized.add([frameDelta, 1]);
        case BubbleGameOperation.surrender:
          serialized.add([frameDelta, 2]);
      }
    }

    return serialized;
  }

  static List<BubbleGameLog> deserializeLogs(List<List<int>> logs) {
    final deserialized = <BubbleGameLog>[];
    var frame = 0;

    for (final log in logs) {
      frame += log[0];

      switch (log[1]) {
        case 0:
          deserialized.add(
            BubbleGameLog(
              frame: frame,
              operation: BubbleGameOperation.drop,
              x: log[2],
            ),
          );
        case 1:
          deserialized.add(
            BubbleGameLog(frame: frame, operation: BubbleGameOperation.hold),
          );
        case 2:
          deserialized.add(
            BubbleGameLog(
              frame: frame,
              operation: BubbleGameOperation.surrender,
            ),
          );
      }
    }

    return deserialized;
  }

  void dispose() {
    MatterEngine.clear(_engine);
    _engine.world.bodies.clear();
    _tickCallbackQueue.clear();
  }
}

class _TickCallback {
  const _TickCallback(this.frame, this.callback);

  final int frame;
  final void Function() callback;
}

class _BodyPair {
  const _BodyPair(this.bodyA, this.bodyB);

  final MatterBody bodyA;
  final MatterBody bodyB;
}

/// JSの`Math.round`相当 (0.5は常に大きいほうへ丸める)。
int _jsRound(double value) => (value + 0.5).floor();

/// JSの`Number.prototype.toString()`相当。
/// ストックのidに使われるだけで、値そのものに意味はない。
String _jsNumberToString(double value) {
  if (value == value.roundToDouble() && value.abs() < 1e21) {
    return value.toInt().toString();
  }
  return value.toString();
}
