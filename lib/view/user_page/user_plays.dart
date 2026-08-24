import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:misskey_dart/misskey_dart.dart";

class UserPlays extends ConsumerWidget {
  final String userId;

  const UserPlays({required this.userId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PushableListView(
      initializeFuture: () async {
        final response = await ref
            .read(misskeyGetContextProvider)
            .users
            .flashs(UsersFlashsRequest(userId: userId));
        return response.toList();
      },
      nextFuture: (item, _) async {
        final response = await ref
            .read(misskeyGetContextProvider)
            .users
            .flashs(UsersFlashsRequest(userId: userId, untilId: item.id));
        return response.toList();
      },
      itemBuilder: (context, play) {
        return ListTile(
          title: MfmText(
            mfmText: play.title,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: MfmText(mfmText: play.summary),
          onTap: () async => context.pushRoute(
            PlayRoute(
              accountContext: ref.read(accountContextProvider),
              flash: play,
            ),
          ),
        );
      },
      additionalErrorInfo: (context, e) {
        return Text(S.of(context).userPlaysAvailability);
      },
    );
  }
}
