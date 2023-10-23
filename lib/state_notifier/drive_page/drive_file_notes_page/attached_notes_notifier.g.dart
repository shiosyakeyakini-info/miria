// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attached_notes_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(AttachedNotesNotifier)
const attachedNotesNotifierProvider = AttachedNotesNotifierFamily._();

final class AttachedNotesNotifierProvider
    extends
        $AsyncNotifierProvider<AttachedNotesNotifier, PaginationState<Note>> {
  const AttachedNotesNotifierProvider._({
    required AttachedNotesNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'attachedNotesNotifierProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = misskeyPostContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies2 = notesWithProvider;

  @override
  String debugGetCreateSourceHash() => _$attachedNotesNotifierHash();

  @override
  String toString() {
    return r'attachedNotesNotifierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AttachedNotesNotifier create() => AttachedNotesNotifier();

  @override
  bool operator ==(Object other) {
    return other is AttachedNotesNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$attachedNotesNotifierHash() =>
    r'9556f30a2989f644c70b89afefbae2d22e87305a';

final class AttachedNotesNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          AttachedNotesNotifier,
          AsyncValue<PaginationState<Note>>,
          PaginationState<Note>,
          FutureOr<PaginationState<Note>>,
          String
        > {
  const AttachedNotesNotifierFamily._()
    : super(
        retry: null,
        name: r'attachedNotesNotifierProvider',
        dependencies: const <ProviderOrFamily>[
          misskeyPostContextProvider,
          notesWithProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          AttachedNotesNotifierProvider.$allTransitiveDependencies0,
          AttachedNotesNotifierProvider.$allTransitiveDependencies1,
          AttachedNotesNotifierProvider.$allTransitiveDependencies2,
        ],
        isAutoDispose: true,
      );

  AttachedNotesNotifierProvider call(String fileId) =>
      AttachedNotesNotifierProvider._(argument: fileId, from: this);

  @override
  String toString() => r'attachedNotesNotifierProvider';
}

abstract class _$AttachedNotesNotifier
    extends $AsyncNotifier<PaginationState<Note>> {
  late final _$args = ref.$arg as String;
  String get fileId => _$args;

  FutureOr<PaginationState<Note>> build(String fileId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref
            as $Ref<AsyncValue<PaginationState<Note>>, PaginationState<Note>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaginationState<Note>>,
                PaginationState<Note>
              >,
              AsyncValue<PaginationState<Note>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
