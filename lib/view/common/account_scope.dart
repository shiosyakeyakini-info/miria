import "package:flutter/widgets.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";

@Deprecated("Use AccountScopeBuilder")
class AccountScope extends InheritedWidget {
  final Account account;

  const AccountScope({
    required this.account,
    required super.child,
    super.key,
  });

  static Account of(BuildContext context) {
    final account = context.dependOnInheritedWidgetOfExactType<AccountScope>();
    if (account == null) {
      throw Exception("has not ancestor");
    }

    return account.account;
  }

  @override
  bool updateShouldNotify(covariant AccountScope oldWidget) =>
      account != oldWidget.account;
}

//TODO: refactor from AccountScopeMark2 to AccountScope
class AccountScopeMark2 extends ConsumerWidget {
  final Account account;
  final Widget child;

  const AccountScopeMark2({
    required this.account,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        accountContextProvider.overrideWithValue(AccountContext.as(account)),
      ],
      child: child,
    );
  }
}
