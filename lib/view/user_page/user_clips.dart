import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/clip_item.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:misskey_dart/misskey_dart.dart";

class UserClips extends ConsumerWidget {
  final String userId;

  const UserClips({required this.userId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PushableListView(
      initializeFuture: () async {
        final response = await ref
            .read(misskeyGetContextProvider)
            .users
            .clips(UsersClipsRequest(userId: userId));
        return response.toList();
      },
      nextFuture: (lastItem, _) async {
        final response = await ref
            .read(misskeyGetContextProvider)
            .users
            .clips(UsersClipsRequest(userId: userId, untilId: lastItem.id));
        return response.toList();
      },
      itemBuilder: (context, item) {
        return ClipItem(clip: item);
      },
    );
  }
}
