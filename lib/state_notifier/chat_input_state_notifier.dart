import "dart:typed_data";

import "package:dio/dio.dart";
import "package:file_picker/file_picker.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:image/image.dart" as img;
import "package:miria/model/image_file.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/note_create_page/drive_modal_sheet.dart";
import "package:miria/view/note_create_page/file_settings_dialog.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:path/path.dart" as p;
import "package:path_provider/path_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "chat_input_state_notifier.freezed.dart";
part "chat_input_state_notifier.g.dart";

@freezed
abstract class ChatInputState with _$ChatInputState {
  const factory ChatInputState({@Default([]) List<MisskeyPostFile> files}) =
      _ChatInputState;
}

@Riverpod(
  keepAlive: true,
  dependencies: [
    accountContext,
    misskeyPostContext,
    fileSystem,
    dio,
    appRouter,
  ],
)
class ChatInputStateNotifier extends _$ChatInputStateNotifier {
  @override
  ChatInputState build() => const ChatInputState();

  Future<void> addFile(MisskeyPostFile file) async {
    state = state.copyWith(files: [...state.files, file]);
  }

  void removeFile(int index) {
    if (index < 0 || index >= state.files.length) return;
    final newFiles = List<MisskeyPostFile>.from(state.files);
    newFiles.removeAt(index);
    state = state.copyWith(files: newFiles);
  }

  void clearFiles() {
    state = state.copyWith(files: []);
  }

  /// ファイルのメタデータを変更する
  ///
  /// ドライブから添付したファイルは `isEdited` を立てておき、送信時に
  /// `drive/files/update` を投げる。
  void setFileMetaData(int index, FileSettingsDialogResult result) {
    if (index < 0 || index >= state.files.length) return;
    final files = state.files.toList();
    final file = files[index];

    files[index] = switch (file) {
      ImageFile() => ImageFile(
        data: file.data,
        fileName: result.fileName,
        isNsfw: result.isNsfw,
        caption: result.caption,
      ),
      ImageFileAlreadyPostedFile() => ImageFileAlreadyPostedFile(
        data: file.data,
        id: file.id,
        fileName: result.fileName,
        isNsfw: result.isNsfw,
        caption: result.caption,
        isEdited: true,
      ),
      UnknownFile() => UnknownFile(
        data: file.data,
        fileName: result.fileName,
        isNsfw: result.isNsfw,
        caption: result.caption,
      ),
      UnknownAlreadyPostedFile() => UnknownAlreadyPostedFile(
        url: file.url,
        id: file.id,
        fileName: result.fileName,
        isNsfw: result.isNsfw,
        caption: result.caption,
        isEdited: true,
      ),
    };

    state = state.copyWith(files: files);
  }

  /// ドライブのファイル情報を更新する
  ///
  /// misskey_dartの`drive.files.update`はFreezedのtoJsonを経由するため
  /// undefinedとnullを区別できず、`comment: null`を渡すとキーごと削除される。
  /// 一方で説明が空のときに`comment: ''`を送ると、Misskey Webが
  /// ALTテキストとしてファイル名を表示しなくなってしまう。
  /// そのためapiServiceを直接呼び、commentについてはnullをそのまま送る。
  Future<void> _updateDriveFile({
    required String fileId,
    required String name,
    required bool isSensitive,
    required String? comment,
  }) async {
    await ref
        .read(misskeyPostContextProvider)
        .apiService
        .post<Map<String, dynamic>>(
          "drive/files/update",
          DriveFilesUpdateRequest(
            fileId: fileId,
            name: name,
            isSensitive: isSensitive,
            comment: comment,
          ).toJson(),
          excludeRemoveNullPredicate: (key, _) => key == "comment",
        );
  }

