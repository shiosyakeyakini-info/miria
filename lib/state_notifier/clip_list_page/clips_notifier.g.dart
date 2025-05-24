// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clips_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(ClipsNotifier)
const clipsNotifierProvider = ClipsNotifierProvider._();

final class ClipsNotifierProvider
    extends $AsyncNotifierProvider<ClipsNotifier, List<Clip>> {
  const ClipsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clipsNotifierProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          ClipsNotifierProvider.$allTransitiveDependencies0,
          ClipsNotifierProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = misskeyPostContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$clipsNotifierHash();

  @$internal
  @override
  ClipsNotifier create() => ClipsNotifier();

  @$internal
  @override
  $AsyncNotifierProviderElement<ClipsNotifier, List<Clip>> $createElement(
    $ProviderPointer pointer,
  ) => $AsyncNotifierProviderElement(pointer);
}

String _$clipsNotifierHash() => r'd2e5c8f6a083dbe75bb63070550f16728c7dde5d';

abstract class _$ClipsNotifier extends $AsyncNotifier<List<Clip>> {
  FutureOr<List<Clip>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Clip>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Clip>>>,
              AsyncValue<List<Clip>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
