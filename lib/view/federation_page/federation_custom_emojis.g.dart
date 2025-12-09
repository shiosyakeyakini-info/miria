// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'federation_custom_emojis.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fetchEmoji)
const fetchEmojiProvider = FetchEmojiFamily._();

final class FetchEmojiProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, List<Emoji>>>,
          Map<String, List<Emoji>>,
          FutureOr<Map<String, List<Emoji>>>
        >
    with
        $FutureModifier<Map<String, List<Emoji>>>,
        $FutureProvider<Map<String, List<Emoji>>> {
  const FetchEmojiProvider._({
    required FetchEmojiFamily super.from,
    required (String, MetaResponse) super.argument,
  }) : super(
         retry: null,
         name: r'fetchEmojiProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = misskeyGetContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyGetContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$fetchEmojiHash();

  @override
  String toString() {
    return r'fetchEmojiProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, List<Emoji>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, List<Emoji>>> create(Ref ref) {
    final argument = this.argument as (String, MetaResponse);
    return fetchEmoji(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchEmojiProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fetchEmojiHash() => r'6a0537c48cf48be2dd1c1823cd69d72ebaa8906b';

final class FetchEmojiFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, List<Emoji>>>,
          (String, MetaResponse)
        > {
  const FetchEmojiFamily._()
    : super(
        retry: null,
        name: r'fetchEmojiProvider',
        dependencies: const <ProviderOrFamily>[misskeyGetContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          FetchEmojiProvider.$allTransitiveDependencies0,
          FetchEmojiProvider.$allTransitiveDependencies1,
        ],
        isAutoDispose: true,
      );

  FetchEmojiProvider call(String host, MetaResponse meta) =>
      FetchEmojiProvider._(argument: (host, meta), from: this);

  @override
  String toString() => r'fetchEmojiProvider';
}
