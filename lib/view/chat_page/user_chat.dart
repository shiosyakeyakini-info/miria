import "dart:async";

import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:hooks_riverpod/legacy.dart";
import "package:miria/hooks/use_async.dart";
import "package:miria/model/image_file.dart";
import "package:miria/providers.dart";
import "package:miria/repository/socket_timeline_repository.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/chat_input_state_notifier.dart";
import "package:miria/view/chat_page/chat_file_preview.dart";
import "package:miria/view/chat_page/chat_message_item.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/common/error_detail.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:miria/view/common/note_create/input_completation.dart";
import "package:miria/view/note_create_page/file_settings_dialog.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:uuid/uuid.dart";

part "user_chat.g.dart";

@Riverpod(keepAlive: true, dependencies: [misskeyGetContext])
class UserChat extends _$UserChat {
  @override
  Future<List<ChatMessage>> build(String userId) async {
    return [
      ...await ref
          .read(misskeyGetContextProvider)
          .chat
          .messages
          .userTimeline(ChatMessagesUserTimelineRequest(userId: userId)),
    ];
  }

  void addChat(ChatMessage message) {
    if (state is! AsyncData) return;
    state = AsyncData([message, ...state.value ?? []]);
  }

  void addMessageReaction(String messageId, String reaction, UserLite? user) {
    if (state is! AsyncData) return;
    final messages = List<ChatMessage>.from(state.value ?? []);
    final messageIndex = messages.indexWhere((m) => m.id == messageId);
    if (messageIndex == -1) return;

    final message = messages[messageIndex];
    final reactions = List<ChatMessageReaction>.from(message.reactions);
    reactions.add(ChatMessageReaction(reaction: reaction, user: user));

    messages[messageIndex] = message.copyWith(reactions: reactions);
    state = AsyncData(messages);
  }

  void deleteMessageReaction(
    String messageId,
    String reaction,
    UserLite? user,
  ) {
    if (state is! AsyncData) return;
    final messages = List<ChatMessage>.from(state.value ?? []);
    final messageIndex = messages.indexWhere((m) => m.id == messageId);
    if (messageIndex == -1) return;

    final message = messages[messageIndex];
    final reactions = List<ChatMessageReaction>.from(message.reactions);
    reactions.removeWhere(
      (r) => r.reaction == reaction && r.user?.id == user?.id,
    );

    messages[messageIndex] = message.copyWith(reactions: reactions);
    state = AsyncData(messages);
  }
}

@RoutePage()
class UserChatPage extends HookConsumerWidget implements AutoRouteWrapper {
  final User user;
  final AccountContext accountContext;

  const UserChatPage({
    required this.user,
    required this.accountContext,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSearching = useState(false);
    final searchController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: isSearching.value
            ? TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: "メッセージを検索...",
                  border: InputBorder.none,
                ),
                onSubmitted: (query) {
                  if (query.trim().isNotEmpty) {
                    context.pushRoute(
                      ChatSearchRoute(
                        account: accountContext.getAccount,
                        chatId: user.id,
                        isChannel: false,
                        query: query.trim(),
                      ),
                    );
                  }
                },
              )
            : SimpleMfmText("${user.name ?? user.username}とのチャット"),
        actions: [
          IconButton(
            icon: Icon(isSearching.value ? Icons.close : Icons.search),
            onPressed: () {
              isSearching.value = !isSearching.value;
              if (!isSearching.value) {
                searchController.clear();
              }
            },
          ),
        ],
      ),
      body: Center(child: UserChatTimeline(user: user)),
    );
  }
}

