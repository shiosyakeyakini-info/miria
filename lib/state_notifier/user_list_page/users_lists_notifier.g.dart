// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_lists_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(UsersListsNotifier)
const usersListsNotifierProvider = UsersListsNotifierProvider._();

final class UsersListsNotifierProvider
    extends $AsyncNotifierProvider<UsersListsNotifier, List<UsersList>> {
  const UsersListsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'usersListsNotifierProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          UsersListsNotifierProvider.$allTransitiveDependencies0,
          UsersListsNotifierProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = misskeyPostContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$usersListsNotifierHash();

  @$internal
  @override
  UsersListsNotifier create() => UsersListsNotifier();
}

String _$usersListsNotifierHash() =>
    r'd8f28e45536ef11dd70dce5cd805d58fa8baf02c';

abstract class _$UsersListsNotifier extends $AsyncNotifier<List<UsersList>> {
  FutureOr<List<UsersList>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<UsersList>>, List<UsersList>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<UsersList>>, List<UsersList>>,
              AsyncValue<List<UsersList>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
