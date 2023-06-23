import 'package:flutter/material.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/clip_item.dart';
import 'package:miria/view/common/pushable_listview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class UserClips extends ConsumerWidget {
  final String userId;

  const UserClips({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PushableListView(
      initializeFuture: () async {
        final response = await ref
            .read(misskeyProvider(AccountScope.of(context)))
            .users
            .clips(UsersClipsRequest(userId: userId));
        return response.toList();
      },
      nextFuture: (lastItem, _) async {
        final response = await ref
            .read(misskeyProvider(AccountScope.of(context)))
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
