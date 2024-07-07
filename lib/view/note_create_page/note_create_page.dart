import "dart:async";

import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/text_editing_controller_extension.dart";
import "package:miria/model/account.dart";
import "package:miria/model/misskey_emoji_data.dart";
import "package:miria/providers.dart";
import "package:miria/state_notifier/note_create_page/note_create_state_notifier.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/modal_indicator.dart";
import "package:miria/view/note_create_page/channel_area.dart";
import "package:miria/view/note_create_page/cw_text_area.dart";
import "package:miria/view/note_create_page/cw_toggle_button.dart";
import "package:miria/view/note_create_page/file_preview.dart";
import "package:miria/view/note_create_page/mfm_preview.dart";
import "package:miria/view/note_create_page/note_create_setting_top.dart";
import "package:miria/view/note_create_page/note_emoji.dart";
import "package:miria/view/note_create_page/renote_area.dart";
import "package:miria/view/note_create_page/reply_area.dart";
import "package:miria/view/note_create_page/reply_to_area.dart";
import "package:miria/view/note_create_page/vote_area.dart";
import "package:miria/view/reaction_picker_dialog/reaction_picker_dialog.dart";
import "package:miria/view/themes/app_theme.dart";
import "package:misskey_dart/misskey_dart.dart";

final noteInputTextProvider =
    ChangeNotifierProvider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();

  return controller;
});
final noteFocusProvider =
    ChangeNotifierProvider.autoDispose((ref) => FocusNode());

enum NoteCreationMode { update, recreate }

@RoutePage()
class NoteCreatePage extends ConsumerStatefulWidget
    implements AutoRouteWrapper {
  final Account initialAccount;
  final String? initialText;
  final List<String>? initialMediaFiles;
  final bool exitOnNoted;
  final CommunityChannel? channel;
  final Note? reply;
  final Note? renote;
  final Note? note;
  final NoteCreationMode? noteCreationMode;

  const NoteCreatePage({
    required this.initialAccount,
    super.key,
    this.initialText,
    this.initialMediaFiles,
    this.exitOnNoted = false,
    this.channel,
    this.reply,
    this.renote,
    this.note,
    this.noteCreationMode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => NoteCreatePageState();

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: initialAccount, child: this);
}

class NoteCreatePageState extends ConsumerState<NoteCreatePage> {
  late final focusNode = ref.watch(noteFocusProvider);
  var isFirstChangeDependenciesCalled = false;

  NoteCreate get data => ref.read(noteCreateNotifierProvider);
  NoteCreateNotifier get notifier =>
      ref.read(noteCreateNotifierProvider.notifier);

  static const shareExtensionMethodChannel =
      MethodChannel("info.shiosyakeyakini.miria/share_extension");

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
      await notifier.initialize(
        widget.channel,
        widget.initialText,
        widget.initialMediaFiles,
        widget.note,
        widget.renote,
        widget.reply,
        widget.noteCreationMode,
      );

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
    ref
      ..listen(
        noteCreateNotifierProvider.select((value) => value.text),
        (_, next) {
          if (next != ref.read(noteInputTextProvider).text) {
            ref.read(noteInputTextProvider).text = next;
          }
        },
      )
      ..listen(
          noteCreateNotifierProvider.select((value) => value.isNoteSending),
          (_, next) async {
        switch (next) {
          case NoteSendStatus.sending:
            IndicatorView.showIndicator(context);
          case NoteSendStatus.finished:
            IndicatorView.hideIndicator(context);
            if (widget.exitOnNoted) {
              await shareExtensionMethodChannel.invokeMethod("exit");
            } else {
              Navigator.of(context).pop();
            }

          case NoteSendStatus.error:
            IndicatorView.hideIndicator(context);
          case null:
            break;
        }
      });

    final noteDecoration = AppTheme.of(context).noteTextStyle.copyWith(
          hintText: (widget.renote != null || widget.reply != null)
              ? S.of(context).replyNotePlaceholder
              : S.of(context).defaultNotePlaceholder,
          contentPadding: const EdgeInsets.all(5),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).note),
        actions: [
          IconButton(
            onPressed: () async => await notifier.note(),
            icon: const Icon(Icons.send),
          ),
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
                    if (widget.noteCreationMode != NoteCreationMode.update)
                      const NoteCreateSettingTop()
                    else
                      const Padding(padding: EdgeInsets.only(top: 30)),
                    const ChannelArea(),
                    const ReplyArea(),
                    const ReplyToArea(),
                    const CwTextArea(),
                    Focus(
                      onKeyEvent: (node, event) {
                        if (event is KeyDownEvent) {
                          if (event.logicalKey == LogicalKeyboardKey.enter &&
                              HardwareKeyboard.instance.isControlPressed) {
                            unawaited(notifier.note());
                            return KeyEventResult.handled;
                          }
                        }
                        return KeyEventResult.ignored;
                      },
                      child: TextField(
                        controller: ref.watch(noteInputTextProvider),
                        focusNode: focusNode,
                        maxLines: null,
                        minLines: 5,
                        keyboardType: TextInputType.multiline,
                        decoration: noteDecoration,
                        autofocus: true,
                      ),
                    ),
                    Row(
                      children: [
                        if (widget.noteCreationMode !=
                            NoteCreationMode.update) ...[
                          IconButton(
                            onPressed: () async => await notifier.chooseFile(),
                            icon: const Icon(Icons.image),
                          ),
                          if (widget.noteCreationMode !=
                              NoteCreationMode.update)
                            IconButton(
                              onPressed: () {
                                ref
                                    .read(noteCreateNotifierProvider.notifier)
                                    .toggleVote();
                              },
                              icon: const Icon(Icons.how_to_vote),
                            ),
                        ],
                        const CwToggleButton(),
                        if (widget.noteCreationMode != NoteCreationMode.update)
                          IconButton(
                            onPressed: () async => notifier.addReplyUser(),
                            icon: const Icon(Icons.mail_outline),
                          ),
                        IconButton(
                          onPressed: () async {
                            final selectedEmoji =
                                await showDialog<MisskeyEmojiData?>(
                              context: context,
                              builder: (context) => ReactionPickerDialog(
                                account: ref
                                    .read(accountContextProvider)
                                    .postAccount,
                                isAcceptSensitive: true,
                              ),
                            );
                            if (selectedEmoji == null) return;
                            switch (selectedEmoji) {
                              case CustomEmojiData():
                                ref
                                    .read(noteInputTextProvider)
                                    .insert(":${selectedEmoji.baseName}:");
                              case UnicodeEmojiData():
                                ref
                                    .read(noteInputTextProvider)
                                    .insert(selectedEmoji.char);
                              default:
                                break;
                            }
                            ref.read(noteFocusProvider).requestFocus();
                          },
                          icon: const Icon(Icons.tag_faces),
                        ),
                      ],
                    ),
                    const MfmPreview(),
                    if (widget.noteCreationMode != NoteCreationMode.update)
                      const FilePreview()
                    else if (widget.note?.files.isNotEmpty == true)
                      Text(S.of(context).hasMediaButCannotEdit),
                    const RenoteArea(),
                    if (widget.noteCreationMode != NoteCreationMode.update)
                      const VoteArea()
                    else if (widget.note?.poll != null)
                      Text(S.of(context).hasVoteButCannotEdit),
                  ],
                ),
              ),
            ),
          ),
          const NoteEmoji(),
        ],
      ),
    );
  }
}
