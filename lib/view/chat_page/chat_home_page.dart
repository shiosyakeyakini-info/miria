import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:mfm/mfm.dart";
import "package:miria/providers.dart";
import "package:miria/view/chat_page/chat_content.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/error_detail.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part 'chat_home_page.g.dart';

@RoutePage()
class ChatHomePage extends ConsumerWidget implements AutoRouteWrapper {
  final AccountContext accountContext;
  final String channelId;

  const ChatHomePage({
    required this.accountContext,
    required this.channelId,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(child: Text("ホーム")),
              Tab(child: Text("招待")),
              Tab(child: Text("入ってるルーム")),
              Tab(child: Text("自分で作ったやつ"))
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ChatHome(),
            InvitedChat(),
            JoiningChat(),
            OwnedChat(),
          ],
        ),
        floatingActionButton:
            ref.read(accountContextProvider).isSame ? null : null,
      ),
    );
  }
}

@Riverpod(dependencies: [misskeyPostContext])
Future<List<ChatMessage>> history(HistoryRef ref) async {
  final (a, b) = await (
    ref
        .read(misskeyPostContextProvider)
        .chat
        .history(const ChatHistoryRequest(limit: 30, room: false)),
    ref
        .read(misskeyPostContextProvider)
        .chat
        .history(const ChatHistoryRequest(limit: 30, room: true))
  ).wait;

  return [...a, ...b]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
}

class ChatHome extends ConsumerWidget {
  const ChatHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);

    return switch (history) {
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
      AsyncError(:final error, :final stackTrace) =>
        ErrorDetail(error: error, stackTrace: stackTrace),
      AsyncData(:final value) => Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) => ChatContent(message: value[index]),
          ),
        ),
    };
  }
}

class InvitedChat extends ConsumerWidget {
  const InvitedChat({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Text("Invited Chat"),
    );
  }
}

class JoiningChat extends ConsumerWidget {
  const JoiningChat({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Text("Joining Chat"),
    );
  }
}

class OwnedChat extends ConsumerWidget {
  const OwnedChat({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Text("Owned Chat"),
    );
  }
}
