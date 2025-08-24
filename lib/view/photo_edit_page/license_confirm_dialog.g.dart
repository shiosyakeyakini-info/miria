// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'license_confirm_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(_emoji)
const _emojiProvider = _EmojiFamily._();

final class _EmojiProvider
    extends
        $FunctionalProvider<
          AsyncValue<EmojiResponse>,
          EmojiResponse,
          FutureOr<EmojiResponse>
        >
    with $FutureModifier<EmojiResponse>, $FutureProvider<EmojiResponse> {
  const _EmojiProvider._({
    required _EmojiFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'_emojiProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = misskeyPostContextProvider;
  static const $allTransitiveDependencies1 =
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
  const _EmojiFamily._()
    : super(
        retry: null,
        name: r'_emojiProvider',
        dependencies: const <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
