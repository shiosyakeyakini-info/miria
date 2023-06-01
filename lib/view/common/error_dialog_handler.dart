import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
//TODO: 微妙な方法

extension FutureExtension<T> on Future<T> {
  Future<T> expectFailure(BuildContext context) {
    return catchError((e) {
      final widgetRef = ProviderScope.containerOf(context, listen: false);

      widgetRef.read(errorEventProvider.notifier).state = (e, context);
    });
  }
}

extension FutureFunctionExtension<T> on Future<T> Function() {
  Future<T> Function() expectFailure(BuildContext context) {
    return () => this.call().catchError((e) {
          final widgetRef = ProviderScope.containerOf(context, listen: false);

          widgetRef.read(errorEventProvider.notifier).state = (e, context);
        });
  }
}
