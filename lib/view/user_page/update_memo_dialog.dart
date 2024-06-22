import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/view/user_page/user_info_notifier.dart";

@RoutePage()
class UpdateMemoDialog extends HookConsumerWidget {
  final Account account;
  final String initialMemo;
  final String userId;

  const UpdateMemoDialog({
    required this.account,
    required this.initialMemo,
    required this.userId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: initialMemo);

    return AlertDialog(
      title: Text(S.of(context).memo),
      content: TextField(
        controller: controller,
        maxLines: null,
        decoration: InputDecoration(
          hintText: S.of(context).memoDescription,
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () async => context.maybePop(),
          child: Text(S.of(context).cancel),
        ),
        ElevatedButton(
          onPressed: () async => ref
              .read(userInfoNotifierProvider(userId).notifier)
              .updateMemo(controller.text),
          child: Text(S.of(context).save),
        ),
      ],
    );
  }
}
