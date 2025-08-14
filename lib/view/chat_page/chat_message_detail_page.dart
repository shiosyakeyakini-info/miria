import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/date_time_extension.dart";
import "package:miria/hooks/use_async.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/avatar_icon.dart";
import "package:miria/view/common/error_detail.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:miria/view/common/misskey_notes/misskey_file_view.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class ChatMessageDetailPage extends HookConsumerWidget
    implements AutoRouteWrapper {
  final Account account;
  final String messageId;

  const ChatMessageDetailPage({
    required this.account,
    required this.messageId,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadMessage = useAsync(() async {
      return await ref
          .read(misskeyGetContextProvider)
          .chat
          .messages
          .show(ChatMessagesShowRequest(messageId: messageId));
    });

    useEffect(() {
      loadMessage.executeOrNull?.call();
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).detail)),
      body: switch (loadMessage.value) {
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
        AsyncError(:final error, :final stackTrace) => ErrorDetail(
          error: error,
          stackTrace: stackTrace,
        ),
        AsyncData(:final value) => _buildMessageDetail(context, ref, value),
        null => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _buildMessageDetail(
    BuildContext context,
    WidgetRef ref,
    ChatMessage message,
  ) {
    final accountContext = ref.read(accountContextProvider);
    final isMyMessage = message.fromUserId == accountContext.postAccount.i.id;

    // メッセージの送信者情報を取得
    final messageUser =
        message.toUser ??
        message.fromUser ??
        (isMyMessage ? accountContext.postAccount.i : null);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ユーザー情報
          if (messageUser != null)
            Row(
              children: [
                AvatarIcon(user: messageUser),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        messageUser.name ?? messageUser.username,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "@${messageUser.username}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),

          // メッセージ内容
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.text != null && message.text!.isNotEmpty) ...[
                    Text(
                      S.of(context).note,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    MfmText(mfmText: message.text),
                    const SizedBox(height: 16),
                  ],
                  if (message.file != null) ...[
                    Text(
                      S.of(context).chatAttachedFiles,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    MisskeyFileView(files: [message.file!]),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // メッセージ詳細情報
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).chatDetailInfo,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow("ID", message.id),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    S.of(context).chatSentAt,
                    "${message.createdAt.toLocal().toString().substring(0, 19)} (${message.createdAt.differenceNow(context)})",
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    S.of(context).chatSenderId,
                    message.fromUserId,
                  ),
                  if (message.toUser != null) ...[
                    const SizedBox(height: 8),
                    _buildDetailRow(S.of(context).user, message.toUser!.id),
                  ],
                  if (message.reactions.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      S.of(context).chatReactionCount,
                      message.reactions.length.toString(),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // リアクション一覧
          if (message.reactions.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).chatReactionList,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    ...message.reactions.map(
                      (reaction) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Text(
                              reaction.reaction,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 8),
                            if (reaction.user != null) ...[
                              AvatarIcon(user: reaction.user!),
                              const SizedBox(width: 8),
                              Text(reaction.user!.username),
                            ] else
                              Text(S.of(context).chatUnknownUser),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(child: SelectableText(value)),
      ],
    );
  }
}
