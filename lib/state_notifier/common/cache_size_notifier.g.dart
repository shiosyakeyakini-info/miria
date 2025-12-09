// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_size_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CacheSizeNotifier)
const cacheSizeProvider = CacheSizeNotifierProvider._();

final class CacheSizeNotifierProvider
    extends $AsyncNotifierProvider<CacheSizeNotifier, String> {
  const CacheSizeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cacheSizeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cacheSizeNotifierHash();

  @$internal
  @override
  CacheSizeNotifier create() => CacheSizeNotifier();
}

String _$cacheSizeNotifierHash() => r'ae3072682228591dbdcfa4228ea8afc5e9bc9f4f';

abstract class _$CacheSizeNotifier extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
