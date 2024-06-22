// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_lists_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$usersListsNotifierHash() =>
    r'2b1fb172193b1223f1c63fd6beb6601f815a806c';

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

abstract class _$UsersListsNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<UsersList>> {
  late final Misskey misskey;

  FutureOr<List<UsersList>> build(
    Misskey misskey,
  );
}

/// See also [UsersListsNotifier].
@ProviderFor(UsersListsNotifier)
const usersListsNotifierProvider = UsersListsNotifierFamily();

/// See also [UsersListsNotifier].
class UsersListsNotifierFamily extends Family {
  /// See also [UsersListsNotifier].
  const UsersListsNotifierFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'usersListsNotifierProvider';

  /// See also [UsersListsNotifier].
  UsersListsNotifierProvider call(
    Misskey misskey,
  ) {
    return UsersListsNotifierProvider(
      misskey,
    );
  }

  @visibleForOverriding
  @override
  UsersListsNotifierProvider getProviderOverride(
    covariant UsersListsNotifierProvider provider,
  ) {
    return call(
      provider.misskey,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(UsersListsNotifier Function() create) {
    return _$UsersListsNotifierFamilyOverride(this, create);
  }
}

class _$UsersListsNotifierFamilyOverride implements FamilyOverride {
  _$UsersListsNotifierFamilyOverride(this.overriddenFamily, this.create);

  final UsersListsNotifier Function() create;

  @override
  final UsersListsNotifierFamily overriddenFamily;

  @override
  UsersListsNotifierProvider getProviderOverride(
    covariant UsersListsNotifierProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [UsersListsNotifier].
class UsersListsNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    UsersListsNotifier, List<UsersList>> {
  /// See also [UsersListsNotifier].
  UsersListsNotifierProvider(
    Misskey misskey,
  ) : this._internal(
          () => UsersListsNotifier()..misskey = misskey,
          from: usersListsNotifierProvider,
          name: r'usersListsNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$usersListsNotifierHash,
          dependencies: UsersListsNotifierFamily._dependencies,
          allTransitiveDependencies:
              UsersListsNotifierFamily._allTransitiveDependencies,
          misskey: misskey,
        );

  UsersListsNotifierProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.misskey,
  }) : super.internal();

  final Misskey misskey;

  @override
  FutureOr<List<UsersList>> runNotifierBuild(
    covariant UsersListsNotifier notifier,
  ) {
    return notifier.build(
      misskey,
    );
  }

  @override
  Override overrideWith(UsersListsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: UsersListsNotifierProvider._internal(
        () => create()..misskey = misskey,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        misskey: misskey,
      ),
    );
  }

  @override
  (Misskey,) get argument {
    return (misskey,);
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<UsersListsNotifier, List<UsersList>>
      createElement() {
    return _UsersListsNotifierProviderElement(this);
  }

  UsersListsNotifierProvider _copyWith(
    UsersListsNotifier Function() create,
  ) {
    return UsersListsNotifierProvider._internal(
      () => create()..misskey = misskey,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      misskey: misskey,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UsersListsNotifierProvider && other.misskey == misskey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, misskey.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UsersListsNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<UsersList>> {
  /// The parameter `misskey` of this provider.
  Misskey get misskey;
}

class _UsersListsNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UsersListsNotifier,
        List<UsersList>> with UsersListsNotifierRef {
  _UsersListsNotifierProviderElement(super.provider);

  @override
  Misskey get misskey => (origin as UsersListsNotifierProvider).misskey;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
