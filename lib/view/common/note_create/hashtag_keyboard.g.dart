// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hashtag_keyboard.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_HashtagsSearch)
const _hashtagsSearchProvider = _HashtagsSearchFamily._();

final class _HashtagsSearchProvider
    extends $AsyncNotifierProvider<_HashtagsSearch, List<String>> {
  const _HashtagsSearchProvider._({
    required _HashtagsSearchFamily super.from,
    required (String, Account) super.argument,
  }) : super(
         retry: null,
         name: r'_hashtagsSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$_hashtagsSearchHash();

  @override
  String toString() {
    return r'_hashtagsSearchProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  _HashtagsSearch create() => _HashtagsSearch();

  @override
  bool operator ==(Object other) {
    return other is _HashtagsSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_hashtagsSearchHash() => r'33995ae8bae76065902a767060f73a587cb7664a';

final class _HashtagsSearchFamily extends $Family
    with
        $ClassFamilyOverride<
          _HashtagsSearch,
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>,
          (String, Account)
        > {
  const _HashtagsSearchFamily._()
    : super(
        retry: null,
        name: r'_hashtagsSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  _HashtagsSearchProvider call(String query, Account account) =>
      _HashtagsSearchProvider._(argument: (query, account), from: this);

  @override
  String toString() => r'_hashtagsSearchProvider';
}

abstract class _$HashtagsSearch extends $AsyncNotifier<List<String>> {
  late final _$args = ref.$arg as (String, Account);
  String get query => _$args.$1;
  Account get account => _$args.$2;

  FutureOr<List<String>> build(String query, Account account);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2);
    final ref = this.ref as $Ref<AsyncValue<List<String>>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<String>>, List<String>>,
              AsyncValue<List<String>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
