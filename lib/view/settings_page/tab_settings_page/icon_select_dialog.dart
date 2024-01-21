import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/tab_icon.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/reaction_picker_dialog/reaction_picker_content.dart';

class IconSelectDialog extends StatelessWidget {
  final icons = [
    Icons.home,
    Icons.home_outlined,
    Icons.favorite,
    Icons.favorite_border,
    Icons.star,
    Icons.star_outline,
    Icons.public,
    Icons.south_america,
    Icons.rocket,
    Icons.rocket_outlined,
    Icons.rocket_launch,
    Icons.rocket_launch_outlined,
    Icons.bookmark,
    Icons.bookmark_outline,
    Icons.hub,
    Icons.hub_outlined,
    Icons.settings_input_antenna,
    Icons.list,
    Icons.format_list_bulleted,
    Icons.feed,
    Icons.feed_outlined,
    Icons.chat,
    Icons.chat_outlined,
    Icons.chat_bubble,
    Icons.chat_bubble_outline,
    Icons.notifications,
    Icons.diversity_1,
    Icons.diversity_1_outlined,
    Icons.diversity_2,
    Icons.diversity_2_outlined,
    Icons.diversity_3,
    Icons.diversity_3_outlined,
    Icons.person,
    Icons.face,
    Icons.sentiment_neutral,
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_satisfied,
    Icons.sentiment_very_satisfied,
    Icons.mood_bad,
    Icons.mood,
    Icons.face,
    Icons.face_2,
    Icons.face_3,
    Icons.face_4,
    Icons.face_5,
    Icons.face_6,
    Icons.person,
    Icons.person_2,
    Icons.person_3,
    Icons.person_4,
    Icons.sick,
    Icons.sick_outlined,
    Icons.cruelty_free,
    Icons.cruelty_free_outlined,
    Icons.psychology,
    Icons.psychology_alt,
    Icons.bolt,
    Icons.electric_bolt,
    Icons.offline_bolt,
    Icons.offline_bolt_outlined,
    Icons.dataset,
    Icons.dataset_outlined,
    Icons.diamond,
    Icons.diamond_outlined,
  ];

  final Account account;

  IconSelectDialog({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(S.of(context).selectIcon),
        content: DefaultTabController(
            length: 2,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: DecoratedBox(
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor),
                      child: TabBar(
                        tabs: [
                          Tab(text: S.of(context).standardIcon),
                          Tab(text: S.of(context).emojiIcon),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(children: [
                      SingleChildScrollView(
                        child: Wrap(
                          children: [
                            for (final icon in icons)
                              IconButton(
                                  onPressed: () => Navigator.of(context)
                                      .pop(TabIcon(codePoint: icon.codePoint)),
                                  icon: Icon(icon)),
                          ],
                        ),
                      ),
                      AccountScope(
                        account: account,
                        child: ReactionPickerContent(
                          isAcceptSensitive: true,
                          onTap: (emoji) => Navigator.of(context)
                              .pop(TabIcon(customEmojiName: emoji.baseName)),
                        ),
                      )
                    ]),
                  )
                ],
              ),
            )));
  }
}
