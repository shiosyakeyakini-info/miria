import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:miria/extensions/text_editing_controller_extension.dart';
import 'package:miria/model/input_completion_type.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/note_create/basic_keyboard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/common/note_create/emoji_keyboard.dart';
import 'package:miria/view/common/note_create/hashtag_keyboard.dart';
import 'package:miria/view/common/note_create/mfm_fn_keyboard.dart';

final inputCompletionTypeProvider =
    StateProvider.autoDispose<InputCompletionType>((ref) => Basic());

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
    ref.read(inputCompletionTypeProvider.notifier).state =
        widget.controller.inputCompletionType;
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

    return TextFieldTapRegion(
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  child: switch (inputCompletionType) {
                    Basic() => BasicKeyboard(
                        controller: widget.controller,
                        focusNode: focusNode,
                      ),
                    Emoji() => EmojiKeyboard(
                        account: account,
                        controller: widget.controller,
                        focusNode: focusNode,
                      ),
                    MfmFn() => MfmFnKeyboard(
                        controller: widget.controller,
                        focusNode: focusNode,
                        parentContext: context,
                      ),
                    Hashtag() => HashtagKeyboard(
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
                icon: const Icon(Icons.keyboard_arrow_down),
              ),
          ],
        ),
      ),
    );
  }
}
