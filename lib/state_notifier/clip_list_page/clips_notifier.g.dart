// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clips_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$clipsNotifierHash() => r'e33dd35d37836ee3b3cf269696fbadfcff2f1add';

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

abstract class _$ClipsNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<Clip>> {
  late final Misskey misskey;

  FutureOr<List<Clip>> build(
    Misskey misskey,
  );
}

/// See also [ClipsNotifier].
@ProviderFor(ClipsNotifier)
const clipsNotifierProvider = ClipsNotifierFamily();

/// See also [ClipsNotifier].
class ClipsNotifierFamily extends Family {
  /// See also [ClipsNotifier].
  const ClipsNotifierFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'clipsNotifierProvider';

  /// See also [ClipsNotifier].
  ClipsNotifierProvider call(
    Misskey misskey,
  ) {
    return ClipsNotifierProvider(
      misskey,
    );
  }

  @visibleForOverriding
  @override
  ClipsNotifierProvider getProviderOverride(
    covariant ClipsNotifierProvider provider,
  ) {
    return call(
      provider.misskey,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(ClipsNotifier Function() create) {
    return _$ClipsNotifierFamilyOverride(this, create);
  }
}

class _$ClipsNotifierFamilyOverride implements FamilyOverride {
  _$ClipsNotifierFamilyOverride(this.overriddenFamily, this.create);

  final ClipsNotifier Function() create;

  @override
  final ClipsNotifierFamily overriddenFamily;

  @override
  ClipsNotifierProvider getProviderOverride(
    covariant ClipsNotifierProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [ClipsNotifier].
class ClipsNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ClipsNotifier, List<Clip>> {
  /// See also [ClipsNotifier].
  ClipsNotifierProvider(
    Misskey misskey,
  ) : this._internal(
          () => ClipsNotifier()..misskey = misskey,
          from: clipsNotifierProvider,
          name: r'clipsNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$clipsNotifierHash,
          dependencies: ClipsNotifierFamily._dependencies,
          allTransitiveDependencies:
              ClipsNotifierFamily._allTransitiveDependencies,
          misskey: misskey,
        );

  ClipsNotifierProvider._internal(
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
  FutureOr<List<Clip>> runNotifierBuild(
    covariant ClipsNotifier notifier,
  ) {
    return notifier.build(
      misskey,
    );
  }

  @override
  Override overrideWith(ClipsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ClipsNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<ClipsNotifier, List<Clip>>
      createElement() {
    return _ClipsNotifierProviderElement(this);
  }

  ClipsNotifierProvider _copyWith(
    ClipsNotifier Function() create,
  ) {
    return ClipsNotifierProvider._internal(
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
    return other is ClipsNotifierProvider && other.misskey == misskey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, misskey.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ClipsNotifierRef on AutoDisposeAsyncNotifierProviderRef<List<Clip>> {
  /// The parameter `misskey` of this provider.
  Misskey get misskey;
}

class _ClipsNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ClipsNotifier, List<Clip>>
    with ClipsNotifierRef {
  _ClipsNotifierProviderElement(super.provider);

  @override
  Misskey get misskey => (origin as ClipsNotifierProvider).misskey;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
