/// 盤面の位置を棋譜の表記に直す。
///
/// リバーシの棋譜は列を英小文字、行を 1 始まりの数字で書く（8x8 の左上が
/// `a1`、定石でよく見る `f5` は 5 行目の 6 列目）。Misskey は通し番号しか
/// 持たないので、表示のたびにマップの幅から組み立てる。
library;

/// [pos] を `f5` のような表記にする。[mapWidth] はマップの横幅。
String reversiPosLabel(int pos, int mapWidth) {
  final x = pos % mapWidth;
  final y = pos ~/ mapWidth;
  return "${_column(x)}${y + 1}";
}

/// 列番号を英小文字にする。
///
/// 組み込みマップの最大幅は 17 (Two board) なので z を超えることはないが、
/// 超えたときに黙って壊れるよりは数字で出す。
String _column(int x) => x < 26 ? String.fromCharCode(0x61 + x) : "${x + 1}";
