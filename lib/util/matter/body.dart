/// matter-js v0.20.0 の `Body` / `Bodies` に相当する部分の移植。
library;

import "dart:math" as math;

import "package:miria/util/matter/js_math.dart";

import "package:miria/util/matter/geometry.dart";

/// `Common.nextId()`。matter-jsと同じくモジュール全体で共有するカウンタ。
/// ボディのidは大小関係しか使われない（衝突ペアの正規化とペアIDの生成）ため、
/// 生成順さえ保たれていれば挙動は変わらない。
int _nextId = 0;

int matterNextId() => _nextId++;

/// テスト用にidカウンタを初期化する。
void resetMatterIdCounter() => _nextId = 0;

const double _inertiaScale = 4;
const double _baseDelta = 1000 / 60;

/// [MatterBody]の生成オプション。matter-jsで既定値を上書きしたいものだけを持つ。
class MatterBodyOptions {
  const MatterBodyOptions({
    this.label,
    this.isStatic,
    this.isSensor,
    this.density,
    this.restitution,
    this.friction,
    this.frictionStatic,
    this.frictionAir,
    this.slop,
  });

  final String? label;
  final bool? isStatic;
  final bool? isSensor;
  final double? density;
  final double? restitution;
  final double? friction;
  final double? frictionStatic;
  final double? frictionAir;
  final double? slop;
}

/// matter-jsの`body`。
class MatterBody {
  MatterBody._({
    required this.id,
    required this.label,
    required this.position,
    required List<MatterVertex> vertices,
    required this.isStatic,
    required this.isSensor,
    required this.density,
    required this.restitution,
    required this.friction,
    required this.frictionStatic,
    required this.frictionAir,
    required this.slop,
    required this.circleRadius,
  }) : _vertices = vertices,
       positionPrev = position.clone(),
       force = MatterVector.zero(),
       positionImpulse = MatterVector.zero(),
       velocity = MatterVector.zero(),
       bounds = MatterBounds(),
       axes = <MatterVector>[];

  final int id;
  String label;

  /// 複合ボディの構成要素。単体のボディでは`[this]`。
  List<MatterBody> parts = <MatterBody>[];
  late MatterBody parent;

  double angle = 0;
  List<MatterVertex> _vertices;
  final MatterVector position;
  final MatterVector force;
  double torque = 0;
  final MatterVector positionImpulse;
  int totalContacts = 0;
  double speed = 0;
  double angularSpeed = 0;
  final MatterVector velocity;
  double angularVelocity = 0;
  bool isSensor;
  bool isStatic;
  bool isSleeping = false;
  int sleepCounter = 0;
  double density;
  double restitution;
  double friction;
  double frictionStatic;
  double frictionAir;
  double slop;
  double timeScale = 1;
  final MatterBounds bounds;
  double circleRadius;
  final MatterVector positionPrev;
  double anglePrev = 0;
  List<MatterVector> axes;
  double area = 0;
  double mass = 0;
  double inertia = 0;
  double inverseMass = 0;
  double inverseInertia = 0;
  double deltaTime = 1000 / 60;

  _OriginalBodyProperties? _original;

  List<MatterVertex> get vertices => _vertices;

