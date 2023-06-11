import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';

class EditedPhotoImage extends ConsumerWidget {
  const EditedPhotoImage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image =
        ref.watch(photoEditProvider.select((value) => value.editedImage));

    final defaultSize =
        ref.watch(photoEditProvider.select((value) => value.defaultSize));
    final actualSize =
        ref.watch(photoEditProvider.select((value) => value.actualSize));

    if (image != null) {
      return Positioned.fill(
          child: Padding(
              padding:
                  EdgeInsets.all(10 * (defaultSize.width / actualSize.width)),
              child: Image.memory(image)));
    }
    return const Positioned(
      child: SizedBox.shrink(),
    );
  }
}
