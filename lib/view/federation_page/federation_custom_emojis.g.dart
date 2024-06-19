// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'federation_custom_emojis.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchEmojiHash() => r'9f7271a3e3365dca42f75fa7b5f3d0917950870f';

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

/// See also [fetchEmoji].
@ProviderFor(fetchEmoji)
const fetchEmojiProvider = FetchEmojiFamily();

/// See also [fetchEmoji].
class FetchEmojiFamily extends Family {
  /// See also [fetchEmoji].
  const FetchEmojiFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchEmojiProvider';

  /// See also [fetchEmoji].
  FetchEmojiProvider call(
    String host,
    MetaResponse meta,
  ) {
    return FetchEmojiProvider(
      host,
      meta,
    );
  }

  @visibleForOverriding
  @override
  FetchEmojiProvider getProviderOverride(
    covariant FetchEmojiProvider provider,
  ) {
    return call(
      provider.host,
      provider.meta,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<Map<String, List<Emoji>>> Function(FetchEmojiRef ref) create) {
    return _$FetchEmojiFamilyOverride(this, create);
  }
}

class _$FetchEmojiFamilyOverride implements FamilyOverride {
  _$FetchEmojiFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<Map<String, List<Emoji>>> Function(FetchEmojiRef ref) create;

  @override
  final FetchEmojiFamily overriddenFamily;

  @override
  FetchEmojiProvider getProviderOverride(
    covariant FetchEmojiProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [fetchEmoji].
class FetchEmojiProvider
    extends AutoDisposeFutureProvider<Map<String, List<Emoji>>> {
  /// See also [fetchEmoji].
  FetchEmojiProvider(
    String host,
    MetaResponse meta,
  ) : this._internal(
          (ref) => fetchEmoji(
            ref as FetchEmojiRef,
            host,
            meta,
          ),
          from: fetchEmojiProvider,
          name: r'fetchEmojiProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchEmojiHash,
          dependencies: FetchEmojiFamily._dependencies,
          allTransitiveDependencies:
              FetchEmojiFamily._allTransitiveDependencies,
          host: host,
          meta: meta,
        );

  FetchEmojiProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.host,
    required this.meta,
  }) : super.internal();

  final String host;
  final MetaResponse meta;

  @override
  Override overrideWith(
    FutureOr<Map<String, List<Emoji>>> Function(FetchEmojiRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchEmojiProvider._internal(
        (ref) => create(ref as FetchEmojiRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        host: host,
        meta: meta,
      ),
    );
  }

  @override
  (
    String,
    MetaResponse,
  ) get argument {
    return (
      host,
      meta,
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, List<Emoji>>> createElement() {
    return _FetchEmojiProviderElement(this);
  }

  FetchEmojiProvider _copyWith(
    FutureOr<Map<String, List<Emoji>>> Function(FetchEmojiRef ref) create,
  ) {
    return FetchEmojiProvider._internal(
      (ref) => create(ref as FetchEmojiRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      host: host,
      meta: meta,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FetchEmojiProvider &&
        other.host == host &&
        other.meta == meta;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, host.hashCode);
    hash = _SystemHash.combine(hash, meta.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchEmojiRef on AutoDisposeFutureProviderRef<Map<String, List<Emoji>>> {
  /// The parameter `host` of this provider.
  String get host;

  /// The parameter `meta` of this provider.
  MetaResponse get meta;
}

class _FetchEmojiProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, List<Emoji>>>
    with FetchEmojiRef {
  _FetchEmojiProviderElement(super.provider);

  @override
  String get host => (origin as FetchEmojiProvider).host;
  @override
  MetaResponse get meta => (origin as FetchEmojiProvider).meta;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
