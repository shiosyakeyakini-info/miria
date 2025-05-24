// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hashtag_keyboard.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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
  String debugGetCreateSourceHash() => _$hashtagsSearchHash();

  @override
  String toString() {
    return r'_hashtagsSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  _HashtagsSearch create() => _HashtagsSearch();

  @$internal
  @override
  $AsyncNotifierProviderElement<_HashtagsSearch, List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $AsyncNotifierProviderElement(pointer);

  @override
  bool operator ==(Object other) {
    return other is _HashtagsSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hashtagsSearchHash() => r'3fbf1ca4000eaeeb1a53d5a64f0a51f785d95813';

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

  _HashtagsSearchProvider call((String, Account) arg) =>
      _HashtagsSearchProvider._(argument: arg, from: this);

  @override
  String toString() => r'_hashtagsSearchProvider';
}

abstract class _$HashtagsSearch extends $AsyncNotifier<List<String>> {
  late final _$args = ref.$arg as (String, Account);
  (String, Account) get arg => _$args;

  FutureOr<List<String>> build((String, Account) arg);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<List<String>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<String>>>,
              AsyncValue<List<String>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(_FilteredHashtags)
const _filteredHashtagsProvider = _FilteredHashtagsFamily._();

final class _FilteredHashtagsProvider
    extends $NotifierProvider<_FilteredHashtags, List<String>> {
  const _FilteredHashtagsProvider._({
    required _FilteredHashtagsFamily super.from,
    required Account super.argument,
  }) : super(
         retry: null,
         name: r'_filteredHashtagsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$filteredHashtagsHash();

  @override
  String toString() {
    return r'_filteredHashtagsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  _FilteredHashtags create() => _FilteredHashtags();

  @$internal
  @override
  $NotifierProviderElement<_FilteredHashtags, List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<List<String>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _FilteredHashtagsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$filteredHashtagsHash() => r'ad8a4ff6097a9430da6aeb19000a7503034b868a';

final class _FilteredHashtagsFamily extends $Family
    with
        $ClassFamilyOverride<
          _FilteredHashtags,
          List<String>,
          List<String>,
          List<String>,
          Account
        > {
  const _FilteredHashtagsFamily._()
    : super(
        retry: null,
        name: r'_filteredHashtagsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  _FilteredHashtagsProvider call(Account arg) =>
      _FilteredHashtagsProvider._(argument: arg, from: this);

  @override
  String toString() => r'_filteredHashtagsProvider';
}

abstract class _$FilteredHashtags extends $Notifier<List<String>> {
  late final _$args = ref.$arg as Account;
  Account get arg => _$args;

  List<String> build(Account arg);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
