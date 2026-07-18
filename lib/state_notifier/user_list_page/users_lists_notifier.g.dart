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
    extends $AsyncNotifierProvider<UsersListsNotifier, List<UsersList>> {
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
    r'b91fce466402982f81c4c6c22727bae1ed3c7d28';

abstract class _$UsersListsNotifier extends $AsyncNotifier<List<UsersList>> {
  FutureOr<List<UsersList>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<UsersList>>, List<UsersList>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<UsersList>>, List<UsersList>>,
              AsyncValue<List<UsersList>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
