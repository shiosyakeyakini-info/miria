// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_note_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$misskeyNoteNotifierHash() =>
    r'20591a74a92ee48715376a65f47ccf3d383cfc29';

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

abstract class _$MisskeyNoteNotifier
    extends BuildlessAutoDisposeNotifier<void> {
  late final Account account;

  void build(
    Account account,
  );
}

/// See also [MisskeyNoteNotifier].
@ProviderFor(MisskeyNoteNotifier)
const misskeyNoteNotifierProvider = MisskeyNoteNotifierFamily();

/// See also [MisskeyNoteNotifier].
class MisskeyNoteNotifierFamily extends Family {
  /// See also [MisskeyNoteNotifier].
  const MisskeyNoteNotifierFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'misskeyNoteNotifierProvider';

  /// See also [MisskeyNoteNotifier].
  MisskeyNoteNotifierProvider call(
    Account account,
  ) {
    return MisskeyNoteNotifierProvider(
      account,
    );
  }

  @visibleForOverriding
  @override
  MisskeyNoteNotifierProvider getProviderOverride(
    covariant MisskeyNoteNotifierProvider provider,
  ) {
    return call(
      provider.account,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(MisskeyNoteNotifier Function() create) {
    return _$MisskeyNoteNotifierFamilyOverride(this, create);
  }
}

class _$MisskeyNoteNotifierFamilyOverride implements FamilyOverride {
  _$MisskeyNoteNotifierFamilyOverride(this.overriddenFamily, this.create);

  final MisskeyNoteNotifier Function() create;

  @override
  final MisskeyNoteNotifierFamily overriddenFamily;

  @override
  MisskeyNoteNotifierProvider getProviderOverride(
    covariant MisskeyNoteNotifierProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [MisskeyNoteNotifier].
class MisskeyNoteNotifierProvider
    extends AutoDisposeNotifierProviderImpl<MisskeyNoteNotifier, void> {
  /// See also [MisskeyNoteNotifier].
  MisskeyNoteNotifierProvider(
    Account account,
  ) : this._internal(
          () => MisskeyNoteNotifier()..account = account,
          from: misskeyNoteNotifierProvider,
          name: r'misskeyNoteNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$misskeyNoteNotifierHash,
          dependencies: MisskeyNoteNotifierFamily._dependencies,
          allTransitiveDependencies:
              MisskeyNoteNotifierFamily._allTransitiveDependencies,
          account: account,
        );

  MisskeyNoteNotifierProvider._internal(
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
  void runNotifierBuild(
    covariant MisskeyNoteNotifier notifier,
  ) {
    return notifier.build(
      account,
    );
  }

  @override
  Override overrideWith(MisskeyNoteNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: MisskeyNoteNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<MisskeyNoteNotifier, void>
      createElement() {
    return _MisskeyNoteNotifierProviderElement(this);
  }

  MisskeyNoteNotifierProvider _copyWith(
    MisskeyNoteNotifier Function() create,
  ) {
    return MisskeyNoteNotifierProvider._internal(
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
    return other is MisskeyNoteNotifierProvider && other.account == account;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MisskeyNoteNotifierRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `account` of this provider.
  Account get account;
}

class _MisskeyNoteNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<MisskeyNoteNotifier, void>
    with MisskeyNoteNotifierRef {
  _MisskeyNoteNotifierProviderElement(super.provider);

  @override
  Account get account => (origin as MisskeyNoteNotifierProvider).account;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
