import "package:flutter/foundation.dart";
import "package:miria/repository/note_repository.dart";
import "package:misskey_dart/misskey_dart.dart";

class FavoriteRepository extends ChangeNotifier {
  final Misskey misskey;
  final NoteRepository noteRepository;

  FavoriteRepository(this.misskey, this.noteRepository);

  List<Note> _notes = [];
  List<Note> get notes => _notes;

  Future<void> getFavorites() async {
    final response = await misskey.i.favorites(
      IFavoritesRequest(
        untilId: _notes.isEmpty ? null : _notes.last.id,
        limit: 50,
      ),
    );
    final responseNotes = response.map((e) => e.note);
    _notes = [..._notes, ...responseNotes];
    noteRepository.registerAll(responseNotes);

    notifyListeners();
  }
}
