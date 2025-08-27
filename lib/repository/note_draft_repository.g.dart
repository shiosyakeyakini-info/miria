// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_draft_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(NoteDraftRepository)
const noteDraftRepositoryProvider = NoteDraftRepositoryProvider._();

final class NoteDraftRepositoryProvider
    extends $NotifierProvider<NoteDraftRepository, Map<String, NoteDraft>> {
  const NoteDraftRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'noteDraftRepositoryProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[
          misskeyPostContextProvider,
          accountContextProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          NoteDraftRepositoryProvider.$allTransitiveDependencies0,
          NoteDraftRepositoryProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = misskeyPostContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$noteDraftRepositoryHash();

  @$internal
  @override
  NoteDraftRepository create() => NoteDraftRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, NoteDraft> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, NoteDraft>>(value),
    );
  }
}

String _$noteDraftRepositoryHash() =>
    r'c91b1b6702e8bfc887859cd757eba4020236c65d';

abstract class _$NoteDraftRepository extends $Notifier<Map<String, NoteDraft>> {
  Map<String, NoteDraft> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<Map<String, NoteDraft>, Map<String, NoteDraft>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, NoteDraft>, Map<String, NoteDraft>>,
              Map<String, NoteDraft>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
