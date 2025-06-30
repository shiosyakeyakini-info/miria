import "package:miria/util/cache_size.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "cache_size_notifier.g.dart";

@Riverpod()
class CacheSizeNotifier extends _$CacheSizeNotifier {
  @override
  Future<String> build() async {
    return await getCacheSizeWithUnit();
  }

  Future<void> clear() async {
    state = const AsyncValue.loading();
    final size = await clearCache();
    state = AsyncValue.data(size);
  }
}
