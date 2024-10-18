// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'license_confirm_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$emojiHash() => r'28b9523a2b6115cce022c78dd796700ff24d3bac';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [_emoji].
@ProviderFor(_emoji)
const _emojiProvider = _EmojiFamily();

/// See also [_emoji].
class _EmojiFamily extends Family {
  /// See also [_emoji].
  const _EmojiFamily();

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    misskeyPostContextProvider
  ];

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    misskeyPostContextProvider,
    ...?misskeyPostContextProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'_emojiProvider';

  /// See also [_emoji].
  _EmojiProvider call(
    String emoji,
  ) {
    return _EmojiProvider(
      emoji,
    );
  }

  @visibleForOverriding
  @override
  _EmojiProvider getProviderOverride(
    covariant _EmojiProvider provider,
  ) {
    return call(
      provider.emoji,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      FutureOr<EmojiResponse> Function(_EmojiRef ref) create) {
    return _$EmojiFamilyOverride(this, create);
  }
}

class _$EmojiFamilyOverride implements FamilyOverride {
  _$EmojiFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<EmojiResponse> Function(_EmojiRef ref) create;

  @override
  final _EmojiFamily overriddenFamily;

  @override
  _EmojiProvider getProviderOverride(
    covariant _EmojiProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [_emoji].
class _EmojiProvider extends AutoDisposeFutureProvider<EmojiResponse> {
  /// See also [_emoji].
  _EmojiProvider(
    String emoji,
  ) : this._internal(
          (ref) => _emoji(
            ref as _EmojiRef,
            emoji,
          ),
          from: _emojiProvider,
          name: r'_emojiProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$emojiHash,
          dependencies: _EmojiFamily._dependencies,
          allTransitiveDependencies: _EmojiFamily._allTransitiveDependencies,
          emoji: emoji,
        );

  _EmojiProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.emoji,
  }) : super.internal();

  final String emoji;

  @override
  Override overrideWith(
    FutureOr<EmojiResponse> Function(_EmojiRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _EmojiProvider._internal(
        (ref) => create(ref as _EmojiRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        emoji: emoji,
      ),
    );
  }

  @override
  (String,) get argument {
    return (emoji,);
  }

  @override
  AutoDisposeFutureProviderElement<EmojiResponse> createElement() {
    return _EmojiProviderElement(this);
  }

  _EmojiProvider _copyWith(
    FutureOr<EmojiResponse> Function(_EmojiRef ref) create,
  ) {
    return _EmojiProvider._internal(
      (ref) => create(ref as _EmojiRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      emoji: emoji,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _EmojiProvider && other.emoji == emoji;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, emoji.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin _EmojiRef on AutoDisposeFutureProviderRef<EmojiResponse> {
  /// The parameter `emoji` of this provider.
  String get emoji;
}

class _EmojiProviderElement
    extends AutoDisposeFutureProviderElement<EmojiResponse> with _EmojiRef {
  _EmojiProviderElement(super.provider);

  @override
  String get emoji => (origin as _EmojiProvider).emoji;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
