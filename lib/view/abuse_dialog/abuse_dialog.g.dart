// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abuse_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(AbuseDialogNotifier)
const abuseDialogNotifierProvider = AbuseDialogNotifierProvider._();

final class AbuseDialogNotifierProvider
    extends $NotifierProvider<AbuseDialogNotifier, void> {
  const AbuseDialogNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'abuseDialogNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$abuseDialogNotifierHash();

  @$internal
  @override
  AbuseDialogNotifier create() => AbuseDialogNotifier();

  @$internal
  @override
  _$AbuseDialogNotifierElement $createElement($ProviderPointer pointer) =>
      _$AbuseDialogNotifierElement(pointer);

  ProviderListenable<AbuseDialogNotifier$ReportAbuse> get reportAbuse =>
      $LazyProxyListenable<AbuseDialogNotifier$ReportAbuse, void>(this, (
        element,
      ) {
        element as _$AbuseDialogNotifierElement;

        return element._$reportAbuse;
      });

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<void>(value),
    );
  }
}

String _$abuseDialogNotifierHash() =>
    r'a40640cb5b0090a796db7b2bd2a260aab35c42df';

abstract class _$AbuseDialogNotifier extends $Notifier<void> {
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

class _$AbuseDialogNotifierElement
    extends $NotifierProviderElement<AbuseDialogNotifier, void> {
  _$AbuseDialogNotifierElement(super.pointer) {
    _$reportAbuse.result = $Result.data(
      _$AbuseDialogNotifier$ReportAbuse(this),
    );
  }
  final _$reportAbuse = $ElementLense<_$AbuseDialogNotifier$ReportAbuse>();
  @override
  void mount() {
    super.mount();
    _$reportAbuse.result!.value!.reset();
  }

  @override
  void visitListenables(
    void Function($ElementLense element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);

    listenableVisitor(_$reportAbuse);
  }
}

sealed class AbuseDialogNotifier$ReportAbuse extends MutationBase<void> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutation], then
  /// will call [AbuseDialogNotifier.reportAbuse] with the provided parameters.
  ///
  /// After the method completes, the mutation state will be updated to either
  /// [SuccessMutation] or [ErrorMutation] based on if the method
  /// threw or not.
  ///
  /// **Note**:
  /// If the notifier threw in its constructor, the mutation won't start
  /// and [call] will throw.
  /// This should generally never happen though, as Notifiers are not supposed
  /// to have logic in their constructors.
  Future<void> call({required String userId, required String comment});
}

final class _$AbuseDialogNotifier$ReportAbuse
    extends
        $AsyncMutationBase<
          void,
          _$AbuseDialogNotifier$ReportAbuse,
          AbuseDialogNotifier
        >
    implements AbuseDialogNotifier$ReportAbuse {
  _$AbuseDialogNotifier$ReportAbuse(this.element, {super.state, super.key});

  @override
  final _$AbuseDialogNotifierElement element;

  @override
  $ElementLense<_$AbuseDialogNotifier$ReportAbuse> get listenable =>
      element._$reportAbuse;

  @override
  Future<void> call({required String userId, required String comment}) {
    return mutate(
      Invocation.method(#reportAbuse, [], {#userId: userId, #comment: comment}),
      ($notifier) => $notifier.reportAbuse(userId: userId, comment: comment),
    );
  }

  @override
  _$AbuseDialogNotifier$ReportAbuse copyWith(
    MutationState<void> state, {
    Object? key,
  }) => _$AbuseDialogNotifier$ReportAbuse(element, state: state, key: key);
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
