import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:url_launcher/url_launcher.dart";

class PlaySearch extends HookConsumerWidget {
  final FocusNode? focusNode;

  const PlaySearch({super.key, this.focusNode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = useState("");
    final searchController = useTextEditingController();
    final listViewKey = useState(0);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: S.of(context).search,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchQuery.value.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        searchQuery.value = "";
                        listViewKey.value++;
                      },
                    )
                  : null,
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              searchQuery.value = value;
            },
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                listViewKey.value++;
              }
            },
          ),
          const SizedBox(height: 10),
          if (searchQuery.value.trim().isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  S.of(context).search,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: PushableListView<Flash>(
                key: ValueKey(listViewKey.value),
                listKey: "play_search_${searchQuery.value}",
                initializeFuture: () async {
                  final response = await ref
                      .read(misskeyGetContextProvider)
                      .flash
                      .search(FlashSearchRequest(query: searchQuery.value.trim()));
                  return response.toList();
                },
                nextFuture: (_, __) async => [],
                hideIsEmpty: false,
                itemBuilder: (context, play) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: MfmText(
                      mfmText: play.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: play.summary.isNotEmpty
                        ? MfmText(mfmText: play.summary)
                        : null,
                    onTap: () async {
                      await launchUrl(
                        Uri(
                          scheme: "https",
                          host: ref
                              .read(accountContextProvider)
                              .getAccount
                              .host,
                          pathSegments: ["play", play.id],
                        ),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
