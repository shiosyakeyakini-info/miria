// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clip_modal_sheet.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notesClipsNotifierHash() =>
    r'7962974959d64b1ca68c7365025f910dc39e75e8';

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

abstract class _$NotesClipsNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<Clip>> {
  late final String noteId;

  FutureOr<List<Clip>> build(
    String noteId,
  );
}

/// See also [_NotesClipsNotifier].
@ProviderFor(_NotesClipsNotifier)
const _notesClipsNotifierProvider = _NotesClipsNotifierFamily();

/// See also [_NotesClipsNotifier].
class _NotesClipsNotifierFamily extends Family {
  /// See also [_NotesClipsNotifier].
  const _NotesClipsNotifierFamily();

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    misskeyPostContextProvider
  ];

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    misskeyPostContextProvider,
    ...?misskeyPostContextProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'_notesClipsNotifierProvider';

  /// See also [_NotesClipsNotifier].
  _NotesClipsNotifierProvider call(
    String noteId,
  ) {
    return _NotesClipsNotifierProvider(
      noteId,
    );
  }

  @visibleForOverriding
  @override
  _NotesClipsNotifierProvider getProviderOverride(
    covariant _NotesClipsNotifierProvider provider,
  ) {
    return call(
      provider.noteId,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(_NotesClipsNotifier Function() create) {
    return _$NotesClipsNotifierFamilyOverride(this, create);
  }
}

class _$NotesClipsNotifierFamilyOverride implements FamilyOverride {
  _$NotesClipsNotifierFamilyOverride(this.overriddenFamily, this.create);

  final _NotesClipsNotifier Function() create;

  @override
  final _NotesClipsNotifierFamily overriddenFamily;

  @override
  _NotesClipsNotifierProvider getProviderOverride(
    covariant _NotesClipsNotifierProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [_NotesClipsNotifier].
class _NotesClipsNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    _NotesClipsNotifier, List<Clip>> {
  /// See also [_NotesClipsNotifier].
  _NotesClipsNotifierProvider(
    String noteId,
  ) : this._internal(
          () => _NotesClipsNotifier()..noteId = noteId,
          from: _notesClipsNotifierProvider,
          name: r'_notesClipsNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$notesClipsNotifierHash,
          dependencies: _NotesClipsNotifierFamily._dependencies,
          allTransitiveDependencies:
              _NotesClipsNotifierFamily._allTransitiveDependencies,
          noteId: noteId,
        );

  _NotesClipsNotifierProvider._internal(
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
  FutureOr<List<Clip>> runNotifierBuild(
    covariant _NotesClipsNotifier notifier,
  ) {
    return notifier.build(
      noteId,
    );
  }

  @override
  Override overrideWith(_NotesClipsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: _NotesClipsNotifierProvider._internal(
        () => create()..noteId = noteId,
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
  AutoDisposeAsyncNotifierProviderElement<_NotesClipsNotifier, List<Clip>>
      createElement() {
    return _NotesClipsNotifierProviderElement(this);
  }

  _NotesClipsNotifierProvider _copyWith(
    _NotesClipsNotifier Function() create,
  ) {
    return _NotesClipsNotifierProvider._internal(
      () => create()..noteId = noteId,
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
    return other is _NotesClipsNotifierProvider && other.noteId == noteId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, noteId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin _NotesClipsNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<Clip>> {
  /// The parameter `noteId` of this provider.
  String get noteId;
}

class _NotesClipsNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<_NotesClipsNotifier,
        List<Clip>> with _NotesClipsNotifierRef {
  _NotesClipsNotifierProviderElement(super.provider);

  @override
  String get noteId => (origin as _NotesClipsNotifierProvider).noteId;
}

String _$clipModalSheetNotifierHash() =>
    r'978ab378797102eac12dd3714bf742a671d769ad';

abstract class _$ClipModalSheetNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<(Clip, bool)>> {
  late final String noteId;

  FutureOr<List<(Clip, bool)>> build(
    String noteId,
  );
}

/// See also [_ClipModalSheetNotifier].
@ProviderFor(_ClipModalSheetNotifier)
const _clipModalSheetNotifierProvider = _ClipModalSheetNotifierFamily();

/// See also [_ClipModalSheetNotifier].
class _ClipModalSheetNotifierFamily extends Family {
  /// See also [_ClipModalSheetNotifier].
  const _ClipModalSheetNotifierFamily();

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    clipsNotifierProvider,
    _notesClipsNotifierProvider,
    misskeyPostContextProvider
  ];

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    clipsNotifierProvider,
    ...?clipsNotifierProvider.allTransitiveDependencies,
    _notesClipsNotifierProvider,
    ...?_notesClipsNotifierProvider.allTransitiveDependencies,
    misskeyPostContextProvider,
    ...?misskeyPostContextProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'_clipModalSheetNotifierProvider';

  /// See also [_ClipModalSheetNotifier].
  _ClipModalSheetNotifierProvider call(
    String noteId,
  ) {
    return _ClipModalSheetNotifierProvider(
      noteId,
    );
  }

  @visibleForOverriding
  @override
  _ClipModalSheetNotifierProvider getProviderOverride(
    covariant _ClipModalSheetNotifierProvider provider,
  ) {
    return call(
      provider.noteId,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(_ClipModalSheetNotifier Function() create) {
    return _$ClipModalSheetNotifierFamilyOverride(this, create);
  }
}

class _$ClipModalSheetNotifierFamilyOverride implements FamilyOverride {
  _$ClipModalSheetNotifierFamilyOverride(this.overriddenFamily, this.create);

  final _ClipModalSheetNotifier Function() create;

  @override
  final _ClipModalSheetNotifierFamily overriddenFamily;

  @override
  _ClipModalSheetNotifierProvider getProviderOverride(
    covariant _ClipModalSheetNotifierProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [_ClipModalSheetNotifier].
class _ClipModalSheetNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<_ClipModalSheetNotifier,
        List<(Clip, bool)>> {
  /// See also [_ClipModalSheetNotifier].
  _ClipModalSheetNotifierProvider(
    String noteId,
  ) : this._internal(
          () => _ClipModalSheetNotifier()..noteId = noteId,
          from: _clipModalSheetNotifierProvider,
          name: r'_clipModalSheetNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$clipModalSheetNotifierHash,
          dependencies: _ClipModalSheetNotifierFamily._dependencies,
          allTransitiveDependencies:
              _ClipModalSheetNotifierFamily._allTransitiveDependencies,
          noteId: noteId,
        );

  _ClipModalSheetNotifierProvider._internal(
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
  FutureOr<List<(Clip, bool)>> runNotifierBuild(
    covariant _ClipModalSheetNotifier notifier,
  ) {
    return notifier.build(
      noteId,
    );
  }

  @override
  Override overrideWith(_ClipModalSheetNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: _ClipModalSheetNotifierProvider._internal(
        () => create()..noteId = noteId,
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
  AutoDisposeAsyncNotifierProviderElement<_ClipModalSheetNotifier,
      List<(Clip, bool)>> createElement() {
    return _ClipModalSheetNotifierProviderElement(this);
  }

  _ClipModalSheetNotifierProvider _copyWith(
    _ClipModalSheetNotifier Function() create,
  ) {
    return _ClipModalSheetNotifierProvider._internal(
      () => create()..noteId = noteId,
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
    return other is _ClipModalSheetNotifierProvider && other.noteId == noteId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, noteId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin _ClipModalSheetNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<(Clip, bool)>> {
  /// The parameter `noteId` of this provider.
  String get noteId;
}

class _ClipModalSheetNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<_ClipModalSheetNotifier,
        List<(Clip, bool)>> with _ClipModalSheetNotifierRef {
  _ClipModalSheetNotifierProviderElement(super.provider);

  @override
  String get noteId => (origin as _ClipModalSheetNotifierProvider).noteId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
