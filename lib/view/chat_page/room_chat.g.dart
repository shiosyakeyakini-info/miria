// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_chat.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(RoomChat)
const roomChatProvider = RoomChatFamily._();

final class RoomChatProvider
    extends $AsyncNotifierProvider<RoomChat, RoomChatState> {
  const RoomChatProvider._({
    required RoomChatFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'roomChatProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = misskeyGetContextProvider;
  static const $allTransitiveDependencies1 =
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

String _$roomChatHash() => r'9463f85ca8de0cd15ebd09c39bd36e50052fb47b';

final class RoomChatFamily extends $Family
    with
        $ClassFamilyOverride<
          RoomChat,
          AsyncValue<RoomChatState>,
          RoomChatState,
          FutureOr<RoomChatState>,
          String
        > {
  const RoomChatFamily._()
    : super(
        retry: null,
        name: r'roomChatProvider',
        dependencies: const <ProviderOrFamily>[misskeyGetContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
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
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<RoomChatState>, RoomChatState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<RoomChatState>, RoomChatState>,
              AsyncValue<RoomChatState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
