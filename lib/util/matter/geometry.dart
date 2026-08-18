/// [matter-js](https://github.com/liabru/matter-js) v0.20.0 の
/// `Vector` / `Bounds` / `Axes` / `Vertices` に相当する部分の移植。
///
/// 本家Misskeyのバブルゲームはmatter-jsの挙動そのものがゲーム性になっており、
/// またリプレイのために決定的である必要があるため、
/// 独自実装ではなく計算順序まで含めて忠実に移植している。
library;

import "dart:math" as math;

import "package:miria/util/matter/js_math.dart";

/// matter-jsの`vector`。matter-jsは値を破壊的に書き換えるためmutableにしている。
class MatterVector {
  MatterVector(this.x, this.y);

  MatterVector.zero() : x = 0, y = 0;

  double x;
  double y;

  MatterVector clone() => MatterVector(x, y);

  static double magnitude(MatterVector vector) =>
      math.sqrt(vector.x * vector.x + vector.y * vector.y);

  static double dot(MatterVector a, MatterVector b) => a.x * b.x + a.y * b.y;

  static double cross(MatterVector a, MatterVector b) => a.x * b.y - a.y * b.x;

  static double cross3(MatterVector a, MatterVector b, MatterVector c) =>
      (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x);

  static MatterVector add(MatterVector a, MatterVector b) =>
      MatterVector(a.x + b.x, a.y + b.y);

  static MatterVector sub(MatterVector a, MatterVector b) =>
      MatterVector(a.x - b.x, a.y - b.y);

  static MatterVector mult(MatterVector v, double scalar) =>
      MatterVector(v.x * scalar, v.y * scalar);

  static MatterVector div(MatterVector v, double scalar) =>
      MatterVector(v.x / scalar, v.y / scalar);

  static MatterVector normalise(MatterVector vector) {
    final magnitude = MatterVector.magnitude(vector);
    if (magnitude == 0) return MatterVector(0, 0);
    return MatterVector(vector.x / magnitude, vector.y / magnitude);
  }

  static MatterVector rotate(MatterVector vector, double angle) {
    final cos = jsCos(angle);
    final sin = jsSin(angle);
    return MatterVector(
      vector.x * cos - vector.y * sin,
      vector.x * sin + vector.y * cos,
    );
  }

  /// `Vector.rotateAbout(vector, angle, point, output)`相当。
  /// matter-jsは`output`に書き戻すため、こちらも[output]を破壊的に更新する。
  static void rotateAbout(
    MatterVector vector,
    double angle,
    MatterVector point,
    MatterVector output,
  ) {
    final cos = jsCos(angle);
    final sin = jsSin(angle);
    final x =
        point.x + ((vector.x - point.x) * cos - (vector.y - point.y) * sin);
    output.y =
        point.y + ((vector.x - point.x) * sin + (vector.y - point.y) * cos);
    output.x = x;
  }

  /// `Vector.angle`相当。
  ///
  /// `atan2`はDartとV8で最終ビットが違うことがあるが、
  /// この値は頂点を角度順に並べ替えるときの比較にしか使われず、
  /// 多角形の頂点どうしの角度が1ulp差になることはないため、
  /// ここではdart:mathのものをそのまま使っている。
  static double angleBetween(MatterVector a, MatterVector b) =>
      math.atan2(b.y - a.y, b.x - a.x);
}

/// matter-jsの`vertices`の要素。
class MatterVertex extends MatterVector {
  MatterVertex(super.x, super.y, {required this.index, required this.body});

  final int index;
  final Object? body;
  bool isInternal = false;
}

/// matter-jsの`bounds` (AABB)。
class MatterBounds {
  MatterBounds() : min = MatterVector.zero(), max = MatterVector.zero();

  factory MatterBounds.fromVertices(List<MatterVector> vertices) {
    final bounds = MatterBounds();
    MatterBounds.update(bounds, vertices, null);
    return bounds;
  }

  final MatterVector min;
  final MatterVector max;

  static void update(
    MatterBounds bounds,
    List<MatterVector> vertices,
    MatterVector? velocity,
  ) {
    bounds.min.x = double.infinity;
    bounds.max.x = double.negativeInfinity;
    bounds.min.y = double.infinity;
    bounds.max.y = double.negativeInfinity;

    for (var i = 0; i < vertices.length; i++) {
      final vertex = vertices[i];
      if (vertex.x > bounds.max.x) bounds.max.x = vertex.x;
      if (vertex.x < bounds.min.x) bounds.min.x = vertex.x;
      if (vertex.y > bounds.max.y) bounds.max.y = vertex.y;
      if (vertex.y < bounds.min.y) bounds.min.y = vertex.y;
    }

    if (velocity != null) {
      if (velocity.x > 0) {
        bounds.max.x += velocity.x;
      } else {
        bounds.min.x += velocity.x;
      }
      if (velocity.y > 0) {
        bounds.max.y += velocity.y;
      } else {
        bounds.min.y += velocity.y;
      }
    }
  }

