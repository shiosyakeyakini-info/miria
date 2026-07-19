// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_create_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NoteCreateNotifier)
final noteCreateProvider = NoteCreateNotifierProvider._();

final class NoteCreateNotifierProvider
    extends $NotifierProvider<NoteCreateNotifier, NoteCreate> {
  NoteCreateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'noteCreateProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[
          misskeyPostContextProvider,
          notesWithProvider,
          accountContextProvider,
          noteDraftRepositoryProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>{
          NoteCreateNotifierProvider.$allTransitiveDependencies0,
          NoteCreateNotifierProvider.$allTransitiveDependencies1,
          NoteCreateNotifierProvider.$allTransitiveDependencies2,
          NoteCreateNotifierProvider.$allTransitiveDependencies3,
        },
      );

  static final $allTransitiveDependencies0 = misskeyPostContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies2 = notesWithProvider;
  static final $allTransitiveDependencies3 = noteDraftRepositoryProvider;

  @override
  String debugGetCreateSourceHash() => _$noteCreateNotifierHash();

  @$internal
  @override
  NoteCreateNotifier create() => NoteCreateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NoteCreate value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NoteCreate>(value),
    );
  }
}

String _$noteCreateNotifierHash() =>
    r'8f02313d01678db05b62133639831006e442b38a';

abstract class _$NoteCreateNotifier extends $Notifier<NoteCreate> {
  NoteCreate build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<NoteCreate, NoteCreate>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NoteCreate, NoteCreate>,
              NoteCreate,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
