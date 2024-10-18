import "package:flutter/widgets.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";

class AccountContextScope extends ConsumerWidget {
  final AccountContext context;
  final Widget child;

  const AccountContextScope({
    required this.context,
    required this.child,
    super.key,
  });

  factory AccountContextScope.as({
    required Account account,
    required Widget child,
  }) =>
      AccountContextScope(context: AccountContext.as(account), child: child);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        accountContextProvider.overrideWithValue(this.context),
      ],
      child: child,
    );
  }
}
