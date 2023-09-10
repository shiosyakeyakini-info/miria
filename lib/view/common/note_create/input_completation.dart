import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:miria/extensions/text_editing_controller_extension.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/note_create/basic_keyboard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/common/note_create/emoji_keyboard.dart';

enum InputCompletionType {
  basic,
  emoji,
}

final inputCompletionTypeProvider =
    StateProvider.autoDispose((ref) => InputCompletionType.basic);

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

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(updateType);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    isClose = !ref.read(widget.focusNode).hasFocus;
  }

  @override
  void dispose() {
    widget.controller.removeListener(updateType);

    super.dispose();
  }

  void updateType() {
    if (widget.controller.isIncludeBeforeColon) {
      if (widget.controller.isEmojiScope) {
        ref.read(inputCompletionTypeProvider.notifier).state =
            InputCompletionType.basic;
      } else {
        ref.read(inputCompletionTypeProvider.notifier).state =
            InputCompletionType.emoji;
      }
    } else {
      ref.read(inputCompletionTypeProvider.notifier).state =
          InputCompletionType.basic;
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputCompletionType = ref.watch(inputCompletionTypeProvider);
    final focusNode = ref.watch(widget.focusNode);
    final account = AccountScope.of(context);

    ref.listen(widget.focusNode, (previous, next) async {
      if (!next.hasFocus) {
        await Future.delayed(
          Duration(milliseconds: ref.read(inputComplementDelayedProvider)),
        );
        if (!mounted) return;
        if (!ref.read(widget.focusNode).hasFocus) {
          setState(() {
            isClose = true;
          });
        }
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
                child: switch (inputCompletionType) {
                  InputCompletionType.basic => BasicKeyboard(
                      controller: widget.controller,
                      focusNode: focusNode,
                    ),
                  InputCompletionType.emoji => EmojiKeyboard(
                      account: account,
                      controller: widget.controller,
                      focusNode: focusNode,
                    ),
                },
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
