import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:miria/extensions/text_editing_controller_extension.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/image_file.dart';
import 'package:miria/model/misskey_emoji_data.dart';
import 'package:miria/providers.dart';
import 'package:miria/state_notifier/note_create_page/note_create_state_notifier.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/common/modal_indicator.dart';
import 'package:miria/view/dialogs/simple_message_dialog.dart';
import 'package:miria/view/themes/app_theme.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';
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

  return controller;
});
final noteFocusProvider =
    ChangeNotifierProvider.autoDispose((ref) => FocusNode());

@RoutePage()
class NoteCreatePage extends ConsumerStatefulWidget {
  final Account initialAccount;
  final String? initialText;
  final List<String>? initialMediaFiles;
  final CommunityChannel? channel;
  final Note? reply;
  final Note? renote;
  final Note? deletedNote;

  const NoteCreatePage({
    super.key,
    required this.initialAccount,
    this.initialText,
    this.initialMediaFiles,
    this.channel,
    this.reply,
    this.renote,
    this.deletedNote,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => NoteCreatePageState();
}

class NoteCreatePageState extends ConsumerState<NoteCreatePage> {
  late final focusNode = ref.watch(noteFocusProvider);
  var isFirstChangeDependenciesCalled = false;

  NoteCreate get data => ref.read(noteCreateProvider(widget.initialAccount));
  NoteCreateNotifier get notifier =>
      ref.read(noteCreateProvider(widget.initialAccount).notifier);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isFirstChangeDependenciesCalled) return;
    isFirstChangeDependenciesCalled = true;
    Future(() async {
      notifier.initialize(
          widget.channel,
          widget.initialText,
          widget.initialMediaFiles,
          widget.deletedNote,
          widget.renote,
          widget.reply);

      ref.read(noteInputTextProvider).addListener(() {
        notifier.setContentText(ref.read(noteInputTextProvider).text);
      });
      focusNode.addListener(() {
        notifier.setContentTextFocused(focusNode.hasFocus);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      noteCreateProvider(widget.initialAccount).select((value) => value.text),
      (_, next) {
        if (next != ref.read(noteInputTextProvider).text) {
          ref.read(noteInputTextProvider).text = next;
        }
      },
    );

    final noteDecoration = AppTheme.of(context).noteTextStyle.copyWith(
          hintText: (widget.renote != null || widget.reply != null)
              ? "何て送る？"
              : "何してはる？",
          contentPadding: const EdgeInsets.all(5),
        );

    return AccountScope(
      account: widget.initialAccount,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ノート"),
          actions: [
            IconButton(
                onPressed: () async =>
                    await notifier.note().expectFailure(context),
                icon: const Icon(Icons.send))
          ],
        ),
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
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
                      const CwTextArea(),
                      TextField(
                        controller: ref.watch(noteInputTextProvider),
                        focusNode: focusNode,
                        maxLines: null,
                        minLines: 5,
                        keyboardType: TextInputType.multiline,
                        decoration: noteDecoration,
                        autofocus: true,
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async =>
                                  await notifier.chooseFile(context),
                              icon: const Icon(Icons.image)),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.how_to_vote)),
                          const CwToggleButton(),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.mail_outline)),
                          IconButton(
                              onPressed: () async {
                                final selectedEmoji =
                                    await showDialog<MisskeyEmojiData?>(
                                        context: context,
                                        builder: (context) =>
                                            ReactionPickerDialog(
                                              account: data.account,
                                              isAcceptSensitive: true,
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
                      const RenoteArea(),
                    ],
                  ),
                ),
              ),
            ),
            const NoteEmoji(),
          ],
        ),
      ),
    );
  }
}

class MfmPreview extends ConsumerWidget {
  const MfmPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewText = ref.watch(noteCreateProvider(AccountScope.of(context))
        .select((value) => value.text));

    return Padding(
      padding: const EdgeInsets.all(5),
      child: MfmText(
        previewText,
        isNyaize: AccountScope.of(context).i.isCat,
      ),
    );
  }
}

class FilePreview extends ConsumerWidget {
  const FilePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final files = ref.watch(noteCreateProvider(AccountScope.of(context))
        .select((value) => value.files));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final file in files)
                Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CreateFileView(file: file))
            ],
          ),
        )
      ],
    );
  }
}

class CreateFileView extends StatelessWidget {
  final MisskeyPostFile file;

  const CreateFileView({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    final data = file;

    switch (data) {
      case ImageFile():
        return SizedBox(
          height: 200,
          child: Image.memory(data.data),
        );
      case ImageFileAlreadyPostedFile():
        return SizedBox(
          height: 200,
          child: Image.memory(data.data),
        );
      case UnknownFile():
        return Text(data.fileName);
      case UnknownAlreadyPostedFile():
        return Text(data.fileName);
    }
  }
}

class ChannelName extends ConsumerWidget {
  const ChannelName({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channel = ref.watch(noteCreateProvider(AccountScope.of(context))
        .select((value) => value.channel));
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
            channel.name,
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
    final reply = ref.watch(noteCreateProvider(AccountScope.of(context))
        .select((value) => value.reply));

    if (reply != null) {
      return MediaQuery(
          data: const MediaQueryData(textScaleFactor: 0.8),
          child: MisskeyNote(note: reply));
    }

    return Container();
  }
}

class RenoteArea extends ConsumerWidget {
  const RenoteArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final renote = ref.watch(noteCreateProvider(AccountScope.of(context))
        .select((value) => value.renote));

    if (renote != null) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "RN:",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor)),
          padding: const EdgeInsets.all(5),
          child: MediaQuery(
            data: const MediaQueryData(textScaleFactor: 0.8),
            child: MisskeyNote(note: renote),
          ),
        )
      ]);
    }

    return Container();
  }
}

class CwToggleButton extends ConsumerWidget {
  const CwToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cw = ref.watch(noteCreateProvider(AccountScope.of(context))
        .select((value) => value.isCw));
    return IconButton(
        onPressed: () => ref
            .read(noteCreateProvider(AccountScope.of(context)).notifier)
            .toggleCw(),
        icon: Icon(cw ? Icons.visibility_off : Icons.remove_red_eye));
  }
}

class CwTextArea extends ConsumerStatefulWidget {
  const CwTextArea({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CwTextAreaState();
}

class CwTextAreaState extends ConsumerState<CwTextArea> {
  final cwController = TextEditingController();

  @override
  void initState() {
    super.initState();

    cwController.addListener(() {
      ref
          .watch(noteCreateProvider(AccountScope.of(context)).notifier)
          .setCwText(cwController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      noteCreateProvider(AccountScope.of(context))
          .select((value) => value.cwText),
      (_, next) {
        if (next != cwController.text) cwController.text = next;
      },
    );

    final cw = ref.watch(noteCreateProvider(AccountScope.of(context))
        .select((value) => value.isCw));

    if (!cw) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor))),
        padding: const EdgeInsets.only(bottom: 10),
        child: TextField(
          controller: cwController,
          keyboardType: TextInputType.multiline,
          decoration: AppTheme.of(context).noteTextStyle.copyWith(
              hintText: "注釈", contentPadding: const EdgeInsets.all(5)),
        ),
      ),
    );
  }
}
