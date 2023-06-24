import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file/file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/image_file.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/dialogs/simple_message_dialog.dart';
import 'package:miria/view/note_create_page/drive_file_select_dialog.dart';
import 'package:miria/view/note_create_page/drive_modal_sheet.dart';
import 'package:misskey_dart/misskey_dart.dart';

part 'note_create_state_notifier.freezed.dart';

@freezed
class NoteCreate with _$NoteCreate {
  const factory NoteCreate({
    required Account account,
    required NoteVisibility noteVisibility,
    required bool localOnly,
    @Default([]) List<MisskeyPostFile> files,
    NoteCreateChannel? channel,
    Note? reply,
    Note? renote,
    required ReactionAcceptance? reactionAcceptance,
    @Default(false) bool isCw,
    @Default("") String cwText,
    @Default("") String text,
    @Default(false) bool isTextFocused,
    @Default(false) bool isNoteSending,
  }) = _NoteCreate;
}

@freezed
class NoteCreateChannel with _$NoteCreateChannel {
  const factory NoteCreateChannel({
    required String id,
    required String name,
  }) = _NoteCreateChannel;
}

class NoteCreateNotifier extends StateNotifier<NoteCreate> {
  FileSystem fileSystem;
  Dio dio;
  Misskey misskey;
  StateNotifier<(Object? error, BuildContext? context)> errorNotifier;

  NoteCreateNotifier(
    super.state,
    this.fileSystem,
    this.dio,
    this.misskey,
    this.errorNotifier,
  );

  /// 初期化する
  Future<void> initialize(
    CommunityChannel? channel,
    String? initialText,
    List<String>? initialMediaFiles,
    Note? deletedNote,
    Note? renote,
    Note? reply,
  ) async {
    var resultState = state;

    final NoteCreateChannel? channelData;
    if (channel != null) {
      channelData = NoteCreateChannel(id: channel.id, name: channel.name);
    } else if (reply?.channel != null) {
      channelData =
          NoteCreateChannel(id: reply!.channel!.id, name: reply.channel!.name);
    } else {
      channelData = null;
    }

    resultState = resultState.copyWith(channel: channelData);

    // 共有からの反映
    if (initialText != null) {
      resultState = resultState.copyWith(text: initialText);
    }
    if (initialMediaFiles != null && initialMediaFiles.isNotEmpty == true) {
      resultState = resultState.copyWith(files: [
        for (final media in initialMediaFiles)
          if (media.toLowerCase().endsWith("jpg") ||
              media.toLowerCase().endsWith("png") ||
              media.toLowerCase().endsWith("gif") ||
              media.toLowerCase().endsWith("webp"))
            ImageFile(
                data: await fileSystem.file(media).readAsBytes(),
                fileName: media.substring(
                    media.lastIndexOf(Platform.pathSeparator) + 1,
                    media.length))
          else
            UnknownFile(
                data: await fileSystem.file(media).readAsBytes(),
                fileName: media.substring(
                    media.lastIndexOf(Platform.pathSeparator) + 1,
                    media.length))
      ]);
    }

    // 削除されたノートの反映
    if (deletedNote != null) {
      final files = <MisskeyPostFile>[];
      for (final file in deletedNote.files) {
        if (file.type.startsWith("image")) {
          final response = await dio.get(file.url,
              options: Options(responseType: ResponseType.bytes));
          files.add(ImageFileAlreadyPostedFile(
              fileName: file.name, data: response.data, id: file.id));
        } else {
          files.add(UnknownAlreadyPostedFile(
              url: file.url, id: file.id, fileName: file.name));
        }
      }
      final deletedNoteChannel = deletedNote.channel;

      resultState = resultState.copyWith(
        noteVisibility: deletedNote.visibility,
        localOnly: deletedNote.localOnly,
        files: files,
        channel: deletedNoteChannel != null
            ? NoteCreateChannel(
                id: deletedNoteChannel.id, name: deletedNoteChannel.name)
            : null,
        cwText: deletedNote.cw ?? "",
        isCw: deletedNote.cw?.isNotEmpty == true,
        text: deletedNote.text ?? "",
        reactionAcceptance: deletedNote.reactionAcceptance,
      );
      state = resultState;
      return;
    }

    if (renote != null) {
      resultState = resultState.copyWith(
          renote: renote,
          noteVisibility: NoteVisibility.min(
              resultState.noteVisibility, renote.visibility));
    }

    if (reply != null) {
      resultState = resultState.copyWith(
          reply: reply,
          noteVisibility:
              NoteVisibility.min(resultState.noteVisibility, reply.visibility),
          cwText: reply.cw ?? "",
          isCw: reply.cw?.isNotEmpty == true);
    }

    // チャンネルのノートか、リプライまたはリノートが連合オフ、デフォルトで連合オフの場合、
    // 返信やRenoteも強制連合オフ
    if (channel != null ||
        reply?.localOnly == true ||
        renote?.localOnly == true) {
      resultState = resultState.copyWith(localOnly: true);
    }

    // サイレンスの場合、ホーム以下に強制
    final isSilenced = state.account.i.isSilenced;
    if (isSilenced == true) {
      resultState = resultState.copyWith(
          noteVisibility: NoteVisibility.min(
              resultState.noteVisibility, NoteVisibility.home));
    }

    state = resultState;
  }

