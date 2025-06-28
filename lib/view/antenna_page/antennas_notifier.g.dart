// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'antennas_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(AntennasNotifier)
const antennasNotifierProvider = AntennasNotifierProvider._();

final class AntennasNotifierProvider
    extends $AsyncNotifierProvider<AntennasNotifier, List<Antenna>> {
  const AntennasNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'antennasNotifierProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          AntennasNotifierProvider.$allTransitiveDependencies0,
          AntennasNotifierProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = misskeyPostContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$antennasNotifierHash();

  @$internal
  @override
  AntennasNotifier create() => AntennasNotifier();
}

String _$antennasNotifierHash() => r'0cecb08c54c64bfafc6cc235c2e1e86f3ec237d2';

abstract class _$AntennasNotifier extends $AsyncNotifier<List<Antenna>> {
  FutureOr<List<Antenna>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Antenna>>, List<Antenna>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Antenna>>, List<Antenna>>,
              AsyncValue<List<Antenna>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
