// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_detail_info.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(ChannelDetail)
const channelDetailProvider = ChannelDetailFamily._();

final class ChannelDetailProvider
    extends $AsyncNotifierProvider<ChannelDetail, ChannelDetailState> {
  const ChannelDetailProvider._({
    required ChannelDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'channelDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = misskeyGetContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyGetContextProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies2 = misskeyPostContextProvider;
  static const $allTransitiveDependencies3 = notesWithProvider;

  @override
  String debugGetCreateSourceHash() => _$channelDetailHash();

  @override
  String toString() {
    return r'channelDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChannelDetail create() => ChannelDetail();

  @$internal
  @override
  _$ChannelDetailElement $createElement($ProviderPointer pointer) =>
      _$ChannelDetailElement(pointer);

  ProviderListenable<ChannelDetail$Follow> get follow => $LazyProxyListenable<
    ChannelDetail$Follow,
    AsyncValue<ChannelDetailState>
  >(this, (element) {
    element as _$ChannelDetailElement;

    return element._$follow;
  });

  ProviderListenable<ChannelDetail$Unfollow> get unfollow =>
      $LazyProxyListenable<
        ChannelDetail$Unfollow,
        AsyncValue<ChannelDetailState>
      >(this, (element) {
        element as _$ChannelDetailElement;

        return element._$unfollow;
      });

  ProviderListenable<ChannelDetail$Favorite> get favorite =>
      $LazyProxyListenable<
        ChannelDetail$Favorite,
        AsyncValue<ChannelDetailState>
      >(this, (element) {
        element as _$ChannelDetailElement;

        return element._$favorite;
      });

  ProviderListenable<ChannelDetail$Unfavorite> get unfavorite =>
      $LazyProxyListenable<
        ChannelDetail$Unfavorite,
        AsyncValue<ChannelDetailState>
      >(this, (element) {
        element as _$ChannelDetailElement;

        return element._$unfavorite;
      });

  @override
  bool operator ==(Object other) {
    return other is ChannelDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$channelDetailHash() => r'5eaa439fc6ef806ecf76d47c1650006df7c13693';

final class ChannelDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          ChannelDetail,
          AsyncValue<ChannelDetailState>,
          ChannelDetailState,
          FutureOr<ChannelDetailState>,
          String
        > {
  const ChannelDetailFamily._()
    : super(
        retry: null,
        name: r'channelDetailProvider',
        dependencies: const <ProviderOrFamily>[
          misskeyGetContextProvider,
          misskeyPostContextProvider,
          notesWithProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>{
          ChannelDetailProvider.$allTransitiveDependencies0,
          ChannelDetailProvider.$allTransitiveDependencies1,
          ChannelDetailProvider.$allTransitiveDependencies2,
          ChannelDetailProvider.$allTransitiveDependencies3,
        },
        isAutoDispose: true,
      );

  ChannelDetailProvider call(String channelId) =>
      ChannelDetailProvider._(argument: channelId, from: this);

  @override
  String toString() => r'channelDetailProvider';
}

abstract class _$ChannelDetail extends $AsyncNotifier<ChannelDetailState> {
  late final _$args = ref.$arg as String;
  String get channelId => _$args;

  FutureOr<ChannelDetailState> build(String channelId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<ChannelDetailState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ChannelDetailState>>,
              AsyncValue<ChannelDetailState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

class _$ChannelDetailElement
    extends $AsyncNotifierProviderElement<ChannelDetail, ChannelDetailState> {
  _$ChannelDetailElement(super.pointer) {
    _$follow.result = $Result.data(_$ChannelDetail$Follow(this));
    _$unfollow.result = $Result.data(_$ChannelDetail$Unfollow(this));
    _$favorite.result = $Result.data(_$ChannelDetail$Favorite(this));
    _$unfavorite.result = $Result.data(_$ChannelDetail$Unfavorite(this));
  }
  final _$follow = $ElementLense<_$ChannelDetail$Follow>();
  final _$unfollow = $ElementLense<_$ChannelDetail$Unfollow>();
  final _$favorite = $ElementLense<_$ChannelDetail$Favorite>();
  final _$unfavorite = $ElementLense<_$ChannelDetail$Unfavorite>();
  @override
  void mount() {
    super.mount();
    _$follow.result!.value!.reset();
    _$unfollow.result!.value!.reset();
    _$favorite.result!.value!.reset();
    _$unfavorite.result!.value!.reset();
  }

  @override
  void visitListenables(
    void Function($ElementLense element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);

    listenableVisitor(_$follow);
    listenableVisitor(_$unfollow);
    listenableVisitor(_$favorite);
    listenableVisitor(_$unfavorite);
  }
}

sealed class ChannelDetail$Follow extends MutationBase<void> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutation], then
  /// will call [ChannelDetail.follow] with the provided parameters.
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
  Future<void> call();
}

final class _$ChannelDetail$Follow
    extends $AsyncMutationBase<void, _$ChannelDetail$Follow, ChannelDetail>
    implements ChannelDetail$Follow {
  _$ChannelDetail$Follow(this.element, {super.state, super.key});

  @override
  final _$ChannelDetailElement element;

  @override
  $ElementLense<_$ChannelDetail$Follow> get listenable => element._$follow;

  @override
  Future<void> call() {
    return mutate(
      Invocation.method(#follow, []),
      ($notifier) => $notifier.follow(),
    );
  }

  @override
  _$ChannelDetail$Follow copyWith(MutationState<void> state, {Object? key}) =>
      _$ChannelDetail$Follow(element, state: state, key: key);
}

sealed class ChannelDetail$Unfollow extends MutationBase<void> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutation], then
  /// will call [ChannelDetail.unfollow] with the provided parameters.
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
  Future<void> call();
}

final class _$ChannelDetail$Unfollow
    extends $AsyncMutationBase<void, _$ChannelDetail$Unfollow, ChannelDetail>
    implements ChannelDetail$Unfollow {
  _$ChannelDetail$Unfollow(this.element, {super.state, super.key});

  @override
  final _$ChannelDetailElement element;

  @override
  $ElementLense<_$ChannelDetail$Unfollow> get listenable => element._$unfollow;

  @override
  Future<void> call() {
    return mutate(
      Invocation.method(#unfollow, []),
      ($notifier) => $notifier.unfollow(),
    );
  }

  @override
  _$ChannelDetail$Unfollow copyWith(MutationState<void> state, {Object? key}) =>
      _$ChannelDetail$Unfollow(element, state: state, key: key);
}

sealed class ChannelDetail$Favorite extends MutationBase<void> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutation], then
  /// will call [ChannelDetail.favorite] with the provided parameters.
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
  Future<void> call();
}

final class _$ChannelDetail$Favorite
    extends $AsyncMutationBase<void, _$ChannelDetail$Favorite, ChannelDetail>
    implements ChannelDetail$Favorite {
  _$ChannelDetail$Favorite(this.element, {super.state, super.key});

  @override
  final _$ChannelDetailElement element;

  @override
  $ElementLense<_$ChannelDetail$Favorite> get listenable => element._$favorite;

  @override
  Future<void> call() {
    return mutate(
      Invocation.method(#favorite, []),
      ($notifier) => $notifier.favorite(),
    );
  }

  @override
  _$ChannelDetail$Favorite copyWith(MutationState<void> state, {Object? key}) =>
      _$ChannelDetail$Favorite(element, state: state, key: key);
}

sealed class ChannelDetail$Unfavorite extends MutationBase<void> {
  /// Starts the mutation.
  ///
  /// This will first set the state to [PendingMutation], then
  /// will call [ChannelDetail.unfavorite] with the provided parameters.
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
  Future<void> call();
}

final class _$ChannelDetail$Unfavorite
    extends $AsyncMutationBase<void, _$ChannelDetail$Unfavorite, ChannelDetail>
    implements ChannelDetail$Unfavorite {
  _$ChannelDetail$Unfavorite(this.element, {super.state, super.key});

  @override
  final _$ChannelDetailElement element;

  @override
  $ElementLense<_$ChannelDetail$Unfavorite> get listenable =>
      element._$unfavorite;

  @override
  Future<void> call() {
    return mutate(
      Invocation.method(#unfavorite, []),
      ($notifier) => $notifier.unfavorite(),
    );
  }

  @override
  _$ChannelDetail$Unfavorite copyWith(
    MutationState<void> state, {
    Object? key,
  }) => _$ChannelDetail$Unfavorite(element, state: state, key: key);
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
