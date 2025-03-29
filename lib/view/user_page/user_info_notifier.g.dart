// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userInfoNotifierProxyHash() =>
    r'45c3a25fbd146b289be6e8929752418ed1adf59a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [userInfoNotifierProxy].
@ProviderFor(userInfoNotifierProxy)
const userInfoNotifierProxyProvider = UserInfoNotifierProxyFamily();

/// See also [userInfoNotifierProxy].
class UserInfoNotifierProxyFamily extends Family {
  /// See also [userInfoNotifierProxy].
  const UserInfoNotifierProxyFamily();

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    accountContextProvider
  ];

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    accountContextProvider,
    ...?accountContextProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userInfoNotifierProxyProvider';

  /// See also [userInfoNotifierProxy].
  UserInfoNotifierProxyProvider call(
    String userId,
  ) {
    return UserInfoNotifierProxyProvider(
      userId,
    );
  }

  @visibleForOverriding
  @override
  UserInfoNotifierProxyProvider getProviderOverride(
    covariant UserInfoNotifierProxyProvider provider,
  ) {
    return call(
      provider.userId,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      Raw<UserInfoNotifier> Function(UserInfoNotifierProxyRef ref) create) {
    return _$UserInfoNotifierProxyFamilyOverride(this, create);
  }
}

class _$UserInfoNotifierProxyFamilyOverride implements FamilyOverride {
  _$UserInfoNotifierProxyFamilyOverride(this.overriddenFamily, this.create);

  final Raw<UserInfoNotifier> Function(UserInfoNotifierProxyRef ref) create;

  @override
  final UserInfoNotifierProxyFamily overriddenFamily;

