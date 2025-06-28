// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_note_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(MisskeyNoteNotifier)
const misskeyNoteNotifierProvider = MisskeyNoteNotifierProvider._();

final class MisskeyNoteNotifierProvider
    extends $NotifierProvider<MisskeyNoteNotifier, void> {
  const MisskeyNoteNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'misskeyNoteNotifierProvider',
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
    r'67d0d5e741e98aacdbe688516132f0c6032d8edd';

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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
