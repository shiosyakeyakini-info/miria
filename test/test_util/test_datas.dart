import "package:dio/dio.dart";
import "package:flutter/services.dart";
import "package:json5/json5.dart";
import "package:miria/model/account.dart";
import "package:miria/model/misskey_emoji_data.dart";
import "package:miria/providers.dart";
import "package:miria/repository/emoji_repository.dart";
import "package:misskey_dart/misskey_dart.dart";

// ignore: avoid_classes_with_only_static_members
class TestData {
  static Account account = Account(
    host: "example.miria.shiosyakeyakini.info",
    userId: "ai",
    i: i1,
    meta: meta,
  );
  static AccountContext accountContext = AccountContext(
    getAccount: account,
    postAccount: account,
  );
  // i
  static MeDetailed i1 = MeDetailed.fromJson(
    JSON5.parse(r"""
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

"""),
  );

  // note

  /// 自身のノート（藍ちゃん）１
  static Note note1 = Note.fromJson(
    JSON5.parse("""
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

  """),
  );

  static Note note2 = Note.fromJson(
    JSON5.parse(r"""
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
  """),
  );

  /// 自身でないノート１
  static Note note3AsAnotherUser = Note.fromJson(
    JSON5.parse("""
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
  """),
  );

  /// 自身のノート（投票込みのノート）
  static Note note4AsVote = Note.fromJson(
    JSON5.parse("""
{
  id: '9h7cbiu7ab',
  createdAt: '2023-07-15T08:58:52.831Z',
  userId: '7rkr3b1c1c',
  user: {
    id: '7rkr3b1c1c',
    name: '藍',
    username: 'ai',
    host: null,
    avatarUrl: 'https://proxy.misskeyusercontent.com/avatar.webp?url=https%3A%2F%2Fs3.arkjp.net%2Fmisskey%2Fwebpublic-ecc1008f-3e2e-4206-ae7e-5093221f08be.png&avatar=1',
    avatarBlurhash: null,
    isBot: true,
    isCat: true,
    emojis: {},
    onlineStatus: 'online',
    badgeRoles: [],
  },
  text: 'みにゃさんは、どれが空から降ってきてほしいですか？',
  cw: null,
  visibility: 'public',
  localOnly: false,
  reactionAcceptance: null,
  renoteCount: 7,
  repliesCount: 0,
  reactions: {
    ':gaming@.:': 1,
    ':kirakira@.:': 3,
    ':5000t_hosii@.:': 4,
    ':twinsparrot@.:': 1,
    ':_question_mark@.:': 7,
    ':role_bisyouzyo@.:': 1,
  },
  reactionEmojis: {},
  fileIds: [],
  files: [],
  replyId: null,
  renoteId: null,
  poll: {
    multiple: false,
    expiresAt: '2023-07-15T09:13:52.831Z',
    choices: [
      {
        text: '光る国民の基本的な権利',
        votes: 17,
        isVoted: false,
      },
      {
        text: 'ぷるぷる自動販売機',
        votes: 9,
        isVoted: false,
      },
      {
        text: '抗菌仕様金髪碧眼の美少女',
        votes: 27,
        isVoted: false,
      },
      {
        text: '養殖null',
        votes: 8,
        isVoted: false,
      },
    ],
  },
}

"""),
  );

