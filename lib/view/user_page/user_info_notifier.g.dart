// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userInfoNotifierProxy)
final userInfoNotifierProxyProvider = UserInfoNotifierProxyFamily._();

final class UserInfoNotifierProxyProvider
    extends
        $FunctionalProvider<
          Raw<UserInfoNotifier>,
          Raw<UserInfoNotifier>,
          Raw<UserInfoNotifier>
        >
    with $Provider<Raw<UserInfoNotifier>> {
  UserInfoNotifierProxyProvider._({
    required UserInfoNotifierProxyFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userInfoNotifierProxyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = accountContextProvider;

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
    r'1157e282e6cc4f3562f1403cc7b9d07f1e460e4c';

final class UserInfoNotifierProxyFamily extends $Family
    with $FunctionalFamilyOverride<Raw<UserInfoNotifier>, String> {
  UserInfoNotifierProxyFamily._()
    : super(
        retry: null,
        name: r'userInfoNotifierProxyProvider',
        dependencies: <ProviderOrFamily>[accountContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
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
final userInfoProxyProvider = UserInfoProxyFamily._();

final class UserInfoProxyProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserInfo>,
          AsyncValue<UserInfo>,
          AsyncValue<UserInfo>
        >
    with $Provider<AsyncValue<UserInfo>> {
  UserInfoProxyProvider._({
    required UserInfoProxyFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userInfoProxyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = accountContextProvider;

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

String _$userInfoProxyHash() => r'e01002b185d729d1d1cc737bc0fc570ea087aa22';

final class UserInfoProxyFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<UserInfo>, String> {
  UserInfoProxyFamily._()
    : super(
        retry: null,
        name: r'userInfoProxyProvider',
        dependencies: <ProviderOrFamily>[accountContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
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
final userInfoProvider = UserInfoNotifierFamily._();

final class UserInfoNotifierProvider
    extends $AsyncNotifierProvider<UserInfoNotifier, UserInfo> {
  UserInfoNotifierProvider._({
    required UserInfoNotifierFamily super.from,
    required ({String userId, AccountContext context}) super.argument,
  }) : super(
         retry: null,
         name: r'userInfoProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userInfoNotifierHash();

  @override
  String toString() {
    return r'userInfoProvider'
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

String _$userInfoNotifierHash() => r'a853c04c23d05d863c6b6c78287f5058bf31d690';

final class UserInfoNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          UserInfoNotifier,
          AsyncValue<UserInfo>,
          UserInfo,
          FutureOr<UserInfo>,
          ({String userId, AccountContext context})
        > {
  UserInfoNotifierFamily._()
    : super(
        retry: null,
        name: r'userInfoProvider',
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
  String toString() => r'userInfoProvider';
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
    final ref = this.ref as $Ref<AsyncValue<UserInfo>, UserInfo>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserInfo>, UserInfo>,
              AsyncValue<UserInfo>,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(userId: _$args.userId, context: _$args.context),
    );
  }
}
