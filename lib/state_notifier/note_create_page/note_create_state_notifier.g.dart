// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_create_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(NoteCreateNotifier)
const noteCreateNotifierProvider = NoteCreateNotifierProvider._();

final class NoteCreateNotifierProvider
    extends $NotifierProvider<NoteCreateNotifier, NoteCreate> {
  const NoteCreateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'noteCreateNotifierProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[
          misskeyPostContextProvider,
          notesWithProvider,
          accountContextProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          NoteCreateNotifierProvider.$allTransitiveDependencies0,
          NoteCreateNotifierProvider.$allTransitiveDependencies1,
          NoteCreateNotifierProvider.$allTransitiveDependencies2,
        ],
      );

  static const $allTransitiveDependencies0 = misskeyPostContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies2 = notesWithProvider;

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
    r'1b5bd9da659afc5215fbc8407441df396fa87122';

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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
