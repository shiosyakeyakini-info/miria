import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/state_notifier/photo_edit_page/photo_edit_state_notifier.dart";

class PhotoEditBottomBar extends ConsumerWidget {
  const PhotoEditBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoEdit = ref.read(photoEditStateNotifierProvider.notifier);

    final isClipMode = ref.watch(
      photoEditStateNotifierProvider.select((value) => value.clipMode),
    );
    final isColorFilterMode = ref.watch(
      photoEditStateNotifierProvider.select((value) => value.colorFilterMode),
    );

    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: isClipMode ? Theme.of(context).primaryColorDark : null,
            ),
            child: IconButton(
              onPressed: () async => photoEdit.crop(),
              icon: const Icon(Icons.crop, color: Colors.white),
            ),
          ),
          IconButton(
            onPressed: () async => photoEdit.rotate(),
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color:
                  isColorFilterMode ? Theme.of(context).primaryColorDark : null,
            ),
            child: IconButton(
              onPressed: () async => photoEdit.colorFilter(),
              icon: const Icon(Icons.palette_outlined, color: Colors.white),
            ),
          ),
          IconButton(
            onPressed: () async => photoEdit.addReaction(),
            icon: const Icon(Icons.add_reaction_outlined, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
