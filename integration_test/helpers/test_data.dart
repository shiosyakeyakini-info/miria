import "package:misskey_dart/misskey_dart.dart";

import "misskey_setup.dart";

/// テストデータの投入
class TestData {
  final MisskeyTestSetup setup;

  TestData(this.setup);

  String? noteId;
  String? cwNoteId;
  String? replyNoteId;
  String? hashtagNoteId;
  String? antennaId;
  String? clipId;
  String? clipNoteId;
  String? listId;
  String? channelId;
  String? favoriteNoteId;

  /// 全テストデータを投入（エラーがあっても続行）
  Future<void> seed() async {
    try {
      await seedNotes();
    } catch (_) {}
    try {
      await seedAntenna();
    } catch (_) {}
    try {
      await seedClip();
    } catch (_) {}
    try {
      await seedList();
    } catch (_) {}
    try {
      await seedChannel();
    } catch (_) {}
    try {
      await seedFavorite();
    } catch (_) {}
    try {
      await seedFollowRelationship();
    } catch (_) {}
    try {
      await seedAnnouncement();
    } catch (_) {}
  }

  /// ノートを作成
  Future<void> seedNotes() async {
    // 通常ノート
    await setup.adminClient.notes.create(
      NotesCreateRequest(text: "管理者のテストノート"),
    );

    await setup.userClient.notes.create(
      NotesCreateRequest(text: "テストユーザーのノート1"),
    );

    // IDを取得するためタイムラインから取得
    final timeline = await setup.userClient.notes.localTimeline(
      const NotesLocalTimelineRequest(limit: 10),
    );
    if (timeline.isNotEmpty) {
      noteId = timeline.first.id;
    }

    // CW付きノート
    await setup.userClient.notes.create(
      NotesCreateRequest(text: "CW本文テスト", cw: "CW警告テスト"),
    );
    final cwTimeline = await setup.userClient.notes.localTimeline(
      const NotesLocalTimelineRequest(limit: 1),
    );
    if (cwTimeline.isNotEmpty) cwNoteId = cwTimeline.first.id;

    // リプライ
    if (noteId != null) {
      await setup.adminClient.notes.create(
        NotesCreateRequest(text: "リプライテスト", replyId: noteId),
      );
      final replyTimeline = await setup.adminClient.notes.localTimeline(
        const NotesLocalTimelineRequest(limit: 1),
      );
      if (replyTimeline.isNotEmpty) replyNoteId = replyTimeline.first.id;
    }

    // ハッシュタグ付きノート
    await setup.userClient.notes.create(
      NotesCreateRequest(text: "#テストタグ ハッシュタグ付きノート"),
    );
    final hashTimeline = await setup.userClient.notes.localTimeline(
      const NotesLocalTimelineRequest(limit: 1),
    );
    if (hashTimeline.isNotEmpty) hashtagNoteId = hashTimeline.first.id;
  }

  /// アンテナを作成
  Future<void> seedAntenna() async {
    final antenna = await setup.userClient.antennas.create(
      AntennasCreateRequest(
        name: "テストアンテナ",
        src: AntennaSource.all,
        keywords: [
          ["テスト"],
        ],
        excludeKeywords: [],
        users: [],
        notify: false,
        withReplies: true,
        withFile: false,
        caseSensitive: false,
        localOnly: false,
      ),
    );
    antennaId = antenna.id;
  }

  /// クリップを作成してノートを追加
  Future<void> seedClip() async {
    final clip = await setup.userClient.clips.create(
      ClipsCreateRequest(name: "テストクリップ"),
    );
    clipId = clip.id;

    if (noteId != null) {
      await setup.userClient.clips.addNote(
        ClipsAddNoteRequest(clipId: clip.id, noteId: noteId!),
      );
      clipNoteId = noteId;
    }
  }

  /// リストを作成してユーザーを追加
  Future<void> seedList() async {
    final list = await setup.userClient.users.list.create(
      UsersListsCreateRequest(name: "テストリスト"),
    );
    listId = list.id;

    await setup.userClient.users.list.push(
      UsersListsPushRequest(listId: list.id, userId: setup.adminId),
    );
  }

  /// チャンネルを作成
  Future<void> seedChannel() async {
    final channel = await setup.userClient.channels.create(
      ChannelsCreateRequest(name: "テストチャンネル"),
    );
    channelId = channel.id;
  }

  /// お気に入りを登録
  Future<void> seedFavorite() async {
    if (noteId == null) return;
    await setup.userClient.notes.favorites.create(
      NotesFavoritesCreateRequest(noteId: noteId!),
    );
    favoriteNoteId = noteId;
  }

  /// フォロー関係を作成
  Future<void> seedFollowRelationship() async {
    try {
      await setup.userClient.following.create(
        FollowingCreateRequest(userId: setup.adminId),
      );
      await setup.adminClient.following.create(
        FollowingCreateRequest(userId: setup.userId),
      );
    } catch (_) {
      // 既にフォロー済みの場合は無視
    }
  }

  /// お知らせを作成（admin APIをDioで直接呼ぶ）
  Future<void> seedAnnouncement() async {
    await setup.apiCall(
      "admin/announcements/create",
      token: setup.adminToken,
      body: {
        "title": "テストお知らせ",
        "text": "これはE2Eテスト用のお知らせです。",
        "imageUrl": null,
      },
    );
  }
}
