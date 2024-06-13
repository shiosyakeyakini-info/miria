import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/user_page/user_control_dialog.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "user_info_notifier.freezed.dart";
part "user_info_notifier.g.dart";

@freezed
class UserInfo with _$UserInfo {
  const factory UserInfo({
    required String userId,
    required UserDetailed response,
    String? remoteUserId,
    UserDetailed? remoteResponse,
    MetaResponse? metaResponse,

    /// メモの更新中
    AsyncValue<void>? updateMemo,

    /// フォロー操作中
    AsyncValue<void>? follow,

    /// ミュート操作中
    AsyncValue<void>? mute,

    /// リノート操作中
    AsyncValue<void>? renoteMute,

    /// ブロック操作中
    AsyncValue<void>? block,
  }) = _UserInfo;

  const UserInfo._();
}

@riverpod
class UserInfoNotifier extends _$UserInfoNotifier {
  DialogStateNotifier get _dialog =>
      ref.read(dialogStateNotifierProvider.notifier);

  @override
  Future<UserInfo> build(Account account, String userId) async {
    final localResponse = await ref
        .read(misskeyProvider(account))
        .users
        .show(UsersShowRequest(userId: userId));
    ref
        .read(notesProvider(account))
        .registerAll(localResponse.pinnedNotes ?? []);

    final remoteHost = localResponse.host;
    final localOnlyState = AsyncData(
      UserInfo(userId: userId, response: localResponse),
    );
    state = localOnlyState;
    if (remoteHost == null) return localOnlyState.value;

    final meta =
        await ref.read(misskeyWithoutAccountProvider(remoteHost)).meta();
    final remoteResponse = await ref
        .read(misskeyProvider(Account.demoAccount(remoteHost, meta)))
        .users
        .showByName(
          UsersShowByUserNameRequest(userName: localResponse.username),
        );

    await ref
        .read(
          emojiRepositoryProvider(
            Account.demoAccount(remoteHost, meta),
          ),
        )
        .loadFromSourceIfNeed();

    ref
        .read(notesProvider(Account.demoAccount(remoteHost, meta)))
        .registerAll(remoteResponse.pinnedNotes ?? []);

    return UserInfo(
      userId: userId,
      response: localResponse,
      remoteUserId: remoteResponse.id,
      remoteResponse: remoteResponse,
      metaResponse: meta,
    );
  }

  Future<void> updateMemo(String text) async {
    var before = await future;
    state = AsyncData(before.copyWith(updateMemo: const AsyncLoading()));
    final result = await _dialog.guard(
      () async => ref.read(misskeyProvider(account)).users.updateMemo(
            UsersUpdateMemoRequest(userId: userId, memo: text),
          ),
    );
    before = await future;

    state = AsyncData(
      before.copyWith(
        //TODO: こういう使い方するならAPIの結果をsealed classにしてあげたい
        response: switch (before.response) {
          UserDetailedNotMe(:final copyWith) => copyWith(memo: text),
          UserDetailedNotMeWithRelations(:final copyWith) =>
            copyWith(memo: text),
          MeDetailed(:final copyWith) => copyWith(memo: text),
          UserDetailed() => before.response,
        },
        updateMemo: result,
      ),
    );
  }

  Future<void> createFollow() async {
    var before = await future;
    if (before.follow is AsyncLoading) return;

    state = AsyncData(before.copyWith(follow: const AsyncLoading()));
    final result = await _dialog.guard(
      () async => await ref
          .read(misskeyProvider(account))
          .following
          .create(FollowingCreateRequest(userId: userId)),
    );
    before = await future;
    final response = before.response;
    if (response is! UserDetailedNotMeWithRelations) {
      return;
    }

    final requiresFollowRequest = response.isLocked && !response.isFollowed;
    state = AsyncData(
      before.copyWith(
        response: (before.response as UserDetailedNotMeWithRelations).copyWith(
          isFollowing: !requiresFollowRequest,
          hasPendingFollowRequestFromYou: requiresFollowRequest,
        ),
        follow: result,
      ),
    );
  }

  Future<void> deleteFollow() async {
    var before = await future;
    if (before is AsyncLoading) return;
    final confirm = await _dialog.showDialog(
      message: (context) => S.of(context).confirmUnfollow,
      actions: (context) => [S.of(context).deleteFollow, S.of(context).cancel],
    );
    if (confirm == 1) return;
    state = AsyncData(before.copyWith(follow: const AsyncLoading()));

    final result = await _dialog.guard(
      () async => await ref
          .read(misskeyProvider(account))
          .following
          .delete(FollowingDeleteRequest(userId: userId)),
    );
    before = await future;
    final response = before.response;
    if (response is! UserDetailedNotMeWithRelations) {
      return;
    }

    state = AsyncData(
      before.copyWith(
        response: response.copyWith(isFollowed: false),
        follow: result,
      ),
    );
  }

