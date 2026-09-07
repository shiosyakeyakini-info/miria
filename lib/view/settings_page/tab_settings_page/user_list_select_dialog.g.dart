// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_list_select_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_usersList)
final _usersListProvider = _UsersListProvider._();

final class _UsersListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserList>>,
          List<UserList>,
          FutureOr<List<UserList>>
        >
    with $FutureModifier<List<UserList>>, $FutureProvider<List<UserList>> {
  _UsersListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_usersListProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[misskeyGetContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          _UsersListProvider.$allTransitiveDependencies0,
          _UsersListProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = misskeyGetContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyGetContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$_usersListHash();

  @$internal
  @override
  $FutureProviderElement<List<UserList>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UserList>> create(Ref ref) {
    return _usersList(ref);
  }
}

String _$_usersListHash() => r'f522f46249c0dd3d131d35ad92e867de78d1fb57';
