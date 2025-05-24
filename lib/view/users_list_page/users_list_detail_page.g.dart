// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_list_detail_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(_UsersListNotifier)
const _usersListNotifierProvider = _UsersListNotifierFamily._();

final class _UsersListNotifierProvider
    extends $AsyncNotifierProvider<_UsersListNotifier, UsersList> {
  const _UsersListNotifierProvider._({
    required _UsersListNotifierFamily super.from,
    required (Misskey, String) super.argument,
  }) : super(
         retry: null,
         name: r'_usersListNotifierProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$usersListNotifierHash();

  @override
  String toString() {
    return r'_usersListNotifierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  _UsersListNotifier create() => _UsersListNotifier();

  @$internal
  @override
  $AsyncNotifierProviderElement<_UsersListNotifier, UsersList> $createElement(
    $ProviderPointer pointer,
  ) => $AsyncNotifierProviderElement(pointer);

  @override
  bool operator ==(Object other) {
    return other is _UsersListNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$usersListNotifierHash() => r'0e4dc8a0b45ed3330d072d3131094be80a0578fa';

final class _UsersListNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          _UsersListNotifier,
          AsyncValue<UsersList>,
          UsersList,
          FutureOr<UsersList>,
          (Misskey, String)
        > {
  const _UsersListNotifierFamily._()
    : super(
        retry: null,
        name: r'_usersListNotifierProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  _UsersListNotifierProvider call((Misskey, String) arg) =>
      _UsersListNotifierProvider._(argument: arg, from: this);

  @override
  String toString() => r'_usersListNotifierProvider';
}

abstract class _$UsersListNotifier extends $AsyncNotifier<UsersList> {
  late final _$args = ref.$arg as (Misskey, String);
  (Misskey, String) get arg => _$args;

  FutureOr<UsersList> build((Misskey, String) arg);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<UsersList>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UsersList>>,
              AsyncValue<UsersList>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(_UsersListUsers)
const _usersListUsersProvider = _UsersListUsersFamily._();

final class _UsersListUsersProvider
    extends $AsyncNotifierProvider<_UsersListUsers, List<User>> {
  const _UsersListUsersProvider._({
    required _UsersListUsersFamily super.from,
    required (Misskey, String) super.argument,
  }) : super(
         retry: null,
         name: r'_usersListUsersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$usersListUsersHash();

  @override
  String toString() {
    return r'_usersListUsersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  _UsersListUsers create() => _UsersListUsers();

  @$internal
  @override
  $AsyncNotifierProviderElement<_UsersListUsers, List<User>> $createElement(
    $ProviderPointer pointer,
  ) => $AsyncNotifierProviderElement(pointer);

  @override
  bool operator ==(Object other) {
    return other is _UsersListUsersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$usersListUsersHash() => r'2745a71f00d11cb3bc8a411a20df9b8e4757eb49';

final class _UsersListUsersFamily extends $Family
    with
        $ClassFamilyOverride<
          _UsersListUsers,
          AsyncValue<List<User>>,
          List<User>,
          FutureOr<List<User>>,
          (Misskey, String)
        > {
  const _UsersListUsersFamily._()
    : super(
        retry: null,
        name: r'_usersListUsersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  _UsersListUsersProvider call((Misskey, String) arg) =>
      _UsersListUsersProvider._(argument: arg, from: this);

  @override
  String toString() => r'_usersListUsersProvider';
}

abstract class _$UsersListUsers extends $AsyncNotifier<List<User>> {
  late final _$args = ref.$arg as (Misskey, String);
  (Misskey, String) get arg => _$args;

  FutureOr<List<User>> build((Misskey, String) arg);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<List<User>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<User>>>,
              AsyncValue<List<User>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
