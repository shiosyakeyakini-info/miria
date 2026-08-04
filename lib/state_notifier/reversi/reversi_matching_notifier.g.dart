// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reversi_matching_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReversiMatchingNotifier)
final reversiMatchingProvider = ReversiMatchingNotifierProvider._();

final class ReversiMatchingNotifierProvider
    extends
        $AsyncNotifierProvider<ReversiMatchingNotifier, ReversiMatchingState> {
  ReversiMatchingNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reversiMatchingProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          ReversiMatchingNotifierProvider.$allTransitiveDependencies0,
          ReversiMatchingNotifierProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = misskeyPostContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$reversiMatchingNotifierHash();

  @$internal
  @override
  ReversiMatchingNotifier create() => ReversiMatchingNotifier();
}

String _$reversiMatchingNotifierHash() =>
    r'84a466ffc5f9070163c95e9879892f3566112185';

abstract class _$ReversiMatchingNotifier
    extends $AsyncNotifier<ReversiMatchingState> {
  FutureOr<ReversiMatchingState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<ReversiMatchingState>, ReversiMatchingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ReversiMatchingState>,
                ReversiMatchingState
              >,
              AsyncValue<ReversiMatchingState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
