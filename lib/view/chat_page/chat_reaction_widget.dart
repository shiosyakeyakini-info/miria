import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/misskey_emoji_data.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/avatar_icon.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/common/misskey_notes/custom_emoji.dart";
import "package:misskey_dart/misskey_dart.dart";

class ChatReactionWidget extends ConsumerWidget {
  final ChatMessage message;
  final ChatMessageReaction reactionData;

  const ChatReactionWidget({
    required this.message,
    required this.reactionData,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.read(accountContextProvider).getAccount;

    // userがnullの場合は自分自身のリアクションとして扱う
    final isMyReaction =
        reactionData.user?.id == account.i.id || reactionData.user == null;

    // 表示するユーザー（nullの場合は自分自身）
    final displayUser = reactionData.user ?? account.i;

    // 絵文字データを作成
    final emojiData = MisskeyEmojiData.fromEmojiName(
      emojiName: reactionData.reaction,
      repository: ref.read(emojiRepositoryProvider(account)),
      host: account.host,
      accountSettingsRepository: ref.read(accountSettingsRepositoryProvider),
      account: account,
    );

    return GestureDetector(
      onTap: () async {
        await ref.read(dialogStateProvider.notifier).guard(() async {
          if (isMyReaction) {
            // 自分のリアクションの場合は削除確認ダイアログを表示
            final dialogValue = await ref
                .read(dialogStateProvider.notifier)
                .showDialog(
                  message: (context) => S.of(context).confirmDeleteReaction,
                  actions: (context) => [
                    S.of(context).cancelReaction,
                    S.of(context).cancel,
                  ],
                );

            if (dialogValue != 0) {
              return;
            }

            await ref
                .read(misskeyPostContextProvider)
                .chat
                .messages
                .unreact(
                  ChatMessagesUnreactRequest(
                    messageId: message.id,
                    reaction: reactionData.reaction,
                  ),
                );
          } else {
            await ref
                .read(misskeyPostContextProvider)
                .chat
                .messages
                .react(
                  ChatMessagesReactRequest(
                    messageId: message.id,
                    reaction: reactionData.reaction,
                  ),
                );
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: isMyReaction
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: isMyReaction
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomEmoji(emojiData: emojiData, size: 14, isAttachTooltip: false),
            const SizedBox(width: 4),
            AvatarIcon(user: displayUser, height: 16),
          ],
        ),
      ),
    );
  }
}
