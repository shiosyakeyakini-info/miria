// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_games_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchReversiDataHash() => r'4a643964d25c0abd2365b2dbf068fba489c67d5d';

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

/// See also [_fetchReversiData].
@ProviderFor(_fetchReversiData)
const _fetchReversiDataProvider = _FetchReversiDataFamily();

/// See also [_fetchReversiData].
class _FetchReversiDataFamily extends Family {
  /// See also [_fetchReversiData].
  const _FetchReversiDataFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'_fetchReversiDataProvider';

  /// See also [_fetchReversiData].
  _FetchReversiDataProvider call(
    Account account,
  ) {
    return _FetchReversiDataProvider(
      account,
    );
  }

  @visibleForOverriding
  @override
  _FetchReversiDataProvider getProviderOverride(
    covariant _FetchReversiDataProvider provider,
  ) {
    return call(
      provider.account,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<List<User>> Function(_FetchReversiDataRef ref) create) {
    return _$FetchReversiDataFamilyOverride(this, create);
  }
}

class _$FetchReversiDataFamilyOverride implements FamilyOverride {
  _$FetchReversiDataFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<List<User>> Function(_FetchReversiDataRef ref) create;

  @override
  final _FetchReversiDataFamily overriddenFamily;

  @override
  _FetchReversiDataProvider getProviderOverride(
    covariant _FetchReversiDataProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [_fetchReversiData].
class _FetchReversiDataProvider extends AutoDisposeFutureProvider<List<User>> {
  /// See also [_fetchReversiData].
  _FetchReversiDataProvider(
    Account account,
  ) : this._internal(
          (ref) => _fetchReversiData(
            ref as _FetchReversiDataRef,
            account,
          ),
          from: _fetchReversiDataProvider,
          name: r'_fetchReversiDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchReversiDataHash,
          dependencies: _FetchReversiDataFamily._dependencies,
          allTransitiveDependencies:
              _FetchReversiDataFamily._allTransitiveDependencies,
          account: account,
        );

  _FetchReversiDataProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.account,
  }) : super.internal();

  final Account account;

  @override
  Override overrideWith(
    FutureOr<List<User>> Function(_FetchReversiDataRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _FetchReversiDataProvider._internal(
        (ref) => create(ref as _FetchReversiDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        account: account,
      ),
    );
  }

  @override
  (Account,) get argument {
    return (account,);
  }

  @override
  AutoDisposeFutureProviderElement<List<User>> createElement() {
    return _FetchReversiDataProviderElement(this);
  }

  _FetchReversiDataProvider _copyWith(
    FutureOr<List<User>> Function(_FetchReversiDataRef ref) create,
  ) {
    return _FetchReversiDataProvider._internal(
      (ref) => create(ref as _FetchReversiDataRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      account: account,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _FetchReversiDataProvider && other.account == account;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin _FetchReversiDataRef on AutoDisposeFutureProviderRef<List<User>> {
  /// The parameter `account` of this provider.
  Account get account;
}

class _FetchReversiDataProviderElement
    extends AutoDisposeFutureProviderElement<List<User>>
    with _FetchReversiDataRef {
  _FetchReversiDataProviderElement(super.provider);

  @override
  Account get account => (origin as _FetchReversiDataProvider).account;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
