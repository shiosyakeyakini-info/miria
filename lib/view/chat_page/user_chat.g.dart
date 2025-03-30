// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_chat.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userChatHash() => r'faa7f533ac3f473e26f6c590cdae7897c1e43483';

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

abstract class _$UserChat extends BuildlessAsyncNotifier<List<ChatMessage>> {
  late final String userId;

  FutureOr<List<ChatMessage>> build(
    String userId,
  );
}

/// See also [UserChat].
@ProviderFor(UserChat)
const userChatProvider = UserChatFamily();

/// See also [UserChat].
class UserChatFamily extends Family {
  /// See also [UserChat].
  const UserChatFamily();

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    misskeyGetContextProvider
  ];

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    misskeyGetContextProvider,
    ...?misskeyGetContextProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userChatProvider';

  /// See also [UserChat].
  UserChatProvider call(
    String userId,
  ) {
    return UserChatProvider(
      userId,
    );
  }

  @visibleForOverriding
  @override
  UserChatProvider getProviderOverride(
    covariant UserChatProvider provider,
  ) {
    return call(
      provider.userId,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(UserChat Function() create) {
    return _$UserChatFamilyOverride(this, create);
  }
}

class _$UserChatFamilyOverride implements FamilyOverride {
  _$UserChatFamilyOverride(this.overriddenFamily, this.create);

  final UserChat Function() create;

  @override
  final UserChatFamily overriddenFamily;

  @override
  UserChatProvider getProviderOverride(
    covariant UserChatProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [UserChat].
class UserChatProvider
    extends AsyncNotifierProviderImpl<UserChat, List<ChatMessage>> {
  /// See also [UserChat].
  UserChatProvider(
    String userId,
  ) : this._internal(
          () => UserChat()..userId = userId,
          from: userChatProvider,
          name: r'userChatProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userChatHash,
          dependencies: UserChatFamily._dependencies,
          allTransitiveDependencies: UserChatFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserChatProvider._internal(
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
  FutureOr<List<ChatMessage>> runNotifierBuild(
    covariant UserChat notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(UserChat Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserChatProvider._internal(
        () => create()..userId = userId,
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
  AsyncNotifierProviderElement<UserChat, List<ChatMessage>> createElement() {
    return _UserChatProviderElement(this);
  }

  UserChatProvider _copyWith(
    UserChat Function() create,
  ) {
    return UserChatProvider._internal(
      () => create()..userId = userId,
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
    return other is UserChatProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserChatRef on AsyncNotifierProviderRef<List<ChatMessage>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserChatProviderElement
    extends AsyncNotifierProviderElement<UserChat, List<ChatMessage>>
    with UserChatRef {
  _UserChatProviderElement(super.provider);

  @override
  String get userId => (origin as UserChatProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
