// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatRoomRepository)
final chatRoomRepositoryProvider = ChatRoomRepositoryProvider._();

final class ChatRoomRepositoryProvider
    extends $NotifierProvider<ChatRoomRepository, void> {
  ChatRoomRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatRoomRepositoryProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          ChatRoomRepositoryProvider.$allTransitiveDependencies0,
          ChatRoomRepositoryProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = misskeyPostContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$chatRoomRepositoryHash();

  @$internal
  @override
  ChatRoomRepository create() => ChatRoomRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$chatRoomRepositoryHash() =>
    r'077cf782a231cb3d64769dc5a155ab2bfb479d6b';

abstract class _$ChatRoomRepository extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
