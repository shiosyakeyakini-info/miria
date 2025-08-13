import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/hooks/use_async.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:miria/view/user_page/user_list_item.dart";
import "package:misskey_dart/misskey_dart.dart";

class ChatRoomInfo extends HookConsumerWidget {
  final ChatRoom room;
  const ChatRoomInfo({required this.room, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameEditingController = useTextEditingController(text: room.name);
    final descriptionEditingController = useTextEditingController(
      text: room.description,
    );
    final isOwned = useMemoized(
      () => room.ownerId == ref.read(accountContextProvider).postAccount.i.id,
      [room],
    );
    final isMuted = useState(room.isMuted ?? false);

    final update = useAsync(() async {
      await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
        await ref
            .read(misskeyGetContextProvider)
            .chat
            .rooms
            .update(
              ChatRoomsUpdateRequest(
                roomId: room.id,
                name: nameEditingController.text,
                description: descriptionEditingController.text,
              ),
            );
      });
    });

    final listKey = useState(DateTime.now().toIso8601String());

    final addUsers = useAsync(() async {
      final accountContext = ref.read(accountContextProvider);
      final result = await context.pushRoute<User>(
        UserSelectRoute(accountContext: accountContext, isLocalOnly: true),
      );
      if (result == null) return;
      await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
        await ref
            .read(misskeyPostContextProvider)
            .chat
            .rooms
            .invitations
            .create(
              ChatRoomsInvitationsCreateRequest(
                roomId: room.id,
                userId: result.id,
              ),
            );
        await ref
            .read(dialogStateNotifierProvider.notifier)
            .showSimpleDialog(message: (context) => "招待したで");
      });
    });

    final mute = useAsync(() async {
      await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
        if (isMuted.value) {
          await ref
              .read(misskeyGetContextProvider)
              .chat
              .rooms
              .mute(ChatRoomsMuteRequest(roomId: room.id, mute: false));
        } else {
          await ref
              .read(misskeyGetContextProvider)
              .chat
              .rooms
              .mute(ChatRoomsMuteRequest(roomId: room.id, mute: true));
        }
        isMuted.value = !isMuted.value;
      });
    });

    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              TextField(
                controller: nameEditingController,
                enabled: isOwned,
                decoration: InputDecoration(labelText: "名前"),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: descriptionEditingController,
                enabled: isOwned,
                decoration: InputDecoration(labelText: "説明"),
                maxLines: 5,
              ),
              if (!isOwned)
                Row(
                  children: [
                    Switch(
                      value: isMuted.value,
                      onChanged: (value) async => mute.executeOrNull?.call(),
                    ),
                    Expanded(child: Text("ミュート")),
                  ],
                ),
              if (isOwned) ...[
                ElevatedButton(
                  onPressed: update.executeOrNull,
                  child: Text("更新"),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () async {
                    final isConfirm = await ref
                        .read(dialogStateNotifierProvider.notifier)
                        .showDialog(
                          message: (context) => "このルームを削除してもええ？\n削除すると元に戻せへんで。",
                          actions: (context) => ["削除する", "キャンセル"],
                        );
                    if (isConfirm == 1) return;
                    await ref.read(dialogStateNotifierProvider.notifier).guard(
                      () async {
                        await ref
                            .read(misskeyGetContextProvider)
                            .chat
                            .rooms
                            .delete(ChatRoomsDeleteRequest(roomId: room.id));
                        await ref
                            .read(dialogStateNotifierProvider.notifier)
                            .showSimpleDialog(
                              message: (context) => "ルームを削除したで",
                            );
                        if (!context.mounted) return;
                        // ルーム削除後は現在のルームチャット画面を削除して前の画面に戻る
                        // まずDrawerを閉じてからナビゲーションを実行
                        Navigator.of(context).pop(); // Drawerを閉じる
                        await Future.delayed(
                          const Duration(milliseconds: 100),
                        ); // 少し待つ
                        if (!context.mounted) return;
                        context.router.maybePop(); // ルームチャット画面を削除
                      },
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  child: Text("ルームを削除"),
                ),
              ],
              ExpansionTile(
                initiallyExpanded: true,
                title: Text("チャット立てた人"),
                children: [UserListItem(user: room.owner)],
              ),
              ExpansionTile(
                initiallyExpanded: true,
                title: Row(
                  children: [
                    Expanded(child: Text("チャットのメンバー")),
                    IconButton(
                      onPressed: addUsers.executeOrNull,
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
                children: [
                  PushableListView(
                    initializeFuture: () async => [
                      ...await ref
                          .read(misskeyGetContextProvider)
                          .chat
                          .rooms
                          .members(ChatRoomsMembersRequest(roomId: room.id)),
                    ],
                    nextFuture: (item, _) async => [
                      ...await ref
                          .read(misskeyGetContextProvider)
                          .chat
                          .rooms
                          .members(
                            ChatRoomsMembersRequest(
                              roomId: room.id,
                              untilId: item.id,
                            ),
                          ),
                    ],
                    itemBuilder: (context, item) =>
                        UserListItem(user: item.user!),
                    listKey: listKey.value,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                ],
              ),
              if (isOwned)
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text("招待中のメンバー"),
                  children: [
                    PushableListView(
                      initializeFuture: () async => [
                        ...await ref
                            .read(misskeyGetContextProvider)
                            .chat
                            .rooms
                            .invitations
                            .outbox(
                              ChatRoomsInvitationsOutboxRequest(
                                roomId: room.id,
                              ),
                            ),
                      ],
                      nextFuture: (item, _) async => [
                        ...await ref
                            .read(misskeyGetContextProvider)
                            .chat
                            .rooms
                            .invitations
                            .outbox(
                              ChatRoomsInvitationsOutboxRequest(
                                roomId: room.id,
                                untilId: item.id,
                              ),
                            ),
                      ],
                      itemBuilder: (context, item) =>
                          UserListItem(user: item.user!),
                      listKey: listKey.value,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                  ],
                ),
              if (!isOwned)
                OutlinedButton(
                  onPressed: () async {
                    final isConfirm = await ref
                        .read(dialogStateNotifierProvider.notifier)
                        .showDialog(
                          message: (context) => "チャットから退出してもええ？",
                          actions: (context) => ["退出する", "キャンセル"],
                        );
                    if (isConfirm == 1) return;
                    await ref.read(dialogStateNotifierProvider.notifier).guard(
                      () async {
                        await ref
                            .read(misskeyGetContextProvider)
                            .chat
                            .rooms
                            .leave(ChatRoomsLeaveRequest(roomId: room.id));
                        await ref
                            .read(dialogStateNotifierProvider.notifier)
                            .showSimpleDialog(
                              message: (context) => "チャットから退出したで",
                            );
                        if (!context.mounted) return;
                        // ルーム退出後は現在のルームチャット画面を削除して前の画面に戻る
                        Navigator.of(context).pop(); // Drawerを閉じる
                        await Future.delayed(
                          const Duration(milliseconds: 100),
                        ); // 少し待つ
                        if (!context.mounted) return;
                        context.router.maybePop(); // ルームチャット画面を削除
                      },
                    );
                  },
                  child: Text("チャットから退出"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