  /// 自身でないノート２
  static Note note5AsAnotherUser = Note.fromJson(
    JSON5.parse(r"""
{
  id: '9gdpe2xkeo',
  createdAt: '2023-06-24T15:11:41.912Z',
  userId: '7rkr4nmz19',
  user: {
    id: '7rkr4nmz19',
    name: 'お知らせ',
    username: 'notify',
    host: null,
    avatarUrl: 'https://proxy.misskeyusercontent.com/avatar.webp?url=https%3A%2F%2Fs3.arkjp.net%2Fmisskey%2F3c08aa80-6a94-4417-a435-ed04cf270734.png&avatar=1',
    avatarBlurhash: null,
    isBot: false,
    isCat: false,
    emojis: {},
    onlineStatus: 'active',
    badgeRoles: [
      {
        name: 'Official',
        iconUrl: 'https://s3.arkjp.net/misskey/8df80984-86f9-4cc5-a289-1f6ab59c74b8.png',
        displayOrder: 1000,
      },
    ],
  },
  text: '【お知らせ】\nhttps://Misskey.io の総投稿数が2000万投稿を超えました！',
  cw: null,
  visibility: 'public',
  localOnly: false,
  reactionAcceptance: 'nonSensitiveOnly',
  renoteCount: 164,
  repliesCount: 0,
  reactions: {
    '❤': 8,
    '🎉': 17,
    '💾': 1,
    ':igyo@.:': 14,
    ':deltu@.:': 1,
    ':sugoi@.:': 11,
    ':igyofes@.:': 1,
    ':misuhai@.:': 7,
    ':16777216@.:': 1,
    ':kusodeka@.:': 1,
    ':nyanners@.:': 1,
    ':omedetou@.:': 1,
    ':199000man@.:': 14,
    ':supertada@.:': 6,
    ':resonyance@.:': 9,
    ':super_igyo@.:': 71,
    ':ultra_igyo@.:': 406,
    ':peroro_sama@.:': 1,
    ':score_65535@.:': 2,
    ':ultra_igyo2@.:': 20,
    ':hashtag_igyo@.:': 34,
    ':igyo_omurice@.:': 1,
    ':sugoihanashi@.:': 8,
    ':kiwamete_igyo@.:': 6,
    ':saikou_sugiru@.:': 1,
    ':ultimate_igyo@.:': 93,
    ':stack_overflow@.:': 1,
    ':igyo_no_tatuzin@.:': 1,
    ':nobel_igyo_syou@.:': 1,
    ':igyo2@misskey.04.si:': 2,
    ':sungee@nijimiss.moe:': 1,
    ':super_chat_10000yen@.:': 1,
    ':supertada@nekomiya.net:': 1,
    ':sugoi@ikaskey.bktsk.com:': 1,
    ':igyo@misskey.yukineko.me:': 1,
    ':master_igyo@nijimiss.moe:': 1,
    ':super_igyo@misskey.yukineko.me:': 1,
  },
  reactionEmojis: {
    'igyo2@misskey.04.si': 'https://misskey.04.si/files/3a484c36-65b0-4677-98d2-a165f72fd25c',
    'sungee@nijimiss.moe': 'https://media.nijimiss.app/null/db7ad2be-a29f-4e14-b873-50125850086d.gif',
    'supertada@nekomiya.net': 'https://nekomiya.net/storage/30b1bcb9-9b80-48e0-baf4-f38bf1f18210',
    'sugoi@ikaskey.bktsk.com': 'https://ikaskey-s3.bktsk.com/ikaskey/7205d272-ee8a-49a0-b64f-1515e2b9c970.png',
    'igyo@misskey.yukineko.me': 'https://s3.yukineko.me/static/misskey/e09da08c-f603-4032-a19d-c90b7c440265.png',
    'master_igyo@nijimiss.moe': 'https://media.nijimiss.app/null/69f7a9f9-f857-4001-9400-d8e0d36ddb56.png',
    'super_igyo@misskey.yukineko.me': 'https://s3.yukineko.me/static/misskey/1902ee5b-3655-483b-938a-efc361bb3eaa.png',
  },
  fileIds: [
    '9gdpdb8wp2',
  ],
  files: [
    {
      id: '9gdpdb8wp2',
      createdAt: '2023-06-24T15:11:06.032Z',
      name: '2023-06-25 00-11-05 1.png',
      type: 'image/png',
      md5: 'cf8cc78629e6fb6e8b4a624a0ded3c29',
      size: 24108,
      isSensitive: false,
      blurhash: 'e384l69XD~xuxc~pD%Rjt7oM00%4%3RjWT00_2%LM{WU9GxuxtayRj',
      properties: {
        width: 646,
        height: 236,
      },
      url: 'https://s3.arkjp.net/misskey/5da55bce-9b22-4a01-97ec-6e8c180aed00.png',
      thumbnailUrl: 'https://s3.arkjp.net/misskey/thumbnail-813f78ab-0622-4a6e-817c-67bbbb9a7597.webp',
      comment: null,
      folderId: null,
      folder: null,
      userId: null,
      user: null,
    },
  ],
  replyId: null,
  renoteId: null,
  myReaction: ':ultra_igyo@.:',
}
  """),
  );

