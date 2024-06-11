// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_detail_info.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$channelDetailHash() => r'd082c9f27a244725f8dae6568484da564cbe39c2';

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

abstract class _$ChannelDetail
    extends BuildlessAutoDisposeAsyncNotifier<ChannelDetailState> {
  late final Account account;
  late final String channelId;

  FutureOr<ChannelDetailState> build(
    Account account,
    String channelId,
  );
}

/// See also [_ChannelDetail].
@ProviderFor(_ChannelDetail)
const _channelDetailProvider = _ChannelDetailFamily();

/// See also [_ChannelDetail].
class _ChannelDetailFamily extends Family {
  /// See also [_ChannelDetail].
  const _ChannelDetailFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'_channelDetailProvider';

  /// See also [_ChannelDetail].
  _ChannelDetailProvider call(
    Account account,
    String channelId,
  ) {
    return _ChannelDetailProvider(
      account,
      channelId,
    );
  }

  @visibleForOverriding
  @override
  _ChannelDetailProvider getProviderOverride(
    covariant _ChannelDetailProvider provider,
  ) {
    return call(
      provider.account,
      provider.channelId,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(_ChannelDetail Function() create) {
    return _$ChannelDetailFamilyOverride(this, create);
  }
}

class _$ChannelDetailFamilyOverride implements FamilyOverride {
  _$ChannelDetailFamilyOverride(this.overriddenFamily, this.create);

  final _ChannelDetail Function() create;

  @override
  final _ChannelDetailFamily overriddenFamily;

  @override
  _ChannelDetailProvider getProviderOverride(
    covariant _ChannelDetailProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [_ChannelDetail].
class _ChannelDetailProvider extends AutoDisposeAsyncNotifierProviderImpl<
    _ChannelDetail, ChannelDetailState> {
  /// See also [_ChannelDetail].
  _ChannelDetailProvider(
    Account account,
    String channelId,
  ) : this._internal(
          () => _ChannelDetail()
            ..account = account
            ..channelId = channelId,
          from: _channelDetailProvider,
          name: r'_channelDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$channelDetailHash,
          dependencies: _ChannelDetailFamily._dependencies,
          allTransitiveDependencies:
              _ChannelDetailFamily._allTransitiveDependencies,
          account: account,
          channelId: channelId,
        );

  _ChannelDetailProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.account,
    required this.channelId,
  }) : super.internal();

  final Account account;
  final String channelId;

  @override
  FutureOr<ChannelDetailState> runNotifierBuild(
    covariant _ChannelDetail notifier,
  ) {
    return notifier.build(
      account,
      channelId,
    );
  }

  @override
  Override overrideWith(_ChannelDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: _ChannelDetailProvider._internal(
        () => create()
          ..account = account
          ..channelId = channelId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        account: account,
        channelId: channelId,
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
      channelId,
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<_ChannelDetail, ChannelDetailState>
      createElement() {
    return _ChannelDetailProviderElement(this);
  }

  _ChannelDetailProvider _copyWith(
    _ChannelDetail Function() create,
  ) {
    return _ChannelDetailProvider._internal(
      () => create()
        ..account = account
        ..channelId = channelId,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      account: account,
      channelId: channelId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _ChannelDetailProvider &&
        other.account == account &&
        other.channelId == channelId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);
    hash = _SystemHash.combine(hash, channelId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin _ChannelDetailRef
    on AutoDisposeAsyncNotifierProviderRef<ChannelDetailState> {
  /// The parameter `account` of this provider.
  Account get account;

  /// The parameter `channelId` of this provider.
  String get channelId;
}

class _ChannelDetailProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<_ChannelDetail,
        ChannelDetailState> with _ChannelDetailRef {
  _ChannelDetailProviderElement(super.provider);

  @override
  Account get account => (origin as _ChannelDetailProvider).account;
  @override
  String get channelId => (origin as _ChannelDetailProvider).channelId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
