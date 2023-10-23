import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/pagination_state.dart';
import 'package:misskey_dart/misskey_dart.dart';

class DriveFoldersNotifier extends AutoDisposeFamilyAsyncNotifier<
    PaginationState<DriveFolder>, (Misskey, String?)> {
  @override
  Future<PaginationState<DriveFolder>> build((Misskey, String?) arg) async {
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
    final folders = await requestFolders();
    return PaginationState(
      items: folders,
      isLastLoaded: folders.isEmpty,
    );
  }

  Misskey get _misskey => arg.$1;

  String? get _folderId => arg.$2;

  PaginationState<DriveFolder> get _state =>
      state.valueOrNull ?? const PaginationState();

  set _state(PaginationState<DriveFolder> value) {
    state = AsyncValue.data(value);
  }

  Future<List<DriveFolder>> requestFolders({String? untilId}) async {
    final response = await _misskey.drive.folders.folders(
      DriveFoldersRequest(
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
      final folders = await requestFolders(untilId: untilId);
      _state = _state.copyWith(
        items: [..._state, ...folders],
        isLastLoaded: folders.isEmpty,
      );
    } finally {
      _state = _state.copyWith(isLoading: false);
    }
  }

  Future<void> create(String? name) async {
    final response = await _misskey.drive.folders.create(
      DriveFoldersCreateRequest(
        name: name,
        parentId: _folderId,
      ),
    );
    _state = _state.copyWith(items: [response, ..._state]);
  }

  Future<void> delete(String folderId) async {
    await _misskey.drive.folders
        .delete(DriveFoldersDeleteRequest(folderId: folderId));
    _state = _state.copyWith(
      items: _state.where((folder) => folder.id != folderId).toList(),
    );
  }

  Future<void> updateName(String folderId, String name) async {
    final response = await _misskey.drive.folders.update(
      DriveFoldersUpdateRequest(
        folderId: folderId,
        name: name,
      ),
    );
    _state = _state.copyWith(
      items: _state
          .map((folder) => folder.id == folderId ? response : folder)
          .toList(),
    );
  }
}
