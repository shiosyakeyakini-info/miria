// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_create_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$noteCreateNotifierHash() =>
    r'b84b6ed0053fefa75f5a2d5bd53c11c7e226d035';

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
class NoteCreateNotifierFamily extends Family<NoteCreate> {
  /// See also [NoteCreateNotifier].
  const NoteCreateNotifierFamily();

  /// See also [NoteCreateNotifier].
  NoteCreateNotifierProvider call(
    Account account,
  ) {
    return NoteCreateNotifierProvider(
      account,
    );
  }

  @override
  NoteCreateNotifierProvider getProviderOverride(
    covariant NoteCreateNotifierProvider provider,
  ) {
    return call(
      provider.account,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'noteCreateNotifierProvider';
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
    super._createNotifier, {
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
  AutoDisposeNotifierProviderElement<NoteCreateNotifier, NoteCreate>
      createElement() {
    return _NoteCreateNotifierProviderElement(this);
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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
