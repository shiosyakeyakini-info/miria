import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:miria/extensions/text_editing_controller_extension.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/misskey_emoji_data.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/common/misskey_notes/custom_emoji.dart';
import 'package:miria/view/themes/app_theme.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:miria/view/common/misskey_notes/misskey_file_view.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';
import 'package:miria/view/common/not_implements_dialog.dart';
import 'package:miria/view/note_create_page/drive_file_select_dialog.dart';
import 'package:miria/view/note_create_page/drive_modal_sheet.dart';
import 'package:miria/view/note_create_page/note_create_setting_top.dart';
import 'package:miria/view/note_create_page/note_emoji.dart';
import 'package:miria/view/reaction_picker_dialog/reaction_picker_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

final noteInputTextProvider =
    ChangeNotifierProvider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  controller.addListener(() {
    if (controller.isIncludeBeforeColon) {
      if (controller.isEmojiScope) {
        if (ref.read(noteCreateEmojisProvider).isNotEmpty) {
          ref.read(noteCreateEmojisProvider.notifier).state = [];
        }
        return;
      }

      Future(() async {
        final initialAccount = ref.read(selectedAccountProvider);
        if (initialAccount == null) return;
        final searchedEmojis = await (ref
            .read(emojiRepositoryProvider(initialAccount))
            .searchEmojis(controller.emojiSearchValue));
        ref.read(noteCreateEmojisProvider.notifier).state = searchedEmojis;
      });
    } else {
      if (ref.read(noteCreateEmojisProvider).isNotEmpty) {
        ref.read(noteCreateEmojisProvider.notifier).state = [];
      }
    }
  });

  return controller;
});
final noteFocusProvider =
    ChangeNotifierProvider.autoDispose((ref) => FocusNode());

final selectedAccountProvider =
    StateProvider.autoDispose<Account?>((ref) => null);
final noteVisibilityProvider =
    StateProvider.autoDispose<NoteVisibility>((ref) => NoteVisibility.public);
final isLocalProvider = StateProvider.autoDispose((ref) => false);
final noteCreateEmojisProvider =
    StateProvider.autoDispose((ref) => <MisskeyEmojiData>[]);
final filesProvider = StateProvider.autoDispose((ref) => <DriveFile>[]);
final progressFileUploadProvider = StateProvider.autoDispose((ref) => false);
final channelProvider =
    StateProvider.autoDispose<(String id, String name)?>((ref) => null);
final replyProvider = StateProvider.autoDispose<Note?>((ref) => null);
final renoteProvider = StateProvider.autoDispose<Note?>((ref) => null);

@RoutePage()
class NoteCreatePage extends ConsumerStatefulWidget {
  final Account? initialAccount;
  final CommunityChannel? channel;
  final Note? reply;
  final Note? renote;
  final Note? deletedNote;

