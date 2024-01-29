import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/avatar_icon.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserListItem extends ConsumerWidget {
  final User user;
  final bool isDetail;

  final void Function()? onTap;

  const UserListItem({
    super.key,
    required this.user,
    this.onTap,
    this.isDetail = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap ??
          () => context.pushRoute(
              UserRoute(userId: user.id, account: AccountScope.of(context))),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AvatarIcon(user: user),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserInformation(user: user),
                    Text(
                      "@${user.username}${user.host != null ? "@${user.host}" : ""}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (user is UserDetailedNotMeWithRelations && isDetail)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Wrap(
                          alignment: WrapAlignment.end,
                          runAlignment: WrapAlignment.end,
                          runSpacing: 5.0,
                          spacing: 5.0,
                          children: [
                            if ((user as UserDetailedNotMeWithRelations)
                                .isFollowing)
                              Text(
                                S.of(context).following,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            if ((user as UserDetailedNotMeWithRelations)
                                .isFollowed)
                              Text(
                                S.of(context).followed,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            if ((user as UserDetailedNotMeWithRelations)
                                .isMuted)
                              Text(
                                " ${S.of(context).muting} ",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            if ((user as UserDetailedNotMeWithRelations)
                                .isBlocking)
                              Text(
                                " ${S.of(context).blocking} ",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                          ],
                        ),
                      ),
                    if (user is UserDetailed && isDetail)
                      MfmText(
                        mfmText: (user as UserDetailed).description ?? "",
                        emoji: user.emojis,
                        maxLines: 5,
                      )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
