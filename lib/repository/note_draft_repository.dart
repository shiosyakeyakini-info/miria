import "package:miria/providers.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "note_draft_repository.g.dart";

@Riverpod(dependencies: [misskeyPostContext])
class NoteDraftRepository extends _$NoteDraftRepository {
  late final Misskey _misskey = ref.read(misskeyPostContextProvider);
  final Map<String, NoteDraft> _drafts = {};

  @override
  Map<String, NoteDraft> build() {
    return _drafts;
  }

  Map<String, NoteDraft> get drafts => state;

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

    final response = await _misskey.notes.drafts.create(request);
    final draft = response.createdDraft;

    _drafts[draft.id] = draft;
    state = Map.from(_drafts);
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

    final drafts = await _misskey.notes.drafts.list(request);
    for (final draft in drafts) {
      _drafts[draft.id] = draft;
    }
    state = Map.from(_drafts);
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

    final response = await _misskey.notes.drafts.update(request);
    final draft = response.updatedDraft;

    _drafts[draft.id] = draft;
    state = Map.from(_drafts);
    return draft;
  }

  /// 下書きを削除
  Future<void> delete(String draftId) async {
    final request = NotesDraftsDeleteRequest(draftId: draftId);
    await _misskey.notes.drafts.delete(request);
    _drafts.remove(draftId);
    state = Map.from(_drafts);
  }

  /// 下書き数を取得
  Future<int> count() async {
    return await _misskey.notes.drafts.count();
  }

  /// 特定の下書きを取得
  NoteDraft? getDraft(String draftId) => _drafts[draftId];

  /// ローカルキャッシュから下書きを登録
  void registerDraft(NoteDraft draft) {
    _drafts[draft.id] = draft;
    state = Map.from(_drafts);
  }

  /// ローカルキャッシュから複数の下書きを登録
  void registerDrafts(Iterable<NoteDraft> drafts) {
    for (final draft in drafts) {
      _drafts[draft.id] = draft;
    }
    state = Map.from(_drafts);
  }
}
