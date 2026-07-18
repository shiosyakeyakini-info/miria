// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_chat.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserChat)
final userChatProvider = UserChatFamily._();

final class UserChatProvider
    extends $AsyncNotifierProvider<UserChat, UserChatState> {
  UserChatProvider._({
    required UserChatFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userChatProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = misskeyGetContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyGetContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$userChatHash();

  @override
  String toString() {
    return r'userChatProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  UserChat create() => UserChat();

  @override
  bool operator ==(Object other) {
    return other is UserChatProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userChatHash() => r'086cd4901b8d57684a49b58d6588033cc2162c21';

final class UserChatFamily extends $Family
    with
        $ClassFamilyOverride<
          UserChat,
          AsyncValue<UserChatState>,
          UserChatState,
          FutureOr<UserChatState>,
          String
        > {
  UserChatFamily._()
    : super(
        retry: null,
        name: r'userChatProvider',
        dependencies: <ProviderOrFamily>[misskeyGetContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          UserChatProvider.$allTransitiveDependencies0,
          UserChatProvider.$allTransitiveDependencies1,
        ],
        isAutoDispose: false,
      );

  UserChatProvider call(String userId) =>
      UserChatProvider._(argument: userId, from: this);

  @override
  String toString() => r'userChatProvider';
}

abstract class _$UserChat extends $AsyncNotifier<UserChatState> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  FutureOr<UserChatState> build(String userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UserChatState>, UserChatState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserChatState>, UserChatState>,
              AsyncValue<UserChatState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
