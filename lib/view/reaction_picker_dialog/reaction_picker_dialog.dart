import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/reaction_picker_dialog/reaction_picker_content.dart";

@RoutePage()
class ReactionPickerDialog extends ConsumerWidget implements AutoRouteWrapper {
  final Account account;
  final bool isAcceptSensitive;

  const ReactionPickerDialog({
    required this.account,
    required this.isAcceptSensitive,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(5),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        child: ReactionPickerContent(
          isAcceptSensitive: isAcceptSensitive,
          onTap: (emoji) => Navigator.of(context).pop(emoji),
        ),
      ),
    );
  }
}
