import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ja.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ja', 'OJ'),
    Locale('ja'),
    Locale('zh', 'CN'),
    Locale('zh'),
  ];

  /// No description provided for @announcement.
  ///
  /// In ja, this message translates to:
  /// **'お知らせ'**
  String get announcement;

  /// No description provided for @antenna.
  ///
  /// In ja, this message translates to:
  /// **'アンテナ'**
  String get antenna;

  /// No description provided for @user.
  ///
  /// In ja, this message translates to:
  /// **'ユーザー'**
  String get user;

  /// No description provided for @channel.
  ///
  /// In ja, this message translates to:
  /// **'チャンネル'**
  String get channel;

  /// No description provided for @timeline.
  ///
  /// In ja, this message translates to:
  /// **'タイムライン'**
  String get timeline;

  /// No description provided for @sensitive.
  ///
  /// In ja, this message translates to:
  /// **'センシティブ'**
  String get sensitive;

  /// No description provided for @favorite.
  ///
  /// In ja, this message translates to:
  /// **'お気に入り'**
  String get favorite;

  /// No description provided for @trend.
  ///
  /// In ja, this message translates to:
  /// **'トレンド'**
  String get trend;

  /// No description provided for @clip.
  ///
  /// In ja, this message translates to:
  /// **'クリップ'**
  String get clip;

  /// No description provided for @edit.
  ///
  /// In ja, this message translates to:
  /// **'編集'**
  String get edit;

  /// No description provided for @create.
  ///
  /// In ja, this message translates to:
  /// **'作成'**
  String get create;

  /// No description provided for @delete.
  ///
  /// In ja, this message translates to:
  /// **'削除'**
  String get delete;

  /// No description provided for @search.
  ///
  /// In ja, this message translates to:
  /// **'検索'**
  String get search;

  /// No description provided for @detail.
  ///
  /// In ja, this message translates to:
  /// **'詳細'**
  String get detail;

  /// No description provided for @save.
  ///
  /// In ja, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @hide.
  ///
  /// In ja, this message translates to:
  /// **'隠す'**
  String get hide;

  /// No description provided for @note.
  ///
  /// In ja, this message translates to:
  /// **'ノート'**
  String get note;

  /// No description provided for @mention.
  ///
  /// In ja, this message translates to:
  /// **'メンション'**
  String get mention;

  /// No description provided for @renote.
  ///
  /// In ja, this message translates to:
  /// **'リノート'**
  String get renote;

  /// No description provided for @quotedRenote.
  ///
  /// In ja, this message translates to:
  /// **'引用'**
  String get quotedRenote;

  /// No description provided for @notification.
  ///
  /// In ja, this message translates to:
  /// **'通知'**
  String get notification;

  /// No description provided for @list.
  ///
  /// In ja, this message translates to:
  /// **'リスト'**
  String get list;

  /// No description provided for @explore.
  ///
  /// In ja, this message translates to:
  /// **'みつける'**
  String get explore;

  /// No description provided for @highlight.
  ///
  /// In ja, this message translates to:
  /// **'ハイライト'**
  String get highlight;

  /// No description provided for @role.
  ///
  /// In ja, this message translates to:
  /// **'ロール'**
  String get role;

  /// No description provided for @page.
  ///
  /// In ja, this message translates to:
  /// **'ページ'**
  String get page;

  /// No description provided for @flash.
  ///
  /// In ja, this message translates to:
  /// **'Play'**
  String get flash;

  /// No description provided for @hashtag.
  ///
  /// In ja, this message translates to:
  /// **'ハッシュタグ'**
  String get hashtag;

  /// No description provided for @otherServers.
  ///
  /// In ja, this message translates to:
  /// **'よそのサーバー'**
  String get otherServers;

  /// No description provided for @follow.
  ///
  /// In ja, this message translates to:
  /// **'フォロー'**
  String get follow;

  /// No description provided for @following.
  ///
  /// In ja, this message translates to:
  /// **'フォロー中'**
  String get following;

  /// No description provided for @managing.
  ///
  /// In ja, this message translates to:
  /// **'管理中'**
  String get managing;

  /// わかった
  ///
  /// In ja, this message translates to:
  /// **'ほい'**
  String get done;

  /// No description provided for @public.
  ///
  /// In ja, this message translates to:
  /// **'パブリック'**
  String get public;

  /// No description provided for @home.
  ///
  /// In ja, this message translates to:
  /// **'ホーム'**
  String get home;

  /// No description provided for @local.
  ///
  /// In ja, this message translates to:
  /// **'ローカル'**
  String get local;

  /// No description provided for @direct.
  ///
  /// In ja, this message translates to:
  /// **'ダイレクト'**
  String get direct;

  /// No description provided for @onlyLocal.
  ///
  /// In ja, this message translates to:
  /// **'ローカルのみ'**
  String get onlyLocal;

  /// No description provided for @remote.
  ///
  /// In ja, this message translates to:
  /// **'リモート'**
  String get remote;

  /// No description provided for @software.
  ///
  /// In ja, this message translates to:
  /// **'ソフトウェア'**
  String get software;

  /// No description provided for @federatedPosts.
  ///
  /// In ja, this message translates to:
  /// **'投稿'**
  String get federatedPosts;

  /// No description provided for @language.
  ///
  /// In ja, this message translates to:
  /// **'言語'**
  String get language;

  /// No description provided for @administrator.
  ///
  /// In ja, this message translates to:
  /// **'管理者'**
  String get administrator;

  /// No description provided for @contact.
  ///
  /// In ja, this message translates to:
  /// **'連絡先'**
  String get contact;

  /// No description provided for @serverRules.
  ///
  /// In ja, this message translates to:
  /// **'サーバーのきめごと'**
  String get serverRules;

  /// No description provided for @tos.
  ///
  /// In ja, this message translates to:
  /// **'利用規約'**
  String get tos;

  /// No description provided for @privacyPolicy.
  ///
  /// In ja, this message translates to:
  /// **'プライバシーポリシー'**
  String get privacyPolicy;

  /// No description provided for @impressum.
  ///
  /// In ja, this message translates to:
  /// **'運営者情報'**
  String get impressum;

  /// No description provided for @willDelete.
  ///
  /// In ja, this message translates to:
  /// **'削除するで'**
  String get willDelete;

  /// No description provided for @cancel.
  ///
  /// In ja, this message translates to:
  /// **'やっぱやめる'**
  String get cancel;

  /// No description provided for @noneAction.
  ///
  /// In ja, this message translates to:
  /// **'なにもしない'**
  String get noneAction;

  /// No description provided for @pleaseInput.
  ///
  /// In ja, this message translates to:
  /// **'入れてや'**
  String get pleaseInput;

  /// No description provided for @pleaseSelect.
  ///
  /// In ja, this message translates to:
  /// **'選んでや'**
  String get pleaseSelect;

  /// No description provided for @login.
  ///
  /// In ja, this message translates to:
  /// **'ログイン'**
  String get login;

  /// No description provided for @settings.
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get settings;

  /// No description provided for @ad.
  ///
  /// In ja, this message translates to:
  /// **'広告'**
  String get ad;

  /// No description provided for @customEmoji.
  ///
  /// In ja, this message translates to:
  /// **'カスタム絵文字'**
  String get customEmoji;

  /// No description provided for @localTimeline.
  ///
  /// In ja, this message translates to:
  /// **'ローカルタイムライン'**
  String get localTimeline;

  /// No description provided for @localTimelineAbbr.
  ///
  /// In ja, this message translates to:
  /// **'LTL'**
  String get localTimelineAbbr;

  /// No description provided for @homeTimeline.
  ///
  /// In ja, this message translates to:
  /// **'ホームタイムライン'**
  String get homeTimeline;

  /// No description provided for @homeTimelineAbbr.
  ///
  /// In ja, this message translates to:
  /// **'HTL'**
  String get homeTimelineAbbr;

  /// No description provided for @socialTimeline.
  ///
  /// In ja, this message translates to:
  /// **'ソーシャルタイムライン'**
  String get socialTimeline;

  /// No description provided for @socialTimelineAbbr.
  ///
  /// In ja, this message translates to:
  /// **'STL'**
  String get socialTimelineAbbr;

  /// No description provided for @globalTimeline.
  ///
  /// In ja, this message translates to:
  /// **'グローバルタイムライン'**
  String get globalTimeline;

  /// No description provided for @roleTimeline.
  ///
  /// In ja, this message translates to:
  /// **'ロールタイムライン'**
  String get roleTimeline;

  /// No description provided for @server.
  ///
  /// In ja, this message translates to:
  /// **'サーバー'**
  String get server;

  /// No description provided for @miAuth.
  ///
  /// In ja, this message translates to:
  /// **'MiAuth'**
  String get miAuth;

  /// No description provided for @apiKey.
  ///
  /// In ja, this message translates to:
  /// **'APIキー'**
  String get apiKey;

  /// No description provided for @contentWarning.
  ///
  /// In ja, this message translates to:
  /// **'注釈'**
  String get contentWarning;

  /// No description provided for @follower.
  ///
  /// In ja, this message translates to:
  /// **'フォロワー'**
  String get follower;

  /// No description provided for @sending.
  ///
  /// In ja, this message translates to:
  /// **'送信中'**
  String get sending;

  /// No description provided for @antennaName.
  ///
  /// In ja, this message translates to:
  /// **'アンテナの名前'**
  String get antennaName;

  /// No description provided for @antennaSource.
  ///
  /// In ja, this message translates to:
  /// **'アンテナのソース'**
  String get antennaSource;

  /// No description provided for @antennaSourceHome.
  ///
  /// In ja, this message translates to:
  /// **'ホーム'**
  String get antennaSourceHome;

  /// No description provided for @antennaSourceAll.
  ///
  /// In ja, this message translates to:
  /// **'ぜんぶ'**
  String get antennaSourceAll;

  /// No description provided for @antennaSourceUser.
  ///
  /// In ja, this message translates to:
  /// **'ユーザー'**
  String get antennaSourceUser;

  /// No description provided for @antennaSourceList.
  ///
  /// In ja, this message translates to:
  /// **'リスト'**
  String get antennaSourceList;

  /// No description provided for @selectAntennaSource.
  ///
  /// In ja, this message translates to:
  /// **'ソースを選択'**
  String get selectAntennaSource;

  /// No description provided for @selectList.
  ///
  /// In ja, this message translates to:
  /// **'リストを選択'**
  String get selectList;

  /// No description provided for @antennaSourceUserHintText.
  ///
  /// In ja, this message translates to:
  /// **'ユーザーネームを改行で区切って指定します'**
  String get antennaSourceUserHintText;

  /// No description provided for @addUser.
  ///
  /// In ja, this message translates to:
  /// **'ユーザーを追加'**
  String get addUser;

  /// No description provided for @keywords.
  ///
  /// In ja, this message translates to:
  /// **'キーワード'**
  String get keywords;

  /// No description provided for @antennaSourceKeywordsHintText.
  ///
  /// In ja, this message translates to:
  /// **'スペースで区切った単語はAND条件で、改行で区切った行はOR条件で扱います'**
  String get antennaSourceKeywordsHintText;

  /// No description provided for @excludeKeywords.
  ///
  /// In ja, this message translates to:
  /// **'除外キーワード'**
  String get excludeKeywords;

  /// No description provided for @antennaSourceExcludeKeywordsHintText.
  ///
  /// In ja, this message translates to:
  /// **'スペースで区切った単語はAND条件で、改行で区切った行はOR条件で扱います'**
  String get antennaSourceExcludeKeywordsHintText;

  /// No description provided for @discriminateUpperLower.
  ///
  /// In ja, this message translates to:
  /// **'大文字と小文字を区別する'**
  String get discriminateUpperLower;

  /// No description provided for @receiveReplies.
  ///
  /// In ja, this message translates to:
  /// **'リプライを受信する'**
  String get receiveReplies;

  /// No description provided for @receiveOnlyFiles.
  ///
  /// In ja, this message translates to:
  /// **'ファイル付きのノートのみ受信する'**
  String get receiveOnlyFiles;

  /// No description provided for @receiveLocal.
  ///
  /// In ja, this message translates to:
  /// **'ローカルのみ受信する'**
  String get receiveLocal;

  /// No description provided for @receiveLocalAvailability.
  ///
  /// In ja, this message translates to:
  /// **'ローカルのみの指定はMisskey 2023.10.2以降で有効です。'**
  String get receiveLocalAvailability;

  /// No description provided for @confirmDeletingAntenna.
  ///
  /// In ja, this message translates to:
  /// **'アンテナ削除するか？'**
  String get confirmDeletingAntenna;

  /// チャンネルの参加人数
  ///
  /// In ja, this message translates to:
  /// **'{usersCount}人が参加中'**
  String channelJoinningCounts(int usersCount);

  /// チャンネルのノート数
  ///
  /// In ja, this message translates to:
  /// **'{notesCount}投稿'**
  String channelNotes(int notesCount);

  /// チャンネルのノート数
  ///
  /// In ja, this message translates to:
  /// **'{lastNotedAt} に更新'**
  String channelLastNotedAt(String lastNotedAt);

  /// No description provided for @thisChannelIsArchived.
  ///
  /// In ja, this message translates to:
  /// **'このチャンネルはアーカイブされています'**
  String get thisChannelIsArchived;

  /// No description provided for @favorited.
  ///
  /// In ja, this message translates to:
  /// **'お気に入り中'**
  String get favorited;

  /// No description provided for @willFavorite.
  ///
  /// In ja, this message translates to:
  /// **'お気に入りに入れるで'**
  String get willFavorite;

  /// No description provided for @willFollow.
  ///
  /// In ja, this message translates to:
  /// **'フォローするで'**
  String get willFollow;

  /// No description provided for @channelInformation.
  ///
  /// In ja, this message translates to:
  /// **'チャンネル情報'**
  String get channelInformation;

  /// チャンネルの統計情報
  ///
  /// In ja, this message translates to:
  /// **'{notesCount} 投稿 / {usersCount} 人が参加中 / {lastNotedAt} に更新'**
  String channelStatistics(int notesCount, int usersCount, String lastNotedAt);

  /// No description provided for @notImplemented.
  ///
  /// In ja, this message translates to:
  /// **'作成中'**
  String get notImplemented;

  /// No description provided for @createClip.
  ///
  /// In ja, this message translates to:
  /// **'クリップを作成'**
  String get createClip;

  /// No description provided for @confirmDeleteClip.
  ///
  /// In ja, this message translates to:
  /// **'このクリップ削除してええか？'**
  String get confirmDeleteClip;

  /// No description provided for @clipName.
  ///
  /// In ja, this message translates to:
  /// **'クリップ名'**
  String get clipName;

  /// No description provided for @clipDescription.
  ///
  /// In ja, this message translates to:
  /// **'説明（省略してもええよ）'**
  String get clipDescription;

  /// No description provided for @alreadyAddedClip.
  ///
  /// In ja, this message translates to:
  /// **'すでにクリップに追加されてるノートみたいやねん'**
  String get alreadyAddedClip;

  /// No description provided for @deleteClip.
  ///
  /// In ja, this message translates to:
  /// **'クリップから削除する'**
  String get deleteClip;

  /// No description provided for @thanksForReport.
  ///
  /// In ja, this message translates to:
  /// **'内容が送信されました。ご報告ありがとうございました。'**
  String get thanksForReport;

  /// No description provided for @reportAbuseOf.
  ///
  /// In ja, this message translates to:
  /// **'{userName} を通報する'**
  String reportAbuseOf(String userName);

  /// No description provided for @pleaseInputReasonWhyAbuse.
  ///
  /// In ja, this message translates to:
  /// **'通報理由の詳細を記入してください。対象のノートがある場合はそのURLも記入してください。'**
  String get pleaseInputReasonWhyAbuse;

  /// No description provided for @reportAbuse.
  ///
  /// In ja, this message translates to:
  /// **'通報する'**
  String get reportAbuse;

  /// No description provided for @closeTweet.
  ///
  /// In ja, this message translates to:
  /// **'ツイートを閉じる'**
  String get closeTweet;

  /// No description provided for @closePlayer.
  ///
  /// In ja, this message translates to:
  /// **'プレイヤーを閉じる'**
  String get closePlayer;

  /// No description provided for @doneCopy.
  ///
  /// In ja, this message translates to:
  /// **'コピーしたで'**
  String get doneCopy;

  /// No description provided for @mutedNotePlaceholder.
  ///
  /// In ja, this message translates to:
  /// **'{userName}が何か言うとるわ'**
  String mutedNotePlaceholder(String userName);

  /// No description provided for @showCw.
  ///
  /// In ja, this message translates to:
  /// **'隠してあるのんの続きを見して'**
  String get showCw;

  /// No description provided for @showReactionedNote.
  ///
  /// In ja, this message translates to:
  /// **'続きを表示'**
  String get showReactionedNote;

  /// No description provided for @showLongText.
  ///
  /// In ja, this message translates to:
  /// **'続きを表示'**
  String get showLongText;

  /// No description provided for @showMoreFiles.
  ///
  /// In ja, this message translates to:
  /// **'続きを表示'**
  String get showMoreFiles;

  /// No description provided for @otherReactions.
  ///
  /// In ja, this message translates to:
  /// **'ほか{reactionCounts}個'**
  String otherReactions(int reactionCounts);

  /// No description provided for @confirmDeleteReaction.
  ///
  /// In ja, this message translates to:
  /// **'リアクション取り消してもええか？'**
  String get confirmDeleteReaction;

  /// No description provided for @cancelReaction.
  ///
  /// In ja, this message translates to:
  /// **'取り消す'**
  String get cancelReaction;

  /// No description provided for @renotedBy.
  ///
  /// In ja, this message translates to:
  /// **'がリノート'**
  String get renotedBy;

  /// No description provided for @selfRenotedBy.
  ///
  /// In ja, this message translates to:
  /// **'がセルフリノート'**
  String get selfRenotedBy;

  /// No description provided for @savedImage.
  ///
  /// In ja, this message translates to:
  /// **'画像保存したで'**
  String get savedImage;

  /// No description provided for @tapToShow.
  ///
  /// In ja, this message translates to:
  /// **'タップして表示'**
  String get tapToShow;

  /// No description provided for @copyContents.
  ///
  /// In ja, this message translates to:
  /// **'内容をコピー'**
  String get copyContents;

  /// No description provided for @copyLinks.
  ///
  /// In ja, this message translates to:
  /// **'リンクをコピー'**
  String get copyLinks;

  /// No description provided for @copyName.
  ///
  /// In ja, this message translates to:
  /// **'ユーザー名をコピー'**
  String get copyName;

  /// No description provided for @copyUserScreenName.
  ///
  /// In ja, this message translates to:
  /// **'ユーザースクリーン名をコピー'**
  String get copyUserScreenName;

  /// No description provided for @openBrowsers.
  ///
  /// In ja, this message translates to:
  /// **'ブラウザで開く'**
  String get openBrowsers;

  /// No description provided for @openBrowsersAsRemote.
  ///
  /// In ja, this message translates to:
  /// **'ブラウザでリモート先を開く'**
  String get openBrowsersAsRemote;

  /// No description provided for @openInAnotherAccount.
  ///
  /// In ja, this message translates to:
  /// **'別のアカウントで開く'**
  String get openInAnotherAccount;

  /// No description provided for @openNoteInBrowsers.
  ///
  /// In ja, this message translates to:
  /// **'ブラウザでノートを開く'**
  String get openNoteInBrowsers;

  /// No description provided for @changeFullScreen.
  ///
  /// In ja, this message translates to:
  /// **'フルスクリーンに切り替え'**
  String get changeFullScreen;

  /// No description provided for @shareNotes.
  ///
  /// In ja, this message translates to:
  /// **'ノートを共有'**
  String get shareNotes;

  /// No description provided for @deleteFavorite.
  ///
  /// In ja, this message translates to:
  /// **'お気に入り解除'**
  String get deleteFavorite;

  /// No description provided for @notesAfterRenote.
  ///
  /// In ja, this message translates to:
  /// **'リノート直後のノート'**
  String get notesAfterRenote;

  /// No description provided for @deletedRecreate.
  ///
  /// In ja, this message translates to:
  /// **'削除してなおす'**
  String get deletedRecreate;

  /// No description provided for @confirmDeletedRecreate.
  ///
  /// In ja, this message translates to:
  /// **'このノート消してなおす？ついたリアクション、リノート、返信は消えて戻らへんで？'**
  String get confirmDeletedRecreate;

  /// No description provided for @deleteRenote.
  ///
  /// In ja, this message translates to:
  /// **'リノートを解除する'**
  String get deleteRenote;

  /// No description provided for @confirmDelete.
  ///
  /// In ja, this message translates to:
  /// **'ほんまに消してええな？'**
  String get confirmDelete;

  /// No description provided for @doDeleting.
  ///
  /// In ja, this message translates to:
  /// **'消す！'**
  String get doDeleting;

  /// No description provided for @confirmPoll.
  ///
  /// In ja, this message translates to:
  /// **'{choiced}に投票しますか？'**
  String confirmPoll(String choiced);

  /// No description provided for @votesCount.
  ///
  /// In ja, this message translates to:
  /// **'({votes}票)'**
  String votesCount(int votes);

  /// No description provided for @totalVotesCount.
  ///
  /// In ja, this message translates to:
  /// **'計{votes}票・'**
  String totalVotesCount(int votes);

  /// No description provided for @finished.
  ///
  /// In ja, this message translates to:
  /// **'終了済み'**
  String get finished;

  /// No description provided for @openResult.
  ///
  /// In ja, this message translates to:
  /// **'結果を見る'**
  String get openResult;

  /// No description provided for @doVoting.
  ///
  /// In ja, this message translates to:
  /// **'投票する'**
  String get doVoting;

  /// No description provided for @alreadyVoted.
  ///
  /// In ja, this message translates to:
  /// **'投票済み'**
  String get alreadyVoted;

  /// No description provided for @remainDiffer.
  ///
  /// In ja, this message translates to:
  /// **'あと{differ}'**
  String remainDiffer(String differ);

  /// No description provided for @renoted.
  ///
  /// In ja, this message translates to:
  /// **'リノートしました。'**
  String get renoted;

  /// No description provided for @renoteInSpecificChannel.
  ///
  /// In ja, this message translates to:
  /// **'{channelName}内にリノート'**
  String renoteInSpecificChannel(String channelName);

  /// No description provided for @quotedRenoteInSpecificChannel.
  ///
  /// In ja, this message translates to:
  /// **'{channelName}内に引用'**
  String quotedRenoteInSpecificChannel(String channelName);

  /// No description provided for @renoteInChannel.
  ///
  /// In ja, this message translates to:
  /// **'チャンネルへリノート'**
  String get renoteInChannel;

  /// No description provided for @renoteInOtherChannel.
  ///
  /// In ja, this message translates to:
  /// **'よそのチャンネルへリノート'**
  String get renoteInOtherChannel;

  /// No description provided for @quotedRenoteInChannel.
  ///
  /// In ja, this message translates to:
  /// **'チャンネルへ引用'**
  String get quotedRenoteInChannel;

  /// No description provided for @quotedRenoteInOtherChannel.
  ///
  /// In ja, this message translates to:
  /// **'よそのチャンネルへ引用'**
  String get quotedRenoteInOtherChannel;

  /// No description provided for @renotedUsers.
  ///
  /// In ja, this message translates to:
  /// **'リノートしたユーザー'**
  String get renotedUsers;

  /// No description provided for @otherComplementReactions.
  ///
  /// In ja, this message translates to:
  /// **'他のん'**
  String get otherComplementReactions;

  /// No description provided for @openAsOtherAccount.
  ///
  /// In ja, this message translates to:
  /// **'開くアカウントを選んでや'**
  String get openAsOtherAccount;

  /// No description provided for @pickColor.
  ///
  /// In ja, this message translates to:
  /// **'色を選んでや'**
  String get pickColor;

  /// No description provided for @decideColor.
  ///
  /// In ja, this message translates to:
  /// **'これにする'**
  String get decideColor;

  /// No description provided for @accountSetting.
  ///
  /// In ja, this message translates to:
  /// **'{accountName}の設定'**
  String accountSetting(String accountName);

  /// No description provided for @chooseFile.
  ///
  /// In ja, this message translates to:
  /// **'ファイルを選択'**
  String get chooseFile;

  /// No description provided for @uploadFile.
  ///
  /// In ja, this message translates to:
  /// **'アップロード'**
  String get uploadFile;

  /// No description provided for @fromDrive.
  ///
  /// In ja, this message translates to:
  /// **'ドライブから'**
  String get fromDrive;

  /// No description provided for @fileName.
  ///
  /// In ja, this message translates to:
  /// **'ファイル名'**
  String get fileName;

  /// No description provided for @randomizeFileName.
  ///
  /// In ja, this message translates to:
  /// **'ファイル名をランダムにする'**
  String get randomizeFileName;

  /// No description provided for @caption.
  ///
  /// In ja, this message translates to:
  /// **'キャプション'**
  String get caption;

  /// No description provided for @sensitiveSubTitle.
  ///
  /// In ja, this message translates to:
  /// **'閲覧注意の設定を外した場合でも、自動で閲覧注意にマークされることがあります。'**
  String get sensitiveSubTitle;

  /// No description provided for @replyNotePlaceholder.
  ///
  /// In ja, this message translates to:
  /// **'何て送る？'**
  String get replyNotePlaceholder;

  /// No description provided for @defaultNotePlaceholder.
  ///
  /// In ja, this message translates to:
  /// **'何してはる？'**
  String get defaultNotePlaceholder;

  /// No description provided for @hasMediaButCannotEdit.
  ///
  /// In ja, this message translates to:
  /// **'メディアがあります（編集はできません）'**
  String get hasMediaButCannotEdit;

  /// No description provided for @hasVoteButCannotEdit.
  ///
  /// In ja, this message translates to:
  /// **'投票があります（編集はできません）'**
  String get hasVoteButCannotEdit;

  /// No description provided for @followedNotification.
  ///
  /// In ja, this message translates to:
  /// **'{userName}からフォローされたで'**
  String followedNotification(String userName);

  /// No description provided for @followRequestAcceptedNotification.
  ///
  /// In ja, this message translates to:
  /// **'{userName}がフォローしてもええでってなったで'**
  String followRequestAcceptedNotification(String userName);

  /// No description provided for @receiveFollowRequestNotification.
  ///
  /// In ja, this message translates to:
  /// **'{userName}がフォローさせてほしそうにしてるで'**
  String receiveFollowRequestNotification(String userName);

  /// No description provided for @achievementEarnedNotification.
  ///
  /// In ja, this message translates to:
  /// **'実績を解除したみたいや'**
  String get achievementEarnedNotification;

  /// No description provided for @testNotification.
  ///
  /// In ja, this message translates to:
  /// **'テストやで'**
  String get testNotification;

  /// No description provided for @renotedUsersInNotification.
  ///
  /// In ja, this message translates to:
  /// **'リノートしてくれはった人'**
  String get renotedUsersInNotification;

  /// No description provided for @reactionUsersInNotification.
  ///
  /// In ja, this message translates to:
  /// **'リアクションしてくれはった人'**
  String get reactionUsersInNotification;

  /// No description provided for @finishedVotedNotification.
  ///
  /// In ja, this message translates to:
  /// **'投票が終わったみたいや'**
  String get finishedVotedNotification;

  /// No description provided for @renoteAndReactionsNotification.
  ///
  /// In ja, this message translates to:
  /// **'{reactionUser}さんたちがリアクションしはって、{renotedUser}さんたちがリノートしはったで'**
  String renoteAndReactionsNotification(
    String? reactionUser,
    String? renotedUser,
  );

  /// No description provided for @renoteNotification.
  ///
  /// In ja, this message translates to:
  /// **'{renoteUser}さんたちがリノートしはったで'**
  String renoteNotification(String? renoteUser);

  /// No description provided for @reactionNotification.
  ///
  /// In ja, this message translates to:
  /// **'{reactionUser}さんたちがリアクションしはったで'**
  String reactionNotification(String? reactionUser);

  /// No description provided for @notedNotification.
  ///
  /// In ja, this message translates to:
  /// **'{notedUser}さんがノートしはったで'**
  String notedNotification(String notedUser);

  /// No description provided for @roleAssignedNotification.
  ///
  /// In ja, this message translates to:
  /// **'ロール「{role}」に入れられたみたいや'**
  String roleAssignedNotification(String role);

  /// No description provided for @appNotification.
  ///
  /// In ja, this message translates to:
  /// **'なんかのアプリからの通知らしいわ'**
  String get appNotification;

  /// No description provided for @someoneLogined.
  ///
  /// In ja, this message translates to:
  /// **'自分のアカウントにログインがあったらしいで'**
  String get someoneLogined;

  /// No description provided for @unknownNotification.
  ///
  /// In ja, this message translates to:
  /// **'知らんタイプの通知やわ'**
  String get unknownNotification;

  /// No description provided for @messageForFollower.
  ///
  /// In ja, this message translates to:
  /// **'フォロワーへ 「{message}」'**
  String messageForFollower(String message);

  /// No description provided for @notificationAll.
  ///
  /// In ja, this message translates to:
  /// **'みんな'**
  String get notificationAll;

  /// No description provided for @notificationForMe.
  ///
  /// In ja, this message translates to:
  /// **'自分宛て'**
  String get notificationForMe;

  /// No description provided for @notificationDirect.
  ///
  /// In ja, this message translates to:
  /// **'ダイレクト'**
  String get notificationDirect;

  /// No description provided for @editPhoto.
  ///
  /// In ja, this message translates to:
  /// **'写真編集'**
  String get editPhoto;

  /// No description provided for @customEmojiLicensedBy.
  ///
  /// In ja, this message translates to:
  /// **'このカスタム絵文字はこのようにライセンスされています。'**
  String get customEmojiLicensedBy;

  /// No description provided for @customEmojiLicensedByNone.
  ///
  /// In ja, this message translates to:
  /// **'※このカスタム絵文字に対してライセンスは設定されていません。'**
  String get customEmojiLicensedByNone;

  /// No description provided for @cancelEmojiChoosing.
  ///
  /// In ja, this message translates to:
  /// **'わからへんからやめとく'**
  String get cancelEmojiChoosing;

  /// No description provided for @doneEmojiChoosing.
  ///
  /// In ja, this message translates to:
  /// **'使ってもだいじょうぶ'**
  String get doneEmojiChoosing;

  /// No description provided for @confirmSavingPhoto.
  ///
  /// In ja, this message translates to:
  /// **'保存しよる？'**
  String get confirmSavingPhoto;

  /// No description provided for @doneEditingPhoto.
  ///
  /// In ja, this message translates to:
  /// **'保存する'**
  String get doneEditingPhoto;

  /// No description provided for @continueEditingPhoto.
  ///
  /// In ja, this message translates to:
  /// **'もうちょっと続ける'**
  String get continueEditingPhoto;

  /// No description provided for @disabledUsingSensitiveCustomEmoji.
  ///
  /// In ja, this message translates to:
  /// **'ここでセンシティブなカスタム絵文字使われへんねやわ'**
  String get disabledUsingSensitiveCustomEmoji;

  /// No description provided for @markAsSensitive.
  ///
  /// In ja, this message translates to:
  /// **'センシティブとしてマークする'**
  String get markAsSensitive;

  /// No description provided for @publicSubTitle.
  ///
  /// In ja, this message translates to:
  /// **'みんなに公開'**
  String get publicSubTitle;

  /// No description provided for @homeSubTitle.
  ///
  /// In ja, this message translates to:
  /// **'ホームタイムラインのみに公開'**
  String get homeSubTitle;

  /// No description provided for @followersSubTitle.
  ///
  /// In ja, this message translates to:
  /// **'自分のフォロワーのみに公開'**
  String get followersSubTitle;

  /// No description provided for @specifiedSubTitle.
  ///
  /// In ja, this message translates to:
  /// **'選択したユーザーのみに公開'**
  String get specifiedSubTitle;

  /// No description provided for @favoriteAll.
  ///
  /// In ja, this message translates to:
  /// **'すべて'**
  String get favoriteAll;

  /// No description provided for @favoriteLikeOnly.
  ///
  /// In ja, this message translates to:
  /// **'いいねのみ'**
  String get favoriteLikeOnly;

  /// No description provided for @favoriteLikeOnlyForRemote.
  ///
  /// In ja, this message translates to:
  /// **'リモートからはいいねのみ'**
  String get favoriteLikeOnlyForRemote;

  /// No description provided for @favoriteNonSensitiveOnly.
  ///
  /// In ja, this message translates to:
  /// **'非センシティブのみ'**
  String get favoriteNonSensitiveOnly;

  /// No description provided for @favoriteNonSensitiveOnlyAndLikeOnlyForRemote.
  ///
  /// In ja, this message translates to:
  /// **'非センシティブのみ（リモートからはいいねのみ）'**
  String get favoriteNonSensitiveOnlyAndLikeOnlyForRemote;

  /// No description provided for @replyTo.
  ///
  /// In ja, this message translates to:
  /// **'返信先'**
  String get replyTo;

  /// No description provided for @addChoice.
  ///
  /// In ja, this message translates to:
  /// **'増やす'**
  String get addChoice;

  /// No description provided for @choiceNumber.
  ///
  /// In ja, this message translates to:
  /// **'回答{choice}'**
  String choiceNumber(int choice);

  /// No description provided for @canMultipleChoice.
  ///
  /// In ja, this message translates to:
  /// **'複数回答'**
  String get canMultipleChoice;

  /// No description provided for @disabledInHashtag.
  ///
  /// In ja, this message translates to:
  /// **'これらはハッシュタグでは機能しません。'**
  String get disabledInHashtag;

  /// No description provided for @joiningHashtagUsers.
  ///
  /// In ja, this message translates to:
  /// **'{usersCount}<small>人</small>'**
  String joiningHashtagUsers(int usersCount);

  /// No description provided for @searchVoteTab.
  ///
  /// In ja, this message translates to:
  /// **'アンケート'**
  String get searchVoteTab;

  /// No description provided for @allocatedRolesCount.
  ///
  /// In ja, this message translates to:
  /// **'{usersCount}<small>人</small>'**
  String allocatedRolesCount(int usersCount);

  /// No description provided for @pageWrittenBy.
  ///
  /// In ja, this message translates to:
  /// **'このページ書きはった人'**
  String get pageWrittenBy;

  /// No description provided for @pageCreatedAt.
  ///
  /// In ja, this message translates to:
  /// **'作成日: {createdAt}'**
  String pageCreatedAt(DateTime createdAt);

  /// No description provided for @pageUpdatedAt.
  ///
  /// In ja, this message translates to:
  /// **'更新日: {updatedAt}'**
  String pageUpdatedAt(DateTime updatedAt);

  /// No description provided for @unsupportedPage.
  ///
  /// In ja, this message translates to:
  /// **'Miriaが対応してないページやわ　ブラウザで見てな'**
  String get unsupportedPage;

  /// No description provided for @canNotFavoriteMyPage.
  ///
  /// In ja, this message translates to:
  /// **'自分のページにはふぁぼつけられへんねん'**
  String get canNotFavoriteMyPage;

  /// No description provided for @activeAnnouncements.
  ///
  /// In ja, this message translates to:
  /// **'いまの'**
  String get activeAnnouncements;

  /// No description provided for @inactiveAnnouncements.
  ///
  /// In ja, this message translates to:
  /// **'まえの'**
  String get inactiveAnnouncements;

  /// No description provided for @announcementsForYou.
  ///
  /// In ja, this message translates to:
  /// **'あんた宛'**
  String get announcementsForYou;

  /// No description provided for @confirmAnnouncementsRead.
  ///
  /// In ja, this message translates to:
  /// **'「{title}」の内容ちゃんと読んだか？'**
  String confirmAnnouncementsRead(Object title);

  /// No description provided for @readAnnouncement.
  ///
  /// In ja, this message translates to:
  /// **'読んだ'**
  String get readAnnouncement;

  /// No description provided for @didNotReadAnnouncement.
  ///
  /// In ja, this message translates to:
  /// **'もうちょい待って'**
  String get didNotReadAnnouncement;

  /// No description provided for @onlineUsers.
  ///
  /// In ja, this message translates to:
  /// **'サーバーオンライン人数'**
  String get onlineUsers;

  /// No description provided for @onlineUsersCount.
  ///
  /// In ja, this message translates to:
  /// **'{usersCount}<small>人</small>'**
  String onlineUsersCount(int usersCount, Object n);

  /// No description provided for @cpuUsageRate.
  ///
  /// In ja, this message translates to:
  /// **'CPU使用率'**
  String get cpuUsageRate;

  /// No description provided for @memoryUsageRate.
  ///
  /// In ja, this message translates to:
  /// **'メモリ使用率'**
  String get memoryUsageRate;

  /// No description provided for @responseTime.
  ///
  /// In ja, this message translates to:
  /// **'応答時間'**
  String get responseTime;

  /// No description provided for @inboxQueue.
  ///
  /// In ja, this message translates to:
  /// **'ジョブキュー (Inbox queue)'**
  String get inboxQueue;

  /// No description provided for @inboxProcessQueue.
  ///
  /// In ja, this message translates to:
  /// **'Process'**
  String get inboxProcessQueue;

  /// No description provided for @inboxActiveQueue.
  ///
  /// In ja, this message translates to:
  /// **'Active'**
  String get inboxActiveQueue;

  /// No description provided for @inboxDelayedQueue.
  ///
  /// In ja, this message translates to:
  /// **'Delayed'**
  String get inboxDelayedQueue;

  /// No description provided for @inboxWaitingQueue.
  ///
  /// In ja, this message translates to:
  /// **'Waiting'**
  String get inboxWaitingQueue;

  /// No description provided for @deliverQueue.
  ///
  /// In ja, this message translates to:
  /// **'ジョブキュー (Deliver queue)'**
  String get deliverQueue;

  /// No description provided for @deliverProcessQueue.
  ///
  /// In ja, this message translates to:
  /// **'Process'**
  String get deliverProcessQueue;

  /// No description provided for @deliverActiveQueue.
  ///
  /// In ja, this message translates to:
  /// **'Active'**
  String get deliverActiveQueue;

  /// No description provided for @deliverDelayedQueue.
  ///
  /// In ja, this message translates to:
  /// **'Delayed'**
  String get deliverDelayedQueue;

  /// No description provided for @deliverWaitingQueue.
  ///
  /// In ja, this message translates to:
  /// **'Waiting'**
  String get deliverWaitingQueue;

  /// No description provided for @persons.
  ///
  /// In ja, this message translates to:
  /// **'人'**
  String get persons;

  /// No description provided for @milliSeconds.
  ///
  /// In ja, this message translates to:
  /// **'ミリ秒'**
  String get milliSeconds;

  /// No description provided for @pinnedUser.
  ///
  /// In ja, this message translates to:
  /// **'ピンどめ'**
  String get pinnedUser;

  /// No description provided for @sort.
  ///
  /// In ja, this message translates to:
  /// **'並び順'**
  String get sort;

  /// No description provided for @joiningServerUsers.
  ///
  /// In ja, this message translates to:
  /// **'{usersCount}人が参加中'**
  String joiningServerUsers(int usersCount);

  /// No description provided for @serverInformation.
  ///
  /// In ja, this message translates to:
  /// **'サーバー情報'**
  String get serverInformation;

  /// No description provided for @loginAsMiAuth.
  ///
  /// In ja, this message translates to:
  /// **'MiAuthでログイン'**
  String get loginAsMiAuth;

  /// No description provided for @loginAsAPIKey.
  ///
  /// In ja, this message translates to:
  /// **'APIキーでログイン'**
  String get loginAsAPIKey;

  /// No description provided for @authorizate.
  ///
  /// In ja, this message translates to:
  /// **'認証をする'**
  String get authorizate;

  /// No description provided for @reauthorizate.
  ///
  /// In ja, this message translates to:
  /// **'再度認証をする'**
  String get reauthorizate;

  /// No description provided for @chooseLoginServer.
  ///
  /// In ja, this message translates to:
  /// **'ログインするサーバーを選んでください'**
  String get chooseLoginServer;

  /// No description provided for @didAuthorize.
  ///
  /// In ja, this message translates to:
  /// **'認証してきた'**
  String get didAuthorize;

  /// No description provided for @thrownConnectionError.
  ///
  /// In ja, this message translates to:
  /// **'通信に失敗しました。'**
  String get thrownConnectionError;

  /// No description provided for @thrownConnectionTimeout.
  ///
  /// In ja, this message translates to:
  /// **'タイムアウトしました。'**
  String get thrownConnectionTimeout;

  /// No description provided for @thrownWebSocketException.
  ///
  /// In ja, this message translates to:
  /// **'通信に失敗しました。'**
  String get thrownWebSocketException;

  /// No description provided for @thrownTimeoutException.
  ///
  /// In ja, this message translates to:
  /// **'サーバーが応答してくれませんでした。'**
  String get thrownTimeoutException;

  /// No description provided for @thrownUnknownError.
  ///
  /// In ja, this message translates to:
  /// **'不明なエラー'**
  String get thrownUnknownError;

  /// No description provided for @thrownError.
  ///
  /// In ja, this message translates to:
  /// **'エラーが起きたみたいや'**
  String get thrownError;

  /// No description provided for @unsupportedServer.
  ///
  /// In ja, this message translates to:
  /// **'非対応のサーバーです'**
  String get unsupportedServer;

  /// No description provided for @future.
  ///
  /// In ja, this message translates to:
  /// **'未来'**
  String get future;

  /// No description provided for @justNow.
  ///
  /// In ja, this message translates to:
  /// **'たったいま'**
  String get justNow;

  /// No description provided for @secondsAgo.
  ///
  /// In ja, this message translates to:
  /// **'{n}秒前'**
  String secondsAgo(int n);

  /// No description provided for @minutesAgo.
  ///
  /// In ja, this message translates to:
  /// **'{n}分前'**
  String minutesAgo(int n);

  /// No description provided for @hoursAgo.
  ///
  /// In ja, this message translates to:
  /// **'{n}時間前'**
  String hoursAgo(int n);

  /// No description provided for @daysAgo.
  ///
  /// In ja, this message translates to:
  /// **'{n}日前'**
  String daysAgo(int n);

  /// No description provided for @yearsAgo.
  ///
  /// In ja, this message translates to:
  /// **'{n}年前'**
  String yearsAgo(int n);

  /// No description provided for @inSeconds.
  ///
  /// In ja, this message translates to:
  /// **'{n}秒後'**
  String inSeconds(int n);

  /// No description provided for @inMinutes.
  ///
  /// In ja, this message translates to:
  /// **'{n}分後'**
  String inMinutes(int n);

  /// No description provided for @inHours.
  ///
  /// In ja, this message translates to:
  /// **'{n}時間後'**
  String inHours(int n);

  /// No description provided for @inDays.
  ///
  /// In ja, this message translates to:
  /// **'{n}日後'**
  String inDays(int n);

  /// No description provided for @inYears.
  ///
  /// In ja, this message translates to:
  /// **'{n}年後'**
  String inYears(int n);

  /// No description provided for @nSeconds.
  ///
  /// In ja, this message translates to:
  /// **'{n, plural, other {{n}秒}}'**
  String nSeconds(int n);

  /// No description provided for @nMinutes.
  ///
  /// In ja, this message translates to:
  /// **'{n, plural, other {{n}分}}'**
  String nMinutes(int n);

  /// No description provided for @nHours.
  ///
  /// In ja, this message translates to:
  /// **'{n, plural, other {{n}時間}}'**
  String nHours(int n);

  /// No description provided for @nDays.
  ///
  /// In ja, this message translates to:
  /// **'{n, plural, other {{n}日}}'**
  String nDays(int n);

  /// No description provided for @lightMode.
  ///
  /// In ja, this message translates to:
  /// **'ライトモード'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In ja, this message translates to:
  /// **'ダークモード'**
  String get darkMode;

  /// No description provided for @syncWithSystem.
  ///
  /// In ja, this message translates to:
  /// **'デバイスの設定にしたがう'**
  String get syncWithSystem;

  /// No description provided for @hideSensitiveMedia.
  ///
  /// In ja, this message translates to:
  /// **'閲覧注意のメディアは隠す'**
  String get hideSensitiveMedia;

  /// No description provided for @showSensitiveMedia.
  ///
  /// In ja, this message translates to:
  /// **'閲覧注意のメディアを隠さない'**
  String get showSensitiveMedia;

  /// No description provided for @hideAllMedia.
  ///
  /// In ja, this message translates to:
  /// **'常にメディアを隠す'**
  String get hideAllMedia;

  /// No description provided for @removeSensitiveNotes.
  ///
  /// In ja, this message translates to:
  /// **'TLで閲覧注意つきのノートを表示しない'**
  String get removeSensitiveNotes;

  /// No description provided for @enableInfiniteScroll.
  ///
  /// In ja, this message translates to:
  /// **'自動で次を読み込む'**
  String get enableInfiniteScroll;

  /// No description provided for @disableInfiniteScroll.
  ///
  /// In ja, this message translates to:
  /// **'自動で読み込まない'**
  String get disableInfiniteScroll;

  /// No description provided for @top.
  ///
  /// In ja, this message translates to:
  /// **'上'**
  String get top;

  /// No description provided for @bottom.
  ///
  /// In ja, this message translates to:
  /// **'下'**
  String get bottom;

  /// No description provided for @systemEmoji.
  ///
  /// In ja, this message translates to:
  /// **'標準'**
  String get systemEmoji;

  /// No description provided for @invalidServer.
  ///
  /// In ja, this message translates to:
  /// **'{server} はサーバーとして認識できませんでした。\nサーバーには、「misskey.io」などを入力してください。'**
  String invalidServer(String server);

  /// No description provided for @serverIsNotMisskey.
  ///
  /// In ja, this message translates to:
  /// **'{server} はMisskeyサーバーとして認識できませんでした。'**
  String serverIsNotMisskey(String server);

  /// No description provided for @softwareNotSupported.
  ///
  /// In ja, this message translates to:
  /// **'Miriaは{software}に未対応です。'**
  String softwareNotSupported(String software);

  /// No description provided for @softwareNotCompatible.
  ///
  /// In ja, this message translates to:
  /// **'Miriaと互換性のないソフトウェアです。\n{software} {version}'**
  String softwareNotCompatible(String software, String version);

  /// No description provided for @alreadyLoggedIn.
  ///
  /// In ja, this message translates to:
  /// **'{acct}で既にログインしています'**
  String alreadyLoggedIn(String acct);

  /// No description provided for @importFromThisFolder.
  ///
  /// In ja, this message translates to:
  /// **'このフォルダーからインポートする'**
  String get importFromThisFolder;

  /// No description provided for @exportedFileNotFound.
  ///
  /// In ja, this message translates to:
  /// **'ここにMiriaの設定ファイルあれへんかったわ'**
  String get exportedFileNotFound;

  /// No description provided for @importCompleted.
  ///
  /// In ja, this message translates to:
  /// **'インポート終わったで。'**
  String get importCompleted;

  /// No description provided for @exportToThisFolder.
  ///
  /// In ja, this message translates to:
  /// **'このフォルダーに保存する'**
  String get exportToThisFolder;

  /// No description provided for @confirmOverwrite.
  ///
  /// In ja, this message translates to:
  /// **'ここにもうあるけど上書きするか？'**
  String get confirmOverwrite;

  /// No description provided for @overwrite.
  ///
  /// In ja, this message translates to:
  /// **'上書きする'**
  String get overwrite;

  /// No description provided for @exportedFileComment.
  ///
  /// In ja, this message translates to:
  /// **'Miria設定ファイル'**
  String get exportedFileComment;

  /// No description provided for @exportCompleted.
  ///
  /// In ja, this message translates to:
  /// **'エクスポート終わったで'**
  String get exportCompleted;

  /// No description provided for @cannotOpenLocalOnlyNoteFromRemote.
  ///
  /// In ja, this message translates to:
  /// **'連合なしのノートを他のサーバーで開くことはできません'**
  String get cannotOpenLocalOnlyNoteFromRemote;

  /// No description provided for @unlimited.
  ///
  /// In ja, this message translates to:
  /// **'無期限'**
  String get unlimited;

  /// No description provided for @specifyByDate.
  ///
  /// In ja, this message translates to:
  /// **'日時指定'**
  String get specifyByDate;

  /// No description provided for @specifyByDuration.
  ///
  /// In ja, this message translates to:
  /// **'期間指定'**
  String get specifyByDuration;

  /// No description provided for @seconds.
  ///
  /// In ja, this message translates to:
  /// **'秒'**
  String get seconds;

  /// No description provided for @minutes.
  ///
  /// In ja, this message translates to:
  /// **'分'**
  String get minutes;

  /// No description provided for @hours.
  ///
  /// In ja, this message translates to:
  /// **'時間'**
  String get hours;

  /// No description provided for @days.
  ///
  /// In ja, this message translates to:
  /// **'日'**
  String get days;

  /// No description provided for @pleaseInputSomething.
  ///
  /// In ja, this message translates to:
  /// **'なんか入れてや'**
  String get pleaseInputSomething;

  /// No description provided for @pleaseAddVoteChoice.
  ///
  /// In ja, this message translates to:
  /// **'投票の選択肢を2つ以上入れてや'**
  String get pleaseAddVoteChoice;

  /// No description provided for @pleaseSpecifyExpirationDate.
  ///
  /// In ja, this message translates to:
  /// **'投票がいつまでか入れてや'**
  String get pleaseSpecifyExpirationDate;

  /// No description provided for @pleaseSpecifyExpirationDuration.
  ///
  /// In ja, this message translates to:
  /// **'投票期間を入れてや'**
  String get pleaseSpecifyExpirationDuration;

  /// No description provided for @cannotMentionToRemoteInLocalOnlyNote.
  ///
  /// In ja, this message translates to:
  /// **'連合オフやのによそのサーバーの人がメンションに含まれてるで'**
  String get cannotMentionToRemoteInLocalOnlyNote;

  /// No description provided for @cannotPublicReplyToPrivateNote.
  ///
  /// In ja, this message translates to:
  /// **'リプライが{visibility}やから、パブリックにでけへん'**
  String cannotPublicReplyToPrivateNote(String visibility);

  /// No description provided for @cannotPublicNoteBySilencedUser.
  ///
  /// In ja, this message translates to:
  /// **'サイレンスロールになっているため、パブリックで投稿することはできません。'**
  String get cannotPublicNoteBySilencedUser;

  /// No description provided for @cannotFederateNoteToChannel.
  ///
  /// In ja, this message translates to:
  /// **'チャンネルのノートを連合にすることはでけへんねん。'**
  String get cannotFederateNoteToChannel;

  /// No description provided for @cannotFederateReplyToLocalOnlyNote.
  ///
  /// In ja, this message translates to:
  /// **'リプライの元ノートが連合なしに設定されとるから、このノートも連合なしにしかでけへんねん。'**
  String get cannotFederateReplyToLocalOnlyNote;

  /// No description provided for @cannotFederateRenoteToLocalOnlyNote.
  ///
  /// In ja, this message translates to:
  /// **'リノートしようとしてるノートが連合なしに設定されとるから、このノートも連合なしにしかでけへんねん。'**
  String get cannotFederateRenoteToLocalOnlyNote;

  /// No description provided for @unexpectedSensitive.
  ///
  /// In ja, this message translates to:
  /// **'上げようとしたファイルがサーバーから、センシティブと思われたんやけどどないする？'**
  String get unexpectedSensitive;

  /// No description provided for @staySensitive.
  ///
  /// In ja, this message translates to:
  /// **'センシティブのままにしとく'**
  String get staySensitive;

  /// No description provided for @unsetSensitive.
  ///
  /// In ja, this message translates to:
  /// **'センシティブやめる'**
  String get unsetSensitive;

  /// No description provided for @noteCreatedAt.
  ///
  /// In ja, this message translates to:
  /// **'投稿時間: {createdAt}'**
  String noteCreatedAt(String createdAt);

  /// No description provided for @accept.
  ///
  /// In ja, this message translates to:
  /// **'許可'**
  String get accept;

  /// No description provided for @reject.
  ///
  /// In ja, this message translates to:
  /// **'拒否'**
  String get reject;

  /// No description provided for @generalSettings.
  ///
  /// In ja, this message translates to:
  /// **'全般設定'**
  String get generalSettings;

  /// No description provided for @accountSettings.
  ///
  /// In ja, this message translates to:
  /// **'アカウント設定'**
  String get accountSettings;

  /// No description provided for @tabSettings.
  ///
  /// In ja, this message translates to:
  /// **'タブ設定'**
  String get tabSettings;

  /// No description provided for @settingsImportAndExport.
  ///
  /// In ja, this message translates to:
  /// **'設定のインポート・エクスポート'**
  String get settingsImportAndExport;

  /// No description provided for @aboutMiria.
  ///
  /// In ja, this message translates to:
  /// **'このアプリについて'**
  String get aboutMiria;

  /// No description provided for @quitAccountSettings.
  ///
  /// In ja, this message translates to:
  /// **'アカウント設定をおわる'**
  String get quitAccountSettings;

  /// No description provided for @packageName.
  ///
  /// In ja, this message translates to:
  /// **'パッケージ名'**
  String get packageName;

  /// No description provided for @version.
  ///
  /// In ja, this message translates to:
  /// **'バージョン'**
  String get version;

  /// No description provided for @developer.
  ///
  /// In ja, this message translates to:
  /// **'開発者'**
  String get developer;

  /// No description provided for @officialWebSite.
  ///
  /// In ja, this message translates to:
  /// **'公式ページ'**
  String get officialWebSite;

  /// No description provided for @openSourceLicense.
  ///
  /// In ja, this message translates to:
  /// **'オープンソースライセンス'**
  String get openSourceLicense;

  /// No description provided for @showLicense.
  ///
  /// In ja, this message translates to:
  /// **'ライセンスを表示する'**
  String get showLicense;

  /// No description provided for @general.
  ///
  /// In ja, this message translates to:
  /// **'全般'**
  String get general;

  /// No description provided for @displayOfSensitiveNotes.
  ///
  /// In ja, this message translates to:
  /// **'閲覧注意のついたノートの表示'**
  String get displayOfSensitiveNotes;

  /// No description provided for @infiniteScroll.
  ///
  /// In ja, this message translates to:
  /// **'一覧の自動更新'**
  String get infiniteScroll;

  /// No description provided for @enableAnimatedMfm.
  ///
  /// In ja, this message translates to:
  /// **'動きのあるMFM'**
  String get enableAnimatedMfm;

  /// No description provided for @enableAnimatedMfmDescription.
  ///
  /// In ja, this message translates to:
  /// **'動きのあるMFMを有効にします。'**
  String get enableAnimatedMfmDescription;

  /// No description provided for @collapseNotes.
  ///
  /// In ja, this message translates to:
  /// **'ノートの省略'**
  String get collapseNotes;

  /// No description provided for @collapseReactionedRenotes.
  ///
  /// In ja, this message translates to:
  /// **'リアクション済みノートのリノートを省略します。'**
  String get collapseReactionedRenotes;

  /// No description provided for @collapseLongNotes.
  ///
  /// In ja, this message translates to:
  /// **'長いノートを省略します。'**
  String get collapseLongNotes;

  /// No description provided for @tabPosition.
  ///
  /// In ja, this message translates to:
  /// **'タブの位置'**
  String get tabPosition;

  /// No description provided for @tabPositionDescription.
  ///
  /// In ja, this message translates to:
  /// **'{tabPosition}に表示する'**
  String tabPositionDescription(String tabPosition);

  /// No description provided for @theme.
  ///
  /// In ja, this message translates to:
  /// **'テーマ'**
  String get theme;

  /// No description provided for @themeForLightMode.
  ///
  /// In ja, this message translates to:
  /// **'ライトモードで使うテーマ'**
  String get themeForLightMode;

  /// No description provided for @themeForDarkMode.
  ///
  /// In ja, this message translates to:
  /// **'ダークモードで使うテーマ'**
  String get themeForDarkMode;

  /// No description provided for @themeIsh.
  ///
  /// In ja, this message translates to:
  /// **'{theme}っぽいの'**
  String themeIsh(String theme);

  /// No description provided for @selectLightOrDarkMode.
  ///
  /// In ja, this message translates to:
  /// **'ライトモード・ダークモードのつかいわけ'**
  String get selectLightOrDarkMode;

  /// No description provided for @reaction.
  ///
  /// In ja, this message translates to:
  /// **'リアクション'**
  String get reaction;

  /// No description provided for @emojiTapReaction.
  ///
  /// In ja, this message translates to:
  /// **'ノート内の絵文字タップでリアクションする'**
  String get emojiTapReaction;

  /// No description provided for @emojiTapReactionDescription.
  ///
  /// In ja, this message translates to:
  /// **'ノート内の絵文字をタップしてリアクションします。MFMや外部サーバーの絵文字の場合うまく機能しないことがあります。'**
  String get emojiTapReactionDescription;

  /// No description provided for @emojiStyle.
  ///
  /// In ja, this message translates to:
  /// **'絵文字のスタイル'**
  String get emojiStyle;

  /// No description provided for @fontStandard.
  ///
  /// In ja, this message translates to:
  /// **'フォント（標準）'**
  String get fontStandard;

  /// No description provided for @fontSerif.
  ///
  /// In ja, this message translates to:
  /// **'フォント（\$[font.serif 用）'**
  String get fontSerif;

  /// No description provided for @fontMonospace.
  ///
  /// In ja, this message translates to:
  /// **'フォント （\$[font.monospace やコードブロック 用）'**
  String get fontMonospace;

  /// No description provided for @fontCursive.
  ///
  /// In ja, this message translates to:
  /// **'フォント （\$[font.cursive 用）'**
  String get fontCursive;

  /// No description provided for @fontFantasy.
  ///
  /// In ja, this message translates to:
  /// **'フォント （\$[font.fantasy 用）'**
  String get fontFantasy;

  /// No description provided for @fontSize.
  ///
  /// In ja, this message translates to:
  /// **'フォントサイズ'**
  String get fontSize;

  /// No description provided for @systemFont.
  ///
  /// In ja, this message translates to:
  /// **'システム標準'**
  String get systemFont;

  /// No description provided for @selectFolder.
  ///
  /// In ja, this message translates to:
  /// **'フォルダー選択'**
  String get selectFolder;

  /// No description provided for @settingsFileManagement.
  ///
  /// In ja, this message translates to:
  /// **'設定ファイルの管理'**
  String get settingsFileManagement;

  /// No description provided for @importAndExportSettingsDescription.
  ///
  /// In ja, this message translates to:
  /// **'現在の設定から、アカウントのログイン情報を除くすべての設定を設定ファイルに出力して管理することができます。設定ファイルは、指定したアカウントの「ドライブ」内に保存されます。'**
  String get importAndExportSettingsDescription;

  /// No description provided for @importSettings.
  ///
  /// In ja, this message translates to:
  /// **'インポート'**
  String get importSettings;

  /// No description provided for @importSettingsDescription.
  ///
  /// In ja, this message translates to:
  /// **'全般設定と、この端末でログインしているアカウントに対応する設定が読み込まれます。'**
  String get importSettingsDescription;

  /// No description provided for @pleaseSelectAccount.
  ///
  /// In ja, this message translates to:
  /// **'アカウントを選んでや'**
  String get pleaseSelectAccount;

  /// No description provided for @select.
  ///
  /// In ja, this message translates to:
  /// **'選択'**
  String get select;

  /// No description provided for @exportSettings.
  ///
  /// In ja, this message translates to:
  /// **'エクスポート'**
  String get exportSettings;

  /// No description provided for @exportSettingsDescription.
  ///
  /// In ja, this message translates to:
  /// **'全般設定と、この端末でログインしているすべてのアカウントの設定を設定ファイルに保存します。'**
  String get exportSettingsDescription;

  /// No description provided for @pleaseSelectAccountToExportSettings.
  ///
  /// In ja, this message translates to:
  /// **'設定ファイルを保存するアカウントを選んでや'**
  String get pleaseSelectAccountToExportSettings;

  /// No description provided for @selectAntenna.
  ///
  /// In ja, this message translates to:
  /// **'アンテナ選択'**
  String get selectAntenna;

  /// No description provided for @selectChannel.
  ///
  /// In ja, this message translates to:
  /// **'チャンネル選択'**
  String get selectChannel;

  /// No description provided for @selectIcon.
  ///
  /// In ja, this message translates to:
  /// **'アイコンを選択'**
  String get selectIcon;

  /// No description provided for @standardIcon.
  ///
  /// In ja, this message translates to:
  /// **'標準'**
  String get standardIcon;

  /// No description provided for @emojiIcon.
  ///
  /// In ja, this message translates to:
  /// **'カスタム絵文字'**
  String get emojiIcon;

  /// No description provided for @selectRole.
  ///
  /// In ja, this message translates to:
  /// **'ロール選択'**
  String get selectRole;

  /// No description provided for @apply.
  ///
  /// In ja, this message translates to:
  /// **'反映する'**
  String get apply;

  /// No description provided for @account.
  ///
  /// In ja, this message translates to:
  /// **'アカウント'**
  String get account;

  /// No description provided for @tabType.
  ///
  /// In ja, this message translates to:
  /// **'タブの種類'**
  String get tabType;

  /// No description provided for @tabName.
  ///
  /// In ja, this message translates to:
  /// **'タブの名前'**
  String get tabName;

  /// No description provided for @icon.
  ///
  /// In ja, this message translates to:
  /// **'アイコン'**
  String get icon;

  /// No description provided for @displayRenotes.
  ///
  /// In ja, this message translates to:
  /// **'リノートを表示する'**
  String get displayRenotes;

  /// No description provided for @includeReplies.
  ///
  /// In ja, this message translates to:
  /// **'返信も入れる'**
  String get includeReplies;

  /// No description provided for @includeRepliesAvailability.
  ///
  /// In ja, this message translates to:
  /// **'Misskey v2023.10.1以降の機能です。'**
  String get includeRepliesAvailability;

  /// No description provided for @mediaOnly.
  ///
  /// In ja, this message translates to:
  /// **'ファイルのみにする'**
  String get mediaOnly;

  /// No description provided for @subscribeNotes.
  ///
  /// In ja, this message translates to:
  /// **'リアクションや投票数を自動更新する'**
  String get subscribeNotes;

  /// No description provided for @subscribeNotesDescription.
  ///
  /// In ja, this message translates to:
  /// **'オフにすると、リアクションや投票数が自動更新されませんが、バッテリー消費を抑えられることがあります。'**
  String get subscribeNotesDescription;

  /// No description provided for @pleaseSelectTabType.
  ///
  /// In ja, this message translates to:
  /// **'タブの種類を選択してください。'**
  String get pleaseSelectTabType;

  /// No description provided for @pleaseSelectIcon.
  ///
  /// In ja, this message translates to:
  /// **'アイコンを選択してください。'**
  String get pleaseSelectIcon;

  /// No description provided for @pleaseSelectChannel.
  ///
  /// In ja, this message translates to:
  /// **'チャンネルを選択してください。'**
  String get pleaseSelectChannel;

  /// No description provided for @pleaseSelectList.
  ///
  /// In ja, this message translates to:
  /// **'リストを選択してください。'**
  String get pleaseSelectList;

  /// No description provided for @pleaseSelectAntenna.
  ///
  /// In ja, this message translates to:
  /// **'アンテナを選択してください。'**
  String get pleaseSelectAntenna;

  /// No description provided for @pleaseSelectRole.
  ///
  /// In ja, this message translates to:
  /// **'ロールを選択してください。'**
  String get pleaseSelectRole;

  /// No description provided for @reactionDeck.
  ///
  /// In ja, this message translates to:
  /// **'リアクションデッキ'**
  String get reactionDeck;

  /// No description provided for @wordMute.
  ///
  /// In ja, this message translates to:
  /// **'ワードミュート'**
  String get wordMute;

  /// No description provided for @hardWordMute.
  ///
  /// In ja, this message translates to:
  /// **'ハードワードミュート'**
  String get hardWordMute;

  /// No description provided for @instanceMute.
  ///
  /// In ja, this message translates to:
  /// **'インスタンスミュート'**
  String get instanceMute;

  /// No description provided for @cacheSettings.
  ///
  /// In ja, this message translates to:
  /// **'キャッシュ設定'**
  String get cacheSettings;

  /// No description provided for @hideConditionalNotes.
  ///
  /// In ja, this message translates to:
  /// **'指定した条件のノートをタイムラインから隠します。'**
  String get hideConditionalNotes;

  /// No description provided for @muteSettingDescription.
  ///
  /// In ja, this message translates to:
  /// **'スペースで区切るとAND指定になり、改行で区切るとOR指定になります。\nキーワードをスラッシュで囲むと正規表現になります。'**
  String get muteSettingDescription;

  /// No description provided for @refreshOnTabChange.
  ///
  /// In ja, this message translates to:
  /// **'タブ切替時に毎回読み込む'**
  String get refreshOnTabChange;

  /// No description provided for @refreshOnLaunch.
  ///
  /// In ja, this message translates to:
  /// **'起動時に毎回読み込む'**
  String get refreshOnLaunch;

  /// No description provided for @refreshOnceADay.
  ///
  /// In ja, this message translates to:
  /// **'1日に1回読み込む'**
  String get refreshOnceADay;

  /// No description provided for @userCache.
  ///
  /// In ja, this message translates to:
  /// **'自分自身の情報（通知などを含みます）'**
  String get userCache;

  /// No description provided for @emojiCache.
  ///
  /// In ja, this message translates to:
  /// **'絵文字の情報'**
  String get emojiCache;

  /// No description provided for @serverCache.
  ///
  /// In ja, this message translates to:
  /// **'サーバーの情報'**
  String get serverCache;

  /// No description provided for @instanceMuteDescription1.
  ///
  /// In ja, this message translates to:
  /// **'設定したサーバーのノートを隠します。'**
  String get instanceMuteDescription1;

  /// No description provided for @instanceMuteDescription2.
  ///
  /// In ja, this message translates to:
  /// **'ミュートしたサーバーのユーザーへの返信を含めて、設定したサーバーの全てのノートとリノートをミュートします。\n改行で区切って設定します。'**
  String get instanceMuteDescription2;

  /// No description provided for @reactionMute.
  ///
  /// In ja, this message translates to:
  /// **'リアクションミュート'**
  String get reactionMute;

  /// No description provided for @reactionMuteDescription.
  ///
  /// In ja, this message translates to:
  /// **'改行区切りで :emoji: または :emoji@host: の形式で入力します。@host のみも受け付け、この場合該当ホストすべてを対象とします。'**
  String get reactionMuteDescription;

  /// No description provided for @bulkAddReactions.
  ///
  /// In ja, this message translates to:
  /// **'一括追加'**
  String get bulkAddReactions;

  /// No description provided for @bulkAddReactionsDescription1.
  ///
  /// In ja, this message translates to:
  /// **'お使いのブラウザでリアクションデッキをコピーしたいアカウントにログインしてください'**
  String get bulkAddReactionsDescription1;

  /// No description provided for @bulkAddReactionsDescription2.
  ///
  /// In ja, this message translates to:
  /// **'同じブラウザで以下のURLにアクセスして「値 (JSON)」の内容をすべて選択してコピーしてください'**
  String get bulkAddReactionsDescription2;

  /// No description provided for @bulkAddReactionsDescription2ForEmojiPalette.
  ///
  /// In ja, this message translates to:
  /// **'同じブラウザで以下のURLにアクセスして絵文字パレットをコピーしてください'**
  String get bulkAddReactionsDescription2ForEmojiPalette;

  /// No description provided for @bulkAddReactionsDescription3.
  ///
  /// In ja, this message translates to:
  /// **'コピーしたものを下のテキストボックスに貼り付けてください'**
  String get bulkAddReactionsDescription3;

  /// No description provided for @bulkAddMutedReactions.
  ///
  /// In ja, this message translates to:
  /// **'ミュート設定をインポート'**
  String get bulkAddMutedReactions;

  /// No description provided for @bulkAddMutedReactionsDescription1.
  ///
  /// In ja, this message translates to:
  /// **'お使いのブラウザでミュート設定をコピーしたいアカウントにログインしてください'**
  String get bulkAddMutedReactionsDescription1;

  /// No description provided for @bulkAddMutedReactionsDescription2.
  ///
  /// In ja, this message translates to:
  /// **'同じブラウザで以下のURLにアクセスしてミュート設定の内容をコピーしてください'**
  String get bulkAddMutedReactionsDescription2;

  /// No description provided for @bulkAddMutedReactionsDescription3.
  ///
  /// In ja, this message translates to:
  /// **'コピーしたものを下のテキストボックスに貼り付けてください'**
  String get bulkAddMutedReactionsDescription3;

  /// No description provided for @importMutedReactions.
  ///
  /// In ja, this message translates to:
  /// **'ミュート設定をインポート'**
  String get importMutedReactions;

  /// No description provided for @pasteHere.
  ///
  /// In ja, this message translates to:
  /// **'ここに貼り付け'**
  String get pasteHere;

  /// No description provided for @invalidInput.
  ///
  /// In ja, this message translates to:
  /// **'入力が有効な値ではありません'**
  String get invalidInput;

  /// No description provided for @clear.
  ///
  /// In ja, this message translates to:
  /// **'クリア'**
  String get clear;

  /// No description provided for @copy.
  ///
  /// In ja, this message translates to:
  /// **'コピー'**
  String get copy;

  /// No description provided for @editReactionDeckDescription.
  ///
  /// In ja, this message translates to:
  /// **'長押しして並び変え、押して削除、＋を押して追加します。'**
  String get editReactionDeckDescription;

  /// No description provided for @confirmClearReactionDeck.
  ///
  /// In ja, this message translates to:
  /// **'すでに設定済みのリアクションデッキをいったんすべてクリアしますか？'**
  String get confirmClearReactionDeck;

  /// No description provided for @clearReactionDeck.
  ///
  /// In ja, this message translates to:
  /// **'クリアする'**
  String get clearReactionDeck;

  /// No description provided for @accountGeneralSettings.
  ///
  /// In ja, this message translates to:
  /// **'{accountName} 全般設定'**
  String accountGeneralSettings(String accountName);

  /// No description provided for @privacy.
  ///
  /// In ja, this message translates to:
  /// **'プライバシー'**
  String get privacy;

  /// No description provided for @setDefaultNoteVisibility.
  ///
  /// In ja, this message translates to:
  /// **'デフォルトの公開範囲を設定します。'**
  String get setDefaultNoteVisibility;

  /// No description provided for @noteVisibility.
  ///
  /// In ja, this message translates to:
  /// **'ノート公開範囲'**
  String get noteVisibility;

  /// No description provided for @disableFederation.
  ///
  /// In ja, this message translates to:
  /// **'連合をなしにします'**
  String get disableFederation;

  /// No description provided for @disableFederationDescription.
  ///
  /// In ja, this message translates to:
  /// **'連合をなしにしても、非公開になりません。ほとんどの場合、連合なしにする必要はありません。'**
  String get disableFederationDescription;

  /// No description provided for @reactionAcceptance.
  ///
  /// In ja, this message translates to:
  /// **'リアクションの受け入れ'**
  String get reactionAcceptance;

  /// No description provided for @reactionAcceptanceAll.
  ///
  /// In ja, this message translates to:
  /// **'全部'**
  String get reactionAcceptanceAll;

  /// No description provided for @forceShowAds.
  ///
  /// In ja, this message translates to:
  /// **'広告を常に表示する'**
  String get forceShowAds;

  /// No description provided for @wordMuteDescription.
  ///
  /// In ja, this message translates to:
  /// **'スペースで区切るとAND指定になり、改行で区切るとOR指定になります。\nキーワードをスラッシュで囲むと正規表現になります。\nただし、Misskey Webと正規表現の仕様が異なるため、Miriaで動作する正規表現がMisskey Webで動作しなかったり、その逆が発生することがあります。'**
  String get wordMuteDescription;

  /// No description provided for @selectAccountToShare.
  ///
  /// In ja, this message translates to:
  /// **'共有するアカウントを選択'**
  String get selectAccountToShare;

  /// No description provided for @createAntenna.
  ///
  /// In ja, this message translates to:
  /// **'アンテナを作成'**
  String get createAntenna;

  /// No description provided for @memo.
  ///
  /// In ja, this message translates to:
  /// **'メモ'**
  String get memo;

  /// No description provided for @memoDescription.
  ///
  /// In ja, this message translates to:
  /// **'なんかメモることあったら書いとき'**
  String get memoDescription;

  /// No description provided for @confirmCreateBlock.
  ///
  /// In ja, this message translates to:
  /// **'ブロックしてもええか？'**
  String get confirmCreateBlock;

  /// No description provided for @createBlock.
  ///
  /// In ja, this message translates to:
  /// **'ブロックする'**
  String get createBlock;

  /// No description provided for @addToList.
  ///
  /// In ja, this message translates to:
  /// **'リストに追加'**
  String get addToList;

  /// No description provided for @addToAntenna.
  ///
  /// In ja, this message translates to:
  /// **'アンテナに追加'**
  String get addToAntenna;

  /// No description provided for @searchNote.
  ///
  /// In ja, this message translates to:
  /// **'ノートを検索'**
  String get searchNote;

  /// No description provided for @deleteRenoteMute.
  ///
  /// In ja, this message translates to:
  /// **'リノートのミュートを解除する'**
  String get deleteRenoteMute;

  /// No description provided for @createRenoteMute.
  ///
  /// In ja, this message translates to:
  /// **'リノートをミュートする'**
  String get createRenoteMute;

  /// No description provided for @deleteMute.
  ///
  /// In ja, this message translates to:
  /// **'ミュートを解除する'**
  String get deleteMute;

  /// No description provided for @createMute.
  ///
  /// In ja, this message translates to:
  /// **'ミュートする'**
  String get createMute;

  /// No description provided for @deleteBlock.
  ///
  /// In ja, this message translates to:
  /// **'ブロックを解除する'**
  String get deleteBlock;

  /// No description provided for @minutes10.
  ///
  /// In ja, this message translates to:
  /// **'10分間'**
  String get minutes10;

  /// No description provided for @hours1.
  ///
  /// In ja, this message translates to:
  /// **'1時間'**
  String get hours1;

  /// No description provided for @day1.
  ///
  /// In ja, this message translates to:
  /// **'1日'**
  String get day1;

  /// No description provided for @week1.
  ///
  /// In ja, this message translates to:
  /// **'1週間'**
  String get week1;

  /// No description provided for @selectDuration.
  ///
  /// In ja, this message translates to:
  /// **'期限を選択してください。'**
  String get selectDuration;

  /// No description provided for @confirmUnfollow.
  ///
  /// In ja, this message translates to:
  /// **'フォロー解除してもええか？'**
  String get confirmUnfollow;

  /// No description provided for @deleteFollow.
  ///
  /// In ja, this message translates to:
  /// **'解除する'**
  String get deleteFollow;

  /// No description provided for @renoteMuting.
  ///
  /// In ja, this message translates to:
  /// **'リノートのミュート中'**
  String get renoteMuting;

  /// No description provided for @muting.
  ///
  /// In ja, this message translates to:
  /// **'ミュート中'**
  String get muting;

  /// No description provided for @blocking.
  ///
  /// In ja, this message translates to:
  /// **'ブロック中'**
  String get blocking;

  /// No description provided for @followed.
  ///
  /// In ja, this message translates to:
  /// **'フォローされています'**
  String get followed;

  /// No description provided for @unfollow.
  ///
  /// In ja, this message translates to:
  /// **'フォロー解除'**
  String get unfollow;

  /// No description provided for @followRequestPending.
  ///
  /// In ja, this message translates to:
  /// **'フォロー許可待ち'**
  String get followRequestPending;

  /// No description provided for @followRequest.
  ///
  /// In ja, this message translates to:
  /// **'フォロー申請'**
  String get followRequest;

  /// No description provided for @createFollow.
  ///
  /// In ja, this message translates to:
  /// **'フォローする'**
  String get createFollow;

  /// No description provided for @refreshing.
  ///
  /// In ja, this message translates to:
  /// **'更新中'**
  String get refreshing;

  /// No description provided for @remoteUserCaution.
  ///
  /// In ja, this message translates to:
  /// **'リモートユーザーのため、情報が不完全です。'**
  String get remoteUserCaution;

  /// No description provided for @showServerInformation.
  ///
  /// In ja, this message translates to:
  /// **'サーバー情報を表示'**
  String get showServerInformation;

  /// No description provided for @location.
  ///
  /// In ja, this message translates to:
  /// **'場所'**
  String get location;

  /// No description provided for @registeredDate.
  ///
  /// In ja, this message translates to:
  /// **'登録日'**
  String get registeredDate;

  /// No description provided for @birthday.
  ///
  /// In ja, this message translates to:
  /// **'誕生日'**
  String get birthday;

  /// No description provided for @includeRepliesShort.
  ///
  /// In ja, this message translates to:
  /// **'返信つき'**
  String get includeRepliesShort;

  /// No description provided for @mediaOnlyShort.
  ///
  /// In ja, this message translates to:
  /// **'ファイルつき'**
  String get mediaOnlyShort;

  /// No description provided for @displayRenotesShort.
  ///
  /// In ja, this message translates to:
  /// **'リノートも'**
  String get displayRenotesShort;

  /// No description provided for @showNotesBeforeThisDate.
  ///
  /// In ja, this message translates to:
  /// **'この日までを表示'**
  String get showNotesBeforeThisDate;

  /// No description provided for @showNotesBeforeThisTime.
  ///
  /// In ja, this message translates to:
  /// **'この時間までを表示'**
  String get showNotesBeforeThisTime;

  /// No description provided for @userHighlightAvailability.
  ///
  /// In ja, this message translates to:
  /// **'ハイライトはMisskey 2023.10.0以降の機能です。'**
  String get userHighlightAvailability;

  /// No description provided for @userInfomation.
  ///
  /// In ja, this message translates to:
  /// **'アカウント情報'**
  String get userInfomation;

  /// No description provided for @userInfomationLocal.
  ///
  /// In ja, this message translates to:
  /// **'アカウント情報（ローカル）'**
  String get userInfomationLocal;

  /// No description provided for @userInfomationRemote.
  ///
  /// In ja, this message translates to:
  /// **'アカウント情報（リモート）'**
  String get userInfomationRemote;

  /// No description provided for @userNotes.
  ///
  /// In ja, this message translates to:
  /// **'ノート'**
  String get userNotes;

  /// No description provided for @userNotesLocal.
  ///
  /// In ja, this message translates to:
  /// **'ノート（ローカル）'**
  String get userNotesLocal;

  /// No description provided for @userNotesRemote.
  ///
  /// In ja, this message translates to:
  /// **'ノート（リモート）'**
  String get userNotesRemote;

  /// No description provided for @userReactions.
  ///
  /// In ja, this message translates to:
  /// **'リアクション'**
  String get userReactions;

  /// No description provided for @userPages.
  ///
  /// In ja, this message translates to:
  /// **'ページ'**
  String get userPages;

  /// No description provided for @userPlays.
  ///
  /// In ja, this message translates to:
  /// **'Play'**
  String get userPlays;

  /// No description provided for @userPlaysAvailability.
  ///
  /// In ja, this message translates to:
  /// **'この機能はMisskey 2023.9以降でのみ使用できます。'**
  String get userPlaysAvailability;

  /// No description provided for @createList.
  ///
  /// In ja, this message translates to:
  /// **'リストを作成'**
  String get createList;

  /// No description provided for @listName.
  ///
  /// In ja, this message translates to:
  /// **'リスト名'**
  String get listName;

  /// No description provided for @members.
  ///
  /// In ja, this message translates to:
  /// **'メンバー'**
  String get members;

  /// No description provided for @listCapacity.
  ///
  /// In ja, this message translates to:
  /// **'{members}/{limit}人'**
  String listCapacity(int members, double limit);

  /// No description provided for @confirmRemoveUser.
  ///
  /// In ja, this message translates to:
  /// **'このユーザーをリストから外しますか？'**
  String get confirmRemoveUser;

  /// No description provided for @removeUser.
  ///
  /// In ja, this message translates to:
  /// **'外す'**
  String get removeUser;

  /// No description provided for @confirmDeleteList.
  ///
  /// In ja, this message translates to:
  /// **'このリストを削除しますか？'**
  String get confirmDeleteList;

  /// No description provided for @homeOnly.
  ///
  /// In ja, this message translates to:
  /// **'ホームのみ'**
  String get homeOnly;

  /// No description provided for @followersOnly.
  ///
  /// In ja, this message translates to:
  /// **'フォロワーのみ'**
  String get followersOnly;

  /// No description provided for @originCombined.
  ///
  /// In ja, this message translates to:
  /// **'全て'**
  String get originCombined;

  /// No description provided for @followerAscendingOrder.
  ///
  /// In ja, this message translates to:
  /// **'フォロワーが少ない順'**
  String get followerAscendingOrder;

  /// No description provided for @followerDescendingOrder.
  ///
  /// In ja, this message translates to:
  /// **'フォロワーが多い順'**
  String get followerDescendingOrder;

  /// No description provided for @createdAtAscendingOrder.
  ///
  /// In ja, this message translates to:
  /// **'古い順'**
  String get createdAtAscendingOrder;

  /// No description provided for @createdAtDescendingOrder.
  ///
  /// In ja, this message translates to:
  /// **'新しい順'**
  String get createdAtDescendingOrder;

  /// No description provided for @updatedAtAscendingOrder.
  ///
  /// In ja, this message translates to:
  /// **'更新されていない順'**
  String get updatedAtAscendingOrder;

  /// No description provided for @updatedAtDescendingOrder.
  ///
  /// In ja, this message translates to:
  /// **'更新された順'**
  String get updatedAtDescendingOrder;

  /// No description provided for @unsupportedFile.
  ///
  /// In ja, this message translates to:
  /// **'対応してないファイルやわ'**
  String get unsupportedFile;

  /// No description provided for @unsupportedFileWithFilename.
  ///
  /// In ja, this message translates to:
  /// **'{filename}は対応してないファイルやわ'**
  String unsupportedFileWithFilename(String filename);

  /// No description provided for @failedFileSave.
  ///
  /// In ja, this message translates to:
  /// **'ファイルの保存に失敗したみたいや'**
  String get failedFileSave;

  /// No description provided for @misskeyGames.
  ///
  /// In ja, this message translates to:
  /// **'Misskey Games'**
  String get misskeyGames;

  /// No description provided for @cookieCliker.
  ///
  /// In ja, this message translates to:
  /// **'Cookie Cliker'**
  String get cookieCliker;

  /// No description provided for @bubbleGame.
  ///
  /// In ja, this message translates to:
  /// **'Bubble Game'**
  String get bubbleGame;

  /// No description provided for @reversi.
  ///
  /// In ja, this message translates to:
  /// **'リバーシ'**
  String get reversi;

  /// No description provided for @loading.
  ///
  /// In ja, this message translates to:
  /// **'読み込み中...'**
  String get loading;

  /// No description provided for @invitedReversi.
  ///
  /// In ja, this message translates to:
  /// **'{users}から招待されとるで'**
  String invitedReversi(String users);

  /// No description provided for @nonInvitedReversi.
  ///
  /// In ja, this message translates to:
  /// **'招待はされとらへんみたいや'**
  String get nonInvitedReversi;

  /// No description provided for @remoteServerWithoutLogin.
  ///
  /// In ja, this message translates to:
  /// **'相手先のサーバー（ログインなし）'**
  String get remoteServerWithoutLogin;

  /// No description provided for @nothingHere.
  ///
  /// In ja, this message translates to:
  /// **'なんもないで'**
  String get nothingHere;

  /// No description provided for @deckMode.
  ///
  /// In ja, this message translates to:
  /// **'デッキモード'**
  String get deckMode;

  /// No description provided for @enableDeckMode.
  ///
  /// In ja, this message translates to:
  /// **'デッキモードにする'**
  String get enableDeckMode;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ja', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'ja':
      {
        switch (locale.countryCode) {
          case 'OJ':
            return SJaOj();
        }
        break;
      }
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'CN':
            return SZhCn();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ja':
      return SJa();
    case 'zh':
      return SZh();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
