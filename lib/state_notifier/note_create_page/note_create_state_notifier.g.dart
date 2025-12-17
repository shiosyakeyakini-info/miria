// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_create_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NoteCreateNotifier)
const noteCreateProvider = NoteCreateNotifierProvider._();

final class NoteCreateNotifierProvider
    extends $NotifierProvider<NoteCreateNotifier, NoteCreate> {
  const NoteCreateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'noteCreateProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[
          misskeyPostContextProvider,
          notesWithProvider,
          accountContextProvider,
          noteDraftRepositoryProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>{
          NoteCreateNotifierProvider.$allTransitiveDependencies0,
          NoteCreateNotifierProvider.$allTransitiveDependencies1,
          NoteCreateNotifierProvider.$allTransitiveDependencies2,
          NoteCreateNotifierProvider.$allTransitiveDependencies3,
        },
      );

  static const $allTransitiveDependencies0 = misskeyPostContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies2 = notesWithProvider;
  static const $allTransitiveDependencies3 = noteDraftRepositoryProvider;

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
    r'e24f4a7ecbf9a886f0da157278be67988e326063';

abstract class _$NoteCreateNotifier extends $Notifier<NoteCreate> {
  NoteCreate build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<NoteCreate, NoteCreate>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NoteCreate, NoteCreate>,
              NoteCreate,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
