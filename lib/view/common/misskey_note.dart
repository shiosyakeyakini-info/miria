import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/repository/time_line_repository.dart';
import 'package:flutter_misskey_app/view/common/mfm_text.dart';
import 'package:flutter_misskey_app/view/common/misskey_file_view.dart';
import 'package:flutter_misskey_app/view/common/reaction_button.dart';
import 'package:flutter_misskey_app/view/reaction_picker_dialog/reaction_picker_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class MisskeyNote extends ConsumerWidget {
  final String noteId;
  final ChangeNotifierProvider<TimeLineRepository> timelineProvider;

  const MisskeyNote(
      {super.key, required this.noteId, required this.timelineProvider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final note = ref.watch(timelineProvider.select(
        (value) => value.notes.firstWhereOrNull((e) => e.id == noteId)));
    if (note == null) return Container();

    final displayNote = note.renote ?? note;

    return Container(
      padding: EdgeInsets.only(
          top: 5 * MediaQuery.of(context).textScaleFactor,
          bottom: 5 * MediaQuery.of(context).textScaleFactor),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (note.renote != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                "${note.user.name ?? ""} が ${note.user.username == note.renote?.user.username ? "セルフRenote" : "Renote"}",
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: SizedBox(
                    width: 24 * MediaQuery.of(context).textScaleFactor,
                    height: 24 * MediaQuery.of(context).textScaleFactor,
                    child:
                        Image.network(displayNote.user.avatarUrl.toString())),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserInformation(user: displayNote.user),
                    MfmText(mfmText: displayNote.text ?? ""),
                    MisskeyFileView(files: displayNote.files),
                    const Padding(padding: EdgeInsets.only(bottom: 5)),
                    Wrap(
                      spacing: 5 * MediaQuery.of(context).textScaleFactor,
                      runSpacing: 5 * MediaQuery.of(context).textScaleFactor,
                      children: [
                        for (final reaction in displayNote.reactions.entries)
                          ReactionButton(
                            reactionKey: reaction.key,
                            reactionCount: reaction.value,
                            myReaction: displayNote.myReaction,
                            noteId: displayNote.id,
                          )
                      ],
                    ),
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