  /// Renote
  static Note note6AsRenote = Note.fromJson(
    JSON5.parse("""
{
    id: '9lmbcrob34',
    createdAt: '2023-11-03T15:07:13.307Z',
    userId: '9byjlos32z',
    user: {
      id: '9byjlos32z',
      name: 'そらいろ:role_reaction_shooter:',
      username: 'shiosyakeyakini',
      host: null,
      avatarUrl: 'https://proxy.misskeyusercontent.com/avatar.webp?url=https%3A%2F%2Fs3.arkjp.net%2Fmisskey%2Fwebpublic-5e0b7842-adf7-4d29-b04a-a6e1faa4c3c4.png&avatar=1',
      avatarBlurhash: 'eaN^k|,Rj%3x]_NM{t7t7jE^+tRjYR%s;MxMxIoogozxvRkRkRijE',
      isBot: false,
      isCat: true,
      emojis: {},
      onlineStatus: 'online',
      badgeRoles: [
        {
          name: 'Patreon Miskist',
          iconUrl: 'https://s3.arkjp.net/misskey/b03aec5c-4ef6-475d-b9ae-040531e77ff2.png',
          displayOrder: 10,
        },
        {
          name: 'Misskey Supporter',
          iconUrl: 'https://s3.arkjp.net/misskey/dab4e89c-4ed1-4c06-918d-441db61dabaf.png',
          displayOrder: 10,
        },
        {
          name: 'FANBOX サポーター',
          iconUrl: 'https://s3.arkjp.net/misskey/6e3b469e-16ed-4cc2-9098-215b441da254.png',
          displayOrder: 0,
        },
      ],
    },
    text: null,
    cw: null,
    visibility: 'public',
    localOnly: false,
    reactionAcceptance: null,
    renoteCount: 0,
    repliesCount: 0,
    reactions: {},
    reactionEmojis: {},
    fileIds: [],
    files: [],
    replyId: null,
    renoteId: '9lmb9yahs7',
    renote: {
      id: '9lmb9yahs7',
      createdAt: '2023-11-03T15:05:01.913Z',
      userId: '9g0ku8jkft',
      user: {
        id: '9g0ku8jkft',
        name: 'しゅうまい君（バカンス）',
        username: 'shuumai',
        host: null,
        avatarUrl: 'https://proxy.misskeyusercontent.com/avatar.webp?url=https%3A%2F%2Fs3.arkjp.net%2Fmisskey%2Fe44afb80-e469-4ca2-bfd0-ddb8555e6a26.png&avatar=1',
        avatarBlurhash: 'eoJThjozuNozo|kpj[ofaye.y=ayVFj[Vts;ayV@j[W;WDj[jEayoz',
        isBot: true,
        isCat: false,
        emojis: {},
        onlineStatus: 'unknown',
        badgeRoles: [
          {
            name: 'Verified',
            iconUrl: 'https://s3.arkjp.net/misskey/8df80984-86f9-4cc5-a289-1f6ab59c74b8.png',
            displayOrder: 1000,
          },
        ],
      },
      text: 'どう考えてもおいしい冷める前のケースに使われてしまいそう」 （白いの自分が綺麗になると自分が36な',
      cw: null,
      visibility: 'public',
      localOnly: false,
      reactionAcceptance: null,
      renoteCount: 2,
      repliesCount: 0,
      reactions: {
        '❤': 1,
        ':miria@.:': 44,
        ':36kyoutei@.:': 5,
      },
      reactionEmojis: {},
      fileIds: [],
      files: [],
      replyId: null,
      renoteId: null,
      myReaction: ':miria@.:',
    },
  }
"""),
  );

  // ドライブ（フォルダ）
  static DriveFolder folder1 = DriveFolder.fromJson(
    JSON5.parse("""
  {
    id: '9ettn0mv95',
    createdAt: '2023-05-16T12:35:31.447Z',
    name: '秘蔵の藍ちゃんフォルダ',
    parentId: null,
  }"""),
  );

  static DriveFolder folder1Child = DriveFolder.fromJson(
    JSON5.parse("""
  {
    id: '9ettn0mv95',
    createdAt: '2023-05-16T12:35:31.447Z',
    name: 'えっちなやつ',
    parentId: '9ettn0mv95',
  }"""),
  );

  // ドライブ（ファイル）
  static DriveFile drive1 = DriveFile.fromJson(
    JSON5.parse(r"""
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
  """),
  );

  static DriveFile drive2AsVideo = DriveFile.fromJson(
    JSON5.parse("""
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
  """),
  );

  static Future<Uint8List> get binaryImage async => Uint8List.fromList(
    (await rootBundle.load("assets/images/icon.png")).buffer.asUint8List(),
  );

