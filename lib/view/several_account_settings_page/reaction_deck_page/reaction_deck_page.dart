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
import 'package:misskey_dart/misskey_dart.dart';
import 'package:reorderables/reorderables.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        title: Text(S.of(context).reactionDeck),
        actions: [
          PopupMenuButton(
            onSelected: (type) => switch (type) {
              ReactionDeckPageMenuType.addMany =>
                showAddReactionsDialog(context: context),
              ReactionDeckPageMenuType.copy => copyReactions(context: context),
              ReactionDeckPageMenuType.clear =>
                clearReactions(context: context),
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: ReactionDeckPageMenuType.addMany,
                child: Text(S.of(context).bulkAddReactions),
              ),
              PopupMenuItem(
                value: ReactionDeckPageMenuType.clear,
                child: Text(S.of(context).clear),
              ),
              PopupMenuItem(
                value: ReactionDeckPageMenuType.copy,
                child: Text(S.of(context).copy),
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
                    icon: const Icon(Icons.add),
                  ),
                  Expanded(
                    child: Text(S.of(context).editReactionDeckDescription),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showAddReactionsDialog({required BuildContext context}) async {
    try {
      final reactions =
          await ref.read(misskeyProvider(widget.account)).i.registry.getDetail(
                const IRegistryGetDetailRequest(
                  scope: ["client", "base"],
                  key: "reactions",
                  domain: null,
                ),
              );

      print(reactions);
    } catch (e) {
      final endpoints =
          await ref.read(misskeyProvider(widget.account)).endpoints();
      final domain =
          endpoints.contains("i/registry/scopes-with-domain") ? "@" : "system";
      if (!mounted) return;
      final emojiNames = await showDialog<List<String>>(
        context: context,
        builder: (context) => AddReactionsDialog(
          account: widget.account,
          domain: domain,
        ),
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
      SnackBar(content: Text(S.of(context).doneCopy)),
    );
  }

  Future<void> clearReactions({required BuildContext context}) async {
    if (await SimpleConfirmDialog.show(
          context: context,
          message: S.of(context).confirmClearReactionDeck,
          primary: S.of(context).clearReactionDeck,
          secondary: S.of(context).cancel,
        ) ==
        true) {
      setState(() {
        reactions.clear();
        save();
      });
    }
  }
}