  Future<void> cancelFollowRequest() async {
    var before = await future;
    if (before.follow is AsyncLoading) return;
    state = AsyncData(before.copyWith(follow: const AsyncLoading()));
    final result = await _dialog.guard(
      () async => await ref
          .read(misskeyProvider(account))
          .following
          .requests
          .cancel(FollowingRequestsCancelRequest(userId: userId)),
    );
    before = await future;
    final response = before.response;
    if (response is! UserDetailedNotMeWithRelations) {
      return;
    }

    state = AsyncData(
      before.copyWith(
        response: response.copyWith(hasPendingFollowRequestFromYou: false),
        follow: result,
      ),
    );
  }

  Future<void> createMute(Expire expires) async {
    var before = await future;
    if (before.mute is AsyncLoading) return;
    state = AsyncData(before.copyWith(mute: const AsyncLoading()));
    final expiresDate = expires == Expire.indefinite
        ? null
        : DateTime.now().add(expires.expires!);

    final result = await _dialog.guard(
      () async => await ref.read(misskeyProvider(account)).mute.create(
            MuteCreateRequest(
              userId: userId,
              expiresAt: expiresDate,
            ),
          ),
    );
    before = await future;
    final response = before.response;
    if (response is! UserDetailedNotMeWithRelations) {
      return;
    }

    state = AsyncData(
      before.copyWith(
        response: response.copyWith(isMuted: true),
        mute: result,
      ),
    );
  }

  Future<void> deleteMute() async {
    var before = await future;
    if (before.mute is AsyncLoading) return;
    state = AsyncData(before.copyWith(mute: const AsyncLoading()));

    final result = await _dialog.guard(
      () async => await ref
          .read(misskeyProvider(account))
          .mute
          .delete(MuteDeleteRequest(userId: userId)),
    );
    before = await future;
    final response = before.response;
    if (response is! UserDetailedNotMeWithRelations) {
      return;
    }

    state = AsyncData(
      before.copyWith(
        response: response.copyWith(isMuted: false),
        mute: result,
      ),
    );
  }

  Future<void> createRenoteMute() async {
    var before = await future;
    if (before.renoteMute is AsyncLoading) return;
    state = AsyncData(before.copyWith(renoteMute: const AsyncLoading()));

    final result = await _dialog.guard(
      () async => await ref.read(misskeyProvider(account)).renoteMute.create(
            RenoteMuteCreateRequest(userId: userId),
          ),
    );
    before = await future;
    final response = before.response;
    if (response is! UserDetailedNotMeWithRelations) {
      return;
    }

    state = AsyncData(
      before.copyWith(
        response: response.copyWith(isRenoteMuted: true),
        mute: result,
      ),
    );
  }

  Future<void> deleteRenoteMute() async {
    var before = await future;
    if (before.renoteMute is AsyncLoading) return;
    state = AsyncData(before.copyWith(renoteMute: const AsyncLoading()));

    final result = await _dialog.guard(
      () async => await ref.read(misskeyProvider(account)).renoteMute.delete(
            RenoteMuteDeleteRequest(userId: userId),
          ),
    );
    before = await future;
    final response = before.response;
    if (response is! UserDetailedNotMeWithRelations) {
      return;
    }

    state = AsyncData(
      before.copyWith(
        response: response.copyWith(isRenoteMuted: false),
        mute: result,
      ),
    );
  }

  Future<void> createBlock() async {
    var before = await future;
    if (before.block is AsyncLoading) return;

    final confirm = await _dialog.showDialog(
      message: (context) => S.of(context).confirmCreateBlock,
      actions: (context) => [
        S.of(context).createBlock,
        S.of(context).cancel,
      ],
    );
    if (confirm == 1) return;

    final result = await _dialog.guard(
      () async => await ref
          .read(misskeyProvider(account))
          .blocking
          .create(BlockCreateRequest(userId: userId)),
    );
    before = await future;
    final response = before.response;
    if (response is! UserDetailedNotMeWithRelations) {
      return;
    }

    state = AsyncData(
      before.copyWith(
        response: response.copyWith(isBlocking: true),
        block: result,
      ),
    );
  }

  Future<void> deleteBlock() async {
    var before = await future;
    if (before.block is AsyncLoading) return;

    final result = await _dialog.guard(
      () async => await ref
          .read(misskeyProvider(account))
          .blocking
          .delete(BlockDeleteRequest(userId: userId)),
    );
    before = await future;
    final response = before.response;
    if (response is! UserDetailedNotMeWithRelations) {
      return;
    }

    state = AsyncData(
      before.copyWith(
        response: response.copyWith(isBlocking: false),
        block: result,
      ),
    );
  }
}
