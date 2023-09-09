import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json5/json5.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/misskey_emoji_data.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/misskey_notes/custom_emoji.dart';
import 'package:miria/view/dialogs/simple_confirm_dialog.dart';
import 'package:miria/view/reaction_picker_dialog/reaction_picker_dialog.dart';
import 'package:miria/view/several_account_settings_page/reaction_deck_page/add_reactions_dialog.dart';
import 'package:reorderables/reorderables.dart';

enum ReactionDeckPageMenuType { addMany, copy, clear }

@RoutePage()
class ReactionDeckPage extends ConsumerStatefulWidget {
  final Account account;

  const ReactionDeckPage({super.key, required this.account});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ReactionDeckPageState();
}

class ReactionDeckPageState extends ConsumerState<ReactionDeckPage> {
  final List<MisskeyEmojiData> reactions = [];

  void save() {
    final currentData =
        ref.read(accountSettingsRepositoryProvider).fromAccount(widget.account);
    ref.read(accountSettingsRepositoryProvider).save(
          currentData.copyWith(
            reactions: reactions.map((e) => e.baseName).toList(),
          ),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    reactions
      ..clear()
      ..addAll(
          ref.read(emojiRepositoryProvider(widget.account)).defaultEmojis());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("リアクションデッキ"),
        actions: [
          PopupMenuButton(
            onSelected: (type) => switch (type) {
              ReactionDeckPageMenuType.addMany =>
                showAddReactionsDialog(context: context),
              ReactionDeckPageMenuType.copy => copyReactions(context: context),
              ReactionDeckPageMenuType.clear =>
                clearReactions(context: context),
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: ReactionDeckPageMenuType.addMany,
                child: Text("一括追加"),
              ),
              PopupMenuItem(
                value: ReactionDeckPageMenuType.clear,
                child: Text("クリア"),
              ),
              PopupMenuItem(
                value: ReactionDeckPageMenuType.copy,
                child: Text("コピー"),
              ),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ReorderableWrap(
                      scrollPhysics: const NeverScrollableScrollPhysics(),
                      spacing: 5,
                      runSpacing: 5,
                      children: [
                        for (final reaction in reactions)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                reactions.remove(reaction);
                                save();
                              });
                            },
                            child: CustomEmoji(
                              emojiData: reaction,
                              fontSizeRatio: 2,
                              isAttachTooltip: false,
                            ),
                          )
                      ],
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          final element = reactions.removeAt(oldIndex);
                          reactions.insert(newIndex, element);
                          save();
                        });
                      }),
                ),
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        final reaction = await showDialog<MisskeyEmojiData?>(
                          context: context,
                          builder: (context) => ReactionPickerDialog(
                            account: widget.account,
                            isAcceptSensitive: true,
                          ),
                        );
                        if (reaction == null) return;
                        if (reactions.any(
                          (element) => element.baseName == reaction.baseName,
                        )) {
                          // already added.
                          return;
                        }
                        setState(() {
                          reactions.add(reaction);
                          save();
                        });
                      },
                      icon: const Icon(Icons.add)),
                  const Expanded(child: Text("長押しして並び変え、押して削除、＋を押して追加します。"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showAddReactionsDialog({required BuildContext context}) async {
    final emojiNames = await showDialog<List<String>>(
      context: context,
      builder: (context) => AddReactionsDialog(account: widget.account),
    );
    if (emojiNames == null) {
      return;
    }
    final emojis = emojiNames
        .map(
          (emojiName) => MisskeyEmojiData.fromEmojiName(
            emojiName: emojiName,
            repository: ref.watch(emojiRepositoryProvider(widget.account)),
          ),
        )
        .where((emoji) => emoji.runtimeType != NotEmojiData)
        .where(
          (emoji) => !reactions.any(
            (element) => element.baseName == emoji.baseName,
          ),
        );
    setState(() {
      reactions.addAll(emojis);
      save();
    });
  }

  void copyReactions({required BuildContext context}) {
    Clipboard.setData(
      ClipboardData(
        text: JSON5.stringify(
          reactions
              .map(
                (reaction) => switch (reaction) {
                  UnicodeEmojiData(char: final char) => char,
                  CustomEmojiData(hostedName: final name) => name,
                  NotEmojiData() => null,
                },
              )
              .whereNotNull()
              .toList(),
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("コピーしました")),
    );
  }

  Future<void> clearReactions({required BuildContext context}) async {
    if (await SimpleConfirmDialog.show(
            context: context,
            message: "すでに設定済みのリアクションデッキをいったんすべてクリアしますか？",
            primary: "クリアする",
            secondary: "やっぱりやめる") ==
        true) {
      setState(() {
        reactions.clear();
        save();
      });
    }
  }
}
