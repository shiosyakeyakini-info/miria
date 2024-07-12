import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/hooks/use_async.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/sending_elevated_button.dart";
import "package:miria/view/user_page/user_info_notifier.dart";

@RoutePage()
class UpdateMemoDialog extends HookConsumerWidget implements AutoRouteWrapper {
  final AccountContext accountContext;
  final String initialMemo;
  final String userId;

  const UpdateMemoDialog({
    required this.accountContext,
    required this.initialMemo,
    required this.userId,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) => AccountContextScope(
        context: accountContext,
        child: this,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: initialMemo);
    final updateMemo = useAsync(() async {
      await ref
          .read(userInfoNotifierProxyProvider(userId))
          .updateMemo(controller.text);
      await ref.read(appRouterProvider).maybePop();
    });

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
        switch (updateMemo.value) {
          AsyncLoading() => const SendingElevatedButton(),
          _ => ElevatedButton(
              onPressed: () async => updateMemo.execute(),
              child: Text(S.of(context).save),
            ),
        }
      ],
    );
  }
}
