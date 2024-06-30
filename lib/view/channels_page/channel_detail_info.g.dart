// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_detail_info.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$channelDetailHash() => r'f8a55187780eb1e455637c3b306790d93e25818b';

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
  late final String channelId;

  FutureOr<ChannelDetailState> build(
    String channelId,
  );
}

/// See also [ChannelDetail].
@ProviderFor(ChannelDetail)
const channelDetailProvider = ChannelDetailFamily();

/// See also [ChannelDetail].
class ChannelDetailFamily extends Family {
  /// See also [ChannelDetail].
  const ChannelDetailFamily();

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
  String? get name => r'channelDetailProvider';

  /// See also [ChannelDetail].
  ChannelDetailProvider call(
    String channelId,
  ) {
    return ChannelDetailProvider(
      channelId,
    );
  }

  @visibleForOverriding
  @override
  ChannelDetailProvider getProviderOverride(
    covariant ChannelDetailProvider provider,
  ) {
    return call(
      provider.channelId,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(ChannelDetail Function() create) {
    return _$ChannelDetailFamilyOverride(this, create);
  }
}

class _$ChannelDetailFamilyOverride implements FamilyOverride {
  _$ChannelDetailFamilyOverride(this.overriddenFamily, this.create);

  final ChannelDetail Function() create;

  @override
  final ChannelDetailFamily overriddenFamily;

  @override
  ChannelDetailProvider getProviderOverride(
    covariant ChannelDetailProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [ChannelDetail].
class ChannelDetailProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ChannelDetail, ChannelDetailState> {
  /// See also [ChannelDetail].
  ChannelDetailProvider(
    String channelId,
  ) : this._internal(
          () => ChannelDetail()..channelId = channelId,
          from: channelDetailProvider,
          name: r'channelDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$channelDetailHash,
          dependencies: ChannelDetailFamily._dependencies,
          allTransitiveDependencies:
              ChannelDetailFamily._allTransitiveDependencies,
          channelId: channelId,
        );

  ChannelDetailProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.channelId,
  }) : super.internal();

  final String channelId;

  @override
  FutureOr<ChannelDetailState> runNotifierBuild(
    covariant ChannelDetail notifier,
  ) {
    return notifier.build(
      channelId,
    );
  }

  @override
  Override overrideWith(ChannelDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChannelDetailProvider._internal(
        () => create()..channelId = channelId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        channelId: channelId,
      ),
    );
  }

  @override
  (String,) get argument {
    return (channelId,);
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ChannelDetail, ChannelDetailState>
      createElement() {
    return _ChannelDetailProviderElement(this);
  }

  ChannelDetailProvider _copyWith(
    ChannelDetail Function() create,
  ) {
    return ChannelDetailProvider._internal(
      () => create()..channelId = channelId,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      channelId: channelId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChannelDetailProvider && other.channelId == channelId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, channelId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChannelDetailRef
    on AutoDisposeAsyncNotifierProviderRef<ChannelDetailState> {
  /// The parameter `channelId` of this provider.
  String get channelId;
}

class _ChannelDetailProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ChannelDetail,
        ChannelDetailState> with ChannelDetailRef {
  _ChannelDetailProviderElement(super.provider);

  @override
  String get channelId => (origin as ChannelDetailProvider).channelId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
