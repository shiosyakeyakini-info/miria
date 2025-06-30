// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_size_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(CacheSizeNotifier)
const cacheSizeNotifierProvider = CacheSizeNotifierProvider._();

final class CacheSizeNotifierProvider
    extends $AsyncNotifierProvider<CacheSizeNotifier, String> {
  const CacheSizeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cacheSizeNotifierProvider',
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

String _$cacheSizeNotifierHash() => r'b24913c827247481c1679e444826e724830a2bb7';

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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
