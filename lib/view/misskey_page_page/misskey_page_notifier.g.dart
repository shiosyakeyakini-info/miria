// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_page_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$misskeyPageNotifierHash() =>
    r'a48c3db37f278a6213bb6d7f5c67c30339ab5acb';

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
  late final Account account;
  late final String pageId;

  FutureOr<MisskeyPageNotifierState> build(
    Account account,
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

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'misskeyPageNotifierProvider';

  /// See also [MisskeyPageNotifier].
  MisskeyPageNotifierProvider call(
    Account account,
    String pageId,
  ) {
    return MisskeyPageNotifierProvider(
      account,
      pageId,
    );
  }

  @visibleForOverriding
  @override
  MisskeyPageNotifierProvider getProviderOverride(
    covariant MisskeyPageNotifierProvider provider,
  ) {
    return call(
      provider.account,
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
    Account account,
    String pageId,
  ) : this._internal(
          () => MisskeyPageNotifier()
            ..account = account
            ..pageId = pageId,
          from: misskeyPageNotifierProvider,
          name: r'misskeyPageNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$misskeyPageNotifierHash,
          dependencies: MisskeyPageNotifierFamily._dependencies,
          allTransitiveDependencies:
              MisskeyPageNotifierFamily._allTransitiveDependencies,
          account: account,
          pageId: pageId,
        );

  MisskeyPageNotifierProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.account,
    required this.pageId,
  }) : super.internal();

  final Account account;
  final String pageId;

  @override
  FutureOr<MisskeyPageNotifierState> runNotifierBuild(
    covariant MisskeyPageNotifier notifier,
  ) {
    return notifier.build(
      account,
      pageId,
    );
  }

  @override
  Override overrideWith(MisskeyPageNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: MisskeyPageNotifierProvider._internal(
        () => create()
          ..account = account
          ..pageId = pageId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        account: account,
        pageId: pageId,
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
      pageId,
    );
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
      () => create()
        ..account = account
        ..pageId = pageId,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      account: account,
      pageId: pageId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MisskeyPageNotifierProvider &&
        other.account == account &&
        other.pageId == pageId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);
    hash = _SystemHash.combine(hash, pageId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MisskeyPageNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<MisskeyPageNotifierState> {
  /// The parameter `account` of this provider.
  Account get account;

  /// The parameter `pageId` of this provider.
  String get pageId;
}

class _MisskeyPageNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MisskeyPageNotifier,
        MisskeyPageNotifierState> with MisskeyPageNotifierRef {
  _MisskeyPageNotifierProviderElement(super.provider);

  @override
  Account get account => (origin as MisskeyPageNotifierProvider).account;
  @override
  String get pageId => (origin as MisskeyPageNotifierProvider).pageId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
