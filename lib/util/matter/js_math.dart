/// JavaScriptの`Math.sin` / `Math.cos`と同じ値を返す実装。
///
/// バブルスコアの検証にはmatter-jsと同じ計算結果が要る一方、
/// Dartの`dart:math`の三角関数はプラットフォームのlibmを使うため
/// V8とは最終ビットが食い違うことがある (実測で約2%)。
/// 96回の位置補正を毎フレーム回すソルバでは、この1ulpの差が数百フレームで
/// 目に見える差に育ってしまう。
///
/// そこでNode.js 22系 (V8 12.4) の`src/base/ieee754.cc`が使っている
/// fdlibm由来の実装をDartに移植している。
///
/// 合わせる相手をV8にしているのは意図的で、`Math.sin`/`Math.cos`は
/// ECMAScriptの仕様上エンジンごとに結果が違ってよいことになっている。
/// V8はfdlibmを同梱していてOSによらず同じ結果を出すが、
/// SpiderMonkeyとJavaScriptCoreは既定でシステムのlibmを使うため一致しない
/// (実測で衝突が2%前後あり、再生させると別の試合になる)。
/// サーバーはNode.js (V8) で動いているので、そこに合わせておくのが安全。
/// 詳細は`test/bubble_game/README.md`を参照。
library;

import "dart:math" as math;
import "dart:typed_data";

final _conversionBuffer = ByteData(8);

/// doubleの上位32bit。C言語の`GET_HIGH_WORD`相当。
int _highWord(double value) {
  _conversionBuffer.setFloat64(0, value);
  return _conversionBuffer.getUint32(0);
}

/// 上位・下位32bitからdoubleを組み立てる。`INSERT_WORDS`相当。
double _fromWords(int high, int low) {
  _conversionBuffer.setUint32(0, high & 0xFFFFFFFF);
  _conversionBuffer.setUint32(4, low & 0xFFFFFFFF);
  return _conversionBuffer.getFloat64(0);
}

/// Cの`static_cast<int>(double)` (0方向への切り捨て)。
int _truncate(double value) => value.truncate();

const double _half = 0.5;
const double _one = 1;

// __kernel_sin の係数
const double _s1 = -1.66666666666666324348e-01;
const double _s2 = 8.33333333332248946124e-03;
const double _s3 = -1.98412698298579493134e-04;
const double _s4 = 2.75573137070700676789e-06;
const double _s5 = -2.50507602534068634195e-08;
const double _s6 = 1.58969099521155010221e-10;

// __kernel_cos の係数
const double _c1 = 4.16666666666666019037e-02;
const double _c2 = -1.38888888888741095749e-03;
const double _c3 = 2.48015872894767294178e-05;
const double _c4 = -2.75573143513906633035e-07;
const double _c5 = 2.08757232129817482790e-09;
const double _c6 = -1.13596475577881948265e-11;

// __ieee754_rem_pio2 の定数
const double _invpio2 = 6.36619772367581382433e-01;
const double _pio2_1 = 1.57079632673412561417e+00;
const double _pio2_1t = 6.07710050650619224932e-11;
const double _pio2_2 = 6.07710050630396597660e-11;
const double _pio2_2t = 2.02226624879595063154e-21;
const double _pio2_3 = 2.02226624871116645580e-21;
const double _pio2_3t = 8.47842766036889956997e-32;

const List<int> _npio2Hw = [
  0x3FF921FB,
  0x400921FB,
  0x4012D97C,
  0x401921FB,
  0x401F6A7A,
  0x4022D97C,
  0x4025FDBB,
  0x402921FB,
  0x402C463A,
  0x402F6A7A,
  0x4031475C,
  0x4032D97C,
  0x40346B9C,
  0x4035FDBB,
  0x40378FDB,
  0x403921FB,
  0x403AB41B,
  0x403C463A,
  0x403DD85A,
  0x403F6A7A,
  0x40407E4C,
  0x4041475C,
  0x4042106C,
  0x4042D97C,
  0x4043A28C,
  0x40446B9C,
  0x404534AC,
  0x4045FDBB,
  0x4046C6CB,
  0x40478FDB,
  0x404858EB,
  0x404921FB,
];

/// `[-pi/4, pi/4]`でのsin。[y]は[x]の下位ビット、[iy]が0なら[y]を無視する。
double _kernelSin(double x, double y, int iy) {
  final ix = _highWord(x) & 0x7FFFFFFF;
  if (ix < 0x3E400000) {
    // |x| < 2**-27
    if (_truncate(x) == 0) return x;
  }
  final z = x * x;
  final v = z * x;
  final r = _s2 + z * (_s3 + z * (_s4 + z * (_s5 + z * _s6)));
  if (iy == 0) {
    return x + v * (_s1 + z * r);
  }
  return x - ((z * (_half * y - v * r) - y) - v * _s1);
}

