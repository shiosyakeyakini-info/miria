// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clip_settings_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clipSettingsNotifierHash();

  @$internal
  @override
  _ClipSettingsNotifier create() => _ClipSettingsNotifier();

  @$internal
  @override
  $NotifierProviderElement<_ClipSettingsNotifier, ClipSettings> $createElement(
    $ProviderPointer pointer,
  ) => $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClipSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<ClipSettings>(value),
    );
  }
}

String _$clipSettingsNotifierHash() =>
    r'a31c8af941b36dbb6da351a2e072423b888c0daf';

abstract class _$ClipSettingsNotifier extends $Notifier<ClipSettings> {
  ClipSettings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ClipSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ClipSettings>,
              ClipSettings,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
