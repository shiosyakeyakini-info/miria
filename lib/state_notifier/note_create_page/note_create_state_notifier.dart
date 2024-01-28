import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file/file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mfm_parser/mfm_parser.dart';
import 'package:miria/extensions/note_visibility_extension.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/image_file.dart';
import 'package:miria/repository/note_repository.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/dialogs/simple_confirm_dialog.dart';
import 'package:miria/view/dialogs/simple_message_dialog.dart';
import 'package:miria/view/note_create_page/drive_file_select_dialog.dart';
import 'package:miria/view/note_create_page/drive_modal_sheet.dart';
import 'package:miria/view/note_create_page/file_settings_dialog.dart';
import 'package:miria/view/note_create_page/note_create_page.dart';
import 'package:miria/view/user_select_dialog.dart';
import 'package:misskey_dart/misskey_dart.dart';

part 'note_create_state_notifier.freezed.dart';

enum NoteSendStatus { sending, finished, error }

enum VoteExpireType {
  unlimited,
  date,
  duration;

  String displayText(BuildContext context) {
    return switch (this) {
      VoteExpireType.unlimited => S.of(context).unlimited,
      VoteExpireType.date => S.of(context).specifyByDate,
      VoteExpireType.duration => S.of(context).specifyByDuration,
    };
  }
}

enum VoteExpireDurationType {
  seconds,
  minutes,
  hours,
  day;

  String displayText(BuildContext context) {
    return switch (this) {
      VoteExpireDurationType.seconds => S.of(context).seconds,
      VoteExpireDurationType.minutes => S.of(context).minutes,
      VoteExpireDurationType.hours => S.of(context).hours,
      VoteExpireDurationType.day => S.of(context).days,
    };
  }
}

sealed class NoteCreateException implements Exception {}

class EmptyNoteException implements NoteCreateException {}

class TooFewVoteChoiceException implements NoteCreateException {}

class EmptyVoteExpireDateException implements NoteCreateException {}

class EmptyVoteExpireDurationException implements NoteCreateException {}

class MentionToRemoteInLocalOnlyNoteException implements NoteCreateException {}

