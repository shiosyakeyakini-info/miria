// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'antennas_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AntennasNotifier)
final antennasProvider = AntennasNotifierProvider._();

final class AntennasNotifierProvider
    extends $AsyncNotifierProvider<AntennasNotifier, List<Antenna>> {
  AntennasNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'antennasProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          AntennasNotifierProvider.$allTransitiveDependencies0,
          AntennasNotifierProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = misskeyPostContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$antennasNotifierHash();

  @$internal
  @override
  AntennasNotifier create() => AntennasNotifier();
}

String _$antennasNotifierHash() => r'1747a52298a4d5e8dfdf31bedbdd1e703e9f119c';

abstract class _$AntennasNotifier extends $AsyncNotifier<List<Antenna>> {
  FutureOr<List<Antenna>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Antenna>>, List<Antenna>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Antenna>>, List<Antenna>>,
              AsyncValue<List<Antenna>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
