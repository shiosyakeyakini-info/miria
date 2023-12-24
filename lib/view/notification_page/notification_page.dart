import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:miria/extensions/date_time_extension.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/misskey_emoji_data.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/notification_page/notification_page_data.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/common/misskey_notes/custom_emoji.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart'
    as misskey_note;
import 'package:miria/view/common/pushable_listview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/user_page/user_list_item.dart';
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
    return DefaultTabController(
      length: 3,
      child: AccountScope(
        account: widget.account,
        child: Scaffold(
          appBar: AppBar(
              title: const Text("通知"),
              bottom: TabBar(tabs: [
                Tab(text: "みんな"),
                Tab(text: "自分宛て"),
                Tab(text: "ダイレクト")
              ])),
          body: Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: TabBarView(
              children: [
                PushableListView<NotificationData>(
                  initializeFuture: () async {
                    final result = await misskey.i
                        .notifications(const INotificationsRequest(
                      limit: 50,
                      markAsRead: true,
                    ));
                    ref
                        .read(notesProvider(widget.account))
                        .registerAll(result.map((e) => e.note).whereNotNull());
                    ref
                        .read(accountRepositoryProvider.notifier)
                        .readAllNotification(widget.account);
                    return result.toNotificationData();
                  },
                  nextFuture: (lastElement, _) async {
                    final result = await misskey.i.notifications(
                        INotificationsRequest(
                            limit: 50, untilId: lastElement.id));
                    ref
                        .read(notesProvider(widget.account))
                        .registerAll(result.map((e) => e.note).whereNotNull());
                    return result.toNotificationData();
                  },
                  itemBuilder: (context, notification) => Align(
                    alignment: Alignment.center,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: NotificationItem(
                        notification: notification,
                        account: widget.account,
                      ),
                    ),
                  ),
                ),
                PushableListView<Note>(
                  initializeFuture: () async {
                    final notes = await ref
                        .read(misskeyProvider(widget.account))
                        .notes
                        .mentions(const NotesMentionsRequest());
                    ref.read(notesProvider(widget.account)).registerAll(notes);
                    return notes.toList();
                  },
                  nextFuture: (item, _) async {
                    final notes = await ref
                        .read(misskeyProvider(widget.account))
                        .notes
                        .mentions(NotesMentionsRequest(untilId: item.id));
                    ref.read(notesProvider(widget.account)).registerAll(notes);
                    return notes.toList();
                  },
                  itemBuilder: (context, note) {
                    return misskey_note.MisskeyNote(note: note);
                  },
                ),
                PushableListView<Note>(
                  initializeFuture: () async {
                    final notes = await ref
                        .read(misskeyProvider(widget.account))
                        .notes
                        .mentions(const NotesMentionsRequest(
                            visibility: NoteVisibility.specified));
                    ref.read(notesProvider(widget.account)).registerAll(notes);
                    return notes.toList();
                  },
                  nextFuture: (item, _) async {
                    final notes = await ref
                        .read(misskeyProvider(widget.account))
                        .notes
                        .mentions(NotesMentionsRequest(
                            untilId: item.id,
                            visibility: NoteVisibility.specified));
                    ref.read(notesProvider(widget.account)).registerAll(notes);
                    return notes.toList();
                  },
                  itemBuilder: (context, note) {
                    return misskey_note.MisskeyNote(note: note);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final showActionsProvider =
    StateProvider.autoDispose.family<bool, NotificationData>((ref, _) => true);

final followRequestsProvider = FutureProvider.autoDispose
    .family<List<FollowRequest>, Account>((ref, account) async {
  final response = await ref
      .watch(misskeyProvider(account))
      .following
      .requests
      .list(const FollowingRequestsListRequest());
  return response.toList();
});

class NotificationItem extends ConsumerWidget {
  final NotificationData notification;
  final Account account;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.account,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notification = this.notification;
    final showActions = ref.watch(showActionsProvider(notification));
    final followRequests = ref.watch(followRequestsProvider(account));

    switch (notification) {
      case RenoteReactionNotificationData():
        final hasRenote = notification.renoteUsers.isNotEmpty;
        final hasReaction = notification.reactionUsers.isNotEmpty;
        return Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 30, right: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Row(
                  children: [
                    if (hasReaction && hasRenote)
                      Expanded(
                        child: SimpleMfmText(
                            "${notification.reactionUsers.first.$2?.name ?? notification.reactionUsers.first.$2?.username}さんたちがリアクションしはって、${notification.renoteUsers.first?.name ?? notification.renoteUsers.first?.username}さんたちがリノートしはったで",
                            emojis: Map.of(
                                notification.reactionUsers.first.$2?.emojis ??
                                    {})
                              ..addAll(notification.renoteUsers.first?.emojis ??
                                  {})),
                      ),
                    if (hasReaction && !hasRenote)
                      Expanded(
                        child: SimpleMfmText(
                          "${notification.reactionUsers.first.$2?.name ?? notification.reactionUsers.first.$2?.username}さんたちがリアクションしはったで",
                          emojis:
                              notification.reactionUsers.first.$2?.emojis ?? {},
                        ),
                      ),
                    if (hasRenote && !hasReaction)
                      Expanded(
                        child: SimpleMfmText(
                            "${notification.renoteUsers.first?.name ?? notification.renoteUsers.first?.username}さんたちがリノートしはったで",
                            emojis:
                                notification.renoteUsers.first?.emojis ?? {}),
                      ),
                    Text(notification.createdAt.differenceNow)
                  ],
                ),
              ),
              if (notification.note != null)
                misskey_note.MisskeyNote(
                  note: notification.note!,
                  recursive: 2,
                  isDisplayBorder: false,
                ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Column(
                  children: [
                    if (hasRenote)
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor)),
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("リノートしてくれはった人"),
                            Column(
                              children: [
                                for (final user
                                    in notification.renoteUsers.whereNotNull())
                                  UserListItem(user: user)
                              ],
                            ),
                          ],
                        ),
                      ),
                    if (hasReaction && hasRenote)
                      const Padding(padding: EdgeInsets.only(bottom: 10)),
                    if (hasReaction)
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor)),
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("リアクションしてくれはった人"),
                            for (final reaction in notification.reactionUsers
                                .mapIndexed(
                                    (index, element) => (index, element))) ...[
                              if (reaction.$2.$1 != null &&
                                      (reaction.$1 > 0 &&
                                          notification
                                                  .reactionUsers[
                                                      reaction.$1 - 1]
                                                  .$1 !=
                                              reaction.$2.$1) ||
                                  reaction.$1 == 0)
                                CustomEmoji(
                                  emojiData: MisskeyEmojiData.fromEmojiName(
                                    emojiName: reaction.$2.$1!,
                                    repository: ref.read(
                                        emojiRepositoryProvider(
                                            AccountScope.of(context))),
                                    emojiInfo:
                                        notification.note?.reactionEmojis,
                                  ),
                                  fontSizeRatio: 2,
                                ),
                              if (reaction.$2.$2 != null)
                                Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: UserListItem(user: reaction.$2.$2!)),
                            ]
                          ],
                        ),
                      )
                  ],
                ),
              )
            ],
          ),
        );

      case MentionQuoteNotificationData():
        return Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
          child: Column(
            children: [
              if (notification.note != null)
                misskey_note.MisskeyNote(note: notification.note!)
            ],
          ),
        );
      case FollowNotificationData():
        final user = notification.user;

        return Padding(
          padding:
              const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SimpleMfmText(
                      "${user?.name ?? user?.username}から${notification.type.name}",
                      emojis: user?.emojis ?? {},
                    ),
                  ),
                  Text(notification.createdAt.differenceNow),
                ],
              ),
              if (user != null) UserListItem(user: user),
              if (showActions && user != null)
                if (notification.type ==
                    FollowNotificationDataType.receiveFollowRequest)
                  followRequests.maybeWhen(
                    data: (requests) {
                      final isPending = requests
                          .any((request) => request.follower.id == user.id);
                      if (isPending) {
                        return Row(
                          children: [
                            const Spacer(flex: 3),
                            Flexible(
                              flex: 5,
                              fit: FlexFit.tight,
                              child: ElevatedButton(
                                onPressed: () => handleFollowRequest(
                                  ref,
                                  account: account,
                                  accept: true,
                                  userId: user.id,
                                ).expectFailure(context),
                                child: const Text("許可"),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              flex: 5,
                              fit: FlexFit.tight,
                              child: OutlinedButton(
                                onPressed: () => handleFollowRequest(
                                  ref,
                                  account: account,
                                  accept: false,
                                  userId: user.id,
                                ).expectFailure(context),
                                child: const Text("拒否"),
                              ),
                            ),
                            const Spacer(flex: 3),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                    orElse: () => Container(),
                  ),
            ],
          ),
        );
      case SimpleNotificationData():
        return Padding(
          padding:
              const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
          child: Row(
            children: [
              Expanded(child: Text(notification.text)),
              Text(notification.createdAt.differenceNow),
            ],
          ),
        );
      case PollNotification():
        return Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: [
                    const Expanded(child: Text("投票が終わったみたいや")),
                    Text(notification.createdAt.differenceNow),
                  ],
                ),
              ),
              misskey_note.MisskeyNote(
                note: notification.note!,
                isDisplayBorder: false,
              ),
            ],
          ),
        );
      case NoteNotification():
        return Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (notification.note?.user != null)
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: SimpleMfmText(
                    "${notification.note?.user.name ?? notification.note?.user.username}さんがノートしはったで",
                    emojis: notification.note?.user.emojis ?? {},
                  ),
                ),
              if (notification.note != null)
                misskey_note.MisskeyNote(note: notification.note!)
            ],
          ),
        );
      case RoleNotification():
        return Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10.0),
          child: Row(
            children: [
              Expanded(
                child: SimpleMfmText(
                  "ロール「${notification.role?.name}」に入れられたみたいや",
                ),
              ),
            ],
          ),
        );
    }
  }

  Future<void> handleFollowRequest(
    WidgetRef ref, {
    required Account account,
    required bool accept,
    required String userId,
  }) async {
    final misskey = ref.watch(misskeyProvider(account));

    if (accept) {
      await misskey.following.requests
          .accept(FollowingRequestsAcceptRequest(userId: userId));
    } else {
      await misskey.following.requests
          .reject(FollowingRequestsRejectRequest(userId: userId));
    }

    ref.invalidate(followRequestsProvider(account));
    ref.read(showActionsProvider(notification).notifier).state = false;
  }
}
