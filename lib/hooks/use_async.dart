import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/log.dart";
import "package:miria/view/common/dialog/dialog_state.dart";

class AsyncOperation<T> {
  final AsyncValue<T>? value;
  final Future<void> Function() execute;

  /// onPressed: に渡し、AsyncLoading() のとき非活性に、それ以外のときは活性にするためのユーティリティ
  Future<void> Function()? get executeOrNull =>
      value is AsyncLoading ? null : execute;

  const AsyncOperation({required this.value, required this.execute});
}

AsyncOperation<T> useAsync<T>(Future<T> Function() future) {
  final result = useState<AsyncValue<T>?>(null);

  return AsyncOperation(
    value: result.value,
    execute: () async {
      result.value = const AsyncLoading();

      try {
        final value = await future();
        if (value is AsyncError) throw value.error;
        result.value = AsyncData(value);
      } catch (error, stack) {
        logger
          ..warning(error)
          ..warning(stack);
        result.value = AsyncError(error, stack);
      }
    },
  );
}

AsyncOperation<T> useHandledFuture<T>(Future<T> Function() future) {
  final result = useState<AsyncValue<T>?>(null);
  final ref = ProviderScope.containerOf(useContext());

  return AsyncOperation(
    value: result.value,
    execute: () async {
      result
        ..value = const AsyncLoading()
        ..value = await ref
            .read(dialogStateNotifierProvider.notifier)
            .guard(() async => await future());
    },
  );
}
