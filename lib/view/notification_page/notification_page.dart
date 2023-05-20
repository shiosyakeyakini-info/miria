import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/avatar_icon.dart';
import 'package:miria/view/common/misskey_notes/custom_emoji.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart' as mfm_text;
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart'
    as misskey_note;
import 'package:miria/view/common/pushable_listview.dart';
import 'package:miria/view/user_page/user_page.dart';
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
      if (kDebugMode) {
        print(notification);
      }
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (notification.user != null)
                    GestureDetector(
                      onTap: () => context.pushRoute(UserRoute(
                          userId: notification.user!.id,
                          account: AccountScope.of(context))),
                      child: AvatarIcon(
                        user: notification.user!,
                        height: (Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.fontSize ??
                                22) *
                            MediaQuery.of(context).textScaleFactor,
                      ),
                    ),
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
                    SimpleMfmText(
                      "${notification.user?.name ?? notification.user?.username} からリアクション",
                      emojis: notification.user?.emojis ?? {},
                    ),
                    MediaQuery(
                        data: MediaQueryData(
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor * 0.7),
                        child: misskey_note.MisskeyNote(
                          note: notification.note!,
                          isDisplayBorder: false,
                        )),
                  ],
                  if (notification.type == NotificationType.renote) ...[
                    SimpleMfmText(
                      "${notification.user?.name ?? notification.user?.username} からRenote",
                      emojis: notification.user?.emojis ?? {},
                    ),
                    MediaQuery(
                      data: MediaQueryData(
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor * 0.7),
                      child: misskey_note.MisskeyNote(
                        note: notification.note!,
                        isDisplayBorder: false,
                      ),
                    )
                  ],
                  if (notification.type == NotificationType.reply) ...[
                    mfm_text.MfmText(
                      "${notification.user?.name ?? notification.user?.username} <small>からリプライ</small>",
                    ),
                    MediaQuery(
                        data: MediaQueryData(
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor * 0.7),
                        child: misskey_note.MisskeyNote(
                          note: notification.note!,
                          isDisplayBorder: false,
                        ))
                  ],
                  if (notification.type == NotificationType.pollEnded) ...[
                    const Text("投票が終わりました。"),
                    MediaQuery(
                        data: MediaQueryData(
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor * 0.7),
                        child: misskey_note.MisskeyNote(
                          note: notification.note!,
                          isDisplayBorder: false,
                        )),
                  ],
                  if (notification.type == NotificationType.achievementEarned)
                    Text("実績を解除したで  [${notification.achievement}]"),
                  if (notification.type == NotificationType.follow)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(padding: EdgeInsets.only(top: 10)),
                        SimpleMfmText(
                          "${notification.user?.name ?? notification.user?.username} ",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text("からフォローされました")
                      ],
                    )
                ],
              ),
            )
          ],
        ));
  }
}
