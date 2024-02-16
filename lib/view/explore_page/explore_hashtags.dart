import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/futable_list_builder.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:miria/view/themes/app_theme.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExploreHashtags extends ConsumerStatefulWidget {
  const ExploreHashtags({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ExploreHashtagsState();
}

enum HashtagListType {
  localTrend,
  local,
  remote,
}

class ExploreHashtagsState extends ConsumerState<ExploreHashtags> {
  var hashtagListType = HashtagListType.localTrend;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 3, bottom: 3),
            child: LayoutBuilder(
                builder: (context, constraints) => ToggleButtons(
                        constraints: BoxConstraints.expand(
                            width: constraints.maxWidth / 3 -
                                Theme.of(context)
                                        .toggleButtonsTheme
                                        .borderWidth!
                                        .toInt() *
                                    3),
                        onPressed: (index) => setState(() {
                              hashtagListType = HashtagListType.values[index];
                            }),
                        isSelected: [
                          for (final element in HashtagListType.values)
                            element == hashtagListType
                        ],
                        children: [
                          Text(S.of(context).trend),
                          Text(S.of(context).local),
                          Text(S.of(context).remote),
                        ]))),
        if (hashtagListType == HashtagListType.localTrend)
          Expanded(
            child: FutureListView(
                future: ref
                    .read(misskeyProvider(AccountScope.of(context)))
                    .hashtags
                    .trend(),
                builder: (context, item) =>
                    Hashtag(hashtag: item.tag, usersCount: item.usersCount)),
          ),
        if (hashtagListType == HashtagListType.local)
          Expanded(
            child: FutureListView(
                future: ref
                    .read(misskeyProvider(AccountScope.of(context)))
                    .hashtags
                    .list(const HashtagsListRequest(
                        limit: 50,
                        attachedToLocalUserOnly: true,
                        sort:
                            HashtagsListSortType.attachedLocalUsersDescendant)),
                builder: (context, item) => Hashtag(
                    hashtag: item.tag,
                    usersCount: item.attachedLocalUsersCount)),
          ),
        if (hashtagListType == HashtagListType.remote)
          Expanded(
            child: FutureListView(
                future: ref
                    .read(misskeyProvider(AccountScope.of(context)))
                    .hashtags
                    .list(const HashtagsListRequest(
                        limit: 50,
                        attachedToRemoteUserOnly: true,
                        sort: HashtagsListSortType
                            .attachedRemoteUsersDescendant)),
                builder: (context, item) => Hashtag(
                    hashtag: item.tag,
                    usersCount: item.attachedRemoteUsersCount)),
          ),
      ],
    );
  }
}

class Hashtag extends StatelessWidget {
  final String hashtag;
  final int usersCount;

  const Hashtag({super.key, required this.hashtag, required this.usersCount});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.pushRoute(
          HashtagRoute(hashtag: hashtag, account: AccountScope.of(context))),
      title: Text("#$hashtag", style: AppTheme.of(context).hashtagStyle),
      trailing: MfmText(mfmText: S.of(context).joiningHashtagUsers(usersCount)),
    );
  }
}