  static Future<Response<Uint8List>> get binaryImageResponse async => Response(
    requestOptions: RequestOptions(),
    statusCode: 200,
    data: await binaryImage,
  );

  // ユーザー情報
  static UserLite user1 = UserLite.fromJson(
    JSON5.parse("""
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
}"""),
  );
  static String user1ExpectId = "7rkr3b1c1c";

  static UserDetailedNotMeWithRelations detailedUser1 =
      UserDetailedNotMeWithRelations.fromJson(
        JSON5.parse(r"""
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
}  """),
      );

  static UserDetailedNotMeWithRelations detailedUser2 =
      UserDetailedNotMeWithRelations.fromJson(
        JSON5.parse(r"""
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
}"""),
      );

  static String detailedUser2ExpectedId = "9gbzuv2cze";

  // ユーザー情報
  static UserDetailedNotMeWithRelations usersShowResponse1 =
      UserDetailedNotMeWithRelations.fromJson(
        JSON5.parse(r"""
{
  id: '7rkr3b1c1c',
  name: '藍',
  username: 'ai',
  host: null,
  avatarUrl: 'https://proxy.misskeyusercontent.com/avatar.webp?url=https%3A%2F%2Fs3.arkjp.net%2Fmisskey%2Fwebpublic-ecc1008f-3e2e-4206-ae7e-5093221f08be.png&avatar=1',
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
  updatedAt: '2023-07-16T09:06:10.691Z',
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
  followersCount: 14276,
  followingCount: 996,
  notesCount: 74078,
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
      avatarUrl: 'https://proxy.misskeyusercontent.com/avatar.webp?url=https%3A%2F%2Fs3.arkjp.net%2Fmisskey%2Fwebpublic-ecc1008f-3e2e-4206-ae7e-5093221f08be.png&avatar=1',
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
    likedCount: 11,
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
  isFollowing: true,
  isFollowed: true,
  hasPendingFollowRequestFromYou: false,
  hasPendingFollowRequestToYou: false,
  isBlocking: false,
  isBlocked: false,
  isMuted: false,
  isRenoteMuted: false,
}

  """),
      );

  static UserDetailedNotMeWithRelations usersShowResponse2 =
      UserDetailedNotMeWithRelations.fromJson(
        JSON5.parse(r"""
{
  id: '7z9zua5kyv',
  name: 'おいしいBot',
  username: 'oishiibot',
  host: null,
  avatarUrl: 'https://proxy.misskeyusercontent.com/avatar.webp?url=https%3A%2F%2Fs3.arkjp.net%2Fmisskey%2Fwebpublic-d67529a5-4b8b-4e76-b827-7fcbb57956b6.png&avatar=1',
  avatarBlurhash: null,
  isBot: true,
  isCat: false,
  emojis: {},
  onlineStatus: 'online',
  badgeRoles: [],
  url: null,
  uri: null,
  movedTo: null,
  alsoKnownAs: [
    '9guzhm5p6f',
  ],
  createdAt: '2019-10-25T17:48:45.416Z',
  updatedAt: '2023-07-16T08:35:54.004Z',
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
  followersCount: 7200,
  followingCount: 7003,
  notesCount: 60536,
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
      avatarUrl: 'https://proxy.misskeyusercontent.com/avatar.webp?url=https%3A%2F%2Fs3.arkjp.net%2Fmisskey%2Fwebpublic-d67529a5-4b8b-4e76-b827-7fcbb57956b6.png&avatar=1',
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
}

  """),
      );

