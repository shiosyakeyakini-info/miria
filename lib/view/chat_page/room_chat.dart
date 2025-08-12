import "dart:async";

import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:hooks_riverpod/experimental/mutation.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:hooks_riverpod/legacy.dart";
import "package:miria/providers.dart";
import "package:miria/repository/socket_timeline_repository.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/chat_page/chat_message_item.dart";
import "package:miria/view/chat_page/pending_chat_message_item.dart";
import "package:miria/view/chat_page/room_info.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/error_detail.dart";
import "package:miria/view/common/note_create/input_completation.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:uuid/uuid.dart";

part "room_chat.freezed.dart";
part "room_chat.g.dart";

@freezed
sealed class RoomChatState with _$RoomChatState {
  const factory RoomChatState({
    required List<ChatMessage> messages,
    @Default(true) bool hasMoreMessages,
    @Default([]) List<PendingChatMessage> pendingMessages,
  }) = _RoomChatState;
}


// RoomChatの過去メッセージ取得用Mutation
final loadRoomChatPreviousMessagesMutation = Mutation<void>();

// RoomChatのメッセージ送信用Mutation
final sendRoomChatMessageMutation = Mutation<void>();

@Riverpod(keepAlive: true, dependencies: [misskeyGetContext])
class RoomChat extends _$RoomChat {
  @override
  Future<RoomChatState> build(String roomId) async {
    final messages = await ref
        .read(misskeyGetContextProvider)
        .chat
        .messages
        .roomTimeline(ChatMessagesRoomTimelineRequest(roomId: roomId));

    return RoomChatState(messages: [...messages], hasMoreMessages: true);
  }

  void addChat(ChatMessage message) {
    if (state is! AsyncData) return;
    final currentState = state.value!;
    state = AsyncData(
      currentState.copyWith(messages: [message, ...currentState.messages]),
    );
  }

  void addPreviousMessages(List<ChatMessage> previousMessages) {
    if (state is! AsyncData) return;
    final currentState = state.value!;

    if (previousMessages.isEmpty) {
      // 空配列が返された場合、これ以上メッセージがないことを示す
      state = AsyncData(currentState.copyWith(hasMoreMessages: false));
    } else {
      state = AsyncData(
        currentState.copyWith(
          messages: [...currentState.messages, ...previousMessages],
        ),
      );
    }
  }

  Future<List<ChatMessage>> fetchPreviousMessages() async {
    if (state is! AsyncData) return [];
    final currentState = state.value!;

    // これ以上メッセージがない場合は早期リターン
    if (!currentState.hasMoreMessages) return [];
    if (currentState.messages.isEmpty) return [];

    final oldestMessage = currentState.messages.last;
    final messages = await ref
        .read(misskeyGetContextProvider)
        .chat
        .messages
        .roomTimeline(
          ChatMessagesRoomTimelineRequest(
            roomId: roomId,
            untilId: oldestMessage.id,
          ),
        );
    return messages.toList();
  }

  void addPendingMessage(PendingChatMessage pendingMessage) {
    if (state is! AsyncData) return;
    final currentState = state.value!;
    state = AsyncData(
      currentState.copyWith(
        pendingMessages: [pendingMessage, ...currentState.pendingMessages],
      ),
    );
  }

  void removePendingMessage(String tempId) {
    if (state is! AsyncData) return;
    final currentState = state.value!;
    state = AsyncData(
      currentState.copyWith(
        pendingMessages: currentState.pendingMessages
            .where((msg) => msg.tempId != tempId)
            .toList(),
      ),
    );
  }

  void addMessageReaction(String messageId, String reaction, UserLite? user) {
    if (state is! AsyncData) return;
    final currentState = state.value!;
    final messages = List<ChatMessage>.from(currentState.messages);
    final messageIndex = messages.indexWhere((m) => m.id == messageId);
    if (messageIndex == -1) return;

    final message = messages[messageIndex];
    final reactions = List<ChatMessageReaction>.from(message.reactions);
    reactions.add(ChatMessageReaction(reaction: reaction, user: user));

    messages[messageIndex] = message.copyWith(reactions: reactions);
    state = AsyncData(currentState.copyWith(messages: messages));
  }

