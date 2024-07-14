import "package:auto_route/auto_route.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/futable_list_builder.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:miria/view/common/misskey_notes/network_image.dart";
import "package:misskey_dart/misskey_dart.dart";

class ExploreRole extends ConsumerWidget {
  const ExploreRole({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: FutureListView<RolesListResponse>(
        future: Future(() async {
          final response =
              await ref.read(misskeyGetContextProvider).roles.list();

          return response
              .where((element) => element.usersCount != 0)
              .sorted((a, b) => b.displayOrder.compareTo(a.displayOrder));
        }),
        builder: (context, item) => RoleListItem(item: item),
      ),
    );
  }
}

class RoleListItem extends ConsumerWidget {
  final RolesListResponse item;

  const RoleListItem({required this.item, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconHeight = MediaQuery.textScalerOf(context)
        .scale(Theme.of(context).textTheme.bodyMedium!.fontSize!);

    return ListTile(
      onTap: () async {
        await context.pushRoute(
          ExploreRoleUsersRoute(
            item: item,
            accountContext: ref.read(accountContextProvider),
          ),
        );
      },
      title: Text.rich(
        TextSpan(
          children: [
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
                    type: ImageType.avatarIcon,
                  ),
                ),
              ),
            TextSpan(text: item.name),
          ],
        ),
      ),
      subtitle: Text(item.description ?? ""),
      trailing:
          MfmText(mfmText: S.of(context).allocatedRolesCount(item.usersCount)),
    );
  }
}
