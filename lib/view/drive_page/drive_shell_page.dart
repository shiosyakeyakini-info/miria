import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";

@RoutePage()
class DriveShellPage extends StatelessWidget implements AutoRouteWrapper {
  const DriveShellPage({required this.accountContext, super.key});

  final AccountContext accountContext;

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
