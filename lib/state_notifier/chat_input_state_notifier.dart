import "dart:io";

import "package:file_picker/file_picker.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:image/image.dart" as img;
import "package:miria/model/misskey_post_file.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/note_create_page/drive_modal_sheet.dart";
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

  Future<void> chooseFile() async {
    final router = ref.read(appRouterProvider);

    // ドライブかアップロードかを選択するモーダルを表示
    final modalResult = await router.push<DriveModalSheetReturnValue>(
      DriveModalRoute(),
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

      await addFile(AlreadyPostedFile.file(driveFile));
    } else if (modalResult
        case DriveModalSheetReturnValue.uploadMedia ||
            DriveModalSheetReturnValue.uploadFile) {
      // ファイルアップロード（既存の処理）
      final fileSystem = ref.read(fileSystemProvider);

      final result = await FilePicker.platform.pickFiles(
        type: modalResult == DriveModalSheetReturnValue.uploadMedia
            ? FileType.media
            : FileType.any,
        allowMultiple: false,
        // iOSでは0の場合HEICファイルがJPEGに変換されないため
        // Androidでは圧縮時に画像の向きがおかしくなることがあるため圧縮パススルー
        compressionQuality: (Platform.isIOS) ? 95 : 0,
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

        await addFile(PostFile.file(jpegFile));
      } else {
        if (file.path case final path?) {
          await addFile(PostFile.file(fileSystem.file(path)));
        }
      }
    }
  }

  Future<String?> uploadAndGetFileId() async {
    if (state.files.isEmpty) return null;

    final file = state.files.first;
    final misskey = ref.read(misskeyPostContextProvider);

    switch (file) {
      case PostFile():
        final bytes = await file.file.readAsBytes();
        final uploadedFile = await misskey.drive.files.createAsBinary(
          DriveFilesCreateRequest(
            name: file.fileName,
            isSensitive: file.isNsfw,
            comment: file.caption,
          ),
          bytes,
        );
        clearFiles();
        return uploadedFile.id;
      case AlreadyPostedFile():
        clearFiles();
        return file.file.id;
    }
  }
}
