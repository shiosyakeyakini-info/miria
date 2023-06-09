import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/misskey_emoji_data.dart';
import 'package:miria/repository/emoji_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:json5/json5.dart';

class TestData {
  static Account account =
      Account(host: "example.miria.shiosyakeyakini.info", userId: "ai", i: i1);

  // i
  static IResponse i1 = IResponse.fromJson(JSON5.parse(r"""
{
  id: '7rkr3b1c1c',
  name: '藍',
  username: 'ai',
  host: null,
  avatarUrl: 'https://nos3.arkjp.net/avatar.webp?url=https%3A%2F%2Fs3.arkjp.net%2Fmisskey%2Fwebpublic-ecc1008f-3e2e-4206-ae7e-5093221f08be.png&avatar=1',
  avatarBlurhash: null,
  isBot: true,
  isCat: true,
  emojis: {},
  onlineStatus: 'online',
  badgeRoles: [],
  url: null,
  uri: null,
  movedTo: null,
  alsoKnownAs: null,
  createdAt: '2019-04-14T17:11:39.168Z',
  updatedAt: '2023-06-18T09:07:08.676Z',
  lastFetchedAt: null,
  bannerUrl: null,
  bannerBlurhash: null,
  isLocked: false,
  isSilenced: false,
  isSuspended: false,
  description: 'Misskey常駐AIの藍です！\nよろしくお願いします♪\n\n[私のサイト](https://xn--931a.moe/) | [説明書](https://github.com/syuilo/ai/blob/master/torisetu.md)\n\nRepository: [Public](https://github.com/syuilo/ai)',
  location: 'Misskey',
  birthday: '2018-03-12',
  lang: null,
  fields: [],
  followersCount: 10044,
  followingCount: 923,
  notesCount: 63713,
  pinnedNoteIds: [],
  pinnedNotes: [],
  pinnedPageId: '7uz2kemwz7',
  pinnedPage: {
    id: '7uz2kemwz7',
    createdAt: '2019-07-09T07:40:46.232Z',
    updatedAt: '2019-07-09T08:13:21.048Z',
    userId: '7rkr3b1c1c',
    user: {
      id: '7rkr3b1c1c',
      name: '藍',
      username: 'ai',
      host: null,
      avatarUrl: 'https://nos3.arkjp.net/avatar.webp?url=https%3A%2F%2Fs3.arkjp.net%2Fmisskey%2Fwebpublic-ecc1008f-3e2e-4206-ae7e-5093221f08be.png&avatar=1',
      avatarBlurhash: null,
      isBot: true,
      isCat: true,
      emojis: {},
      onlineStatus: 'online',
      badgeRoles: [],
    },
    content: [
      {
        id: 'b6faa1ad-c38a-41df-b8fb-c1c486c40b6c',
        var: null,
        text: '私とリバーシで遊ぶ',
        type: 'button',
        event: 'inviteReversi',
        action: 'pushEvent',
        content: null,
        message: '招待を送信しましたよ～',
        primary: true,
      },
    ],
    variables: [],
    title: 'コントロールパネル',
    name: 'cp',
    summary: null,
    hideTitleWhenPinned: true,
    alignCenter: true,
    font: 'sans-serif',
    script: '',
    eyeCatchingImageId: null,
    eyeCatchingImage: null,
    attachedFiles: [],
    likedCount: 10,
    isLiked: false,
  },
  publicReactions: true,
  ffVisibility: 'public',
  twoFactorEnabled: false,
  usePasswordLessLogin: false,
  securityKeys: false,
  roles: [
    {
      id: '9ablrt3x4q',
      name: '5年生',
      color: null,
      iconUrl: null,
      description: 'Misskey.ioを使い始めて4年経過\nドライブの容量が18GBに',
      isModerator: false,
      isAdministrator: false,
      displayOrder: 0,
    },
  ],
  memo: null,
  avatarId: '9daib14i0n',
  bannerId: null,
  isModerator: false,
  isAdmin: false,
  injectFeaturedNote: true,
  receiveAnnouncementEmail: true,
  alwaysMarkNsfw: false,
  autoSensitive: false,
  carefulBot: false,
  autoAcceptFollowed: true,
  noCrawle: false,
  preventAiLearning: true,
  isExplorable: true,
  isDeleted: false,
  hideOnlineStatus: false,
  hasUnreadSpecifiedNotes: false,
  hasUnreadMentions: true,
  hasUnreadAnnouncement: false,
  hasUnreadAntenna: false,
  hasUnreadChannel: false,
  hasUnreadNotification: false,
  hasPendingReceivedFollowRequest: false,
  mutedWords: [],
  mutedInstances: [],
  mutingNotificationTypes: [],
  emailNotificationTypes: [],
  achievements: [
    {
      name: 'profileFilled',
      unlockedAt: 1677997663681,
    },
    {
      name: 'notes1',
      unlockedAt: 1677997809183,
    },
    {
      name: 'following1',
      unlockedAt: 1677998411734,
    },
    {
      name: 'notes10',
      unlockedAt: 1678000046923,
    },
    {
      name: 'followers1',
      unlockedAt: 1678000047369,
    },
    {
      name: 'client30min',
      unlockedAt: 1678000425238,
    },
    {
      name: 'noteDeletedWithin1min',
      unlockedAt: 1678006086467,
    },
    {
      name: 'markedAsCat',
      unlockedAt: 1678007404127,
    },
    {
      name: 'myNoteFavorited1',
      unlockedAt: 1678046566031,
    },
    {
      name: 'notes100',
      unlockedAt: 1678056770606,
    },
    {
      name: 'login3',
      unlockedAt: 1678158483645,
    },
    {
      name: 'followers10',
      unlockedAt: 1678164920521,
    },
    {
      name: 'justPlainLucky',
      unlockedAt: 1678197492040,
    },
    {
      name: 'postedAtLateNight',
      unlockedAt: 1678208168178,
    },
    {
      name: 'notes500',
      unlockedAt: 1678462799750,
    },
    {
      name: 'login7',
      unlockedAt: 1678493208768,
    },
    {
      name: 'cookieClicked',
      unlockedAt: 1678728772558,
    },
    {
      name: 'setNameToSyuilo',
      unlockedAt: 1678874929956,
    },
    {
      name: 'following10',
      unlockedAt: 1679161251123,
    },
    {
      name: 'login15',
      unlockedAt: 1679184043190,
    },
    {
      name: 'viewAchievements3min',
      unlockedAt: 1679372673841,
    },
    {
      name: 'noteFavorited1',
      unlockedAt: 1679397225817,
    },
    {
      name: 'foundTreasure',
      unlockedAt: 1679403516530,
    },
    {
      name: 'viewInstanceChart',
      unlockedAt: 1679403534059,
    },
    {
      name: 'notes1000',
      unlockedAt: 1679523232889,
    },
    {
      name: 'clickedClickHere',
      unlockedAt: 1679608162658,
    },
    {
      name: 'followers50',
      unlockedAt: 1679647726001,
    },
    {
      name: 'noteClipped1',
      unlockedAt: 1679753557164,
    },
    {
      name: 'open3windows',
      unlockedAt: 1679825038902,
    },
    {
      name: 'login30',
      unlockedAt: 1680481495564,
    },
    {
      name: 'collectAchievements30',
      unlockedAt: 1680481496059,
    },
    {
      name: 'selfQuote',
      unlockedAt: 1680753122971,
    },
    {
      name: 'followers100',
      unlockedAt: 1681737681046,
    },
    {
      name: 'following50',
      unlockedAt: 1682048324638,
    },
    {
      name: 'postedAt0min0sec',
      unlockedAt: 1682373600789,
    },
    {
      name: 'login60',
      unlockedAt: 1683073668394,
    },
    {
      name: 'client60min',
      unlockedAt: 1683753050911,
    },
    {
      name: 'iLoveMisskey',
      unlockedAt: 1684281873048,
    },
    {
      name: 'notes5000',
      unlockedAt: 1685754168611,
    },
    {
      name: 'login100',
      unlockedAt: 1686540317625,
    },
    {
      name: 'loggedInOnBirthday',
      unlockedAt: 1686962479605,
    },
    {
      name: 'following100',
      unlockedAt: 1687071751035,
    },
  ],
  loggedInDays: 106,
  policies: {
    gtlAvailable: true,
    ltlAvailable: true,
    canPublicNote: true,
    canInvite: false,
    canManageCustomEmojis: false,
    canSearchNotes: true,
    canHideAds: true,
    driveCapacityMb: 51200,
    alwaysMarkNsfw: false,
    pinLimit: 10,
    antennaLimit: 20,
    wordMuteLimit: 500,
    webhookLimit: 10,
    clipLimit: 50,
    noteEachClipsLimit: 200,
    userListLimit: 20,
    userEachUserListsLimit: 100,
    rateLimitFactor: 1.5,
  },
  email: 'ai@example.com',
  emailVerified: true,
  securityKeysList: [],
}

"""));

