import "package:auto_route/auto_route.dart";
import "package:bubble/bubble.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/date_time_extension.dart";
import "package:miria/model/misskey_emoji_data.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/chat_page/chat_message_menu_sheet.dart";
import "package:miria/view/chat_page/chat_reaction_widget.dart";
import "package:miria/view/chat_page/room_chat.dart";
import "package:miria/view/chat_page/user_chat.dart";
import "package:miria/view/common/avatar_icon.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:miria/view/common/misskey_notes/misskey_file_view.dart";
import "package:miria/view/themes/app_theme.dart";
import "package:misskey_dart/misskey_dart.dart";

class ChatMessageItem extends ConsumerWidget {
  final ChatMessage message;
  final User? user;
  final bool isMyMessage;
  final String? roomId; // ルームチャットの場合のルームID
  final String? userId; // ユーザーチャットの場合のユーザーID

  const ChatMessageItem({
    required this.message,
    required this.user,
    required this.isMyMessage,
    this.roomId,
    this.userId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isMyMessage) {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0, bottom: 16.0),
        child: Align(
          alignment: Alignment.topRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onLongPress: () => _showMessageMenu(context, ref),
                child: Bubble(
                  nip: BubbleNip.rightBottom,
                  color: AppTheme.of(context).colorTheme.primary,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.text != null && message.text!.isNotEmpty)
                        MfmText(mfmText: message.text),
                      if (message.file != null) ...[
                        if (message.text != null && message.text!.isNotEmpty)
                          const SizedBox(height: 8),
                        MisskeyFileView(files: [message.file!], height: 200),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => _showMessageMenu(context, ref),
                    icon: Icon(
                      Icons.more_horiz,
                      size: 16,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    message.createdAt.differenceNow(context),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              if (message.reactions.isNotEmpty)
                _buildReactionsList(context, ref),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        if (user != null) AvatarIcon(user: user!),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onLongPress: () => _showMessageMenu(context, ref),
                child: Bubble(
                  color: AppTheme.of(context).colorTheme.background,
                  nip: BubbleNip.leftTop,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.text != null && message.text!.isNotEmpty)
                        MfmText(mfmText: message.text),
                      if (message.file != null) ...[
                        if (message.text != null && message.text!.isNotEmpty)
                          const SizedBox(height: 8),
                        MisskeyFileView(files: [message.file!], height: 200),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    message.createdAt.differenceNow(context),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () => _showMessageMenu(context, ref),
                    icon: Icon(
                      Icons.more_horiz,
                      size: 16,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              if (message.reactions.isNotEmpty ?? false)
                _buildReactionsList(context, ref),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReactionsList(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: message.reactions
            .map(
              (reaction) =>
                  ChatReactionWidget(message: message, reactionData: reaction),
            )
            .toList(),
      ),
    );
  }

  Future<void> _showMessageMenu(BuildContext context, WidgetRef ref) async {
    // 自分のメッセージの場合はpostAccountのユーザー情報を使用
    final displayUser = user ?? ref.read(accountContextProvider).postAccount.i;

    final action = await context.pushRoute<ChatMessageMenuAction>(
      ChatMessageMenuRoute(
        account: ref.read(accountContextProvider).postAccount,
        message: message,
        user: displayUser,
      ),
    );

    if (action == null) return;

    switch (action) {
      case ChatMessageMenuAction.reaction:
        final emoji = await context.pushRoute<MisskeyEmojiData>(
          ReactionPickerRoute(
            account: ref.read(accountContextProvider).postAccount,
            isAcceptSensitive: true,
          ),
        );
        if (emoji != null) {
          final reactionString = _getReactionString(emoji);

          await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
            await ref
                .read(misskeyPostContextProvider)
                .chat
                .messages
                .react(
                  ChatMessagesReactRequest(
                    messageId: message.id,
                    reaction: reactionString,
                  ),
                );
          });
        }

      case ChatMessageMenuAction.copy:
        if (message.text != null) {
          Clipboard.setData(ClipboardData(text: message.text!));
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("コピーしました")));
        }

      case ChatMessageMenuAction.delete:
        final isConfirm = await ref
            .read(dialogStateNotifierProvider.notifier)
            .showDialog(
              message: (context) => "このメッセージを削除してもええ？\n削除すると元に戻せへんで。",
              actions: (context) => ["削除する", "キャンセル"],
            );
        if (isConfirm == 1) return;

        await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
          await ref
              .read(misskeyPostContextProvider)
              .chat
              .messages
              .delete(ChatMessagesDeleteRequest(messageId: message.id));
          
          // 状態更新：削除されたメッセージをUIから削除
          if (roomId != null) {
            ref.read(roomChatProvider(roomId!).notifier).deleteMessage(message.id);
          } else if (userId != null) {
            ref.read(userChatProvider(userId!).notifier).deleteMessage(message.id);
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("メッセージを削除したで")),
          );
        });

      case ChatMessageMenuAction.detail:
        await context.pushRoute(
          ChatMessageDetailRoute(
            account: ref.read(accountContextProvider).postAccount,
            messageId: message.id,
          ),
        );

      case ChatMessageMenuAction.report:
        await context.pushRoute(
          AbuseRoute(
            account: ref.read(accountContextProvider).postAccount,
            targetUser: displayUser,
            defaultText: "チャットメッセージ: ${message.text}",
          ),
        );
    }
  }

  String _getReactionString(MisskeyEmojiData emoji) {
    switch (emoji) {
      case CustomEmojiData():
        return emoji.hostedName;
      case UnicodeEmojiData():
        return emoji.char;
      case NotEmojiData():
        return emoji.name;
      case MutedEmojiData():
        return _getReactionString(emoji.originalData);
    }
  }
}
