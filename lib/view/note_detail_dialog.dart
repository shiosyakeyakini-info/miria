import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/repository/time_line_repository.dart';
import 'package:flutter_misskey_app/view/custom_emoji.dart';
import 'package:flutter_misskey_app/view/misskey_note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class NoteDetailDialog extends ConsumerStatefulWidget {
  final Note note;
  final ChangeNotifierProvider<TimeLineRepository> timeLineRepository;

  const NoteDetailDialog({super.key, required this.note, required this.timeLineRepository});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      NoteDetailDialogState();
}

class NoteDetailDialogState extends ConsumerState<NoteDetailDialog> {
  final reactionTextField = TextEditingController();

  final foundEmojis = <Emoji>[];

  @override
  void initState() {
    super.initState();
    reactionTextField.addListener(() {
      setState(() {
        foundEmojis.clear();
        if (reactionTextField.text.isNotEmpty) {
          foundEmojis.addAll(ref
                  .read(emojiRepositoryProvider)
                  .emoji
                  ?.where((element) =>
                      element.name.contains(reactionTextField.text) ||
                      element.aliases
                          .any((e) => e.contains(reactionTextField.text)))
                  .take(10) ??
              []);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Column(
              children: [
                MisskeyNote(
                  noteId: widget.note.id,
                  timelineProvider: widget.timeLineRepository,
                ),
                TextField(
                  controller: reactionTextField,
                ),
                Wrap(
                  children: [
                    for (final emoji in foundEmojis)
                      SizedBox(
                        height: 42,
                        child: CustomEmoji(emoji: emoji),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
