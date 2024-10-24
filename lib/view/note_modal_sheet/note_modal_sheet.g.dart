// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_modal_sheet.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$noteModalSheetNotifierHash() =>
    r'6e16e66d1e8ce6671ac6ba8bd9bb208c9b7b6652';

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

abstract class _$NoteModalSheetNotifier
    extends BuildlessAutoDisposeNotifier<NoteModalSheetState> {
  late final Note note;

  NoteModalSheetState build(
    Note note,
  );
}

/// See also [NoteModalSheetNotifier].
@ProviderFor(NoteModalSheetNotifier)
const noteModalSheetNotifierProvider = NoteModalSheetNotifierFamily();

/// See also [NoteModalSheetNotifier].
class NoteModalSheetNotifierFamily extends Family {
  /// See also [NoteModalSheetNotifier].
  const NoteModalSheetNotifierFamily();

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>{
    misskeyPostContextProvider,
    misskeyGetContextProvider,
    accountContextProvider,
    notesWithProvider
  };

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    misskeyPostContextProvider,
    ...?misskeyPostContextProvider.allTransitiveDependencies,
    misskeyGetContextProvider,
    ...?misskeyGetContextProvider.allTransitiveDependencies,
    accountContextProvider,
    ...?accountContextProvider.allTransitiveDependencies,
    notesWithProvider,
    ...?notesWithProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'noteModalSheetNotifierProvider';

  /// See also [NoteModalSheetNotifier].
  NoteModalSheetNotifierProvider call(
    Note note,
  ) {
    return NoteModalSheetNotifierProvider(
      note,
    );
  }

  @visibleForOverriding
  @override
  NoteModalSheetNotifierProvider getProviderOverride(
    covariant NoteModalSheetNotifierProvider provider,
  ) {
    return call(
      provider.note,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(NoteModalSheetNotifier Function() create) {
    return _$NoteModalSheetNotifierFamilyOverride(this, create);
  }
}

class _$NoteModalSheetNotifierFamilyOverride implements FamilyOverride {
  _$NoteModalSheetNotifierFamilyOverride(this.overriddenFamily, this.create);

  final NoteModalSheetNotifier Function() create;

  @override
  final NoteModalSheetNotifierFamily overriddenFamily;

  @override
  NoteModalSheetNotifierProvider getProviderOverride(
    covariant NoteModalSheetNotifierProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [NoteModalSheetNotifier].
class NoteModalSheetNotifierProvider extends AutoDisposeNotifierProviderImpl<
    NoteModalSheetNotifier, NoteModalSheetState> {
  /// See also [NoteModalSheetNotifier].
  NoteModalSheetNotifierProvider(
    Note note,
  ) : this._internal(
          () => NoteModalSheetNotifier()..note = note,
          from: noteModalSheetNotifierProvider,
          name: r'noteModalSheetNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$noteModalSheetNotifierHash,
          dependencies: NoteModalSheetNotifierFamily._dependencies,
          allTransitiveDependencies:
              NoteModalSheetNotifierFamily._allTransitiveDependencies,
          note: note,
        );

  NoteModalSheetNotifierProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.note,
  }) : super.internal();

  final Note note;

  @override
  NoteModalSheetState runNotifierBuild(
    covariant NoteModalSheetNotifier notifier,
  ) {
    return notifier.build(
      note,
    );
  }

  @override
  Override overrideWith(NoteModalSheetNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: NoteModalSheetNotifierProvider._internal(
        () => create()..note = note,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        note: note,
      ),
    );
  }

  @override
  (Note,) get argument {
    return (note,);
  }

  @override
  AutoDisposeNotifierProviderElement<NoteModalSheetNotifier,
      NoteModalSheetState> createElement() {
    return _NoteModalSheetNotifierProviderElement(this);
  }

  NoteModalSheetNotifierProvider _copyWith(
    NoteModalSheetNotifier Function() create,
  ) {
    return NoteModalSheetNotifierProvider._internal(
      () => create()..note = note,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      note: note,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is NoteModalSheetNotifierProvider && other.note == note;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, note.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NoteModalSheetNotifierRef
    on AutoDisposeNotifierProviderRef<NoteModalSheetState> {
  /// The parameter `note` of this provider.
  Note get note;
}

class _NoteModalSheetNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<NoteModalSheetNotifier,
        NoteModalSheetState> with NoteModalSheetNotifierRef {
  _NoteModalSheetNotifierProviderElement(super.provider);

  @override
  Note get note => (origin as NoteModalSheetNotifierProvider).note;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
