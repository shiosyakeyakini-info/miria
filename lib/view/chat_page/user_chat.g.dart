// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_chat.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(UserChat)
const userChatProvider = UserChatFamily._();

final class UserChatProvider
    extends $AsyncNotifierProvider<UserChat, UserChatState> {
  const UserChatProvider._({
    required UserChatFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userChatProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = misskeyGetContextProvider;
  static const $allTransitiveDependencies1 =
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

String _$userChatHash() => r'37c78c1f11dc89e9f4c13c91b2109e1f3d0065f5';

final class UserChatFamily extends $Family
    with
        $ClassFamilyOverride<
          UserChat,
          AsyncValue<UserChatState>,
          UserChatState,
          FutureOr<UserChatState>,
          String
        > {
  const UserChatFamily._()
    : super(
        retry: null,
        name: r'userChatProvider',
        dependencies: const <ProviderOrFamily>[misskeyGetContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
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
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<UserChatState>, UserChatState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserChatState>, UserChatState>,
              AsyncValue<UserChatState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