  @override
  UserInfoNotifierProxyProvider getProviderOverride(
    covariant UserInfoNotifierProxyProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [userInfoNotifierProxy].
class UserInfoNotifierProxyProvider
    extends AutoDisposeProvider<Raw<UserInfoNotifier>> {
  /// See also [userInfoNotifierProxy].
  UserInfoNotifierProxyProvider(
    String userId,
  ) : this._internal(
          (ref) => userInfoNotifierProxy(
            ref as UserInfoNotifierProxyRef,
            userId,
          ),
          from: userInfoNotifierProxyProvider,
          name: r'userInfoNotifierProxyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userInfoNotifierProxyHash,
          dependencies: UserInfoNotifierProxyFamily._dependencies,
          allTransitiveDependencies:
              UserInfoNotifierProxyFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserInfoNotifierProxyProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    Raw<UserInfoNotifier> Function(UserInfoNotifierProxyRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserInfoNotifierProxyProvider._internal(
        (ref) => create(ref as UserInfoNotifierProxyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  (String,) get argument {
    return (userId,);
  }

  @override
  AutoDisposeProviderElement<Raw<UserInfoNotifier>> createElement() {
    return _UserInfoNotifierProxyProviderElement(this);
  }

  UserInfoNotifierProxyProvider _copyWith(
    Raw<UserInfoNotifier> Function(UserInfoNotifierProxyRef ref) create,
  ) {
    return UserInfoNotifierProxyProvider._internal(
      (ref) => create(ref as UserInfoNotifierProxyRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      userId: userId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserInfoNotifierProxyProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserInfoNotifierProxyRef
    on AutoDisposeProviderRef<Raw<UserInfoNotifier>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserInfoNotifierProxyProviderElement
    extends AutoDisposeProviderElement<Raw<UserInfoNotifier>>
    with UserInfoNotifierProxyRef {
  _UserInfoNotifierProxyProviderElement(super.provider);

  @override
  String get userId => (origin as UserInfoNotifierProxyProvider).userId;
}

String _$userInfoProxyHash() => r'f05bda4353cb2f3c6459b1548021ad68fb66bd5e';

/// See also [userInfoProxy].
@ProviderFor(userInfoProxy)
const userInfoProxyProvider = UserInfoProxyFamily();

/// See also [userInfoProxy].
class UserInfoProxyFamily extends Family {
  /// See also [userInfoProxy].
  const UserInfoProxyFamily();

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    accountContextProvider
  ];

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    accountContextProvider,
    ...?accountContextProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userInfoProxyProvider';

  /// See also [userInfoProxy].
  UserInfoProxyProvider call(
    String userId,
  ) {
    return UserInfoProxyProvider(
      userId,
    );
  }

  @visibleForOverriding
  @override
  UserInfoProxyProvider getProviderOverride(
    covariant UserInfoProxyProvider provider,
  ) {
    return call(
      provider.userId,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      AsyncValue<UserInfo> Function(UserInfoProxyRef ref) create) {
    return _$UserInfoProxyFamilyOverride(this, create);
  }
}

class _$UserInfoProxyFamilyOverride implements FamilyOverride {
  _$UserInfoProxyFamilyOverride(this.overriddenFamily, this.create);

  final AsyncValue<UserInfo> Function(UserInfoProxyRef ref) create;

  @override
  final UserInfoProxyFamily overriddenFamily;

  @override
  UserInfoProxyProvider getProviderOverride(
    covariant UserInfoProxyProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [userInfoProxy].
class UserInfoProxyProvider extends AutoDisposeProvider<AsyncValue<UserInfo>> {
  /// See also [userInfoProxy].
  UserInfoProxyProvider(
    String userId,
  ) : this._internal(
          (ref) => userInfoProxy(
            ref as UserInfoProxyRef,
            userId,
          ),
          from: userInfoProxyProvider,
          name: r'userInfoProxyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userInfoProxyHash,
          dependencies: UserInfoProxyFamily._dependencies,
          allTransitiveDependencies:
              UserInfoProxyFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserInfoProxyProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    AsyncValue<UserInfo> Function(UserInfoProxyRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserInfoProxyProvider._internal(
        (ref) => create(ref as UserInfoProxyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  (String,) get argument {
    return (userId,);
  }

  @override
  AutoDisposeProviderElement<AsyncValue<UserInfo>> createElement() {
    return _UserInfoProxyProviderElement(this);
  }

  UserInfoProxyProvider _copyWith(
    AsyncValue<UserInfo> Function(UserInfoProxyRef ref) create,
  ) {
    return UserInfoProxyProvider._internal(
      (ref) => create(ref as UserInfoProxyRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      userId: userId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserInfoProxyProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserInfoProxyRef on AutoDisposeProviderRef<AsyncValue<UserInfo>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserInfoProxyProviderElement
    extends AutoDisposeProviderElement<AsyncValue<UserInfo>>
    with UserInfoProxyRef {
  _UserInfoProxyProviderElement(super.provider);

  @override
  String get userId => (origin as UserInfoProxyProvider).userId;
}

String _$userInfoNotifierHash() => r'b4b78145b2cb531abe6da2fb840c4b01bb12f4dd';

abstract class _$UserInfoNotifier
    extends BuildlessAutoDisposeAsyncNotifier<UserInfo> {
  late final String userId;
  late final AccountContext context;

  FutureOr<UserInfo> build({
    required String userId,
    required AccountContext context,
  });
}

/// See also [UserInfoNotifier].
@ProviderFor(UserInfoNotifier)
const userInfoNotifierProvider = UserInfoNotifierFamily();

/// See also [UserInfoNotifier].
class UserInfoNotifierFamily extends Family {
  /// See also [UserInfoNotifier].
  const UserInfoNotifierFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userInfoNotifierProvider';

  /// See also [UserInfoNotifier].
  UserInfoNotifierProvider call({
    required String userId,
    required AccountContext context,
  }) {
    return UserInfoNotifierProvider(
      userId: userId,
      context: context,
    );
  }

  @visibleForOverriding
  @override
  UserInfoNotifierProvider getProviderOverride(
    covariant UserInfoNotifierProvider provider,
  ) {
    return call(
      userId: provider.userId,
      context: provider.context,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(UserInfoNotifier Function() create) {
    return _$UserInfoNotifierFamilyOverride(this, create);
  }
}

class _$UserInfoNotifierFamilyOverride implements FamilyOverride {
  _$UserInfoNotifierFamilyOverride(this.overriddenFamily, this.create);

  final UserInfoNotifier Function() create;

  @override
  final UserInfoNotifierFamily overriddenFamily;

  @override
  UserInfoNotifierProvider getProviderOverride(
    covariant UserInfoNotifierProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [UserInfoNotifier].
class UserInfoNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<UserInfoNotifier, UserInfo> {
  /// See also [UserInfoNotifier].
  UserInfoNotifierProvider({
    required String userId,
    required AccountContext context,
  }) : this._internal(
          () => UserInfoNotifier()
            ..userId = userId
            ..context = context,
          from: userInfoNotifierProvider,
          name: r'userInfoNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userInfoNotifierHash,
          dependencies: UserInfoNotifierFamily._dependencies,
          allTransitiveDependencies:
              UserInfoNotifierFamily._allTransitiveDependencies,
          userId: userId,
          context: context,
        );

  UserInfoNotifierProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
    required this.context,
  }) : super.internal();

  final String userId;
  final AccountContext context;

  @override
  FutureOr<UserInfo> runNotifierBuild(
    covariant UserInfoNotifier notifier,
  ) {
    return notifier.build(
      userId: userId,
      context: context,
    );
  }

  @override
  Override overrideWith(UserInfoNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserInfoNotifierProvider._internal(
        () => create()
          ..userId = userId
          ..context = context,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
        context: context,
      ),
    );
  }

  @override
  ({
    String userId,
    AccountContext context,
  }) get argument {
    return (
      userId: userId,
      context: context,
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<UserInfoNotifier, UserInfo>
      createElement() {
    return _UserInfoNotifierProviderElement(this);
  }

  UserInfoNotifierProvider _copyWith(
    UserInfoNotifier Function() create,
  ) {
    return UserInfoNotifierProvider._internal(
      () => create()
        ..userId = userId
        ..context = context,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      userId: userId,
      context: context,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserInfoNotifierProvider &&
        other.userId == userId &&
        other.context == context;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, context.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserInfoNotifierRef on AutoDisposeAsyncNotifierProviderRef<UserInfo> {
  /// The parameter `userId` of this provider.
  String get userId;

  /// The parameter `context` of this provider.
  AccountContext get context;
}

class _UserInfoNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UserInfoNotifier, UserInfo>
    with UserInfoNotifierRef {
  _UserInfoNotifierProviderElement(super.provider);

  @override
  String get userId => (origin as UserInfoNotifierProvider).userId;
  @override
  AccountContext get context => (origin as UserInfoNotifierProvider).context;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
