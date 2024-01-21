import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:miria/view/common/pushable_listview.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:url_launcher/url_launcher.dart';

class UserPlays extends ConsumerWidget {
  final String userId;

  const UserPlays({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PushableListView(
      initializeFuture: () async {
        final response = await ref
            .read(misskeyProvider(AccountScope.of(context)))
            .users
            .flashs(UsersFlashsRequest(userId: userId));
        return response.toList();
      },
      nextFuture: (item, _) async {
        final response = await ref
            .read(misskeyProvider(AccountScope.of(context)))
            .users
            .flashs(UsersFlashsRequest(userId: userId, untilId: item.id));
        return response.toList();
      },
      itemBuilder: (context, play) {
        return ListTile(
          title: MfmText(
              mfmText: play.title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          subtitle: MfmText(mfmText: play.summary),
          onTap: () {
            launchUrl(
                Uri(
                    scheme: "https",
                    host: AccountScope.of(context).host,
                    pathSegments: ["play", play.id]),
                mode: LaunchMode.externalApplication);
          },
        );
      },
      additionalErrorInfo: (context, e) {
        return Text(S.of(context).userPlaysAvailability);
      },
    );
  }
}
