// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translate_note_modal_sheet.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(_notesTranslate)
const _notesTranslateProvider = _NotesTranslateFamily._();

final class _NotesTranslateProvider
    extends
        $FunctionalProvider<
          AsyncValue<NotesTranslateResponse>,
          NotesTranslateResponse,
          FutureOr<NotesTranslateResponse>
        >
    with
        $FutureModifier<NotesTranslateResponse>,
        $FutureProvider<NotesTranslateResponse> {
  const _NotesTranslateProvider._({
    required _NotesTranslateFamily super.from,
    required ({String noteId, String targetLang}) super.argument,
  }) : super(
         retry: null,
         name: r'_notesTranslateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = misskeyPostContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$_notesTranslateHash();

  @override
  String toString() {
    return r'_notesTranslateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<NotesTranslateResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<NotesTranslateResponse> create(Ref ref) {
    final argument = this.argument as ({String noteId, String targetLang});
    return _notesTranslate(
      ref,
      noteId: argument.noteId,
      targetLang: argument.targetLang,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _NotesTranslateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_notesTranslateHash() => r'f5568573f08f41ed91c32be6b6b529a9e7fbc37c';

final class _NotesTranslateFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<NotesTranslateResponse>,
          ({String noteId, String targetLang})
        > {
  const _NotesTranslateFamily._()
    : super(
        retry: null,
        name: r'_notesTranslateProvider',
        dependencies: const <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          _NotesTranslateProvider.$allTransitiveDependencies0,
          _NotesTranslateProvider.$allTransitiveDependencies1,
        ],
        isAutoDispose: true,
      );

  _NotesTranslateProvider call({
    required String noteId,
    required String targetLang,
  }) => _NotesTranslateProvider._(
    argument: (noteId: noteId, targetLang: targetLang),
    from: this,
  );

  @override
  String toString() => r'_notesTranslateProvider';
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