  static UserDetailedNotMeWithRelations usersShowResponse3AsRemoteUser =
      UserDetailedNotMeWithRelations.fromJson(
        JSON5.parse(r'''
{
  id: '9i08deo0vj',
  name: 'あけおめらんか～',
  username: 'akeome',
  host: 'misskey.backspace.fm',
  avatarUrl: 'https://misskey.io/identicon/akeome@misskey.backspace.fm',
  avatarBlurhash: null,
  isBot: true,
  isCat: false,
  instance: {
    name: 'BackspaceKey',
    softwareName: 'misskey',
    softwareVersion: '2023.9.3-bsk-2.1.2',
    iconUrl: 'https://s3.bskstorage.com/sakura/backspacekey/dc65f1fb-bc2b-4013-8f47-c6abd6df30ee.png',
    faviconUrl: 'https://s3.bskstorage.com/sakura/backspacekey/125bc5c2-7e4b-409f-b50f-331dfb3e6bde.png',
    themeColor: '#e4d440',
  },
  emojis: {},
  onlineStatus: 'unknown',
  url: 'https://misskey.backspace.fm/@akeome',
  uri: 'https://misskey.backspace.fm/users/9i07ia9bf0',
  movedTo: null,
  alsoKnownAs: null,
  createdAt: '2023-08-04T14:13:41.376Z',
  updatedAt: '2023-11-01T15:02:05.677Z',
  lastFetchedAt: '2023-11-01T14:04:12.561Z',
  bannerUrl: null,
  bannerBlurhash: null,
  isLocked: false,
  isSilenced: false,
  isLimited: false,
  isSuspended: false,
  description: '毎日0:00に開かれる時間競技を観測するためのbotです。\n**/follow**でこちらからフォローします。',
  location: null,
  birthday: null,
  lang: null,
  fields: [
    {
      name: '集計ワード',
      value: '"あけおめ","あけましておめでとうございます",":akeome:",":sakibashiri_oniichan_ni_akeome_shite_agerunoha_atashi_kurai_desho_heart:","はるさめずるずるひょるひょるほほほー",":harusame_zuruzuru:"',
    },
    {
      name: '集計に使わせていただいております',
      value: 'https://github.com/taichanNE30/yamag',
    },
    {
      name: '集計部分の制作者',
      value: '@taichan',
    },
    {
      name: '中の人',
      value: '@mirashiya37',
    },
  ],
  followersCount: 0,
  followingCount: 0,
  notesCount: 197,
  pinnedNoteIds: [],
  pinnedNotes: [],
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
}
'''),
      );

  static UserDetailedNotMeWithRelations usersShowResponse3AsLocalUser =
      UserDetailedNotMeWithRelations.fromJson(
        JSON5.parse('''
{
  id: '9i07ia9bf0',
  name: 'あけおめらんか～',
  username: 'akeome',
  host: null,
  avatarUrl: 'https://misskey.backspace.fm/identicon/akeome@misskey.backspace.fm',
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
  createdAt: '2023-08-04T13:49:29.327Z',
  updatedAt: '2023-11-02T21:01:34.367Z',
  lastFetchedAt: null,
  bannerUrl: null,
  bannerBlurhash: null,
  isLocked: false,
  isSilenced: false,
  isSuspended: false,
  description: '毎日0:00に開かれる時間競技を観測するためのbotです。\\n**/follow**でこちらからフォローします。',
  location: null,
  birthday: null,
  lang: 'ja',
  fields: [
    {
      name: '集計ワード',
      value: '"あけおめ","あけましておめでとうございます",":akeome:",":sakibashiri_oniichan_ni_akeome_shite_agerunoha_atashi_kurai_desho_heart:","はるさめずるずるひょるひょるほほほー",":harusame_zuruzuru:"',
    },
    {
      name: '集計に使わせていただいております',
      value: 'https://github.com/taichanNE30/yamag',
    },
    {
      name: '集計部分の制作者',
      value: '@taichan',
    },
    {
      name: '中の人',
      value: '@mirashiya37',
    },
  ],
  verifiedLinks: [],
  followersCount: 70,
  followingCount: 61,
  notesCount: 593,
  pinnedNoteIds: [],
  pinnedNotes: [],
  pinnedPageId: null,
  pinnedPage: null,
  publicReactions: true,
  ffVisibility: 'public',
  twoFactorEnabled: false,
  usePasswordLessLogin: false,
  securityKeys: false,
  roles: [
    {
      id: '9gvf639rj8',
      name: '一期生',
      color: null,
      iconUrl: null,
      description: '',
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
  notify: 'none',
}

'''),
      );

  // ユーザー情報 (followingVisibility テスト用)
  static UserDetailedNotMeWithRelations userWithFollowingVisibilityPublic =
      detailedUser1.copyWith(
        followingVisibility: FFVisibility.public,
        ffVisibility: FFVisibility
            .private, // Different from followingVisibility to test precedence
      );

  static UserDetailedNotMeWithRelations userWithFollowingVisibilityPrivate =
      detailedUser1.copyWith(
        followingVisibility: FFVisibility.private,
        ffVisibility: FFVisibility
            .public, // Different from followingVisibility to test precedence
        isFollowing: true, // User is following to test private visibility logic
      );

