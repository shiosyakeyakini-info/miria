import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:miria/extensions/note_extension.dart';
import 'package:miria/model/account.dart';
import 'package:misskey_dart/misskey_dart.dart';

part 'note_repository.freezed.dart';

@freezed
class NoteStatus with _$NoteStatus {
  const factory NoteStatus({
    required bool isCwOpened,
    required bool isLongVisible,
    required bool isReactionedRenote,
    required bool isLongVisibleInitialized,
    required bool isIncludeMuteWord,
    required bool isMuteOpened,
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
        try {
          softMuteWordRegExps
              .add(RegExp(regExp.substring(1, regExp.length - 1)));
        } catch (e) {}
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
          hardMuteWordRegExps
              .add(RegExp(regExp.substring(1, regExp.length - 1)));
        } catch (e) {}
      }
    }
  }

  Map<String, Note> get notes => _notes;

  Map<String, NoteStatus> get noteStatuses => _noteStatuses;

  void updateNoteStatus(
      String id, NoteStatus Function(NoteStatus status) statusPredicate,
      {bool isNotify = true}) {
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
              (note.reactions.isNotEmpty ? registeredNote?.myReaction : null)),
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
        isMuteOpened: false);
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
}
