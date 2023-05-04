import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_misskey_app/model/account.dart';

class AccountScope extends InheritedWidget {
  final Account account;

  const AccountScope({
    super.key,
    required this.account,
    required super.child,
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
