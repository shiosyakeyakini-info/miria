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

@RoutePage()
class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      NotificationPageState();
}

class NotificationPageState extends ConsumerState<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("通知")),
        body: FutureBuilder<Iterable<INotificationsResponse>>(
          future: ref
              .read(misskeyProvider)
              .i
              .notifications(const INotificationsRequest()),
          builder: (context, snapshot) {
            final data = snapshot.data?.toList();
            if (data != null) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final notification = data[index];

                  print(notification.reaction);
                  return Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context).dividerColor))),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                  width: 32,
                                  child: Image.network(
                                      notification.user.avatarUrl.toString())),
                              if (notification.reaction != null) ...[
                                const Padding(
                                    padding: EdgeInsets.only(top: 10)),
                                CustomEmoji(
                                    emoji: ref
                                        .read(emojiRepositoryProvider)
                                        .emoji
                                        ?.firstWhere((element) =>
                                            ":${element.name}:" ==
                                            notification.reaction)),
                              ]
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              if (notification.type ==
                                  NotificationType.reaction) ...[
                                Column(
                                  children: [
                                    mfm_text.MfmText(
                                        mfmText:
                                            "${notification.user.name ?? notification.user.username} <small>からリアクション</small>"),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: misskey_note.MisskeyNote(
                                              note: notification.note),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ]
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}
