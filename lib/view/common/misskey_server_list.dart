import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/constants.dart';
import 'package:miria/view/common/error_detail.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MisskeyServerList extends ConsumerWidget {
  final bool isDisableUnloginable;

  final void Function(JoinMisskeyInstanceInfo) onTap;

  const MisskeyServerList({
    super.key,
    this.isDisableUnloginable = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servers = ref.watch(misskeyServerListNotifierProvider);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
              ),
              onChanged:
                  ref.read(misskeyServerListNotifierProvider.notifier).setQuery,
            ),
          ),
          Expanded(
            child: servers.when(
              skipLoadingOnReload: true,
              data: (servers) => ListView.builder(
                itemCount: servers.length,
                itemBuilder: (context, index) {
                  final server = servers[index];
                  final description =
                      server.description?.replaceAll(htmlTagRemove, "") ?? "";
                  final available = !isDisableUnloginable ||
                      server.nodeInfo?.software?.name == "misskey" &&
                          availableServerVersion
                              .allMatches(
                                server.nodeInfo?.software?.version ?? "",
                              )
                              .isNotEmpty;
                  return Padding(
                    key: ValueKey(server.url),
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: available ? () => onTap.call(server) : null,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: available ? null : Colors.grey.withAlpha(160),
                          border:
                              Border.all(color: Theme.of(context).dividerColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (server.icon)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: SizedBox(
                                      width: MediaQuery.textScalerOf(context)
                                          .scale(
                                        Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.fontSize ??
                                            22 * 2,
                                      ),
                                      child: Image.network(
                                        "https://instanceapp.misskey.page/instance-icons/${server.url}.webp",
                                      ),
                                    ),
                                  ),
                                Expanded(child: Text(server.name)),
                              ],
                            ),
                            Text(
                              description,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const Padding(padding: EdgeInsets.only(top: 10)),
                            Text(
                              S.of(context).joiningServerUsers(
                                  server.nodeInfo?.usage?.users?.total ?? 0),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const Padding(padding: EdgeInsets.only(top: 10)),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "${server.nodeInfo?.software?.name ?? ""} ${server.nodeInfo?.software?.version}",
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.right,
                              ),
                            ),
                            if (!available)
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  S.of(context).unsupportedServer,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              error: (e, st) => ErrorDetail(error: e, stackTrace: st),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
