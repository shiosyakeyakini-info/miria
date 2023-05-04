import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/model/account.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/repository/emoji_repository.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/custom_emoji.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class ReactionPickerDialog extends ConsumerStatefulWidget {
  final Note targetNote;
  final Account account;

  const ReactionPickerDialog(
      {super.key, required this.targetNote, required this.account});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReactionPickerDialogState();
}

class _ReactionPickerDialogState extends ConsumerState<ReactionPickerDialog> {
  final emojis = <Emoji>[];

  EmojiRepository get emojiRepository =>
      ref.read(emojiRepositoryProvider(widget.account));

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    emojis.clear();
    emojis.addAll(emojiRepository.emoji?.take(30) ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: AccountScope(
        account: widget.account,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    Future(() async {
                      final result = await emojiRepository.searchEmojis(value);
                      setState(() {
                        emojis.clear();
                        emojis.addAll(result);
                      });
                    });
                  },
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    for (final emoji in emojis)
                      ElevatedButton(
                          style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.transparent),
                            padding:
                                MaterialStatePropertyAll(EdgeInsets.all(5)),
                            elevation: MaterialStatePropertyAll(0),
                            minimumSize: MaterialStatePropertyAll(Size(0, 0)),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () async {
                            try {
                              await ref
                                  .read(misskeyProvider(widget.account))
                                  .notes
                                  .reactions
                                  .create(NotesReactionsCreateRequest(
                                      noteId: widget.targetNote.id,
                                      reaction: ":${emoji.name}:"));
                              await ref
                                  .read(notesProvider(widget.account))
                                  .refresh(widget.targetNote.id);
                            } finally {
                              Navigator.of(context).pop();
                            }
                          },
                          child: SizedBox(
                              height:
                                  32 * MediaQuery.of(context).textScaleFactor,
                              child: CustomEmoji(emoji: emoji)))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