  // note
  static Note note1 = Note.fromJson(JSON5.parse(r'''
{
  id: '9g3rcngj3e',
  createdAt: '2023-06-17T16:08:52.675Z',
  userId: '7rkr3b1c1c',
  user: {
    id: '7rkr3b1c1c',
    name: '藍',
    username: 'ai',
    host: null,
    avatarUrl: 'https://nos3.arkjp.net/avatar.webp?url=https%3A%2F%2Fs3.arkjp.net%2Fmisskey%2Fwebpublic-ecc1008f-3e2e-4206-ae7e-5093221f08be.png&avatar=1',
    avatarBlurhash: null,
    isBot: true,
    isCat: true,
    emojis: {},
    onlineStatus: 'online',
    badgeRoles: [],
  },
  text: '気づいたら、健康保険証っぽいプラズマ化したつまようじの賞味期限が切れてました…',
  cw: null,
  visibility: 'public',
  localOnly: false,
  reactionAcceptance: null,
  renoteCount: 2,
  repliesCount: 0,
  reactions: {
    '❤': 1,
    ':aane@.:': 1,
    ':tsuyoi@.:': 2,
    ':thinkhappy@.:': 9,
    ':mareniyokuaru@.:': 2,
    ':sonnakotoarunda@.:': 1,
    ':hontou_ni_tabete_simattanoka@.:': 2,
  },
  reactionEmojis: {},
  fileIds: [],
  files: [],
  replyId: null,
  renoteId: null,
}  
  
  '''));
  static String note1ExpectText = "気づいたら、健康保険証っぽいプラズマ化したつまようじの賞味期限が切れてました…";
  static String note1ExpectId = "9g3rcngj3e";

