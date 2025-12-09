// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'muted_users_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MutedUsersNotifier)
const mutedUsersProvider = MutedUsersNotifierProvider._();

final class MutedUsersNotifierProvider
    extends $AsyncNotifierProvider<MutedUsersNotifier, List<Muting>> {
  const MutedUsersNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mutedUsersProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          MutedUsersNotifierProvider.$allTransitiveDependencies0,
          MutedUsersNotifierProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = misskeyPostContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$mutedUsersNotifierHash();

  @$internal
  @override
  MutedUsersNotifier create() => MutedUsersNotifier();
}

String _$mutedUsersNotifierHash() =>
    r'af426139b90ee8d96ed0417173a9255d42fc10ac';

abstract class _$MutedUsersNotifier extends $AsyncNotifier<List<Muting>> {
  FutureOr<List<Muting>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Muting>>, List<Muting>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Muting>>, List<Muting>>,
              AsyncValue<List<Muting>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
