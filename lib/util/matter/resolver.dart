/// matter-js v0.20.0 の `Resolver` の移植。
library;

import "dart:math" as math;

import "package:miria/util/matter/body.dart";
import "package:miria/util/matter/collision.dart";
import "package:miria/util/matter/geometry.dart";

const double _baseDelta = 1000 / 60;

abstract final class MatterResolver {
  static const double _restingThresh = 2;
  static final double _restingThreshTangent = math.sqrt(6);
  static const double _positionDampen = 0.9;
  static const double _positionWarming = 0.8;
  static const double _frictionNormalMultiplier = 5;
  static const double _frictionMaxStatic = double.maxFinite;

  /// 各ボディの接触点の総数を数える。
  static void preSolvePosition(List<MatterPair> pairs) {
    for (var i = 0; i < pairs.length; i++) {
      final pair = pairs[i];
      if (!pair.isActive) continue;
      final contactCount = pair.contactCount;
      pair.collision.parentA.totalContacts += contactCount;
      pair.collision.parentB.totalContacts += contactCount;
    }
  }

  /// めり込みを解消するための位置の補正量を求める。
  static void solvePosition(
    List<MatterPair> pairs,
    double delta,
    double damping,
  ) {
    final positionDampen = _positionDampen * damping;
    final slopDampen = _clamp(delta / _baseDelta, 0, 1);

    for (var i = 0; i < pairs.length; i++) {
      final pair = pairs[i];
      if (!pair.isActive || pair.isSensor) continue;

      final collision = pair.collision;
      final bodyA = collision.parentA;
      final bodyB = collision.parentB;
      final normal = collision.normal;

      pair.separation =
          collision.depth +
          normal.x * (bodyB.positionImpulse.x - bodyA.positionImpulse.x) +
          normal.y * (bodyB.positionImpulse.y - bodyA.positionImpulse.y);
    }

    for (var i = 0; i < pairs.length; i++) {
      final pair = pairs[i];
      if (!pair.isActive || pair.isSensor) continue;

      final collision = pair.collision;
      final bodyA = collision.parentA;
      final bodyB = collision.parentB;
      final normal = collision.normal;
      var positionImpulse = pair.separation - pair.slop * slopDampen;

      if (bodyA.isStatic || bodyB.isStatic) positionImpulse *= 2;

      if (!(bodyA.isStatic || bodyA.isSleeping)) {
        final contactShare = positionDampen / bodyA.totalContacts;
        bodyA.positionImpulse.x += normal.x * positionImpulse * contactShare;
        bodyA.positionImpulse.y += normal.y * positionImpulse * contactShare;
      }

      if (!(bodyB.isStatic || bodyB.isSleeping)) {
        final contactShare = positionDampen / bodyB.totalContacts;
        bodyB.positionImpulse.x -= normal.x * positionImpulse * contactShare;
        bodyB.positionImpulse.y -= normal.y * positionImpulse * contactShare;
      }
    }
  }

  /// 求めた補正量を実際の位置に反映する。
  static void postSolvePosition(List<MatterBody> bodies) {
    for (var i = 0; i < bodies.length; i++) {
      final body = bodies[i];
      final positionImpulse = body.positionImpulse;
      final positionImpulseX = positionImpulse.x;
      final positionImpulseY = positionImpulse.y;
      final velocity = body.velocity;

      body.totalContacts = 0;

      if (positionImpulseX != 0 || positionImpulseY != 0) {
        for (var j = 0; j < body.parts.length; j++) {
          final part = body.parts[j];
          MatterVertices.translate(part.vertices, positionImpulse);
          MatterBounds.update(part.bounds, part.vertices, velocity);
          part.position.x += positionImpulseX;
          part.position.y += positionImpulseY;
        }

        // 速度を変えずに位置だけ動かす
        body.positionPrev.x += positionImpulseX;
        body.positionPrev.y += positionImpulseY;

        if (positionImpulseX * velocity.x + positionImpulseY * velocity.y < 0) {
          positionImpulse.x = 0;
          positionImpulse.y = 0;
        } else {
          positionImpulse.x *= _positionWarming;
          positionImpulse.y *= _positionWarming;
        }
      }
    }
  }

