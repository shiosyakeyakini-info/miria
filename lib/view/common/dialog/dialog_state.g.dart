// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialog_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DialogStateNotifier)
final dialogStateProvider = DialogStateNotifierProvider._();

final class DialogStateNotifierProvider
    extends $NotifierProvider<DialogStateNotifier, DialogsState> {
  DialogStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dialogStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dialogStateNotifierHash();

  @$internal
  @override
  DialogStateNotifier create() => DialogStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DialogsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DialogsState>(value),
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
    final ref = this.ref as $Ref<DialogsState, DialogsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DialogsState, DialogsState>,
              DialogsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
