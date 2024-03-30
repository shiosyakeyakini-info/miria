import 'package:flutter/material.dart';
import 'package:miria/model/misskey_emoji_data.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/custom_emoji.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';
import 'package:miria/view/common/pushable_listview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/themes/app_theme.dart';
import 'package:misskey_dart/misskey_dart.dart';

class UserReactions extends ConsumerWidget {
  final String userId;

  const UserReactions({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = AccountScope.of(context);
    return PushableListView(
      initializeFuture: () async {
        final response = await ref
            .read(misskeyProvider(account))
            .users
            .reactions(UsersReactionsRequest(userId: userId));
        ref
            .read(notesProvider(account))
            .registerAll(response.map((e) => e.note));
        return response.toList();
      },
      nextFuture: (lastItem, _) async {
        final response = await ref
            .read(misskeyProvider(account))
            .users
            .reactions(
                UsersReactionsRequest(userId: userId, untilId: lastItem.id));
        ref
            .read(notesProvider(account))
            .registerAll(response.map((e) => e.note));

        return response.toList();
      },
      itemBuilder: (context, item) {
        return UserReaction(response: item);
      },
    );
  }
}

class UserReaction extends ConsumerWidget {
  final UsersReactionsResponse response;

  const UserReaction({super.key, required this.response});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                  color: AppTheme.of(context).colorTheme.accentedBackground,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 3, bottom: 3),
                  child: CustomEmoji(
                    emojiData: MisskeyEmojiData.fromEmojiName(
                        emojiName: response.type,
                        emojiInfo: response.note.reactionEmojis,
                        repository: ref.read(
                            emojiRepositoryProvider(AccountScope.of(context)))),
                    fontSizeRatio: 2,
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                child: MisskeyNote(note: response.note)),
            const Padding(padding: EdgeInsets.all(5)),
          ],
        ),
      ),
    );
  }
}
