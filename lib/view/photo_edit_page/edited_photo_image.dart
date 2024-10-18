import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/state_notifier/photo_edit_page/photo_edit_state_notifier.dart";

class EditedPhotoImage extends ConsumerWidget {
  const EditedPhotoImage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = ref.watch(
      photoEditStateNotifierProvider.select((value) => value.editedImage),
    );

    final defaultSize = ref.watch(
      photoEditStateNotifierProvider.select((value) => value.defaultSize),
    );
    final actualSize = ref.watch(
      photoEditStateNotifierProvider.select((value) => value.actualSize),
    );

    if (image != null) {
      return Positioned.fill(
        child: Padding(
          padding: EdgeInsets.all(10 * (defaultSize.width / actualSize.width)),
          child: Image.memory(image),
        ),
      );
    }
    return const Positioned(
      child: SizedBox.shrink(),
    );
  }
}
