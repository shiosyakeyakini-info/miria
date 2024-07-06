// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_page_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$misskeyPageNotifierHash() =>
    r'584b3c35a6e2456887fdce91f96ef3da288044f7';

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

abstract class _$MisskeyPageNotifier
    extends BuildlessAutoDisposeAsyncNotifier<MisskeyPageNotifierState> {
  late final String pageId;

  FutureOr<MisskeyPageNotifierState> build(
    String pageId,
  );
}

/// See also [MisskeyPageNotifier].
@ProviderFor(MisskeyPageNotifier)
const misskeyPageNotifierProvider = MisskeyPageNotifierFamily();

/// See also [MisskeyPageNotifier].
class MisskeyPageNotifierFamily extends Family {
  /// See also [MisskeyPageNotifier].
  const MisskeyPageNotifierFamily();

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
  String? get name => r'misskeyPageNotifierProvider';

  /// See also [MisskeyPageNotifier].
  MisskeyPageNotifierProvider call(
    String pageId,
  ) {
    return MisskeyPageNotifierProvider(
      pageId,
    );
  }

  @visibleForOverriding
  @override
  MisskeyPageNotifierProvider getProviderOverride(
    covariant MisskeyPageNotifierProvider provider,
  ) {
    return call(
      provider.pageId,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(MisskeyPageNotifier Function() create) {
    return _$MisskeyPageNotifierFamilyOverride(this, create);
  }
}

class _$MisskeyPageNotifierFamilyOverride implements FamilyOverride {
  _$MisskeyPageNotifierFamilyOverride(this.overriddenFamily, this.create);

  final MisskeyPageNotifier Function() create;

  @override
  final MisskeyPageNotifierFamily overriddenFamily;

  @override
  MisskeyPageNotifierProvider getProviderOverride(
    covariant MisskeyPageNotifierProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [MisskeyPageNotifier].
class MisskeyPageNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    MisskeyPageNotifier, MisskeyPageNotifierState> {
  /// See also [MisskeyPageNotifier].
  MisskeyPageNotifierProvider(
    String pageId,
  ) : this._internal(
          () => MisskeyPageNotifier()..pageId = pageId,
          from: misskeyPageNotifierProvider,
          name: r'misskeyPageNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$misskeyPageNotifierHash,
          dependencies: MisskeyPageNotifierFamily._dependencies,
          allTransitiveDependencies:
              MisskeyPageNotifierFamily._allTransitiveDependencies,
          pageId: pageId,
        );

  MisskeyPageNotifierProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pageId,
  }) : super.internal();

  final String pageId;

  @override
  FutureOr<MisskeyPageNotifierState> runNotifierBuild(
    covariant MisskeyPageNotifier notifier,
  ) {
    return notifier.build(
      pageId,
    );
  }

  @override
  Override overrideWith(MisskeyPageNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: MisskeyPageNotifierProvider._internal(
        () => create()..pageId = pageId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pageId: pageId,
      ),
    );
  }

  @override
  (String,) get argument {
    return (pageId,);
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<MisskeyPageNotifier,
      MisskeyPageNotifierState> createElement() {
    return _MisskeyPageNotifierProviderElement(this);
  }

  MisskeyPageNotifierProvider _copyWith(
    MisskeyPageNotifier Function() create,
  ) {
    return MisskeyPageNotifierProvider._internal(
      () => create()..pageId = pageId,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      pageId: pageId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MisskeyPageNotifierProvider && other.pageId == pageId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pageId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MisskeyPageNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<MisskeyPageNotifierState> {
  /// The parameter `pageId` of this provider.
  String get pageId;
}

class _MisskeyPageNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MisskeyPageNotifier,
        MisskeyPageNotifierState> with MisskeyPageNotifierRef {
  _MisskeyPageNotifierProviderElement(super.provider);

  @override
  String get pageId => (origin as MisskeyPageNotifierProvider).pageId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