  void deleteMessageReaction(
    String messageId,
    String reaction,
    UserLite? user,
  ) {
    if (state is! AsyncData) return;
    final currentState = state.value!;
    final messages = List<ChatMessage>.from(currentState.messages);
    final messageIndex = messages.indexWhere((m) => m.id == messageId);
    if (messageIndex == -1) return;

    final message = messages[messageIndex];
    final reactions = List<ChatMessageReaction>.from(message.reactions);
    reactions.removeWhere(
      (r) => r.reaction == reaction && r.user?.id == user?.id,
    );

    messages[messageIndex] = message.copyWith(reactions: reactions);
    state = AsyncData(currentState.copyWith(messages: messages));
  }
}

@RoutePage()
class RoomChatPage extends HookConsumerWidget implements AutoRouteWrapper {
  final ChatRoom room;
  final AccountContext accountContext;

  const RoomChatPage({
    required this.room,
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
                        chatId: room.id,
                        isChannel: true,
                        query: query.trim(),
                      ),
                    );
                  }
                },
              )
            : Text(room.name),
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
      body: Center(child: ChatTimeline(roomId: room.id)),
      endDrawer: ChatRoomInfo(room: room),
    );
  }
}

class ChatTimeline extends HookConsumerWidget {
  final String roomId;
  const ChatTimeline({required this.roomId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomChat = ref.watch(roomChatProvider(roomId));
    final streamingId = useMemoized(() => const Uuid().v4());
    final scrollController = useScrollController();
    final loadPreviousMutation = ref.watch(
      loadRoomChatPreviousMessagesMutation,
    );

    useEffect(() {
      final misskey = ref.read(misskeyGetContextProvider);
      StreamSubscription<StreamingResponse>? chatStream;
      StreamingController? streaming;
      unawaited(() async {
        streaming = await ref.read(misskeyStreamingProvider(misskey).future);
        chatStream = streaming!
            .chatRoomStream(
              id: streamingId,
              parameter: ChatRoomParameter(roomId: roomId),
            )
            .listen((response) {
              final body = response.body;
              switch (body) {
                case ChatMessageChannelEvent():
                  ref
                      .read(roomChatProvider(roomId).notifier)
                      .addChat(body.body);

                case ChatReactChannelEvent():
                  final reactData = body.body;
                  ref
                      .read(roomChatProvider(roomId).notifier)
                      .addMessageReaction(
                        reactData.messageId,
                        reactData.reaction,
                        reactData.user,
                      );
                case ChatUnreactChannelEvent():
                  final reactData = body.body;
                  ref
                      .read(roomChatProvider(roomId).notifier)
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

    void loadMoreMessages() {
      if (loadPreviousMutation is MutationPending) return;

      // hasMoreMessagesがfalseの場合は処理しない
      final currentState = roomChat.value;
      if (currentState != null && !currentState.hasMoreMessages) return;

      loadRoomChatPreviousMessagesMutation.run(ref, (ref) async {
        final roomChatNotifier = ref.get(roomChatProvider(roomId).notifier);
        final previousMessages = await roomChatNotifier.fetchPreviousMessages();
        roomChatNotifier.addPreviousMessages(previousMessages);
      });
    }

    return switch (roomChat) {
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
      AsyncError(:final error, :final stackTrace) => ErrorDetail(
        error: error,
        stackTrace: stackTrace,
      ),
      AsyncData(:final value) => Column(
        children: [
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo is ScrollEndNotification &&
                    scrollController.position.pixels >=
                        scrollController.position.maxScrollExtent - 200) {
                  // 上端から200px以内に到達したら過去のメッセージを読み込み
                  loadMoreMessages();
                }
                return false;
              },
              child: ListView.builder(
                controller: scrollController,
                itemCount:
                    value.messages.length +
                    value.pendingMessages.length +
                    (loadPreviousMutation is MutationPending ? 1 : 0),
                reverse: true,
                itemBuilder: (context, index) {
                  // ローディングインジケーターを最上部（逆順なので最後）に表示
                  if (index == value.messages.length + value.pendingMessages.length) {
                    return switch (loadPreviousMutation) {
                      MutationPending() => const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      MutationError() => Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Column(
                            children: [
                              const Icon(Icons.error, color: Colors.red),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: loadMoreMessages,
                                child: const Text("再試行"),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _ => const SizedBox.shrink(),
                    };
                  }

                  // 送信中メッセージを表示
                  if (index < value.pendingMessages.length) {
                    final pendingMessage = value.pendingMessages[index];
                    return PendingChatMessageItem(
                      pendingMessage: pendingMessage,
                      isMyMessage: true,
                    );
                  }

                  // 通常のメッセージを表示
                  final messageIndex = index - value.pendingMessages.length;
                  final message = value.messages[messageIndex];
                  final isMyMessage =
                      message.fromUserId ==
                      ref.read(accountContextProvider).getAccount.i.id;

                  final messageUser =
                      message.toUser ??
                      message.fromUser ??
                      ref.read(accountContextProvider).getAccount.i;

                  return ChatMessageItem(
                    message: message,
                    user: isMyMessage ? null : messageUser,
                    isMyMessage: isMyMessage,
                  );
                },
              ),
            ),
          ),
          RoomChatTextField(roomId: roomId),
        ],
      ),
    };
  }
}

final roomChatFocusNodeProvider = ChangeNotifierProvider<FocusNode>((ref) {
  return FocusNode();
});

class RoomChatTextField extends HookConsumerWidget {
  final String roomId;
  const RoomChatTextField({required this.roomId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditingController = useTextEditingController();
    final focusNode = ref.watch(roomChatFocusNodeProvider);
    final sendMessageMutation = ref.watch(sendRoomChatMessageMutation);

    void sendMessage() {
      final text = textEditingController.text.trim();
      if (text.isEmpty) return;

      final tempId = const Uuid().v4();
      final pendingMessage = PendingChatMessage(
        tempId: tempId,
        text: text,
        createdAt: DateTime.now(),
      );

      // 送信中メッセージをUIに追加
      ref.read(roomChatProvider(roomId).notifier).addPendingMessage(pendingMessage);
      
      // テキストフィールドをクリア
      textEditingController.clear();

      // 実際の送信処理
      sendRoomChatMessageMutation.run(ref, (ref) async {
        try {
          await ref
              .get(misskeyPostContextProvider)
              .chat
              .messages
              .createToRoom(
                ChatMessagesCreateToRoomRequest(toRoomId: roomId, text: text),
              );

          // 送信成功時、送信中メッセージを削除
          ref.get(roomChatProvider(roomId).notifier).removePendingMessage(tempId);
        } catch (e) {
          // 送信失敗時、テキストを復元し送信中メッセージを削除
          textEditingController.text = text;
          ref.get(roomChatProvider(roomId).notifier).removePendingMessage(tempId);
          rethrow;
        }
      });
    }

    return Column(
      children: [
        InputComplement(
          controller: textEditingController,
          focusNode: roomChatFocusNodeProvider,
        ),
        Row(
          children: [
            Expanded(
              child: Focus(
                onKeyEvent: (node, event) {
                  if (event is KeyDownEvent) {
                    if (event.logicalKey == LogicalKeyboardKey.enter &&
                        HardwareKeyboard.instance.isControlPressed) {
                      sendMessage();
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
            IconButton(
              onPressed: sendMessageMutation is MutationPending ? null : sendMessage,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ],
    );
  }
}
