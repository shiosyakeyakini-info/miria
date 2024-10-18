import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/repository/note_repository.dart";
import "package:miria/router/app_router.dart";
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
  }) = _UserInfo;

  const UserInfo._();
}

// Riverpod 3.0ではこのようなことをする必要がないはず
// でもまだ https://github.com/rrousselGit/riverpod/issues/767 の機能がないことに加え、
// https://github.com/rrousselGit/riverpod/issues/2383 のようなこともあるので、
// UserInfoNotifierが直接accountContextにdependenciesを設定したり、引数のデフォルトにしたりすることが現状できない。
@Riverpod(dependencies: [accountContext])
Raw<UserInfoNotifier> userInfoNotifierProxy(
  UserInfoNotifierProxyRef ref,
  String userId,
) {
  return ref.read(
    userInfoNotifierProvider(
      userId: userId,
      context: ref.read(accountContextProvider),
    ).notifier,
  );
}

@Riverpod(dependencies: [accountContext])
AsyncValue<UserInfo> userInfoProxy(UserInfoProxyRef ref, String userId) {
  return ref.watch(
    userInfoNotifierProvider(
      userId: userId,
      context: ref.read(accountContextProvider),
    ),
  );
}

@Riverpod()
class UserInfoNotifier extends _$UserInfoNotifier {
  DialogStateNotifier get _dialog =>
      ref.read(dialogStateNotifierProvider.notifier);

  Misskey get _getMisskey => ref.read(misskeyProvider(context.getAccount));
  Misskey get _postMisskey => ref.read(misskeyProvider(context.postAccount));
  NoteRepository get _noteRepo => ref.read(notesProvider(context.getAccount));

