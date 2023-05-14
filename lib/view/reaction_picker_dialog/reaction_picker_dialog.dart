import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/model/account.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/repository/emoji_repository.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/custom_emoji.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class ReactionPickerDialog extends ConsumerStatefulWidget {
  final Account account;

  const ReactionPickerDialog({super.key, required this.account});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReactionPickerDialogState();
}

class _ReactionPickerDialogState extends ConsumerState<ReactionPickerDialog> {
  final emojis = <Emoji>[];
  final categoryList = <String>[];

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

    categoryList
      ..clear()
      ..addAll(emojiRepository.emoji
              ?.map((e) => e.category)
              .toSet()
              .toList()
              .whereNotNull() ??
          []);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(5),
      content: AccountScope(
        account: widget.account,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.9,
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
                Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      for (final emoji in emojis) EmojiButton(emoji: emoji)
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categoryList.length,
                  itemBuilder: (context, index) => ExpansionTile(
                    title: Text(categoryList[index]),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: [
                              for (final emoji in (emojiRepository.emoji ?? [])
                                  .where((element) =>
                                      element.category == categoryList[index]))
                                EmojiButton(emoji: emoji)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmojiButton extends ConsumerWidget {
  final Emoji emoji;

  const EmojiButton({super.key, required this.emoji});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.transparent),
          padding: MaterialStatePropertyAll(EdgeInsets.all(5)),
          elevation: MaterialStatePropertyAll(0),
          minimumSize: MaterialStatePropertyAll(Size(0, 0)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () async {
          Navigator.of(context).pop(emoji);
        },
        child: SizedBox(
            height: 32 * MediaQuery.of(context).textScaleFactor,
            child: CustomEmoji(emoji: emoji)));
  }
}
