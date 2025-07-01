import 'package:flutter_test/flutter_test.dart';
import 'package:miria/extensions/user_extension.dart';
import 'package:json5/json5.dart';
import 'package:misskey_dart/misskey_dart.dart';

void main() {
  group('UserDetailedExtension following visibility', () {
    test('isFollowingVisibleForMe returns true when followingVisibility is public', () {
      final user = UserDetailedNotMeWithRelations.fromJson(
        JSON5.parse(r'''
{
  id: 'test_user_id',
  name: 'Test User',
  username: 'testuser',
  host: null,
  avatarUrl: null,
  avatarBlurhash: null,
  isBot: false,
  isCat: false,
  emojis: {},
  onlineStatus: 'unknown',
  badgeRoles: [],
  url: null,
  uri: null,
  movedTo: null,
  alsoKnownAs: null,
  createdAt: '2023-01-01T00:00:00.000Z',
  updatedAt: '2023-01-01T00:00:00.000Z',
  lastFetchedAt: null,
  bannerUrl: null, 
  bannerBlurhash: null,
  isLocked: false,
  isSilenced: false,
  isSuspended: false,
  description: null,
  location: null,
  birthday: null,
  lang: null,
  fields: [],
  followersCount: 100,
  followingCount: 50,
  notesCount: 200,
  pinnedNoteIds: [],
  pinnedNotes: [],
  pinnedPageId: null,
  pinnedPage: null,
  publicReactions: true,
  followingVisibility: 'public',
  followersVisibility: 'public',
  ffVisibility: 'private',
  twoFactorEnabled: false,
  usePasswordLessLogin: false,
  securityKeys: false,
  roles: [],
  memo: null,
  isFollowing: false,
  isFollowed: false,
  hasPendingFollowRequestFromYou: false,
  hasPendingFollowRequestToYou: false,
  isBlocking: false,
  isBlocked: false,
  isMuted: false,
  isRenoteMuted: false
}
        '''),
      );

      // followingVisibility is 'public', should return true even though ffVisibility is 'private'
      expect(user.isFollowingVisibleForMe, true);
    });

    test('isFollowingVisibleForMe returns false when followingVisibility is private', () {
      final user = UserDetailedNotMeWithRelations.fromJson(
        JSON5.parse(r'''
{
  id: 'test_user_id',
  name: 'Test User',
  username: 'testuser',
  host: null,
  avatarUrl: null,
  avatarBlurhash: null,
  isBot: false,
  isCat: false,
  emojis: {},
  onlineStatus: 'unknown',
  badgeRoles: [],
  url: null,
  uri: null,
  movedTo: null,
  alsoKnownAs: null,
  createdAt: '2023-01-01T00:00:00.000Z',
  updatedAt: '2023-01-01T00:00:00.000Z',
  lastFetchedAt: null,
  bannerUrl: null,
  bannerBlurhash: null,
  isLocked: false,
  isSilenced: false,
  isSuspended: false,
  description: null,
  location: null,
  birthday: null,
  lang: null,
  fields: [],
  followersCount: 100,
  followingCount: 50,
  notesCount: 200,
  pinnedNoteIds: [],
  pinnedNotes: [],
  pinnedPageId: null,
  pinnedPage: null,
  publicReactions: true,
  followingVisibility: 'private',
  followersVisibility: 'public',
  ffVisibility: 'public',
  twoFactorEnabled: false,
  usePasswordLessLogin: false,
  securityKeys: false,
  roles: [],
  memo: null,
  isFollowing: true,
  isFollowed: false,
  hasPendingFollowRequestFromYou: false,
  hasPendingFollowRequestToYou: false,
  isBlocking: false,
  isBlocked: false,
  isMuted: false,
  isRenoteMuted: false
}
        '''),
      );

      // followingVisibility is 'private', should return false even though ffVisibility is 'public'
      expect(user.isFollowingVisibleForMe, false);
    });

    test('isFollowingVisibleForMe falls back to ffVisibility when followingVisibility is null', () {
      final user = UserDetailedNotMeWithRelations.fromJson(
        JSON5.parse(r'''
{
  id: 'test_user_id',
  name: 'Test User',
  username: 'testuser',
  host: null,
  avatarUrl: null,
  avatarBlurhash: null,
  isBot: false,
  isCat: false,
  emojis: {},
  onlineStatus: 'unknown',
  badgeRoles: [],
  url: null,
  uri: null,
  movedTo: null,
  alsoKnownAs: null,
  createdAt: '2023-01-01T00:00:00.000Z',
  updatedAt: '2023-01-01T00:00:00.000Z',
  lastFetchedAt: null,
  bannerUrl: null,
  bannerBlurhash: null,
  isLocked: false,
  isSilenced: false,
  isSuspended: false,
  description: null,
  location: null,
  birthday: null,
  lang: null,
  fields: [],
  followersCount: 100,
  followingCount: 50,
  notesCount: 200,
  pinnedNoteIds: [],
  pinnedNotes: [],
  pinnedPageId: null,
  pinnedPage: null,
  publicReactions: true,
  followingVisibility: null,
  followersVisibility: 'public',
  ffVisibility: 'public',
  twoFactorEnabled: false,
  usePasswordLessLogin: false,
  securityKeys: false,
  roles: [],
  memo: null,
  isFollowing: false,
  isFollowed: false,
  hasPendingFollowRequestFromYou: false,
  hasPendingFollowRequestToYou: false,
  isBlocking: false,
  isBlocked: false,
  isMuted: false,
  isRenoteMuted: false
}
        '''),
      );

      // followingVisibility is null, should fall back to ffVisibility which is 'public'
      expect(user.isFollowingVisibleForMe, true);
    });
  });
}