  static UserDetailedNotMeWithRelations
  userWithFollowingVisibilityNull = detailedUser1.copyWith(
    followingVisibility: null,
    ffVisibility: FFVisibility
        .public, // Should fall back to this when followingVisibility is null
  );

  // カスタム絵文字
  static UnicodeEmojiData unicodeEmoji1 = const UnicodeEmojiData(char: "♥");
  static CustomEmojiData customEmoji1 = CustomEmojiData(
    baseName: "ai_yay",
    hostedName: "misskey.io",
    url: Uri.parse("https://s3.arkjp.net/emoji/ai_yay.apng"),
    isCurrentServer: true,
    isSensitive: false,
  );

  static EmojiRepositoryData unicodeEmojiRepositoryData1 = EmojiRepositoryData(
    emoji: unicodeEmoji1,
    category: "symbols",
    kanaName: "へあt",
    aliases: ["heart", "ハート"],
    kanaAliases: ["へあt", "ハート"],
  );

  static EmojiRepositoryData customEmojiRepositoryData1 = EmojiRepositoryData(
    emoji: customEmoji1,
    category: "02 Ai",
    kanaName: "あいやy",
    aliases: [
      "yay_ai",
      "藍",
      "あい",
      "ばんざい",
      "バンザイ",
      "ばんざーい",
      "やった",
      "やったぁ",
      "わぁい",
      "わーい",
      "やったー",
      "やったぁ",
      "うれしい",
      "ハッピー",
      "たのしい",
      "わーいわーい",
      "よろこび",
      "よろこぶ",
      "",
      "happy",
      "yay",
      "ai",
      "praise",
    ],
    kanaAliases: [
      "やyあい",
      "藍",
      "あい",
      "ばんざい",
      "バンザイ",
      "ばんざーい",
      "やった",
      "やったぁ",
      "わぁい",
      "わーい",
      "やったー",
      "やったぁ",
      "うれしい",
      "ハッピー",
      "たのしい",
      "わーいわーい",
      "よろこび",
      "よろこぶ",
      "",
      "はppy",
      "やy",
      "あい",
      "pらいせ",
    ],
  );

  // チャンネル
  static CommunityChannel channel1 = CommunityChannel.fromJson(
    JSON5.parse(r"""
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
  """),
  );

  static String expectChannel1DescriptionContaining = "ありがとうブルーアーカイブ";

  static CommunityChannel channel2 = CommunityChannel.fromJson(
    JSON5.parse(r"""
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
  """),
  );

  // アンテナ
  static Antenna antenna = Antenna.fromJson(
    JSON5.parse("""
{
    id: '9f7kcbzcoe',
    createdAt: '2023-05-26T03:24:02.856Z',
    name: 'ポテイモン',
    keywords: [
      [
        'ポテイモン',
      ],
      [
        '芋神',
      ],
      [
        'misscat',
      ],
    ],
    excludeKeywords: [
      [
        '応天門',
      ],
    ],
    src: 'all',
    userListId: null,
    users: [
      '',
    ],
    caseSensitive: false,
    notify: false,
    withReplies: false,
    withFile: false,
    isActive: true,
    hasUnreadNote: false,
  }
"""),
  );

  static Clip clip = Clip.fromJson(
    JSON5.parse("""
{
    id: '9crm7l2n4k',
    createdAt: '2023-03-25T14:12:37.103Z',
    lastClippedAt: '2023-06-27T10:08:56.762Z',
    userId: '9byjlos32z',
    user: {
      id: '7rkr3b1c1c',
      name: '藍',
      username: 'ai',
      host: null,
      avatarUrl: 'https://proxy.misskeyusercontent.com/avatar.webp?url=https%3A%2F%2Fs3.arkjp.net%2Fmisskey%2Fwebpublic-ecc1008f-3e2e-4206-ae7e-5093221f08be.png&avatar=1',
      avatarBlurhash: null,
      isBot: true,
      isCat: true,
      emojis: {},
      onlineStatus: 'online',
      badgeRoles: [],
    },
    name: 'ぴょんぷっぷー',
    description: null,
    isPublic: true,
    favoritedCount: 0,
    isFavorited: false,
  }

"""),
  );

