// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clip_modal_sheet.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_NotesClipsNotifier)
final _notesClipsProvider = _NotesClipsNotifierFamily._();

final class _NotesClipsNotifierProvider
    extends $AsyncNotifierProvider<_NotesClipsNotifier, List<Clip>> {
  _NotesClipsNotifierProvider._({
    required _NotesClipsNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'_notesClipsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = misskeyPostContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$_notesClipsNotifierHash();

  @override
  String toString() {
    return r'_notesClipsProvider'
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
  _NotesClipsNotifierFamily._()
    : super(
        retry: null,
        name: r'_notesClipsProvider',
        dependencies: <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          _NotesClipsNotifierProvider.$allTransitiveDependencies0,
          _NotesClipsNotifierProvider.$allTransitiveDependencies1,
        ],
        isAutoDispose: true,
      );

  _NotesClipsNotifierProvider call(String noteId) =>
      _NotesClipsNotifierProvider._(argument: noteId, from: this);

  @override
  String toString() => r'_notesClipsProvider';
}

abstract class _$NotesClipsNotifier extends $AsyncNotifier<List<Clip>> {
  late final _$args = ref.$arg as String;
  String get noteId => _$args;

  FutureOr<List<Clip>> build(String noteId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Clip>>, List<Clip>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Clip>>, List<Clip>>,
              AsyncValue<List<Clip>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(_ClipModalSheetNotifier)
final _clipModalSheetProvider = _ClipModalSheetNotifierFamily._();

final class _ClipModalSheetNotifierProvider
    extends
        $AsyncNotifierProvider<_ClipModalSheetNotifier, List<(Clip, bool)>> {
  _ClipModalSheetNotifierProvider._({
    required _ClipModalSheetNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'_clipModalSheetProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = clipsProvider;
  static final $allTransitiveDependencies1 =
      ClipsNotifierProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies2 =
      ClipsNotifierProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies3 = _notesClipsProvider;

  @override
  String debugGetCreateSourceHash() => _$_clipModalSheetNotifierHash();

  @override
  String toString() {
    return r'_clipModalSheetProvider'
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
    r'd9a875adeef23fe6792c27ca4b1bbe1dfc739f35';

final class _ClipModalSheetNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          _ClipModalSheetNotifier,
          AsyncValue<List<(Clip, bool)>>,
          List<(Clip, bool)>,
          FutureOr<List<(Clip, bool)>>,
          String
        > {
  _ClipModalSheetNotifierFamily._()
    : super(
        retry: null,
        name: r'_clipModalSheetProvider',
        dependencies: <ProviderOrFamily>[
          clipsProvider,
          _notesClipsProvider,
          misskeyPostContextProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>{
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
  String toString() => r'_clipModalSheetProvider';
}

abstract class _$ClipModalSheetNotifier
    extends $AsyncNotifier<List<(Clip, bool)>> {
  late final _$args = ref.$arg as String;
  String get noteId => _$args;

  FutureOr<List<(Clip, bool)>> build(String noteId);
  @$mustCallSuper
  @override
  void runBuild() {
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
    element.handleCreate(ref, () => build(_$args));
  }
}
