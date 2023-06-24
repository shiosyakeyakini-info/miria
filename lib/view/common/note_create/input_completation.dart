import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:miria/extensions/text_editing_controller_extension.dart';
import 'package:miria/model/misskey_emoji_data.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/custom_emoji.dart';
import 'package:miria/view/common/note_create/custom_keyboard_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/reaction_picker_dialog/reaction_picker_dialog.dart';

final inputComplementEmojiProvider =
    StateProvider.autoDispose((ref) => <MisskeyEmojiData>[]);
final inputComplementDelayedProvider = Provider((ref) => 300);

class InputComplement extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final AutoDisposeChangeNotifierProvider<FocusNode> focusNode;

  const InputComplement({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => InputComplementState();
}

class InputComplementState extends ConsumerState<InputComplement> {
  bool isClose = true;

  void insertEmoji(MisskeyEmojiData emoji, WidgetRef ref) {
    final currentPosition = widget.controller.selection.base.offset;
    final text = widget.controller.text;

    final beforeSearchText =
        text.substring(0, text.substring(0, currentPosition).lastIndexOf(":"));

    final after = (currentPosition == text.length || currentPosition == -1)
        ? ""
        : text.substring(currentPosition, text.length);

    switch (emoji) {
      case CustomEmojiData():
        widget.controller.value = TextEditingValue(
            text: "$beforeSearchText:${emoji.baseName}:$after",
            selection: TextSelection.collapsed(
                offset: beforeSearchText.length + emoji.baseName.length + 2));
        break;
      case UnicodeEmojiData():
        widget.controller.value = TextEditingValue(
            text: "$beforeSearchText${emoji.char}$after",
            selection: TextSelection.collapsed(offset: emoji.char.length));

        break;
      default:
        return;
    }

    ref.read(inputComplementEmojiProvider.notifier).state = [];
    ref.read(widget.focusNode).requestFocus();
  }

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      if (widget.controller.isIncludeBeforeColon) {
        if (widget.controller.isEmojiScope) {
          if (ref.read(inputComplementEmojiProvider).isNotEmpty) {
            ref.read(inputComplementEmojiProvider.notifier).state = [];
          }
          return;
        }

        Future(() async {
          final initialAccount = AccountScope.of(context);
          final searchedEmojis = await (ref
              .read(emojiRepositoryProvider(initialAccount))
              .searchEmojis(widget.controller.emojiSearchValue));
          ref.read(inputComplementEmojiProvider.notifier).state =
              searchedEmojis;
        });
      } else {
        if (ref.read(inputComplementEmojiProvider).isNotEmpty) {
          ref.read(inputComplementEmojiProvider.notifier).state = [];
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    isClose = !ref.read(widget.focusNode).hasFocus;
  }

  @override
  Widget build(BuildContext context) {
    final filteredInputEmoji = ref.watch(inputComplementEmojiProvider);

    ref.listen(widget.focusNode, (previous, next) {
      if (!next.hasFocus) {
        Future(() async {
          await Future.delayed(
              Duration(milliseconds: ref.read(inputComplementDelayedProvider)));
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

    return DecoratedBox(
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(color: Theme.of(context).primaryColor))),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (filteredInputEmoji.isNotEmpty) ...[
                        for (final emoji in filteredInputEmoji)
                          GestureDetector(
                            onTap: () => insertEmoji(emoji, ref),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: SizedBox(
                                  height: 32 *
                                      MediaQuery.of(context).textScaleFactor,
                                  child: CustomEmoji(emojiData: emoji)),
                            ),
                          ),
                        TextButton.icon(
                            onPressed: () async {
                              final selected = await showDialog(
                                  context: context,
                                  builder: (context2) => ReactionPickerDialog(
                                        account: AccountScope.of(context),
                                        isAcceptSensitive: true,
                                      ));
                              if (selected != null) {
                                insertEmoji(selected, ref);
                              }
                            },
                            icon: const Icon(Icons.add_reaction_outlined),
                            label: const Text("他のん"))
                      ] else
                        CustomKeyboardList(
                          controller: widget.controller,
                          focusNode: ref.read(widget.focusNode),
                        ),
                    ]),
              ),
            ),
          ),
          if (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS)
            IconButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                icon: const Icon(Icons.keyboard_arrow_down)),
        ],
      ),
    );
  }
}
