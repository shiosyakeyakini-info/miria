// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'federation_custom_emojis.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fetchEmoji)
final fetchEmojiProvider = FetchEmojiFamily._();

final class FetchEmojiProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, List<EmojiSimple>>>,
          Map<String, List<EmojiSimple>>,
          FutureOr<Map<String, List<EmojiSimple>>>
        >
    with
        $FutureModifier<Map<String, List<EmojiSimple>>>,
        $FutureProvider<Map<String, List<EmojiSimple>>> {
  FetchEmojiProvider._({
    required FetchEmojiFamily super.from,
    required (String, MetaResponse) super.argument,
  }) : super(
         retry: null,
         name: r'fetchEmojiProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = misskeyGetContextProvider;
  static final $allTransitiveDependencies1 =
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
  $FutureProviderElement<Map<String, List<EmojiSimple>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, List<EmojiSimple>>> create(Ref ref) {
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

String _$fetchEmojiHash() => r'ff757f9d55617dd91a6e5c80e82cc2c7ee9e694a';

final class FetchEmojiFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, List<EmojiSimple>>>,
          (String, MetaResponse)
        > {
  FetchEmojiFamily._()
    : super(
        retry: null,
        name: r'fetchEmojiProvider',
        dependencies: <ProviderOrFamily>[misskeyGetContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
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
