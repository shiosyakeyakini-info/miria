import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";

class PhotoEditBottomBar extends ConsumerWidget {
  const PhotoEditBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoEdit = ref.read(photoEditProvider.notifier);

    final isClipMode =
        ref.watch(photoEditProvider.select((value) => value.clipMode));
    final isColorFilterMode =
        ref.watch(photoEditProvider.select((value) => value.colorFilterMode));

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
            onPressed: () async =>
                photoEdit.addReaction(AccountScope.of(context), context),
            icon: const Icon(Icons.add_reaction_outlined, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
