/// [seedrandom](https://github.com/davidbau/seedrandom) v3.0.5 の
/// 既定PRNG (ARC4) をDartに移植したもの。
///
/// Misskey本家のバブルゲームはシード付きの乱数列でドロップするモノを決めており、
/// リプレイやスコア検証のために同じシードから同じ列が出る必要がある。
/// そのため`Random`ではなく本家と同じアルゴリズムを用いる。
library;

/// 各RC4出力の値域 (0 <= x < 256)
const int _width = 256;

/// doubleひとつを作るのに使うRC4出力の数
const int _chunks = 6;

/// doubleの有効桁数
const int _digits = 52;

final double _startdenom = _pow(_width.toDouble(), _chunks);
final double _significance = _pow(2, _digits);
final double _overflow = _significance * 2;
const int _mask = _width - 1;

double _pow(double x, int n) {
  var result = 1.0;
  for (var i = 0; i < n; i++) {
    result *= x;
  }
  return result;
}

/// JSの`ToInt32`相当。`^=`などのビット演算がJSでは32bit符号付きで行われるため。
int _toInt32(int value) => value.toSigned(32);

class _Arc4 {
  _Arc4(List<int> key) {
    var keyList = key;
    var keylen = keyList.length;
    // 空のキーは[0]として扱う
    if (keylen == 0) {
      keyList = [0];
      keylen = 1;
    }

    for (var i = 0; i < _width; i++) {
      _s[i] = i;
    }
    var j = 0;
    for (var i = 0; i < _width; i++) {
      final t = _s[i];
      j = _mask & (j + keyList[i % keylen] + t);
      _s[i] = _s[j];
      _s[j] = t;
    }

    // RC4-drop[256]
    g(_width);
  }

  final List<int> _s = List<int>.filled(_width, 0);
  int _i = 0;
  int _j = 0;

  /// 次の[count]個の出力を1つの数として返す (0 <= x < 256 ^ count)。
  int g(int count) {
    var r = 0;
    var i = _i;
    var j = _j;
    for (var n = count; n > 0; n--) {
      i = _mask & (i + 1);
      final t = _s[i];
      j = _mask & (j + t);
      _s[i] = _s[j];
      _s[j] = t;
      r = r * _width + _s[_mask & (_s[i] + t)];
    }
    _i = i;
    _j = j;
    return r;
  }
}

/// 文字列のシードを整数配列のキーに混ぜ込む。
List<int> _mixkey(String seed) {
  final key = <int, int>{};
  var smear = 0;
  for (var j = 0; j < seed.length; j++) {
    final index = _mask & j;
    // JSでは未定義要素との演算がNaN経由で0になる
    final previous = key[index];
    smear = _toInt32(smear ^ (previous == null ? 0 : _toInt32(previous * 19)));
    key[index] = _mask & (smear + seed.codeUnitAt(j));
  }
  // Common.valuesと同じく挿入順で取り出す
  return key.values.toList();
}

/// seedrandomと同じ乱数列を生成する。
class SeedRandom {
  SeedRandom(String seed) : _arc4 = _Arc4(_mixkey(seed));

  final _Arc4 _arc4;

  /// [0, 1) のdoubleを返す。JSの`prng()`と同じ値を返す。
  double nextDouble() {
    var n = _arc4.g(_chunks).toDouble();
    var d = _startdenom;
    var x = 0;
    while (n < _significance) {
      n = (n + x) * _width;
      d *= _width;
      x = _arc4.g(1);
    }
    while (n >= _overflow) {
      n /= 2;
      d /= 2;
      x >>= 1;
    }
    return (n + x) / d;
  }
}
