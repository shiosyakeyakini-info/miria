// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_settings_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(AiSettingsRepository)
const aiSettingsRepositoryProvider = AiSettingsRepositoryProvider._();

final class AiSettingsRepositoryProvider
    extends $AsyncNotifierProvider<AiSettingsRepository, AiSettings> {
  const AiSettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiSettingsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiSettingsRepositoryHash();

  @$internal
  @override
  AiSettingsRepository create() => AiSettingsRepository();
}

String _$aiSettingsRepositoryHash() =>
    r'caadc99ddf07103f2527227e1ab1c50870622f19';

abstract class _$AiSettingsRepository extends $AsyncNotifier<AiSettings> {
  FutureOr<AiSettings> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<AiSettings>, AiSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AiSettings>, AiSettings>,
              AsyncValue<AiSettings>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
