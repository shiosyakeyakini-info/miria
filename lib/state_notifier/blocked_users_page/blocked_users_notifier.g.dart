// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_users_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(BlockedUsersNotifier)
const blockedUsersNotifierProvider = BlockedUsersNotifierProvider._();

final class BlockedUsersNotifierProvider
    extends $AsyncNotifierProvider<BlockedUsersNotifier, List<Blocking>> {
  const BlockedUsersNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'blockedUsersNotifierProvider',
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
    r'6d3f93323db181e11627c1ef55a14d7c4b763d00';

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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
