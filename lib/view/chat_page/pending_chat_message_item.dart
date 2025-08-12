import "package:flutter/material.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "pending_chat_message_item.freezed.dart";

@freezed
sealed class PendingChatMessage with _$PendingChatMessage {
  const factory PendingChatMessage({
    required String tempId,
    required String text,
    String? fileId,
    required DateTime createdAt,
  }) = _PendingChatMessage;
}

class PendingChatMessageItem extends StatelessWidget {
  final PendingChatMessage pendingMessage;
  final bool isMyMessage;

  const PendingChatMessageItem({
    required this.pendingMessage,
    required this.isMyMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment:
            isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            decoration: BoxDecoration(
              color: isMyMessage
                  ? Theme.of(context).primaryColor.withOpacity(0.3)
                  : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).dividerColor.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (pendingMessage.text.isNotEmpty)
                    Opacity(
                      opacity: 0.6,
                      child: Text(
                        pendingMessage.text,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.6),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "送信中...",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.6),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}