import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/date_time_extension.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/avatar_icon.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:misskey_dart/misskey_dart.dart";

class ChatContent extends ConsumerWidget {
  final ChatMessage message;
  const ChatContent({required this.message, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = message.toRoom;
    return Row(
      children: [
        AvatarIcon(
          user:
              message.toUser ??
              message.fromUser ??
              ref.read(accountContextProvider).getAccount.i,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (room != null)
                    Expanded(child: Text(room.name))
                  else
                    Expanded(
                      child: SimpleMfmText(
                        message.toUser?.name ??
                            message.toUser?.username ??
                            message.fromUser?.name ??
                            message.fromUser?.username ??
                            ref
                                .read(accountContextProvider)
                                .getAccount
                                .i
                                .name ??
                            ref
                                .read(accountContextProvider)
                                .getAccount
                                .i
                                .username,
                      ),
                    ),
                  Text(message.createdAt.differenceNow(context)),
                ],
              ),
              SimpleMfmText(message.text ?? ""),
            ],
          ),
        ),
      ],
    );
  }
}
