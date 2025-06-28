// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_modal_sheet.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(NoteModalSheetNotifier)
const noteModalSheetNotifierProvider = NoteModalSheetNotifierFamily._();

final class NoteModalSheetNotifierProvider
    extends $NotifierProvider<NoteModalSheetNotifier, NoteModalSheetState> {
  const NoteModalSheetNotifierProvider._({
    required NoteModalSheetNotifierFamily super.from,
    required Note super.argument,
  }) : super(
         retry: null,
         name: r'noteModalSheetNotifierProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = misskeyPostContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies2 = misskeyGetContextProvider;
  static const $allTransitiveDependencies3 = notesWithProvider;

  @override
  String debugGetCreateSourceHash() => _$noteModalSheetNotifierHash();

  @override
  String toString() {
    return r'noteModalSheetNotifierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  NoteModalSheetNotifier create() => NoteModalSheetNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NoteModalSheetState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NoteModalSheetState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is NoteModalSheetNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$noteModalSheetNotifierHash() =>
    r'500faf8f42ddccca0502c701cbd2791aa39f3cdf';

final class NoteModalSheetNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          NoteModalSheetNotifier,
          NoteModalSheetState,
          NoteModalSheetState,
          NoteModalSheetState,
          Note
        > {
  const NoteModalSheetNotifierFamily._()
    : super(
        retry: null,
        name: r'noteModalSheetNotifierProvider',
        dependencies: const <ProviderOrFamily>[
          misskeyPostContextProvider,
          misskeyGetContextProvider,
          accountContextProvider,
          notesWithProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>{
          NoteModalSheetNotifierProvider.$allTransitiveDependencies0,
          NoteModalSheetNotifierProvider.$allTransitiveDependencies1,
          NoteModalSheetNotifierProvider.$allTransitiveDependencies2,
          NoteModalSheetNotifierProvider.$allTransitiveDependencies3,
        },
        isAutoDispose: true,
      );

  NoteModalSheetNotifierProvider call(Note note) =>
      NoteModalSheetNotifierProvider._(argument: note, from: this);

  @override
  String toString() => r'noteModalSheetNotifierProvider';
}

abstract class _$NoteModalSheetNotifier extends $Notifier<NoteModalSheetState> {
  late final _$args = ref.$arg as Note;
  Note get note => _$args;

  NoteModalSheetState build(Note note);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<NoteModalSheetState, NoteModalSheetState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NoteModalSheetState, NoteModalSheetState>,
              NoteModalSheetState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
