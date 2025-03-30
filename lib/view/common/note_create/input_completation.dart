import "dart:async";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/text_editing_controller_extension.dart";
import "package:miria/model/input_completion_type.dart";
import "package:miria/view/common/note_create/basic_keyboard.dart";
import "package:miria/view/common/note_create/emoji_keyboard.dart";
import "package:miria/view/common/note_create/hashtag_keyboard.dart";
import "package:miria/view/common/note_create/mfm_fn_keyboard.dart";

final inputCompletionTypeProvider =
    StateProvider.autoDispose<InputCompletionType>((ref) => Basic());

final inputComplementDelayedProvider = Provider((ref) => 300);

class InputComplement extends HookConsumerWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const InputComplement({
    required this.controller,
    required this.focusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inputCompletionType = ref.watch(inputCompletionTypeProvider);
    final focusNode = this.focusNode;

    final isClose = useState(!this.focusNode.hasFocus);

    useEffect(
      () {
        InputCompletionType updateType() =>
            ref.read(inputCompletionTypeProvider.notifier).state =
                controller.inputCompletionType;
        controller.addListener(updateType);

        return () => controller.removeListener(updateType);
      },
      const [],
    );

    useEffect(
      () {
        Future<void> handleFocusChange() async {
          if (!focusNode.hasFocus) {
            await Future.delayed(
              Duration(milliseconds: ref.read(inputComplementDelayedProvider)),
            );
            if (!context.mounted) return;
            if (focusNode.hasFocus) return;
            isClose.value = true;
          } else {
            isClose.value = false;
          }
        }

        focusNode.addListener(handleFocusChange);

        return () => focusNode.removeListener(handleFocusChange);
      },
      [focusNode],
    );

    if (isClose.value) {
      return Container();
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).primaryColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                child: switch (inputCompletionType) {
                  Basic() =>
                    BasicKeyboard(controller: controller, focusNode: focusNode),
                  Emoji() =>
                    EmojiKeyboard(controller: controller, focusNode: focusNode),
                  MfmFn() => MfmFnKeyboard(
                      controller: controller,
                      focusNode: focusNode,
                      parentContext: context,
                    ),
                  Hashtag() => HashtagKeyboard(
                      controller: controller,
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
    );
  }
}