  static bool overlaps(MatterBounds a, MatterBounds b) =>
      a.min.x <= b.max.x &&
      a.max.x >= b.min.x &&
      a.max.y >= b.min.y &&
      a.min.y <= b.max.y;
}

/// JSの`Number.prototype.toFixed(3)`と同じ文字列を返す。
///
/// Dartの`toStringAsFixed`は`-0.0`を`"-0.000"`にするが、
/// JSは`(-0).toFixed(3) === "0.000"`となるためそこだけ揃える。
/// またJSは`Infinity.toFixed(3) === "Infinity"`を返す。
String jsToFixed3(double value) {
  if (value.isNaN) return "NaN";
  if (value.isInfinite) return value > 0 ? "Infinity" : "-Infinity";
  if (value == 0) return "0.000";
  return value.toStringAsFixed(3);
}

/// matter-jsの`axes`。
abstract final class MatterAxes {
  static List<MatterVector> fromVertices(List<MatterVector> vertices) {
    // 辺の法線の傾きをキーにして重複する軸を除く。
    // JSのオブジェクトと同じく挿入順を保つ必要があるためLinkedHashMapを使う。
    final axes = <String, MatterVector>{};

    for (var i = 0; i < vertices.length; i++) {
      final j = (i + 1) % vertices.length;
      final normal = MatterVector.normalise(
        MatterVector(
          vertices[j].y - vertices[i].y,
          vertices[i].x - vertices[j].x,
        ),
      );
      final gradient = normal.y == 0 ? double.infinity : (normal.x / normal.y);
      axes[jsToFixed3(gradient)] = normal;
    }

    return axes.values.toList();
  }

  static void rotate(List<MatterVector> axes, double angle) {
    if (angle == 0) return;

    final cos = jsCos(angle);
    final sin = jsSin(angle);

    for (var i = 0; i < axes.length; i++) {
      final axis = axes[i];
      final xx = axis.x * cos - axis.y * sin;
      axis.y = axis.x * sin + axis.y * cos;
      axis.x = xx;
    }
  }
}

/// matter-jsの`vertices`。
abstract final class MatterVertices {
  static List<MatterVertex> create(List<MatterVector> points, Object? body) => [
    for (var i = 0; i < points.length; i++)
      MatterVertex(points[i].x, points[i].y, index: i, body: body),
  ];

  static MatterVector centre(List<MatterVector> vertices) {
    final area = MatterVertices.area(vertices, signed: true);
    var centre = MatterVector(0, 0);

    for (var i = 0; i < vertices.length; i++) {
      final j = (i + 1) % vertices.length;
      final cross = MatterVector.cross(vertices[i], vertices[j]);
      final temp = MatterVector.mult(
        MatterVector.add(vertices[i], vertices[j]),
        cross,
      );
      centre = MatterVector.add(centre, temp);
    }

    return MatterVector.div(centre, 6 * area);
  }

  static MatterVector mean(List<MatterVector> vertices) {
    final average = MatterVector(0, 0);
    for (var i = 0; i < vertices.length; i++) {
      average.x += vertices[i].x;
      average.y += vertices[i].y;
    }
    return MatterVector.div(average, vertices.length.toDouble());
  }

  static double area(List<MatterVector> vertices, {bool signed = false}) {
    var area = 0.0;
    var j = vertices.length - 1;

    for (var i = 0; i < vertices.length; i++) {
      area += (vertices[j].x - vertices[i].x) * (vertices[j].y + vertices[i].y);
      j = i;
    }

    if (signed) return area / 2;
    return area.abs() / 2;
  }

  static double inertia(List<MatterVector> vertices, double mass) {
    var numerator = 0.0;
    var denominator = 0.0;
    final v = vertices;

    for (var n = 0; n < v.length; n++) {
      final j = (n + 1) % v.length;
      final cross = MatterVector.cross(v[j], v[n]).abs();
      numerator +=
          cross *
          (MatterVector.dot(v[j], v[j]) +
              MatterVector.dot(v[j], v[n]) +
              MatterVector.dot(v[n], v[n]));
      denominator += cross;
    }

    return (mass / 6) * (numerator / denominator);
  }

  static void translate(
    List<MatterVector> vertices,
    MatterVector vector, {
    double scalar = 1,
  }) {
    final translateX = vector.x * scalar;
    final translateY = vector.y * scalar;
    for (var i = 0; i < vertices.length; i++) {
      vertices[i].x += translateX;
      vertices[i].y += translateY;
    }
  }

