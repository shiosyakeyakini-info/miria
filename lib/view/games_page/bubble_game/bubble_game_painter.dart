import "dart:ui" as ui;

import "package:flutter/material.dart";
import "package:miria/model/bubble_game/drop_and_fusion_game.dart";
import "package:miria/model/bubble_game/mono.dart";
import "package:miria/util/matter/geometry.dart";
import "package:miria/view/games_page/bubble_game/mono_textures.dart";

/// ゲームの盤面を描く。
///
/// 座標は本家と同じ450x600のゲーム内座標のまま扱い、
/// 最後にウィジェットの大きさへ拡大縮小する。
class BubbleGamePainter extends CustomPainter {
  BubbleGamePainter({
    required this.game,
    required this.textures,
    required this.dropperX,
    required this.canDrop,
    required this.colorScheme,
    required super.repaint,
  });

  final DropAndFusionGame game;
  final MonoTextures? textures;
  final double dropperX;
  final bool canDrop;
  final ColorScheme colorScheme;

  /// これより上でモノがぶつかるとゲームオーバーになる位置。
  static const double _dangerLineY = 100;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / DropAndFusionGame.gameWidth;
    canvas
      ..save()
      ..scale(scale);

    _paintField(canvas);
    _paintDropper(canvas);

    for (final body in game.getBodyStates()) {
      _paintMono(canvas, body);
    }

    canvas.restore();
  }

  void _paintField(Canvas canvas) {
    const margin = DropAndFusionGame.playareaMargin;
    final field = Rect.fromLTRB(
      margin,
      0,
      DropAndFusionGame.gameWidth - margin,
      DropAndFusionGame.gameHeight - margin,
    );

    canvas
      ..drawRect(field, Paint()..color = colorScheme.surfaceContainerHighest)
      ..drawLine(
        Offset(field.left, _dangerLineY),
        Offset(field.right, _dangerLineY),
        Paint()
          ..color = colorScheme.error.withValues(alpha: 0.4)
          ..strokeWidth = 1,
      )
      ..drawRect(
        field,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = colorScheme.outlineVariant,
      );
  }

  /// 次に落とすモノと、落ちる位置のガイドを描く。
  void _paintDropper(Canvas canvas) {
    final pick = game.stock.firstOrNull;
    if (pick == null || game.isGameOver) return;

    const margin = DropAndFusionGame.playareaMargin;
    final x = dropperX.clamp(
      margin + pick.mono.sizeX / 2,
      DropAndFusionGame.gameWidth - margin - pick.mono.sizeX / 2,
    );
    final y = 50 + pick.mono.sizeY / 2;
    final opacity = canDrop ? 1.0 : 0.4;

    canvas
      ..drawLine(
        Offset(x, y),
        Offset(x, DropAndFusionGame.gameHeight - margin),
        Paint()
          ..color = colorScheme.primary.withValues(alpha: canDrop ? 0.5 : 0.15)
          ..strokeWidth = 1,
      )
      ..save()
      ..translate(x, y);
    if (!_paintSprite(canvas, pick.mono, opacity: opacity)) {
      _paintFallbackShape(canvas, pick.mono, opacity: opacity);
    }
    canvas.restore();
  }

  void _paintMono(Canvas canvas, BubbleGameBodyState body) {
    canvas
      ..save()
      ..translate(body.x, body.y)
      ..rotate(body.angle);
    final painted = _paintSprite(canvas, body.mono);
    canvas.restore();

    if (painted) return;

    // 画像が無いときは当たり判定の形をそのまま描く。
    // 多角形の頂点は絶対座標で持っているので、変換をかけずにそのまま使う。
    if (body.mono.shape == MonoShape.custom && body.vertices.isNotEmpty) {
      _paintPolygon(canvas, body.vertices);
      return;
    }

    canvas
      ..save()
      ..translate(body.x, body.y)
      ..rotate(body.angle);
    _paintFallbackShape(canvas, body.mono);
    canvas.restore();
  }

  /// 画像を描く。画像がまだ読めていなければ何もせずfalseを返す。
  bool _paintSprite(Canvas canvas, Mono mono, {double opacity = 1}) {
    final image = textures?[mono];
    if (image == null) return false;

    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromCenter(
        center: Offset.zero,
        width: mono.sizeX * mono.spriteScale,
        height: mono.sizeY * mono.spriteScale,
      ),
      Paint()
        ..filterQuality = FilterQuality.medium
        ..color = Colors.white.withValues(alpha: opacity),
    );
    return true;
  }

  void _paintFallbackShape(Canvas canvas, Mono mono, {double opacity = 1}) {
    final paint = Paint()
      ..color = colorScheme.primary.withValues(alpha: opacity);

    switch (mono.shape) {
      case MonoShape.rectangle:
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: mono.sizeX,
            height: mono.sizeY,
          ),
          paint,
        );
      case MonoShape.circle:
      case MonoShape.custom:
        canvas.drawCircle(Offset.zero, mono.sizeX / 2, paint);
    }
  }

  void _paintPolygon(Canvas canvas, List<MatterVector> vertices) {
    final path = ui.Path()..moveTo(vertices.first.x, vertices.first.y);
    for (final vertex in vertices.skip(1)) {
      path.lineTo(vertex.x, vertex.y);
    }
    path.close();

    canvas.drawPath(path, Paint()..color = colorScheme.primary);
  }

  @override
  bool shouldRepaint(BubbleGamePainter oldDelegate) =>
      oldDelegate.game != game ||
      oldDelegate.textures != textures ||
      oldDelegate.dropperX != dropperX ||
      oldDelegate.canDrop != canDrop;
}
