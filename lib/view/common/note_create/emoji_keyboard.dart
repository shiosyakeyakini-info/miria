import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/model/input_completion_type.dart";
import "package:miria/model/misskey_emoji_data.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/misskey_notes/custom_emoji.dart";
import "package:miria/view/common/note_create/basic_keyboard.dart";
import "package:miria/view/common/note_create/input_completation.dart";

final _filteredEmojisProvider = NotifierProvider.autoDispose
    .family<_FilteredEmojis, List<MisskeyEmojiData>, Account>(
  _FilteredEmojis.new,
);

class _FilteredEmojis
    extends AutoDisposeFamilyNotifier<List<MisskeyEmojiData>, Account> {
  @override
  List<MisskeyEmojiData> build(Account arg) {
    ref.listen(
      inputCompletionTypeProvider,
      (_, type) async => _updateEmojis(type),
    );
    return ref.read(emojiRepositoryProvider(arg)).defaultEmojis();
  }

  Future<void> _updateEmojis(InputCompletionType type) async {
    if (type is Emoji) {
      state =
          await ref.read(emojiRepositoryProvider(arg)).searchEmojis(type.query);
    }
  }
}

class EmojiKeyboard extends ConsumerWidget {
  const EmojiKeyboard({
    required this.controller,
    required this.focusNode,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  void insertEmoji(MisskeyEmojiData emoji, WidgetRef ref) {
    final currentPosition = controller.selection.base.offset;
    final text = controller.text;

    final beforeSearchText =
        text.substring(0, text.substring(0, currentPosition).lastIndexOf(":"));

    final after = (currentPosition == text.length || currentPosition == -1)
        ? ""
        : text.substring(currentPosition, text.length);

    switch (emoji) {
      case CustomEmojiData():
        controller.value = TextEditingValue(
          text: "$beforeSearchText:${emoji.baseName}:$after",
          selection: TextSelection.collapsed(
            offset: beforeSearchText.length + emoji.baseName.length + 2,
          ),
        );
      case UnicodeEmojiData():
        controller.value = TextEditingValue(
          text: "$beforeSearchText${emoji.char}$after",
          selection: TextSelection.collapsed(
            offset: beforeSearchText.length + emoji.char.length,
          ),
        );
      default:
        return;
    }
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredEmojis = ref.watch(
      _filteredEmojisProvider(ref.read(accountContextProvider).getAccount),
    );

    if (filteredEmojis.isEmpty) {
      return BasicKeyboard(
        controller: controller,
        focusNode: focusNode,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (final emoji in filteredEmojis)
          GestureDetector(
            onTap: () => insertEmoji(emoji, ref),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: SizedBox(
                height: MediaQuery.textScalerOf(context).scale(32),
                child: CustomEmoji(emojiData: emoji),
              ),
            ),
          ),
        TextButton.icon(
          onPressed: () async {
            final selected = await context.pushRoute<MisskeyEmojiData>(
              ReactionPickerRoute(
                account: ref.read(accountContextProvider).getAccount,
                isAcceptSensitive: true,
              ),
            );

            if (selected != null) {
              insertEmoji(selected, ref);
            }
          },
          icon: const Icon(Icons.add_reaction_outlined),
          label: Text(S.of(context).otherComplementReactions),
        ),
      ],
    );
  }
}
