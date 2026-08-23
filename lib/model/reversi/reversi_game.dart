/// Misskey のリバーシのルールエンジンを Dart に移植したもの。
///
/// 移植元は `misskey-dev/misskey` の `packages/misskey-reversi/src/game.ts`
/// (AGPL-3.0-only, syuilo and misskey-project)。
///
/// サーバーは打たれた手のログだけを配信し、盤面そのものは送ってこない
/// （`ReversiService.putStoneToGame` が流すのは `log` イベント 1 件だけ）。
/// つまりクライアントはサーバーと**同一のルール実装**を持っていないと盤面を
/// 再現できない。だからこの移植は見た目の都合ではなく必須で、しかも
/// 挙動が 1 箇所でもずれると `reversi/verify` の crc32 が合わなくなる。
/// 読みやすさより移植元との一致を優先している箇所があるのはそのため。
library;

import "dart:convert";

import "package:miria/model/reversi/reversi_crc32.dart";

/// 石の色。移植元の `Color`（`true` が黒、`false` が白）に対応する。
///
/// Misskey の API もこの真偽値表現をそのまま使う
/// （対局ログの `player`、`black` は 1 なら user1 が黒）ので、
/// enum に置き換えず素の [bool] のままにしている。
typedef ReversiColor = bool;

/// 黒。
const reversiBlack = true;

/// 白。
const reversiWhite = false;

/// 盤面のマス。
///
/// 移植元では `Color | null | undefined` の 3 状態で持っている。
/// Dart には `undefined` がないので列挙型にした。[empty] と [none] の
/// 区別は必須で、潰すと「盤面に存在しないマス」に石が置けてしまう
/// （移植元の `canPut` は `board[pos] !== null` で `undefined` を弾いている）。
enum ReversiCell {
  /// 黒石が置かれている（移植元の `true`）。
  black,

  /// 白石が置かれている（移植元の `false`）。
  white,

  /// 石が置かれていない、置けるマス（移植元の `null`）。
  empty,

  /// マップ上に存在しないマス（移植元の `undefined`）。
  none;

  /// 石が置かれているならその色、置かれていないなら null。
  ReversiColor? get color => switch (this) {
    ReversiCell.black => reversiBlack,
    ReversiCell.white => reversiWhite,
    _ => null,
  };

  /// [color] に対応するマス。
  static ReversiCell of(ReversiColor color) =>
      color ? ReversiCell.black : ReversiCell.white;
}

/// マップの各マスが盤面として存在するかどうか。移植元の `MapCell`。
enum ReversiMapCell {
  /// 石を置ける（かもしれない）マス。
  empty,

  /// 盤面として存在しないマス。
  none,
}

/// 対局のルール設定。移植元の `Options`。
class ReversiGameOptions {
  const ReversiGameOptions({
    this.isLlotheo = false,
    this.canPutEverywhere = false,
    this.loopedBoard = false,
  });

  /// 石の少ない方が勝ち。
  final bool isLlotheo;

  /// 相手の石を挟めなくても置ける。
  final bool canPutEverywhere;

  /// 盤面の端がループして繋がる。
  final bool loopedBoard;
}

/// [ReversiGame.undo] のための 1 手ぶんの記録。移植元の `Undo`。
class ReversiUndo {
  const ReversiUndo({
    required this.color,
    required this.pos,
    required this.effects,
    required this.turn,
  });

  /// 打った色。
  final ReversiColor color;

  /// 打った位置。
  final int pos;

  /// 反転した石の位置。
  final List<int> effects;

  /// 打つ前の手番。
  final ReversiColor? turn;
}

