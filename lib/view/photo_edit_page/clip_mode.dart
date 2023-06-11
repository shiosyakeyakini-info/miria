import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/photo_edit_page/edited_photo_image.dart';

class ClipMode extends ConsumerWidget {
  const ClipMode({super.key});

  final basePadding = 20;
  final iconSize = 40;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    final ratio = defaultSize.width / actualSize.width;

    return SizedBox(
      width: defaultSize.width + (basePadding * ratio) * 2,
      height: defaultSize.height + (basePadding * ratio) * 2,
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
                left: cropOffset.dx + basePadding * ratio + cropSize.width,
                top: basePadding * ratio,
                width: defaultSize.width - cropSize.width - cropOffset.dx,
                height: defaultSize.height,
                child: DecoratedBox(
                    decoration:
                        BoxDecoration(color: Colors.black87.withAlpha(150)))),
            //left over crop
            Positioned(
                left: basePadding * ratio + cropOffset.dx,
                top: basePadding * ratio,
                width: cropSize.width,
                height: cropOffset.dy,
                child: DecoratedBox(
                    decoration:
                        BoxDecoration(color: Colors.black87.withAlpha(150)))),

            //left under crop
            Positioned(
                left: basePadding * ratio + cropOffset.dx,
                top: basePadding * ratio + cropSize.height + cropOffset.dy,
                width: cropSize.width,
                height: defaultSize.height - cropSize.height - cropOffset.dy,
                child: DecoratedBox(
                    decoration:
                        BoxDecoration(color: Colors.black87.withAlpha(150)))),

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
          ]
        ],
      ),
    );
  }
}
