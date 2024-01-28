import 'dart:async';
import 'dart:typed_data';

import 'package:file/file.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/pagination_state.dart';
import 'package:miria/providers.dart';
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

  Future<void> upload(File file) async {
    final response = await _misskey.drive.files.create(
      DriveFilesCreateRequest(
        folderId: _folderId,
        name: file.basename,
      ),
      file,
    );
    _state = _state.copyWith(items: [response, ..._state]);
  }

  Future<void> uploadAsBinary(
    Uint8List data, {
    String? name,
    String? comment,
    bool? isSensitive,
  }) async {
    final response = await _misskey.drive.files.createAsBinary(
      DriveFilesCreateRequest(
        folderId: _folderId,
        name: name,
        comment: comment,
        isSensitive: isSensitive,
      ),
      data,
    );
    _state = _state.copyWith(items: [response, ..._state]);
  }

  Future<void> delete(String fileId) async {
    await _misskey.drive.files.delete(DriveFilesDeleteRequest(fileId: fileId));
    _state = _state.copyWith(
      items: _state.where((file) => file.id != fileId).toList(),
    );
  }

  Future<void> updateFile({
    required String fileId,
    String? name,
    bool? isSensitive,
    String? comment,
  }) async {
    final response = await _misskey.drive.files.update(
      DriveFilesUpdateRequest(
        fileId: fileId,
        name: name,
        isSensitive: isSensitive,
        comment: comment,
      ),
    );
    _state = _state.copyWith(
      items: _state.map((file) => file.id == fileId ? response : file).toList(),
    );
  }

  Future<void> move({
    required String fileId,
    required String? folderId,
  }) async {
    if (folderId == _folderId) {
      return;
    }
    // folderIdがnullのときキーが削除されるのを回避
    final response = await _misskey.apiService.post<Map<String, dynamic>>(
      "drive/files/update",
      {
        "fileId": fileId,
        "folderId": folderId,
      },
      excludeRemoveNullPredicate: (key, _) => key == "folderId",
    );
    final file = DriveFile.fromJson(response);
    _state = _state.copyWith(
      items: _state.where((file) => file.id != fileId).toList(),
    );
    ref
        .read(driveFilesNotifierProvider((_misskey, folderId)).notifier)
        .add(file);
  }

  void add(DriveFile file) {
    _state = _state.copyWith(items: [file, ..._state]);
  }
}
