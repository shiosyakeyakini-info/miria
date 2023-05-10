import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/extensions/date_time_extension.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/common/avatar_icon.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/mfm_text.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/misskey_file_view.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/note_modal_sheet.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/reaction_button.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/renote_modal_sheet.dart';
import 'package:flutter_misskey_app/view/reaction_picker_dialog/reaction_picker_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class MisskeyNote extends ConsumerStatefulWidget {
  final Note note;
  final bool isDisplayBorder;
  final int recursive;

  const MisskeyNote({
    super.key,
    required this.note,
    this.isDisplayBorder = true,
    this.recursive = 1,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MisskeyNoteState();
}

class MisskeyNoteState extends ConsumerState<MisskeyNote> {
  var isCwOpened = false;

  @override
  Widget build(BuildContext context) {
    final latestActualNote = ref.watch(notesProvider(AccountScope.of(context))
        .select((value) => value.notes[widget.note.id]));
    final renoteId = widget.note.renote?.id;
    final Note? renoteNote;

    bool isEmptyRenote = renoteId != null &&
        latestActualNote?.text == null &&
        latestActualNote?.cw == null;

    if (isEmptyRenote) {
      renoteNote = ref.watch(notesProvider(AccountScope.of(context))
          .select((value) => value.notes[renoteId]));
    } else {
      renoteNote = null;
    }
    final displayNote = renoteNote ?? latestActualNote;

    if (displayNote == null) {
      // ありえない
      return Container();
    }

    if (widget.recursive == 3) {
      return Container();
    }

    final userId =
        "@${displayNote.user.username}${displayNote.user.host == null ? "" : "@${displayNote.user.host}"}";

    return MediaQuery(
      data: MediaQueryData(
          textScaleFactor: MediaQuery.of(context).textScaleFactor *
              (widget.recursive > 1 ? 0.7 : 1)),
      child: Container(
        padding: EdgeInsets.only(
            top: 5 * MediaQuery.of(context).textScaleFactor,
            bottom: 5 * MediaQuery.of(context).textScaleFactor),
        decoration: widget.isDisplayBorder
            ? BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: Theme.of(context).dividerColor, width: 0.5)))
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isEmptyRenote)
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: MfmText(
                  mfmText:
                      "<small>${widget.note.user.name ?? widget.note.user.username} が ${widget.note.user.username == widget.note.renote?.user.username ? "セルフRenote" : "Renote"}</small>",
                ),
              ),
            if (displayNote.reply != null)
              MisskeyNote(
                note: displayNote.reply!,
                isDisplayBorder: false,
                recursive: widget.recursive + 1,
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvatarIcon(user: displayNote.user),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NoteHeader1(
                        displayNote: displayNote,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              userId,
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          if (displayNote.user.instance != null)
                            Text(displayNote.user.instance?.name ?? "",
                                style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                      if (displayNote.cw != null) ...[
                        MfmText(
                          mfmText: displayNote.cw ?? "",
                          emojiFontSizeRatio: 2,
                          host: displayNote.user.host,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              padding: const EdgeInsets.all(5),
                              textStyle: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.fontSize),
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              setState(() {
                                isCwOpened = !isCwOpened;
                              });
                            },
                            child: Text(
                              isCwOpened ? "隠す" : "続きを見る",
                            ))
                      ],
                      if (displayNote.cw == null ||
                          displayNote.cw != null && isCwOpened) ...[
                        MfmText(
                          mfmText: displayNote.text ?? "",
                          emojiFontSizeRatio: 2,
                          host: displayNote.user.host,
                        ),
                        MisskeyFileView(
                          files: displayNote.files,
                          height:
                              200 * pow(0.5, widget.recursive - 1).toDouble(),
                        ),
                      ],
                      if (displayNote.reactions.isNotEmpty)
                        const Padding(padding: EdgeInsets.only(bottom: 5)),
                      Wrap(
                        spacing: 5 * MediaQuery.of(context).textScaleFactor,
                        runSpacing: 5 * MediaQuery.of(context).textScaleFactor,
                        children: [
                          for (final reaction in displayNote.reactions.entries
                              .sorted((a, b) => b.value.compareTo(a.value)))
                            ReactionButton(
                              reactionKey: reaction.key,
                              reactionCount: reaction.value,
                              myReaction: displayNote.myReaction,
                              noteId: displayNote.id,
                              anotherServerUrl: displayNote
                                  .reactionEmojis.entries
                                  .firstWhereOrNull((element) =>
                                      ":${element.key}:" == reaction.key)
                                  ?.value,
                            )
                        ],
                      ),
                      if (displayNote.channel != null)
                        NoteChannelView(channel: displayNote.channel!),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          IconButton(
                              onPressed: () {},
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              style: const ButtonStyle(
                                padding:
                                    MaterialStatePropertyAll(EdgeInsets.zero),
                                minimumSize:
                                    MaterialStatePropertyAll(Size(0, 0)),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              icon: Icon(
                                Icons.reply,
                                size:
                                    16 * MediaQuery.of(context).textScaleFactor,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color,
                              )),
                          TextButton.icon(
                            onPressed: () => showModalBottomSheet(
                                context: context,
                                builder: (innerContext) => RenoteModalSheet(
                                    note: displayNote,
                                    account: AccountScope.of(context))),
                            icon: Icon(
                              Icons.repeat_rounded,
                              size: 16 * MediaQuery.of(context).textScaleFactor,
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            label: Text(
                                "${displayNote.renoteCount != 0 ? displayNote.renoteCount : ""}",
                                style: Theme.of(context).textTheme.bodySmall),
                            style: const ButtonStyle(
                              padding:
                                  MaterialStatePropertyAll(EdgeInsets.zero),
                              minimumSize: MaterialStatePropertyAll(Size(0, 0)),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                          IconButton(
                              onPressed: () async => await reactionControl(
                                  ref, context, displayNote),
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              style: const ButtonStyle(
                                padding:
                                    MaterialStatePropertyAll(EdgeInsets.zero),
                                minimumSize:
                                    MaterialStatePropertyAll(Size(0, 0)),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              icon: Icon(
                                displayNote.myReaction == null
                                    ? Icons.add
                                    : Icons.remove,
                                size:
                                    16 * MediaQuery.of(context).textScaleFactor,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color,
                              )),
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (builder) {
                                      return NoteModalSheet(
                                          note: displayNote,
                                          account: AccountScope.of(context));
                                    });
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              style: const ButtonStyle(
                                padding:
                                    MaterialStatePropertyAll(EdgeInsets.zero),
                                minimumSize:
                                    MaterialStatePropertyAll(Size(0, 0)),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              icon: Icon(
                                Icons.more_horiz,
                                size:
                                    16 * MediaQuery.of(context).textScaleFactor,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (!isEmptyRenote && displayNote.renote != null)
              Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.deepOrangeAccent.shade700)),
                padding: const EdgeInsets.all(5),
                child: MisskeyNote(
                  note: displayNote.renote!,
                  isDisplayBorder: false,
                  recursive: widget.recursive + 1,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> reactionControl(
      WidgetRef ref, BuildContext context, Note displayNote) async {
    final account = AccountScope.of(context);
    if (displayNote.myReaction != null) {
      await ref
          .read(misskeyProvider(account))
          .notes
          .reactions
          .delete(NotesReactionsDeleteRequest(noteId: displayNote.id));
      await ref.read(notesProvider(account)).refresh(displayNote.id);
      return;
    }
    showDialog(
        context: context,
        builder: (context) => ReactionPickerDialog(
              targetNote: displayNote,
              account: account,
            ));
  }
}

class NoteHeader1 extends StatelessWidget {
  final Note displayNote;

  const NoteHeader1({super.key, required this.displayNote});
  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      children: [
        Expanded(child: UserInformation(user: displayNote.user)),
        Text(
          displayNote.createdAt.differenceNow,
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (displayNote.visibility == NoteVisibility.followers)
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Icon(
              Icons.lock,
              size: Theme.of(context).textTheme.bodySmall?.fontSize,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        if (displayNote.visibility == NoteVisibility.home)
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Icon(
              Icons.home,
              size: Theme.of(context).textTheme.bodySmall?.fontSize,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        if (displayNote.visibility == NoteVisibility.specified)
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Icon(
              Icons.mail,
              size: Theme.of(context).textTheme.bodySmall?.fontSize,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        if (displayNote.localOnly)
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Stack(
              children: [
                Icon(
                  Icons.rocket,
                  size: Theme.of(context).textTheme.bodySmall?.fontSize,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                Transform.translate(
                  offset: Offset(
                      3,
                      (Theme.of(context).textTheme.bodySmall?.fontSize ?? 22) /
                              2 -
                          1),
                  child: Transform.rotate(
                    angle: 45 * pi / 180,
                    child: Container(
                      width: Theme.of(context).textTheme.bodySmall?.fontSize,
                      height: Theme.of(context).textTheme.bodySmall?.fontSize,
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color:
                                Theme.of(context).textTheme.bodySmall?.color ??
                                    Colors.grey,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
      ],
    );
  }
}

class NoteChannelView extends StatelessWidget {
  final NoteChannelInfo channel;

  const NoteChannelView({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.tv,
          size: Theme.of(context).textTheme.bodySmall?.fontSize,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 5),
        ),
        Text(
          channel.name,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
