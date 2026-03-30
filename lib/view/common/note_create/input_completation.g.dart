// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_completation.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(InputCompletionTypeNotifier)
const inputCompletionTypeNotifierProvider =
    InputCompletionTypeNotifierProvider._();

final class InputCompletionTypeNotifierProvider
    extends
        $NotifierProvider<InputCompletionTypeNotifier, InputCompletionType> {
  const InputCompletionTypeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inputCompletionTypeNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inputCompletionTypeNotifierHash();

  @$internal
  @override
  InputCompletionTypeNotifier create() => InputCompletionTypeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InputCompletionType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InputCompletionType>(value),
    );
  }
}

String _$inputCompletionTypeNotifierHash() =>
    r'e2c46ec5b943ea642cb750e3a170526b71d8420f';

abstract class _$InputCompletionTypeNotifier
    extends $Notifier<InputCompletionType> {
  InputCompletionType build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<InputCompletionType, InputCompletionType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InputCompletionType, InputCompletionType>,
              InputCompletionType,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
