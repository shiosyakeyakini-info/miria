import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:misskey_dart/misskey_dart.dart';

class UserDetailedNotifier extends AutoDisposeFamilyAsyncNotifier<
    UsersShowResponse, (Account, String)> {
  @override
  Future<UsersShowResponse> build((Account, String) arg) async {
    final user = await _misskey.users.show(UsersShowRequest(userId: _userId));
    ref.read(notesProvider(_account)).registerAll(user.pinnedNotes ?? []);
    return user;
  }

  Account get _account => arg.$1;

  String get _userId => arg.$2;

  Misskey get _misskey => ref.read(misskeyProvider(_account));

  Future<void> createRenoteMute() async {
    await _misskey.renoteMute.create(RenoteMuteCreateRequest(userId: _userId));
    final user = state.value;
    if (user != null) {
      state = AsyncValue.data(user.copyWith(isRenoteMuted: true));
    }
  }

  Future<void> deleteRenoteMute() async {
    await _misskey.renoteMute.delete(RenoteMuteDeleteRequest(userId: _userId));
    final user = state.value;
    if (user != null) {
      state = AsyncValue.data(user.copyWith(isRenoteMuted: false));
    }
  }

  Future<void> createMute(Duration? duration) async {
    await _misskey.mute.create(
      MuteCreateRequest(
        userId: _userId,
        expiresAt: duration == null ? null : DateTime.now().add(duration),
      ),
    );
    final user = state.value;
    if (user != null) {
      state = AsyncValue.data(user.copyWith(isMuted: true));
    }
  }

  Future<void> deleteMute() async {
    await _misskey.mute.delete(MuteDeleteRequest(userId: _userId));
    final user = state.value;
    if (user != null) {
      state = AsyncValue.data(user.copyWith(isMuted: false));
    }
  }

  Future<void> createBlock() async {
    await _misskey.blocking.create(BlockCreateRequest(userId: _userId));
    final user = state.value;
    if (user != null) {
      state = AsyncValue.data(user.copyWith(isBlocking: true));
    }
  }

  Future<void> deleteBlock() async {
    await _misskey.blocking.delete(BlockDeleteRequest(userId: _userId));
    final user = state.value;
    if (user != null) {
      state = AsyncValue.data(user.copyWith(isBlocking: false));
    }
  }

  Future<void> createFollow() async {
    await _misskey.following.create(FollowingCreateRequest(userId: _userId));
    final user = state.value;
    if (user != null) {
      state = AsyncValue.data(
        user.copyWith(
          isFollowing: !user.isLocked,
          hasPendingFollowRequestFromYou: user.isLocked,
        ),
      );
    }
  }

  Future<void> deleteFollow() async {
    await _misskey.following.delete(FollowingDeleteRequest(userId: _userId));
    final user = state.value;
    if (user != null) {
      state = AsyncValue.data(user.copyWith(isFollowing: false));
    }
  }

  Future<void> cancelFollowRequest() async {
    await _misskey.following.requests
        .cancel(FollowingRequestsCancelRequest(userId: _userId));
    final user = state.value;
    if (user != null) {
      state = AsyncValue.data(
        user.copyWith(hasPendingFollowRequestFromYou: false),
      );
    }
  }

  Future<void> updateMemo(String memo) async {
    await _misskey.users
        .updateMemo(UsersUpdateMemoRequest(userId: _userId, memo: memo));
    final user = state.value;
    if (user != null) {
      state = AsyncValue.data(user.copyWith(memo: memo));
    }
  }
}
