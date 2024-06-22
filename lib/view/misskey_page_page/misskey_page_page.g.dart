// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_page_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchNoteHash() => r'19df39fbffe9dff5fee801e90a30981b4121f708';

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

/// See also [fetchNote].
@ProviderFor(fetchNote)
const fetchNoteProvider = FetchNoteFamily();

/// See also [fetchNote].
class FetchNoteFamily extends Family {
  /// See also [fetchNote].
  const FetchNoteFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchNoteProvider';

  /// See also [fetchNote].
  FetchNoteProvider call(
    Account account,
    String noteId,
  ) {
    return FetchNoteProvider(
      account,
      noteId,
    );
  }

  @visibleForOverriding
  @override
  FetchNoteProvider getProviderOverride(
    covariant FetchNoteProvider provider,
  ) {
    return call(
      provider.account,
      provider.noteId,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(FutureOr<Note> Function(FetchNoteRef ref) create) {
    return _$FetchNoteFamilyOverride(this, create);
  }
}

class _$FetchNoteFamilyOverride implements FamilyOverride {
  _$FetchNoteFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<Note> Function(FetchNoteRef ref) create;

  @override
  final FetchNoteFamily overriddenFamily;

  @override
  FetchNoteProvider getProviderOverride(
    covariant FetchNoteProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [fetchNote].
class FetchNoteProvider extends AutoDisposeFutureProvider<Note> {
  /// See also [fetchNote].
  FetchNoteProvider(
    Account account,
    String noteId,
  ) : this._internal(
          (ref) => fetchNote(
            ref as FetchNoteRef,
            account,
            noteId,
          ),
          from: fetchNoteProvider,
          name: r'fetchNoteProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchNoteHash,
          dependencies: FetchNoteFamily._dependencies,
          allTransitiveDependencies: FetchNoteFamily._allTransitiveDependencies,
          account: account,
          noteId: noteId,
        );

  FetchNoteProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.account,
    required this.noteId,
  }) : super.internal();

  final Account account;
  final String noteId;

  @override
  Override overrideWith(
    FutureOr<Note> Function(FetchNoteRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchNoteProvider._internal(
        (ref) => create(ref as FetchNoteRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        account: account,
        noteId: noteId,
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
      noteId,
    );
  }

  @override
  AutoDisposeFutureProviderElement<Note> createElement() {
    return _FetchNoteProviderElement(this);
  }

  FetchNoteProvider _copyWith(
    FutureOr<Note> Function(FetchNoteRef ref) create,
  ) {
    return FetchNoteProvider._internal(
      (ref) => create(ref as FetchNoteRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      account: account,
      noteId: noteId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FetchNoteProvider &&
        other.account == account &&
        other.noteId == noteId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);
    hash = _SystemHash.combine(hash, noteId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchNoteRef on AutoDisposeFutureProviderRef<Note> {
  /// The parameter `account` of this provider.
  Account get account;

  /// The parameter `noteId` of this provider.
  String get noteId;
}

class _FetchNoteProviderElement extends AutoDisposeFutureProviderElement<Note>
    with FetchNoteRef {
  _FetchNoteProviderElement(super.provider);

  @override
  Account get account => (origin as FetchNoteProvider).account;
  @override
  String get noteId => (origin as FetchNoteProvider).noteId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
