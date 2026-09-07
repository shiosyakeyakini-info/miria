// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_lists_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UsersListsNotifier)
final usersListsProvider = UsersListsNotifierProvider._();

final class UsersListsNotifierProvider
    extends $AsyncNotifierProvider<UsersListsNotifier, List<UserList>> {
  UsersListsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'usersListsProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          UsersListsNotifierProvider.$allTransitiveDependencies0,
          UsersListsNotifierProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = misskeyPostContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$usersListsNotifierHash();

  @$internal
  @override
  UsersListsNotifier create() => UsersListsNotifier();
}

String _$usersListsNotifierHash() =>
    r'306a929e892431e5e8f3020063a98b8fa1876379';

abstract class _$UsersListsNotifier extends $AsyncNotifier<List<UserList>> {
  FutureOr<List<UserList>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<UserList>>, List<UserList>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<UserList>>, List<UserList>>,
              AsyncValue<List<UserList>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
