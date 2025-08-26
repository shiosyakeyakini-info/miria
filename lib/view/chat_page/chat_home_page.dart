import "dart:async";

import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/hooks/use_async.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/providers.dart";
import "package:miria/repository/account_repository.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/chat_page/chat_content.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/avatar_icon.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/common/error_detail.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:miria/view/themes/app_theme.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "chat_home_page.g.dart";

@RoutePage()
class ChatHomePage extends HookConsumerWidget implements AutoRouteWrapper {
  final AccountContext accountContext;
  final int initialTab;

  const ChatHomePage({
    required this.accountContext,
    this.initialTab = 0,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // チャットページを開いたときに未読状態をクリア

    return DefaultTabController(
      length: 4,
      initialIndex: initialTab,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);
          return Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(child: Text(S.of(context).home)),
                  Tab(child: Text(S.of(context).chatInvitation)),
                  Tab(child: Text(S.of(context).channel)),
                  Tab(child: Text(S.of(context).chatOwnRooms)),
                ],
              ),
            ),
            body: const TabBarView(
              children: [ChatHome(), InvitedChat(), JoiningChat(), OwnedChat()],
            ),
            floatingActionButton: !ref.read(accountContextProvider).isSame
                ? null
                : SafeArea(
                    child: AnimatedBuilder(
                      animation: tabController,
                      builder: (context, child) {
                        final currentTab = tabController.index;
                        // ホームタブ（0）では対ユーザーチャット、その他ではルーム作成
                        if (currentTab == 0) {
                          return FloatingActionButton(
                            onPressed: () async {
                              final selectedUser = await context.router
                                  .push<User>(
                                    UserSelectRoute(
                                      accountContext: ref.read(
                                        accountContextProvider,
                                      ),
                                    ),
                                  );
                              if (selectedUser != null) {
                                if (!context.mounted) return;
                                await context.router.push(
                                  UserChatRoute(
                                    user: selectedUser,
                                    accountContext: ref.read(
                                      accountContextProvider,
                                    ),
                                  ),
                                );
                              }
                            },
                            tooltip: S.of(context).chatNewChat,
                            child: const Icon(Icons.person_add),
                          );
                        } else {
                          return FloatingActionButton(
                            onPressed: () async {
                              await context.router.push(
                                ChatRoomCreateRoute(
                                  accountContext: ref.read(
                                    accountContextProvider,
                                  ),
                                ),
                              );
                            },
                            tooltip: S.of(context).create,
                            child: const Icon(Icons.add),
                          );
                        }
                      },
                    ),
                  ),
          );
        },
      ),
    );
  }
}

@Riverpod(dependencies: [misskeyPostContext])
Future<List<ChatMessage>> history(Ref ref) async {
  final (a, b) = await (
    ref
        .read(misskeyPostContextProvider)
        .chat
        .history(const ChatHistoryRequest(limit: 30, room: false)),
    ref
        .read(misskeyPostContextProvider)
        .chat
        .history(const ChatHistoryRequest(limit: 30, room: true)),
  ).wait;

  return [...a, ...b]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
}

class ChatHome extends HookConsumerWidget {
  const ChatHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);

    useEffect(() {
      unawaited(() async {
        try {
          await ref.read(misskeyPostContextProvider).chat.readAll();
          await ref
              .read(accountRepositoryProvider.notifier)
              .readAllChatMessages(
                ref.read(accountContextProvider).postAccount,
              );
        } catch (e) {
          debugPrint("Failed to call chat.readAll() on chat home page: $e");
        }
      }());
      return null;
    }, []);

    return switch (history) {
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
      AsyncError(:final error, :final stackTrace) => ErrorDetail(
        error: error,
        stackTrace: stackTrace,
      ),
      AsyncData(:final value) => Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () async {
              final room = value[index].toRoom;
              final targetUser =
                  value[index].toUser?.id ==
                      ref.read(accountContextProvider).getAccount.i.id
                  ? value[index].fromUser
                  : value[index].toUser;
              if (room != null) {
                await context.router.push(
                  RoomChatRoute(
                    room: room,
                    accountContext: ref.read(accountContextProvider),
                  ),
                );
              } else if (targetUser != null) {
                await context.router.push(
                  UserChatRoute(
                    user: targetUser,
                    accountContext: ref.read(accountContextProvider),
                  ),
                );
              }
            },
            child: ChatContent(message: value[index]),
          ),
        ),
      ),
    };
  }
}

