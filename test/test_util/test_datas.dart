import 'package:miria/model/account.dart';
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

  // user
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
}
