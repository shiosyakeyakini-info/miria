import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/hooks/use_async.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/providers.dart";
import "package:miria/repository/chat_room_repository.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/dialog/dialog_state.dart";

@RoutePage()
class ChatRoomCreatePage extends HookConsumerWidget
    implements AutoRouteWrapper {
  final AccountContext accountContext;

  const ChatRoomCreatePage({required this.accountContext, super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final createRoom = useAsync(() async {
      if (!formKey.currentState!.validate()) return;

      await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
        final room = await ref
            .read(chatRoomRepositoryProvider.notifier)
            .createRoom(
              name: nameController.text.trim(),
              description: descriptionController.text.trim().isEmpty
                  ? null
                  : descriptionController.text.trim(),
            );

        if (!context.mounted) return;

        // ルーム作成成功後、作成したルームのチャット画面に遷移
        // 作成ページをルームチャットに置き換えて、戻るボタンでチャットホームに戻れるようにする
        await context.router.replace(
          RoomChatRoute(room: room, accountContext: accountContext),
        );
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).create),
        actions: [
          ElevatedButton.icon(
            onPressed: createRoom.executeOrNull,
            icon: const Icon(Icons.check),
            label: Text(S.of(context).chatCreate),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: S.of(context).chatRoomName,
                  hintText: S.of(context).pleaseInput,
                  border: OutlineInputBorder(),
                ),
                // 文字数制限はサーバー側で行われるため、maxLengthは設定しない
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return S.of(context).pleaseInput;
                  }
                  return null;
                },
                enabled: createRoom.value is! AsyncLoading,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: S.of(context).chatRoomDescription,
                  hintText: S.of(context).pleaseInput,
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                // 文字数制限はサーバー側で行われるため、maxLengthは設定しない
                validator: (value) {
                  // 説明は任意なので空白チェックなし
                  return null;
                },
                enabled: createRoom.value is! AsyncLoading,
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            S.of(context).create,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "• ルーム作成後は、メンバーを招待してチャットを開始できます\n"
                        "• あなたがルームの管理者となります\n"
                        "• ルーム名と説明は後から変更可能です",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
