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
        dependencies: const <ProviderOrFamily>[accountContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          MisskeyNoteNotifierProvider.$allTransitiveDependencies0,
        ],
      );

  static const $allTransitiveDependencies0 = accountContextProvider;

  @override
  String debugGetCreateSourceHash() => _$misskeyNoteNotifierHash();

  @$internal
  @override
  MisskeyNoteNotifier create() => MisskeyNoteNotifier();

  @$internal
  @override
  $NotifierProviderElement<MisskeyNoteNotifier, void> $createElement(
    $ProviderPointer pointer,
  ) => $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<void>(value),
    );
  }
}

String _$misskeyNoteNotifierHash() =>
    r'30eda0d11cd6ab399588640cb08e0c3ead597b69';

abstract class _$MisskeyNoteNotifier extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void>;
    final element =
        ref.element
            as $ClassProviderElement<AnyNotifier<void>, void, Object?, Object?>;
    element.handleValue(ref, null);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
