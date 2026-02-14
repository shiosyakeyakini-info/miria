// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'antenna_select_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_antennas)
final _antennasProvider = _AntennasProvider._();

final class _AntennasProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Antenna>>,
          List<Antenna>,
          FutureOr<List<Antenna>>
        >
    with $FutureModifier<List<Antenna>>, $FutureProvider<List<Antenna>> {
  _AntennasProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_antennasProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[misskeyGetContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          _AntennasProvider.$allTransitiveDependencies0,
          _AntennasProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = misskeyGetContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyGetContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$_antennasHash();

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

String _$_antennasHash() => r'789e8f8a722a66e9c9270594c9307d9257a14936';
