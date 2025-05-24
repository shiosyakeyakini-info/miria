// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'antennas_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(AntennasNotifier)
const antennasNotifierProvider = AntennasNotifierProvider._();

final class AntennasNotifierProvider
    extends $AsyncNotifierProvider<AntennasNotifier, List<Antenna>> {
  const AntennasNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'antennasNotifierProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          AntennasNotifierProvider.$allTransitiveDependencies0,
          AntennasNotifierProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = misskeyPostContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$antennasNotifierHash();

  @$internal
  @override
  AntennasNotifier create() => AntennasNotifier();

  @$internal
  @override
  _$AntennasNotifierElement $createElement($ProviderPointer pointer) =>
      _$AntennasNotifierElement(pointer);

  ProviderListenable<AntennasNotifier$CreateAntenna> get createAntenna =>
      $LazyProxyListenable<
        AntennasNotifier$CreateAntenna,
        AsyncValue<List<Antenna>>
      >(this, (element) {
        element as _$AntennasNotifierElement;

        return element._$createAntenna;
      });

  ProviderListenable<AntennasNotifier$DeleteAntenna> get deleteAntenna =>
      $LazyProxyListenable<
        AntennasNotifier$DeleteAntenna,
        AsyncValue<List<Antenna>>
      >(this, (element) {
        element as _$AntennasNotifierElement;

        return element._$deleteAntenna;
      });

  ProviderListenable<AntennasNotifier$UpdateAntenna> get updateAntenna =>
      $LazyProxyListenable<
        AntennasNotifier$UpdateAntenna,
        AsyncValue<List<Antenna>>
      >(this, (element) {
        element as _$AntennasNotifierElement;

        return element._$updateAntenna;
      });
}

String _$antennasNotifierHash() => r'5171beae8ace9ab19319086b41ac62709e0174f5';

abstract class _$AntennasNotifier extends $AsyncNotifier<List<Antenna>> {
  FutureOr<List<Antenna>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Antenna>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Antenna>>>,
              AsyncValue<List<Antenna>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

class _$AntennasNotifierElement
    extends $AsyncNotifierProviderElement<AntennasNotifier, List<Antenna>> {
  _$AntennasNotifierElement(super.pointer) {
    _$createAntenna.result = $Result.data(
      _$AntennasNotifier$CreateAntenna(this),
    );
    _$deleteAntenna.result = $Result.data(
      _$AntennasNotifier$DeleteAntenna(this),
    );
    _$updateAntenna.result = $Result.data(
      _$AntennasNotifier$UpdateAntenna(this),
    );
  }
  final _$createAntenna = $ElementLense<_$AntennasNotifier$CreateAntenna>();
  final _$deleteAntenna = $ElementLense<_$AntennasNotifier$DeleteAntenna>();
  final _$updateAntenna = $ElementLense<_$AntennasNotifier$UpdateAntenna>();
  @override
  void mount() {
    super.mount();
    _$createAntenna.result!.value!.reset();
    _$deleteAntenna.result!.value!.reset();
    _$updateAntenna.result!.value!.reset();
  }

  @override
  void visitListenables(
    void Function($ElementLense element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);

    listenableVisitor(_$createAntenna);
    listenableVisitor(_$deleteAntenna);
    listenableVisitor(_$updateAntenna);
  }
}

sealed class AntennasNotifier$CreateAntenna extends MutationBase<void> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutation], then
  /// will call [AntennasNotifier.createAntenna] with the provided parameters.
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
  Future<void> call(AntennaSettings settings);
}

final class _$AntennasNotifier$CreateAntenna
    extends
        $AsyncMutationBase<
          void,
          _$AntennasNotifier$CreateAntenna,
          AntennasNotifier
        >
    implements AntennasNotifier$CreateAntenna {
  _$AntennasNotifier$CreateAntenna(this.element, {super.state, super.key});

  @override
  final _$AntennasNotifierElement element;

  @override
  $ElementLense<_$AntennasNotifier$CreateAntenna> get listenable =>
      element._$createAntenna;

  @override
  Future<void> call(AntennaSettings settings) {
    return mutate(
      Invocation.method(#createAntenna, [settings]),
      ($notifier) => $notifier.createAntenna(settings),
    );
  }

  @override
  _$AntennasNotifier$CreateAntenna copyWith(
    MutationState<void> state, {
    Object? key,
  }) => _$AntennasNotifier$CreateAntenna(element, state: state, key: key);
}

sealed class AntennasNotifier$DeleteAntenna extends MutationBase<void> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutation], then
  /// will call [AntennasNotifier.deleteAntenna] with the provided parameters.
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
  Future<void> call(String antennaId);
}

final class _$AntennasNotifier$DeleteAntenna
    extends
        $AsyncMutationBase<
          void,
          _$AntennasNotifier$DeleteAntenna,
          AntennasNotifier
        >
    implements AntennasNotifier$DeleteAntenna {
  _$AntennasNotifier$DeleteAntenna(this.element, {super.state, super.key});

  @override
  final _$AntennasNotifierElement element;

  @override
  $ElementLense<_$AntennasNotifier$DeleteAntenna> get listenable =>
      element._$deleteAntenna;

  @override
  Future<void> call(String antennaId) {
    return mutate(
      Invocation.method(#deleteAntenna, [antennaId]),
      ($notifier) => $notifier.deleteAntenna(antennaId),
    );
  }

  @override
  _$AntennasNotifier$DeleteAntenna copyWith(
    MutationState<void> state, {
    Object? key,
  }) => _$AntennasNotifier$DeleteAntenna(element, state: state, key: key);
}

sealed class AntennasNotifier$UpdateAntenna extends MutationBase<void> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutation], then
  /// will call [AntennasNotifier.updateAntenna] with the provided parameters.
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
  Future<void> call(String antennaId, AntennaSettings settings);
}

final class _$AntennasNotifier$UpdateAntenna
    extends
        $AsyncMutationBase<
          void,
          _$AntennasNotifier$UpdateAntenna,
          AntennasNotifier
        >
    implements AntennasNotifier$UpdateAntenna {
  _$AntennasNotifier$UpdateAntenna(this.element, {super.state, super.key});

  @override
  final _$AntennasNotifierElement element;

  @override
  $ElementLense<_$AntennasNotifier$UpdateAntenna> get listenable =>
      element._$updateAntenna;

  @override
  Future<void> call(String antennaId, AntennaSettings settings) {
    return mutate(
      Invocation.method(#updateAntenna, [antennaId, settings]),
      ($notifier) => $notifier.updateAntenna(antennaId, settings),
    );
  }

  @override
  _$AntennasNotifier$UpdateAntenna copyWith(
    MutationState<void> state, {
    Object? key,
  }) => _$AntennasNotifier$UpdateAntenna(element, state: state, key: key);
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