  @override
  Future<UserInfo> build({
    required String userId,
    required AccountContext context,
  }) async {
    final localResponse =
        await _getMisskey.users.show(UsersShowRequest(userId: userId));
    _noteRepo.registerAll(localResponse.pinnedNotes ?? []);

    final remoteHost = localResponse.host;
    final localOnlyState = AsyncData(
      UserInfo(userId: userId, response: localResponse),
    );
    state = localOnlyState;
    if (remoteHost == null) {
      return localOnlyState.value;
    }

    try {
      final meta =
          await ref.read(misskeyWithoutAccountProvider(remoteHost)).meta();
      final remoteResponse = await ref
          .read(misskeyWithoutAccountProvider(remoteHost))
          .users
          .showByName(
            UsersShowByUserNameRequest(userName: localResponse.username),
          );

      await ref
          .read(
            emojiRepositoryProvider(Account.demoAccount(remoteHost, meta)),
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
    } catch (e) {
      return localOnlyState.value;
    }
  }

  Future<AsyncValue<void>> updateMemo(String text) async {
    return await _dialog.guard(() async {
      await _postMisskey.users.updateMemo(
        UsersUpdateMemoRequest(userId: userId, memo: text),
      );

      final before = await future;
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
        ),
      );
    });
  }

  Future<AsyncValue<void>> createFollow() async {
    return await _dialog.guard(() async {
      await _postMisskey.following
          .create(FollowingCreateRequest(userId: userId));

      final before = await future;
      final response = before.response;
      if (response is! UserDetailedNotMeWithRelations) {
        return;
      }

      final requiresFollowRequest = response.isLocked && !response.isFollowed;
      state = AsyncData(
        before.copyWith(
          response: response.copyWith(
            isFollowing: !requiresFollowRequest,
            hasPendingFollowRequestFromYou: requiresFollowRequest,
          ),
        ),
      );
    });
  }

  Future<AsyncValue<void>?> deleteFollow() async {
    final confirm = await _dialog.showDialog(
      message: (context) => S.of(context).confirmUnfollow,
      actions: (context) => [S.of(context).deleteFollow, S.of(context).cancel],
    );
    if (confirm == 1) return null;

    return await _dialog.guard(() async {
      await _postMisskey.following
          .delete(FollowingDeleteRequest(userId: userId));

      final before = await future;
      final response = before.response;
      if (response is! UserDetailedNotMeWithRelations) {
        return;
      }

      state = AsyncData(
        before.copyWith(response: response.copyWith(isFollowing: false)),
      );
    });
  }

  Future<AsyncValue<void>> cancelFollowRequest() async {
    return await _dialog.guard(() async {
      await _postMisskey.following.requests
          .cancel(FollowingRequestsCancelRequest(userId: userId));
      final before = await future;
      final response = before.response;
      if (response is! UserDetailedNotMeWithRelations) {
        return;
      }

      state = AsyncData(
        before.copyWith(
          response: response.copyWith(hasPendingFollowRequestFromYou: false),
        ),
      );
    });
  }

  /// ミュートする
  Future<AsyncValue<void>?> createMute() async {
    final expires = await ref.read(appRouterProvider).push<Expire?>(
          const ExpireSelectRoute(),
        );
    if (expires == null) return null;
    final expiresDate = expires == Expire.indefinite
        ? null
        : DateTime.now().add(expires.expires!);

    return await _dialog.guard(() async {
      await _postMisskey.mute.create(
        MuteCreateRequest(
          userId: userId,
          expiresAt: expiresDate,
        ),
      );

      final before = await future;
      final response = before.response;
      if (response is! UserDetailedNotMeWithRelations) {
        return;
      }

      state = AsyncData(
        before.copyWith(response: response.copyWith(isMuted: true)),
      );
      await ref.read(appRouterProvider).maybePop();
    });
  }

  /// ミュートを解除する
  Future<AsyncValue<void>?> deleteMute() async {
    return await _dialog.guard(() async {
      await _postMisskey.mute.delete(MuteDeleteRequest(userId: userId));
      final before = await future;
      final response = before.response;
      if (response is! UserDetailedNotMeWithRelations) {
        return;
      }

      state = AsyncData(
        before.copyWith(response: response.copyWith(isMuted: false)),
      );
      await ref.read(appRouterProvider).maybePop();
    });
  }

  /// Renoteをミュートする
  Future<AsyncValue<void>> createRenoteMute() async {
    return await _dialog.guard(() async {
      await _postMisskey.renoteMute.create(
        RenoteMuteCreateRequest(userId: userId),
      );
      final before = await future;
      final response = before.response;
      if (response is! UserDetailedNotMeWithRelations) {
        return;
      }

      state = AsyncData(
        before.copyWith(response: response.copyWith(isRenoteMuted: true)),
      );
      await ref.read(appRouterProvider).maybePop();
    });
  }

  /// Renoteのミュートを解除する
  Future<AsyncValue<void>> deleteRenoteMute() async {
    return await _dialog.guard(() async {
      await _postMisskey.renoteMute.delete(
        RenoteMuteDeleteRequest(userId: userId),
      );
      final before = await future;
      final response = before.response;
      if (response is! UserDetailedNotMeWithRelations) {
        return;
      }

      state = AsyncData(
        before.copyWith(response: response.copyWith(isRenoteMuted: false)),
      );
      await ref.read(appRouterProvider).maybePop();
    });
  }

  /// ブロックする
  Future<AsyncValue<void>?> createBlocking() async {
    final confirm = await _dialog.showDialog(
      message: (context) => S.of(context).confirmCreateBlock,
      actions: (context) => [
        S.of(context).createBlock,
        S.of(context).cancel,
      ],
    );
    if (confirm == 1) return null;

    return await _dialog.guard(() async {
      await _postMisskey.blocking.create(BlockCreateRequest(userId: userId));

      final before = await future;
      final response = before.response;
      if (response is! UserDetailedNotMeWithRelations) {
        return;
      }

      state = AsyncData(
        before.copyWith(response: response.copyWith(isBlocking: true)),
      );
      await ref.read(appRouterProvider).maybePop();
    });
  }

  /// ブロックを解除する
  Future<AsyncValue<void>> deleteBlocking() async {
    return await _dialog.guard(() async {
      await _postMisskey.blocking.delete(BlockDeleteRequest(userId: userId));

      final before = await future;
      final response = before.response;
      if (response is! UserDetailedNotMeWithRelations) {
        return;
      }

      state = AsyncData(
        before.copyWith(response: response.copyWith(isBlocking: false)),
      );
      await ref.read(appRouterProvider).maybePop();
    });
  }
}
