// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'license_confirm_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_emoji)
final _emojiProvider = _EmojiFamily._();

final class _EmojiProvider
    extends
        $FunctionalProvider<
          AsyncValue<EmojiResponse>,
          EmojiResponse,
          FutureOr<EmojiResponse>
        >
    with $FutureModifier<EmojiResponse>, $FutureProvider<EmojiResponse> {
  _EmojiProvider._({
    required _EmojiFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'_emojiProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = misskeyPostContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$_emojiHash();

  @override
  String toString() {
    return r'_emojiProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<EmojiResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<EmojiResponse> create(Ref ref) {
    final argument = this.argument as String;
    return _emoji(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is _EmojiProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_emojiHash() => r'4d613b2d1965a683c3d159578f812609b9f6cbd1';

final class _EmojiFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<EmojiResponse>, String> {
  _EmojiFamily._()
    : super(
        retry: null,
        name: r'_emojiProvider',
        dependencies: <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          _EmojiProvider.$allTransitiveDependencies0,
          _EmojiProvider.$allTransitiveDependencies1,
        ],
        isAutoDispose: true,
      );

  _EmojiProvider call(String emoji) =>
      _EmojiProvider._(argument: emoji, from: this);

  @override
  String toString() => r'_emojiProvider';
}
