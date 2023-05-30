import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/misskey_emoji_data.dart';
import 'package:miria/providers.dart';
import 'package:miria/repository/emoji_repository.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/custom_emoji.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ReactionPickerContent extends ConsumerStatefulWidget {
  final FutureOr Function(MisskeyEmojiData emoji) onTap;

  const ReactionPickerContent({super.key, required this.onTap});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ReactionPickerContentState();
}

class ReactionPickerContentState extends ConsumerState<ReactionPickerContent> {
  final emojis = <MisskeyEmojiData>[];
  final categoryList = <String>[];
  EmojiRepository get emojiRepository =>
      ref.read(emojiRepositoryProvider(AccountScope.of(context)));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    emojis.clear();
    emojis.addAll(emojiRepository.defaultEmojis().toList());

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
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search)),
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
                for (final emoji in emojis)
                  EmojiButton(
                    emoji: emoji,
                    onTap: widget.onTap,
                    isForceVisible: true,
                  )
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
                  padding: const EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        for (final emoji in (emojiRepository.emoji ?? []).where(
                            (element) =>
                                element.category == categoryList[index]))
                          EmojiButton(
                            emoji: emoji.emoji,
                            onTap: widget.onTap,
                          )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class EmojiButton extends ConsumerStatefulWidget {
  final MisskeyEmojiData emoji;
  final FutureOr Function(MisskeyEmojiData emoji) onTap;
  final bool isForceVisible;

  const EmojiButton({
    super.key,
    required this.emoji,
    required this.onTap,
    this.isForceVisible = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => EmojiButtonState();
}

class EmojiButtonState extends ConsumerState<EmojiButton> {
  late var isVisibility = widget.isForceVisible;
  late var isVisibilityOnceMore = widget.isForceVisible;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.emoji.baseName),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction != 0) {
          setState(() {
            isVisibility = true;
            isVisibilityOnceMore = true;
          });
        }
      },
      child: ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.transparent),
            padding: MaterialStatePropertyAll(EdgeInsets.all(5)),
            elevation: MaterialStatePropertyAll(0),
            minimumSize: MaterialStatePropertyAll(Size(0, 0)),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () async {
            widget.onTap.call(widget.emoji);
          },
          child: SizedBox(
              height: 32 * MediaQuery.of(context).textScaleFactor,
              child: isVisibility
                  ? CustomEmoji(emojiData: widget.emoji)
                  : const SizedBox.shrink())),
    );
  }
}
