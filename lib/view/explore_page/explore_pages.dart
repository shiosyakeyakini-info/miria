import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/futable_list_builder.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";

class ExplorePages extends ConsumerWidget {
  const ExplorePages({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: FutureListView(
        future: () async {
          final result =
              await ref.read(misskeyGetContextProvider).pages.featured();
          return result.toList();
        }(),
        builder: (context, item) {
          return ListTile(
            onTap: () async {
              await context.pushRoute(
                MisskeyRouteRoute(
                  accountContext: ref.read(accountContextProvider),
                  page: item,
                ),
              );
            },
            title: MfmText(
              mfmText: item.title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: MfmText(mfmText: item.summary ?? ""),
          );
        },
      ),
    );
  }
}