  /// 前フレームの力積を先に適用しておく (warm starting)。
  static void preSolveVelocity(List<MatterPair> pairs) {
    for (var i = 0; i < pairs.length; i++) {
      final pair = pairs[i];
      if (!pair.isActive || pair.isSensor) continue;

      final contacts = pair.contacts;
      final contactCount = pair.contactCount;
      final collision = pair.collision;
      final bodyA = collision.parentA;
      final bodyB = collision.parentB;
      final normal = collision.normal;
      final tangent = collision.tangent;

      for (var j = 0; j < contactCount; j++) {
        final contact = contacts[j];
        final contactVertex = contact.vertex!;
        final normalImpulse = contact.normalImpulse;
        final tangentImpulse = contact.tangentImpulse;

        if (normalImpulse != 0 || tangentImpulse != 0) {
          final impulseX =
              normal.x * normalImpulse + tangent.x * tangentImpulse;
          final impulseY =
              normal.y * normalImpulse + tangent.y * tangentImpulse;

          if (!(bodyA.isStatic || bodyA.isSleeping)) {
            bodyA.positionPrev.x += impulseX * bodyA.inverseMass;
            bodyA.positionPrev.y += impulseY * bodyA.inverseMass;
            bodyA.anglePrev +=
                bodyA.inverseInertia *
                ((contactVertex.x - bodyA.position.x) * impulseY -
                    (contactVertex.y - bodyA.position.y) * impulseX);
          }

          if (!(bodyB.isStatic || bodyB.isSleeping)) {
            bodyB.positionPrev.x -= impulseX * bodyB.inverseMass;
            bodyB.positionPrev.y -= impulseY * bodyB.inverseMass;
            bodyB.anglePrev -=
                bodyB.inverseInertia *
                ((contactVertex.x - bodyB.position.x) * impulseY -
                    (contactVertex.y - bodyB.position.y) * impulseX);
          }
        }
      }
    }
  }

