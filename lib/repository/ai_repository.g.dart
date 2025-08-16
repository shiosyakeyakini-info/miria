// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(AiRepository)
const aiRepositoryProvider = AiRepositoryProvider._();

final class AiRepositoryProvider
    extends $NotifierProvider<AiRepository, AiRepository> {
  const AiRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiRepositoryHash();

  @$internal
  @override
  AiRepository create() => AiRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiRepository>(value),
    );
  }
}

String _$aiRepositoryHash() => r'9162f51345a10b0709602de69f3026d34dfedcee';

abstract class _$AiRepository extends $Notifier<AiRepository> {
  AiRepository build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AiRepository, AiRepository>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AiRepository, AiRepository>,
              AiRepository,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