  static Note note2 = Note.fromJson(JSON5.parse(r'''
{
  id: '9g4rtxu236',
  createdAt: '2023-06-18T09:10:05.450Z',
  userId: '7rkr3b1c1c',
  user: {
    id: '7rkr3b1c1c',
    name: '藍',
    username: 'ai',
    host: null,
    avatarUrl: 'https://nos3.arkjp.net/avatar.webp?url=https%3A%2F%2Fs3.arkjp.net%2Fmisskey%2Fwebpublic-ecc1008f-3e2e-4206-ae7e-5093221f08be.png&avatar=1',
    avatarBlurhash: null,
    isBot: true,
    isCat: true,
    emojis: {},
    onlineStatus: 'online',
    badgeRoles: [],
  },
  text: 'みにゃさん、数取りゲームしましょう！\n0~100の中で最も大きい数字を取った人が勝ちです。他の人と被ったらだめですよ～\n制限時間は10分です。数字はこの投稿にリプライで送ってくださいね！',
  cw: null,
  visibility: 'public',
  localOnly: false,
  reactionAcceptance: null,
  renoteCount: 0,
  repliesCount: 35,
  reactions: {
    ':tondemonee_mattetanda@.:': 3,
    ':taisen_yorosiku_onegaisimasu@.:': 1,
    ':tatakau_riyuu_ha_mitukatta_ka__q@.:': 2,
  },
  reactionEmojis: {},
  fileIds: [],
  files: [],
  replyId: null,
  renoteId: null,
}  
  '''));
  static String note2ExpectText =
      "みにゃさん、数取りゲームしましょう！\n0~100の中で最も大きい数字を取った人が勝ちです。他の人と被ったらだめですよ～\n制限時間は10分です。数字はこの投稿にリプライで送ってくださいね！";

  static Note note3AsAnotherUser = Note.fromJson(JSON5.parse(r'''
{
  id: '9g2ja0y8ix',
  createdAt: '2023-06-16T19:35:07.088Z',
  userId: '7z9zua5kyv',
  user: {
    id: '7z9zua5kyv',
    name: 'おいしいBot',
    username: 'oishiibot',
    host: null,
    avatarUrl: 'https://nos3.arkjp.net/avatar.webp?url=https%3A%2F%2Fs3.arkjp.net%2Fmisskey%2Fwebpublic-d67529a5-4b8b-4e76-b827-7fcbb57956b6.png&avatar=1',
    avatarBlurhash: null,
    isBot: true,
    isCat: false,
    emojis: {},
    onlineStatus: 'online',
    badgeRoles: [],
  },
  text: 'ﾑﾋﾋﾋﾋﾋｮﾋｮﾋｮﾋｮおいしい',
  cw: null,
  visibility: 'public',
  localOnly: false,
  reactionAcceptance: null,
  renoteCount: 2,
  repliesCount: 0,
  reactions: {
    '❤': 1,
    ':kisei@.:': 1,
    ':kuruu@.:': 2,
    ':wheeze@.:': 2,
    ':kusa_wwwwww@.:': 10,
    ':naxanikorexe@.:': 4,
    ':naxanikorexe@fedibird.com:': 1,
  },
  reactionEmojis: {
    'naxanikorexe@fedibird.com': 'https://s3.arkjp.net/misskey/f5d9e5ca-700d-4a9f-aaad-a45efc4a4486.png',
  },
  fileIds: [],
  files: [],
  replyId: null,
  renoteId: null,
}  
  '''));

