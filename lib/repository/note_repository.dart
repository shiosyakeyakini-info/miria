import "package:flutter/foundation.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:miria/extensions/note_extension.dart";
import "package:miria/log.dart";
import "package:miria/model/account.dart";
import "package:misskey_dart/misskey_dart.dart";

part "note_repository.freezed.dart";

@freezed
abstract class NoteStatus with _$NoteStatus {
  const factory NoteStatus({
    required bool isCwOpened,
    required bool isLongVisible,
    required bool isReactionedRenote,
    required bool isLongVisibleInitialized,
    required bool isIncludeMuteWord,
    required bool isMuteOpened,
    required bool isPollResultOpened,
  }) = _NoteStatus;
}

class NoteRepository extends ChangeNotifier {
  final Misskey misskey;
  final Account account;
  final Map<String, Note> _notes = {};
  final Map<String, NoteStatus> _noteStatuses = {};

  final List<List<String>> softMuteWordContents = [];
  final List<RegExp> softMuteWordRegExps = [];

  final List<List<String>> hardMuteWordContents = [];
  final List<RegExp> hardMuteWordRegExps = [];

  NoteRepository(this.misskey, this.account) {
    updateMute(account.i.mutedWords, account.i.hardMutedWords);
  }

  void updateMute(List<MuteWord> softMuteWords, List<MuteWord> hardMuteWords) {
    for (final muteWord in softMuteWords) {
      final content = muteWord.content;
      final regExp = muteWord.regExp;
      if (content != null) {
        softMuteWordContents.add(content);
      }
      if (regExp != null) {
        final regExpAndFlags = RegExp(r"^\/(.+)\/(.*)$").firstMatch(regExp);
        if (regExpAndFlags != null) {
          try {
            final flags = regExpAndFlags[2] ?? "";
            softMuteWordRegExps.add(
              RegExp(
                regExpAndFlags[1]!,
                multiLine: flags.contains("m"),
                caseSensitive: !flags.contains("i"),
                unicode: flags.contains("u"),
                dotAll: flags.contains("s"),
              ),
            );
          } catch (e) {
            logger.warning(e);
          }
        }
      }
    }

    for (final muteWord in hardMuteWords) {
      final content = muteWord.content;
      final regExp = muteWord.regExp;
      if (content != null) {
        hardMuteWordContents.add(content);
      }
      if (regExp != null) {
        try {
          hardMuteWordRegExps.add(
            RegExp(regExp.substring(1, regExp.length - 1)),
          );
        } catch (e) {}
      }
    }
  }

  Map<String, Note> get notes => _notes;

  Map<String, NoteStatus> get noteStatuses => _noteStatuses;

  void updateNoteStatus(
    String id,
    NoteStatus Function(NoteStatus status) statusPredicate, {
    bool isNotify = true,
  }) {
    _noteStatuses[id] = statusPredicate.call(_noteStatuses[id]!);
    if (isNotify) notifyListeners();
  }

  void _registerNote(Note note) {
    bool isMuteTarget(Pattern target) {
      if (note.isEmptyRenote) {
        return note.renote?.text?.contains(target) == true ||
            note.renote?.cw?.contains(target) == true;
      } else {
        return note.text?.contains(target) == true ||
            note.cw?.contains(target) == true;
      }
    }

    if ((note.user.host != null || note.user.id != account.i.id) &&
            hardMuteWordContents.any((e) => e.every(isMuteTarget)) ||
        hardMuteWordRegExps.any(isMuteTarget)) {
      return;
    }

    final registeredNote = _notes[note.id];
    _notes[note.id] = note.copyWith(
      renote: note.renote ?? _notes[note.renoteId],
      reply: note.reply ?? _notes[note.replyId],
      poll: note.poll ?? registeredNote?.poll,
      myReaction: note.myReaction?.isEmpty == true
          ? null
          : (note.myReaction ??
                (note.reactions.isNotEmpty
                    ? registeredNote?.myReaction
                    : null)),
    );
    _noteStatuses[note.id] ??= NoteStatus(
      isCwOpened: false,
      isLongVisible: false,
      isReactionedRenote: false,
      isLongVisibleInitialized: false,
      isIncludeMuteWord:
          (note.user.host != null || note.user.id != account.i.id) &&
              softMuteWordContents.any((e) => e.every(isMuteTarget)) ||
          softMuteWordRegExps.any(isMuteTarget),
      isMuteOpened: false,
      isPollResultOpened: _getInitialPollResultState(note),
    );
    final renote = note.renote;
    final reply = note.reply;
    if (renote != null) {
      _registerNote(renote);
    }
    if (reply != null) {
      _registerNote(reply);
    }
  }

  void registerNote(Note note) {
    _registerNote(note);
    Future(() {
      notifyListeners();
    });
  }

  void registerAll(Iterable<Note> notes) {
    for (final element in notes) {
      _registerNote(element);
    }
    Future(() {
      notifyListeners();
    });
  }

  Future<void> refresh(String noteId) async {
    final note = await misskey.notes.show(NotesShowRequest(noteId: noteId));
    registerNote(note.copyWith(myReaction: note.myReaction ?? ""));
  }

  void delete(String noteId) {
    _notes.remove(noteId);
    Future(() {
      notifyListeners();
    });
  }

  /// 投票結果表示状態の初期値を決定
  /// 元のロジック: !isAnyVotable(ref) と同等の判定
  bool _getInitialPollResultState(Note note) {
    final poll = note.poll;
    if (poll == null) return false;
    
    // 期限切れの場合は表示
    final expiresAt = poll.expiresAt;
    if (expiresAt != null && expiresAt.isBefore(DateTime.now())) {
      return true;
    }
    
    // 既に投票済みの場合は表示
    if (poll.choices.any((choice) => choice.isVoted)) {
      return true;
    }
    
    // 投票可能な場合は非表示（元のロジック通り）
    // isAnyVotableがtrueの場合、!isAnyVotableはfalseになる
    return false;
  }

  /// 投票結果表示状態を切り替え
  void togglePollResult(String noteId) {
    final status = _noteStatuses[noteId];
    if (status != null) {
      _noteStatuses[noteId] = status.copyWith(
        isPollResultOpened: !status.isPollResultOpened,
      );
      notifyListeners();
    }
  }

  /// 投票結果表示状態を設定
  void setPollResultOpened(String noteId, bool isOpened) {
    final status = _noteStatuses[noteId];
    if (status != null) {
      _noteStatuses[noteId] = status.copyWith(
        isPollResultOpened: isOpened,
      );
      notifyListeners();
    }
  }

  /// 投票結果表示状態を取得
  bool getPollResultOpened(String noteId) {
    return _noteStatuses[noteId]?.isPollResultOpened ?? false;
  }
}
