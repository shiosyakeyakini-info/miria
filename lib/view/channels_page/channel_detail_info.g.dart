// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_detail_info.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

  @override
  bool operator ==(Object other) {
    return other is ChannelDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$channelDetailHash() => r'1856423bc5f37b9238872a785f42fa214c0bb2c5';

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
    final ref =
        this.ref as $Ref<AsyncValue<ChannelDetailState>, ChannelDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ChannelDetailState>, ChannelDetailState>,
              AsyncValue<ChannelDetailState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
