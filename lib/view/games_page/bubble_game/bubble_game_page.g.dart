// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bubble_game_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_ranking)
final _rankingProvider = _RankingFamily._();

final class _RankingProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BubbleGameRankingResponse>>,
          List<BubbleGameRankingResponse>,
          FutureOr<List<BubbleGameRankingResponse>>
        >
    with
        $FutureModifier<List<BubbleGameRankingResponse>>,
        $FutureProvider<List<BubbleGameRankingResponse>> {
  _RankingProvider._({
    required _RankingFamily super.from,
    required BubbleGameMode super.argument,
  }) : super(
         retry: null,
         name: r'_rankingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = misskeyPostContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$_rankingHash();

  @override
  String toString() {
    return r'_rankingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<BubbleGameRankingResponse>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BubbleGameRankingResponse>> create(Ref ref) {
    final argument = this.argument as BubbleGameMode;
    return _ranking(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is _RankingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_rankingHash() => r'c9f185481536501e55eef616b3d05509d84fdf44';

final class _RankingFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<BubbleGameRankingResponse>>,
          BubbleGameMode
        > {
  _RankingFamily._()
    : super(
        retry: null,
        name: r'_rankingProvider',
        dependencies: <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          _RankingProvider.$allTransitiveDependencies0,
          _RankingProvider.$allTransitiveDependencies1,
        ],
        isAutoDispose: true,
      );

  _RankingProvider call(BubbleGameMode gameMode) =>
      _RankingProvider._(argument: gameMode, from: this);

  @override
  String toString() => r'_rankingProvider';
}