  const NoteCreatePage({
    super.key,
    this.initialAccount,
    this.channel,
    this.reply,
    this.renote,
    this.deletedNote,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => NoteCreatePageState();
}

class NoteCreatePageState extends ConsumerState<NoteCreatePage> {
  var isCw = false;
  final cwController = TextEditingController();
  late final focusNode = ref.read(noteFocusProvider);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Future(() async {
      final account =
          widget.initialAccount ?? ref.read(accountRepository).account.first;
      ref.read(selectedAccountProvider.notifier).state =
          widget.initialAccount ?? ref.read(accountRepository).account.first;
      final channel = widget.channel;
      ref.read(channelProvider.notifier).state =
          channel != null ? (channel.id, channel.name) : null;
      final accountSettings =
          ref.read(accountSettingsRepositoryProvider).fromAccount(account);
      var noteVisibility = accountSettings.defaultNoteVisibility;

      final deletedNote = widget.deletedNote;
      if (deletedNote != null) {
        noteVisibility = deletedNote.visibility;
        ref.read(isLocalProvider.notifier).state = deletedNote.localOnly;
        ref.read(filesProvider.notifier).state = deletedNote.files;
        final deletedNoteChannel = deletedNote.channel;
        ref.read(channelProvider.notifier).state = deletedNoteChannel != null
            ? (deletedNoteChannel.id, deletedNoteChannel.name)
            : null;
        cwController.text = deletedNote.cw ?? "";
        isCw = deletedNote.cw?.isNotEmpty == true;
        ref.read(noteInputTextProvider).text = deletedNote.text ?? "";
      }

      final renote = widget.renote;
      if (renote != null) {
        ref.read(renoteProvider.notifier).state = renote;
        noteVisibility = NoteVisibility.min(noteVisibility, renote.visibility);
      }

      final reply = widget.reply;
      ref.read(replyProvider.notifier).state = reply;
      if (reply != null) {
        // リプライの可視性はリノートより強くする
        noteVisibility = NoteVisibility.min(noteVisibility, reply.visibility);
      }

      // チャンネルのノートか、リプライまたはリノートが連合オフ、デフォルトで連合オフの場合、
      // 返信やRenoteも強制連合オフ
      if (widget.channel != null ||
          widget.reply?.localOnly == true ||
          widget.renote?.localOnly == true ||
          accountSettings.defaultIsLocalOnly) {
        ref.read(isLocalProvider.notifier).state = true;
      }

      // サイレンスの場合、ホーム以下に強制
      final isSilenced = ref.read(selectedAccountProvider)?.i.isSilenced;
      if (isSilenced == true) {
        noteVisibility =
            NoteVisibility.min(noteVisibility, NoteVisibility.home);
      }

      ref.read(noteVisibilityProvider.notifier).state = noteVisibility;
    });
  }

  Future<void> note() async {
    final account = ref.read(selectedAccountProvider);
    final files = ref.read(filesProvider);
    if (account == null) return;
    ref.read(misskeyProvider(account)).notes.create(NotesCreateRequest(
          visibility: ref.read(noteVisibilityProvider),
          text: ref.read(noteInputTextProvider).text,
          cw: isCw ? cwController.text : null,
          localOnly: ref.read(isLocalProvider),
          replyId: ref.read(replyProvider)?.id,
          renoteId: ref.read(renoteProvider)?.id,
          channelId: ref.read(channelProvider)?.$1,
          fileIds: files.isNotEmpty ? files.map((e) => e.id).toList() : null,
        ));
    Navigator.of(context).pop();
  }

  Future<void> driveConnect() async {
    final result = await showModalBottomSheet<DriveModalSheetReturnValue?>(
        context: context, builder: (context) => const DriveModalSheet());
    final account = ref.read(selectedAccountProvider);
    if (account == null) return;
    final misskey = ref.read(misskeyProvider(account));

    if (result == DriveModalSheetReturnValue.drive) {
      if (!mounted) return;
      final result = await showDialog<DriveFile?>(
          context: context,
          builder: (context) => DriveFileSelectDialog(account: account));
      if (result == null) return;

      ref.read(filesProvider.notifier).state = [
        ...ref.read(filesProvider),
        result
      ];
    } else if (result == DriveModalSheetReturnValue.upload) {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result == null) return;

      final path = result.files.single.path;
      if (path == null) return;
      if (!mounted) return;
      ref.read(progressFileUploadProvider.notifier).state = true;
      final response = await misskey.drive.files.create(
          DriveFilesCreateRequest(
            force: true,
            name: path.substring(
                path.lastIndexOf(Platform.pathSeparator) + 1, path.length),
          ),
          File(path));
      if (!mounted) return;
      ref.read(filesProvider.notifier).state = [
        ...ref.read(filesProvider),
        response
      ];
      ref.read(progressFileUploadProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedAccount = ref.watch(selectedAccountProvider);

    final noteDecoration = AppTheme.of(context).noteTextStyle.copyWith(
          hintText: (widget.renote != null || widget.reply != null)
              ? "何て送る？"
              : "何してはる？",
          contentPadding: const EdgeInsets.all(5),
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text("ノート"),
        actions: [
          IconButton(
              onPressed: () => note.expectFailure(context),
              icon: const Icon(Icons.send))
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const NoteCreateSettingTop(),
              const ChannelName(),
              const ReplyArea(),
              if (isCw)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context).dividerColor))),
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextField(
                      controller: cwController,
                      keyboardType: TextInputType.multiline,
                      decoration: AppTheme.of(context).noteTextStyle.copyWith(
                          hintText: "注釈",
                          contentPadding: const EdgeInsets.all(5)),
                    ),
                  ),
                ),
              TextField(
                controller: ref.read(noteInputTextProvider),
                focusNode: focusNode,
                maxLines: null,
                minLines: 5,
                keyboardType: TextInputType.multiline,
                decoration: noteDecoration,
                autofocus: true,
              ),
              const RenoteArea(),
              Row(
                children: [
                  IconButton(onPressed: driveConnect, icon: Icon(Icons.image)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.how_to_vote)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          isCw = !isCw;
                        });
                      },
                      icon: Icon(
                          isCw ? Icons.visibility_off : Icons.remove_red_eye)),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.mail_outline)),
                  IconButton(
                      onPressed: () async {
                        final account = ref.read(selectedAccountProvider);
                        if (account == null) return;
                        final selectedEmoji =
                            await showDialog<MisskeyEmojiData?>(
                                context: context,
                                builder: (context) => ReactionPickerDialog(
                                      account: account,
                                    ));
                        if (selectedEmoji == null) return;
                        switch (selectedEmoji) {
                          case CustomEmojiData():
                            ref
                                .read(noteInputTextProvider)
                                .insert(":${selectedEmoji.baseName}:");
                            break;
                          case UnicodeEmojiData():
                            ref
                                .read(noteInputTextProvider)
                                .insert(selectedEmoji.char);
                            break;
                          default:
                            break;
                        }
                        ref.read(noteFocusProvider).requestFocus();
                      },
                      icon: const Icon(Icons.tag_faces))
                ],
              ),
              const MfmPreview(),
              const FilePreview(),
            ],
          ),
        ),
      ),
      bottomSheet: const NoteEmoji(),
    );
  }
}

