import 'dart:async';

import 'package:flutter/material.dart';
import 'package:miria/view/common/misskey_notes/custom_emoji.dart';
import 'package:miria/view/common/note_create/custom_keyboard_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class InputComplement extends ConsumerStatefulWidget {
  final AutoDisposeStateProvider<List<Emoji>> searchedEmojiProvider;
  final TextEditingController controller;
  final AutoDisposeChangeNotifierProvider<FocusNode> focusNode;

  const InputComplement({
    super.key,
    required this.searchedEmojiProvider,
    required this.controller,
    required this.focusNode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => InputComplementState();
}

class InputComplementState extends ConsumerState<InputComplement> {
  bool isClose = true;

  void insertEmoji(Emoji emoji, WidgetRef ref) {
    final currentPosition = widget.controller.selection.base.offset;
    final text = widget.controller.text;
    final beforeSearchText =
        text.substring(0, text.substring(0, currentPosition).lastIndexOf(":"));

    final after = (currentPosition == text.length || currentPosition == -1)
        ? ""
        : text.substring(currentPosition, text.length);

    widget.controller.value = TextEditingValue(
        text: "$beforeSearchText:${emoji.name}:$after",
        selection: TextSelection.collapsed(
            offset: beforeSearchText.length + emoji.name.length + 2));
    ref.read(widget.searchedEmojiProvider.notifier).state = [];
    ref.read(widget.focusNode).requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final filteredInputEmoji = ref.watch(widget.searchedEmojiProvider);

    ref.listen(widget.focusNode, (previous, next) {
      if (!next.hasFocus) {
        Future(() async {
          await Future.delayed(const Duration(milliseconds: 300));
          if (!mounted) return;
          if (!ref.read(widget.focusNode).hasFocus) {
            setState(() {
              isClose = true;
            });
          }
        });
      } else {
        setState(() {
          isClose = false;
        });
      }
    });

    if (isClose) {
      return Container();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minWidth: MediaQuery.of(context).size.width),
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: Theme.of(context).primaryColor))),
          padding: const EdgeInsets.all(5),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (filteredInputEmoji.isNotEmpty)
                  for (final emoji in filteredInputEmoji)
                    GestureDetector(
                      onTap: () => insertEmoji(emoji, ref),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: SizedBox(
                            height: 32 * MediaQuery.of(context).textScaleFactor,
                            child: CustomEmoji(emoji: emoji)),
                      ),
                    )
                else
                  CustomKeyboardList(
                    controller: widget.controller,
                    focusNode: ref.read(widget.focusNode),
                  ),
              ]),
        ),
      ),
    );
  }
}