/// リバーシの盤面とルール。移植元の `Game`。
class ReversiGame {
  /// [mapLines] は 1 行 1 文字列のマップ定義。
  /// `-` が空きマス、`b` が黒石、`w` が白石、それ以外（半角スペース）は
  /// 盤面として存在しないマス。
  ReversiGame(List<String> mapLines, {this.opts = const ReversiGameOptions()})
    : assert(mapLines.isNotEmpty, "マップが空"),
      mapWidth = mapLines.first.length,
      mapHeight = mapLines.length,
      board = mapLines
          .join()
          .split("")
          .map(
            (e) => switch (e) {
              "-" => ReversiCell.empty,
              "b" => ReversiCell.black,
              "w" => ReversiCell.white,
              _ => ReversiCell.none,
            },
          )
          .toList(),
      map = mapLines
          .join()
          .split("")
          .map(
            (e) => switch (e) {
              "-" || "b" || "w" => ReversiMapCell.empty,
              _ => ReversiMapCell.none,
            },
          )
          .toList() {
    // 開始時点で片方の色の石しかない、あるいは開始時点で勝敗が決まるマップがある。
    if (!canPutSomewhere(reversiBlack)) {
      turn = canPutSomewhere(reversiWhite) ? reversiWhite : null;
    }
  }

  /// マップ（マスが存在するかどうか）。
  final List<ReversiMapCell> map;

  /// マップの横幅。
  final int mapWidth;

  /// マップの高さ。
  final int mapHeight;

  /// 盤面。
  final List<ReversiCell> board;

  /// ルール設定。
  final ReversiGameOptions opts;

  /// 現在の手番。null なら対局終了。
  ReversiColor? turn = reversiBlack;

  /// 直前に打たれた位置。まだ 1 手も打たれていなければ -1。
  int prevPos = -1;

  /// 直前に打った色。
  ReversiColor? prevColor;

  final List<ReversiUndo> _logs = [];

  /// 黒石の数。
  int get blackCount => board.where((e) => e == ReversiCell.black).length;

  /// 白石の数。
  int get whiteCount => board.where((e) => e == ReversiCell.white).length;

  /// 通し番号を (x, y) に変換する。
  (int, int) posToXy(int pos) => (pos % mapWidth, pos ~/ mapWidth);

  /// (x, y) を通し番号に変換する。
  int xyToPos(int x, int y) => x + (y * mapWidth);

  /// [pos] に現在の手番の石を打つ。
  ///
  /// 打てるかどうかは検証しない（移植元も同じ）。呼ぶ前に [canPut] で確かめること。
  void putStone(int pos) {
    final color = turn;
    if (color == null) return;

    prevPos = pos;
    prevColor = color;

    board[pos] = ReversiCell.of(color);

    // 反転させられる石を取得
    final effects = this.effects(color, pos);

    // 反転させる
    for (final effect in effects) {
      board[effect] = ReversiCell.of(color);
    }

    _logs.add(
      ReversiUndo(color: color, pos: pos, effects: effects, turn: turn),
    );

    _calcTurn();
  }

  void _calcTurn() {
    // 移植元の `!this.prevColor` は prevColor が null のとき true になる。
    final opposite = !(prevColor ?? false);
    turn = canPutSomewhere(opposite)
        ? opposite
        : canPutSomewhere(prevColor!)
        ? prevColor
        : null;
  }

  /// 直前の 1 手を取り消す。
  void undo() {
    if (_logs.isEmpty) return;
    final undo = _logs.removeLast();

    prevColor = undo.color;
    prevPos = undo.pos;
    board[undo.pos] = ReversiCell.empty;
    for (final pos in undo.effects) {
      // 移植元の `!color`。黒以外はすべて黒になる。
      board[pos] = board[pos] == ReversiCell.black
          ? ReversiCell.white
          : ReversiCell.black;
    }
    turn = undo.turn;
  }

  /// [pos] のマスが盤面として存在するかどうか。
  ReversiMapCell mapDataGet(int pos) {
    final (x, y) = posToXy(pos);
    return x < 0 || y < 0 || x >= mapWidth || y >= mapHeight
        ? ReversiMapCell.none
        : map[pos];
  }

  /// [color] が打てるマスの一覧。
  List<int> getPuttablePlaces(ReversiColor color) => [
    for (var i = 0; i < board.length; i++)
      if (canPut(color, i)) i,
  ];

  /// [color] がどこかに打てるかどうか。
  bool canPutSomewhere(ReversiColor color) =>
      getPuttablePlaces(color).isNotEmpty;

