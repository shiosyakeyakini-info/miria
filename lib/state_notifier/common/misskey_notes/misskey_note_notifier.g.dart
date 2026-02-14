// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_note_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MisskeyNoteNotifier)
final misskeyNoteProvider = MisskeyNoteNotifierProvider._();

final class MisskeyNoteNotifierProvider
    extends $NotifierProvider<MisskeyNoteNotifier, void> {
  MisskeyNoteNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'misskeyNoteProvider',
        isAutoDispose: false,
        dependencies: <ProviderOrFamily>[
          accountContextProvider,
          misskeyGetContextProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>[
          MisskeyNoteNotifierProvider.$allTransitiveDependencies0,
          MisskeyNoteNotifierProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = accountContextProvider;
  static final $allTransitiveDependencies1 = misskeyGetContextProvider;

  @override
  String debugGetCreateSourceHash() => _$misskeyNoteNotifierHash();

  @$internal
  @override
  MisskeyNoteNotifier create() => MisskeyNoteNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$misskeyNoteNotifierHash() =>
    r'2eaa2dab6ead93c01dd98132fc90e47d34b78dce';

abstract class _$MisskeyNoteNotifier extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
