// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clip_settings_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(_formKey)
const _formKeyProvider = _FormKeyProvider._();

final class _FormKeyProvider
    extends
        $FunctionalProvider<
          GlobalKey<FormState>,
          GlobalKey<FormState>,
          GlobalKey<FormState>
        >
    with $Provider<GlobalKey<FormState>> {
  const _FormKeyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_formKeyProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[],
        $allTransitiveDependencies: const <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$_formKeyHash();

  @$internal
  @override
  $ProviderElement<GlobalKey<FormState>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GlobalKey<FormState> create(Ref ref) {
    return _formKey(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GlobalKey<FormState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GlobalKey<FormState>>(value),
    );
  }
}

String _$_formKeyHash() => r'd8a56e0366cb1a53da5331749cce00aef36862b1';

@ProviderFor(_initialSettings)
const _initialSettingsProvider = _InitialSettingsProvider._();

final class _InitialSettingsProvider
    extends $FunctionalProvider<ClipSettings, ClipSettings, ClipSettings>
    with $Provider<ClipSettings> {
  const _InitialSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_initialSettingsProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[],
        $allTransitiveDependencies: const <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$_initialSettingsHash();

  @$internal
  @override
  $ProviderElement<ClipSettings> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ClipSettings create(Ref ref) {
    return _initialSettings(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClipSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClipSettings>(value),
    );
  }
}

String _$_initialSettingsHash() => r'5822fd6a8e4070e8a4da0c299a6149e49f7ef49e';

@ProviderFor(_ClipSettingsNotifier)
const _clipSettingsNotifierProvider = _ClipSettingsNotifierProvider._();

final class _ClipSettingsNotifierProvider
    extends $NotifierProvider<_ClipSettingsNotifier, ClipSettings> {
  const _ClipSettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_clipSettingsNotifierProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[_initialSettingsProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          _ClipSettingsNotifierProvider.$allTransitiveDependencies0,
        ],
      );

  static const $allTransitiveDependencies0 = _initialSettingsProvider;

  @override
  String debugGetCreateSourceHash() => _$_clipSettingsNotifierHash();

  @$internal
  @override
  _ClipSettingsNotifier create() => _ClipSettingsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClipSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClipSettings>(value),
    );
  }
}

String _$_clipSettingsNotifierHash() =>
    r'004b0ddb0c4b37ca968f1da8c8390ef047727180';

abstract class _$ClipSettingsNotifier extends $Notifier<ClipSettings> {
  ClipSettings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ClipSettings, ClipSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ClipSettings, ClipSettings>,
              ClipSettings,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