class InvitedChat extends HookConsumerWidget {
  const InvitedChat({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final valueNotifier = useState(DateTime.now());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: PushableListView(
        initializeFuture: () async => [
          ...await ref
              .read(misskeyGetContextProvider)
              .chat
              .rooms
              .invitations
              .inbox(const ChatRoomsInvitationsInboxRequest()),
        ],
        nextFuture: (item, index) async => [
          ...await ref
              .read(misskeyGetContextProvider)
              .chat
              .rooms
              .invitations
              .inbox(ChatRoomsInvitationsInboxRequest(untilId: item.id)),
        ],
        itemBuilder: (context, item) => item.room != null
            ? InvitedChatItem(item.room!, valueNotifier)
            : const SizedBox.shrink(),
        listKey: valueNotifier.value,
      ),
    );
  }
}

class InvitedChatItem extends HookConsumerWidget {
  final ChatRoom room;
  final ValueNotifier<Object> valueNotifier;
  const InvitedChatItem(this.room, this.valueNotifier, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final join = useAsync(() async {
      await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
        await ref
            .read(misskeyPostContextProvider)
            .chat
            .rooms
            .join(ChatRoomsJoinRequest(roomId: room.id));
        valueNotifier.value = DateTime.now();
        if (!context.mounted) return;
        await context.pushRoute(
          RoomChatRoute(
            room: room,
            accountContext: ref.read(accountContextProvider),
          ),
        );
      });
    });
    final ignore = useAsync(() async {
      await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
        await ref
            .read(misskeyPostContextProvider)
            .chat
            .rooms
            .invitations
            .ignore(ChatRoomsInvitationsIgnoreRequest(roomId: room.id));
        if (!context.mounted) return;
        valueNotifier.value = DateTime.now();
        await ref
            .read(dialogStateNotifierProvider.notifier)
            .showSimpleDialog(message: (context) => S.of(context).chatIgnored);
      });
    });

    return GestureDetector(
      onTap: () async {
        await context.router.push(
          RoomChatRoute(
            room: room,
            accountContext: ref.read(accountContextProvider),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppTheme.of(context).colorTheme.accentedBackground,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 3, bottom: 3),
                    child: Text(room.name),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                child: Row(
                  children: [
                    AvatarIcon(user: room.owner),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SimpleMfmText(room.owner.name ?? room.owner.username),
                        const Divider(),
                        Text(
                          room.description.isEmpty
                              ? S.of(context).chatNoDescription
                              : room.description,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.all(5)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: join.executeOrNull,
                        child: Text(S.of(context).chatJoin),
                      ),
                    ),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: ignore.executeOrNull,
                        child: Text(S.of(context).chatIgnore),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JoiningChat extends ConsumerWidget {
  const JoiningChat({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PushableListView(
        initializeFuture: () async => [
          ...await ref
              .read(misskeyGetContextProvider)
              .chat
              .rooms
              .joining(const ChatRoomsJoiningRequest()),
        ],
        nextFuture: (item, _) async => [
          ...await ref
              .read(misskeyGetContextProvider)
              .chat
              .rooms
              .joining(ChatRoomsJoiningRequest(sinceId: item.id)),
        ],
        itemBuilder: (context, item) => RoomInfo(room: item.room!),
      ),
    );
  }
}

class RoomInfo extends ConsumerWidget {
  final ChatRoom room;
  const RoomInfo({required this.room, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        await context.router.push(
          RoomChatRoute(
            room: room,
            accountContext: ref.read(accountContextProvider),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(room.name), Text(room.description)],
        ),
      ),
    );
  }
}

class OwnedChat extends ConsumerWidget {
  const OwnedChat({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PushableListView(
        initializeFuture: () async => [
          ...await ref
              .read(misskeyGetContextProvider)
              .chat
              .rooms
              .owned(const ChatRoomsOwnedRequest()),
        ],
        nextFuture: (item, _) async => [
          ...await ref
              .read(misskeyGetContextProvider)
              .chat
              .rooms
              .owned(ChatRoomsOwnedRequest(sinceId: item.id)),
        ],
        itemBuilder: (context, item) => RoomInfo(room: item),
      ),
    );
  }
}
