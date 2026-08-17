/// matter-js v0.20.0 の
/// `Collision` / `Detector` / `Contact` / `Pair` / `Pairs` の移植。
library;

import "package:miria/util/matter/body.dart";
import "package:miria/util/matter/geometry.dart";

/// matter-jsの`collision`。
class MatterCollision {
  MatterCollision(this.bodyA, this.bodyB)
    : parentA = bodyA.parent,
      parentB = bodyB.parent,
      normal = MatterVector.zero(),
      tangent = MatterVector.zero(),
      penetration = MatterVector.zero(),
      supports = List<MatterVertex?>.filled(2, null);

  MatterPair? pair;
  bool collided = false;
  MatterBody bodyA;
  MatterBody bodyB;
  MatterBody parentA;
  MatterBody parentB;
  double depth = 0;
  final MatterVector normal;
  final MatterVector tangent;
  final MatterVector penetration;
  final List<MatterVertex?> supports;
  int supportCount = 0;
}

class _OverlapResult {
  double overlap = 0;
  MatterVector? axis;
}

final _OverlapResult _overlapAB = _OverlapResult();
final _OverlapResult _overlapBA = _OverlapResult();

/// `Collision._findSupports`が使い回す配列。
/// matter-jsはこれをモジュール共有にしており、2回目の呼び出しで
/// 1回目の戻り値も書き換わることが結果に影響するため同じ構造にしている。
final List<MatterVertex?> _supports = List<MatterVertex?>.filled(2, null);

abstract final class MatterCollisions {
  /// 2つのボディが衝突しているかを判定する。衝突していなければnull。
  static MatterCollision? collides(
    MatterBody bodyA,
    MatterBody bodyB,
    MatterPairs? pairs,
  ) {
    _overlapAxes(_overlapAB, bodyA.vertices, bodyB.vertices, bodyA.axes);
    if (_overlapAB.overlap <= 0) return null;

    _overlapAxes(_overlapBA, bodyB.vertices, bodyA.vertices, bodyB.axes);
    if (_overlapBA.overlap <= 0) return null;

    final existingPair = pairs?.table[MatterPair.idOf(bodyA, bodyB)];
    final MatterCollision collision;

    if (existingPair == null) {
      collision = MatterCollision(bodyA, bodyB);
      collision.collided = true;
      collision.bodyA = bodyA.id < bodyB.id ? bodyA : bodyB;
      collision.bodyB = bodyA.id < bodyB.id ? bodyB : bodyA;
      collision.parentA = collision.bodyA.parent;
      collision.parentB = collision.bodyB.parent;
    } else {
      collision = existingPair.collision;
    }

    final a = collision.bodyA;
    final b = collision.bodyB;

    final minOverlap = _overlapAB.overlap < _overlapBA.overlap
        ? _overlapAB
        : _overlapBA;

    final normal = collision.normal;
    final tangent = collision.tangent;
    final penetration = collision.penetration;
    final supports = collision.supports;
    final depth = minOverlap.overlap;
    final minAxis = minOverlap.axis!;
    var normalX = minAxis.x;
    var normalY = minAxis.y;
    final deltaX = b.position.x - a.position.x;
    final deltaY = b.position.y - a.position.y;

    // 法線がAからBへ向くようにする
    if (normalX * deltaX + normalY * deltaY >= 0) {
      normalX = -normalX;
      normalY = -normalY;
    }

    normal.x = normalX;
    normal.y = normalY;
    tangent.x = -normalY;
    tangent.y = normalX;
    penetration.x = normalX * depth;
    penetration.y = normalY * depth;
    collision.depth = depth;

    final supportsB = _findSupports(a, b, normal, 1);
    var supportCount = 0;

    if (MatterVertices.contains(a.vertices, supportsB[0]!)) {
      supports[supportCount++] = supportsB[0];
    }
    if (MatterVertices.contains(a.vertices, supportsB[1]!)) {
      supports[supportCount++] = supportsB[1];
    }

    if (supportCount < 2) {
      // _supportsは共有配列なので、この呼び出しでsupportsBの中身も入れ替わる
      final supportsA = _findSupports(b, a, normal, -1);

      if (MatterVertices.contains(b.vertices, supportsA[0]!)) {
        supports[supportCount++] = supportsA[0];
      }
      if (supportCount < 2 &&
          MatterVertices.contains(b.vertices, supportsA[1]!)) {
        supports[supportCount++] = supportsA[1];
      }
    }

    if (supportCount == 0) {
      supports[supportCount++] = supportsB[0];
    }

    collision.supportCount = supportCount;

    return collision;
  }