  static void rotate(
    List<MatterVector> vertices,
    double angle,
    MatterVector point,
  ) {
    if (angle == 0) return;

    final cos = jsCos(angle);
    final sin = jsSin(angle);
    final pointX = point.x;
    final pointY = point.y;

    for (var i = 0; i < vertices.length; i++) {
      final vertex = vertices[i];
      final dx = vertex.x - pointX;
      final dy = vertex.y - pointY;
      vertex.x = pointX + (dx * cos - dy * sin);
      vertex.y = pointY + (dx * sin + dy * cos);
    }
  }

  static bool contains(List<MatterVector> vertices, MatterVector point) {
    final pointX = point.x;
    final pointY = point.y;
    var vertex = vertices[vertices.length - 1];

    for (var i = 0; i < vertices.length; i++) {
      final nextVertex = vertices[i];
      if ((pointX - vertex.x) * (nextVertex.y - vertex.y) +
              (pointY - vertex.y) * (vertex.x - nextVertex.x) >
          0) {
        return false;
      }
      vertex = nextVertex;
    }

    return true;
  }

  /// 時計回りに並べ替える。
  /// JSの`Array.prototype.sort`は安定ソートなので[_stableSort]を使う。
  static List<MatterVector> clockwiseSort(List<MatterVector> vertices) {
    final centre = mean(vertices);
    _stableSort(
      vertices,
      (a, b) => _sign(
        MatterVector.angleBetween(centre, a) -
            MatterVector.angleBetween(centre, b),
      ),
    );
    return vertices;
  }

  /// 凸ならtrue、凹ならfalse、判定できない場合はnull。
  static bool? isConvex(List<MatterVector> vertices) {
    var flag = 0;
    final n = vertices.length;

    if (n < 3) return null;

    for (var i = 0; i < n; i++) {
      final j = (i + 1) % n;
      final k = (i + 2) % n;
      var z = (vertices[j].x - vertices[i].x) * (vertices[k].y - vertices[j].y);
      z -= (vertices[j].y - vertices[i].y) * (vertices[k].x - vertices[j].x);

      if (z < 0) {
        flag |= 1;
      } else if (z > 0) {
        flag |= 2;
      }

      if (flag == 3) return false;
    }

    return flag != 0 ? true : null;
  }

  /// 凸包を求める。
  static List<MatterVector> hull(List<MatterVector> vertices) {
    final upper = <MatterVector>[];
    final lower = <MatterVector>[];

    final sorted = vertices.toList();
    _stableSort(sorted, (a, b) {
      final dx = a.x - b.x;
      return dx != 0 ? _sign(dx) : _sign(a.y - b.y);
    });

    for (var i = 0; i < sorted.length; i++) {
      final vertex = sorted[i];
      while (lower.length >= 2 &&
          MatterVector.cross3(
                lower[lower.length - 2],
                lower[lower.length - 1],
                vertex,
              ) <=
              0) {
        lower.removeLast();
      }
      lower.add(vertex);
    }

    for (var i = sorted.length - 1; i >= 0; i--) {
      final vertex = sorted[i];
      while (upper.length >= 2 &&
          MatterVector.cross3(
                upper[upper.length - 2],
                upper[upper.length - 1],
                vertex,
              ) <=
              0) {
        upper.removeLast();
      }
      upper.add(vertex);
    }

    upper.removeLast();
    lower.removeLast();

    return [...upper, ...lower];
  }
}

int _sign(double value) => value < 0
    ? -1
    : value > 0
    ? 1
    : 0;

/// 安定ソート (マージソート)。
/// JSの`Array.prototype.sort`は安定なので、順序に依存する箇所で挙動を揃えるために使う。
void _stableSort<T>(List<T> list, int Function(T a, T b) compare) {
  if (list.length < 2) return;
  final buffer = List<T>.of(list);
  _mergeSortRange(list, buffer, 0, list.length, compare);
}

void _mergeSortRange<T>(
  List<T> list,
  List<T> buffer,
  int start,
  int end,
  int Function(T a, T b) compare,
) {
  if (end - start < 2) return;
  final middle = start + (end - start) ~/ 2;
  _mergeSortRange(list, buffer, start, middle, compare);
  _mergeSortRange(list, buffer, middle, end, compare);

  for (var i = start; i < end; i++) {
    buffer[i] = list[i];
  }

  var left = start;
  var right = middle;
  for (var i = start; i < end; i++) {
    if (left < middle &&
        (right >= end || compare(buffer[left], buffer[right]) <= 0)) {
      list[i] = buffer[left++];
    } else {
      list[i] = buffer[right++];
    }
  }
}

/// 内部で使う安定ソート。matter-jsの`Detector`など順序が結果に影響する箇所で使う。
void matterStableSort<T>(List<T> list, int Function(T a, T b) compare) =>
    _stableSort(list, compare);
