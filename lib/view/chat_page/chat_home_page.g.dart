// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_home_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(history)
final historyProvider = HistoryProvider._();

final class HistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChatMessage>>,
          List<ChatMessage>,
          FutureOr<List<ChatMessage>>
        >
    with
        $FutureModifier<List<ChatMessage>>,
        $FutureProvider<List<ChatMessage>> {
  HistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          HistoryProvider.$allTransitiveDependencies0,
          HistoryProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = misskeyPostContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$historyHash();

  @$internal
  @override
  $FutureProviderElement<List<ChatMessage>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ChatMessage>> create(Ref ref) {
    return history(ref);
  }
}

String _$historyHash() => r'cb9e7c0825ef6f68d2b46eea4a992376349bf480';
