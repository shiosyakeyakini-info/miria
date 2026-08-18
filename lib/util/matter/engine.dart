/// matter-js v0.20.0 の `Engine` / `Composite` (World) の移植。
///
/// バブルゲームは拘束(Constraint)を使わないため、拘束まわりは移植していない
/// (拘束が無い場合`Constraint.preSolveAll`/`postSolveAll`は何もしないため、
/// 省いても挙動は変わらない)。
library;

import "package:miria/util/matter/body.dart";
import "package:miria/util/matter/collision.dart";
import "package:miria/util/matter/geometry.dart";
import "package:miria/util/matter/resolver.dart";

const double _baseDelta = 1000 / 60;

/// matter-jsの`composite`。バブルゲームでは入れ子のコンポジットを使わないため、
/// ボディの平坦なリストとして扱う。
class MatterComposite {
  MatterComposite({this.label = "Composite"}) : id = matterNextId();

  final int id;
  final String label;
  final List<MatterBody> bodies = [];
  bool isModified = false;

  static void add(MatterComposite composite, MatterBody body) {
    composite.bodies.add(body);
    composite.isModified = true;
  }

  static void addAll(MatterComposite composite, List<MatterBody> bodies) {
    for (final body in bodies) {
      add(composite, body);
    }
  }

  static void remove(MatterComposite composite, MatterBody body) {
    if (composite.bodies.remove(body)) {
      body.sleepCounter = 0;
      composite.isModified = true;
    }
  }

  static void removeAll(MatterComposite composite, List<MatterBody> bodies) {
    for (final body in bodies) {
      remove(composite, body);
    }
  }
}

/// 衝突イベントのコールバック。
typedef MatterCollisionCallback = void Function(List<MatterPair> pairs);

/// matter-jsの`engine`。
class MatterEngine {
  MatterEngine({
    this.positionIterations = 6,
    this.velocityIterations = 4,
    required this.gravity,
    this.timeScale = 1,
  }) : world = MatterComposite(label: "World");

  final int positionIterations;
  final int velocityIterations;
  final MatterVector gravity;

  /// `gravity.scale`。matter-jsの既定値。
  final double gravityScale = 0.001;
  final double timeScale;

  final MatterComposite world;
  final MatterPairs pairs = MatterPairs();
  late final MatterDetector detector = MatterDetector()..pairs = pairs;

  double timestamp = 0;

  MatterCollisionCallback? onCollisionStart;
  MatterCollisionCallback? onCollisionActive;
  MatterCollisionCallback? onCollisionEnd;

  static void update(MatterEngine engine, double deltaTime) {
    final world = engine.world;
    final detector = engine.detector;
    final pairs = engine.pairs;

    // Pairs.updateに渡すのは加算前のタイムスタンプ
    final timestamp = engine.timestamp;

    final delta = deltaTime * engine.timeScale;
    engine.timestamp += delta;

    // matter-jsの`Composite.allBodies`はキャッシュした配列のコピーを返すため、
    // 更新の途中でワールドからボディが足し引きされても
    // このフレームの処理は開始時点の一覧で進む。
    // 合体でボディを消したフレームでは、消えたボディも
    // `postSolvePosition`や速度の解決に参加するので、ここでも複製しておく。
    final allBodies = List<MatterBody>.of(world.bodies);

    if (world.isModified) {
      MatterDetector.setBodies(detector, allBodies);
      world.isModified = false;
    }

    _bodiesApplyGravity(allBodies, engine.gravity, engine.gravityScale);

    if (delta > 0) {
      _bodiesUpdate(allBodies, delta);
    }

    final collisions = MatterDetector.detectCollisions(detector);
    MatterPairs.update(pairs, collisions, timestamp);

    if (pairs.collisionStart.isNotEmpty) {
      engine.onCollisionStart?.call(pairs.collisionStart);
    }

    final positionDamping = _clamp(20 / engine.positionIterations, 0, 1);

    MatterResolver.preSolvePosition(pairs.list);
    for (var i = 0; i < engine.positionIterations; i++) {
      MatterResolver.solvePosition(pairs.list, delta, positionDamping);
    }
    MatterResolver.postSolvePosition(allBodies);

    MatterResolver.preSolveVelocity(pairs.list);
    for (var i = 0; i < engine.velocityIterations; i++) {
      MatterResolver.solveVelocity(pairs.list, delta);
    }

    _bodiesUpdateVelocities(allBodies);

    if (pairs.collisionActive.isNotEmpty) {
      engine.onCollisionActive?.call(pairs.collisionActive);
    }

    if (pairs.collisionEnd.isNotEmpty) {
      engine.onCollisionEnd?.call(pairs.collisionEnd);
    }

    _bodiesClearForces(allBodies);
  }

  static void clear(MatterEngine engine) {
    MatterPairs.clear(engine.pairs);
    MatterDetector.clear(engine.detector);
  }

  static void _bodiesClearForces(List<MatterBody> bodies) {
    for (var i = 0; i < bodies.length; i++) {
      final body = bodies[i];
      body.force.x = 0;
      body.force.y = 0;
      body.torque = 0;
    }
  }

  static void _bodiesApplyGravity(
    List<MatterBody> bodies,
    MatterVector gravity,
    double gravityScale,
  ) {
    if ((gravity.x == 0 && gravity.y == 0) || gravityScale == 0) return;

    for (var i = 0; i < bodies.length; i++) {
      final body = bodies[i];
      if (body.isStatic || body.isSleeping) continue;
      body.force.y += body.mass * gravity.y * gravityScale;
      body.force.x += body.mass * gravity.x * gravityScale;
    }
  }

  static void _bodiesUpdate(List<MatterBody> bodies, double delta) {
    for (var i = 0; i < bodies.length; i++) {
      final body = bodies[i];
      if (body.isStatic || body.isSleeping) continue;
      MatterBody.update(body, delta);
    }
  }

  static void _bodiesUpdateVelocities(List<MatterBody> bodies) {
    for (var i = 0; i < bodies.length; i++) {
      MatterBody.updateVelocities(bodies[i]);
    }
  }
}

double _clamp(double value, double min, double max) {
  if (value < min) return min;
  if (value > max) return max;
  return value;
}

/// `Common._baseDelta`。
const double matterBaseDelta = _baseDelta;
