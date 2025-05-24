// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'antenna_select_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(_antennas)
const _antennasProvider = _AntennasProvider._();

final class _AntennasProvider
    extends
        $FunctionalProvider<AsyncValue<List<Antenna>>, FutureOr<List<Antenna>>>
    with $FutureModifier<List<Antenna>>, $FutureProvider<List<Antenna>> {
  const _AntennasProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_antennasProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[misskeyGetContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          _AntennasProvider.$allTransitiveDependencies0,
          _AntennasProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = misskeyGetContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyGetContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$antennasHash();

  @$internal
  @override
  $FutureProviderElement<List<Antenna>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Antenna>> create(Ref ref) {
    return _antennas(ref);
  }
}

String _$antennasHash() => r'789e8f8a722a66e9c9270594c9307d9257a14936';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
