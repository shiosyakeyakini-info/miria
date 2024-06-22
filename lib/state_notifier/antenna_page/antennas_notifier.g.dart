// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'antennas_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$antennasNotifierHash() => r'bc971acc312b22119b0a1b1f7bc749fad635a777';

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

abstract class _$AntennasNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<Antenna>> {
  late final Misskey misskey;

  FutureOr<List<Antenna>> build(
    Misskey misskey,
  );
}

/// See also [AntennasNotifier].
@ProviderFor(AntennasNotifier)
const antennasNotifierProvider = AntennasNotifierFamily();

/// See also [AntennasNotifier].
class AntennasNotifierFamily extends Family {
  /// See also [AntennasNotifier].
  const AntennasNotifierFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'antennasNotifierProvider';

  /// See also [AntennasNotifier].
  AntennasNotifierProvider call(
    Misskey misskey,
  ) {
    return AntennasNotifierProvider(
      misskey,
    );
  }

  @visibleForOverriding
  @override
  AntennasNotifierProvider getProviderOverride(
    covariant AntennasNotifierProvider provider,
  ) {
    return call(
      provider.misskey,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(AntennasNotifier Function() create) {
    return _$AntennasNotifierFamilyOverride(this, create);
  }
}

class _$AntennasNotifierFamilyOverride implements FamilyOverride {
  _$AntennasNotifierFamilyOverride(this.overriddenFamily, this.create);

  final AntennasNotifier Function() create;

  @override
  final AntennasNotifierFamily overriddenFamily;

  @override
  AntennasNotifierProvider getProviderOverride(
    covariant AntennasNotifierProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [AntennasNotifier].
class AntennasNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    AntennasNotifier, List<Antenna>> {
  /// See also [AntennasNotifier].
  AntennasNotifierProvider(
    Misskey misskey,
  ) : this._internal(
          () => AntennasNotifier()..misskey = misskey,
          from: antennasNotifierProvider,
          name: r'antennasNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$antennasNotifierHash,
          dependencies: AntennasNotifierFamily._dependencies,
          allTransitiveDependencies:
              AntennasNotifierFamily._allTransitiveDependencies,
          misskey: misskey,
        );

  AntennasNotifierProvider._internal(
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
  FutureOr<List<Antenna>> runNotifierBuild(
    covariant AntennasNotifier notifier,
  ) {
    return notifier.build(
      misskey,
    );
  }

  @override
  Override overrideWith(AntennasNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: AntennasNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<AntennasNotifier, List<Antenna>>
      createElement() {
    return _AntennasNotifierProviderElement(this);
  }

  AntennasNotifierProvider _copyWith(
    AntennasNotifier Function() create,
  ) {
    return AntennasNotifierProvider._internal(
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
    return other is AntennasNotifierProvider && other.misskey == misskey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, misskey.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AntennasNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<Antenna>> {
  /// The parameter `misskey` of this provider.
  Misskey get misskey;
}

class _AntennasNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<AntennasNotifier,
        List<Antenna>> with AntennasNotifierRef {
  _AntennasNotifierProviderElement(super.provider);

  @override
  Misskey get misskey => (origin as AntennasNotifierProvider).misskey;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
