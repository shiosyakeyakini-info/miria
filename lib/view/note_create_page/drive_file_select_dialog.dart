import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";

@RoutePage()
class DriveFileSelectDialog extends HookConsumerWidget
    implements AutoRouteWrapper {
  final AccountContext accountContext;

  const DriveFileSelectDialog({required this.accountContext, super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(child: AutoRouter());
  }
}
