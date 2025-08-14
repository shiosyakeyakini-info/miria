import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/date_time_extension.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/avatar_icon.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:misskey_dart/misskey_dart.dart";

class ChatContent extends ConsumerWidget {
  final ChatMessage message;
  final Function() onTap;
  const ChatContent({required this.message, required this.onTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = message.toRoom;

    final targetUser =
        (message.toUser?.id == ref.read(accountContextProvider).getAccount.i.id
            ? message.fromUser
            : message.toUser) ??
        ref.read(accountContextProvider).getAccount.i;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
      leading: AvatarIcon(user: targetUser),
      onTap: onTap,
      title: Row(
        children: [
          if (room != null)
            Expanded(
              child: Text(
                room.name,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            )
          else
            Expanded(
              child: SimpleMfmText(
                targetUser.name ?? targetUser.username,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          Text(
            message.createdAt.differenceNow(context),
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
      subtitle: SimpleMfmText(
        message.text ?? "",
        style: Theme.of(context).textTheme.bodySmall,
        maxLines: 5,
      ),
    );
  }
}