class MfmPreview extends ConsumerWidget {
  const MfmPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewText = ref.watch(noteInputTextProvider);
    final account = ref.watch(selectedAccountProvider);

    //TODO: どこかが監視してないといけないので
    ref.watch(noteFocusProvider);

    if (account == null) {
      return Container();
    }

    return AccountScope(
      account: account,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: MfmText(
          previewText.text,
          isNyaize: account.i.isCat,
        ),
      ),
    );
  }
}

class FilePreview extends ConsumerWidget {
  const FilePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final files = ref.watch(filesProvider);
    final isUploading = ref.watch(progressFileUploadProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isUploading)
          const Padding(padding: EdgeInsets.all(10), child: Text("アップロード中...")),
        MisskeyFileView(files: files),
      ],
    );
  }
}

class ChannelName extends ConsumerWidget {
  const ChannelName({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channel = ref.watch(channelProvider);
    if (channel == null) return Container();
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Icon(
            Icons.tv,
            size: Theme.of(context).textTheme.bodySmall!.fontSize! *
                MediaQuery.of(context).textScaleFactor,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          Text(
            channel.$2,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class ReplyArea extends ConsumerWidget {
  const ReplyArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reply = ref.watch(replyProvider);
    final account = ref.watch(selectedAccountProvider);

    if (reply != null && account != null) {
      return AccountScope(
        account: account,
        child: MediaQuery(
            data: const MediaQueryData(textScaleFactor: 0.8),
            child: MisskeyNote(note: reply)),
      );
    }

    return Container();
  }
}

class RenoteArea extends ConsumerWidget {
  const RenoteArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(selectedAccountProvider);
    final renote = ref.watch(renoteProvider);

    if (renote != null && account != null) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "RN:",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor)),
          padding: const EdgeInsets.all(5),
          child: AccountScope(
            account: account,
            child: MediaQuery(
              data: const MediaQueryData(textScaleFactor: 0.8),
              child: MisskeyNote(note: renote),
            ),
          ),
        )
      ]);
    }

    return Container();
  }
}