  static String note3ExpectUserName = "@oishiibot";

  // ドライブ（フォルダ）
  static DriveFolder folder1 = DriveFolder.fromJson(JSON5.parse(r'''
  {
    id: '9ettn0mv95',
    createdAt: '2023-05-16T12:35:31.447Z',
    name: '秘蔵の藍ちゃんフォルダ',
    parentId: null,
  }'''));

  static DriveFolder folder1Child = DriveFolder.fromJson(JSON5.parse(r'''
  {
    id: '9ettn0mv95',
    createdAt: '2023-05-16T12:35:31.447Z',
    name: 'えっちなやつ',
    parentId: '9ettn0mv95',
  }'''));

  // ドライブ（ファイル）
  static DriveFile drive1 = DriveFile.fromJson(JSON5.parse(r'''
{
    id: '9g6yuyisp3',
    createdAt: '2023-06-19T22:02:22.660Z',
    name: 'maze.png',
    type: 'image/png',
    md5: 'c2585a2f9c286c3ee1cb07b6a1041b58',
    size: 85317,
    isSensitive: false,
    blurhash: 'e172_xti05ti05t$kAV]azaz05ag%]afyStiazazfjV]05azylagy8',
    properties: {
      width: 4096,
      height: 4096,
    },
    url: 'https://s3.arkjp.net/misskey/webpublic-5efa067b-f0f6-4e9c-afbf-25a6140b6c6a.png',
    thumbnailUrl: 'https://s3.arkjp.net/misskey/thumbnail-db8c0a1d-ba8c-4ea2-bbf1-be1e8f021605.webp',
    comment: null,
    folderId: null,
    folder: null,
    userId: null,
    user: null,
  }  
  '''));

  static DriveFile drive2AsVideo = DriveFile.fromJson(JSON5.parse(r'''
{
  id: '9g0kvlw8d3',
  createdAt: '2023-06-15T10:44:21.272Z',
  name: 'RPReplay_Final1686825395.mp4',
  type: 'video/mp4',
  md5: '9e1df6b1e79796e4e4b58fbf804a9f40',
  size: 11400289,
  isSensitive: false,
  blurhash: null,
  properties: {},
  url: 'https://s3.arkjp.net/misskey/e5d2aaea-6c64-4d07-b8c2-2708a955a606.mp4',
  thumbnailUrl: 'https://s3.arkjp.net/misskey/thumbnail-be640464-688f-46ef-90b6-8bbba80e73cb.webp',
  comment: null,
  folderId: null,
  folder: null,
  userId: null,
  user: null,
}
  '''));

  static Future<Uint8List> get binaryImage async => Uint8List.fromList(
      (await rootBundle.load("assets/images/icon.png")).buffer.asUint8List());

  static Future<Response<Uint8List>> get binaryImageResponse async => Response(
      requestOptions: RequestOptions(),
      statusCode: 200,
      data: await binaryImage);

  // ユーザー情報
  static User user1 = User.fromJson(JSON5.parse(r'''
{
  id: '7rkr3b1c1c',
  name: '藍',
  username: 'ai',
  host: null,
  avatarUrl: 'https://nos3.arkjp.net/avatar.webp?url=https%3A%2F%2Fs3.arkjp.net%2Fmisskey%2Fwebpublic-ecc1008f-3e2e-4206-ae7e-5093221f08be.png&avatar=1',
  avatarBlurhash: null,
  isBot: true,
  isCat: true,
  emojis: {},
  onlineStatus: 'online',
  badgeRoles: [],
}'''));
  static String user1ExpectId = "7rkr3b1c1c";

