import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/futable_list_builder.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:miria/view/themes/app_theme.dart";
import "package:misskey_dart/misskey_dart.dart";

enum HashtagListType {
  localTrend,
  local,
  remote,
}

class ExploreHashtags extends HookConsumerWidget {
  const ExploreHashtags({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hashtagListType = useState(HashtagListType.localTrend);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3, bottom: 3),
          child: LayoutBuilder(
            builder: (context, constraints) => ToggleButtons(
              constraints: BoxConstraints.expand(
                width: constraints.maxWidth / 3 -
                    Theme.of(context).toggleButtonsTheme.borderWidth!.toInt() *
                        3,
              ),
              onPressed: (index) =>
                  hashtagListType.value = HashtagListType.values[index],
              isSelected: [
                for (final element in HashtagListType.values)
                  element == hashtagListType.value,
              ],
              children: [
                Text(S.of(context).trend),
                Text(S.of(context).local),
                Text(S.of(context).remote),
              ],
            ),
          ),
        ),
        switch (hashtagListType.value) {
          HashtagListType.localTrend => Expanded(
              child: FutureListView(
                future: ref.read(misskeyGetContextProvider).hashtags.trend(),
                builder: (context, item) =>
                    Hashtag(hashtag: item.tag, usersCount: item.usersCount),
              ),
            ),
          HashtagListType.local => Expanded(
              child: FutureListView(
                future: ref.read(misskeyGetContextProvider).hashtags.list(
                      const HashtagsListRequest(
                        limit: 50,
                        attachedToLocalUserOnly: true,
                        sort: HashtagsListSortType.attachedLocalUsersDescendant,
                      ),
                    ),
                builder: (context, item) => Hashtag(
                  hashtag: item.tag,
                  usersCount: item.attachedLocalUsersCount,
                ),
              ),
            ),
          HashtagListType.remote => Expanded(
              child: FutureListView(
                future: ref.read(misskeyGetContextProvider).hashtags.list(
                      const HashtagsListRequest(
                        limit: 50,
                        attachedToRemoteUserOnly: true,
                        sort:
                            HashtagsListSortType.attachedRemoteUsersDescendant,
                      ),
                    ),
                builder: (context, item) => Hashtag(
                  hashtag: item.tag,
                  usersCount: item.attachedRemoteUsersCount,
                ),
              ),
            ),
        },
      ],
    );
  }
}

class Hashtag extends ConsumerWidget {
  final String hashtag;
  final int usersCount;

  const Hashtag({required this.hashtag, required this.usersCount, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () async => context.pushRoute(
        HashtagRoute(
          hashtag: hashtag,
          accountContext: ref.read(accountContextProvider),
        ),
      ),
      title: Text("#$hashtag", style: AppTheme.of(context).hashtagStyle),
      trailing: MfmText(mfmText: S.of(context).joiningHashtagUsers(usersCount)),
    );
  }
}
