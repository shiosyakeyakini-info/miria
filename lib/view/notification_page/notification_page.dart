import "package:auto_route/auto_route.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/date_time_extension.dart";
import "package:miria/model/misskey_emoji_data.dart";
import "package:miria/providers.dart";
import "package:miria/repository/account_repository.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/common/misskey_notes/custom_emoji.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart"
    as misskey_note;
import "package:miria/view/common/pushable_listview.dart";
import "package:miria/view/notification_page/notification_page_data.dart";
import "package:miria/view/user_page/user_list_item.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "notification_page.g.dart";

@RoutePage()
class NotificationPage extends ConsumerWidget implements AutoRouteWrapper {
  final AccountContext accountContext;

  const NotificationPage({required this.accountContext, super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final misskey = ref.read(misskeyPostContextProvider);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).notification),
          bottom: TabBar(
            tabs: [
              Tab(text: S.of(context).notificationAll),
              Tab(text: S.of(context).notificationForMe),
              Tab(text: S.of(context).notificationDirect),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: TabBarView(
            children: [
              PushableListView<NotificationData>(
                initializeFuture: () async {
                  final localize = S.of(context);
                  final result = await misskey.i.notifications(
                    const INotificationsRequest(
                      limit: 50,
                      markAsRead: true,
                    ),
                  );
                  ref
                      .read(notesWithProvider)
                      .registerAll(result.map((e) => e.note).whereNotNull());

                  await ref
                      .read(accountRepositoryProvider.notifier)
                      .readAllNotification(accountContext.postAccount);
                  return result.toNotificationData(localize);
                },
                nextFuture: (lastElement, _) async {
                  final localize = S.of(context);
                  final result = await misskey.i.notifications(
                    INotificationsRequest(
                      limit: 50,
                      untilId: lastElement.id,
                    ),
                  );
                  ref
                      .read(notesWithProvider)
                      .registerAll(result.map((e) => e.note).whereNotNull());
                  return result.toNotificationData(localize);
                },
                itemBuilder: (context, notification) => Align(
                  alignment: Alignment.center,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: NotificationItem(notification: notification),
                  ),
                ),
              ),
              PushableListView<Note>(
                initializeFuture: () async {
                  final notes = await ref
                      .read(misskeyPostContextProvider)
                      .notes
                      .mentions(const NotesMentionsRequest());
                  ref.read(notesWithProvider).registerAll(notes);
                  return notes.toList();
                },
                nextFuture: (item, _) async {
                  final notes = await ref
                      .read(misskeyPostContextProvider)
                      .notes
                      .mentions(NotesMentionsRequest(untilId: item.id));
                  ref.read(notesWithProvider).registerAll(notes);
                  return notes.toList();
                },
                itemBuilder: (context, note) {
                  return misskey_note.MisskeyNote(note: note);
                },
              ),
              PushableListView<Note>(
                initializeFuture: () async {
                  final notes =
                      await ref.read(misskeyPostContextProvider).notes.mentions(
                            const NotesMentionsRequest(
                              visibility: NoteVisibility.specified,
                            ),
                          );
                  ref.read(notesWithProvider).registerAll(notes);
                  return notes.toList();
                },
                nextFuture: (item, _) async {
                  final notes =
                      await ref.read(misskeyPostContextProvider).notes.mentions(
                            NotesMentionsRequest(
                              untilId: item.id,
                              visibility: NoteVisibility.specified,
                            ),
                          );
                  ref.read(notesWithProvider).registerAll(notes);
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
    );
  }
}

final showActionsProvider =
    StateProvider.autoDispose.family<bool, NotificationData>((ref, _) => true);

@Riverpod(dependencies: [misskeyPostContext])
Future<List<FollowRequest>> followRequests(FollowRequestsRef ref) async {
  final response = await ref
      .watch(misskeyPostContextProvider)
      .following
      .requests
      .list(const FollowingRequestsListRequest());
  return response.toList();
}

class NotificationItem extends ConsumerWidget {
  final NotificationData notification;

  const NotificationItem({
    required this.notification,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notification = this.notification;
    final showActions = ref.watch(showActionsProvider(notification));
    final followRequests = ref.watch(followRequestsProvider);

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
                          S.of(context).renoteAndReactionsNotification(
                                notification.reactionUsers.first.$2?.name ??
                                    notification
                                        .reactionUsers.first.$2?.username,
                                notification.renoteUsers.first?.name ??
                                    notification.renoteUsers.first?.username,
                              ),
                          emojis: Map.of(
                            notification.reactionUsers.first.$2?.emojis ?? {},
                          )..addAll(
                              notification.renoteUsers.first?.emojis ?? {},
                            ),
                        ),
                      ),
                    if (hasReaction && !hasRenote)
                      Expanded(
                        child: SimpleMfmText(
                          S.of(context).reactionNotification(
                                notification.reactionUsers.first.$2?.name ??
                                    notification
                                        .reactionUsers.first.$2?.username,
                              ),
                          emojis:
                              notification.reactionUsers.first.$2?.emojis ?? {},
                        ),
                      ),
                    if (hasRenote && !hasReaction)
                      Expanded(
                        child: SimpleMfmText(
                          S.of(context).renoteNotification(
                                notification.renoteUsers.first?.name ??
                                    notification.renoteUsers.first?.username,
                              ),
                          emojis: notification.renoteUsers.first?.emojis ?? {},
                        ),
                      ),
                    Text(notification.createdAt.differenceNow(context)),
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
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(S.of(context).renotedUsersInNotification),
                            Column(
                              children: [
                                for (final user
                                    in notification.renoteUsers.whereNotNull())
                                  UserListItem(user: user),
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
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(S.of(context).reactionUsersInNotification),
                            for (final reaction
                                in notification.reactionUsers.mapIndexed(
                              (index, element) => (index, element),
                            )) ...[
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
                                        ref
                                            .read(accountContextProvider)
                                            .getAccount,
                                      ),
                                    ),
                                    emojiInfo:
                                        notification.note?.reactionEmojis,
                                  ),
                                  fontSizeRatio: 2,
                                ),
                              if (reaction.$2.$2 != null)
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: UserListItem(user: reaction.$2.$2!),
                                ),
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );

