// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'renote_modal_sheet.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$renoteNotifierHash() => r'2f8d167b63754ec318a4f0f76509e87798948ec6';

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

abstract class _$RenoteNotifier
    extends BuildlessAutoDisposeNotifier<AsyncValue<void>?> {
  late final Account account;
  late final Note note;

  AsyncValue<void>? build(
    Account account,
    Note note,
  );
}

/// See also [RenoteNotifier].
@ProviderFor(RenoteNotifier)
const renoteNotifierProvider = RenoteNotifierFamily();

/// See also [RenoteNotifier].
class RenoteNotifierFamily extends Family {
  /// See also [RenoteNotifier].
  const RenoteNotifierFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'renoteNotifierProvider';

  /// See also [RenoteNotifier].
  RenoteNotifierProvider call(
    Account account,
    Note note,
  ) {
    return RenoteNotifierProvider(
      account,
      note,
    );
  }

  @visibleForOverriding
  @override
  RenoteNotifierProvider getProviderOverride(
    covariant RenoteNotifierProvider provider,
  ) {
    return call(
      provider.account,
      provider.note,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(RenoteNotifier Function() create) {
    return _$RenoteNotifierFamilyOverride(this, create);
  }
}

class _$RenoteNotifierFamilyOverride implements FamilyOverride {
  _$RenoteNotifierFamilyOverride(this.overriddenFamily, this.create);

  final RenoteNotifier Function() create;

  @override
  final RenoteNotifierFamily overriddenFamily;

  @override
  RenoteNotifierProvider getProviderOverride(
    covariant RenoteNotifierProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [RenoteNotifier].
class RenoteNotifierProvider
    extends AutoDisposeNotifierProviderImpl<RenoteNotifier, AsyncValue<void>?> {
  /// See also [RenoteNotifier].
  RenoteNotifierProvider(
    Account account,
    Note note,
  ) : this._internal(
          () => RenoteNotifier()
            ..account = account
            ..note = note,
          from: renoteNotifierProvider,
          name: r'renoteNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$renoteNotifierHash,
          dependencies: RenoteNotifierFamily._dependencies,
          allTransitiveDependencies:
              RenoteNotifierFamily._allTransitiveDependencies,
          account: account,
          note: note,
        );

  RenoteNotifierProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.account,
    required this.note,
  }) : super.internal();

  final Account account;
  final Note note;

  @override
  AsyncValue<void>? runNotifierBuild(
    covariant RenoteNotifier notifier,
  ) {
    return notifier.build(
      account,
      note,
    );
  }

  @override
  Override overrideWith(RenoteNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: RenoteNotifierProvider._internal(
        () => create()
          ..account = account
          ..note = note,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        account: account,
        note: note,
      ),
    );
  }

  @override
  (
    Account,
    Note,
  ) get argument {
    return (
      account,
      note,
    );
  }

  @override
  AutoDisposeNotifierProviderElement<RenoteNotifier, AsyncValue<void>?>
      createElement() {
    return _RenoteNotifierProviderElement(this);
  }

  RenoteNotifierProvider _copyWith(
    RenoteNotifier Function() create,
  ) {
    return RenoteNotifierProvider._internal(
      () => create()
        ..account = account
        ..note = note,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      account: account,
      note: note,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RenoteNotifierProvider &&
        other.account == account &&
        other.note == note;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);
    hash = _SystemHash.combine(hash, note.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RenoteNotifierRef on AutoDisposeNotifierProviderRef<AsyncValue<void>?> {
  /// The parameter `account` of this provider.
  Account get account;

  /// The parameter `note` of this provider.
  Note get note;
}

class _RenoteNotifierProviderElement extends AutoDisposeNotifierProviderElement<
    RenoteNotifier, AsyncValue<void>?> with RenoteNotifierRef {
  _RenoteNotifierProviderElement(super.provider);

  @override
  Account get account => (origin as RenoteNotifierProvider).account;
  @override
  Note get note => (origin as RenoteNotifierProvider).note;
}

String _$renoteChannelNotifierHash() =>
    r'c519cce3b931c05ce41c7d31f69e849feca88bff';

abstract class _$RenoteChannelNotifier
    extends BuildlessAutoDisposeNotifier<AsyncValue<CommunityChannel>?> {
  late final Account account;

  AsyncValue<CommunityChannel>? build(
    Account account,
  );
}

/// See also [RenoteChannelNotifier].
@ProviderFor(RenoteChannelNotifier)
const renoteChannelNotifierProvider = RenoteChannelNotifierFamily();

/// See also [RenoteChannelNotifier].
class RenoteChannelNotifierFamily extends Family {
  /// See also [RenoteChannelNotifier].
  const RenoteChannelNotifierFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'renoteChannelNotifierProvider';

  /// See also [RenoteChannelNotifier].
  RenoteChannelNotifierProvider call(
    Account account,
  ) {
    return RenoteChannelNotifierProvider(
      account,
    );
  }

  @visibleForOverriding
  @override
  RenoteChannelNotifierProvider getProviderOverride(
    covariant RenoteChannelNotifierProvider provider,
  ) {
    return call(
      provider.account,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(RenoteChannelNotifier Function() create) {
    return _$RenoteChannelNotifierFamilyOverride(this, create);
  }
}

class _$RenoteChannelNotifierFamilyOverride implements FamilyOverride {
  _$RenoteChannelNotifierFamilyOverride(this.overriddenFamily, this.create);

  final RenoteChannelNotifier Function() create;

  @override
  final RenoteChannelNotifierFamily overriddenFamily;

  @override
  RenoteChannelNotifierProvider getProviderOverride(
    covariant RenoteChannelNotifierProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [RenoteChannelNotifier].
class RenoteChannelNotifierProvider extends AutoDisposeNotifierProviderImpl<
    RenoteChannelNotifier, AsyncValue<CommunityChannel>?> {
  /// See also [RenoteChannelNotifier].
  RenoteChannelNotifierProvider(
    Account account,
  ) : this._internal(
          () => RenoteChannelNotifier()..account = account,
          from: renoteChannelNotifierProvider,
          name: r'renoteChannelNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$renoteChannelNotifierHash,
          dependencies: RenoteChannelNotifierFamily._dependencies,
          allTransitiveDependencies:
              RenoteChannelNotifierFamily._allTransitiveDependencies,
          account: account,
        );

  RenoteChannelNotifierProvider._internal(
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
  AsyncValue<CommunityChannel>? runNotifierBuild(
    covariant RenoteChannelNotifier notifier,
  ) {
    return notifier.build(
      account,
    );
  }

  @override
  Override overrideWith(RenoteChannelNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: RenoteChannelNotifierProvider._internal(
        () => create()..account = account,
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
  AutoDisposeNotifierProviderElement<RenoteChannelNotifier,
      AsyncValue<CommunityChannel>?> createElement() {
    return _RenoteChannelNotifierProviderElement(this);
  }

  RenoteChannelNotifierProvider _copyWith(
    RenoteChannelNotifier Function() create,
  ) {
    return RenoteChannelNotifierProvider._internal(
      () => create()..account = account,
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
    return other is RenoteChannelNotifierProvider && other.account == account;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RenoteChannelNotifierRef
    on AutoDisposeNotifierProviderRef<AsyncValue<CommunityChannel>?> {
  /// The parameter `account` of this provider.
  Account get account;
}

class _RenoteChannelNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<RenoteChannelNotifier,
        AsyncValue<CommunityChannel>?> with RenoteChannelNotifierRef {
  _RenoteChannelNotifierProviderElement(super.provider);

  @override
  Account get account => (origin as RenoteChannelNotifierProvider).account;
}

String _$renoteOtherAccountNotifierHash() =>
    r'e3176e375b9657de2d8e05483e5f6d7add7a1ef2';

abstract class _$RenoteOtherAccountNotifier
    extends BuildlessAutoDisposeNotifier<AsyncValue<(Account, Note)>?> {
  late final Account account;
  late final Note note;

  AsyncValue<(Account, Note)>? build(
    Account account,
    Note note,
  );
}

/// See also [RenoteOtherAccountNotifier].
@ProviderFor(RenoteOtherAccountNotifier)
const renoteOtherAccountNotifierProvider = RenoteOtherAccountNotifierFamily();

/// See also [RenoteOtherAccountNotifier].
class RenoteOtherAccountNotifierFamily extends Family {
  /// See also [RenoteOtherAccountNotifier].
  const RenoteOtherAccountNotifierFamily();

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    accountContextProvider
  ];

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    accountContextProvider,
    ...?accountContextProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'renoteOtherAccountNotifierProvider';

  /// See also [RenoteOtherAccountNotifier].
  RenoteOtherAccountNotifierProvider call(
    Account account,
    Note note,
  ) {
    return RenoteOtherAccountNotifierProvider(
      account,
      note,
    );
  }

  @visibleForOverriding
  @override
  RenoteOtherAccountNotifierProvider getProviderOverride(
    covariant RenoteOtherAccountNotifierProvider provider,
  ) {
    return call(
      provider.account,
      provider.note,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(RenoteOtherAccountNotifier Function() create) {
    return _$RenoteOtherAccountNotifierFamilyOverride(this, create);
  }
}

class _$RenoteOtherAccountNotifierFamilyOverride implements FamilyOverride {
  _$RenoteOtherAccountNotifierFamilyOverride(
      this.overriddenFamily, this.create);

  final RenoteOtherAccountNotifier Function() create;

  @override
  final RenoteOtherAccountNotifierFamily overriddenFamily;

  @override
  RenoteOtherAccountNotifierProvider getProviderOverride(
    covariant RenoteOtherAccountNotifierProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [RenoteOtherAccountNotifier].
class RenoteOtherAccountNotifierProvider
    extends AutoDisposeNotifierProviderImpl<RenoteOtherAccountNotifier,
        AsyncValue<(Account, Note)>?> {
  /// See also [RenoteOtherAccountNotifier].
  RenoteOtherAccountNotifierProvider(
    Account account,
    Note note,
  ) : this._internal(
          () => RenoteOtherAccountNotifier()
            ..account = account
            ..note = note,
          from: renoteOtherAccountNotifierProvider,
          name: r'renoteOtherAccountNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$renoteOtherAccountNotifierHash,
          dependencies: RenoteOtherAccountNotifierFamily._dependencies,
          allTransitiveDependencies:
              RenoteOtherAccountNotifierFamily._allTransitiveDependencies,
          account: account,
          note: note,
        );

  RenoteOtherAccountNotifierProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.account,
    required this.note,
  }) : super.internal();

  final Account account;
  final Note note;

  @override
  AsyncValue<(Account, Note)>? runNotifierBuild(
    covariant RenoteOtherAccountNotifier notifier,
  ) {
    return notifier.build(
      account,
      note,
    );
  }

  @override
  Override overrideWith(RenoteOtherAccountNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: RenoteOtherAccountNotifierProvider._internal(
        () => create()
          ..account = account
          ..note = note,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        account: account,
        note: note,
      ),
    );
  }

  @override
  (
    Account,
    Note,
  ) get argument {
    return (
      account,
      note,
    );
  }

  @override
  AutoDisposeNotifierProviderElement<RenoteOtherAccountNotifier,
      AsyncValue<(Account, Note)>?> createElement() {
    return _RenoteOtherAccountNotifierProviderElement(this);
  }

  RenoteOtherAccountNotifierProvider _copyWith(
    RenoteOtherAccountNotifier Function() create,
  ) {
    return RenoteOtherAccountNotifierProvider._internal(
      () => create()
        ..account = account
        ..note = note,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      account: account,
      note: note,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RenoteOtherAccountNotifierProvider &&
        other.account == account &&
        other.note == note;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);
    hash = _SystemHash.combine(hash, note.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RenoteOtherAccountNotifierRef
    on AutoDisposeNotifierProviderRef<AsyncValue<(Account, Note)>?> {
  /// The parameter `account` of this provider.
  Account get account;

  /// The parameter `note` of this provider.
  Note get note;
}

class _RenoteOtherAccountNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<RenoteOtherAccountNotifier,
        AsyncValue<(Account, Note)>?> with RenoteOtherAccountNotifierRef {
  _RenoteOtherAccountNotifierProviderElement(super.provider);

  @override
  Account get account => (origin as RenoteOtherAccountNotifierProvider).account;
  @override
  Note get note => (origin as RenoteOtherAccountNotifierProvider).note;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
