// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'explore_users.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_pinnedUser)
const _pinnedUserProvider = _PinnedUserProvider._();

final class _PinnedUserProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserDetailed>>,
          List<UserDetailed>,
          FutureOr<List<UserDetailed>>
        >
    with
        $FutureModifier<List<UserDetailed>>,
        $FutureProvider<List<UserDetailed>> {
  const _PinnedUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_pinnedUserProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[misskeyGetContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          _PinnedUserProvider.$allTransitiveDependencies0,
          _PinnedUserProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = misskeyGetContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyGetContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$_pinnedUserHash();

  @$internal
  @override
  $FutureProviderElement<List<UserDetailed>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UserDetailed>> create(Ref ref) {
    return _pinnedUser(ref);
  }
}

String _$_pinnedUserHash() => r'bc9d937e7e437c825d643641c24715a4d5762f89';
