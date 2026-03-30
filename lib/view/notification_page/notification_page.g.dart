// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(ShowActions)
const showActionsProvider = ShowActionsFamily._();

final class ShowActionsProvider extends $NotifierProvider<ShowActions, bool> {
  const ShowActionsProvider._({
    required ShowActionsFamily super.from,
    required NotificationData super.argument,
  }) : super(
         retry: null,
         name: r'showActionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$showActionsHash();

  @override
  String toString() {
    return r'showActionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ShowActions create() => ShowActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ShowActionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$showActionsHash() => r'eb3a172b160bbbd151168a0172ab49be5030ba53';

final class ShowActionsFamily extends $Family
    with $ClassFamilyOverride<ShowActions, bool, bool, bool, NotificationData> {
  const ShowActionsFamily._()
    : super(
        retry: null,
        name: r'showActionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ShowActionsProvider call(NotificationData data) =>
      ShowActionsProvider._(argument: data, from: this);

  @override
  String toString() => r'showActionsProvider';
}

abstract class _$ShowActions extends $Notifier<bool> {
  late final _$args = ref.$arg as NotificationData;
  NotificationData get data => _$args;

  bool build(NotificationData data);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(followRequests)
const followRequestsProvider = FollowRequestsProvider._();

final class FollowRequestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FollowRequest>>,
          List<FollowRequest>,
          FutureOr<List<FollowRequest>>
        >
    with
        $FutureModifier<List<FollowRequest>>,
        $FutureProvider<List<FollowRequest>> {
  const FollowRequestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'followRequestsProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          FollowRequestsProvider.$allTransitiveDependencies0,
          FollowRequestsProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = misskeyPostContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$followRequestsHash();

  @$internal
  @override
  $FutureProviderElement<List<FollowRequest>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<FollowRequest>> create(Ref ref) {
    return followRequests(ref);
  }
}

String _$followRequestsHash() => r'e4fcfbd6849d685a1609a29b7a1ba35765342774';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
