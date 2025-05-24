// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_list_select_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(_usersList)
const _usersListProvider = _UsersListProvider._();

final class _UsersListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UsersList>>,
          FutureOr<List<UsersList>>
        >
    with $FutureModifier<List<UsersList>>, $FutureProvider<List<UsersList>> {
  const _UsersListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_usersListProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[misskeyGetContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          _UsersListProvider.$allTransitiveDependencies0,
          _UsersListProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = misskeyGetContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyGetContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$usersListHash();

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

String _$usersListHash() => r'd7fab580bf6bc18fc282743de3d482f5d1d62a49';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
