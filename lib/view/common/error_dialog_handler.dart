import "package:flutter/cupertino.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
//TODO: 微妙な方法

class SpecifiedException implements Exception {
  final String message;
  SpecifiedException(this.message);
}

extension FutureExtension<T> on Future<T> {
  @Deprecated("use `dialogStateNotifier`")
  Future<T> expectFailure(BuildContext context) {
    return catchError((e) {
      final Ref = ProviderScope.containerOf(context, listen: false);

      Ref.read(errorEventProvider.notifier).fire(e, context);
    });
  }
}

extension FutureFunctionExtension<T> on Future<T> Function() {
  @Deprecated("use `dialogStateNotifier`")
  Future<T> Function() expectFailure(BuildContext context) {
    return () => this.call().catchError((e) {
      final Ref = ProviderScope.containerOf(context, listen: false);

      Ref.read(errorEventProvider.notifier).fire(e, context);
    });
  }
}
