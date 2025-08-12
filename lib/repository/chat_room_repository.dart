import "package:miria/providers.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "chat_room_repository.g.dart";

@Riverpod(dependencies: [misskeyPostContext])
class ChatRoomRepository extends _$ChatRoomRepository {
  @override
  void build() {}

  /// 新しいチャットルームを作成する
  Future<ChatRoom> createRoom({
    required String name,
    String? description,
  }) async {
    // バリデーション
    if (name.trim().isEmpty) {
      throw ArgumentError("ルーム名は必須です");
    }
    if (name.trim().length > 100) {
      throw ArgumentError("ルーム名は100文字以内で入力してください");
    }
    if (description != null && description.trim().length > 500) {
      throw ArgumentError("ルーム説明は500文字以内で入力してください");
    }

    final room = await ref
        .read(misskeyPostContextProvider)
        .chat
        .rooms
        .create(
          ChatRoomsCreateRequest(
            name: name.trim(),
            description: description?.trim().isEmpty == true
                ? null
                : description?.trim(),
          ),
        );

    return room;
  }

  /// ルームの情報を更新する（既存機能の拡張として将来実装予定）
  Future<ChatRoom> updateRoom({
    required String roomId,
    String? name,
    String? description,
  }) async {
    return await ref
        .read(misskeyPostContextProvider)
        .chat
        .rooms
        .update(
          ChatRoomsUpdateRequest(
            roomId: roomId,
            name: name?.trim(),
            description: description?.trim().isEmpty == true
                ? null
                : description?.trim(),
          ),
        );
  }

  /// ルームを削除する（将来実装予定）
  Future<void> deleteRoom({required String roomId}) async {
    await ref
        .read(misskeyPostContextProvider)
        .chat
        .rooms
        .delete(ChatRoomsDeleteRequest(roomId: roomId));
  }

  /// ルームに参加する
  Future<void> joinRoom({required String roomId}) async {
    await ref
        .read(misskeyPostContextProvider)
        .chat
        .rooms
        .join(ChatRoomsJoinRequest(roomId: roomId));
  }

  /// ルームから退出する
  Future<void> leaveRoom({required String roomId}) async {
    await ref
        .read(misskeyPostContextProvider)
        .chat
        .rooms
        .leave(ChatRoomsLeaveRequest(roomId: roomId));
  }

  /// ユーザーをルームに招待する
  Future<void> inviteUser({
    required String roomId,
    required String userId,
  }) async {
    await ref
        .read(misskeyPostContextProvider)
        .chat
        .rooms
        .invitations
        .create(
          ChatRoomsInvitationsCreateRequest(roomId: roomId, userId: userId),
        );
  }
}
