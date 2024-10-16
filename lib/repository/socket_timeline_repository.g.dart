// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_timeline_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$misskeyStreamingHash() => r'f56a883b14e639e71e8ec44952e56c0a527447c1';

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

/// See also [misskeyStreaming].
@ProviderFor(misskeyStreaming)
const misskeyStreamingProvider = MisskeyStreamingFamily();

/// See also [misskeyStreaming].
class MisskeyStreamingFamily extends Family {
  /// See also [misskeyStreaming].
  const MisskeyStreamingFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'misskeyStreamingProvider';

  /// See also [misskeyStreaming].
  MisskeyStreamingProvider call(
    Misskey misskey,
  ) {
    return MisskeyStreamingProvider(
      misskey,
    );
  }

  @visibleForOverriding
  @override
  MisskeyStreamingProvider getProviderOverride(
    covariant MisskeyStreamingProvider provider,
  ) {
    return call(
      provider.misskey,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<StreamingController> Function(MisskeyStreamingRef ref) create) {
    return _$MisskeyStreamingFamilyOverride(this, create);
  }
}

class _$MisskeyStreamingFamilyOverride implements FamilyOverride {
  _$MisskeyStreamingFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<StreamingController> Function(MisskeyStreamingRef ref) create;

  @override
  final MisskeyStreamingFamily overriddenFamily;

  @override
  MisskeyStreamingProvider getProviderOverride(
    covariant MisskeyStreamingProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [misskeyStreaming].
class MisskeyStreamingProvider extends FutureProvider<StreamingController> {
  /// See also [misskeyStreaming].
  MisskeyStreamingProvider(
    Misskey misskey,
  ) : this._internal(
          (ref) => misskeyStreaming(
            ref as MisskeyStreamingRef,
            misskey,
          ),
          from: misskeyStreamingProvider,
          name: r'misskeyStreamingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$misskeyStreamingHash,
          dependencies: MisskeyStreamingFamily._dependencies,
          allTransitiveDependencies:
              MisskeyStreamingFamily._allTransitiveDependencies,
          misskey: misskey,
        );

  MisskeyStreamingProvider._internal(
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
  Override overrideWith(
    FutureOr<StreamingController> Function(MisskeyStreamingRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MisskeyStreamingProvider._internal(
        (ref) => create(ref as MisskeyStreamingRef),
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
  FutureProviderElement<StreamingController> createElement() {
    return _MisskeyStreamingProviderElement(this);
  }

  MisskeyStreamingProvider _copyWith(
    FutureOr<StreamingController> Function(MisskeyStreamingRef ref) create,
  ) {
    return MisskeyStreamingProvider._internal(
      (ref) => create(ref as MisskeyStreamingRef),
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
    return other is MisskeyStreamingProvider && other.misskey == misskey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, misskey.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MisskeyStreamingRef on FutureProviderRef<StreamingController> {
  /// The parameter `misskey` of this provider.
  Misskey get misskey;
}

class _MisskeyStreamingProviderElement
    extends FutureProviderElement<StreamingController>
    with MisskeyStreamingRef {
  _MisskeyStreamingProviderElement(super.provider);

  @override
  Misskey get misskey => (origin as MisskeyStreamingProvider).misskey;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