  static void _overlapAxes(
    _OverlapResult result,
    List<MatterVertex> verticesA,
    List<MatterVertex> verticesB,
    List<MatterVector> axes,
  ) {
    final verticesALength = verticesA.length;
    final verticesBLength = verticesB.length;
    final verticesAX = verticesA[0].x;
    final verticesAY = verticesA[0].y;
    final verticesBX = verticesB[0].x;
    final verticesBY = verticesB[0].y;
    final axesLength = axes.length;
    var overlapMin = double.maxFinite;
    var overlapAxisNumber = 0;

    for (var i = 0; i < axesLength; i++) {
      final axis = axes[i];
      final axisX = axis.x;
      final axisY = axis.y;
      var minA = verticesAX * axisX + verticesAY * axisY;
      var minB = verticesBX * axisX + verticesBY * axisY;
      var maxA = minA;
      var maxB = minB;

      for (var j = 1; j < verticesALength; j++) {
        final dot = verticesA[j].x * axisX + verticesA[j].y * axisY;
        if (dot > maxA) {
          maxA = dot;
        } else if (dot < minA) {
          minA = dot;
        }
      }

      for (var j = 1; j < verticesBLength; j++) {
        final dot = verticesB[j].x * axisX + verticesB[j].y * axisY;
        if (dot > maxB) {
          maxB = dot;
        } else if (dot < minB) {
          minB = dot;
        }
      }

      final overlapAB = maxA - minB;
      final overlapBA = maxB - minA;
      final overlap = overlapAB < overlapBA ? overlapAB : overlapBA;

      if (overlap < overlapMin) {
        overlapMin = overlap;
        overlapAxisNumber = i;
        if (overlap <= 0) break;
      }
    }

    result.axis = axes[overlapAxisNumber];
    result.overlap = overlapMin;
  }

  static List<MatterVertex?> _findSupports(
    MatterBody bodyA,
    MatterBody bodyB,
    MatterVector normal,
    double direction,
  ) {
    final vertices = bodyB.vertices;
    final verticesLength = vertices.length;
    final bodyAPositionX = bodyA.position.x;
    final bodyAPositionY = bodyA.position.y;
    final normalX = normal.x * direction;
    final normalY = normal.y * direction;

    var vertexA = vertices[0];
    var vertexB = vertexA;
    var nearestDistance =
        normalX * (bodyAPositionX - vertexB.x) +
        normalY * (bodyAPositionY - vertexB.y);

    // 法線方向にもっとも近い頂点を探す
    for (var j = 1; j < verticesLength; j++) {
      vertexB = vertices[j];
      final distance =
          normalX * (bodyAPositionX - vertexB.x) +
          normalY * (bodyAPositionY - vertexB.y);
      if (distance < nearestDistance) {
        nearestDistance = distance;
        vertexA = vertexB;
      }
    }

    // 隣接する頂点のうち近いほうを2つ目の支持点にする
    final vertexC =
        vertices[(verticesLength + vertexA.index - 1) % verticesLength];
    nearestDistance =
        normalX * (bodyAPositionX - vertexC.x) +
        normalY * (bodyAPositionY - vertexC.y);
    vertexB = vertices[(vertexA.index + 1) % verticesLength];

    if (normalX * (bodyAPositionX - vertexB.x) +
            normalY * (bodyAPositionY - vertexB.y) <
        nearestDistance) {
      _supports[0] = vertexA;
      _supports[1] = vertexB;
      return _supports;
    }

    _supports[0] = vertexA;
    _supports[1] = vertexC;
    return _supports;
  }
}

