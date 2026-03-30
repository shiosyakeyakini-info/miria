// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(storage)
const storageProvider = StorageProvider._();

final class StorageProvider
    extends
        $FunctionalProvider<
          AsyncValue<LegacyJsonSharedPreferencesStorage>,
          LegacyJsonSharedPreferencesStorage,
          FutureOr<LegacyJsonSharedPreferencesStorage>
        >
    with
        $FutureModifier<LegacyJsonSharedPreferencesStorage>,
        $FutureProvider<LegacyJsonSharedPreferencesStorage> {
  const StorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storageHash();

  @$internal
  @override
  $FutureProviderElement<LegacyJsonSharedPreferencesStorage> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LegacyJsonSharedPreferencesStorage> create(Ref ref) {
    return storage(ref);
  }
}

String _$storageHash() => r'f1443925729f6cda188ce89901e16c15c18462c7';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
