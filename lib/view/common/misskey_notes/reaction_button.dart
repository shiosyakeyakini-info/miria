import "dart:math";

import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/const.dart";
import "package:miria/hooks/use_async.dart";
import "package:miria/model/misskey_emoji_data.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/common/misskey_notes/custom_emoji.dart";
import "package:miria/view/dialogs/simple_confirm_dialog.dart";
import "package:miria/view/themes/app_theme.dart";
import "package:misskey_dart/misskey_dart.dart";

class ReactionButton extends HookConsumerWidget {
  final MisskeyEmojiData emojiData;
  final int reactionCount;
  final String? myReaction;
  final String noteId;

  const ReactionButton({
    required this.emojiData,
    required this.reactionCount,
    required this.myReaction,
    required this.noteId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emojiData = this.emojiData;
    final isMyReaction =
        (emojiData is CustomEmojiData && myReaction == emojiData.hostedName) ||
            (emojiData is UnicodeEmojiData && myReaction == emojiData.char);

    final backgroundColor = isMyReaction
        ? AppTheme.of(context).reactionButtonMeReactedColor
        : (emojiData is CustomEmojiData && !emojiData.isCurrentServer)
            ? Colors.transparent
            : AppTheme.of(context).reactionButtonBackgroundColor;

    final foreground = isMyReaction
        ? Theme.of(context).primaryColor
        : Theme.of(context).textTheme.bodyMedium?.color;

    final borderColor =
        isMyReaction ? Theme.of(context).primaryColor : Colors.transparent;

    final reaction = useAsync(() async {
      final accountContext = ref.read(accountContextProvider);
      if (!accountContext.isSame) return;
      // リアクション取り消し
      final account = accountContext.postAccount;
      if (isMyReaction) {
        final dialogValue =
            await ref.read(dialogStateNotifierProvider.notifier).showDialog(
                  message: (context) => S.of(context).confirmDeleteReaction,
                  actions: (context) => [
                    S.of(context).cancelReaction,
                    S.of(context).cancel,
                  ],
                );
        if (dialogValue != 0) return;

        await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
          await ref
              .read(misskeyPostContextProvider)
              .notes
              .reactions
              .delete(NotesReactionsDeleteRequest(noteId: noteId));
          if (account.host == "misskey.io") {
            await Future.delayed(
              const Duration(milliseconds: misskeyIOReactionDelay),
            );
          }

          await ref.read(notesWithProvider).refresh(noteId);
        });

        return;
      }

      // すでに別のリアクションを行っている
      if (myReaction != null) return;

      final String reactionString;
      switch (emojiData) {
        case UnicodeEmojiData():
          reactionString = emojiData.char;
        case CustomEmojiData():
          if (!emojiData.isCurrentServer) return;
          reactionString = ":${emojiData.baseName}:";
        case NotEmojiData():
          return;
      }
      await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
        await ref.read(misskeyPostContextProvider).notes.reactions.create(
              NotesReactionsCreateRequest(
                noteId: noteId,
                reaction: reactionString,
              ),
            );

        // misskey.ioはただちにリアクションを反映してくれない
        if (account.host == "misskey.io") {
          await Future.delayed(
            const Duration(milliseconds: misskeyIOReactionDelay),
          );
        }

        await ref.read(notesWithProvider).refresh(noteId);
      });
    });

    return ElevatedButton(
      onPressed: reaction.executeOrNull,
      onLongPress: () async {
        await context.pushRoute(
          ReactionUserRoute(
            accountContext: ref.read(accountContextProvider),
            emojiData: emojiData,
            noteId: noteId,
          ),
        );
      },
      style: AppTheme.of(context).reactionButtonStyle.copyWith(
            backgroundColor: WidgetStatePropertyAll(backgroundColor),
            side: WidgetStatePropertyAll(
              BorderSide(color: borderColor),
            ),
          ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: min(MediaQuery.of(context).size.width, 800) * 0.75,
              minHeight: MediaQuery.textScalerOf(context).scale(24),
              maxHeight: MediaQuery.textScalerOf(context).scale(24),
            ),
            child: CustomEmoji(
              emojiData: emojiData,
              isAttachTooltip: false,
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 5)),
          Text(
            reactionCount.toString(),
            style: TextStyle(color: foreground),
          ),
        ],
      ),
    );
  }
}
