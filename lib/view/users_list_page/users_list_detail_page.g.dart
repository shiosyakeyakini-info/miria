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

  @$internal
  @override
  _$UsersListNotifierElement $createElement($ProviderPointer pointer) =>
      _$UsersListNotifierElement(pointer);

  ProviderListenable<_UsersListNotifier$UpdateList> get updateList =>
      $LazyProxyListenable<
        _UsersListNotifier$UpdateList,
        AsyncValue<UsersList>
      >(this, (element) {
        element as _$UsersListNotifierElement;

        return element._$updateList;
      });

  @override
  bool operator ==(Object other) {
    return other is _UsersListNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$usersListNotifierHash() => r'e8067b9153fabe40c2e9fb3068b338c77244085c';

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

class _$UsersListNotifierElement
    extends $AsyncNotifierProviderElement<_UsersListNotifier, UsersList> {
  _$UsersListNotifierElement(super.pointer) {
    _$updateList.result = $Result.data(_$_UsersListNotifier$UpdateList(this));
  }
  final _$updateList = $ElementLense<_$_UsersListNotifier$UpdateList>();
  @override
  void mount() {
    super.mount();
    _$updateList.result!.value!.reset();
  }

  @override
  void visitListenables(
    void Function($ElementLense element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);

    listenableVisitor(_$updateList);
  }
}

sealed class _UsersListNotifier$UpdateList extends MutationBase<void> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutation], then
  /// will call [_UsersListNotifier.updateList] with the provided parameters.
  ///
  /// After the method completes, the mutation state will be updated to either
  /// [SuccessMutation] or [ErrorMutation] based on if the method
  /// threw or not.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  Future<void> call(UsersListSettings settings);
}

final class _$_UsersListNotifier$UpdateList
    extends
        $AsyncMutationBase<
          void,
          _$_UsersListNotifier$UpdateList,
          _UsersListNotifier
        >
    implements _UsersListNotifier$UpdateList {
  _$_UsersListNotifier$UpdateList(this.element, {super.state, super.key});

  @override
  final _$UsersListNotifierElement element;

  @override
  $ElementLense<_$_UsersListNotifier$UpdateList> get listenable =>
      element._$updateList;

  @override
  Future<void> call(UsersListSettings settings) {
    return mutate(
      Invocation.method(#updateList, [settings]),
      ($notifier) => $notifier.updateList(settings),
    );
  }

  @override
  _$_UsersListNotifier$UpdateList copyWith(
    MutationState<void> state, {
    Object? key,
  }) => _$_UsersListNotifier$UpdateList(element, state: state, key: key);
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

String _$usersListUsersHash() => r'e5720c38fe76ff4425e4a4f684d99aa2e0db7783';

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
