/// リバーシの盤面同期チェックに使う CRC32。
///
/// Misskey サーバーは `reversi/verify` で受け取った crc32 を、自分が計算した
/// 値と**文字列として**比較する（`ReversiService.checkCrc`）。サーバー側は
/// npm の `crc-32` パッケージを使っており、その `CRC32.str()` は結果を
/// **符号付き 32bit** で返す。したがってここも符号付きで返さないと、
/// 上位ビットが立った瞬間に文字列比較が食い違って毎回 desync 扱いになる。
library;

/// CRC-32 (IEEE 802.3) のテーブル。
final _table = List<int>.generate(256, (index) {
  var value = index;
  for (var bit = 0; bit < 8; bit++) {
    value = (value & 1) != 0 ? (value >> 1) ^ 0xEDB88320 : value >> 1;
  }
  return value;
}, growable: false);

/// [bytes] の CRC32 を符号付き 32bit で返す。
///
/// 符号付きにする理由は library ドキュメント参照。
int crc32(List<int> bytes) {
  var crc = 0xFFFFFFFF;
  for (final byte in bytes) {
    crc = _table[(crc ^ byte) & 0xFF] ^ (crc >> 8);
  }
  crc = (crc ^ 0xFFFFFFFF) & 0xFFFFFFFF;

  // JavaScript の `>>> 0` を挟まない `crc-32` と同じく符号付きで返す。
  return crc > 0x7FFFFFFF ? crc - 0x100000000 : crc;
}
