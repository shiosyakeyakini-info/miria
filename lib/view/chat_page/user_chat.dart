import "dart:async";

import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:hooks_riverpod/legacy.dart";
import "package:miria/hooks/use_async.dart";
import "package:miria/providers.dart";
import "package:miria/repository/socket_timeline_repository.dart";
import "package:miria/view/chat_page/chat_message_item.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/common/error_detail.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:miria/view/common/note_create/input_completation.dart";
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
class UserChatPage extends ConsumerWidget implements AutoRouteWrapper {
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
    return Scaffold(
      appBar: AppBar(
        title: SimpleMfmText("${user.name ?? user.username}とのチャット"),
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

final userChatFocusNodeProvider = ChangeNotifierProvider.autoDispose((ref) {
  final focusNode = FocusNode();
  ref.onDispose(focusNode.dispose);
  return focusNode;
});

class UserChatTextField extends HookConsumerWidget {
  final String userId;
  const UserChatTextField({required this.userId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditingController = useTextEditingController();
    final focusNode = useFocusNode();

    final chat = useAsync(() async {
      final text = textEditingController.text;
      textEditingController.clear();
      await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
        try {
          await ref
              .read(misskeyPostContextProvider)
              .chat
              .messages
              .createToUser(
                ChatMessagesCreateToUserRequest(toUserId: userId, text: text),
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
        Row(
          children: [
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