  /// [color] が [pos] に打てるかどうか。
  bool canPut(ReversiColor color, int pos) {
    // 既に石が置いてある場所、および盤面として存在しないマスには打てない。
    if (board[pos] != ReversiCell.empty) return false;
    // 挟んでなくても置けるモード
    if (opts.canPutEverywhere) return mapDataGet(pos) == ReversiMapCell.empty;
    // 相手の石を 1 つでも反転させられるか
    return effects(color, pos).isNotEmpty;
  }

  /// 指定のマスに石を置いた時の、反転させられる石を取得する。
  ///
  /// [color] は自分の色、[initPos] は置く位置。
  List<int> effects(ReversiColor color, int initPos) {
    final enemyColor = ReversiCell.of(!color);
    final myColor = ReversiCell.of(color);

    const diffVectors = <(int, int)>[
      (0, -1), // 上
      (1, -1), // 右上
      (1, 0), // 右
      (1, 1), // 右下
      (0, 1), // 下
      (-1, 1), // 左下
      (-1, 0), // 左
      (-1, -1), // 左上
    ];

    List<int> effectsInLine((int, int) diff) {
      final (dx, dy) = diff;

      // 挟めるかもしれない相手の石を入れておく配列
      final found = <int>[];
      var (x, y) = posToXy(initPos);

      while (true) {
        x += dx;
        y += dy;

        // 座標が指し示す位置がボード外に出たとき
        if (opts.loopedBoard) {
          x = ((x % mapWidth) + mapWidth) % mapWidth;
          y = ((y % mapHeight) + mapHeight) % mapHeight;
          if (xyToPos(x, y) == initPos) {
            // 盤面の境界でループし、自分が石を置く位置に戻ってきたとき、
            // 挟めるようにしている
            return found;
          }
        } else if (x == -1 || y == -1 || x == mapWidth || y == mapHeight) {
          // 挟めないことが確定（盤面外に到達）
          return [];
        }

        final pos = xyToPos(x, y);
        // 挟めないことが確定（配置不可能なマスに到達）
        if (mapDataGet(pos) == ReversiMapCell.none) return [];

        final stone = board[pos];
        // 挟めないことが確定（石が置かれていないマスに到達）
        if (stone == ReversiCell.empty) return [];
        // 挟めるかもしれない（相手の石を発見）
        if (stone == enemyColor) found.add(pos);
        // 挟めることが確定（対となる自分の石を発見）
        if (stone == myColor) return found;
      }
    }

    return [for (final diff in diffVectors) ...effectsInLine(diff)];
  }

  /// 盤面と手番から求めた CRC32。`reversi/verify` に渡して同期を確かめる。
  ///
  /// 移植元は `CRC32.str(JSON.stringify({ board, turn }))`。JSON.stringify は
  /// 配列中の `undefined` を `null` として書き出すので、[ReversiCell.none] と
  /// [ReversiCell.empty] はどちらも `null` になる。
  int calcCrc32() {
    final buffer = StringBuffer('{"board":[');
    for (var i = 0; i < board.length; i++) {
      if (i > 0) buffer.write(",");
      buffer.write(switch (board[i]) {
        ReversiCell.black => "true",
        ReversiCell.white => "false",
        _ => "null",
      });
    }
    buffer
      ..write('],"turn":')
      ..write(switch (turn) {
        null => "null",
        reversiBlack => "true",
        _ => "false",
      })
      ..write("}");

    return crc32(utf8.encode(buffer.toString()));
  }

  /// 対局が終了しているかどうか。
  bool get isEnded => turn == null;

  /// 勝者の色。引き分けなら null。
  ///
  /// 終了していないときに読んではいけない（移植元は `undefined as never` を返す）。
  ReversiColor? get winner {
    assert(isEnded, "対局が終了していないのに winner を読んでいる");
    if (blackCount == whiteCount) return null;
    // 移植元は `opts.isLlotheo === blackCount > whiteCount ? WHITE : BLACK`。
    // `>` の方が `===` より強く結合するので、比較対象は真偽値どうし。
    return opts.isLlotheo == (blackCount > whiteCount)
        ? reversiWhite
        : reversiBlack;
  }
}
