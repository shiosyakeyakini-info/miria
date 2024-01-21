import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/futable_list_builder.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:miria/view/common/misskey_notes/network_image.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExploreRole extends ConsumerWidget {
  const ExploreRole({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: FutureListView<RolesListResponse>(
          future: () async {
            final response = await ref
                .read(misskeyProvider(AccountScope.of(context)))
                .roles
                .list();

            return response
                .where((element) => element.usersCount != 0)
                .sorted((a, b) => b.displayOrder.compareTo(a.displayOrder));
          }(),
          builder: (context, item) => RoleListItem(item: item)),
    );
  }
}

class RoleListItem extends StatelessWidget {
  final RolesListResponse item;

  const RoleListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final iconHeight = MediaQuery.textScalerOf(context)
        .scale(Theme.of(context).textTheme.bodyMedium!.fontSize!);

    return ListTile(
      onTap: () {
        context.pushRoute(ExploreRoleUsersRoute(
            item: item, account: AccountScope.of(context)));
      },
      title: Text.rich(
        TextSpan(children: [
          if (item.iconUrl != null)
            WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: NetworkImageView(
                      height: iconHeight,
                      loadingBuilder: (context, _, __) => SizedBox(
                            width: iconHeight,
                            height: iconHeight,
                          ),
                      errorBuilder: (context, e, s) => const SizedBox(
                            width: 1,
                            height: 1,
                          ),
                      url: item.iconUrl!.toString(),
                      type: ImageType.avatarIcon),
                )),
          TextSpan(text: item.name),
        ]),
      ),
      subtitle: Text(item.description ?? ""),
      trailing:
          MfmText(mfmText: S.of(context).allocatedRolesCount(item.usersCount)),
    );
  }
}