  static RolesListResponse role = RolesListResponse.fromJson(
    JSON5.parse("""
{
    id: '9diazxez3m',
    createdAt: '2023-04-13T06:28:30.827Z',
    updatedAt: '2023-06-25T09:28:16.529Z',
    name: 'Super New User',
    description: 'アカウント作成してから1日以内のユーザー',
    color: '#a4850a',
    iconUrl: 'https://s3.arkjp.net/misskey/358069f4-e033-4366-891b-fcc4fc4d0c70.png',
    target: 'conditional',
    condFormula: {
      id: '83328ff6-8bdc-4516-9dee-751222897481',
      type: 'and',
      values: [
        {
          id: 'deac20b7-2688-4d7e-a264-5d0f0345f003',
          type: 'isLocal',
        },
        {
          id: '9959c843-b273-4edf-8632-41b103af8b88',
          sec: 86400,
          type: 'createdLessThan',
        },
      ],
    },
    isPublic: true,
    isAdministrator: false,
    isModerator: false,
    isExplorable: true,
    asBadge: true,
    canEditMembersByModerator: false,
    displayOrder: 0,
    policies: {
      pinLimit: {
        value: 3,
        priority: 0,
        useDefault: true,
      },
      canInvite: {
        value: false,
        priority: 0,
        useDefault: true,
      },
      clipLimit: {
        value: 10,
        priority: 0,
        useDefault: true,
      },
      canHideAds: {
        value: false,
        priority: 0,
        useDefault: true,
      },
      antennaLimit: {
        value: 5,
        priority: 0,
        useDefault: true,
      },
      gtlAvailable: {
        value: true,
        priority: 0,
        useDefault: true,
      },
      ltlAvailable: {
        value: true,
        priority: 0,
        useDefault: true,
      },
      webhookLimit: {
        value: 3,
        priority: 0,
        useDefault: true,
      },
      canPublicNote: {
        value: true,
        priority: 0,
        useDefault: true,
      },
      userListLimit: {
        value: 5,
        priority: 0,
        useDefault: true,
      },
      wordMuteLimit: {
        value: 200,
        priority: 0,
        useDefault: true,
      },
      alwaysMarkNsfw: {
        value: false,
        priority: 0,
        useDefault: true,
      },
      canSearchNotes: {
        value: false,
        priority: 0,
        useDefault: true,
      },
      driveCapacityMb: {
        value: 10240,
        priority: 0,
        useDefault: true,
      },
      rateLimitFactor: {
        value: 2,
        priority: 0,
        useDefault: true,
      },
      noteEachClipsLimit: {
        value: 50,
        priority: 0,
        useDefault: true,
      },
      canManageCustomEmojis: {
        value: false,
        priority: 0,
        useDefault: true,
      },
      userEachUserListsLimit: {
        value: 20,
        priority: 0,
        useDefault: true,
      },
      canCreateContent: {
        useDefault: true,
        priority: 0,
        value: true,
      },
      canUpdateContent: {
        useDefault: true,
        priority: 0,
        value: true,
      },
      canDeleteContent: {
        useDefault: true,
        priority: 0,
        value: true,
      },
      inviteLimit: {
        useDefault: true,
        priority: 0,
        value: 0,
      },
      inviteLimitCycle: {
        useDefault: true,
        priority: 0,
        value: 10080,
      },
      inviteExpirationTime: {
        useDefault: true,
        priority: 0,
        value: 0,
      },
    },
    usersCount: 0,
  }
"""),
  );

  static HashtagsTrendResponse hashtagTrends = HashtagsTrendResponse.fromJson(
    JSON5.parse("""
{
    tag: 'ろぐぼチャレンジ',
    chart: [
      3,
      2,
      2,
      1,
      3,
      4,
      2,
      4,
      2,
      4,
      0,
      0,
      3,
      2,
      3,
      6,
      5,
      4,
      12,
      8,
    ],
    usersCount: 15,
  }
"""),
  );

  static Hashtag hashtag = Hashtag.fromJson(
    JSON5.parse("""
{
    tag: 'アークナイツ',
    mentionedUsersCount: 531,
    mentionedLocalUsersCount: 3,
    mentionedRemoteUsersCount: 528,
    attachedUsersCount: 67,
    attachedLocalUsersCount: 2,
    attachedRemoteUsersCount: 65,
  }
"""),
  );