  /// ノートを投稿する
  Future<void> note() async {
    if (state.text.isEmpty && state.files.isEmpty) {
      throw SpecifiedException("なんか入れてや");
    }

    try {
      state = state.copyWith(isNoteSending: true);

      final fileIds = <String>[];

      for (final file in state.files) {
        switch (file) {
          case ImageFile():
            final response = await misskey.drive.files.createAsBinary(
              DriveFilesCreateRequest(
                force: true,
                name: file.fileName,
              ),
              file.data,
            );
            fileIds.add(response.id);

            break;
          case UnknownFile():
            final response = await misskey.drive.files.createAsBinary(
              DriveFilesCreateRequest(
                force: true,
                name: file.fileName,
              ),
              file.data,
            );
            fileIds.add(response.id);

            break;
          case UnknownAlreadyPostedFile():
            fileIds.add(file.id);
            break;
          case ImageFileAlreadyPostedFile():
            fileIds.add(file.id);
            break;
        }
      }

      if (!mounted) return;

      await misskey.notes.create(NotesCreateRequest(
        visibility: state.noteVisibility,
        text: state.text,
        cw: state.isCw ? state.cwText : null,
        localOnly: state.localOnly,
        replyId: state.reply?.id,
        renoteId: state.renote?.id,
        channelId: state.channel?.id,
        fileIds: fileIds.isEmpty ? null : fileIds,
        reactionAcceptance: state.reactionAcceptance,
      ));
      if (!mounted) return;
      state = state.copyWith(isNoteSending: false);
    } catch (e) {
      state = state.copyWith(isNoteSending: false);
      rethrow;
    }
  }

  /// メディアを選択する
  Future<void> chooseFile(BuildContext context) async {
    final result = await showModalBottomSheet<DriveModalSheetReturnValue?>(
        context: context, builder: (context) => const DriveModalSheet());

    if (result == DriveModalSheetReturnValue.drive) {
      if (!mounted) return;
      final result = await showDialog<DriveFile?>(
          context: context,
          builder: (context) => DriveFileSelectDialog(account: state.account));
      if (result == null) return;
      if (result.type.startsWith("image")) {
        final fileContentResponse = await dio.get(result.url,
            options: Options(responseType: ResponseType.bytes));

        state = state.copyWith(files: [
          ...state.files,
          ImageFileAlreadyPostedFile(
            data: fileContentResponse.data,
            fileName: result.name,
            id: result.id,
          )
        ]);
      } else {
        state = state.copyWith(files: [
          ...state.files,
          UnknownAlreadyPostedFile(
              url: result.url, id: result.id, fileName: result.name)
        ]);
      }
    } else if (result == DriveModalSheetReturnValue.upload) {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result == null) return;

      final path = result.files.single.path;
      if (path == null) return;
      if (!mounted) return;
      state = state.copyWith(files: [
        ...state.files,
        ImageFile(
            data: await fileSystem.file(path).readAsBytes(),
            fileName: path.substring(
                path.lastIndexOf(Platform.pathSeparator) + 1, path.length))
      ]);
    }
  }

  /// CWの表示を入れ替える
  void toggleCw() {
    state = state.copyWith(isCw: !state.isCw);
  }

  bool validateNoteVisibility(NoteVisibility visibility, BuildContext context) {
    final replyVisibility = state.reply?.visibility;
    if (replyVisibility == NoteVisibility.specified ||
        replyVisibility == NoteVisibility.followers ||
        replyVisibility == NoteVisibility.home) {
      SimpleMessageDialog.show(
          context, "リプライが${replyVisibility!.displayName}やから、パブリックにでけへん");
      return false;
    }
    if (state.account.i.isSilenced == true) {
      SimpleMessageDialog.show(context, "サイレンスロールになっているため、パブリックで投稿することはできません。");
      return false;
    }
    return true;
  }

  /// ノートの公開範囲を設定する
  void setNoteVisibility(NoteVisibility visibility) {
    state = state.copyWith(noteVisibility: visibility);
  }

  /// ノートの連合オン・オフを設定する
  void toggleLocalOnly(BuildContext context) {
    // チャンネルのノートは強制ローカルから変えられない
    if (state.channel != null) {
      errorNotifier.state =
          (SpecifiedException("チャンネルのノートを連合にすることはでけへんねん。"), context);
      return;
    }
    if (state.reply?.localOnly == true) {
      errorNotifier.state = (
        SpecifiedException("リプライの元ノートが連合なしに設定されとるから、このノートも連合なしにしかでけへんねん。"),
        context
      );
      return;
    }
    if (state.renote?.localOnly == true) {
      errorNotifier.state = (
        SpecifiedException("リノートしようとしてるノートが連合なしに設定されとるから、このノートも連合なしにしかでけへんねん。"),
        context
      );
      return;
    }
    state = state.copyWith(localOnly: !state.localOnly);
  }

  /// リアクションの受け入れを設定する
  void setReactionAcceptance(ReactionAcceptance? reactionAcceptance) {
    state = state.copyWith(reactionAcceptance: reactionAcceptance);
  }

  /// 注釈のテキストを設定する
  void setCwText(String text) {
    state = state.copyWith(cwText: text);
  }

  /// 本文を設定する
  void setContentText(String text) {
    state = state.copyWith(text: text);
  }

  /// 本文へのフォーカスを設定する
  void setContentTextFocused(bool isFocus) {
    state = state.copyWith(isTextFocused: isFocus);
  }
}
