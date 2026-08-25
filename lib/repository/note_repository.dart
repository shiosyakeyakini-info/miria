import "dart:async";
import "dart:convert";
import "package:collection/collection.dart";
import "package:flutter/foundation.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:miria/extensions/note_extension.dart";
import "package:miria/log.dart";
import "package:miria/model/account.dart";
import "package:miria/state_notifier/aiscript_plugin_notifier.dart";
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
  }) = _NoteStatus;
}

class NoteRepository extends ChangeNotifier {
  final Misskey misskey;
  final Account account;
  final Map<String, Note> _notes = {};
  final Map<String, NoteStatus> _noteStatuses = {};

  /// プラグインが登録した note_view_interruptor を引く。
  ///
  /// 押し込まれるのではなく、要るときに引きに行く。プラグインはノートより
  /// 後に立ち上がることがあり、購読で押し込む形だと取りこぼす。
  final List<PluginInterruptor> Function() _noteViewInterruptors;

  /// interruptor を通し終えたノート。二度通さないための覚え書き。
  final Set<String> _interrupted = {};

  /// 最後に見た interruptor の顔ぶれ。変わったら覚え書きを捨てる。
  List<PluginInterruptor> _lastInterruptors = const [];

  final List<List<String>> softMuteWordContents = [];
  final List<RegExp> softMuteWordRegExps = [];

  final List<List<String>> hardMuteWordContents = [];
  final List<RegExp> hardMuteWordRegExps = [];

  NoteRepository(
    this.misskey,
    this.account, {
    List<PluginInterruptor> Function()? noteViewInterruptors,
  }) : _noteViewInterruptors = noteViewInterruptors ?? _noInterruptors {
    updateMute(account.i.mutedWords, account.i.hardMutedWords);
  }

  static List<PluginInterruptor> _noInterruptors() => const [];

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
    _applyNoteViewInterruptors(note.id);
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

  /// note_view_interruptor をノートに通して、結果で置き換える。
  ///
  /// AiScript は Rust 側で動いていて同期には呼べないので、描画をせき止めず
  /// に後から差し替える。本家 Misskey は描画のたびに同期で通すが、そこは
  /// 揃えられない。代わりに一度通したノートは覚えておいて二度通さない。
  void _applyNoteViewInterruptors(String id) {
    final interruptors = _noteViewInterruptors();
    if (interruptors.isEmpty) return;
    // 顔ぶれが変わっていたら、通し直すために覚え書きを捨てる
    if (!identical(interruptors, _lastInterruptors) &&
        !const ListEquality<PluginInterruptor>().equals(
          interruptors,
          _lastInterruptors,
        )) {
      _lastInterruptors = interruptors;
      _interrupted.clear();
    }
    // 既に通したものはそのまま
    if (!_interrupted.add(id)) return;

    unawaited(
      Future(() async {
        final registered = _notes[id];
        if (registered == null) return;
        var note = registered;
        for (final interruptor in interruptors) {
          try {
            final result = await interruptor.callback.call(
              value: jsonEncode(note.toJson()),
            );
            final decoded = jsonDecode(result);
            if (decoded is Map<String, dynamic>) {
              note = Note.fromJson(decoded);
            }
          } catch (e) {
            // プラグインが変なものを返しても、もとのノートで表示を続ける
            logger.warning(e);
          }
        }
        // 通している間に消えていたら何もしない
        if (_notes.containsKey(id)) {
          _notes[id] = note;
          notifyListeners();
        }
      }),
    );
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