/// matter-jsの`contact`。
class MatterContact {
  MatterVertex? vertex;
  double normalImpulse = 0;
  double tangentImpulse = 0;
}

/// matter-jsの`pair`。
class MatterPair {
  MatterPair(this.collision, double timestamp)
    : id = MatterPair.idOf(collision.bodyA, collision.bodyB),
      bodyA = collision.bodyA,
      bodyB = collision.bodyB,
      contacts = [MatterContact(), MatterContact()],
      isSensor = collision.bodyA.isSensor || collision.bodyB.isSensor,
      timeCreated = timestamp,
      timeUpdated = timestamp {
    update(this, collision, timestamp);
  }

  final String id;
  final MatterBody bodyA;
  final MatterBody bodyB;
  MatterCollision collision;
  final List<MatterContact> contacts;
  int contactCount = 0;
  double separation = 0;
  bool isActive = true;
  final bool isSensor;
  final double timeCreated;
  double timeUpdated;
  double inverseMass = 0;
  double friction = 0;
  double frictionStatic = 0;
  double restitution = 0;
  double slop = 0;

  static void update(
    MatterPair pair,
    MatterCollision collision,
    double timestamp,
  ) {
    final supports = collision.supports;
    final supportCount = collision.supportCount;
    final contacts = pair.contacts;
    final parentA = collision.parentA;
    final parentB = collision.parentB;

    pair.isActive = true;
    pair.timeUpdated = timestamp;
    pair.collision = collision;
    pair.separation = collision.depth;
    pair.inverseMass = parentA.inverseMass + parentB.inverseMass;
    pair.friction = parentA.friction < parentB.friction
        ? parentA.friction
        : parentB.friction;
    pair.frictionStatic = parentA.frictionStatic > parentB.frictionStatic
        ? parentA.frictionStatic
        : parentB.frictionStatic;
    pair.restitution = parentA.restitution > parentB.restitution
        ? parentA.restitution
        : parentB.restitution;
    pair.slop = parentA.slop > parentB.slop ? parentA.slop : parentB.slop;
    pair.contactCount = supportCount;
    collision.pair = pair;

    final supportA = supports[0];
    var contactA = contacts[0];
    final supportB = supports[1];
    var contactB = contacts[1];

    // 前フレームと支持点が入れ替わっていた場合は接触情報も入れ替える
    if (identical(contactB.vertex, supportA) ||
        identical(contactA.vertex, supportB)) {
      contacts[1] = contactA;
      contacts[0] = contactB;
      contactA = contactB;
      contactB = contacts[1];
    }

    contactA.vertex = supportA;
    contactB.vertex = supportB;
  }

  static void setActive(MatterPair pair, bool isActive, double timestamp) {
    if (isActive) {
      pair.isActive = true;
      pair.timeUpdated = timestamp;
    } else {
      pair.isActive = false;
      pair.contactCount = 0;
    }
  }

  static String idOf(MatterBody bodyA, MatterBody bodyB) => bodyA.id < bodyB.id
      ? "${bodyA.id.toRadixString(36)}:${bodyB.id.toRadixString(36)}"
      : "${bodyB.id.toRadixString(36)}:${bodyA.id.toRadixString(36)}";
}

/// matter-jsの`pairs`。
class MatterPairs {
  final Map<String, MatterPair> table = {};
  final List<MatterPair> list = [];
  final List<MatterPair> collisionStart = [];
  final List<MatterPair> collisionActive = [];
  final List<MatterPair> collisionEnd = [];

