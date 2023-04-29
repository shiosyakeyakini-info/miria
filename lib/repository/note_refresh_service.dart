import 'package:collection/collection.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class NoteRefreshService {
  final T Function<T>(ProviderListenable<T> provider) reader;

  NoteRefreshService(this.reader);

  Future<void> refresh(String noteId) async {
    final note = await reader(misskeyProvider)
        .notes
        .show(NotesShowRequest(noteId: noteId));
    refreshFromNote(note);
  }

  Future<void> refreshFromNote(Note note) async {
    for (final provider in [
      globalTimeLineProvider,
      homeTimeLineProvider,
      localTimeLineProvider
    ]) {
      reader(provider).updateNote(note);
    }
  }
}
