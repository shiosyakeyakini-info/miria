import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/hooks/use_async.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:miria/view/common/sending_elevated_button.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class AbuseDialog extends HookConsumerWidget implements AutoRouteWrapper {
  final Account account;
  final User targetUser;
  final String? defaultText;

  const AbuseDialog({
    required this.account,
    required this.targetUser,
    super.key,
    this.defaultText,
  });

  @override
  Widget wrappedRoute(BuildContext context) => AccountContextScope.as(
        account: account,
        child: this,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: defaultText);

    final abuse = useHandledFuture(() async {
      await ref.read(misskeyPostContextProvider).users.reportAbuse(
            UsersReportAbuseRequest(
              userId: targetUser.id,
              comment: controller.text,
            ),
          );
      await ref.read(dialogStateNotifierProvider.notifier).showSimpleDialog(
            message: (context) => S.of(context).thanksForReport,
          );
      await ref.read(appRouterProvider).maybePop();
    });

    return AlertDialog(
      title: SimpleMfmText(
        S.of(context).reportAbuseOf(targetUser.name ?? targetUser.username),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).detail),
            TextField(
              controller: controller,
              maxLines: null,
              minLines: 5,
              autofocus: true,
            ),
            Text(
              S.of(context).pleaseInputReasonWhyAbuse,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      actions: [
        switch (abuse.value) {
          AsyncLoading() => const SendingElevatedButton(),
          _ => ElevatedButton(
              onPressed: () async => abuse.execute(),
              child: Text(S.of(context).reportAbuse),
            ),
        },
      ],
    );
  }
}
