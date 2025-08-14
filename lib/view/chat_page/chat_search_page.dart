import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/repository/chat_search_repository.dart";
import "package:miria/view/chat_page/chat_message_item.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class ChatSearchPage extends HookConsumerWidget implements AutoRouteWrapper {
  const ChatSearchPage({
    required this.account,
    required this.chatId,
    required this.isChannel,
    required this.query,
    super.key,
  });

  final Account account;
  final String chatId;
  final bool isChannel;
  final String query;

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final currentQuery = useState(query);
    final isRoom = chatId.startsWith("room:");

    useEffect(() {
      searchController.text = query;
      if (query.isNotEmpty) {
        currentQuery.value = query;
      }
      return null;
    }, [query]);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).chatSearch),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: S.of(context).search,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    currentQuery.value = "";
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  currentQuery.value = value.trim();
                }
              },
            ),
          ),
        ),
      ),
      body: currentQuery.value.isEmpty
          ? Center(child: Text(S.of(context).pleaseInput))
          : PushableListView<ChatMessage>(
              listKey: "${currentQuery.value}_${chatId}_$isChannel",
              initializeFuture: () =>
                  _performInitialSearch(ref, currentQuery.value, isRoom),
              nextFuture: (lastMessage, currentCount) => _loadMoreResults(
                ref,
                currentQuery.value,
                lastMessage,
                isRoom,
              ),
              itemBuilder: (context, message) {
                final isMyMessage = message.fromUserId == account.i.id;
                return ChatMessageItem(
                  message: message,
                  user: isMyMessage ? null : message.fromUser,
                  isMyMessage: isMyMessage,
                  userId: isRoom ? null : chatId,
                  roomId: isRoom ? chatId : null,
                );
              },
              showAd: false,
              hideIsEmpty: false,
            ),
    );
  }

  Future<List<ChatMessage>> _performInitialSearch(
    WidgetRef ref,
    String query,
    bool isRoom,
  ) async {
    if (query.isEmpty) return [];

    try {
      final repository = ref.read(chatSearchRepositoryProvider.notifier);

      List<ChatMessage> results;
      if (isChannel) {
        // チャンネルの場合は通常のNoteとして処理される
        // 実際の実装では notes/search API を使用する
        results = [];
      } else if (isRoom) {
        results = await repository.searchRoomChatMessages(
          roomId: chatId,
          query: query,
          limit: 20,
        );
      } else {
        results = await repository.searchUserChatMessages(
          userId: chatId,
          query: query,
          limit: 20,
        );
      }

      return results;
    } catch (e) {
      return [];
    }
  }

  Future<List<ChatMessage>> _loadMoreResults(
    WidgetRef ref,
    String query,
    ChatMessage lastMessage,
    bool isRoom,
  ) async {
    // NOTE: Misskey APIのchat/messages/searchエンドポイントはuntilIdパラメータを
    // サポートしていないため、ページネーション機能は利用できません。
    // 検索結果は初回のAPIコールで取得できる分（最大100件）のみ表示されます。
    return [];
  }
}
