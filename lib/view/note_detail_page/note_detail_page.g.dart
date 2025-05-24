// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_detail_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(_notesShow)
const _notesShowProvider = _NotesShowFamily._();

final class _NotesShowProvider
    extends $FunctionalProvider<AsyncValue<Note>, FutureOr<Note>>
    with $FutureModifier<Note>, $FutureProvider<Note> {
  const _NotesShowProvider._({
    required _NotesShowFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'_notesShowProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = misskeyGetContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyGetContextProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies2 = notesWithProvider;

  @override
  String debugGetCreateSourceHash() => _$notesShowHash();

  @override
  String toString() {
    return r'_notesShowProvider'
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
    return _notesShow(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is _NotesShowProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$notesShowHash() => r'69e8ff0eaa98e6a6047750a22d7fdacc566a28af';

final class _NotesShowFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Note>, String> {
  const _NotesShowFamily._()
    : super(
        retry: null,
        name: r'_notesShowProvider',
        dependencies: const <ProviderOrFamily>[
          misskeyGetContextProvider,
          notesWithProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          _NotesShowProvider.$allTransitiveDependencies0,
          _NotesShowProvider.$allTransitiveDependencies1,
          _NotesShowProvider.$allTransitiveDependencies2,
        ],
        isAutoDispose: true,
      );

  _NotesShowProvider call(String noteId) =>
      _NotesShowProvider._(argument: noteId, from: this);

  @override
  String toString() => r'_notesShowProvider';
}

@ProviderFor(_conversation)
const _conversationProvider = _ConversationFamily._();

final class _ConversationProvider
    extends $FunctionalProvider<AsyncValue<List<Note>>, FutureOr<List<Note>>>
    with $FutureModifier<List<Note>>, $FutureProvider<List<Note>> {
  const _ConversationProvider._({
    required _ConversationFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'_conversationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = misskeyGetContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyGetContextProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies2 = notesWithProvider;

  @override
  String debugGetCreateSourceHash() => _$conversationHash();

  @override
  String toString() {
    return r'_conversationProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Note>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Note>> create(Ref ref) {
    final argument = this.argument as String;
    return _conversation(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is _ConversationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$conversationHash() => r'b69ce226a89b66118fb9eb993e16b802e9c6210d';

final class _ConversationFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Note>>, String> {
  const _ConversationFamily._()
    : super(
        retry: null,
        name: r'_conversationProvider',
        dependencies: const <ProviderOrFamily>[
          misskeyGetContextProvider,
          notesWithProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          _ConversationProvider.$allTransitiveDependencies0,
          _ConversationProvider.$allTransitiveDependencies1,
          _ConversationProvider.$allTransitiveDependencies2,
        ],
        isAutoDispose: true,
      );

  _ConversationProvider call(String noteId) =>
      _ConversationProvider._(argument: noteId, from: this);

  @override
  String toString() => r'_conversationProvider';
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
