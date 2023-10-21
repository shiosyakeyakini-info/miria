import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/common/misskey_server_list.dart';

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
