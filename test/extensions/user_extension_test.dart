import "package:flutter_test/flutter_test.dart";
import "package:miria/extensions/user_extension.dart";

import "../test_util/test_datas.dart";

void main() {
  group("UserDetailedExtension following visibility", () {
    test(
      "isFollowingVisibleForMe returns true when followingVisibility is public",
      () {
        final user = TestData.userWithFollowingVisibilityPublic;

        // followingVisibility is 'public', should return true even though ffVisibility is 'private'
        expect(user.isFollowingVisibleForMe, true);
      },
    );

    test(
      "isFollowingVisibleForMe returns false when followingVisibility is private",
      () {
        final user = TestData.userWithFollowingVisibilityPrivate;

        // followingVisibility is 'private', should return false even though ffVisibility is 'public'
        expect(user.isFollowingVisibleForMe, false);
      },
    );

    test(
      "isFollowingVisibleForMe falls back to ffVisibility when followingVisibility is null",
      () {
        final user = TestData.userWithFollowingVisibilityNull;

        // followingVisibility is null, should fall back to ffVisibility which is 'public'
        expect(user.isFollowingVisibleForMe, true);
      },
    );
  });
}
