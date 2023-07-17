import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/common/constants.dart';
import 'package:miria/view/common/futable_list_builder.dart';
import 'package:misskey_dart/misskey_dart.dart';

class MisskeyServerListDialog extends ConsumerStatefulWidget {
  const MisskeyServerListDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      MisskeyServerListDialogState();
}

class MisskeyServerListDialogState
    extends ConsumerState<MisskeyServerListDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("ログインするサーバーをえらんでください"),
      content: SizedBox(
          width: double.maxFinite,
          child: MisskeyServerList(
            isDisableUnloginable: true,
            onTap: (item) => Navigator.of(context).pop(item.url),
          )),
    );
  }
}

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
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: FutureListView<JoinMisskeyInstanceInfo>(
          future: () async {
            final instances =
                await JoinMisskey(host: "instanceapp.misskey.page").instances();
            return instances.instancesInfos.toList()
              ..sort((a, b) => (b.nodeInfo?.usage?.users?.total ?? 0)
                  .compareTo((a.nodeInfo?.usage?.users?.total ?? 0)));
          }(),
          builder: (context, item) {
            final description =
                item.description?.replaceAll(htmlTagRemove, "") ?? "";
            final available = !isDisableUnloginable ||
                item.nodeInfo?.software?.name == "misskey" &&
                    availableServerVersion
                        .allMatches(item.nodeInfo?.software?.version ?? "")
                        .isNotEmpty;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Ink(
                child: GestureDetector(
                  onTap: available ? () => onTap.call(item) : null,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: available ? null : Colors.grey.withAlpha(160),
                        border:
                            Border.all(color: Theme.of(context).dividerColor)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            if (item.icon)
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SizedBox(
                                  width: (Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.fontSize ??
                                          22) *
                                      MediaQuery.of(context).textScaleFactor *
                                      2,
                                  child: Image.network(
                                      "https://instanceapp.misskey.page/instance-icons/${item.url}.webp"),
                                ),
                              ),
                            Expanded(child: Text(item.name)),
                          ],
                        ),
                        Text(
                          description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        Text(
                          "${item.nodeInfo?.usage?.users?.total?.format()}人が参加中",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${item.nodeInfo?.software?.name ?? ""} ${item.nodeInfo?.software?.version}",
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.right,
                          ),
                        ),
                        if (!available)
                          Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "非対応のサーバーです",
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.right,
                              ))
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
