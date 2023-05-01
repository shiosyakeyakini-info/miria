import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/view/common/custom_emoji.dart';
import 'package:flutter_misskey_app/view/common/mfm_text.dart' as mfm_text;
import 'package:flutter_misskey_app/view/common/misskey_note.dart'
    as misskey_note;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mfm/mfm.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:collection/collection.dart';

@RoutePage()
class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      NotificationPageState();
}

class NotificationPageState extends ConsumerState<NotificationPage> {
  var isLoading = false;

  List<INotificationsResponse> notifications = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLoading = true;
    Future(() async {
      notifications.addAll(await ref
          .read(misskeyProvider)
          .i
          .notifications(const INotificationsRequest(limit: 50)));
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("通知")),
        body: ListView.builder(
            itemCount: notifications.length + 1,
            itemBuilder: (context, index) {
              if (notifications.length == index) {
                return Center(
                  child: !isLoading
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                              Future(() async {
                                notifications.addAll(await ref
                                    .read(misskeyProvider)
                                    .i
                                    .notifications(INotificationsRequest(
                                      untilId: notifications.last.id,
                                      limit: 50,
                                    )));
                                setState(() {
                                  isLoading = false;
                                });
                              });
                            });
                          },
                          icon: const Icon(Icons.keyboard_arrow_down),
                        )
                      : const Padding(
                          padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator()),
                );
              }

              final notification = notifications[index];

              if (notification.type != NotificationType.reaction &&
                  notification.type != NotificationType.renote &&
                  notification.type != NotificationType.reply) {
                print(notification);
              }

              return Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context).dividerColor))),
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
                                    child: Image.network(notification
                                        .user!.avatarUrl
                                        .toString())),
                              if (notification.reaction != null) ...[
                                const Padding(
                                    padding: EdgeInsets.only(top: 10)),
                                SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: CustomEmoji.fromEmojiName(
                                      notification.reaction!,
                                      ref.read(emojiRepositoryProvider)),
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
                                if (notification.type ==
                                    NotificationType.reaction) ...[
                                  mfm_text.MfmText(
                                      mfmText:
                                          "${notification.user?.name ?? notification.user?.username} <small>からリアクション</small>"),
                                  misskey_note.MisskeyNote(
                                      note: notification.note!),
                                ],
                                if (notification.type ==
                                    NotificationType.renote) ...[
                                  mfm_text.MfmText(
                                    mfmText:
                                        "${notification.user?.name ?? notification.user?.username} <small>からRenote</small>",
                                  ),
                                  misskey_note.MisskeyNote(
                                      note: notification.note!)
                                ],
                                if (notification.type ==
                                    NotificationType.reply) ...[
                                  mfm_text.MfmText(
                                    mfmText:
                                        "${notification.user?.name ?? notification.user?.username} <small>からリプライ</small>",
                                  ),
                                  misskey_note.MisskeyNote(
                                      note: notification.note!)
                                ],
                                if (notification.type ==
                                    NotificationType.pollEnded) ...[
                                  Text("投票が終わりました。"),
                                  misskey_note.MisskeyNote(
                                      note: notification.note!)
                                ]
                              ]),
                        )
                      ]));
            }));
  }
}
