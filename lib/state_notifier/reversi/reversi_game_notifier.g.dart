// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reversi_game_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReversiGameNotifier)
final reversiGameProvider = ReversiGameNotifierFamily._();

final class ReversiGameNotifierProvider
    extends $AsyncNotifierProvider<ReversiGameNotifier, ReversiGameState> {
  ReversiGameNotifierProvider._({
    required ReversiGameNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'reversiGameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = misskeyPostContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$reversiGameNotifierHash();

  @override
  String toString() {
    return r'reversiGameProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ReversiGameNotifier create() => ReversiGameNotifier();

  @override
  bool operator ==(Object other) {
    return other is ReversiGameNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reversiGameNotifierHash() =>
    r'2d3f15546da89d29229d8e4f6a3ce709dafe05ff';

final class ReversiGameNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          ReversiGameNotifier,
          AsyncValue<ReversiGameState>,
          ReversiGameState,
          FutureOr<ReversiGameState>,
          String
        > {
  ReversiGameNotifierFamily._()
    : super(
        retry: null,
        name: r'reversiGameProvider',
        dependencies: <ProviderOrFamily>[
          misskeyPostContextProvider,
          accountContextProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>[
          ReversiGameNotifierProvider.$allTransitiveDependencies0,
          ReversiGameNotifierProvider.$allTransitiveDependencies1,
        ],
        isAutoDispose: true,
      );

  ReversiGameNotifierProvider call(String gameId) =>
      ReversiGameNotifierProvider._(argument: gameId, from: this);

  @override
  String toString() => r'reversiGameProvider';
}

abstract class _$ReversiGameNotifier extends $AsyncNotifier<ReversiGameState> {
  late final _$args = ref.$arg as String;
  String get gameId => _$args;

  FutureOr<ReversiGameState> build(String gameId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ReversiGameState>, ReversiGameState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ReversiGameState>, ReversiGameState>,
              AsyncValue<ReversiGameState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
