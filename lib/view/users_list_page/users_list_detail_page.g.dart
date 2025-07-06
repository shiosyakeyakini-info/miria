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
        '$argument';
  }

  @$internal
  @override
  _UsersListNotifier create() => _UsersListNotifier();

  @override
  bool operator ==(Object other) {
    return other is _UsersListNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$usersListNotifierHash() => r'c51fadbf7615f1343297d33391c16f5ef99d84d8';

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

  _UsersListNotifierProvider call(Misskey misskey, String listId) =>
      _UsersListNotifierProvider._(argument: (misskey, listId), from: this);

  @override
  String toString() => r'_usersListNotifierProvider';
}

abstract class _$UsersListNotifier extends $AsyncNotifier<UsersList> {
  late final _$args = ref.$arg as (Misskey, String);
  Misskey get misskey => _$args.$1;
  String get listId => _$args.$2;

  FutureOr<UsersList> build(Misskey misskey, String listId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2);
    final ref = this.ref as $Ref<AsyncValue<UsersList>, UsersList>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UsersList>, UsersList>,
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
        '$argument';
  }

  @$internal
  @override
  _UsersListUsers create() => _UsersListUsers();

  @override
  bool operator ==(Object other) {
    return other is _UsersListUsersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$usersListUsersHash() => r'd4f5066da6faec88593e8f35da198edb0b3150a4';

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

  _UsersListUsersProvider call(Misskey misskey, String listId) =>
      _UsersListUsersProvider._(argument: (misskey, listId), from: this);

  @override
  String toString() => r'_usersListUsersProvider';
}

abstract class _$UsersListUsers extends $AsyncNotifier<List<User>> {
  late final _$args = ref.$arg as (Misskey, String);
  Misskey get misskey => _$args.$1;
  String get listId => _$args.$2;

  FutureOr<List<User>> build(Misskey misskey, String listId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2);
    final ref = this.ref as $Ref<AsyncValue<List<User>>, List<User>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<User>>, List<User>>,
              AsyncValue<List<User>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