  /// `Body.create`相当。
  ///
  /// matter-jsの`Body.create`は`Common.extend(defaults, options)`のあとに
  /// `_initProperties`を呼ぶ。プロパティの適用順が結果に効く
  /// （例えば静的ボディの`inertia`が`Infinity`になるのは、
  /// 2回目の`Body.set`に渡すオブジェクトリテラルが
  /// `setMass`より前に評価されるため）ので、その順序をそのまま再現している。
  factory MatterBody.create({
    List<MatterVector>? vertices,
    MatterVector? position,
    List<MatterBody>? parts,
    double circleRadius = 0,
    MatterBodyOptions options = const MatterBodyOptions(),
  }) {
    final body = MatterBody._(
      id: matterNextId(),
      label: options.label ?? "Body",
      position: position?.clone() ?? MatterVector.zero(),
      vertices: MatterVertices.create(vertices ?? _defaultVertices(), null),
      isStatic: options.isStatic ?? false,
      isSensor: options.isSensor ?? false,
      density: options.density ?? 0.001,
      restitution: options.restitution ?? 0,
      friction: options.friction ?? 0.1,
      frictionStatic: options.frictionStatic ?? 0.5,
      frictionAir: options.frictionAir ?? 0.01,
      slop: options.slop ?? 0.05,
      circleRadius: circleRadius,
    );

    // Body.set(body, {bounds, positionPrev, anglePrev, vertices, parts, isStatic, isSleeping, parent})
    // 値はすべて適用前に評価される。
    final verticesValue = body._vertices;
    final partsValue = parts ?? const <MatterBody>[];

    MatterBounds.update(body.bounds, verticesValue, null);
    body.positionPrev.x = body.position.x;
    body.positionPrev.y = body.position.y;
    body.anglePrev = body.angle;
    _setVertices(body, verticesValue);
    _setParts(body, partsValue);
    _setStatic(body, body.isStatic);
    // isSleeping / parent は既定値のまま (parentは_setPartsで自身に設定済み)

    MatterVertices.rotate(body._vertices, body.angle, body.position);
    MatterAxes.rotate(body.axes, body.angle);
    MatterBounds.update(body.bounds, body._vertices, body.velocity);

    // Body.set(body, {axes, area, mass, inertia})
    // オブジェクトリテラルの評価が先なので、ここで読む値はsetMass適用前のもの。
    final massValue = body.mass;
    final inertiaValue = body.inertia;
    _setMass(body, massValue);
    _setInertia(body, inertiaValue);

    return body;
  }

  static void _setStatic(MatterBody body, bool isStatic) {
    for (var i = 0; i < body.parts.length; i++) {
      final part = body.parts[i];
      if (isStatic) {
        if (!part.isStatic) {
          part._original = _OriginalBodyProperties(
            restitution: part.restitution,
            friction: part.friction,
            mass: part.mass,
            inertia: part.inertia,
            density: part.density,
            inverseMass: part.inverseMass,
            inverseInertia: part.inverseInertia,
          );
        }
        part.restitution = 0;
        part.friction = 1;
        part.mass = double.infinity;
        part.inertia = double.infinity;
        part.density = double.infinity;
        part.inverseMass = 0;
        part.inverseInertia = 0;
        part.positionPrev.x = part.position.x;
        part.positionPrev.y = part.position.y;
        part.anglePrev = part.angle;
        part.angularVelocity = 0;
        part.speed = 0;
        part.angularSpeed = 0;
      } else {
        final original = part._original;
        if (original != null) {
          part.restitution = original.restitution;
          part.friction = original.friction;
          part.mass = original.mass;
          part.inertia = original.inertia;
          part.density = original.density;
          part.inverseMass = original.inverseMass;
          part.inverseInertia = original.inverseInertia;
          part._original = null;
        }
      }
      part.isStatic = isStatic;
    }
  }

  static void _setMass(MatterBody body, double mass) {
    final moment = body.inertia / (body.mass / 6);
    body.inertia = moment * (mass / 6);
    body.inverseInertia = 1 / body.inertia;
    body.mass = mass;
    body.inverseMass = 1 / body.mass;
    body.density = body.mass / body.area;
  }

  static void _setInertia(MatterBody body, double inertia) {
    body.inertia = inertia;
    body.inverseInertia = 1 / body.inertia;
  }

  static void _setVertices(MatterBody body, List<MatterVector> vertices) {
    final first = vertices.isEmpty ? null : vertices.first;
    if (first is MatterVertex && identical(first.body, body)) {
      body._vertices = vertices.cast<MatterVertex>();
    } else {
      body._vertices = MatterVertices.create(vertices, body);
    }

    body.axes = MatterAxes.fromVertices(body._vertices);
    body.area = MatterVertices.area(body._vertices);
    _setMass(body, body.density * body.area);

    // 重心を原点に合わせてから慣性モーメントを求める
    final centre = MatterVertices.centre(body._vertices);
    MatterVertices.translate(body._vertices, centre, scalar: -1);

    _setInertia(
      body,
      _inertiaScale * MatterVertices.inertia(body._vertices, body.mass),
    );

    MatterVertices.translate(body._vertices, body.position);
    MatterBounds.update(body.bounds, body._vertices, body.velocity);
  }

