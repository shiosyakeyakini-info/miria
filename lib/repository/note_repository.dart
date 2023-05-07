import 'package:flutter/foundation.dart';
import 'package:misskey_dart/misskey_dart.dart';

class NoteRepository extends ChangeNotifier {
  final Misskey misskey;
  final Map<String, Note> _notes = {};

  NoteRepository(this.misskey);

  Map<String, Note> get notes => _notes;

  void _registerNote(Note note) {
    _notes[note.id] = note;
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
    notifyListeners();
  }

  void registerAll(Iterable<Note> notes) {
    for (final element in notes) {
      _registerNote(element);
    }
    notifyListeners();
  }

  Future<void> refresh(String noteId) async {
    final note = await misskey.notes.show(NotesShowRequest(noteId: noteId));
    registerNote(note);
  }
}
