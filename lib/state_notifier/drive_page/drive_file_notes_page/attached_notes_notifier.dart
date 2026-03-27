import "package:miria/model/pagination_state.dart";
import "package:miria/providers.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "attached_notes_notifier.g.dart";

@Riverpod(dependencies: [misskeyPostContext, notesWith])
class AttachedNotesNotifier extends _$AttachedNotesNotifier {
  @override
  FutureOr<PaginationState<Note>> build(String fileId) async {
    final response = await _fetchNotes();
    return PaginationState.fromIterable(response);
  }

  Future<Iterable<Note>> _fetchNotes({String? untilId}) async {
    final notes = await ref
        .read(misskeyPostContextProvider)
        .drive
        .files
        .attachedNotes(
          DriveFilesAttachedNotesRequest(fileId: fileId, untilId: untilId),
        );
    ref.read(notesWithProvider).registerAll(notes);
    return notes;
  }

  Future<void> loadMore({bool skipError = false}) async {
    if (state.isLoading || (state.hasError && !skipError)) {
      return;
    }
    final value = skipError ? state.value! : await future;
    if (value.isLastLoaded) {
      return;
    }
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final response = await _fetchNotes(untilId: value.items.lastOrNull?.id);
      if (response.any((note) => note.id == value.items.firstOrNull?.id)) {
        // Misskey 2023.10.0 より前はpaginationがなかったため
        return value.copyWith(isLastLoaded: true);
      } else {
        return PaginationState(
          items: [...value.items, ...response],
          isLastLoaded: response.isEmpty,
        );
      }
    });
  }
}