  static void _setParts(MatterBody body, List<MatterBody> parts) {
    final source = parts.toList();
    body.parts = <MatterBody>[body];
    body.parent = body;

    for (var i = 0; i < source.length; i++) {
      final part = source[i];
      if (!identical(part, body)) {
        part.parent = body;
        body.parts.add(part);
      }
    }

    if (body.parts.length == 1) return;

    // すべてのパーツの凸包を親ボディの形状にする
    final hullSource = <MatterVector>[];
    for (var i = 0; i < source.length; i++) {
      hullSource.addAll(source[i]._vertices);
    }
    MatterVertices.clockwiseSort(hullSource);
    final hull = MatterVertices.hull(hullSource);
    final hullCentre = MatterVertices.centre(hull);
    _setVertices(body, hull);
    MatterVertices.translate(body._vertices, hullCentre);

    final total = _totalProperties(body);
    body.area = total.area;
    body.parent = body;
    body.position.x = total.centre.x;
    body.position.y = total.centre.y;
    body.positionPrev.x = total.centre.x;
    body.positionPrev.y = total.centre.y;
    _setMass(body, total.mass);
    _setInertia(body, total.inertia);
    setPosition(body, total.centre);
  }

  static void setPosition(MatterBody body, MatterVector position) {
    final delta = MatterVector.sub(position, body.position);
    body.positionPrev.x += delta.x;
    body.positionPrev.y += delta.y;

    for (var i = 0; i < body.parts.length; i++) {
      final part = body.parts[i];
      part.position.x += delta.x;
      part.position.y += delta.y;
      MatterVertices.translate(part._vertices, delta);
      MatterBounds.update(part.bounds, part._vertices, body.velocity);
    }
  }

  /// `Body.update`相当。Verlet積分で位置と角度を進める。
  static void update(MatterBody body, double delta) {
    final deltaTime = delta * body.timeScale;
    final deltaTimeSquared = deltaTime * deltaTime;
    final correction =
        deltaTime / (body.deltaTime == 0 ? deltaTime : body.deltaTime);

    final frictionAir = 1 - body.frictionAir * (deltaTime / _baseDelta);
    final velocityPrevX = (body.position.x - body.positionPrev.x) * correction;
    final velocityPrevY = (body.position.y - body.positionPrev.y) * correction;

    body.velocity.x =
        (velocityPrevX * frictionAir) +
        (body.force.x / body.mass) * deltaTimeSquared;
    body.velocity.y =
        (velocityPrevY * frictionAir) +
        (body.force.y / body.mass) * deltaTimeSquared;
    body.positionPrev.x = body.position.x;
    body.positionPrev.y = body.position.y;
    body.position.x += body.velocity.x;
    body.position.y += body.velocity.y;
    body.deltaTime = deltaTime;

    body.angularVelocity =
        ((body.angle - body.anglePrev) * frictionAir * correction) +
        (body.torque / body.inertia) * deltaTimeSquared;
    body.anglePrev = body.angle;
    body.angle += body.angularVelocity;

    for (var i = 0; i < body.parts.length; i++) {
      final part = body.parts[i];

      MatterVertices.translate(part._vertices, body.velocity);

      if (i > 0) {
        part.position.x += body.velocity.x;
        part.position.y += body.velocity.y;
      }

      if (body.angularVelocity != 0) {
        MatterVertices.rotate(
          part._vertices,
          body.angularVelocity,
          body.position,
        );
        MatterAxes.rotate(part.axes, body.angularVelocity);
        if (i > 0) {
          MatterVector.rotateAbout(
            part.position,
            body.angularVelocity,
            body.position,
            part.position,
          );
        }
      }

      MatterBounds.update(part.bounds, part._vertices, body.velocity);
    }
  }

  static void updateVelocities(MatterBody body) {
    final timeScale = _baseDelta / body.deltaTime;
    final bodyVelocity = body.velocity;

    bodyVelocity.x = (body.position.x - body.positionPrev.x) * timeScale;
    bodyVelocity.y = (body.position.y - body.positionPrev.y) * timeScale;
    body.speed = math.sqrt(
      bodyVelocity.x * bodyVelocity.x + bodyVelocity.y * bodyVelocity.y,
    );

    body.angularVelocity = (body.angle - body.anglePrev) * timeScale;
    body.angularSpeed = body.angularVelocity.abs();
  }

  static void applyForce(
    MatterBody body,
    MatterVector position,
    MatterVector force,
  ) {
    final offsetX = position.x - body.position.x;
    final offsetY = position.y - body.position.y;
    body.force.x += force.x;
    body.force.y += force.y;
    body.torque += offsetX * force.y - offsetY * force.x;
  }

