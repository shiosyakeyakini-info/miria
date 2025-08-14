import "package:flutter/material.dart";
import "package:miria/providers.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "chat_search_repository.g.dart";

@Riverpod(dependencies: [misskeyGetContext])
class ChatSearchRepository extends _$ChatSearchRepository {
  @override
  Map<String, List<ChatMessage>> build() => {};

  Future<List<ChatMessage>> searchUserChatMessages({
    required String userId,
    required String query,
    int? limit,
    // NOTE: Misskey APIのchat/messages/searchはuntilIdをサポートしていないため、
    // ページネーション機能は現在利用できません
  }) async {
    try {
      final misskey = ref.read(misskeyGetContextProvider);
      final response = await misskey.chat.messages.search(
        ChatMessagesSearchRequest(
          query: query,
          userId: userId,
          limit: limit ?? 20,
        ),
      );

      return response.toList();
    } catch (e) {
      debugPrint("User chat search error: $e");
      return [];
    }
  }

  Future<List<ChatMessage>> searchRoomChatMessages({
    required String roomId,
    required String query,
    int? limit,
    // NOTE: Misskey APIのchat/messages/searchはuntilIdをサポートしていないため、
    // ページネーション機能は現在利用できません
  }) async {
    try {
      final misskey = ref.read(misskeyGetContextProvider);
      final response = await misskey.chat.messages.search(
        ChatMessagesSearchRequest(
          query: query,
          roomId: roomId,
          limit: limit ?? 20,
        ),
      );

      return response.toList();
    } catch (e) {
      debugPrint("Room chat search error: $e");
      return [];
    }
  }

  Future<List<Note>> searchChannelNotes({
    required String channelId,
    required String query,
    int? limit,
    // NOTE: Misskey APIのnotes/searchもuntilIdをサポートしていない可能性があります
  }) async {
    try {
      final misskey = ref.read(misskeyGetContextProvider);
      final response = await misskey.notes.search(
        NotesSearchRequest(
          query: query,
          channelId: channelId,
          limit: limit ?? 20,
        ),
      );

      return response.toList();
    } catch (e) {
      debugPrint("Channel notes search error: $e");
      return [];
    }
  }

  void cacheResults(String key, List<ChatMessage> messages) {
    final current = state;
    state = {...current, key: messages};
  }

  List<ChatMessage>? getCachedResults(String key) {
    return state[key];
  }

  void clearCache() {
    state = {};
  }
}

@riverpod
class ChatSearchPagination extends _$ChatSearchPagination {
  @override
  List<ChatMessage> build(String searchKey) => [];

  // NOTE: Misskey APIのchat/messages/searchはページネーションをサポートしていないため、
  // loadMoreメソッドは現在機能しません。APIがuntilIdパラメータをサポートするまで
  // ページネーション機能は無効化されています。
  Future<void> loadMore({
    required String chatId,
    required String query,
    required bool isChannel,
    required bool isRoom,
  }) async {
    // ページネーション機能は現在サポートされていません
    // Misskey APIがuntilIdパラメータをサポートした場合に実装予定
    return;
  }

  void reset() {
    state = [];
  }

  void setInitialResults(List<ChatMessage> results) {
    state = results;
  }
}
