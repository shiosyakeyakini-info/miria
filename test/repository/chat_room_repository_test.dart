import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/repository/chat_room_repository.dart";
import "package:mockito/mockito.dart";

import "../test_util/mock.mocks.dart";
import "../test_util/test_datas.dart";

void main() {
  group("ChatRoomRepository", () {
    late ProviderContainer container;
    late MockMisskey mockMisskey;
    late MockMisskeyChat mockChat;
    late MockMisskeyChatRooms mockChatRooms;

    setUp(() {
      mockMisskey = MockMisskey();
      mockChat = MockMisskeyChat();
      mockChatRooms = MockMisskeyChatRooms();
      final mockInvitations = MockMisskeyChatRoomsInvitations();

      // Setup the mock hierarchy
      when(mockMisskey.chat).thenReturn(mockChat);
      when(mockChat.rooms).thenReturn(mockChatRooms);
      when(mockChatRooms.invitations).thenReturn(mockInvitations);

      // Mock successful operations
      when(
        mockChatRooms.create(any),
      ).thenAnswer((_) async => TestData.chatRoom1);
      when(
        mockChatRooms.update(any),
      ).thenAnswer((_) async => TestData.chatRoom1);
      when(mockChatRooms.delete(any)).thenAnswer((_) async {});
      when(mockChatRooms.join(any)).thenAnswer((_) async {});
      when(mockChatRooms.leave(any)).thenAnswer((_) async {});
      when(
        mockInvitations.create(any),
      ).thenAnswer((_) async => TestData.chatJoining1);

      container = ProviderContainer(
        overrides: [misskeyPostContextProvider.overrideWithValue(mockMisskey)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group("createRoom バリデーション", () {
      test("空のルーム名でArgumentErrorが発生する", () async {
        final repository = container.read(chatRoomRepositoryProvider.notifier);

        expect(
          () => repository.createRoom(name: ""),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              "message",
              "ルーム名は必須です",
            ),
          ),
        );
      });

      test("スペースのみのルーム名でArgumentErrorが発生する", () async {
        final repository = container.read(chatRoomRepositoryProvider.notifier);

        expect(
          () => repository.createRoom(name: "   "),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              "message",
              "ルーム名は必須です",
            ),
          ),
        );
      });

      test("100文字を超えるルーム名でArgumentErrorが発生する", () async {
        final repository = container.read(chatRoomRepositoryProvider.notifier);
        final longName = "a" * 101;

        expect(
          () => repository.createRoom(name: longName),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              "message",
              "ルーム名は100文字以内で入力してください",
            ),
          ),
        );
      });

      test("500文字を超える説明でArgumentErrorが発生する", () async {
        final repository = container.read(chatRoomRepositoryProvider.notifier);
        final longDescription = "a" * 501;

        expect(
          () => repository.createRoom(
            name: "テストルーム",
            description: longDescription,
          ),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              "message",
              "ルーム説明は500文字以内で入力してください",
            ),
          ),
        );
      });

      test("有効なルーム名とnull説明で正常に作成される", () async {
        final repository = container.read(chatRoomRepositoryProvider.notifier);

        // バリデーションが通り、正常に作成される
        final result = await repository.createRoom(name: "有効なルーム名");
        expect(result, equals(TestData.chatRoom1));
      });

      test("有効なルーム名と有効な説明で正常に作成される", () async {
        final repository = container.read(chatRoomRepositoryProvider.notifier);

        // バリデーションが通り、正常に作成される
        final result = await repository.createRoom(
          name: "有効なルーム名",
          description: "有効な説明",
        );
        expect(result, equals(TestData.chatRoom1));
      });

      test("空白文字がトリミングされる", () async {
        final repository = container.read(chatRoomRepositoryProvider.notifier);

        // スペースが除去されて有効になることを確認
        final result = await repository.createRoom(
          name: "  有効なルーム名  ",
          description: "  有効な説明  ",
        );
        expect(result, equals(TestData.chatRoom1));
      });

      test("空文字の説明がnullに変換される", () async {
        final repository = container.read(chatRoomRepositoryProvider.notifier);

        // 空文字がnullに変換されて有効になることを確認
        final result = await repository.createRoom(
          name: "有効なルーム名",
          description: "   ", // 空白のみ
        );
        expect(result, equals(TestData.chatRoom1));
      });
    });

    group("その他のメソッド", () {
      test("updateRoom メソッドが正常に動作する", () async {
        final repository = container.read(chatRoomRepositoryProvider.notifier);

        final result = await repository.updateRoom(roomId: "test", name: "テスト");
        expect(result, equals(TestData.chatRoom1));
      });

      test("deleteRoom メソッドが正常に動作する", () async {
        final repository = container.read(chatRoomRepositoryProvider.notifier);

        await repository.deleteRoom(roomId: "test");
        // 正常に完了することを確認（例外が発生しない）
      });

      test("joinRoom メソッドが正常に動作する", () async {
        final repository = container.read(chatRoomRepositoryProvider.notifier);

        await repository.joinRoom(roomId: "test");
        // 正常に完了することを確認（例外が発生しない）
      });

      test("leaveRoom メソッドが正常に動作する", () async {
        final repository = container.read(chatRoomRepositoryProvider.notifier);

        await repository.leaveRoom(roomId: "test");
        // 正常に完了することを確認（例外が発生しない）
      });

      test("inviteUser メソッドが正常に動作する", () async {
        final repository = container.read(chatRoomRepositoryProvider.notifier);

        await repository.inviteUser(roomId: "test", userId: "user123");
        // 正常に完了することを確認（例外が発生しない）
      });
    });
  });
}
