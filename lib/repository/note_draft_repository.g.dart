// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_draft_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NoteDraftRepository)
final noteDraftRepositoryProvider = NoteDraftRepositoryProvider._();

final class NoteDraftRepositoryProvider
    extends $NotifierProvider<NoteDraftRepository, Map<String, NoteDraft>> {
  NoteDraftRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'noteDraftRepositoryProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[
          misskeyPostContextProvider,
          accountContextProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>[
          NoteDraftRepositoryProvider.$allTransitiveDependencies0,
          NoteDraftRepositoryProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = misskeyPostContextProvider;
  static final $allTransitiveDependencies1 =
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
    element.handleCreate(ref, build);
  }
}
