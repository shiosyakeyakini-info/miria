import "package:flutter/widgets.dart";
import "package:miria/model/account.dart";

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
