import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        child: FutureListView<JoinMisskeyInstanceInfo>(
          future: () async {
            final instances =
                await JoinMisskey(host: "instanceapp.misskey.page").instances();
            return instances.instancesInfos;
          }(),
          builder: (context, item) {
            final description = item.description?.replaceAll(
                    RegExp(r"""<("[^"]*"|'[^']*'|[^'">])*>"""), "") ??
                "";

            return Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Ink(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(item.url);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).dividerColor)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (item.icon)
                              Padding(
                                padding: EdgeInsets.only(right: 10),
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
