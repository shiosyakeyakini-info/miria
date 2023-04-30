import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/extensions/date_time_extension.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/repository/time_line_repository.dart';
import 'package:flutter_misskey_app/router/app_router.dart';
import 'package:flutter_misskey_app/view/common/mfm_text.dart';
import 'package:flutter_misskey_app/view/common/misskey_file_view.dart';
import 'package:flutter_misskey_app/view/common/reaction_button.dart';
import 'package:flutter_misskey_app/view/reaction_picker_dialog/reaction_picker_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class MisskeyNote extends ConsumerStatefulWidget {
  final Note note;

  const MisskeyNote({super.key, required this.note});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MisskeyNoteState();
}

class MisskeyNoteState extends ConsumerState<MisskeyNote> {
  var isCwOpened = false;

  @override
  Widget build(BuildContext context) {
    final displayNote = widget.note.renote ?? widget.note;

    final userId =
        "@${displayNote.user.username}${displayNote.user.host == null ? "" : "@${displayNote.user.host}"}";

    return Container(
      padding: EdgeInsets.only(
          top: 5 * MediaQuery.of(context).textScaleFactor,
          bottom: 5 * MediaQuery.of(context).textScaleFactor),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Theme.of(context).dividerColor, width: 0.5))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.note.renote != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                "${widget.note.user.name ?? ""} が ${widget.note.user.username == widget.note.renote?.user.username ? "セルフRenote" : "Renote"}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  context.pushRoute(UserRoute(userId: displayNote.user.id));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: SizedBox(
                      width: 32 * MediaQuery.of(context).textScaleFactor,
                      height: 32 * MediaQuery.of(context).textScaleFactor,
                      child:
                          Image.network(displayNote.user.avatarUrl.toString())),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: UserInformation(user: displayNote.user)),
                        Text(
                          displayNote.createdAt.differenceNow,
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
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
                      MfmText(mfmText: displayNote.cw ?? ""),
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
                      MfmText(mfmText: displayNote.text ?? ""),
                      MisskeyFileView(files: displayNote.files),
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
                            anotherServerUrl: displayNote.reactionEmojis.entries
                                .firstWhereOrNull((element) =>
                                    ":${element.key}:" == reaction.key)
                                ?.value,
                          )
                      ],
                    ),
                    if (displayNote.channel != null) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.tv,
                            size:
                                Theme.of(context).textTheme.bodySmall?.fontSize,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Text(
                            displayNote.channel!.name,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      )
                    ],
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
                              minimumSize: MaterialStatePropertyAll(Size(0, 0)),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: Icon(
                              Icons.reply,
                              size: 16 * MediaQuery.of(context).textScaleFactor,
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            )),
                        IconButton(
                            onPressed: () {},
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            style: const ButtonStyle(
                              padding:
                                  MaterialStatePropertyAll(EdgeInsets.zero),
                              minimumSize: MaterialStatePropertyAll(Size(0, 0)),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: Icon(
                              Icons.repeat,
                              size: 16 * MediaQuery.of(context).textScaleFactor,
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            )),
                        IconButton(
                            onPressed: () async => await reactionControl(
                                ref, context, displayNote),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            style: const ButtonStyle(
                              padding:
                                  MaterialStatePropertyAll(EdgeInsets.zero),
                              minimumSize: MaterialStatePropertyAll(Size(0, 0)),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: Icon(
                              displayNote.myReaction == null
                                  ? Icons.add
                                  : Icons.remove,
                              size: 16 * MediaQuery.of(context).textScaleFactor,
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            )),
                        IconButton(
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            style: const ButtonStyle(
                              padding:
                                  MaterialStatePropertyAll(EdgeInsets.zero),
                              minimumSize: MaterialStatePropertyAll(Size(0, 0)),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: Icon(
                              Icons.more_horiz,
                              size: 16 * MediaQuery.of(context).textScaleFactor,
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> reactionControl(
      WidgetRef ref, BuildContext context, Note displayNote) async {
    if (displayNote.myReaction != null) {
      await ref
          .read(misskeyProvider)
          .notes
          .reactions
          .delete(NotesReactionsDeleteRequest(noteId: displayNote.id));
      await ref.read(noteRefreshServiceProvider).refresh(displayNote.id);
      return;
    }
    showDialog(
        context: context,
        builder: (context) => ReactionPickerDialog(targetNote: displayNote));
  }
}
