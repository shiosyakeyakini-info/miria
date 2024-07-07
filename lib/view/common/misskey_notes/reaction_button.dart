import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/const.dart";
import "package:miria/model/misskey_emoji_data.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/misskey_notes/custom_emoji.dart";
import "package:miria/view/common/misskey_notes/reaction_user_dialog.dart";
import "package:miria/view/dialogs/simple_confirm_dialog.dart";
import "package:miria/view/themes/app_theme.dart";
import "package:misskey_dart/misskey_dart.dart";

class ReactionButton extends ConsumerStatefulWidget {
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
  ConsumerState<ConsumerStatefulWidget> createState() => ReactionButtonState();
}

class ReactionButtonState extends ConsumerState<ReactionButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final emojiData = widget.emojiData;
    final isMyReaction = (emojiData is CustomEmojiData &&
            widget.myReaction == emojiData.hostedName) ||
        (emojiData is UnicodeEmojiData && widget.myReaction == emojiData.char);

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

    return ElevatedButton(
      onPressed: () async {
        final accountContext = ref.read(accountContextProvider);
        if (!accountContext.isSame) return;
        // リアクション取り消し
        final account = accountContext.postAccount;
        if (isMyReaction) {
          if (await SimpleConfirmDialog.show(
                context: context,
                message: S.of(context).confirmDeleteReaction,
                primary: S.of(context).cancelReaction,
                secondary: S.of(context).cancel,
              ) !=
              true) {
            return;
          }

          await ref
              .read(misskeyPostContextProvider)
              .notes
              .reactions
              .delete(NotesReactionsDeleteRequest(noteId: widget.noteId));
          if (account.host == "misskey.io") {
            await Future.delayed(
              const Duration(milliseconds: misskeyIOReactionDelay),
            );
          }

          await ref.read(notesProvider(account)).refresh(widget.noteId);

          return;
        }

        // すでに別のリアクションを行っている
        if (widget.myReaction != null) return;

        final String reactionString;
        final emojiData = widget.emojiData;
        switch (emojiData) {
          case UnicodeEmojiData():
            reactionString = emojiData.char;
          case CustomEmojiData():
            if (!emojiData.isCurrentServer) return;
            reactionString = ":${emojiData.baseName}:";
          case NotEmojiData():
            return;
        }

        await ref.read(misskeyPostContextProvider).notes.reactions.create(
              NotesReactionsCreateRequest(
                noteId: widget.noteId,
                reaction: reactionString,
              ),
            );

        // misskey.ioはただちにリアクションを反映してくれない
        if (account.host == "misskey.io") {
          await Future.delayed(
            const Duration(milliseconds: misskeyIOReactionDelay),
          );
        }

        await ref.read(notesProvider(account)).refresh(widget.noteId);
      },
      onLongPress: () async {
        await showDialog(
          context: context,
          builder: (context2) {
            return ReactionUserDialog(
              account: ref.read(accountContextProvider).getAccount,
              emojiData: widget.emojiData,
              noteId: widget.noteId,
            );
          },
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
              emojiData: widget.emojiData,
              isAttachTooltip: false,
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 5)),
          Text(
            widget.reactionCount.toString(),
            style: TextStyle(color: foreground),
          ),
        ],
      ),
    );
  }
}
