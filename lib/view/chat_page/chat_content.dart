import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/date_time_extension.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/avatar_icon.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:misskey_dart/misskey_dart.dart";

class ChatContent extends ConsumerWidget {
  final ChatMessage message;
  const ChatContent({required this.message, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = message.toRoom;

    final targetUser =
        (message.toUser?.id == ref.read(accountContextProvider).getAccount.i.id
            ? message.fromUser
            : message.toUser) ??
        ref.read(accountContextProvider).getAccount.i;

    return Row(
      children: [
        AvatarIcon(user: targetUser),
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
                        targetUser.name ?? targetUser.username,
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
