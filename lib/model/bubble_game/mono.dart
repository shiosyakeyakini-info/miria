/// バブルゲーム (ドロップ＆フュージョン) で落ちてくる「モノ」の定義。
///
/// Misskey本家の`packages/misskey-bubble-game`の`Mono`型に、
/// フロントエンド側が持っている表示用の情報 (画像・効果音の音程) を合わせたもの。
library;

/// モノの当たり判定の形状。
enum MonoShape {
  /// 円 (matter-jsでは多角形で近似される)
  circle,

  /// 矩形
  rectangle,

  /// 任意の多角形
  custom,
}

/// [MonoShape.custom]のモノの頂点。
class MonoVertex {
  const MonoVertex(this.x, this.y);

  final double x;
  final double y;
}

/// バブルゲームのモノ1種類ぶんの定義。
class Mono {
  const Mono({
    required this.id,
    required this.level,
    required this.sizeX,
    required this.sizeY,
    required this.shape,
    this.vertices,
    this.verticesSize,
    required this.score,
    required this.dropCandidate,
    required this.img,
    required this.imgSizeX,
    required this.imgSizeY,
    required this.spriteScale,
    required this.sfxPitch,
  });

  final String id;

  /// 合体するとひとつ上のレベルのモノになる。
  final int level;
  final double sizeX;
  final double sizeY;
  final MonoShape shape;

  /// [MonoShape.custom]のときの頂点。[verticesSize]を基準とした座標。
  final List<List<MonoVertex>>? vertices;
  final double? verticesSize;

  /// 合体したときに入る得点。
  final int score;

  /// 上から落ちてくる候補かどうか。
  final bool dropCandidate;

  /// インスタンス上の画像のパス。
  final String img;
  final double imgSizeX;
  final double imgSizeY;
  final double spriteScale;

  /// 合体時の効果音の音程。
  final double sfxPitch;
}

/// バブルゲームのゲームモード。
enum BubbleGameMode {
  normal("normal", "pt"),
  yen("yen", "円"),
  square("square", "pt"),
  sweets("sweets", "kcal"),
  space("space", "");

  const BubbleGameMode(this.apiValue, this.scoreUnit);

  /// `bubble-game/register`などのAPIに渡す値。
  final String apiValue;

  /// スコアの単位。本家の表示に合わせている。
  final String scoreUnit;
}
