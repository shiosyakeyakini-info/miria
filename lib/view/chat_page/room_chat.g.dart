// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_chat.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RoomChat)
final roomChatProvider = RoomChatFamily._();

final class RoomChatProvider
    extends $AsyncNotifierProvider<RoomChat, RoomChatState> {
  RoomChatProvider._({
    required RoomChatFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'roomChatProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = misskeyGetContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyGetContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$roomChatHash();

  @override
  String toString() {
    return r'roomChatProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RoomChat create() => RoomChat();

  @override
  bool operator ==(Object other) {
    return other is RoomChatProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$roomChatHash() => r'38c66d1756970f926a65a2dcc56051a1cbcbeb27';

final class RoomChatFamily extends $Family
    with
        $ClassFamilyOverride<
          RoomChat,
          AsyncValue<RoomChatState>,
          RoomChatState,
          FutureOr<RoomChatState>,
          String
        > {
  RoomChatFamily._()
    : super(
        retry: null,
        name: r'roomChatProvider',
        dependencies: <ProviderOrFamily>[misskeyGetContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          RoomChatProvider.$allTransitiveDependencies0,
          RoomChatProvider.$allTransitiveDependencies1,
        ],
        isAutoDispose: false,
      );

  RoomChatProvider call(String roomId) =>
      RoomChatProvider._(argument: roomId, from: this);

  @override
  String toString() => r'roomChatProvider';
}

abstract class _$RoomChat extends $AsyncNotifier<RoomChatState> {
  late final _$args = ref.$arg as String;
  String get roomId => _$args;

  FutureOr<RoomChatState> build(String roomId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<RoomChatState>, RoomChatState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<RoomChatState>, RoomChatState>,
              AsyncValue<RoomChatState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