  static MetaResponse meta = MetaResponse.fromJson(
    JSON5.parse("""
{
  maintainerName: 'そらいろ',
  maintainerEmail: 'sorairo@shiosyakeyakini.info',
  version: '2023.12.0-beta.1',
  name: 'Miria検証環境サーバー',
  shortName: null,
  uri: 'https://stg.miria.shiosyakeyakini.info',
  description: 'このサーバーはMiria ( https://shiosyakeyakini.info/miria_web/index.html ) の検証と、ストア審査用の環境です。',
  langs: [],
  tosUrl: null,
  repositoryUrl: 'https://github.com/misskey-dev/misskey',
  feedbackUrl: 'https://github.com/misskey-dev/misskey/issues/new',
  impressumUrl: null,
  privacyPolicyUrl: null,
  disableRegistration: true,
  emailRequiredForSignup: false,
  enableHcaptcha: false,
  hcaptchaSiteKey: null,
  enableRecaptcha: false,
  recaptchaSiteKey: null,
  enableTurnstile: false,
  turnstileSiteKey: null,
  swPublickey: null,
  themeColor: null,
  mascotImageUrl: '/assets/ai.png',
  bannerUrl: null,
  infoImageUrl: null,
  serverErrorImageUrl: null,
  notFoundImageUrl: null,
  iconUrl: null,
  backgroundImageUrl: null,
  logoImageUrl: null,
  maxNoteTextLength: 3000,
  defaultLightTheme: null,
  defaultDarkTheme: null,
  ads: [
    {
      id: '9i5sueefva',
      url: 'https://shiosyakeyakini.info/miria_web/index.html',
      place: 'square',
      ratio: 1,
      imageUrl: 'https://shiosyakeyakini.info/miria_web/ad.png',
      dayOfWeek: 0,
    },
  ],
  notesPerOneAd: 0,
  enableEmail: false,
  enableServiceWorker: false,
  translatorAvailable: false,
  serverRules: [],
  policies: {
    gtlAvailable: true,
    ltlAvailable: true,
    canPublicNote: true,
    canInvite: false,
    inviteLimit: 0,
    inviteLimitCycle: 10080,
    inviteExpirationTime: 0,
    canManageCustomEmojis: false,
    canManageAvatarDecorations: false,
    canSearchNotes: false,
    canUseTranslator: true,
    canHideAds: false,
    driveCapacityMb: 100,
    alwaysMarkNsfw: false,
    pinLimit: 5,
    antennaLimit: 5,
    wordMuteLimit: 200,
    webhookLimit: 3,
    clipLimit: 10,
    noteEachClipsLimit: 200,
    userListLimit: 10,
    userEachUserListsLimit: 50,
    rateLimitFactor: 1,
  },
  mediaProxy: 'https://stg.miria.shiosyakeyakini.info/proxy',
  cacheRemoteFiles: false,
  cacheRemoteSensitiveFiles: true,
  requireSetup: false,
  proxyAccountName: null,
  features: {
    registration: false,
    emailRequiredForSignup: false,
    hcaptcha: false,
    recaptcha: false,
    turnstile: false,
    objectStorage: false,
    serviceWorker: false,
    miauth: true,
  },
}
"""),
  );

  // Chat Rooms
  static ChatRoom chatRoom1 = ChatRoom(
    id: "chatroom-1",
    createdAt: DateTime.parse("2024-01-01T12:00:00.000Z"),
    ownerId: "ai",
    owner: user1,
    name: "テストルーム",
    description: "テスト用のチャットルーム",
    isMuted: false,
  );

  static ChatJoining chatJoining1 = ChatJoining(
    id: "joining-1",
    createdAt: DateTime.parse("2024-01-01T12:00:00.000Z"),
    userId: "ai",
    user: user1,
    roomId: "chatroom-1",
    room: chatRoom1,
  );

  static ChatRoom chatRoom2 = ChatRoom(
    id: "chatroom-2",
    createdAt: DateTime.parse("2024-01-02T12:00:00.000Z"),
    ownerId: "ai",
    owner: user1,
    name: "プライベートルーム",
    description: "プライベート用チャットルーム",
    isMuted: true,
  );

  static ChatRoom emptyDescriptionRoom = ChatRoom(
    id: "chatroom-empty",
    createdAt: DateTime.parse("2024-01-03T12:00:00.000Z"),
    ownerId: "ai",
    owner: user1,
    name: "説明なしルーム",
    description: "",
    isMuted: false,
  );

  // Dio
  static DioException response404 = DioException(
    requestOptions: RequestOptions(),
    response: Response(requestOptions: RequestOptions(), statusCode: 404),
    type: DioExceptionType.unknown,
  );
}
