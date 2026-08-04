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
          AsyncValue<List<UsersList>>,
          List<UsersList>,
          FutureOr<List<UsersList>>
        >
    with $FutureModifier<List<UsersList>>, $FutureProvider<List<UsersList>> {
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
  $FutureProviderElement<List<UsersList>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UsersList>> create(Ref ref) {
    return _usersList(ref);
  }
}

String _$_usersListHash() => r'd7fab580bf6bc18fc282743de3d482f5d1d62a49';
