// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_detail_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_onlineCounts)
const _onlineCountsProvider = _OnlineCountsProvider._();

final class _OnlineCountsProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  const _OnlineCountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_onlineCountsProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[misskeyGetContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          _OnlineCountsProvider.$allTransitiveDependencies0,
          _OnlineCountsProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = misskeyGetContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyGetContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$_onlineCountsHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return _onlineCounts(ref);
  }
}

String _$_onlineCountsHash() => r'948bcc533f8c06ee79935fc5386ad67051c03bb9';

@ProviderFor(_totalMemories)
const _totalMemoriesProvider = _TotalMemoriesProvider._();

final class _TotalMemoriesProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  const _TotalMemoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_totalMemoriesProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[misskeyGetContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          _TotalMemoriesProvider.$allTransitiveDependencies0,
          _TotalMemoriesProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = misskeyGetContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyGetContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$_totalMemoriesHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return _totalMemories(ref);
  }
}

String _$_totalMemoriesHash() => r'd7f5bc52076ca1a74f8cdf65938cff571a92acd8';

@ProviderFor(_ping)
const _pingProvider = _PingProvider._();

final class _PingProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  const _PingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_pingProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[misskeyGetContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          _PingProvider.$allTransitiveDependencies0,
          _PingProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = misskeyGetContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyGetContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$_pingHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return _ping(ref);
  }
}

String _$_pingHash() => r'3e002e48252dd1158c3ecdf4c6c4a635c5bc80fa';