      case MentionQuoteNotificationData():
        return Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
          child: Column(
            children: [
              if (notification.note != null)
                misskey_note.MisskeyNote(note: notification.note!),
            ],
          ),
        );
      case FollowNotificationData():
        final user = notification.user;
        final type = notification.type;

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
                      notification.type
                          .name(context, (user?.name ?? user?.username) ?? ""),
                      emojis: user?.emojis ?? {},
                    ),
                  ),
                  Text(notification.createdAt.differenceNow(context)),
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
                                onPressed: () async => handleFollowRequest(
                                  ref,
                                  accept: true,
                                  userId: user.id,
                                ),
                                child: Text(S.of(context).accept),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              flex: 5,
                              fit: FlexFit.tight,
                              child: OutlinedButton(
                                onPressed: () async => handleFollowRequest(
                                  ref,
                                  accept: false,
                                  userId: user.id,
                                ),
                                child: Text(S.of(context).reject),
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
              if (type is FollowRequestAccepted && type.message != null)
                SimpleMfmText(
                  S.of(context).messageForFollower(type.message ?? ""),
                )
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
              Text(notification.createdAt.differenceNow(context)),
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
                    Expanded(
                      child: Text(S.of(context).finishedVotedNotification),
                    ),
                    Text(notification.createdAt.differenceNow(context)),
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
      case NoteNotification(:final note):
        final user = note?.user;
        return Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user != null)
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: SimpleMfmText(
                    S.of(context).notedNotification(user.name ?? user.username),
                    emojis: user.emojis,
                  ),
                ),
              if (note != null) misskey_note.MisskeyNote(note: note),
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
                  S
                      .of(context)
                      .roleAssignedNotification(notification.role?.name ?? ""),
                ),
              ),
            ],
          ),
        );
    }
  }

  Future<void> handleFollowRequest(
    WidgetRef ref, {
    required bool accept,
    required String userId,
  }) async {
    await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      final misskey = ref.watch(misskeyPostContextProvider);

      if (accept) {
        await misskey.following.requests
            .accept(FollowingRequestsAcceptRequest(userId: userId));
      } else {
        await misskey.following.requests
            .reject(FollowingRequestsRejectRequest(userId: userId));
      }

      ref.invalidate(followRequestsProvider);
      ref.read(showActionsProvider(notification).notifier).state = false;
    });
  }
}
