// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_detail_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notesShowHash() => r'63ae72993a53ae11435a15f7dea995e715e75d03';

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

/// See also [_notesShow].
@ProviderFor(_notesShow)
const _notesShowProvider = _NotesShowFamily();

/// See also [_notesShow].
class _NotesShowFamily extends Family {
  /// See also [_notesShow].
  const _NotesShowFamily();

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    misskeyGetContextProvider,
    notesWithProvider
  ];

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    misskeyGetContextProvider,
    ...?misskeyGetContextProvider.allTransitiveDependencies,
    notesWithProvider,
    ...?notesWithProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'_notesShowProvider';

  /// See also [_notesShow].
  _NotesShowProvider call(
    String noteId,
  ) {
    return _NotesShowProvider(
      noteId,
    );
  }

  @visibleForOverriding
  @override
  _NotesShowProvider getProviderOverride(
    covariant _NotesShowProvider provider,
  ) {
    return call(
      provider.noteId,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(FutureOr<Note> Function(_NotesShowRef ref) create) {
    return _$NotesShowFamilyOverride(this, create);
  }
}

class _$NotesShowFamilyOverride implements FamilyOverride {
  _$NotesShowFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<Note> Function(_NotesShowRef ref) create;

  @override
  final _NotesShowFamily overriddenFamily;

  @override
  _NotesShowProvider getProviderOverride(
    covariant _NotesShowProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [_notesShow].
class _NotesShowProvider extends AutoDisposeFutureProvider<Note> {
  /// See also [_notesShow].
  _NotesShowProvider(
    String noteId,
  ) : this._internal(
          (ref) => _notesShow(
            ref as _NotesShowRef,
            noteId,
          ),
          from: _notesShowProvider,
          name: r'_notesShowProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$notesShowHash,
          dependencies: _NotesShowFamily._dependencies,
          allTransitiveDependencies:
              _NotesShowFamily._allTransitiveDependencies,
          noteId: noteId,
        );

  _NotesShowProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.noteId,
  }) : super.internal();

  final String noteId;

  @override
  Override overrideWith(
    FutureOr<Note> Function(_NotesShowRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _NotesShowProvider._internal(
        (ref) => create(ref as _NotesShowRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        noteId: noteId,
      ),
    );
  }

  @override
  (String,) get argument {
    return (noteId,);
  }

  @override
  AutoDisposeFutureProviderElement<Note> createElement() {
    return _NotesShowProviderElement(this);
  }

  _NotesShowProvider _copyWith(
    FutureOr<Note> Function(_NotesShowRef ref) create,
  ) {
    return _NotesShowProvider._internal(
      (ref) => create(ref as _NotesShowRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      noteId: noteId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _NotesShowProvider && other.noteId == noteId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, noteId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin _NotesShowRef on AutoDisposeFutureProviderRef<Note> {
  /// The parameter `noteId` of this provider.
  String get noteId;
}

class _NotesShowProviderElement extends AutoDisposeFutureProviderElement<Note>
    with _NotesShowRef {
  _NotesShowProviderElement(super.provider);

  @override
  String get noteId => (origin as _NotesShowProvider).noteId;
}

String _$conversationHash() => r'6135b7e553bb745dd69625bc4aaa17efbf72aec5';

/// See also [_conversation].
@ProviderFor(_conversation)
const _conversationProvider = _ConversationFamily();

/// See also [_conversation].
class _ConversationFamily extends Family {
  /// See also [_conversation].
  const _ConversationFamily();

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    misskeyGetContextProvider,
    notesWithProvider
  ];

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    misskeyGetContextProvider,
    ...?misskeyGetContextProvider.allTransitiveDependencies,
    notesWithProvider,
    ...?notesWithProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'_conversationProvider';

  /// See also [_conversation].
  _ConversationProvider call(
    String noteId,
  ) {
    return _ConversationProvider(
      noteId,
    );
  }

  @visibleForOverriding
  @override
  _ConversationProvider getProviderOverride(
    covariant _ConversationProvider provider,
  ) {
    return call(
      provider.noteId,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<List<Note>> Function(_ConversationRef ref) create) {
    return _$ConversationFamilyOverride(this, create);
  }
}

class _$ConversationFamilyOverride implements FamilyOverride {
  _$ConversationFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<List<Note>> Function(_ConversationRef ref) create;

  @override
  final _ConversationFamily overriddenFamily;

  @override
  _ConversationProvider getProviderOverride(
    covariant _ConversationProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [_conversation].
class _ConversationProvider extends AutoDisposeFutureProvider<List<Note>> {
  /// See also [_conversation].
  _ConversationProvider(
    String noteId,
  ) : this._internal(
          (ref) => _conversation(
            ref as _ConversationRef,
            noteId,
          ),
          from: _conversationProvider,
          name: r'_conversationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$conversationHash,
          dependencies: _ConversationFamily._dependencies,
          allTransitiveDependencies:
              _ConversationFamily._allTransitiveDependencies,
          noteId: noteId,
        );

  _ConversationProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.noteId,
  }) : super.internal();

  final String noteId;

  @override
  Override overrideWith(
    FutureOr<List<Note>> Function(_ConversationRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _ConversationProvider._internal(
        (ref) => create(ref as _ConversationRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        noteId: noteId,
      ),
    );
  }

  @override
  (String,) get argument {
    return (noteId,);
  }

  @override
  AutoDisposeFutureProviderElement<List<Note>> createElement() {
    return _ConversationProviderElement(this);
  }

  _ConversationProvider _copyWith(
    FutureOr<List<Note>> Function(_ConversationRef ref) create,
  ) {
    return _ConversationProvider._internal(
      (ref) => create(ref as _ConversationRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      noteId: noteId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _ConversationProvider && other.noteId == noteId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, noteId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin _ConversationRef on AutoDisposeFutureProviderRef<List<Note>> {
  /// The parameter `noteId` of this provider.
  String get noteId;
}

class _ConversationProviderElement
    extends AutoDisposeFutureProviderElement<List<Note>> with _ConversationRef {
  _ConversationProviderElement(super.provider);

  @override
  String get noteId => (origin as _ConversationProvider).noteId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
