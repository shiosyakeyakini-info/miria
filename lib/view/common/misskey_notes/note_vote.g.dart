// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_vote.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NoteVoteNotifier)
final noteVoteProvider = NoteVoteNotifierFamily._();

final class NoteVoteNotifierProvider
    extends $NotifierProvider<NoteVoteNotifier, AsyncValue<dynamic>?> {
  NoteVoteNotifierProvider._({
    required NoteVoteNotifierFamily super.from,
    required Note super.argument,
  }) : super(
         retry: null,
         name: r'noteVoteProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = misskeyPostContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies2 = notesWithProvider;

  @override
  String debugGetCreateSourceHash() => _$noteVoteNotifierHash();

  @override
  String toString() {
    return r'noteVoteProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  NoteVoteNotifier create() => NoteVoteNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<dynamic>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<dynamic>?>(value),
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

String _$noteVoteNotifierHash() => r'73c0131ce935ff5e7f444be691e90233184685d1';

final class NoteVoteNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          NoteVoteNotifier,
          AsyncValue<dynamic>?,
          AsyncValue<dynamic>?,
          AsyncValue<dynamic>?,
          Note
        > {
  NoteVoteNotifierFamily._()
    : super(
        retry: null,
        name: r'noteVoteProvider',
        dependencies: <ProviderOrFamily>[
          misskeyPostContextProvider,
          notesWithProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>[
          NoteVoteNotifierProvider.$allTransitiveDependencies0,
          NoteVoteNotifierProvider.$allTransitiveDependencies1,
          NoteVoteNotifierProvider.$allTransitiveDependencies2,
        ],
        isAutoDispose: true,
      );

  NoteVoteNotifierProvider call(Note note) =>
      NoteVoteNotifierProvider._(argument: note, from: this);

  @override
  String toString() => r'noteVoteProvider';
}

abstract class _$NoteVoteNotifier extends $Notifier<AsyncValue<dynamic>?> {
  late final _$args = ref.$arg as Note;
  Note get note => _$args;

  AsyncValue<dynamic>? build(Note note);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<dynamic>?, AsyncValue<dynamic>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<dynamic>?, AsyncValue<dynamic>?>,
              AsyncValue<dynamic>?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
