// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_page_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fetchNote)
const fetchNoteProvider = FetchNoteFamily._();

final class FetchNoteProvider
    extends
        $FunctionalProvider<
          AsyncValue<misskey.Note>,
          misskey.Note,
          FutureOr<misskey.Note>
        >
    with $FutureModifier<misskey.Note>, $FutureProvider<misskey.Note> {
  const FetchNoteProvider._({
    required FetchNoteFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'fetchNoteProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = misskeyGetContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyGetContextProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies2 = notesWithProvider;

  @override
  String debugGetCreateSourceHash() => _$fetchNoteHash();

  @override
  String toString() {
    return r'fetchNoteProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<misskey.Note> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<misskey.Note> create(Ref ref) {
    final argument = this.argument as String;
    return fetchNote(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchNoteProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fetchNoteHash() => r'a791492c94a0fd09c655fe5a35b00405396d3b82';

final class FetchNoteFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<misskey.Note>, String> {
  const FetchNoteFamily._()
    : super(
        retry: null,
        name: r'fetchNoteProvider',
        dependencies: const <ProviderOrFamily>[
          misskeyGetContextProvider,
          notesWithProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          FetchNoteProvider.$allTransitiveDependencies0,
          FetchNoteProvider.$allTransitiveDependencies1,
          FetchNoteProvider.$allTransitiveDependencies2,
        ],
        isAutoDispose: true,
      );

  FetchNoteProvider call(String noteId) =>
      FetchNoteProvider._(argument: noteId, from: this);

  @override
  String toString() => r'fetchNoteProvider';
}