  static User detailedUser1 = User.fromJson(JSON5.parse(r'''
{
  id: '7z9zua5kyv',
  name: 'おいしいBot',
  username: 'oishiibot',
  host: null,
  avatarUrl: 'https://nos3.arkjp.net/avatar.webp?url=https%3A%2F%2Fs3.arkjp.net%2Fmisskey%2Fwebpublic-d67529a5-4b8b-4e76-b827-7fcbb57956b6.png&avatar=1',
  avatarBlurhash: null,
  isBot: true,
  isCat: false,
  emojis: {},
  onlineStatus: 'online',
  badgeRoles: [],
  url: null,
  uri: null,
  movedTo: null,
  alsoKnownAs: null,
  createdAt: '2019-10-25T17:48:45.416Z',
  updatedAt: '2023-06-24T10:02:49.412Z',
  lastFetchedAt: null,
  bannerUrl: null,
  bannerBlurhash: null,
  isLocked: false,
  isSilenced: false,
  isSuspended: false,
  description: 'このアカウントはホームTLを見て、美味しそうなものを記憶します。\n\nTLから覚えさせる場合、このアカウントをフォローしてください。\nフォローが返ってきたら、解除しても構いません。\n\nBot属性がついたアカウントに反応しません。\nチャットも反応しません。\n\n消してほしいものがあれば @kabo まで\nお別れは /unfollow で\n\nお知らせまとめ https://misskey.io/clips/8hknysdjeu\n\n編集:2022/08/27',
  location: null,
  birthday: null,
  lang: null,
  fields: [
    {
      name: 'オーナー',
      value: '@kabo@misskey.io , @AureoleArk@misskey.io',
    },
    {
      name: '詳しい使い方',
      value: 'https://misskey.io/@oishiibot/pages/about',
    },
    {
      name: 'Hosted by',
      value: '@AureoleArk@misskey.io',
    },
    {
      name: 'リポジトリ',
      value: 'https://github.com/kabo2468/oishii-bot',
    },
  ],
  followersCount: 3799,
  followingCount: 3699,
  notesCount: 59659,
  pinnedNoteIds: [],
  pinnedNotes: [],
  pinnedPageId: '7zcd5e96mp',
  pinnedPage: {
    id: '7zcd5e96mp',
    createdAt: '2019-10-27T09:36:51.306Z',
    updatedAt: '2020-02-15T07:13:58.312Z',
    userId: '7z9zua5kyv',
    user: {
      id: '7z9zua5kyv',
      name: 'おいしいBot',
      username: 'oishiibot',
      host: null,
      avatarUrl: 'https://nos3.arkjp.net/avatar.webp?url=https%3A%2F%2Fs3.arkjp.net%2Fmisskey%2Fwebpublic-d67529a5-4b8b-4e76-b827-7fcbb57956b6.png&avatar=1',
      avatarBlurhash: null,
      isBot: true,
      isCat: false,
      emojis: {},
      onlineStatus: 'online',
      badgeRoles: [],
    },
    content: [
      {
        id: 'b493be43-4e13-4080-90fb-f2fb1a02abfa',
        text: 'このアカウントに`美味しいものは何？`とリプライを送ると、返事が帰ってきます。\n他には、`〇〇は美味しいよ`を送ると学習させることが出来ます。\n`〇〇って美味しい？`と聞くと美味しいかどうか判断します。\n\n`お腹空いた`とリプライを送ると、おすすめの食べ物を教えます。\n\n`みんなの美味しいものは何？`とリプライを送ると、ユーザーが教えたものから美味しいものを返します。\n\n`@ピザ`とリプライを送ると、ピザのサイトを返します。\nTLに`@ピザ`と投稿しても返します。\nTLの場合、他のインスタンスのユーザーは、このアカウントをフォローしてください。\n\n`お寿司握って`とリプライを送ると、お寿司を握ってくれます。\n\n`食べ物頂戴`とリプライを送ると、食べ物を作ってくれます。\n\n// バレンタインデーを過ぎたので、チョコをあげたり受け取ったりすることはできません\nバレンタインデーの機能で、\n`チョコちょうだい！`や`チョコあげる！`でチョコをあげたり受け取ったりすることができます。',
        type: 'text',
      },
      {
        id: '4a1562d1-6a05-4735-8e98-620d543d8886',
        type: 'section',
        title: '正規表現',
        children: [
          {
            id: 'ccbb7bd8-fe1e-44fa-a190-5124122b5624',
            text: '```\n[Adjective] = ((おい|美味)し|(まず|マズ|不味)く(な|にゃ)|うま|旨)い|(まず|マズ|不味|(おい|美味)しく(な|にゃ)|(うま|旨)く(な|にゃ))い\n検索\n/(みん(な|にゃ)の)?([Adjective])(もの|物|の)は?(何|(な|にゃ)に)?[？?]*/\n判断\n/(.+)(は|って)([Adjective])[？?]+/\n学習\n/(.+)[はも]([Adjective])よ?[！!]*/\n```',
            type: 'text',
          },
          {
            id: 'fc97974e-64d4-4d1b-b4f8-68450e4644bc',
            text: 'お腹空いた機能\n```\n/お?(腹|(な|にゃ)か|はら)([空すあ]い|([減へ][っり]))た?[！!]*/\n```',
            type: 'text',
          },
          {
            id: '4d79791e-ced6-4f51-836d-54700861b03b',
            text: '@ピザ機能\n```\nリプライ時\n/\\s*[@＠]?(ピザ|ぴざ)\\s*/\nTL時　\n/^[@＠](ピザ|ぴざ)$/\n```',
            type: 'text',
          },
          {
            id: '6dd37515-6f69-4396-b33f-1d3d59dacde9',
            text: '寿司機能\n```\n/^\\s*お?(寿司|すし)を?(握|にぎ)(って|れ)/\n```',
            type: 'text',
          },
          {
            id: '7c9c11ae-6907-4ecf-9295-9e58423bbe2e',
            text: '食べ物機能\n```\n/^\\s*((何|(な|にゃ)に|(な|にゃ)ん)か)?[食た]べる?(物|もの)(くれ|ちょうだい|頂戴|ください)/\n```',
            type: 'text',
          },
        ],
      },
      {
        id: '1ca26baa-4ea5-449a-afe8-a06df802bf8f',
        type: 'section',
        title: 'コマンド',
        children: [
          {
            id: 'b0c92622-d725-4c93-8e4a-329818ee6752',
            text: '```\n/help: コマンドリストを表示する。\n/ping: 生存確認する。\n/info: (今のところは)DBのレコード数を表示する。\n/say: なにか言わせる。(オーナーのみ)\n/follow: フォローする。\n/unfollow: フォローを解除する。\n/delete: 削除する。（オーナーのみ）\n/chart: DBのレコード数をチャートにする。（オーナーのみ）\n```',
            type: 'text',
          },
        ],
      },
      {
        id: '170cb06a-1dc7-4939-bafe-3dc2ce4baf31',
        text: '最終更新: 2020/02/15',
        type: 'text',
      },
    ],
    variables: [],
    title: '説明',
    name: 'about',
    summary: null,
    hideTitleWhenPinned: false,
    alignCenter: false,
    font: 'sans-serif',
    script: '',
    eyeCatchingImageId: null,
    eyeCatchingImage: null,
    attachedFiles: [],
    likedCount: 8,
    isLiked: false,
  },
  publicReactions: false,
  ffVisibility: 'public',
  twoFactorEnabled: false,
  usePasswordLessLogin: false,
  securityKeys: false,
  roles: [
    {
      id: '9ablrbdi3h',
      name: '4年生',
      color: null,
      iconUrl: null,
      description: 'Misskey.ioを使い始めて3年経過\nドライブの容量が16GBに',
      isModerator: false,
      isAdministrator: false,
      displayOrder: 0,
    },
  ],
  memo: null,
  isFollowing: false,
  isFollowed: false,
  hasPendingFollowRequestFromYou: false,
  hasPendingFollowRequestToYou: false,
  isBlocking: false,
  isBlocked: false,
  isMuted: false,
  isRenoteMuted: false,
}  '''));

