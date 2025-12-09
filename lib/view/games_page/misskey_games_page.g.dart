// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_games_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_fetchReversiData)
const _fetchReversiDataProvider = _FetchReversiDataProvider._();

final class _FetchReversiDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<User>>,
          List<User>,
          FutureOr<List<User>>
        >
    with $FutureModifier<List<User>>, $FutureProvider<List<User>> {
  const _FetchReversiDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_fetchReversiDataProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          _FetchReversiDataProvider.$allTransitiveDependencies0,
          _FetchReversiDataProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = misskeyPostContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$_fetchReversiDataHash();

  @$internal
  @override
  $FutureProviderElement<List<User>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<User>> create(Ref ref) {
    return _fetchReversiData(ref);
  }
}

String _$_fetchReversiDataHash() => r'c83ae0f4b7d51c2f9b8d800e959556517d4a8839';
