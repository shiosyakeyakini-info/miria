import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/repository/tab_settings_repository.dart';
import 'package:flutter_misskey_app/repository/time_line_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class NoteRefreshService {
  final T Function<T>(ProviderListenable<T> provider) reader;
  final List<ChangeNotifierProvider<TimeLineRepository>> targetProviders = [];

  NoteRefreshService(this.reader);

  Future<void> refresh(String noteId) async {
    final note = await reader(misskeyProvider)
        .notes
        .show(NotesShowRequest(noteId: noteId));
    refreshFromNote(note);
  }

  Future<void> refreshFromNote(Note note) async {
    for (final tab in reader(tabSettingsRepositoryProvider).tabSettings) {
      reader(tab.tabType.timelineProvider(tab)).updateNote(note);
    }
  }
}
