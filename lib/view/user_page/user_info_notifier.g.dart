// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userInfoNotifierHash() => r'96a7d920b4da78dc45efeea068dc0a6661e405cf';

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

abstract class _$UserInfoNotifier
    extends BuildlessAutoDisposeAsyncNotifier<UserInfo> {
  late final Account account;
  late final String userId;

  FutureOr<UserInfo> build(
    Account account,
    String userId,
  );
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
  UserInfoNotifierProvider call(
    Account account,
    String userId,
  ) {
    return UserInfoNotifierProvider(
      account,
      userId,
    );
  }

  @visibleForOverriding
  @override
  UserInfoNotifierProvider getProviderOverride(
    covariant UserInfoNotifierProvider provider,
  ) {
    return call(
      provider.account,
      provider.userId,
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
  UserInfoNotifierProvider(
    Account account,
    String userId,
  ) : this._internal(
          () => UserInfoNotifier()
            ..account = account
            ..userId = userId,
          from: userInfoNotifierProvider,
          name: r'userInfoNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userInfoNotifierHash,
          dependencies: UserInfoNotifierFamily._dependencies,
          allTransitiveDependencies:
              UserInfoNotifierFamily._allTransitiveDependencies,
          account: account,
          userId: userId,
        );

  UserInfoNotifierProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.account,
    required this.userId,
  }) : super.internal();

  final Account account;
  final String userId;

  @override
  FutureOr<UserInfo> runNotifierBuild(
    covariant UserInfoNotifier notifier,
  ) {
    return notifier.build(
      account,
      userId,
    );
  }

  @override
  Override overrideWith(UserInfoNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserInfoNotifierProvider._internal(
        () => create()
          ..account = account
          ..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        account: account,
        userId: userId,
      ),
    );
  }

  @override
  (
    Account,
    String,
  ) get argument {
    return (
      account,
      userId,
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
        ..account = account
        ..userId = userId,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      account: account,
      userId: userId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserInfoNotifierProvider &&
        other.account == account &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserInfoNotifierRef on AutoDisposeAsyncNotifierProviderRef<UserInfo> {
  /// The parameter `account` of this provider.
  Account get account;

  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserInfoNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UserInfoNotifier, UserInfo>
    with UserInfoNotifierRef {
  _UserInfoNotifierProviderElement(super.provider);

  @override
  Account get account => (origin as UserInfoNotifierProvider).account;
  @override
  String get userId => (origin as UserInfoNotifierProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