  Future<void> chooseFile() async {
    final router = ref.read(appRouterProvider);

    // ドライブかアップロードかを選択するモーダルを表示
    final modalResult = await router.push<DriveModalSheetReturnValue>(
      const DriveModalRoute(),
    );

    if (modalResult == DriveModalSheetReturnValue.drive) {
      // ドライブから選択
      final driveFiles = await router.push<List<DriveFile>>(
        DriveFileSelectRoute(
          account: ref.read(accountContextProvider).postAccount,
          allowMultiple: false,
        ),
      );

      if (driveFiles == null || driveFiles.isEmpty) return;

      final driveFile = driveFiles.first;
      final dio = ref.read(dioProvider);

      if (driveFile.type.startsWith("image")) {
        final fileContentResponse = await dio.get<Uint8List>(
          driveFile.url,
          options: Options(responseType: ResponseType.bytes),
        );
        await addFile(
          ImageFileAlreadyPostedFile(
            data: fileContentResponse.data!,
            id: driveFile.id,
            fileName: driveFile.name,
            isNsfw: driveFile.isSensitive,
            caption: driveFile.comment,
          ),
        );
      } else {
        await addFile(
          UnknownAlreadyPostedFile(
            url: driveFile.url,
            id: driveFile.id,
            fileName: driveFile.name,
            isNsfw: driveFile.isSensitive,
            caption: driveFile.comment,
          ),
        );
      }
    } else if (modalResult == DriveModalSheetReturnValue.upload) {
      // ファイルアップロード（既存の処理）
      final fileSystem = ref.read(fileSystemProvider);

      final result = await FilePicker.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ["jpg", "jpeg", "png", "gif", "mp4", "webm"],
      );

      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      if (file.path == null) return;

      if (file.extension?.toLowerCase() == "heic") {
        final bytes = await fileSystem.file(file.path).readAsBytes();
        final image = img.decodeImage(bytes);
        if (image == null) return;

        final jpeg = img.encodeJpg(image);
        final directory = await getTemporaryDirectory();
        final path = p.join(
          directory.path,
          "${DateTime.now().millisecondsSinceEpoch}.jpg",
        );
        final jpegFile = await fileSystem.file(path).writeAsBytes(jpeg);

        await addFile(
          ImageFile(
            data: Uint8List.fromList(jpeg),
            fileName: p.basename(jpegFile.path),
          ),
        );
      } else if ([
        "jpg",
        "jpeg",
        "png",
        "gif",
      ].contains(file.extension?.toLowerCase())) {
        final bytes = await fileSystem.file(file.path).readAsBytes();
        await addFile(ImageFile(data: bytes, fileName: file.name));
      } else {
        final bytes = await fileSystem.file(file.path).readAsBytes();
        await addFile(UnknownFile(data: bytes, fileName: file.name));
      }
    }
  }

  Future<String?> uploadAndGetFileId() async {
    if (state.files.isEmpty) return null;

    final file = state.files.first;
    final misskey = ref.read(misskeyPostContextProvider);

    DriveFile? uploadedFile;

    switch (file) {
      case ImageFile():
        uploadedFile = await misskey.drive.files.createAsBinary(
          DriveFilesCreateRequest(
            name: file.fileName,
            isSensitive: file.isNsfw,
            comment: file.caption,
          ),
          file.data,
        );
      case ImageFileAlreadyPostedFile():
        if (file.isEdited) {
          await _updateDriveFile(
            fileId: file.id,
            name: file.fileName,
            isSensitive: file.isNsfw,
            comment: file.caption,
          );
        }
        clearFiles();
        return file.id;
      case UnknownFile():
        uploadedFile = await misskey.drive.files.createAsBinary(
          DriveFilesCreateRequest(
            name: file.fileName,
            isSensitive: file.isNsfw,
            comment: file.caption,
          ),
          file.data,
        );
      case UnknownAlreadyPostedFile():
        if (file.isEdited) {
          await _updateDriveFile(
            fileId: file.id,
            name: file.fileName,
            isSensitive: file.isNsfw,
            comment: file.caption,
          );
        }
        clearFiles();
        return file.id;
    }

    clearFiles();
    return uploadedFile.id;
  }
}
