import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/misskey_emoji_data.dart';
import 'package:miria/providers.dart';
import 'package:miria/repository/timeline_repository.dart';
import 'package:miria/view/common/misskey_notes/custom_emoji.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class NoteDetailDialog extends ConsumerStatefulWidget {
  final Note note;
  final Account account;
  final ChangeNotifierProvider<TimelineRepository> timeLineRepository;

  const NoteDetailDialog({
    super.key,
    required this.note,
    required this.timeLineRepository,
    required this.account,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      NoteDetailDialogState();
}

class NoteDetailDialogState extends ConsumerState<NoteDetailDialog> {
  final reactionTextField = TextEditingController();

  final foundEmojis = <MisskeyEmojiData>[];

  @override
  void initState() {
    super.initState();
    reactionTextField.addListener(() {
      setState(() {
        foundEmojis.clear();
        if (reactionTextField.text.isNotEmpty) {
          foundEmojis.addAll(ref
                  .read(emojiRepositoryProvider(widget.account))
                  .emoji
                  ?.where((element) =>
                      element.emoji.baseName.contains(reactionTextField.text) ||
                      element.aliases
                          .any((e) => e.contains(reactionTextField.text)))
                  .take(10)
                  .map((e) => e.emoji) ??
              []);
        }
      });
    });
  }

  @override
  void dispose() {
    reactionTextField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Column(
              children: [
                MisskeyNote(note: widget.note),
                TextField(
                  controller: reactionTextField,
                ),
                Wrap(
                  children: [
                    for (final emoji in foundEmojis)
                      SizedBox(
                        height: 42,
                        child: CustomEmoji(emojiData: emoji),
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
