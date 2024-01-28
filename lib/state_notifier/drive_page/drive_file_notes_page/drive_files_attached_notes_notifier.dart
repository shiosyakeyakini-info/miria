import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/pagination_state.dart';
import 'package:misskey_dart/misskey_dart.dart';

class DriveFilesAttachedNotesNotifier extends AutoDisposeFamilyAsyncNotifier<
    PaginationState<Note>, (Misskey, String)> {
  @override
  Future<PaginationState<Note>> build((Misskey, String) arg) async {
    final notes = await requestNotes();
    return PaginationState(
      items: notes,
      isLastLoaded: notes.isEmpty,
    );
  }

  Misskey get _misskey => arg.$1;

  String get _fileId => arg.$2;

  PaginationState<Note> get _state =>
      state.valueOrNull ?? const PaginationState();

  set _state(PaginationState<Note> value) {
    state = AsyncValue.data(value);
  }

  Future<List<Note>> requestNotes({String? untilId}) async {
    final response = await _misskey.drive.files.attachedNotes(
      DriveFilesAttachedNotesRequest(
        fileId: _fileId,
        untilId: untilId,
      ),
    );
    return response.toList();
  }

  Future<void> loadMore() async {
    if (_state.isLoading || _state.isLastLoaded) {
      return;
    }
    _state = _state.copyWith(isLoading: true);
    final untilId = _state.lastOrNull?.id;
    try {
      final notes = await requestNotes(untilId: untilId);
      // Misskey 2023.10.0 より前はpaginationがなかったため
      if (notes.any((e) => e.id == _state.firstOrNull?.id)) {
        _state = _state.copyWith(isLastLoaded: true);
      } else {
        _state = _state.copyWith(
          items: [..._state, ...notes],
          isLastLoaded: notes.isEmpty,
        );
      }
    } finally {
      _state = _state.copyWith(isLoading: false);
    }
  }
}
