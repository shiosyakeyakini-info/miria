// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clips_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ClipsNotifier)
final clipsProvider = ClipsNotifierProvider._();

final class ClipsNotifierProvider
    extends $AsyncNotifierProvider<ClipsNotifier, List<Clip>> {
  ClipsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clipsProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          ClipsNotifierProvider.$allTransitiveDependencies0,
          ClipsNotifierProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = misskeyPostContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$clipsNotifierHash();

  @$internal
  @override
  ClipsNotifier create() => ClipsNotifier();
}

String _$clipsNotifierHash() => r'9ae9dc7380fdef054b33f4ffaf92d2ccc8af4fee';

abstract class _$ClipsNotifier extends $AsyncNotifier<List<Clip>> {
  FutureOr<List<Clip>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Clip>>, List<Clip>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Clip>>, List<Clip>>,
              AsyncValue<List<Clip>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
