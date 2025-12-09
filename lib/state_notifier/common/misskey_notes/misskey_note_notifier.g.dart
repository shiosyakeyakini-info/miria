// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_note_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MisskeyNoteNotifier)
const misskeyNoteProvider = MisskeyNoteNotifierProvider._();

final class MisskeyNoteNotifierProvider
    extends $NotifierProvider<MisskeyNoteNotifier, void> {
  const MisskeyNoteNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'misskeyNoteProvider',
        isAutoDispose: false,
        dependencies: const <ProviderOrFamily>[
          accountContextProvider,
          misskeyGetContextProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          MisskeyNoteNotifierProvider.$allTransitiveDependencies0,
          MisskeyNoteNotifierProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = accountContextProvider;
  static const $allTransitiveDependencies1 = misskeyGetContextProvider;

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
    r'2498b99dd118b71f706d8d830b41047aa7ee3ded';

abstract class _$MisskeyNoteNotifier extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
