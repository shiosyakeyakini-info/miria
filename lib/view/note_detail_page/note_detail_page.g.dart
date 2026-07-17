// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_detail_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_notesShow)
final _notesShowProvider = _NotesShowFamily._();

final class _NotesShowProvider
    extends $FunctionalProvider<AsyncValue<Note>, Note, FutureOr<Note>>
    with $FutureModifier<Note>, $FutureProvider<Note> {
  _NotesShowProvider._({
    required _NotesShowFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'_notesShowProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = misskeyGetContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyGetContextProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies2 = notesWithProvider;

  @override
  String debugGetCreateSourceHash() => _$_notesShowHash();

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

String _$_notesShowHash() => r'69e8ff0eaa98e6a6047750a22d7fdacc566a28af';

final class _NotesShowFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Note>, String> {
  _NotesShowFamily._()
    : super(
        retry: null,
        name: r'_notesShowProvider',
        dependencies: <ProviderOrFamily>[
          misskeyGetContextProvider,
          notesWithProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>[
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
final _conversationProvider = _ConversationFamily._();

final class _ConversationProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Note>>,
          List<Note>,
          FutureOr<List<Note>>
        >
    with $FutureModifier<List<Note>>, $FutureProvider<List<Note>> {
  _ConversationProvider._({
    required _ConversationFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'_conversationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = misskeyGetContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyGetContextProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies2 = notesWithProvider;

  @override
  String debugGetCreateSourceHash() => _$_conversationHash();

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

String _$_conversationHash() => r'b69ce226a89b66118fb9eb993e16b802e9c6210d';

final class _ConversationFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Note>>, String> {
  _ConversationFamily._()
    : super(
        retry: null,
        name: r'_conversationProvider',
        dependencies: <ProviderOrFamily>[
          misskeyGetContextProvider,
          notesWithProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>[
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
