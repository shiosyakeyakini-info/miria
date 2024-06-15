// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'federation_data.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$federationStateHash() => r'9c167f036298a174352bb982133485adbee4c5bc';

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

abstract class _$FederationState
    extends BuildlessAutoDisposeAsyncNotifier<FederationData> {
  late final Account account;
  late final String host;

  FutureOr<FederationData> build(
    Account account,
    String host,
  );
}

/// See also [FederationState].
@ProviderFor(FederationState)
const federationStateProvider = FederationStateFamily();

/// See also [FederationState].
class FederationStateFamily extends Family {
  /// See also [FederationState].
  const FederationStateFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'federationStateProvider';

  /// See also [FederationState].
  FederationStateProvider call(
    Account account,
    String host,
  ) {
    return FederationStateProvider(
      account,
      host,
    );
  }

  @visibleForOverriding
  @override
  FederationStateProvider getProviderOverride(
    covariant FederationStateProvider provider,
  ) {
    return call(
      provider.account,
      provider.host,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(FederationState Function() create) {
    return _$FederationStateFamilyOverride(this, create);
  }
}

class _$FederationStateFamilyOverride implements FamilyOverride {
  _$FederationStateFamilyOverride(this.overriddenFamily, this.create);

  final FederationState Function() create;

  @override
  final FederationStateFamily overriddenFamily;

  @override
  FederationStateProvider getProviderOverride(
    covariant FederationStateProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [FederationState].
class FederationStateProvider extends AutoDisposeAsyncNotifierProviderImpl<
    FederationState, FederationData> {
  /// See also [FederationState].
  FederationStateProvider(
    Account account,
    String host,
  ) : this._internal(
          () => FederationState()
            ..account = account
            ..host = host,
          from: federationStateProvider,
          name: r'federationStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$federationStateHash,
          dependencies: FederationStateFamily._dependencies,
          allTransitiveDependencies:
              FederationStateFamily._allTransitiveDependencies,
          account: account,
          host: host,
        );

  FederationStateProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.account,
    required this.host,
  }) : super.internal();

  final Account account;
  final String host;

  @override
  FutureOr<FederationData> runNotifierBuild(
    covariant FederationState notifier,
  ) {
    return notifier.build(
      account,
      host,
    );
  }

  @override
  Override overrideWith(FederationState Function() create) {
    return ProviderOverride(
      origin: this,
      override: FederationStateProvider._internal(
        () => create()
          ..account = account
          ..host = host,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        account: account,
        host: host,
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
      host,
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FederationState, FederationData>
      createElement() {
    return _FederationStateProviderElement(this);
  }

  FederationStateProvider _copyWith(
    FederationState Function() create,
  ) {
    return FederationStateProvider._internal(
      () => create()
        ..account = account
        ..host = host,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      account: account,
      host: host,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FederationStateProvider &&
        other.account == account &&
        other.host == host;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);
    hash = _SystemHash.combine(hash, host.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FederationStateRef
    on AutoDisposeAsyncNotifierProviderRef<FederationData> {
  /// The parameter `account` of this provider.
  Account get account;

  /// The parameter `host` of this provider.
  String get host;
}

class _FederationStateProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FederationState,
        FederationData> with FederationStateRef {
  _FederationStateProviderElement(super.provider);

  @override
  Account get account => (origin as FederationStateProvider).account;
  @override
  String get host => (origin as FederationStateProvider).host;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
