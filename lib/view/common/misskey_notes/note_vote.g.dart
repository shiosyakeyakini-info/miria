// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_vote.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(NoteVoteNotifier)
const noteVoteNotifierProvider = NoteVoteNotifierFamily._();

final class NoteVoteNotifierProvider
    extends $NotifierProvider<NoteVoteNotifier, AsyncValue?> {
  const NoteVoteNotifierProvider._({
    required NoteVoteNotifierFamily super.from,
    required Note super.argument,
  }) : super(
         retry: null,
         name: r'noteVoteNotifierProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = misskeyPostContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies2 = notesWithProvider;

  @override
  String debugGetCreateSourceHash() => _$noteVoteNotifierHash();

  @override
  String toString() {
    return r'noteVoteNotifierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  NoteVoteNotifier create() => NoteVoteNotifier();

  @$internal
  @override
  $NotifierProviderElement<NoteVoteNotifier, AsyncValue?> $createElement(
    $ProviderPointer pointer,
  ) => $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<AsyncValue?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is NoteVoteNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$noteVoteNotifierHash() => r'421dc72908e2fd868f90df56516d266c6a1de281';

final class NoteVoteNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          NoteVoteNotifier,
          AsyncValue?,
          AsyncValue?,
          AsyncValue?,
          Note
        > {
  const NoteVoteNotifierFamily._()
    : super(
        retry: null,
        name: r'noteVoteNotifierProvider',
        dependencies: const <ProviderOrFamily>[
          misskeyPostContextProvider,
          notesWithProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          NoteVoteNotifierProvider.$allTransitiveDependencies0,
          NoteVoteNotifierProvider.$allTransitiveDependencies1,
          NoteVoteNotifierProvider.$allTransitiveDependencies2,
        ],
        isAutoDispose: true,
      );

  NoteVoteNotifierProvider call(Note note) =>
      NoteVoteNotifierProvider._(argument: note, from: this);

  @override
  String toString() => r'noteVoteNotifierProvider';
}

abstract class _$NoteVoteNotifier extends $Notifier<AsyncValue?> {
  late final _$args = ref.$arg as Note;
  Note get note => _$args;

  AsyncValue? build(Note note);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue?>,
              AsyncValue?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
