// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialog_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(DialogStateNotifier)
const dialogStateNotifierProvider = DialogStateNotifierProvider._();

final class DialogStateNotifierProvider
    extends $NotifierProvider<DialogStateNotifier, DialogsState> {
  const DialogStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dialogStateNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dialogStateNotifierHash();

  @$internal
  @override
  DialogStateNotifier create() => DialogStateNotifier();

  @$internal
  @override
  $NotifierProviderElement<DialogStateNotifier, DialogsState> $createElement(
    $ProviderPointer pointer,
  ) => $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DialogsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<DialogsState>(value),
    );
  }
}

String _$dialogStateNotifierHash() =>
    r'343762a93c3daf2931bda3d287046cc566cda24e';

abstract class _$DialogStateNotifier extends $Notifier<DialogsState> {
  DialogsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DialogsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DialogsState>,
              DialogsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
