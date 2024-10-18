// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_vote.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$noteVoteNotifierHash() => r'421dc72908e2fd868f90df56516d266c6a1de281';

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

abstract class _$NoteVoteNotifier
    extends BuildlessAutoDisposeNotifier<AsyncValue?> {
  late final Note note;

  AsyncValue? build(
    Note note,
  );
}

/// See also [NoteVoteNotifier].
@ProviderFor(NoteVoteNotifier)
const noteVoteNotifierProvider = NoteVoteNotifierFamily();

/// See also [NoteVoteNotifier].
class NoteVoteNotifierFamily extends Family {
  /// See also [NoteVoteNotifier].
  const NoteVoteNotifierFamily();

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
  String? get name => r'noteVoteNotifierProvider';

  /// See also [NoteVoteNotifier].
  NoteVoteNotifierProvider call(
    Note note,
  ) {
    return NoteVoteNotifierProvider(
      note,
    );
  }

  @visibleForOverriding
  @override
  NoteVoteNotifierProvider getProviderOverride(
    covariant NoteVoteNotifierProvider provider,
  ) {
    return call(
      provider.note,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(NoteVoteNotifier Function() create) {
    return _$NoteVoteNotifierFamilyOverride(this, create);
  }
}

class _$NoteVoteNotifierFamilyOverride implements FamilyOverride {
  _$NoteVoteNotifierFamilyOverride(this.overriddenFamily, this.create);

  final NoteVoteNotifier Function() create;

  @override
  final NoteVoteNotifierFamily overriddenFamily;

  @override
  NoteVoteNotifierProvider getProviderOverride(
    covariant NoteVoteNotifierProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [NoteVoteNotifier].
class NoteVoteNotifierProvider
    extends AutoDisposeNotifierProviderImpl<NoteVoteNotifier, AsyncValue?> {
  /// See also [NoteVoteNotifier].
  NoteVoteNotifierProvider(
    Note note,
  ) : this._internal(
          () => NoteVoteNotifier()..note = note,
          from: noteVoteNotifierProvider,
          name: r'noteVoteNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$noteVoteNotifierHash,
          dependencies: NoteVoteNotifierFamily._dependencies,
          allTransitiveDependencies:
              NoteVoteNotifierFamily._allTransitiveDependencies,
          note: note,
        );

  NoteVoteNotifierProvider._internal(
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
  AsyncValue? runNotifierBuild(
    covariant NoteVoteNotifier notifier,
  ) {
    return notifier.build(
      note,
    );
  }

  @override
  Override overrideWith(NoteVoteNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: NoteVoteNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<NoteVoteNotifier, AsyncValue?>
      createElement() {
    return _NoteVoteNotifierProviderElement(this);
  }

  NoteVoteNotifierProvider _copyWith(
    NoteVoteNotifier Function() create,
  ) {
    return NoteVoteNotifierProvider._internal(
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
    return other is NoteVoteNotifierProvider && other.note == note;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, note.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NoteVoteNotifierRef on AutoDisposeNotifierProviderRef<AsyncValue?> {
  /// The parameter `note` of this provider.
  Note get note;
}

class _NoteVoteNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<NoteVoteNotifier, AsyncValue?>
    with NoteVoteNotifierRef {
  _NoteVoteNotifierProviderElement(super.provider);

  @override
  Note get note => (origin as NoteVoteNotifierProvider).note;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
