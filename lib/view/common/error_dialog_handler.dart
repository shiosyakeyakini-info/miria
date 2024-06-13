import "package:flutter/cupertino.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
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
      final widgetRef = ProviderScope.containerOf(context, listen: false);

      widgetRef.read(errorEventProvider.notifier).state = (e, context);
    });
  }
}

extension FutureFunctionExtension<T> on Future<T> Function() {
  @Deprecated("use `dialogStateNotifier`")
  Future<T> Function() expectFailure(BuildContext context) {
    return () => this.call().catchError((e) {
          final widgetRef = ProviderScope.containerOf(context, listen: false);

          widgetRef.read(errorEventProvider.notifier).state = (e, context);
        });
  }
}
