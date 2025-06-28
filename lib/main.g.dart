// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(miriaWindowListener)
const miriaWindowListenerProvider = MiriaWindowListenerProvider._();

final class MiriaWindowListenerProvider
    extends
        $FunctionalProvider<
          MiriaWindowListener,
          MiriaWindowListener,
          MiriaWindowListener
        >
    with $Provider<MiriaWindowListener> {
  const MiriaWindowListenerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'miriaWindowListenerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$miriaWindowListenerHash();

  @$internal
  @override
  $ProviderElement<MiriaWindowListener> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MiriaWindowListener create(Ref ref) {
    return miriaWindowListener(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MiriaWindowListener value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MiriaWindowListener>(value),
    );
  }
}

String _$miriaWindowListenerHash() =>
    r'6d4369e18b29741bbcbe3f3a7e9e6b44e3136403';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