  static User detailedUser2 = User.fromJson(JSON5.parse(r'''
{
  id: '9gbzuv2cze',
  name: '藍ちゃんにおじさん構文でメンションを送るbot',
  username: 'ojichat_to_ai',
  host: 'misskey.04.si',
  avatarUrl: 'https://misskey.io/identicon/ojichat_to_ai@misskey.04.si',
  avatarBlurhash: null,
  isBot: true,
  isCat: false,
  instance: {
    name: 'りんごぱい',
    softwareName: 'misskey',
    softwareVersion: '13.13.2-pie.1',
    iconUrl: 'https://misskey.04.si/static-assets/icons/192.png',
    faviconUrl: 'https://04.si/favicons/icon-512x512.png',
    themeColor: '#eb349b',
  },
  emojis: {},
  onlineStatus: 'unknown',
  url: 'https://misskey.04.si/@ojichat_to_ai',
  uri: 'https://misskey.04.si/users/9gbzf7dzzl',
  movedTo: null,
  alsoKnownAs: null,
  createdAt: '2023-06-23T10:29:08.676Z',
  updatedAt: '2023-06-23T10:29:11.609Z',
  lastFetchedAt: '2023-06-23T10:29:08.676Z',
  bannerUrl: null,
  bannerBlurhash: null,
  isLocked: false,
  isSilenced: false,
  isSuspended: false,
  description: '名前の通り。返信機能などはありません。\n文章はojichatで生成しています。\n管理者: @grj1234@misskey.04.si\nPC起動時のみ運用するため、かなりの頻度で停止します。',
  location: '藍ちゃんの隣',
  birthday: null,
  lang: null,
  fields: [
    {
      name: '管理者',
      value: '@grj1234',
    },
  ],
  followersCount: 0,
  followingCount: 0,
  notesCount: 1,
  pinnedNoteIds: [
    '9gbzomafzn',
  ],
  pinnedNotes: [
    {
      id: '9gbzomafzn',
      createdAt: '2023-06-23T10:24:17.367Z',
      userId: '9gbzuv2cze',
      user: {
        id: '9gbzuv2cze',
        name: '藍ちゃんにおじさん構文でメンションを送るbot',
        username: 'ojichat_to_ai',
        host: 'misskey.04.si',
        avatarUrl: 'https://misskey.io/identicon/ojichat_to_ai@misskey.04.si',
        avatarBlurhash: null,
        isBot: true,
        isCat: false,
        instance: {
          name: 'りんごぱい',
          softwareName: 'misskey',
          softwareVersion: '13.13.2-pie.1',
          iconUrl: 'https://misskey.04.si/static-assets/icons/192.png',
          faviconUrl: 'https://04.si/favicons/icon-512x512.png',
          themeColor: '#eb349b',
        },
        emojis: {},
        onlineStatus: 'unknown',
      },
      text: '[手動] どんなアイコンを設定すれば良いか悩んでいます。是非とも皆さんのご意見をお聞きしたいと思います。',
      cw: null,
      visibility: 'public',
      localOnly: false,
      reactionAcceptance: null,
      renoteCount: 0,
      repliesCount: 0,
      reactions: {},
      reactionEmojis: {},
      emojis: {},
      fileIds: [],
      files: [],
      replyId: null,
      renoteId: null,
      uri: 'https://misskey.04.si/notes/9gbzomaf1o',
    },
  ],
  pinnedPageId: null,
  pinnedPage: null,
  publicReactions: true,
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
  isRenoteMuted: false,
}'''));

