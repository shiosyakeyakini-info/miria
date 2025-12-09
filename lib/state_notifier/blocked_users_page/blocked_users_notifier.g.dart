// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_users_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BlockedUsersNotifier)
const blockedUsersProvider = BlockedUsersNotifierProvider._();

final class BlockedUsersNotifierProvider
    extends $AsyncNotifierProvider<BlockedUsersNotifier, List<Blocking>> {
  const BlockedUsersNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'blockedUsersProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          BlockedUsersNotifierProvider.$allTransitiveDependencies0,
          BlockedUsersNotifierProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = misskeyPostContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$blockedUsersNotifierHash();

  @$internal
  @override
  BlockedUsersNotifier create() => BlockedUsersNotifier();
}

String _$blockedUsersNotifierHash() =>
    r'eeda8b44b56a947c9e26e01b88cf322d33073c3a';

abstract class _$BlockedUsersNotifier extends $AsyncNotifier<List<Blocking>> {
  FutureOr<List<Blocking>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Blocking>>, List<Blocking>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Blocking>>, List<Blocking>>,
              AsyncValue<List<Blocking>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