@freezed
class NoteCreate with _$NoteCreate {
  const factory NoteCreate({
    required Account account,
    required NoteVisibility noteVisibility,
    required bool localOnly,
    @Default([]) List<User> replyTo,
    @Default([]) List<MisskeyPostFile> files,
    NoteCreateChannel? channel,
    Note? reply,
    Note? renote,
    required ReactionAcceptance? reactionAcceptance,
    @Default(false) bool isCw,
    @Default("") String cwText,
    @Default("") String text,
    @Default(false) bool isTextFocused,
    NoteSendStatus? isNoteSending,
    @Default(false) bool isVote,
    @Default(["", ""]) List<String> voteContent,
    @Default(2) int voteContentCount,
    @Default(VoteExpireType.unlimited) VoteExpireType voteExpireType,
    @Default(false) bool isVoteMultiple,
    DateTime? voteDate,
    int? voteDuration,
    @Default(VoteExpireDurationType.seconds)
    VoteExpireDurationType voteDurationType,
    NoteCreationMode? noteCreationMode,
    String? noteId,
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
  NoteRepository noteRepository;
  StateNotifier<(Object? error, BuildContext? context)> errorNotifier;

  NoteCreateNotifier(
    super.state,
    this.fileSystem,
    this.dio,
    this.misskey,
    this.errorNotifier,
    this.noteRepository,
  );

  /// 初期化する
  Future<void> initialize(
    CommunityChannel? channel,
    String? initialText,
    List<String>? initialMediaFiles,
    Note? note,
    Note? renote,
    Note? reply,
    NoteCreationMode? noteCreationMode,
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
      resultState = resultState.copyWith(
        files: await Future.wait(
          initialMediaFiles.map((media) async {
            final file = fileSystem.file(media);
            final contents = await file.readAsBytes();
            final fileName = file.basename;
            final extension = fileName.split(".").last.toLowerCase();
            if (["jpg", "png", "gif", "webp"].contains(extension)) {
              return ImageFile(
                data: contents,
                fileName: fileName,
              );
            } else {
              return UnknownFile(
                data: contents,
                fileName: fileName,
              );
            }
          }),
        ),
      );
    }

    // 削除されたノートの反映
    if (note != null) {
      final files = <MisskeyPostFile>[];
      for (final file in note.files) {
        if (file.type.startsWith("image")) {
          final response = await dio.get(file.url,
              options: Options(responseType: ResponseType.bytes));
          files.add(
            ImageFileAlreadyPostedFile(
              fileName: file.name,
              data: response.data,
              id: file.id,
              isNsfw: file.isSensitive,
              caption: file.comment,
            ),
          );
        } else {
          files.add(
            UnknownAlreadyPostedFile(
              url: file.url,
              id: file.id,
              fileName: file.name,
              isNsfw: file.isSensitive,
              caption: file.comment,
            ),
          );
        }
      }
      final deletedNoteChannel = note.channel;

      final replyTo = <User>[];
      if (note.mentions.isNotEmpty) {
        replyTo.addAll(
          await misskey.users
              .showByIds(UsersShowByIdsRequest(userIds: note.mentions)),
        );
      }

      resultState = resultState.copyWith(
        noteVisibility: note.visibility,
        localOnly: note.localOnly,
        files: files,
        channel: deletedNoteChannel != null
            ? NoteCreateChannel(
                id: deletedNoteChannel.id, name: deletedNoteChannel.name)
            : null,
        cwText: note.cw ?? "",
        isCw: note.cw?.isNotEmpty == true,
        text: note.text ?? "",
        reactionAcceptance: note.reactionAcceptance,
        replyTo: replyTo.toList(),
        isVote: note.poll != null,
        isVoteMultiple: note.poll?.multiple ?? false,
        voteExpireType: note.poll?.expiresAt == null
            ? VoteExpireType.unlimited
            : VoteExpireType.date,
        voteContentCount: note.poll?.choices.map((e) => e.text).length ?? 2,
        voteContent: note.poll?.choices.map((e) => e.text).toList() ?? [],
        voteDate: note.poll?.expiresAt,
        noteCreationMode: noteCreationMode,
        noteId: note.id,
        renote: note.renote,
        reply: note.reply,
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
      final replyTo = <User>[];
      if (reply.mentions.isNotEmpty) {
        replyTo.addAll(
          await misskey.users
              .showByIds(UsersShowByIdsRequest(userIds: reply.mentions)),
        );
      }

      resultState = resultState.copyWith(
        reply: reply,
        noteVisibility:
            NoteVisibility.min(resultState.noteVisibility, reply.visibility),
        cwText: reply.cw ?? "",
        isCw: reply.cw?.isNotEmpty == true,
        replyTo: [
          reply.user,
          ...replyTo,
        ]..removeWhere((element) => element.id == state.account.i.id),
      );
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
  Future<void> note(BuildContext context) async {
    if (state.text.isEmpty && state.files.isEmpty && !state.isVote) {
      throw EmptyNoteException();
    }

    if (state.isVote &&
        state.voteContent.where((e) => e.isNotEmpty).length < 2) {
      throw TooFewVoteChoiceException();
    }

    if (state.isVote &&
        state.voteExpireType == VoteExpireType.date &&
        state.voteDate == null) {
      throw EmptyVoteExpireDateException();
    }

    if (state.isVote &&
        state.voteExpireType == VoteExpireType.duration &&
        state.voteDuration == null) {
      throw EmptyVoteExpireDurationException();
    }

    try {
      state = state.copyWith(isNoteSending: NoteSendStatus.sending);

      final fileIds = <String>[];

      for (final file in state.files) {
        DriveFile? response;

        switch (file) {
          case ImageFile():
            final fileName = file.fileName.toLowerCase();
            var imageData = file.data;
            try {
              if (fileName.endsWith("jpg") ||
                  fileName.endsWith("jpeg") ||
                  fileName.endsWith("tiff") ||
                  fileName.endsWith("tif")) {
                imageData =
                    await FlutterImageCompress.compressWithList(file.data);
              }
            } catch (e) {
              print("failed to compress file");
            }

            response = await misskey.drive.files.createAsBinary(
              DriveFilesCreateRequest(
                force: true,
                name: file.fileName,
                isSensitive: file.isNsfw,
                comment: file.caption,
              ),
              imageData,
            );
            fileIds.add(response.id);

            break;
          case UnknownFile():
            response = await misskey.drive.files.createAsBinary(
              DriveFilesCreateRequest(
                force: true,
                name: file.fileName,
                isSensitive: file.isNsfw,
                comment: file.caption,
              ),
              file.data,
            );
            fileIds.add(response.id);

            break;
          case UnknownAlreadyPostedFile():
            if (file.isEdited) {
              await misskey.drive.files.update(DriveFilesUpdateRequest(
                fileId: file.id,
                name: file.fileName,
                isSensitive: file.isNsfw,
                comment: file.caption,
              ));
            }
            fileIds.add(file.id);
            break;
          case ImageFileAlreadyPostedFile():
            if (file.isEdited) {
              response =
                  await misskey.drive.files.update(DriveFilesUpdateRequest(
                fileId: file.id,
                name: file.fileName,
                isSensitive: file.isNsfw,
                comment: file.caption,
              ));
            }

            fileIds.add(file.id);
            break;
        }

        if (response?.isSensitive == true &&
            !file.isNsfw &&
            !state.account.i.alwaysMarkNsfw) {
          if (context.mounted) {
            final confirmResult = await SimpleConfirmDialog.show(
              context: context,
              message: S.of(context).unexpectedSensitive,
              primary: S.of(context).staySensitive,
              secondary: S.of(context).unsetSensitive,
            );
            if (confirmResult == false) {
              await misskey.drive.files.update(
                DriveFilesUpdateRequest(
                  fileId: fileIds.last,
                  isSensitive: false,
                ),
              );
            }
          }
        }
      }

      if (!mounted) return;

      final nodes = const MfmParser().parse(state.text);
      final userList = <MfmMention>[];

      void findMfmMentions(List<MfmNode> nodes) {
        for (final node in nodes) {
          if (node is MfmMention) {
            userList.add(node);
          }
          findMfmMentions(node.children ?? []);
        }
      }

      findMfmMentions(nodes);

      // 連合オフなのに他のサーバーの人がメンションに含まれている
      if (state.localOnly &&
          userList.any((element) =>
              element.host != null &&
              element.host != misskey.apiService.host)) {
        throw MentionToRemoteInLocalOnlyNoteException();
      }

      final mentionTargetUsers = [
        for (final user in userList)
          await misskey.users.showByName(UsersShowByUserNameRequest(
              userName: user.username, host: user.host))
      ];
      final visibleUserIds = state.replyTo.map((e) => e.id).toList();
      visibleUserIds.addAll(mentionTargetUsers.map((e) => e.id));

      final baseText =
          "${state.replyTo.map((e) => "@${e.username}${e.host == null ? " " : "@${e.host} "}").join("")}${state.text}";
      final postText = baseText.isNotEmpty ? baseText : null;

      final durationType = state.voteDurationType;
      final voteDuration = Duration(
        days: durationType == VoteExpireDurationType.day
            ? state.voteDuration ?? 0
            : 0,
        hours: durationType == VoteExpireDurationType.hours
            ? state.voteDuration ?? 0
            : 0,
        minutes: durationType == VoteExpireDurationType.minutes
            ? state.voteDuration ?? 0
            : 0,
        seconds: durationType == VoteExpireDurationType.seconds
            ? state.voteDuration ?? 0
            : 0,
      );

      final poll = NotesCreatePollRequest(
          choices: state.voteContent,
          multiple: state.isVoteMultiple,
          expiresAt: state.voteExpireType == VoteExpireType.date
              ? state.voteDate
              : null,
          expiredAfter: state.voteExpireType == VoteExpireType.duration
              ? voteDuration
              : null);

      if (state.noteCreationMode == NoteCreationMode.update) {
        await misskey.notes.update(NotesUpdateRequest(
          noteId: state.noteId!,
          text: postText ?? "",
          cw: state.isCw ? state.cwText : null,
        ));
        noteRepository.registerNote(noteRepository.notes[state.noteId!]!
            .copyWith(
                text: postText ?? "", cw: state.isCw ? state.cwText : null));
      } else {
        await misskey.notes.create(NotesCreateRequest(
          visibility: state.noteVisibility,
          text: postText,
          cw: state.isCw ? state.cwText : null,
          localOnly: state.localOnly,
          replyId: state.reply?.id,
          renoteId: state.renote?.id,
          channelId: state.channel?.id,
          fileIds: fileIds.isEmpty ? null : fileIds,
          visibleUserIds: visibleUserIds.toSet().toList(), //distinct list
          reactionAcceptance: state.reactionAcceptance,
          poll: state.isVote ? poll : null,
        ));
      }
      if (!mounted) return;
      state = state.copyWith(isNoteSending: NoteSendStatus.finished);
    } catch (e) {
      state = state.copyWith(isNoteSending: NoteSendStatus.error);
      rethrow;
    }
  }

  /// メディアを選択する
  Future<void> chooseFile(BuildContext context) async {
    final result = await showModalBottomSheet<DriveModalSheetReturnValue?>(
        context: context, builder: (context) => const DriveModalSheet());

    if (result == DriveModalSheetReturnValue.drive) {
      if (!mounted) return;
      final result = await showDialog<List<DriveFile>?>(
        context: context,
        builder: (context) => DriveFileSelectDialog(
          account: state.account,
          allowMultiple: true,
        ),
      );
      if (result == null) return;
      final files = await Future.wait(
        result.map((file) async {
          if (file.type.startsWith("image")) {
            final fileContentResponse = await dio.get<Uint8List>(
              file.url,
              options: Options(responseType: ResponseType.bytes),
            );
            return ImageFileAlreadyPostedFile(
              data: fileContentResponse.data!,
              id: file.id,
              fileName: file.name,
              isNsfw: file.isSensitive,
              caption: file.comment,
            );
          }
          return UnknownAlreadyPostedFile(
            url: file.url,
            id: file.id,
            fileName: file.name,
            isNsfw: file.isSensitive,
            caption: file.comment,
          );
        }),
      );
      if (!mounted) return;
      state = state.copyWith(
        files: [
          ...state.files,
          ...files,
        ],
      );
    } else if (result == DriveModalSheetReturnValue.upload) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );
      if (result == null || result.files.isEmpty) return;

      final fsFiles = result.files.map((file) {
        final path = file.path;
        if (path != null) {
          return fileSystem.file(path);
        }
        return null;
      }).nonNulls;
      final files = await Future.wait(
        fsFiles.map(
          (file) async => ImageFile(
            data: await file.readAsBytes(),
            fileName: file.basename,
          ),
        ),
      );

      if (!mounted) return;
      state = state.copyWith(
        files: [
          ...state.files,
          ...files,
        ],
      );
    }
  }

  /// メディアの内容を変更する
  void setFileContent(MisskeyPostFile file, Uint8List? content) {
    if (content == null) return;
    final files = state.files.toList();

    switch (file) {
      case ImageFile():
        files[files.indexOf(file)] = ImageFile(
            data: content,
            fileName: file.fileName,
            caption: file.caption,
            isNsfw: file.isNsfw);
        break;
      case ImageFileAlreadyPostedFile():
        files[files.indexOf(file)] = ImageFile(
            data: content,
            fileName: file.fileName,
            caption: file.caption,
            isNsfw: file.isNsfw);
        break;
      case UnknownFile():
        files[files.indexOf(file)] = ImageFile(
            data: content,
            fileName: file.fileName,
            caption: file.caption,
            isNsfw: file.isNsfw);
        break;
      case UnknownAlreadyPostedFile():
        files[files.indexOf(file)] = ImageFile(
            data: content,
            fileName: file.fileName,
            caption: file.caption,
            isNsfw: file.isNsfw);
        break;
    }

    state = state.copyWith(files: files);
  }

  /// ファイルのメタデータを変更する
  void setFileMetaData(int index, FileSettingsDialogResult result) {
    final files = state.files.toList();
    final file = state.files[index];

    switch (file) {
      case ImageFile():
        files[index] = ImageFile(
          data: file.data,
          fileName: result.fileName,
          caption: result.caption,
          isNsfw: result.isNsfw,
        );
        break;
      case ImageFileAlreadyPostedFile():
        files[index] = ImageFileAlreadyPostedFile(
          data: file.data,
          id: file.id,
          fileName: result.fileName,
          isNsfw: result.isNsfw,
          caption: result.caption,
          isEdited: true,
        );
        break;
      case UnknownFile():
        files[index] = UnknownFile(
            data: file.data,
            fileName: result.fileName,
            isNsfw: result.isNsfw,
            caption: result.caption);
        break;
      case UnknownAlreadyPostedFile():
        files[index] = UnknownAlreadyPostedFile(
          url: file.url,
          id: file.id,
          fileName: result.fileName,
          isNsfw: result.isNsfw,
          caption: result.caption,
          isEdited: true,
        );
        break;
    }

    state = state.copyWith(files: files);
  }

  /// メディアを削除する
  void deleteFile(int index) {
    final list = state.files.toList();
    list.removeAt(index);

    state = state.copyWith(files: list);
  }

  /// リプライ先ユーザーを追加する
  Future<void> addReplyUser(BuildContext context) async {
    final user = await showDialog<User?>(
        context: context,
        builder: (context) => UserSelectDialog(account: state.account));
    if (user != null) {
      state = state.copyWith(replyTo: [...state.replyTo, user]);
    }
  }

  void deleteReplyUser(User user) async {
    final list = state.replyTo.toList();
    state = state.copyWith(replyTo: list..remove(user));
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
        context,
        S.of(context).cannotPublicReplyToPrivateNote(
              replyVisibility!.displayName(context),
            ),
      );
      return false;
    }
    if (state.account.i.isSilenced == true) {
      SimpleMessageDialog.show(
        context,
        S.of(context).cannotPublicNoteBySilencedUser,
      );
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
      errorNotifier.state = (
        SpecifiedException(S.of(context).cannotFederateNoteToChannel),
        context
      );
      return;
    }
    if (state.reply?.localOnly == true) {
      errorNotifier.state = (
        SpecifiedException(S.of(context).cannotFederateReplyToLocalOnlyNote),
        context
      );
      return;
    }
    if (state.renote?.localOnly == true) {
      errorNotifier.state = (
        SpecifiedException(S.of(context).cannotFederateRenoteToLocalOnlyNote),
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

  /// 投票をトグルする
  void toggleVote() {
    state = state.copyWith(isVote: !state.isVote);
  }

  void toggleVoteMultiple() {
    state = state.copyWith(isVoteMultiple: !state.isVoteMultiple);
  }

  /// 投票を追加する
  void addVoteContent() {
    if (state.voteContentCount == 10) return;
    final list = state.voteContent.toList();
    list.add("");
    state = state.copyWith(
        voteContentCount: state.voteContentCount + 1, voteContent: list);
  }

  /// 投票の行を削除する
  void deleteVoteContent(int index) {
    if (state.voteContentCount == 2) return;
    final list = state.voteContent.toList();
    list.removeAt(index);
    state = state.copyWith(
        voteContentCount: state.voteContentCount - 1, voteContent: list);
  }

  /// 投票の内容を設定する
  void setVoteContent(int index, String text) {
    final list = state.voteContent.toList();
    list[index] = text;
    state = state.copyWith(voteContent: list);
  }

  void setVoteExpireDate(DateTime date) {
    state = state.copyWith(voteDate: date);
  }

  void setVoteExpireType(VoteExpireType type) {
    state = state.copyWith(voteExpireType: type);
  }

  void setVoteDuration(int time) {
    state = state.copyWith(voteDuration: time);
  }

  void setVoteDurationType(VoteExpireDurationType type) {
    state = state.copyWith(voteDurationType: type);
  }
}
