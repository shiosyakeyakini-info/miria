// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_chat.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$roomChatHash() => r'6906bac78991676644d4c75f6b5b5bce2dd87994';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$RoomChat extends BuildlessAsyncNotifier<List<ChatMessage>> {
  late final String roomId;

  FutureOr<List<ChatMessage>> build(
    String roomId,
  );
}

/// See also [RoomChat].
@ProviderFor(RoomChat)
const roomChatProvider = RoomChatFamily();

/// See also [RoomChat].
class RoomChatFamily extends Family {
  /// See also [RoomChat].
  const RoomChatFamily();

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    misskeyGetContextProvider
  ];

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    misskeyGetContextProvider,
    ...?misskeyGetContextProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'roomChatProvider';

  /// See also [RoomChat].
  RoomChatProvider call(
    String roomId,
  ) {
    return RoomChatProvider(
      roomId,
    );
  }

  @visibleForOverriding
  @override
  RoomChatProvider getProviderOverride(
    covariant RoomChatProvider provider,
  ) {
    return call(
      provider.roomId,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(RoomChat Function() create) {
    return _$RoomChatFamilyOverride(this, create);
  }
}

class _$RoomChatFamilyOverride implements FamilyOverride {
  _$RoomChatFamilyOverride(this.overriddenFamily, this.create);

  final RoomChat Function() create;

  @override
  final RoomChatFamily overriddenFamily;

  @override
  RoomChatProvider getProviderOverride(
    covariant RoomChatProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [RoomChat].
class RoomChatProvider
    extends AsyncNotifierProviderImpl<RoomChat, List<ChatMessage>> {
  /// See also [RoomChat].
  RoomChatProvider(
    String roomId,
  ) : this._internal(
          () => RoomChat()..roomId = roomId,
          from: roomChatProvider,
          name: r'roomChatProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$roomChatHash,
          dependencies: RoomChatFamily._dependencies,
          allTransitiveDependencies: RoomChatFamily._allTransitiveDependencies,
          roomId: roomId,
        );

  RoomChatProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.roomId,
  }) : super.internal();

  final String roomId;

  @override
  FutureOr<List<ChatMessage>> runNotifierBuild(
    covariant RoomChat notifier,
  ) {
    return notifier.build(
      roomId,
    );
  }

  @override
  Override overrideWith(RoomChat Function() create) {
    return ProviderOverride(
      origin: this,
      override: RoomChatProvider._internal(
        () => create()..roomId = roomId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        roomId: roomId,
      ),
    );
  }

  @override
  (String,) get argument {
    return (roomId,);
  }

  @override
  AsyncNotifierProviderElement<RoomChat, List<ChatMessage>> createElement() {
    return _RoomChatProviderElement(this);
  }

  RoomChatProvider _copyWith(
    RoomChat Function() create,
  ) {
    return RoomChatProvider._internal(
      () => create()..roomId = roomId,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      roomId: roomId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RoomChatProvider && other.roomId == roomId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roomId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RoomChatRef on AsyncNotifierProviderRef<List<ChatMessage>> {
  /// The parameter `roomId` of this provider.
  String get roomId;
}

class _RoomChatProviderElement
    extends AsyncNotifierProviderElement<RoomChat, List<ChatMessage>>
    with RoomChatRef {
  _RoomChatProviderElement(super.provider);

  @override
  String get roomId => (origin as RoomChatProvider).roomId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
