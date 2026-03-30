// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_settings_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(GeneralSettingsNotifier)
const generalSettingsNotifierProvider = GeneralSettingsNotifierProvider._();

final class GeneralSettingsNotifierProvider
    extends $NotifierProvider<GeneralSettingsNotifier, GeneralSettings> {
  const GeneralSettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'generalSettingsNotifierProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$generalSettingsNotifierHash();

  @$internal
  @override
  GeneralSettingsNotifier create() => GeneralSettingsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GeneralSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GeneralSettings>(value),
    );
  }
}

String _$generalSettingsNotifierHash() =>
    r'a31f74afd71e97020d740fb730b9160159c9742c';

abstract class _$GeneralSettingsNotifier extends $Notifier<GeneralSettings> {
  GeneralSettings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<GeneralSettings, GeneralSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GeneralSettings, GeneralSettings>,
              GeneralSettings,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
