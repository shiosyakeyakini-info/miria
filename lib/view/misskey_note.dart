import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/view/custom_emoji.dart';
import 'package:flutter_misskey_app/view/mfm_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class MisskeyNote extends ConsumerWidget {
  final Note note;

  const MisskeyNote({super.key, required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayNote = note.renote ?? note;

    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (note.renote != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "${note.user.name ?? ""} が ${note.user.username == note.renote?.user.username ? "セルフRenote" : "Renote"}",
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.network(displayNote.user.avatarUrl.toString())),
              const Padding(
                padding: EdgeInsets.only(left: 10),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserInformation(user: displayNote.user),
                    const Padding(
                      padding: EdgeInsets.only(top: 5),
                    ),
                    MfmText(mfmText: displayNote.text ?? ""),
                    for (final file in displayNote.files
                        .where((e) => e.thumbnailUrl != null))
                      if (!file.isSensitive)
                        Image.network(
                            (file.thumbnailUrl ?? file.url).toString()),
                    Wrap(
                      runSpacing: 5,
                      children: [
                        for (final reaction in displayNote.reactions.entries)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                  onPressed: () {},
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.white),
                                      padding: MaterialStatePropertyAll(
                                          EdgeInsets.zero)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomEmoji.fromEmojiName(reaction.key,
                                          ref.read(emojiRepositoryProvider)),
                                      Padding(
                                          padding: EdgeInsets.only(left: 5)),
                                      Text(reaction.value.toString(),
                                          style: TextStyle(
                                            color: Colors.black45,
                                          )),
                                    ],
                                  )),
                              const Padding(
                                padding: EdgeInsets.only(left: 5, bottom: 5),
                              ),
                            ],
                          )
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
}
