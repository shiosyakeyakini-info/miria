import "package:flutter/material.dart";
import "package:miria/model/reversi/reversi_game.dart";
import "package:miria/view/common/misskey_notes/network_image.dart";

/// リバーシの盤面。
///
/// マス目は marionette からは「ただの矩形」にしか見えないので、1 マスずつ
/// [Key] に `reversi-cell-<pos>` を持たせてある。これで `tap --key` から
/// 位置を指定して打てる。盤面の中身の確認は Riverpod の状態側
/// （`ReversiGameState.toJson` の `board`）を読む。
class ReversiBoard extends StatelessWidget {
  const ReversiBoard({
    required this.game,
    required this.onTapCell,
    this.puttable = const [],
    this.lastPos,
    this.blackAvatarUrl,
    this.whiteAvatarUrl,
    super.key,
  });

  /// 描画する盤面。
  final ReversiGame game;

  /// 打てる位置。ここに印を出す。
  final List<int> puttable;

  /// 直前に打たれた位置。
  final int? lastPos;

  /// 黒を持っているユーザーのアバター。null なら石だけ描く。
  final Uri? blackAvatarUrl;

  /// 白を持っているユーザーのアバター。null なら石だけ描く。
  final Uri? whiteAvatarUrl;

  /// マスが押されたときに呼ばれる。
  final void Function(int pos) onTapCell;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AspectRatio(
      aspectRatio: game.mapWidth / game.mapHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellSize = constraints.maxWidth / game.mapWidth;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var y = 0; y < game.mapHeight; y++)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var x = 0; x < game.mapWidth; x++)
                      _ReversiCellTile(
                        pos: game.xyToPos(x, y),
                        cell: game.board[game.xyToPos(x, y)],
                        size: cellSize,
                        isPuttable: puttable.contains(game.xyToPos(x, y)),
                        isLast: lastPos == game.xyToPos(x, y),
                        onTap: onTapCell,
                        boardColor: theme.colorScheme.primaryContainer,
                        lineColor: theme.colorScheme.onPrimaryContainer,
                        blackAvatarUrl: blackAvatarUrl,
                        whiteAvatarUrl: whiteAvatarUrl,
                      ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ReversiCellTile extends StatelessWidget {
  const _ReversiCellTile({
    required this.pos,
    required this.cell,
    required this.size,
    required this.isPuttable,
    required this.isLast,
    required this.onTap,
    required this.boardColor,
    required this.lineColor,
    required this.blackAvatarUrl,
    required this.whiteAvatarUrl,
  });

  final int pos;
  final ReversiCell cell;
  final double size;
  final bool isPuttable;
  final bool isLast;
  final void Function(int pos) onTap;
  final Color boardColor;
  final Color lineColor;
  final Uri? blackAvatarUrl;
  final Uri? whiteAvatarUrl;

  @override
  Widget build(BuildContext context) {
    // 盤面として存在しないマスは、押せない空白として置く。
    if (cell == ReversiCell.none) {
      return SizedBox(width: size, height: size);
    }

    return GestureDetector(
      key: Key("reversi-cell-$pos"),
      onTap: () => onTap(pos),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isPuttable
              ? Color.alphaBlend(lineColor.withValues(alpha: 0.15), boardColor)
              : boardColor,
          // 直前に打たれたマスだけ枠を強調する。
          border: Border.all(
            color: isLast
                ? Theme.of(context).colorScheme.error
                : lineColor.withValues(alpha: 0.4),
            width: isLast ? 2 : 0.5,
          ),
        ),
        child: Center(
          child: switch (cell) {
            ReversiCell.black => ReversiStone(
              diameter: size * 0.78,
              color: Colors.black,
              avatarUrl: blackAvatarUrl,
            ),
            ReversiCell.white => ReversiStone(
              diameter: size * 0.78,
              color: Colors.white,
              avatarUrl: whiteAvatarUrl,
            ),
            // 打てるマスには小さい点を出す。
            _ when isPuttable => Container(
              width: size * 0.2,
              height: size * 0.2,
              decoration: BoxDecoration(
                color: lineColor.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
            ),
            _ => const SizedBox.shrink(),
          },
        ),
      ),
    );
  }
}

/// 1 つの石。
///
/// 本家の Misskey は `useAvatarAsStone` が既定 ON で、石そのものを持ち主の
/// アバターに差し替える。ここでは黒白の円を残してその内側にアバターを敷き、
/// ふちとして色が見えるようにしている。アバターだけにすると、似た絵柄の
/// ユーザーどうしや読み込み前にどちらの石か分からなくなるため。
class ReversiStone extends StatelessWidget {
  const ReversiStone({
    required this.diameter,
    required this.color,
    this.avatarUrl,
    super.key,
  });

  /// 石の直径。
  final double diameter;

  /// 石の色。[Colors.black] か [Colors.white]。
  final Color color;

  /// 石の持ち主のアバター。null なら石だけ描く。
  final Uri? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = this.avatarUrl;

    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: avatarUrl == null
          ? null
          : Padding(
              // 黒白のふちの太さ。細すぎると色が読めず、太いとアバターが潰れる。
              padding: EdgeInsets.all(diameter * 0.09),
              child: ClipOval(
                child: NetworkImageView(
                  url: avatarUrl.toString(),
                  type: ImageType.avatarIcon,
                  fit: BoxFit.cover,
                  // 読み込めなかったときは素の石に戻す。既定のエラー表示は
                  // 灰色の四角なので、盤面に置くと石に見えなくなる。
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),
            ),
    );
  }
}
