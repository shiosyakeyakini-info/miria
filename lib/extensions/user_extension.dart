import "package:misskey_dart/misskey_dart.dart";

extension UserExtension on User {
  String get acct {
    return "@$username${host != null ? "@$host" : ""}";
  }
}

extension UserDetailedExtension on UserDetailed {
  bool get isFollowersVisibleForMe {
    if (this is MeDetailed) {
      return true;
    }

    final user = this;

    return switch (followersVisibility ?? ffVisibility) {
      FFVisibility.public => true,
      FFVisibility.followers =>
        user is UserDetailedNotMeWithRelations && user.isFollowing,
      FFVisibility.private || FFVisibility.unknown || null => false,
    };
  }

  bool get isFollowingVisibleForMe {
    if (this is MeDetailed) {
      return true;
    }

    final user = this;

    // Check if user has followingVisibility property
    final visibility = switch (user) {
      UserDetailedNotMeWithRelations(:final followingVisibility) =>
        followingVisibility ?? user.ffVisibility,
      UserDetailedNotMe(:final followingVisibility) =>
        followingVisibility ?? user.ffVisibility,
      _ => ffVisibility,
    };

    return switch (visibility) {
      FFVisibility.public => true,
      FFVisibility.followers =>
        user is UserDetailedNotMeWithRelations && user.isFollowing,
      FFVisibility.private || FFVisibility.unknown || null => false,
    };
  }
}
