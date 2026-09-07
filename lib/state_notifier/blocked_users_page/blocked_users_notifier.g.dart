// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_users_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BlockedUsersNotifier)
final blockedUsersProvider = BlockedUsersNotifierProvider._();

final class BlockedUsersNotifierProvider
    extends $AsyncNotifierProvider<BlockedUsersNotifier, List<Blocking>> {
  BlockedUsersNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'blockedUsersProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          BlockedUsersNotifierProvider.$allTransitiveDependencies0,
          BlockedUsersNotifierProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = misskeyPostContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$blockedUsersNotifierHash();

  @$internal
  @override
  BlockedUsersNotifier create() => BlockedUsersNotifier();
}

String _$blockedUsersNotifierHash() =>
    r'72402214132a96c9be2427d59d9d493d2d638e64';

abstract class _$BlockedUsersNotifier extends $AsyncNotifier<List<Blocking>> {
  FutureOr<List<Blocking>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Blocking>>, List<Blocking>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Blocking>>, List<Blocking>>,
              AsyncValue<List<Blocking>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