  static _TotalProperties _totalProperties(MatterBody body) {
    var totalMass = 0.0;
    var totalArea = 0.0;
    var totalInertia = 0.0;
    var centre = MatterVector(0, 0);

    for (var i = body.parts.length == 1 ? 0 : 1; i < body.parts.length; i++) {
      final part = body.parts[i];
      final mass = part.mass != double.infinity ? part.mass : 1.0;
      totalMass += mass;
      totalArea += part.area;
      totalInertia += part.inertia;
      centre = MatterVector.add(centre, MatterVector.mult(part.position, mass));
    }

    return _TotalProperties(
      mass: totalMass,
      area: totalArea,
      inertia: totalInertia,
      centre: MatterVector.div(centre, totalMass),
    );
  }
}

class _OriginalBodyProperties {
  const _OriginalBodyProperties({
    required this.restitution,
    required this.friction,
    required this.mass,
    required this.inertia,
    required this.density,
    required this.inverseMass,
    required this.inverseInertia,
  });

  final double restitution;
  final double friction;
  final double mass;
  final double inertia;
  final double density;
  final double inverseMass;
  final double inverseInertia;
}

class _TotalProperties {
  const _TotalProperties({
    required this.mass,
    required this.area,
    required this.inertia,
    required this.centre,
  });

  final double mass;
  final double area;
  final double inertia;
  final MatterVector centre;
}

/// matter-jsの`Bodies`。
abstract final class MatterBodies {
  static MatterBody rectangle(
    double x,
    double y,
    double width,
    double height,
    MatterBodyOptions options,
  ) => MatterBody.create(
    position: MatterVector(x, y),
    vertices: [
      MatterVector(0, 0),
      MatterVector(width, 0),
      MatterVector(width, height),
      MatterVector(0, height),
    ],
    options: options,
  );

  static MatterBody circle(
    double x,
    double y,
    double radius,
    MatterBodyOptions options,
  ) {
    // matter-jsは円を多角形で近似する
    const maxSides = 25;
    var sides = math.max(10, math.min(maxSides, radius)).ceil();
    if (sides % 2 == 1) sides += 1;
    return polygon(x, y, sides, radius, options, circleRadius: radius);
  }

  static MatterBody polygon(
    double x,
    double y,
    int sides,
    double radius,
    MatterBodyOptions options, {
    double circleRadius = 0,
  }) {
    if (sides < 3) return circle(x, y, radius, options);

    final theta = 2 * math.pi / sides;
    final offset = theta * 0.5;
    final points = <MatterVector>[];

    for (var i = 0; i < sides; i++) {
      final angle = offset + (i * theta);
      // matter-jsはパス文字列を経由するため、ここで3桁に丸められる
      points.add(
        MatterVector(
          _roundTo3(jsCos(angle) * radius),
          _roundTo3(jsSin(angle) * radius),
        ),
      );
    }

    return MatterBody.create(
      position: MatterVector(x, y),
      vertices: points,
      circleRadius: circleRadius,
      options: options,
    );
  }

  /// `Bodies.fromVertices`相当。
  ///
  /// 本家はpoly-decompを読み込んでいないため、凹多角形は分解されず凸包に潰れる。
  /// ここでもその挙動に合わせている。
  static MatterBody fromVertices(
    double x,
    double y,
    List<List<MatterVector>> vertexSets,
    MatterBodyOptions options,
  ) {
    final parts = <MatterBody>[];

    for (final vertexSet in vertexSets) {
      final isConvex = MatterVertices.isConvex(vertexSet);
      final vertices = isConvex ?? false
          ? MatterVertices.clockwiseSort(vertexSet.toList())
          : MatterVertices.hull(vertexSet);

      parts.add(
        MatterBody.create(
          position: MatterVector(x, y),
          vertices: vertices,
          options: options,
        ),
      );
    }

    if (parts.length > 1) {
      final body = MatterBody.create(
        position: MatterVector(x, y),
        parts: parts.toList(),
        options: options,
      );
      MatterBody.setPosition(body, MatterVector(x, y));
      return body;
    }

    return parts[0];
  }
}

/// JSの`parseFloat(value.toFixed(3))`相当。
double _roundTo3(double value) => double.parse(jsToFixed3(value));

/// `Body.create`の既定の頂点 (`L 0 0 L 40 0 L 40 40 L 0 40`)。
List<MatterVector> _defaultVertices() => [
  MatterVector(0, 0),
  MatterVector(40, 0),
  MatterVector(40, 40),
  MatterVector(0, 40),
];
