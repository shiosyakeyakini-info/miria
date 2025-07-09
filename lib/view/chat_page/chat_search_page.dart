import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/repository/chat_search_repository.dart";
import "package:miria/view/chat_page/chat_message_item.dart";
import "package:miria/view/common/account_scope.dart";
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
    final isSearching = useState(false);
    final searchResults = useState<List<ChatMessage>>([]);
    final hasMore = useState(true);
    final isRoom = chatId.startsWith("room:");

    useEffect(() {
      searchController.text = query;
      if (query.isNotEmpty) {
        _performSearch(
          ref,
          currentQuery,
          isSearching,
          searchResults,
          hasMore,
          isRoom,
        );
      }
      return null;
    }, [query]);

    return Scaffold(
      appBar: AppBar(
        title: const Text("チャット検索"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "メッセージを検索...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: isSearching.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          searchResults.value = [];
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
                  searchResults.value = [];
                  _performSearch(
                    ref,
                    currentQuery,
                    isSearching,
                    searchResults,
                    hasMore,
                    isRoom,
                  );
                }
              },
            ),
          ),
        ),
      ),
      body: currentQuery.value.isEmpty
          ? const Center(child: Text("検索キーワードを入力してください"))
          : isSearching.value && searchResults.value.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : searchResults.value.isEmpty
          ? const Center(child: Text("該当するメッセージが見つかりませんでした"))
          : ListView.builder(
              itemCount: searchResults.value.length + (hasMore.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == searchResults.value.length) {
                  if (hasMore.value) {
                    // Load more
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!isSearching.value) {
                        _loadMore(
                          ref,
                          currentQuery,
                          isSearching,
                          searchResults,
                          hasMore,
                          isRoom,
                        );
                      }
                    });
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }

                final message = searchResults.value[index];
                final isMyMessage = message.fromUserId == account.i.id;
                return ChatMessageItem(
                  message: message,
                  user: isMyMessage ? null : message.fromUser,
                  isMyMessage: isMyMessage,
                );
              },
            ),
    );
  }

  Future<void> _performSearch(
    WidgetRef ref,
    ValueNotifier<String> currentQuery,
    ValueNotifier<bool> isSearching,
    ValueNotifier<List<ChatMessage>> searchResults,
    ValueNotifier<bool> hasMore,
    bool isRoom,
  ) async {
    if (currentQuery.value.isEmpty) return;

    isSearching.value = true;

    try {
      final repository = ref.read(chatSearchRepositoryProvider.notifier);

      List<ChatMessage> newResults;
      if (isChannel) {
        // チャンネルの場合は通常のNoteとして処理される
        // 実際の実装では notes/search API を使用する
        newResults = [];
      } else if (isRoom) {
        newResults = await repository.searchRoomChatMessages(
          roomId: chatId,
          query: currentQuery.value,
          limit: 20,
        );
      } else {
        newResults = await repository.searchUserChatMessages(
          userId: chatId,
          query: currentQuery.value,
          limit: 20,
        );
      }

      searchResults.value = newResults;
      hasMore.value = newResults.length == 20;
    } catch (e) {
      searchResults.value = [];
      hasMore.value = false;
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> _loadMore(
    WidgetRef ref,
    ValueNotifier<String> currentQuery,
    ValueNotifier<bool> isSearching,
    ValueNotifier<List<ChatMessage>> searchResults,
    ValueNotifier<bool> hasMore,
    bool isRoom,
  ) async {
    if (currentQuery.value.isEmpty || isSearching.value) return;

    isSearching.value = true;

    try {
      final repository = ref.read(chatSearchRepositoryProvider.notifier);
      final lastMessage = searchResults.value.isNotEmpty
          ? searchResults.value.last
          : null;

      List<ChatMessage> newResults;
      if (isChannel) {
        // チャンネルの場合は通常のNoteとして処理される
        newResults = [];
      } else if (isRoom) {
        newResults = await repository.searchRoomChatMessages(
          roomId: chatId,
          query: currentQuery.value,
          limit: 20,
        );
      } else {
        newResults = await repository.searchUserChatMessages(
          userId: chatId,
          query: currentQuery.value,
          limit: 20,
        );
      }

      if (newResults.isNotEmpty) {
        searchResults.value = [...searchResults.value, ...newResults];
        hasMore.value = newResults.length == 20;
      } else {
        hasMore.value = false;
      }
    } catch (e) {
      hasMore.value = false;
    } finally {
      isSearching.value = false;
    }
  }
}
