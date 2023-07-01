import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/misskey_notes/custom_emoji.dart';
import 'package:miria/view/photo_edit_page/edited_photo_image.dart';

class ClipMode extends ConsumerStatefulWidget {
  final GlobalKey renderingGlobalKey;

  const ClipMode({super.key, required this.renderingGlobalKey});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ClipModeState();
}

class ClipModeState extends ConsumerState<ClipMode> {
  final basePadding = 20;
  final iconSize = 40;

  @override
  Widget build(BuildContext context) {
    final clipMode =
        ref.watch(photoEditProvider.select((value) => value.clipMode));
    final defaultSize =
        ref.watch(photoEditProvider.select((value) => value.defaultSize));
    final cropOffset =
        ref.watch(photoEditProvider.select((value) => value.cropOffset));
    final actualSize =
        ref.watch(photoEditProvider.select((value) => value.actualSize));
    final cropSize =
        ref.watch(photoEditProvider.select((value) => value.cropSize));
    final reactions =
        ref.watch(photoEditProvider.select((value) => value.emojis));
    final selectedReaction = ref
        .watch(photoEditProvider.select((value) => value.selectedEmojiIndex));

    final ratio = defaultSize.width / actualSize.width;

    return SizedBox(
      width: defaultSize.width + (basePadding * ratio) * 2,
      height: defaultSize.height + (basePadding * ratio) * 2,
      child: Listener(
        onPointerMove: selectedReaction == null
            ? null
            : (detail) =>
                ref.read(photoEditProvider.notifier).reactionMove(detail),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onScaleStart: selectedReaction == null
              ? null
              : (detail) => ref
                  .read(photoEditProvider.notifier)
                  .reactionScaleStart(detail),
          onScaleUpdate: selectedReaction == null
              ? null
              : (detail) => ref
                  .read(photoEditProvider.notifier)
                  .reactionScaleUpdate(detail),
          child: RepaintBoundary(
            key: widget.renderingGlobalKey,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const EditedPhotoImage(),
                if (clipMode) ...[
                  // mask
                  Positioned(
                      left: cropOffset.dx + basePadding * ratio,
                      top: cropOffset.dy + basePadding * ratio,
                      width: cropSize.width,
                      height: cropSize.height,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white.withAlpha(150),
                                width: 2 * ratio)),
                      )),

                  //left top-down
                  Positioned(
                      left: basePadding * ratio,
                      top: basePadding * ratio,
                      width: cropOffset.dx,
                      height: defaultSize.height,
                      child: DecoratedBox(
                        decoration:
                            BoxDecoration(color: Colors.black87.withAlpha(150)),
                      )),
                  //right top-down
                  Positioned(
                      left:
                          cropOffset.dx + basePadding * ratio + cropSize.width,
                      top: basePadding * ratio,
                      width: defaultSize.width - cropSize.width - cropOffset.dx,
                      height: defaultSize.height,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Colors.black87.withAlpha(150)))),
                  //left over crop
                  Positioned(
                      left: basePadding * ratio + cropOffset.dx,
                      top: basePadding * ratio,
                      width: cropSize.width,
                      height: cropOffset.dy,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Colors.black87.withAlpha(150)))),

                  //left under crop
                  Positioned(
                      left: basePadding * ratio + cropOffset.dx,
                      top:
                          basePadding * ratio + cropSize.height + cropOffset.dy,
                      width: cropSize.width,
                      height:
                          defaultSize.height - cropSize.height - cropOffset.dy,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Colors.black87.withAlpha(150)))),

                  Positioned(
                    left: cropOffset.dx - (iconSize / 2 - basePadding) * ratio,
                    top: cropOffset.dy - (iconSize / 2 - basePadding) * ratio,
                    width: iconSize * ratio,
                    height: iconSize * ratio,
                    child: Listener(
                      behavior: HitTestBehavior.translucent,
                      onPointerMove: (detail) => ref
                          .read(photoEditProvider.notifier)
                          .cropMoveLeftTop(detail),
                      child: Icon(Icons.add, size: iconSize * ratio),
                    ),
                  ),
                  Positioned(
                    left: cropOffset.dx +
                        cropSize.width -
                        (iconSize / 2 - basePadding) * ratio,
                    top: cropOffset.dy - (iconSize / 2 - basePadding) * ratio,
                    child: Listener(
                      behavior: HitTestBehavior.translucent,
                      onPointerMove: (detail) => ref
                          .read(photoEditProvider.notifier)
                          .cropMoveRightTop(detail),
                      child: Icon(Icons.add, size: 40 * ratio),
                    ),
                  ),
                  Positioned(
                    left: cropOffset.dx - (iconSize / 2 - basePadding) * ratio,
                    top: cropOffset.dy +
                        cropSize.height -
                        (iconSize / 2 - basePadding) / 2 * ratio,
                    child: Listener(
                      behavior: HitTestBehavior.translucent,
                      onPointerMove: (detail) => ref
                          .read(photoEditProvider.notifier)
                          .cropMoveLeftBottom(detail),
                      child: Icon(Icons.add, size: 40 * ratio),
                    ),
                  ),
                  Positioned(
                    left: cropOffset.dx +
                        cropSize.width -
                        (iconSize / 2 - basePadding) * ratio,
                    top: cropOffset.dy +
                        cropSize.height -
                        (iconSize / 2 - basePadding) * ratio,
                    child: Listener(
                      behavior: HitTestBehavior.translucent,
                      onPointerMove: (detail) => ref
                          .read(photoEditProvider.notifier)
                          .cropMoveRightBottom(detail),
                      child: Icon(Icons.add, size: 40 * ratio),
                    ),
                  ),
                ],

                // Reactions
                for (final reaction
                    in reactions.mapIndexed((index, e) => (index, e)))
                  Positioned(
                    left: reaction.$2.position.dx +
                        basePadding * ratio +
                        (clipMode
                            ? 0
                            : (defaultSize.width - cropSize.width) / 2 -
                                cropOffset.dx),
                    top: reaction.$2.position.dy +
                        basePadding * ratio +
                        (clipMode
                            ? 0
                            : (defaultSize.height - cropSize.height) / 2 -
                                cropOffset.dy),
                    width: reaction.$2.scale,
                    height: reaction.$2.scale,
                    child: GestureDetector(
                      onTap: () => ref
                          .read(photoEditProvider.notifier)
                          .selectReaction(reaction.$1),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            border: reaction.$1 == selectedReaction
                                ? Border.all(color: Colors.white)
                                : null),
                        child: SizedBox(
                          width: reaction.$2.scale,
                          height: reaction.$2.scale,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Transform.rotate(
                              angle: reaction.$2.angle,
                              child: CustomEmoji(
                                emojiData: reaction.$2.emoji,
                                isAttachTooltip: false,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
