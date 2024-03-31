import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:miria/providers.dart";

class ColorFilterImagePreview extends ConsumerWidget {
  const ColorFilterImagePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewImages = ref
        .watch(
            photoEditProvider.select((value) => value.colorFilterPreviewImages))
        .toList();
    final previewMode =
        ref.watch(photoEditProvider.select((value) => value.colorFilterMode));
    final adaptive =
        ref.watch(photoEditProvider.select((value) => value.adaptivePresets));
    if (!previewMode) {
      return const SizedBox.shrink();
    }
    if (previewImages.isEmpty) {
      return SizedBox.fromSize(size: const Size(double.infinity, 200));
    }

    return SizedBox(
      width: double.infinity,
      height: 100,
      child: ListView.builder(
        key: const PageStorageKey<String>("colorFilterImagePreview"),
        scrollDirection: Axis.horizontal,
        itemCount: previewImages.length,
        itemBuilder: (context, index) {
          final image = previewImages[index].image;
          if (image == null) return const SizedBox.shrink();
          return GestureDetector(
            onTap: () => ref
                .read(photoEditProvider.notifier)
                .selectColorFilter(previewImages[index].name),
            child: DecoratedBox(
              decoration: adaptive.any((e) => e == previewImages[index].name)
                  ? BoxDecoration(color: Theme.of(context).primaryColor)
                  : const BoxDecoration(),
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: SizedBox(
                  height: 100,
                  child: Column(
                    children: [
                      Expanded(child: Image.memory(image)),
                      Text(previewImages[index].name)
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
