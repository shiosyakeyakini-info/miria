// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bubble_game_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bubbleGameRepository)
final bubbleGameRepositoryProvider = BubbleGameRepositoryProvider._();

final class BubbleGameRepositoryProvider
    extends
        $FunctionalProvider<
          BubbleGameRepository,
          BubbleGameRepository,
          BubbleGameRepository
        >
    with $Provider<BubbleGameRepository> {
  BubbleGameRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bubbleGameRepositoryProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          BubbleGameRepositoryProvider.$allTransitiveDependencies0,
          BubbleGameRepositoryProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = misskeyPostContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$bubbleGameRepositoryHash();

  @$internal
  @override
  $ProviderElement<BubbleGameRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BubbleGameRepository create(Ref ref) {
    return bubbleGameRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BubbleGameRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BubbleGameRepository>(value),
    );
  }
}

String _$bubbleGameRepositoryHash() =>
    r'11024508ac618e5ae4dde5e836969ff481287b67';