class UserChatTimeline extends HookConsumerWidget {
  final User user;
  const UserChatTimeline({required this.user, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userChat = ref.watch(userChatProvider(user.id));
    final streamingId = useMemoized(() => const Uuid().v4());

    useEffect(() {
      final misskey = ref.read(misskeyGetContextProvider);
      StreamSubscription<StreamingResponse>? chatStream;
      StreamingController? streaming;
      unawaited(() async {
        streaming = await ref.read(misskeyStreamingProvider(misskey).future);
        chatStream = streaming!
            .chatUserStream(
              id: streamingId,
              parameter: ChatUserParameter(otherId: user.id),
            )
            .listen((response) {
              final body = response.body;
              switch (body) {
                case ChatMessageChannelEvent():
                  ref
                      .read(userChatProvider(user.id).notifier)
                      .addChat(body.body);
                case ChatReactChannelEvent():
                  final reactData = body.body;
                  ref
                      .read(userChatProvider(user.id).notifier)
                      .addMessageReaction(
                        reactData.messageId,
                        reactData.reaction,
                        reactData.user,
                      );
                case ChatUnreactChannelEvent():
                  final reactData = body.body;
                  ref
                      .read(userChatProvider(user.id).notifier)
                      .deleteMessageReaction(
                        reactData.messageId,
                        reactData.reaction,
                        reactData.user,
                      );
                default:
                  break;
              }
            });
      }());

      return () {
        unawaited(() async {
          await (
            streaming?.removeChannel(streamingId) ?? Future.value(),
            chatStream?.cancel() ?? Future.value(),
          ).wait;
        }());
      };
    }, const []);
    return switch (userChat) {
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
      AsyncError(:final error, :final stackTrace) => ErrorDetail(
        error: error,
        stackTrace: stackTrace,
      ),
      AsyncData(:final value) => Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: value.length,
              reverse: true,
              itemBuilder: (context, index) {
                final message = value[index];
                final isMyMessage =
                    message.fromUserId ==
                    ref.read(accountContextProvider).getAccount.i.id;

                return ChatMessageItem(
                  message: message,
                  user: isMyMessage ? null : user,
                  isMyMessage: isMyMessage,
                );
              },
            ),
          ),
          UserChatTextField(userId: user.id),
        ],
      ),
    };
  }
}

final userChatFocusNodeProvider = ChangeNotifierProvider<FocusNode>((ref) {
  return FocusNode();
});

class UserChatTextField extends HookConsumerWidget {
  final String userId;
  const UserChatTextField({required this.userId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditingController = useTextEditingController();
    final focusNode = ref.watch(userChatFocusNodeProvider);
    final chatInputState = ref.watch(chatInputStateNotifierProvider);

    final chat = useAsync(() async {
      final text = textEditingController.text;
      textEditingController.clear();

      // ファイルをアップロードしてfileIdを取得
      final fileId = await ref
          .read(chatInputStateNotifierProvider.notifier)
          .uploadAndGetFileId();

      await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
        try {
          await ref
              .read(misskeyPostContextProvider)
              .chat
              .messages
              .createToUser(
                ChatMessagesCreateToUserRequest(
                  toUserId: userId,
                  text: text.isEmpty ? null : text,
                  fileId: fileId,
                ),
              );
        } catch (e) {
          textEditingController.text = text;
          rethrow;
        }
      });
    });

    return Column(
      children: [
        InputComplement(
          controller: textEditingController,
          focusNode: userChatFocusNodeProvider,
        ),
        if (chatInputState.files.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: chatInputState.files.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: ChatFilePreview(
                    file: chatInputState.files[index],
                    onFileDeleted: () => ref
                        .read(chatInputStateNotifierProvider.notifier)
                        .removeFile(index),
                    onFileSettingChanged: (file) async {
                      final editedFile =
                          await showDialog<FileSettingsDialogResult?>(
                            context: context,
                            builder: (context) =>
                                FileSettingsDialog(file: file),
                          );
                      if (editedFile != null) {
                        // NSFWやキャプションの変更を反映
                        final updatedFile = switch (file) {
                          ImageFile() => ImageFile(
                            data: file.data,
                            fileName: file.fileName,
                            isNsfw: editedFile.isNsfw,
                            caption: editedFile.caption,
                          ),
                          UnknownFile() => UnknownFile(
                            data: file.data,
                            fileName: file.fileName,
                            isNsfw: editedFile.isNsfw,
                            caption: editedFile.caption,
                          ),
                          _ => file,
                        };
                        ref
                            .read(chatInputStateNotifierProvider.notifier)
                            .removeFile(index);
                        await ref
                            .read(chatInputStateNotifierProvider.notifier)
                            .addFile(updatedFile);
                      }
                    },
                  ),
                );
              },
            ),
          ),
        Row(
          children: [
            IconButton(
              onPressed: () async {
                await ref
                    .read(chatInputStateNotifierProvider.notifier)
                    .chooseFile();
              },
              icon: const Icon(Icons.attach_file),
            ),
            Expanded(
              child: Focus(
                onKeyEvent: (node, event) {
                  if (event is KeyDownEvent) {
                    if (event.logicalKey == LogicalKeyboardKey.enter &&
                        HardwareKeyboard.instance.isControlPressed) {
                      unawaited(chat.execute());
                      return KeyEventResult.handled;
                    }
                  }
                  return KeyEventResult.ignored;
                },
                child: TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                ),
              ),
            ),
            IconButton(onPressed: chat.execute, icon: const Icon(Icons.send)),
          ],
        ),
      ],
    );
  }
}
