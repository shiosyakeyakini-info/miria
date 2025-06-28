// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_page_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(fetchNote)
const fetchNoteProvider = FetchNoteFamily._();

final class FetchNoteProvider
    extends $FunctionalProvider<AsyncValue<Note>, Note, FutureOr<Note>>
    with $FutureModifier<Note>, $FutureProvider<Note> {
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
  $FutureProviderElement<Note> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Note> create(Ref ref) {
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
    with $FunctionalFamilyOverride<FutureOr<Note>, String> {
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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
