import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/common/misskey_server_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      title: Text(S.of(context).chooseLoginServer),
      content: SizedBox(
          width: double.maxFinite,
          child: MisskeyServerList(
            isDisableUnloginable: true,
            onTap: (item) => Navigator.of(context).pop(item.url),
          )),
    );
  }
}
