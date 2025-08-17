import "package:flutter/foundation.dart";
import "package:miria/model/account.dart";
import "package:misskey_dart/misskey_dart.dart";

class NoteDraftRepository extends ChangeNotifier {
  final Misskey misskey;
  final Account account;
  final Map<String, NoteDraft> _drafts = {};

  NoteDraftRepository(this.misskey, this.account);

  Map<String, NoteDraft> get drafts => _drafts;

  /// 下書きを作成
  Future<NoteDraft> create({
    String? text,
    String? cw,
    NoteVisibility? visibility,
    List<String>? visibleUserIds,
    bool? localOnly,
    ReactionAcceptance? reactionAcceptance,
    List<String>? fileIds,
    String? replyId,
    String? renoteId,
    String? channelId,
    NotesCreatePollRequest? poll,
  }) async {
    // デバッグ用：リクエストパラメータをログ出力
    print("DEBUG: NoteDraftRepository.create() called with:");
    print("  text: $text");
    print("  poll: $poll");
    if (poll != null) {
      print("    choices: ${poll.choices}");
      print("    multiple: ${poll.multiple}");
      print("    expiresAt: ${poll.expiresAt}");
      print("    expiredAfter: ${poll.expiredAfter}");
    }

    final request = NotesDraftsCreateRequest(
      text: text,
      cw: cw,
      visibility: visibility,
      visibleUserIds: visibleUserIds,
      localOnly: localOnly,
      reactionAcceptance: reactionAcceptance,
      fileIds: fileIds,
      replyId: replyId,
      renoteId: renoteId,
      channelId: channelId,
      poll: poll,
    );

    final response = await misskey.notes.drafts.create(request);
    final draft = response.createdDraft;
    
    // デバッグ用：レスポンスをログ出力
    print("DEBUG: Created draft response:");
    print("  draft.id: ${draft.id}");
    print("  draft.poll: ${draft.poll}");
    if (draft.poll != null) {
      print("    choices: ${draft.poll!.choices}");
      print("    multiple: ${draft.poll!.multiple}");
      print("    expiresAt: ${draft.poll!.expiresAt}");
      print("    expiredAfter: ${draft.poll!.expiredAfter}");
    }
    
    _drafts[draft.id] = draft;
    notifyListeners();
    return draft;
  }

  /// 下書き一覧を取得
  Future<List<NoteDraft>> list({
    int limit = 30,
    String? sinceId,
    String? untilId,
  }) async {
    final request = NotesDraftsListRequest(
      limit: limit,
      sinceId: sinceId,
      untilId: untilId,
    );

    final drafts = await misskey.notes.drafts.list(request);
    for (final draft in drafts) {
      _drafts[draft.id] = draft;
    }
    notifyListeners();
    return drafts.toList();
  }

  /// 下書きを更新
  Future<NoteDraft> update({
    required String draftId,
    String? text,
    String? cw,
    NoteVisibility? visibility,
    List<String>? visibleUserIds,
    bool? localOnly,
    ReactionAcceptance? reactionAcceptance,
    List<String>? fileIds,
    String? replyId,
    String? renoteId,
    String? channelId,
    NotesCreatePollRequest? poll,
  }) async {
    // デバッグ用：リクエストパラメータをログ出力
    print("DEBUG: NoteDraftRepository.update() called with:");
    print("  draftId: $draftId");
    print("  text: $text");
    print("  poll: $poll");
    if (poll != null) {
      print("    choices: ${poll.choices}");
      print("    multiple: ${poll.multiple}");
      print("    expiresAt: ${poll.expiresAt}");
      print("    expiredAfter: ${poll.expiredAfter}");
    }

    final request = NotesDraftsUpdateRequest(
      draftId: draftId,
      text: text,
      cw: cw,
      visibility: visibility,
      visibleUserIds: visibleUserIds,
      localOnly: localOnly,
      reactionAcceptance: reactionAcceptance,
      fileIds: fileIds,
      replyId: replyId,
      renoteId: renoteId,
      channelId: channelId,
      poll: poll,
    );

    final response = await misskey.notes.drafts.update(request);
    final draft = response.updatedDraft;
    
    // デバッグ用：レスポンスをログ出力
    print("DEBUG: Updated draft response:");
    print("  draft.id: ${draft.id}");
    print("  draft.poll: ${draft.poll}");
    if (draft.poll != null) {
      print("    choices: ${draft.poll!.choices}");
      print("    multiple: ${draft.poll!.multiple}");
      print("    expiresAt: ${draft.poll!.expiresAt}");
      print("    expiredAfter: ${draft.poll!.expiredAfter}");
    }
    
    _drafts[draft.id] = draft;
    notifyListeners();
    return draft;
  }

  /// 下書きを削除
  Future<void> delete(String draftId) async {
    final request = NotesDraftsDeleteRequest(draftId: draftId);
    await misskey.notes.drafts.delete(request);
    _drafts.remove(draftId);
    notifyListeners();
  }

  /// 下書き数を取得
  Future<int> count() async {
    return await misskey.notes.drafts.count();
  }

  /// 特定の下書きを取得
  NoteDraft? getDraft(String draftId) => _drafts[draftId];

  /// ローカルキャッシュから下書きを登録
  void registerDraft(NoteDraft draft) {
    _drafts[draft.id] = draft;
    notifyListeners();
  }

  /// ローカルキャッシュから複数の下書きを登録
  void registerDrafts(Iterable<NoteDraft> drafts) {
    for (final draft in drafts) {
      _drafts[draft.id] = draft;
    }
    notifyListeners();
  }
}
