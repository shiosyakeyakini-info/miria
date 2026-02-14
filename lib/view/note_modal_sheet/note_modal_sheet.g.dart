// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_modal_sheet.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NoteModalSheetNotifier)
final noteModalSheetProvider = NoteModalSheetNotifierFamily._();

final class NoteModalSheetNotifierProvider
    extends $NotifierProvider<NoteModalSheetNotifier, NoteModalSheetState> {
  NoteModalSheetNotifierProvider._({
    required NoteModalSheetNotifierFamily super.from,
    required Note super.argument,
  }) : super(
         retry: null,
         name: r'noteModalSheetProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = misskeyPostContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies2 = misskeyGetContextProvider;
  static final $allTransitiveDependencies3 = notesWithProvider;

  @override
  String debugGetCreateSourceHash() => _$noteModalSheetNotifierHash();

  @override
  String toString() {
    return r'noteModalSheetProvider'
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
    r'fd7ce41085cfdef3aaf1e67e8fbe6c4f1d1c6214';

final class NoteModalSheetNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          NoteModalSheetNotifier,
          NoteModalSheetState,
          NoteModalSheetState,
          NoteModalSheetState,
          Note
        > {
  NoteModalSheetNotifierFamily._()
    : super(
        retry: null,
        name: r'noteModalSheetProvider',
        dependencies: <ProviderOrFamily>[
          misskeyPostContextProvider,
          misskeyGetContextProvider,
          accountContextProvider,
          notesWithProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>{
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
  String toString() => r'noteModalSheetProvider';
}

abstract class _$NoteModalSheetNotifier extends $Notifier<NoteModalSheetState> {
  late final _$args = ref.$arg as Note;
  Note get note => _$args;

  NoteModalSheetState build(Note note);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<NoteModalSheetState, NoteModalSheetState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NoteModalSheetState, NoteModalSheetState>,
              NoteModalSheetState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
