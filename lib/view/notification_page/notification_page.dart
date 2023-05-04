import 'package:auto_route/annotations.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/model/account.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/custom_emoji.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/mfm_text.dart'
    as mfm_text;
import 'package:flutter_misskey_app/view/common/misskey_notes/misskey_note.dart'
    as misskey_note;
import 'package:flutter_misskey_app/view/common/pushable_listview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

@RoutePage()
class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key, required this.account});
  final Account account;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      NotificationPageState();
}

class NotificationPageState extends ConsumerState<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    final misskey = ref.read(misskeyProvider(widget.account));
    return Scaffold(
      appBar: AppBar(title: const Text("通知")),
      body: AccountScope(
        account: widget.account,
        child: PushableListView<INotificationsResponse>(
          initializeFuture: () async {
            final result =
                await misskey.i.notifications(const INotificationsRequest(
              limit: 50,
            ));
            ref
                .read(notesProvider(widget.account))
                .registerAll(result.map((e) => e.note).whereNotNull());
            if (result.isNotEmpty) {
              ref
                  .read(mainStreamRepositoryProvider(widget.account))
                  .latestMarkAs(result.first.id);
            }
            return result.toList();
          },
          nextFuture: (lastElement) async {
            final result = await misskey.i.notifications(
                INotificationsRequest(limit: 50, untilId: lastElement.id));
            ref
                .read(notesProvider(widget.account))
                .registerAll(result.map((e) => e.note).whereNotNull());
            return result.toList();
          },
          itemBuilder: (context, notification) => NotificationItem(
            notification: notification,
          ),
        ),
      ),
    );
  }
}

class NotificationItem extends ConsumerWidget {
  final INotificationsResponse notification;

  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (notification.type != NotificationType.reaction &&
        notification.type != NotificationType.renote &&
        notification.type != NotificationType.reply) {
      print(notification);
    }

    return Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (notification.user != null)
                    SizedBox(
                        width: 32,
                        child: Image.network(
                            notification.user!.avatarUrl.toString())),
                  if (notification.reaction != null) ...[
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: CustomEmoji.fromEmojiName(
                          notification.reaction!,
                          ref.read(emojiRepositoryProvider(
                              AccountScope.of(context)))),
                    ),
                  ]
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (notification.type == NotificationType.reaction) ...[
                    mfm_text.MfmText(
                        mfmText:
                            "${notification.user?.name ?? notification.user?.username} <small>からリアクション</small>"),
                    misskey_note.MisskeyNote(note: notification.note!),
                  ],
                  if (notification.type == NotificationType.renote) ...[
                    mfm_text.MfmText(
                      mfmText:
                          "${notification.user?.name ?? notification.user?.username} <small>からRenote</small>",
                    ),
                    misskey_note.MisskeyNote(note: notification.note!)
                  ],
                  if (notification.type == NotificationType.reply) ...[
                    mfm_text.MfmText(
                      mfmText:
                          "${notification.user?.name ?? notification.user?.username} <small>からリプライ</small>",
                    ),
                    misskey_note.MisskeyNote(note: notification.note!)
                  ],
                  if (notification.type == NotificationType.pollEnded) ...[
                    const Text("投票が終わりました。"),
                    misskey_note.MisskeyNote(note: notification.note!)
                  ]
                ],
              ),
            )
          ],
        ));
  }
}
