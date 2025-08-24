// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clip_modal_sheet.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(_NotesClipsNotifier)
const _notesClipsNotifierProvider = _NotesClipsNotifierFamily._();

final class _NotesClipsNotifierProvider
    extends $AsyncNotifierProvider<_NotesClipsNotifier, List<Clip>> {
  const _NotesClipsNotifierProvider._({
    required _NotesClipsNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'_notesClipsNotifierProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = misskeyPostContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$_notesClipsNotifierHash();

  @override
  String toString() {
    return r'_notesClipsNotifierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  _NotesClipsNotifier create() => _NotesClipsNotifier();

  @override
  bool operator ==(Object other) {
    return other is _NotesClipsNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_notesClipsNotifierHash() =>
    r'ac73f5e5d6dcc731e9c023a03e84eb10fd14de9c';

final class _NotesClipsNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          _NotesClipsNotifier,
          AsyncValue<List<Clip>>,
          List<Clip>,
          FutureOr<List<Clip>>,
          String
        > {
  const _NotesClipsNotifierFamily._()
    : super(
        retry: null,
        name: r'_notesClipsNotifierProvider',
        dependencies: const <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          _NotesClipsNotifierProvider.$allTransitiveDependencies0,
          _NotesClipsNotifierProvider.$allTransitiveDependencies1,
        ],
        isAutoDispose: true,
      );

  _NotesClipsNotifierProvider call(String noteId) =>
      _NotesClipsNotifierProvider._(argument: noteId, from: this);

  @override
  String toString() => r'_notesClipsNotifierProvider';
}

abstract class _$NotesClipsNotifier extends $AsyncNotifier<List<Clip>> {
  late final _$args = ref.$arg as String;
  String get noteId => _$args;

  FutureOr<List<Clip>> build(String noteId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<List<Clip>>, List<Clip>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Clip>>, List<Clip>>,
              AsyncValue<List<Clip>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(_ClipModalSheetNotifier)
const _clipModalSheetNotifierProvider = _ClipModalSheetNotifierFamily._();

final class _ClipModalSheetNotifierProvider
    extends
        $AsyncNotifierProvider<_ClipModalSheetNotifier, List<(Clip, bool)>> {
  const _ClipModalSheetNotifierProvider._({
    required _ClipModalSheetNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'_clipModalSheetNotifierProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = clipsNotifierProvider;
  static const $allTransitiveDependencies1 =
      ClipsNotifierProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies2 =
      ClipsNotifierProvider.$allTransitiveDependencies1;
  static const $allTransitiveDependencies3 = _notesClipsNotifierProvider;

  @override
  String debugGetCreateSourceHash() => _$_clipModalSheetNotifierHash();

  @override
  String toString() {
    return r'_clipModalSheetNotifierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  _ClipModalSheetNotifier create() => _ClipModalSheetNotifier();

  @override
  bool operator ==(Object other) {
    return other is _ClipModalSheetNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_clipModalSheetNotifierHash() =>
    r'0751058a13d6c6ff7714eeef4110d399970c5b46';

final class _ClipModalSheetNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          _ClipModalSheetNotifier,
          AsyncValue<List<(Clip, bool)>>,
          List<(Clip, bool)>,
          FutureOr<List<(Clip, bool)>>,
          String
        > {
  const _ClipModalSheetNotifierFamily._()
    : super(
        retry: null,
        name: r'_clipModalSheetNotifierProvider',
        dependencies: const <ProviderOrFamily>[
          clipsNotifierProvider,
          _notesClipsNotifierProvider,
          misskeyPostContextProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>{
          _ClipModalSheetNotifierProvider.$allTransitiveDependencies0,
          _ClipModalSheetNotifierProvider.$allTransitiveDependencies1,
          _ClipModalSheetNotifierProvider.$allTransitiveDependencies2,
          _ClipModalSheetNotifierProvider.$allTransitiveDependencies3,
        },
        isAutoDispose: true,
      );

  _ClipModalSheetNotifierProvider call(String noteId) =>
      _ClipModalSheetNotifierProvider._(argument: noteId, from: this);

  @override
  String toString() => r'_clipModalSheetNotifierProvider';
}

abstract class _$ClipModalSheetNotifier
    extends $AsyncNotifier<List<(Clip, bool)>> {
  late final _$args = ref.$arg as String;
  String get noteId => _$args;

  FutureOr<List<(Clip, bool)>> build(String noteId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<List<(Clip, bool)>>, List<(Clip, bool)>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<(Clip, bool)>>, List<(Clip, bool)>>,
              AsyncValue<List<(Clip, bool)>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
