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
  String debugGetCreateSourceHash() => _$notesClipsNotifierHash();

  @override
  String toString() {
    return r'_notesClipsNotifierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  _NotesClipsNotifier create() => _NotesClipsNotifier();

  @$internal
  @override
  $AsyncNotifierProviderElement<_NotesClipsNotifier, List<Clip>> $createElement(
    $ProviderPointer pointer,
  ) => $AsyncNotifierProviderElement(pointer);

  @override
  bool operator ==(Object other) {
    return other is _NotesClipsNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$notesClipsNotifierHash() =>
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
    final ref = this.ref as $Ref<AsyncValue<List<Clip>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Clip>>>,
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
  String debugGetCreateSourceHash() => _$clipModalSheetNotifierHash();

  @override
  String toString() {
    return r'_clipModalSheetNotifierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  _ClipModalSheetNotifier create() => _ClipModalSheetNotifier();

  @$internal
  @override
  _$ClipModalSheetNotifierElement $createElement($ProviderPointer pointer) =>
      _$ClipModalSheetNotifierElement(pointer);

  ProviderListenable<_ClipModalSheetNotifier$AddToClip> get addToClip =>
      $LazyProxyListenable<
        _ClipModalSheetNotifier$AddToClip,
        AsyncValue<List<(Clip, bool)>>
      >(this, (element) {
        element as _$ClipModalSheetNotifierElement;

        return element._$addToClip;
      });

  ProviderListenable<_ClipModalSheetNotifier$RemoveFromClip>
  get removeFromClip => $LazyProxyListenable<
    _ClipModalSheetNotifier$RemoveFromClip,
    AsyncValue<List<(Clip, bool)>>
  >(this, (element) {
    element as _$ClipModalSheetNotifierElement;

    return element._$removeFromClip;
  });

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

String _$clipModalSheetNotifierHash() =>
    r'ed0bec6b648cba697c8373a5f73b1ee2a66fae3f';

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
    final ref = this.ref as $Ref<AsyncValue<List<(Clip, bool)>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<(Clip, bool)>>>,
              AsyncValue<List<(Clip, bool)>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

class _$ClipModalSheetNotifierElement
    extends
        $AsyncNotifierProviderElement<
          _ClipModalSheetNotifier,
          List<(Clip, bool)>
        > {
  _$ClipModalSheetNotifierElement(super.pointer) {
    _$addToClip.result = $Result.data(
      _$_ClipModalSheetNotifier$AddToClip(this),
    );
    _$removeFromClip.result = $Result.data(
      _$_ClipModalSheetNotifier$RemoveFromClip(this),
    );
  }
  final _$addToClip = $ElementLense<_$_ClipModalSheetNotifier$AddToClip>();
  final _$removeFromClip =
      $ElementLense<_$_ClipModalSheetNotifier$RemoveFromClip>();
  @override
  void mount() {
    super.mount();
    _$addToClip.result!.value!.reset();
    _$removeFromClip.result!.value!.reset();
  }

  @override
  void visitListenables(
    void Function($ElementLense element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);

    listenableVisitor(_$addToClip);
    listenableVisitor(_$removeFromClip);
  }
}

sealed class _ClipModalSheetNotifier$AddToClip extends MutationBase<void> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutation], then
  /// will call [_ClipModalSheetNotifier.addToClip] with the provided parameters.
  ///
  /// After the method completes, the mutation state will be updated to either
  /// [SuccessMutation] or [ErrorMutation] based on if the method
  /// threw or not.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  Future<void> call(Clip clip);
}

final class _$_ClipModalSheetNotifier$AddToClip
    extends
        $AsyncMutationBase<
          void,
          _$_ClipModalSheetNotifier$AddToClip,
          _ClipModalSheetNotifier
        >
    implements _ClipModalSheetNotifier$AddToClip {
  _$_ClipModalSheetNotifier$AddToClip(this.element, {super.state, super.key});

  @override
  final _$ClipModalSheetNotifierElement element;

  @override
  $ElementLense<_$_ClipModalSheetNotifier$AddToClip> get listenable =>
      element._$addToClip;

  @override
  Future<void> call(Clip clip) {
    return mutate(
      Invocation.method(#addToClip, [clip]),
      ($notifier) => $notifier.addToClip(clip),
    );
  }

  @override
  _$_ClipModalSheetNotifier$AddToClip copyWith(
    MutationState<void> state, {
    Object? key,
  }) => _$_ClipModalSheetNotifier$AddToClip(element, state: state, key: key);
}

sealed class _ClipModalSheetNotifier$RemoveFromClip extends MutationBase<void> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutation], then
  /// will call [_ClipModalSheetNotifier.removeFromClip] with the provided parameters.
  ///
  /// After the method completes, the mutation state will be updated to either
  /// [SuccessMutation] or [ErrorMutation] based on if the method
  /// threw or not.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  Future<void> call(Clip clip);
}

final class _$_ClipModalSheetNotifier$RemoveFromClip
    extends
        $AsyncMutationBase<
          void,
          _$_ClipModalSheetNotifier$RemoveFromClip,
          _ClipModalSheetNotifier
        >
    implements _ClipModalSheetNotifier$RemoveFromClip {
  _$_ClipModalSheetNotifier$RemoveFromClip(
    this.element, {
    super.state,
    super.key,
  });

  @override
  final _$ClipModalSheetNotifierElement element;

  @override
  $ElementLense<_$_ClipModalSheetNotifier$RemoveFromClip> get listenable =>
      element._$removeFromClip;

  @override
  Future<void> call(Clip clip) {
    return mutate(
      Invocation.method(#removeFromClip, [clip]),
      ($notifier) => $notifier.removeFromClip(clip),
    );
  }

  @override
  _$_ClipModalSheetNotifier$RemoveFromClip copyWith(
    MutationState<void> state, {
    Object? key,
  }) =>
      _$_ClipModalSheetNotifier$RemoveFromClip(element, state: state, key: key);
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
