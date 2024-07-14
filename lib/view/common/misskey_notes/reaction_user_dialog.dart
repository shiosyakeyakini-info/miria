import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/misskey_emoji_data.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/misskey_notes/custom_emoji.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:miria/view/user_page/user_list_item.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class ReactionUserDialog extends ConsumerWidget implements AutoRouteWrapper {
  final AccountContext accountContext;
  final MisskeyEmojiData emojiData;
  final String noteId;

  const ReactionUserDialog({
    required this.accountContext,
    required this.emojiData,
    required this.noteId,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String type;
    switch (emojiData) {
      case CustomEmojiData(:final hostedName):
        type = hostedName;
      case UnicodeEmojiData(:final char):
        type = char;
      default:
        type = "";
    }

    return AlertDialog(
      title: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomEmoji(
            emojiData: emojiData,
          ),
          Text(
            emojiData.baseName,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.width * 0.8,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: PushableListView(
            initializeFuture: () async {
              final response = await ref
                  .read(misskeyGetContextProvider)
                  .notes
                  .reactions
                  .reactions(
                    NotesReactionsRequest(noteId: noteId, type: type),
                  );
              return response.toList();
            },
            nextFuture: (item, index) async {
              // 後方互換性のためにoffsetとuntilIdの両方をリクエストに含める
              final response = await ref
                  .read(misskeyGetContextProvider)
                  .notes
                  .reactions
                  .reactions(
                    NotesReactionsRequest(
                      noteId: noteId,
                      type: type,
                      offset: index,
                      untilId: item.id,
                    ),
                  );
              return response.toList();
            },
            itemBuilder: (context, item) => UserListItem(user: item.user),
            showAd: false,
          ),
        ),
      ),
    );
  }
}