/// `[-pi/4, pi/4]`でのcos。
double _kernelCos(double x, double y) {
  final ix = _highWord(x) & 0x7FFFFFFF;
  if (ix < 0x3E400000) {
    if (_truncate(x) == 0) return _one;
  }
  final z = x * x;
  final r = z * (_c1 + z * (_c2 + z * (_c3 + z * (_c4 + z * (_c5 + z * _c6)))));
  if (ix < 0x3FD33333) {
    // |x| < 0.3
    return _one - (0.5 * z - (z * r - x * y));
  }
  final double qx;
  if (ix > 0x3FE90000) {
    // x > 0.78125
    qx = 0.28125;
  } else {
    qx = _fromWords(ix - 0x00200000, 0);
  }
  final iz = 0.5 * z - qx;
  final a = _one - qx;
  return a - (iz - (z * r - x * y));
}

/// `x`をpi/2で割った余りを`y[0] + y[1]`として返し、商を返す。
///
/// 巨大な引数 (|x| > 2^19*(pi/2)) 向けの`__kernel_rem_pio2`は移植していない。
/// 回転角としてそのような値が現れることはないため、
/// 万一渡された場合は[jsSin]/[jsCos]側でdart:mathにフォールバックする。
int _remPio2(double x, List<double> y) {
  final hx = _highWord(x).toSigned(32);
  final ix = hx & 0x7FFFFFFF;

  if (ix <= 0x3FE921FB) {
    // |x| ~<= pi/4
    y[0] = x;
    y[1] = 0;
    return 0;
  }

  if (ix < 0x4002D97C) {
    // |x| < 3pi/4
    if (hx > 0) {
      var z = x - _pio2_1;
      if (ix != 0x3FF921FB) {
        y[0] = z - _pio2_1t;
        y[1] = (z - y[0]) - _pio2_1t;
      } else {
        z -= _pio2_2;
        y[0] = z - _pio2_2t;
        y[1] = (z - y[0]) - _pio2_2t;
      }
      return 1;
    } else {
      var z = x + _pio2_1;
      if (ix != 0x3FF921FB) {
        y[0] = z + _pio2_1t;
        y[1] = (z - y[0]) + _pio2_1t;
      } else {
        z += _pio2_2;
        y[0] = z + _pio2_2t;
        y[1] = (z - y[0]) + _pio2_2t;
      }
      return -1;
    }
  }

  // |x| ~<= 2^19*(pi/2)
  var t = x.abs();
  final n = _truncate(t * _invpio2 + _half);
  final fn = n.toDouble();
  var r = t - fn * _pio2_1;
  var w = fn * _pio2_1t; // 1回目で85bit相当
  if (n < 32 && ix != _npio2Hw[n - 1]) {
    y[0] = r - w;
  } else {
    final j = ix >> 20;
    y[0] = r - w;
    var high = _highWord(y[0]);
    var i = j - ((high >> 20) & 0x7FF);
    if (i > 16) {
      // 2回目で118bit相当
      t = r;
      w = fn * _pio2_2;
      r = t - w;
      w = fn * _pio2_2t - ((t - r) - w);
      y[0] = r - w;
      high = _highWord(y[0]);
      i = j - ((high >> 20) & 0x7FF);
      if (i > 49) {
        // 3回目で151bit相当
        t = r;
        w = fn * _pio2_3;
        r = t - w;
        w = fn * _pio2_3t - ((t - r) - w);
        y[0] = r - w;
      }
    }
  }
  y[1] = (r - y[0]) - w;

  if (hx < 0) {
    y[0] = -y[0];
    y[1] = -y[1];
    return -n;
  }
  return n;
}

/// `__ieee754_rem_pio2`の移植範囲を超える大きさかどうか。
bool _isTooLargeForRemPio2(int ix) => ix > 0x413921FB;

/// JavaScriptの`Math.sin`と同じ値を返す。
double jsSin(double x) {
  final ix = _highWord(x) & 0x7FFFFFFF;

  if (ix <= 0x3FE921FB) {
    return _kernelSin(x, 0, 0);
  }
  if (ix >= 0x7FF00000) {
    return x - x;
  }
  if (_isTooLargeForRemPio2(ix)) {
    return math.sin(x);
  }

  final y = [0.0, 0.0];
  final n = _remPio2(x, y);
  return switch (n & 3) {
    0 => _kernelSin(y[0], y[1], 1),
    1 => _kernelCos(y[0], y[1]),
    2 => -_kernelSin(y[0], y[1], 1),
    _ => -_kernelCos(y[0], y[1]),
  };
}

/// JavaScriptの`Math.cos`と同じ値を返す。
double jsCos(double x) {
  final ix = _highWord(x) & 0x7FFFFFFF;

  if (ix <= 0x3FE921FB) {
    return _kernelCos(x, 0);
  }
  if (ix >= 0x7FF00000) {
    return x - x;
  }
  if (_isTooLargeForRemPio2(ix)) {
    return math.cos(x);
  }

  final y = [0.0, 0.0];
  final n = _remPio2(x, y);
  return switch (n & 3) {
    0 => _kernelCos(y[0], y[1]),
    1 => -_kernelSin(y[0], y[1], 1),
    2 => -_kernelCos(y[0], y[1]),
    _ => _kernelSin(y[0], y[1], 1),
  };
}