  static String detailedUser2ExpectedId = "9gbzuv2cze";

  // カスタム絵文字
  static UnicodeEmojiData unicodeEmoji1 = const UnicodeEmojiData(char: "♥");
  static CustomEmojiData customEmoji1 = CustomEmojiData(
      baseName: "ai_yay",
      hostedName: "misskey.io",
      url: Uri.parse("https://s3.arkjp.net/emoji/ai_yay.apng"),
      isCurrentServer: true,
      isSensitive: false);

  static EmojiRepositoryData unicodeEmojiRepositoryData1 = EmojiRepositoryData(
      emoji: unicodeEmoji1,
      category: "symbols",
      kanaName: "へあt",
      aliases: ["heart", "ハート"],
      kanaAliases: ["へあt", "ハート"]);

  static EmojiRepositoryData customEmojiRepositoryData1 = EmojiRepositoryData(
      emoji: customEmoji1,
      category: "02 Ai",
      kanaName: "あいやy",
      aliases: [
        'yay_ai',
        '藍',
        'あい',
        'ばんざい',
        'バンザイ',
        'ばんざーい',
        'やった',
        'やったぁ',
        'わぁい',
        'わーい',
        'やったー',
        'やったぁ',
        'うれしい',
        'ハッピー',
        'たのしい',
        'わーいわーい',
        'よろこび',
        'よろこぶ',
        '',
        'happy',
        'yay',
        'ai',
        'praise',
      ],
      kanaAliases: [
        'やyあい',
        '藍',
        'あい',
        'ばんざい',
        'バンザイ',
        'ばんざーい',
        'やった',
        'やったぁ',
        'わぁい',
        'わーい',
        'やったー',
        'やったぁ',
        'うれしい',
        'ハッピー',
        'たのしい',
        'わーいわーい',
        'よろこび',
        'よろこぶ',
        '',
        'はppy',
        'やy',
        'あい',
        'pらいせ',
      ]);

