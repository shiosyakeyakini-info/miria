import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:miria/view/common/misskey_server_list.dart";

@RoutePage<String>()
class MisskeyServerListDialog extends StatelessWidget {
  const MisskeyServerListDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).chooseLoginServer),
      content: SizedBox(
        width: double.maxFinite,
        child: MisskeyServerList(
          isDisableUnloginable: true,
          onTap: (item) async => context.maybePop(item.url),
        ),
      ),
    );
  }
}
