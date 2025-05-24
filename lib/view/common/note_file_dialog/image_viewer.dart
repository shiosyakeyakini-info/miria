import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/state_notifier/note_file_dialog/image_viewer_info_notifier.dart";
import "package:miria/view/common/note_file_dialog/scale_notifier_interactive_viewer.dart";
import "package:misskey_dart/misskey_dart.dart";

class ImageViewer extends HookConsumerWidget {
  final DriveFile file;
  final double maxScale;
  const ImageViewer({required this.file, super.key, this.maxScale = 8.0});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(imageViewerInfoNotifierProvider);

    final transformationController = useTransformationController();

    final resetScale = useCallback(() {
      transformationController.value = Matrix4.identity();
      ref.read(imageViewerInfoNotifierProvider.notifier).reset();
    }, [transformationController, 1.0]);
    return Stack(
      children: [
        Positioned.fill(
          child: Listener(
            onPointerDown: (event) {
              ref.read(imageViewerInfoNotifierProvider.notifier).addPointer();
            },
            onPointerUp: (event) {
              if (provider.scale == 1.0 && provider.lastScale != 1.0) {
                resetScale();
              }
              ref
                  .read(imageViewerInfoNotifierProvider.notifier)
                  .removePointer();
            },
            onPointerMove: (event) {
              final prov = ref.read(imageViewerInfoNotifierProvider);
              if (prov.isDoubleTap && prov.pointersCount == 1) {
                final position = prov.lastTapLocalPosition;
                final delta = event.localPosition - position!;

                final s = max(
                  min(prov.lastScale + (delta.dy / 75.0), maxScale),
                  1.0,
                );
                ref
                    .read(imageViewerInfoNotifierProvider.notifier)
                    .updateScale(s);
                final v = transformationController.toScene(position);

                transformationController.value =
                    Matrix4.identity()..scale(provider.scale);

                final v2 = transformationController.toScene(position) - v;

                transformationController.value =
                    transformationController.value.clone()
                      ..translate(v2.dx, v2.dy);
              }
            },
            child: GestureDetector(
              onDoubleTapDown: (details) {
                ref
                    .read(imageViewerInfoNotifierProvider.notifier)
                    .update(
                      ref
                          .read(imageViewerInfoNotifierProvider)
                          .copyWith(
                            lastScale: provider.scale,
                            isDoubleTap: true,
                            lastTapLocalPosition: details.localPosition,
                          ),
                    );
              },
              onDoubleTap: () {
                if (provider.scale != 1.0) {
                  resetScale();
                } else {
                  final position =
                      ref
                          .read(imageViewerInfoNotifierProvider)
                          .lastTapLocalPosition;
                  if (position == null) return;
                  transformationController.value =
                      Matrix4.identity()
                        ..translate(-position.dx * 2, -position.dy * 2)
                        ..scale(3.0);
                  ref
                      .read(imageViewerInfoNotifierProvider.notifier)
                      .update(
                        ref
                            .read(imageViewerInfoNotifierProvider)
                            .copyWith(
                              scale: 3.0,
                              isDoubleTap: false,
                              lastTapLocalPosition: null,
                            ),
                      );
                }
              },
              child: ScaleNotifierInteractiveViewer(
                imageUrl: file.url,
                controller: transformationController,
                onScaleChanged: (scaleUpdated) {
                  ref
                      .read(imageViewerInfoNotifierProvider.notifier)
                      .updateScale(scaleUpdated);
                },
                maxScale: maxScale,
                canChangeScale: !provider.isDoubleTap,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