  static void update(
    MatterPairs pairs,
    List<MatterCollision> collisions,
    double timestamp,
  ) {
    final pairsTable = pairs.table;
    final pairsList = pairs.list;
    final collisionStart = pairs.collisionStart;
    final collisionEnd = pairs.collisionEnd;
    final collisionActive = pairs.collisionActive;

    collisionStart.clear();
    collisionActive.clear();
    collisionEnd.clear();

    for (var i = 0; i < collisions.length; i++) {
      final collision = collisions[i];
      final pair = collision.pair;

      if (pair != null) {
        if (pair.isActive) {
          collisionActive.add(pair);
        }
        MatterPair.update(pair, collision, timestamp);
      } else {
        final created = MatterPair(collision, timestamp);
        pairsTable[created.id] = created;
        collisionStart.add(created);
        pairsList.add(created);
      }
    }

    // 今フレームで更新されなかったペアを終了扱いにする
    final retained = <MatterPair>[];
    for (var i = 0; i < pairsList.length; i++) {
      final pair = pairsList[i];
      if (pair.timeUpdated >= timestamp) {
        retained.add(pair);
      } else {
        MatterPair.setActive(pair, false, timestamp);
        if (pair.collision.bodyA.sleepCounter > 0 &&
            pair.collision.bodyB.sleepCounter > 0) {
          retained.add(pair);
        } else {
          collisionEnd.add(pair);
          pairsTable.remove(pair.id);
        }
      }
    }

    pairsList
      ..clear()
      ..addAll(retained);
  }

  static void clear(MatterPairs pairs) {
    pairs.table.clear();
    pairs.list.clear();
    pairs.collisionStart.clear();
    pairs.collisionActive.clear();
    pairs.collisionEnd.clear();
  }
}

/// matter-jsの`detector`。
class MatterDetector {
  List<MatterBody> bodies = [];
  final List<MatterCollision> collisions = [];
  MatterPairs? pairs;

  static void setBodies(MatterDetector detector, List<MatterBody> bodies) {
    detector.bodies = bodies.toList();
  }

  static void clear(MatterDetector detector) {
    detector.bodies = [];
    detector.collisions.clear();
  }

  /// 総当たりの前に境界のx最小値でソートして枝刈りする (sweep and prune)。
  static List<MatterCollision> detectCollisions(MatterDetector detector) {
    final pairs = detector.pairs;
    final bodies = detector.bodies;
    final bodiesLength = bodies.length;
    final collisions = detector.collisions;
    collisions.clear();

    // JSのArray.prototype.sortは安定ソートなので順序を揃える
    matterStableSort(bodies, (a, b) {
      final delta = a.bounds.min.x - b.bounds.min.x;
      return delta < 0
          ? -1
          : delta > 0
          ? 1
          : 0;
    });

    for (var i = 0; i < bodiesLength; i++) {
      final bodyA = bodies[i];
      final boundXMax = bodyA.bounds.max.x;
      final boundYMax = bodyA.bounds.max.y;
      final boundYMin = bodyA.bounds.min.y;
      final bodyAStatic = bodyA.isStatic || bodyA.isSleeping;
      final partsALength = bodyA.parts.length;
      final partsASingle = partsALength == 1;

      for (var j = i + 1; j < bodiesLength; j++) {
        final bodyB = bodies[j];
        final boundsB = bodyB.bounds;

        if (boundsB.min.x > boundXMax) break;

        if (boundYMax < boundsB.min.y || boundYMin > boundsB.max.y) continue;

        if (bodyAStatic && (bodyB.isStatic || bodyB.isSleeping)) continue;

        final partsBLength = bodyB.parts.length;

        if (partsASingle && partsBLength == 1) {
          final collision = MatterCollisions.collides(bodyA, bodyB, pairs);
          if (collision != null) collisions.add(collision);
        } else {
          final partsAStart = partsALength > 1 ? 1 : 0;
          final partsBStart = partsBLength > 1 ? 1 : 0;

          for (var k = partsAStart; k < partsALength; k++) {
            final partA = bodyA.parts[k];
            final partBoundsA = partA.bounds;

            for (var z = partsBStart; z < partsBLength; z++) {
              final partB = bodyB.parts[z];
              final partBoundsB = partB.bounds;

              if (partBoundsA.min.x > partBoundsB.max.x ||
                  partBoundsA.max.x < partBoundsB.min.x ||
                  partBoundsA.max.y < partBoundsB.min.y ||
                  partBoundsA.min.y > partBoundsB.max.y) {
                continue;
              }

              final collision = MatterCollisions.collides(partA, partB, pairs);
              if (collision != null) collisions.add(collision);
            }
          }
        }
      }
    }

    return collisions;
  }
}
