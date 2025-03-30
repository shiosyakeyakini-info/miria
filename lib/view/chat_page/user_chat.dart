import "dart:async";

import "package:auto_route/auto_route.dart";
import "package:bubble/bubble.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/date_time_extension.dart";
import "package:miria/hooks/use_async.dart";
import "package:miria/providers.dart";
import "package:miria/repository/socket_timeline_repository.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/avatar_icon.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/common/error_detail.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:miria/view/common/note_create/input_completation.dart";
import "package:miria/view/themes/app_theme.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:uuid/uuid.dart";

part "user_chat.g.dart";

@Riverpod(keepAlive: true, dependencies: [misskeyGetContext])
class UserChat extends _$UserChat {
  @override
  Future<List<ChatMessage>> build(String userId) async {
    return [
      ...await ref.read(misskeyGetContextProvider).chat.messages.userTimeline(
            ChatMessagesUserTimelineRequest(userId: userId),
          ),
    ];
  }

  void addChat(ChatMessage message) {
    if (state is! AsyncData) return;
    state = AsyncData([message, ...state.value ?? []]);
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
      body: Center(
        child: UserChatTimeline(user: user),
      ),
    );
  }
}

class UserChatTimeline extends HookConsumerWidget {
  final User user;
  const UserChatTimeline({
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userChat = ref.watch(userChatProvider(user.id));
    final streamingId = useMemoized(() => const Uuid().v4());

    useEffect(
      () {
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
            if (body is! ChatMessageChannelEvent) return;
            final innerBody = body.body;
            ref.read(userChatProvider(user.id).notifier).addChat(innerBody);
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
      },
      const [],
    );
    return switch (userChat) {
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
      AsyncError(:final error, :final stackTrace) =>
        ErrorDetail(error: error, stackTrace: stackTrace),
      AsyncData(:final value) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: value.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final message = value[index];

                  if (message.fromUserId ==
                      ref.read(accountContextProvider).getAccount.i.id) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0, bottom: 16.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Column(
                          children: [
                            Bubble(
                              nip: BubbleNip.rightBottom,
                              color: AppTheme.of(context).colorTheme.primary,
                              child: MfmText(mfmText: message.text ?? ""),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              message.createdAt.differenceNow(context),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Row(
                    children: [
                      AvatarIcon(user: user),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Bubble(
                              color: AppTheme.of(context).colorTheme.background,
                              nip: BubbleNip.leftTop,
                              child: MfmText(mfmText: message.text ?? ""),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              message.createdAt.differenceNow(context),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
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

class UserChatTextField extends HookConsumerWidget {
  final String userId;
  const UserChatTextField({
    required this.userId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditingController = useTextEditingController();
    final focusNode = useFocusNode();

    final chat = useAsync(
      () async {
        final text = textEditingController.text;
        textEditingController.clear();
        await ref.read(dialogStateNotifierProvider.notifier).guard(
          () async {
            try {
              await ref
                  .read(misskeyPostContextProvider)
                  .chat
                  .messages
                  .createToUser(
                    ChatMessagesCreateToUserRequest(
                      toUserId: userId,
                      text: text,
                    ),
                  );
            } catch (e) {
              textEditingController.text = text;
              rethrow;
            }
          },
        );
      },
    );

    return Column(
      children: [
        InputComplement(
          controller: textEditingController,
          focusNode: focusNode,
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
            IconButton(
              onPressed: chat.execute,
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
      ],
    );
  }
}
