import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/pagination_state.dart';
import 'package:misskey_dart/misskey_dart.dart';

class DriveFilesNotifier extends AutoDisposeFamilyAsyncNotifier<
    PaginationState<DriveFile>, (Misskey, String?)> {
  @override
  Future<PaginationState<DriveFile>> build((Misskey, String?) arg) async {
    final link = ref.keepAlive();
    Timer? timer;
    ref.onCancel(() {
      timer = Timer(const Duration(minutes: 1), link.close);
    });
    ref.onResume(() {
      timer?.cancel();
    });
    ref.onDispose(() {
      timer?.cancel();
    });
    final files = await requestFiles();
    return PaginationState(
      items: files,
      isLastLoaded: files.isEmpty,
    );
  }

  Misskey get _misskey => arg.$1;

  String? get _folderId => arg.$2;

  PaginationState<DriveFile> get _state =>
      state.valueOrNull ?? const PaginationState();

  set _state(PaginationState<DriveFile> value) {
    state = AsyncValue.data(value);
  }

  Future<List<DriveFile>> requestFiles({String? untilId}) async {
    final response = await _misskey.drive.files.files(
      DriveFilesRequest(
        folderId: _folderId,
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
      final files = await requestFiles(untilId: untilId);
      _state = _state.copyWith(
        items: [..._state, ...files],
        isLastLoaded: files.isEmpty,
      );
    } finally {
      _state = _state.copyWith(isLoading: false);
    }
  }
}
