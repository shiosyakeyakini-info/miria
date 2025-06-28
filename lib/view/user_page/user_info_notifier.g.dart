// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(userInfoNotifierProxy)
const userInfoNotifierProxyProvider = UserInfoNotifierProxyFamily._();

final class UserInfoNotifierProxyProvider
    extends
        $FunctionalProvider<
          Raw<UserInfoNotifier>,
          Raw<UserInfoNotifier>,
          Raw<UserInfoNotifier>
        >
    with $Provider<Raw<UserInfoNotifier>> {
  const UserInfoNotifierProxyProvider._({
    required UserInfoNotifierProxyFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userInfoNotifierProxyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = accountContextProvider;

  @override
  String debugGetCreateSourceHash() => _$userInfoNotifierProxyHash();

  @override
  String toString() {
    return r'userInfoNotifierProxyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Raw<UserInfoNotifier>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Raw<UserInfoNotifier> create(Ref ref) {
    final argument = this.argument as String;
    return userInfoNotifierProxy(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<UserInfoNotifier> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Raw<UserInfoNotifier>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserInfoNotifierProxyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userInfoNotifierProxyHash() =>
    r'6793ee9dbda64a646583409d4986f1766aa82c81';

final class UserInfoNotifierProxyFamily extends $Family
    with $FunctionalFamilyOverride<Raw<UserInfoNotifier>, String> {
  const UserInfoNotifierProxyFamily._()
    : super(
        retry: null,
        name: r'userInfoNotifierProxyProvider',
        dependencies: const <ProviderOrFamily>[accountContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          UserInfoNotifierProxyProvider.$allTransitiveDependencies0,
        ],
        isAutoDispose: true,
      );

  UserInfoNotifierProxyProvider call(String userId) =>
      UserInfoNotifierProxyProvider._(argument: userId, from: this);

  @override
  String toString() => r'userInfoNotifierProxyProvider';
}

@ProviderFor(userInfoProxy)
const userInfoProxyProvider = UserInfoProxyFamily._();

final class UserInfoProxyProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserInfo>,
          AsyncValue<UserInfo>,
          AsyncValue<UserInfo>
        >
    with $Provider<AsyncValue<UserInfo>> {
  const UserInfoProxyProvider._({
    required UserInfoProxyFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userInfoProxyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = accountContextProvider;

  @override
  String debugGetCreateSourceHash() => _$userInfoProxyHash();

  @override
  String toString() {
    return r'userInfoProxyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<UserInfo>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<UserInfo> create(Ref ref) {
    final argument = this.argument as String;
    return userInfoProxy(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<UserInfo> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<UserInfo>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserInfoProxyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userInfoProxyHash() => r'1f984a6f339e55d8959f256b52d14dbc48e87ab8';

final class UserInfoProxyFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<UserInfo>, String> {
  const UserInfoProxyFamily._()
    : super(
        retry: null,
        name: r'userInfoProxyProvider',
        dependencies: const <ProviderOrFamily>[accountContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          UserInfoProxyProvider.$allTransitiveDependencies0,
        ],
        isAutoDispose: true,
      );

  UserInfoProxyProvider call(String userId) =>
      UserInfoProxyProvider._(argument: userId, from: this);

  @override
  String toString() => r'userInfoProxyProvider';
}

@ProviderFor(UserInfoNotifier)
const userInfoNotifierProvider = UserInfoNotifierFamily._();

final class UserInfoNotifierProvider
    extends $AsyncNotifierProvider<UserInfoNotifier, UserInfo> {
  const UserInfoNotifierProvider._({
    required UserInfoNotifierFamily super.from,
    required ({String userId, AccountContext context}) super.argument,
  }) : super(
         retry: null,
         name: r'userInfoNotifierProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userInfoNotifierHash();

  @override
  String toString() {
    return r'userInfoNotifierProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  UserInfoNotifier create() => UserInfoNotifier();

  @override
  bool operator ==(Object other) {
    return other is UserInfoNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userInfoNotifierHash() => r'b4b78145b2cb531abe6da2fb840c4b01bb12f4dd';

final class UserInfoNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          UserInfoNotifier,
          AsyncValue<UserInfo>,
          UserInfo,
          FutureOr<UserInfo>,
          ({String userId, AccountContext context})
        > {
  const UserInfoNotifierFamily._()
    : super(
        retry: null,
        name: r'userInfoNotifierProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserInfoNotifierProvider call({
    required String userId,
    required AccountContext context,
  }) => UserInfoNotifierProvider._(
    argument: (userId: userId, context: context),
    from: this,
  );

  @override
  String toString() => r'userInfoNotifierProvider';
}

abstract class _$UserInfoNotifier extends $AsyncNotifier<UserInfo> {
  late final _$args = ref.$arg as ({String userId, AccountContext context});
  String get userId => _$args.userId;
  AccountContext get context => _$args.context;

  FutureOr<UserInfo> build({
    required String userId,
    required AccountContext context,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(userId: _$args.userId, context: _$args.context);
    final ref = this.ref as $Ref<AsyncValue<UserInfo>, UserInfo>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserInfo>, UserInfo>,
              AsyncValue<UserInfo>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
