// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_create_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$noteCreateNotifierHash() =>
    r'2c97d94482937fad9949829c46507b072da21bde';

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

abstract class _$NoteCreateNotifier
    extends BuildlessAutoDisposeNotifier<NoteCreate> {
  late final Account account;

  NoteCreate build(
    Account account,
  );
}

/// See also [NoteCreateNotifier].
@ProviderFor(NoteCreateNotifier)
const noteCreateNotifierProvider = NoteCreateNotifierFamily();

/// See also [NoteCreateNotifier].
class NoteCreateNotifierFamily extends Family {
  /// See also [NoteCreateNotifier].
  const NoteCreateNotifierFamily();

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    misskeyPostContextProvider,
    notesWithProvider
  ];

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    misskeyPostContextProvider,
    ...?misskeyPostContextProvider.allTransitiveDependencies,
    notesWithProvider,
    ...?notesWithProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'noteCreateNotifierProvider';

  /// See also [NoteCreateNotifier].
  NoteCreateNotifierProvider call(
    Account account,
  ) {
    return NoteCreateNotifierProvider(
      account,
    );
  }

  @visibleForOverriding
  @override
  NoteCreateNotifierProvider getProviderOverride(
    covariant NoteCreateNotifierProvider provider,
  ) {
    return call(
      provider.account,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(NoteCreateNotifier Function() create) {
    return _$NoteCreateNotifierFamilyOverride(this, create);
  }
}

class _$NoteCreateNotifierFamilyOverride implements FamilyOverride {
  _$NoteCreateNotifierFamilyOverride(this.overriddenFamily, this.create);

  final NoteCreateNotifier Function() create;

  @override
  final NoteCreateNotifierFamily overriddenFamily;

  @override
  NoteCreateNotifierProvider getProviderOverride(
    covariant NoteCreateNotifierProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [NoteCreateNotifier].
class NoteCreateNotifierProvider
    extends AutoDisposeNotifierProviderImpl<NoteCreateNotifier, NoteCreate> {
  /// See also [NoteCreateNotifier].
  NoteCreateNotifierProvider(
    Account account,
  ) : this._internal(
          () => NoteCreateNotifier()..account = account,
          from: noteCreateNotifierProvider,
          name: r'noteCreateNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$noteCreateNotifierHash,
          dependencies: NoteCreateNotifierFamily._dependencies,
          allTransitiveDependencies:
              NoteCreateNotifierFamily._allTransitiveDependencies,
          account: account,
        );

  NoteCreateNotifierProvider._internal(
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
  NoteCreate runNotifierBuild(
    covariant NoteCreateNotifier notifier,
  ) {
    return notifier.build(
      account,
    );
  }

  @override
  Override overrideWith(NoteCreateNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: NoteCreateNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<NoteCreateNotifier, NoteCreate>
      createElement() {
    return _NoteCreateNotifierProviderElement(this);
  }

  NoteCreateNotifierProvider _copyWith(
    NoteCreateNotifier Function() create,
  ) {
    return NoteCreateNotifierProvider._internal(
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
    return other is NoteCreateNotifierProvider && other.account == account;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NoteCreateNotifierRef on AutoDisposeNotifierProviderRef<NoteCreate> {
  /// The parameter `account` of this provider.
  Account get account;
}

class _NoteCreateNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<NoteCreateNotifier, NoteCreate>
    with NoteCreateNotifierRef {
  _NoteCreateNotifierProviderElement(super.provider);

  @override
  Account get account => (origin as NoteCreateNotifierProvider).account;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
