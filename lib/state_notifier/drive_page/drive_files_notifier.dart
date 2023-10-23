import "dart:async";
import "dart:typed_data";

import "package:miria/model/pagination_state.dart";
import "package:miria/providers.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "drive_files_notifier.g.dart";

@Riverpod(dependencies: [misskeyPostContext])
class DriveFilesNotifier extends _$DriveFilesNotifier {
  @override
  Future<PaginationState<DriveFile>> build(String? folderId) async {
    final link = ref.keepAlive();
    Timer? timer;
    ref
      ..onCancel(() => timer = Timer(const Duration(minutes: 1), link.close))
      ..onResume(() => timer?.cancel())
      ..onDispose(() => timer?.cancel());
    try {
      final response = await _fetchFiles();
      return PaginationState.fromIterable(response);
    } catch (_) {
      timer?.cancel();
      link.close();
      rethrow;
    }
  }

  Misskey get _misskey => ref.read(misskeyPostContextProvider);

  Future<Iterable<DriveFile>> _fetchFiles({String? untilId}) async {
    return _misskey.drive.files.files(
      DriveFilesRequest(folderId: folderId, untilId: untilId),
    );
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
      final response = await _fetchFiles(untilId: value.items.lastOrNull?.id);
      return PaginationState(
        items: [...value.items, ...response],
        isLastLoaded: response.isEmpty,
      );
    });
  }

  Future<void> uploadBinary(
    Uint8List data, {
    String? name,
    String? comment,
    bool? isSensitive,
  }) async {
    final response = await _misskey.drive.files.createAsBinary(
      DriveFilesCreateRequest(
        folderId: folderId,
        name: name,
        comment: comment,
        isSensitive: isSensitive,
      ),
      data,
    );
    final value = state.value ?? const PaginationState();
    state = AsyncValue.data(value.copyWith(items: [response, ...value.items]));
  }

  Future<void> delete(String fileId) async {
    await _misskey.drive.files.delete(DriveFilesDeleteRequest(fileId: fileId));
    final value = state.value ?? const PaginationState();
    state = AsyncValue.data(
      value.copyWith(
        items: value.items.where((file) => file.id != fileId).toList(),
      ),
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
    final value = state.value ?? const PaginationState();
    state = AsyncValue.data(
      value.copyWith(
        items: value.items
            .map((file) => file.id == fileId ? response : file)
            .toList(),
      ),
    );
  }
}