  /// 反発と摩擦を解く。
  static void solveVelocity(List<MatterPair> pairs, double delta) {
    final timeScale = delta / _baseDelta;
    final timeScaleSquared = timeScale * timeScale;
    final timeScaleCubed = timeScaleSquared * timeScale;
    final restingThresh = -_restingThresh * timeScale;
    final restingThreshTangent = _restingThreshTangent;
    final frictionNormalMultiplier = _frictionNormalMultiplier * timeScale;

    for (var i = 0; i < pairs.length; i++) {
      final pair = pairs[i];
      if (!pair.isActive || pair.isSensor) continue;

      final collision = pair.collision;
      final bodyA = collision.parentA;
      final bodyB = collision.parentB;
      final normalX = collision.normal.x;
      final normalY = collision.normal.y;
      final tangentX = collision.tangent.x;
      final tangentY = collision.tangent.y;
      final inverseMassTotal = pair.inverseMass;
      final friction =
          pair.friction * pair.frictionStatic * frictionNormalMultiplier;
      final contacts = pair.contacts;
      final contactCount = pair.contactCount;
      final contactShare = 1 / contactCount;

      final bodyAVelocityX = bodyA.position.x - bodyA.positionPrev.x;
      final bodyAVelocityY = bodyA.position.y - bodyA.positionPrev.y;
      final bodyAAngularVelocity = bodyA.angle - bodyA.anglePrev;
      final bodyBVelocityX = bodyB.position.x - bodyB.positionPrev.x;
      final bodyBVelocityY = bodyB.position.y - bodyB.positionPrev.y;
      final bodyBAngularVelocity = bodyB.angle - bodyB.anglePrev;

      for (var j = 0; j < contactCount; j++) {
        final contact = contacts[j];
        final contactVertex = contact.vertex!;

        final offsetAX = contactVertex.x - bodyA.position.x;
        final offsetAY = contactVertex.y - bodyA.position.y;
        final offsetBX = contactVertex.x - bodyB.position.x;
        final offsetBY = contactVertex.y - bodyB.position.y;

        final velocityPointAX =
            bodyAVelocityX - offsetAY * bodyAAngularVelocity;
        final velocityPointAY =
            bodyAVelocityY + offsetAX * bodyAAngularVelocity;
        final velocityPointBX =
            bodyBVelocityX - offsetBY * bodyBAngularVelocity;
        final velocityPointBY =
            bodyBVelocityY + offsetBX * bodyBAngularVelocity;

        final relativeVelocityX = velocityPointAX - velocityPointBX;
        final relativeVelocityY = velocityPointAY - velocityPointBY;

        final normalVelocity =
            normalX * relativeVelocityX + normalY * relativeVelocityY;
        final tangentVelocity =
            tangentX * relativeVelocityX + tangentY * relativeVelocityY;

        // クーロン摩擦
        final normalOverlap = pair.separation + normalVelocity;
        var normalForce = math.min(normalOverlap, 1.0);
        normalForce = normalOverlap < 0 ? 0.0 : normalForce;

        final frictionLimit = normalForce * friction;

        double tangentImpulse;
        double maxFriction;

        if (tangentVelocity < -frictionLimit ||
            tangentVelocity > frictionLimit) {
          maxFriction = tangentVelocity > 0
              ? tangentVelocity
              : -tangentVelocity;
          tangentImpulse =
              pair.friction * (tangentVelocity > 0 ? 1 : -1) * timeScaleCubed;

          if (tangentImpulse < -maxFriction) {
            tangentImpulse = -maxFriction;
          } else if (tangentImpulse > maxFriction) {
            tangentImpulse = maxFriction;
          }
        } else {
          tangentImpulse = tangentVelocity;
          maxFriction = _frictionMaxStatic;
        }

        final oAcN = offsetAX * normalY - offsetAY * normalX;
        final oBcN = offsetBX * normalY - offsetBY * normalX;
        final share =
            contactShare /
            (inverseMassTotal +
                bodyA.inverseInertia * oAcN * oAcN +
                bodyB.inverseInertia * oBcN * oBcN);

        var normalImpulse = (1 + pair.restitution) * normalVelocity * share;
        tangentImpulse *= share;

        if (normalVelocity < restingThresh) {
          contact.normalImpulse = 0;
        } else {
          // 静止している接触はErin Cattoの方法で解く
          final contactNormalImpulse = contact.normalImpulse;
          contact.normalImpulse += normalImpulse;
          if (contact.normalImpulse > 0) contact.normalImpulse = 0;
          normalImpulse = contact.normalImpulse - contactNormalImpulse;
        }

        if (tangentVelocity < -restingThreshTangent ||
            tangentVelocity > restingThreshTangent) {
          contact.tangentImpulse = 0;
        } else {
          final contactTangentImpulse = contact.tangentImpulse;
          contact.tangentImpulse += tangentImpulse;
          if (contact.tangentImpulse < -maxFriction) {
            contact.tangentImpulse = -maxFriction;
          }
          if (contact.tangentImpulse > maxFriction) {
            contact.tangentImpulse = maxFriction;
          }
          tangentImpulse = contact.tangentImpulse - contactTangentImpulse;
        }

        final impulseX = normalX * normalImpulse + tangentX * tangentImpulse;
        final impulseY = normalY * normalImpulse + tangentY * tangentImpulse;

        if (!(bodyA.isStatic || bodyA.isSleeping)) {
          bodyA.positionPrev.x += impulseX * bodyA.inverseMass;
          bodyA.positionPrev.y += impulseY * bodyA.inverseMass;
          bodyA.anglePrev +=
              (offsetAX * impulseY - offsetAY * impulseX) *
              bodyA.inverseInertia;
        }

        if (!(bodyB.isStatic || bodyB.isSleeping)) {
          bodyB.positionPrev.x -= impulseX * bodyB.inverseMass;
          bodyB.positionPrev.y -= impulseY * bodyB.inverseMass;
          bodyB.anglePrev -=
              (offsetBX * impulseY - offsetBY * impulseX) *
              bodyB.inverseInertia;
        }
      }
    }
  }
}

double _clamp(double value, double min, double max) {
  if (value < min) return min;
  if (value > max) return max;
  return value;
}
