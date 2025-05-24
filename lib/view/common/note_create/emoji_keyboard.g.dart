// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji_keyboard.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(_FilteredEmojis)
const _filteredEmojisProvider = _FilteredEmojisFamily._();

final class _FilteredEmojisProvider
    extends $NotifierProvider<_FilteredEmojis, List<MisskeyEmojiData>> {
  const _FilteredEmojisProvider._({
    required _FilteredEmojisFamily super.from,
    required Account super.argument,
  }) : super(
         retry: null,
         name: r'_filteredEmojisProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$filteredEmojisHash();

  @override
  String toString() {
    return r'_filteredEmojisProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  _FilteredEmojis create() => _FilteredEmojis();

  @$internal
  @override
  $NotifierProviderElement<_FilteredEmojis, List<MisskeyEmojiData>>
  $createElement($ProviderPointer pointer) => $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<MisskeyEmojiData> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<List<MisskeyEmojiData>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _FilteredEmojisProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$filteredEmojisHash() => r'c32adc500c0e142a2242c8b79cb200d5ee1b299d';

final class _FilteredEmojisFamily extends $Family
    with
        $ClassFamilyOverride<
          _FilteredEmojis,
          List<MisskeyEmojiData>,
          List<MisskeyEmojiData>,
          List<MisskeyEmojiData>,
          Account
        > {
  const _FilteredEmojisFamily._()
    : super(
        retry: null,
        name: r'_filteredEmojisProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  _FilteredEmojisProvider call(Account arg) =>
      _FilteredEmojisProvider._(argument: arg, from: this);

  @override
  String toString() => r'_filteredEmojisProvider';
}

abstract class _$FilteredEmojis extends $Notifier<List<MisskeyEmojiData>> {
  late final _$args = ref.$arg as Account;
  Account get arg => _$args;

  List<MisskeyEmojiData> build(Account arg);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<List<MisskeyEmojiData>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<MisskeyEmojiData>>,
              List<MisskeyEmojiData>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
