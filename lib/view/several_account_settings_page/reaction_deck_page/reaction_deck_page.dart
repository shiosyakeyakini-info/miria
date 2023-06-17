import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/account_settings.dart';
import 'package:miria/model/misskey_emoji_data.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/misskey_notes/custom_emoji.dart';
import 'package:miria/view/reaction_picker_dialog/reaction_picker_dialog.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:reorderables/reorderables.dart';

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
    ref.read(accountSettingsRepositoryProvider).save(AccountSettings(
        userId: widget.account.userId,
        host: widget.account.host,
        reactions: reactions.map((e) => e.baseName).toList()));
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
      appBar: AppBar(title: const Text("リアクションデッキ")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(10),
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
                                ));
                        if (reaction == null) return;
                        if (reactions.any((element) =>
                            element.baseName == reaction.baseName)) {
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
}
