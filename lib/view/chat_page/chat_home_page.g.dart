// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_home_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(history)
const historyProvider = HistoryProvider._();

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
  const HistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          HistoryProvider.$allTransitiveDependencies0,
          HistoryProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = misskeyPostContextProvider;
  static const $allTransitiveDependencies1 =
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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
