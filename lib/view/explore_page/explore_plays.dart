import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/futable_list_builder.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:url_launcher/url_launcher.dart";

class ExplorePlay extends ConsumerWidget {
  const ExplorePlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: FutureListView(
        future: () async {
          final result =
              await ref.read(misskeyGetContextProvider).flash.featured();
          return result.toList();
        }(),
        builder: (context, item) {
          return ListTile(
            onTap: () async {
              await launchUrl(
                Uri(
                  scheme: "https",
                  host: ref.read(accountContextProvider).getAccount.host,
                  pathSegments: ["play", item.id],
                ),
                mode: LaunchMode.externalApplication,
              );
            },
            title: MfmText(
              mfmText: item.title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: MfmText(mfmText: item.summary),
          );
        },
      ),
    );
  }
}