  // チャンネル
  static CommunityChannel channel1 = CommunityChannel.fromJson(JSON5.parse(r'''
  {
    id: '9axtmmcxuy',
    createdAt: '2023-02-07T13:07:28.305Z',
    lastNotedAt: '2023-06-18T10:43:33.672Z',
    name: 'ブルーアーカイ部 総合',
    description: '<center>ありがとうブルーアーカイブ\nブルアカに関する投稿なら何でも歓迎！ネタ投稿や雑談、MFM芸なども:yattare:！</center>\n\n投稿内容がネタや雑談よりになってしまったため、公式供給や攻略情報に関する話題など、真面目な話を行うための[サブチャンネル🔗](https://misskey.io/channels/9cpndqrb3i)を設けました。\n各自使い分けをお願いします。\n当チャンネルは引き続き自由にご利用ください。\n\nその他、他の方が作られたブルアカ関連チャンネル\n・[変態妄想垂れ流し部](https://misskey.io/channels/9c0i1s4abg)\n\n**攻略情報や質問などはサブチャンネルがオススメです！\nクリア編成報告もサブチャンネルのほうが参考にできるのでいいかも。特に低レベルクリアには需要がありますよ！**\n\n今までどおりの雑談はこちらでどうぞ！\n場合によっては引用で跨いでもいいと思います。\n\n役立ちそうなリンク集\n[公式サイト ニュースページ:bluearchive:](https://bluearchive.jp/news/newsJump)\n[公式Twitter（JP）:twitter:](https://twitter.com/Blue_ArchiveJP)\n[公式Twitter（KR）:twitter:](https://twitter.com/KR_BlueArchive)\n[公式YouTube（JP）:youtube:](https://youtube.com/channel/UCmgf8DJrAXFnU7j3u0kklUQ)\n[公式YouTube（グロ版）:youtube:](https://youtube.com/@bluearchive_Global)\n\n**※ネタバレやNSFWな内容、愚痴、偏った解釈などは「内容を隠す」機能を使ってワンクッション置くことをおすすめします。[NSFWのガイドラインはこちら](https://support.misskey.io/hc/ja/articles/6657417016463)**\n$[fg.color=red ※FA等の無断転載はやめましょう！元ツイートやノートを共有して、作者にいいねを届けましょう。]\nエッチな話は直接的なことや倫理的に危ういことなどはひかえて！みんなが見てるよ！:edasi:\n\n※バナーは公式サイトのファンキットを利用させていただいてます。',
    userId: '87psesv6sm',
    bannerUrl: 'https://s3.arkjp.net/misskey/7aa0455b-3b37-4725-8f7c-d4c846fc0aa6.jpg',
    pinnedNoteIds: [],
    color: '#00d7fb',
    isArchived: false,
    usersCount: 1095,
    notesCount: 67609,
    isFollowing: true,
    isFavorited: true,
    hasUnreadNote: false,
  }
  '''));
  static String channel1ExpectId = "9axtmmcxuy";
  static String channel1ExpectName = "ブルーアーカイ部 総合";

  static CommunityChannel channel2 = CommunityChannel.fromJson(JSON5.parse(r'''
{
  id: '9b3chwrm7f',
  createdAt: '2023-02-11T09:54:32.098Z',
  lastNotedAt: '2023-06-18T10:46:31.692Z',
  name: 'Misskeyアークナイツ部',
  description: 'シナリオ・オペレーター・イラスト・音楽・ガチャ報告etc…アクナイに関連するものなら🆗テラの話はこちらで🙌\n\n\n<center> $[fg **※注意事項※**]</center>\n怪文書┃R-18┃大陸版先行情報┃ネタバレ┃チクチク言葉┃などのセンシティブコンテンツは$[bg.color=0000ff $[fg.color=ffff00 **必ず注意書きで内容を明記**]]し、$[fg.color=00ff00 **CW・NSFW**]で配慮して投稿してください。\n(初心者の方も投稿を見る可能性があるのでシナリオのネタバレは配慮して頂けると助かります）\n\nリーク情報は公式の利用規約に抵触する恐れがあるためNGとします。\n\nhttps://www.arknights.jp/terms_of_service\n\nチャンネルで何かあれば @369 までどうぞ',
  userId: '9as52pe3nw',
  bannerUrl: 'https://s3.arkjp.net/misskey/webpublic-3bd34a15-bb8a-4189-b5ec-5e4b11e2bef7.jpg',
  pinnedNoteIds: [
    '9djyt2oghv',
  ],
  color: '#01c7fc',
  isArchived: false,
  usersCount: 442,
  notesCount: 31600,
  isFollowing: true,
  isFavorited: true,
  hasUnreadNote: false,
}  
  '''));
  static String channel2ExpectId = "9b3chwrm7f";
  static String channel2ExpectName = "Misskeyアークナイツ部";

  // Dio
  static DioError response404 = DioError(
      requestOptions: RequestOptions(),
      response: Response(requestOptions: RequestOptions(), statusCode: 404),
      type: DioErrorType.unknown);
}
