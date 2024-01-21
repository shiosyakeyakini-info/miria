class AuthTestData {
  static Map<String, dynamic> calckeyNodeInfo = {
    "links": [
      {
        "rel": "http://nodeinfo.diaspora.software/ns/schema/2.1",
        "href": "https://calckey.jp/nodeinfo/2.1"
      },
      {
        "rel": "http://nodeinfo.diaspora.software/ns/schema/2.0",
        "href": "https://calckey.jp/nodeinfo/2.0"
      }
    ]
  };

  static Map<String, dynamic> calckeyNodeInfo2 = {
    "version": "2.0",
    "software": {
      "name": "calckey",
      "version": "14.0.0-rc2c-jp3",
      "homepage": "https://calckey.org/"
    },
    "protocols": ["activitypub"],
    "services": {
      "inbound": [],
      "outbound": ["atom1.0", "rss2.0"]
    },
    "openRegistrations": false,
    "usage": {
      "users": {"total": 447, "activeHalfyear": 445, "activeMonth": 237},
      "localPosts": 53977,
      "localComments": 0
    },
    "metadata": {
      "nodeName": "Calckey.jp",
      "nodeDescription":
          "分散型SNS、Calckeyへようこそ！ここは日本語を話すユーザー向けの非公式サーバーです。利用規約を遵守していただく限り、自由にご利用いただけます。 Welcome to Calckey! This unofficial instance is for Japanese speakers, also welcoming those who are interested in or learning Japanese!\nただいま招待制となっております。招待コードは個別に発行しておりますので、お気軽に @nmkj@calckey.jp までご連絡ください。こちらで他のサーバーを探すこともできます： https://calckey.org/ja/join/",
      "maintainer": {"name": "Namekuji", "email": "nmkj@duck.com"},
      "langs": [],
      "tosUrl": "https://media.calckey.jp/tos/coc.html",
      "repositoryUrl": "https://codeberg.org/calckey/calckey",
      "feedbackUrl": "https://codeberg.org/calckey/calckey/issues",
      "disableRegistration": true,
      "disableLocalTimeline": false,
      "disableRecommendedTimeline": true,
      "disableGlobalTimeline": false,
      "emailRequiredForSignup": true,
      "enableHcaptcha": true,
      "enableRecaptcha": false,
      "maxNoteTextLength": 5000,
      "maxCaptionTextLength": 1500,
      "enableTwitterIntegration": false,
      "enableGithubIntegration": false,
      "enableDiscordIntegration": false,
      "enableEmail": true,
      "enableServiceWorker": true,
      "proxyAccountName": "proxy",
      "themeColor": "#31748f"
    }
  };

  static Map<String, dynamic> oldVerMisskeyNodeInfo = {
    "links": [
      {
        "rel": "http://nodeinfo.diaspora.software/ns/schema/2.0",
        "href": "https://misskey.dev/nodeinfo/2.0"
      }
    ]
  };

  static Map<String, dynamic> oldVerMisskeyNodeInfo2 = {
    "version": "2.0",
    "software": {"name": "misskey", "version": "11.37.1-20230209223723"},
    "protocols": ["activitypub"],
    "services": {
      "inbound": [],
      "outbound": ["atom1.0", "rss2.0"]
    },
    "openRegistrations": true,
    "usage": {"users": {}},
    "metadata": {
      "nodeName": "misskey.dev",
      "nodeDescription":
          r'''<h3>Misskey for Developers and any people!</h3>\n<div style=\"margin:-8px 0;\">テクノロジーが好きにゃ人もそうじゃにゃい人も大歓迎！にゃMisskey<span style=\"font-size:0.8rem\">(ミスキー)</span>サーバー<span style=\"font-size:0.8rem\">(旧:インスタンス)</span>です。内容はフリートークでOK！当サーバーでは現在、Misskey めいv11が稼働しております。<div class=\"h4\" style=\"font-size:1.2rem;\"><a href=\"https://s.misskey.dev/howtouse\">How to Use</a> \n   |   <a href=\"https://s.misskey.dev/howtouse-jp\">使い方</a>\n   |   <a href=\"https://misskey.dev/@cv_k/pages/info\">Info・情報<small style=\"font-size:80%\">(登録前に確認！)</small></a></div><div style=\"margin:0px 0 10px 0;\"><span style=\"line-height:1.2;font-size:70%;color:#ff4a4a\">注意:misskey.devには横長絵文字、とある歌人等の絵文字はなく導入する予定もありません。それらの絵文字を使いたい場合は<a href=\"https://join.misskey.page/ja-JP/instances\" style=\"color:#ff0033\" target=\"_blank\" rel=\"noopener\">他のサーバー</a>をご利用ください</span></div>''',
      "maintainer": {"name": "cv_k", "email": r"sitesupport$live.jp"},
      "langs": [],
      "ToSUrl": "https://misskey.dev/@cv_k/pages/tos",
      "repositoryUrl": "https://github.com/syuilo/misskey",
      "feedbackUrl": "https://github.com/syuilo/misskey/issues/new",
      "announcements": [
        {
          "text":
              "✨ 最新のお知らせは ?[#misskeydevinfo](https://misskey.dev/tags/misskeydevinfo)をご確認ください :smiling_ai:\n**【必ずご確認ください】[サーバーの移行に伴う重要なお知らせ](https://misskey.dev/notes/9e6e8didf7)**\n\n詳しい情報は ?[info](https://misskey.dev/@cv_k/pages/info) ページをご確認ください\n運営費の寄付・支援は https://fantia.jp/takimura で受付しています。\n\nアイコンの変更方法は https://misskey.dev/notes/8w71u4lo9w をご覧ください。",
          "image": null,
          "title": "Misskeyへようこそ"
        },
        {
          "text":
              "⭐Approved as a pinned account\n⭐More request to add custom icons<small>(free user:1icon per month)</small>\n⭐User name posted on ?[info](https://misskey.dev/@cv_k/pages/info)page\n<center>[***      Donate      ***](https://liberapay.com/misskey.dev)</center>\n⭐ピン留めアカウントとして公認\n⭐より多くのカスタム絵文字の追加リクエスト<small>(非会員は一ヶ月につき1個まで)</small>\n⭐?[info](https://misskey.dev/@cv_k/pages/info)ページにてユーザー名の掲載\n\n支払いにはクレジットカード及びコンビニ決済をご利用いただけます。\n**New** Premiumの特典がないお得な100円プラン始めました。✌✌✌\n\n<center>[***    詳細・登録はこちら    ***](https://fantia.jp/takimura)</center>\nFantia招待コード：9A848327\n\n以下からBraveを30日間ご利用いただくことでも支援していただけます！\nhttps://brave.com/mis911",
          "image": null,
          "title": "misskey.dev Premium"
        },
        {
          "text":
              "How to Use \nhttps://misskey.dev/notes/5c79e2a0fe0a36003970239f\nTerms of service\nhttps://misskey.dev/@cv_k/pages/tos\nInfo\nhttps://misskey.dev/@cv_k/pages/info\n<center>-----</center>使い方\nhttps://misskey.dev/notes/5c79e505c9c298003288f8c8\n利用規約\nhttps://misskey.dev/@cv_k/pages/tos\nInfoページ\nhttps://misskey.dev/@cv_k/pages/info",
          "image": null,
          "title": "Misskey Information"
        },
        {
          "text":
              "カスタム絵文字の依頼について：128x128px以上のpngもしくはsvg画像を添付し、 @cv_k までReplyまたはDMしてください。追加の検討を致します。\n\nRegarding local accounts and remote accounts : Accounts that repeat posts that violate the laws of Japan are freezed.\n<center>-----</center>アカウント/リモートアカウントに関して : 日本国の法律に抵触する投稿を繰り返し行うアカウントは凍結されます。",
          "image": null,
          "title": "Misskey Information 2"
        }
      ],
      "disableRegistration": false,
      "disableLocalTimeline": false,
      "disableGlobalTimeline": false,
      "enableRecaptcha": true,
      "maxNoteTextLength": 2048,
      "enableTwitterIntegration": true,
      "enableGithubIntegration": true,
      "enableDiscordIntegration": true,
      "enableEmail": false,
      "enableServiceWorker": true
    }
  };

  static String oldVerMisskeyMeta = r'''
{
    "maintainerName": "cv_k",
    "maintainerEmail": "sitesupport$live.jp",
    "version": "11.37.1-20231128072711",
    "name": "misskey.dev",
    "uri": "https://misskey.dev",
    "description": "<h3>Misskey for ALL Technology Lover and any people!</h3>\n<div style=\"margin:-8px 0;\">テクノロジーが好きにゃ人もそうじゃにゃい人も大歓迎！にゃMisskey<span style=\"font-size:0.8rem\">(ミスキー)</span>サーバー<span style=\"font-size:0.8rem\">(旧:インスタンス)</span>です。内容はフリートークでOK！当サーバーでは現在、Misskey めいv11が稼働しております。 <div class=\"h4\" style=\"font-size:1.2rem;\"><a href=\"https://s.misskey.dev/howtouse\">How to Use</a> \n   |   <a href=\"https://s.misskey.dev/howtouse-jp\">使い方</a>\n   |   <a href=\"https://misskey.dev/@cv_k/pages/info\">Info・情報<small style=\"font-size:80%\">(登録前に確認！)</small></a></div><div style=\"margin:0px 0 10px 0;\"><span style=\"line-height:1.2;font-size:70%;color:#ff4a4a\">注意:misskey.devには横長絵文字、とある歌人等の絵文字はなく導入する予定もありません。それらの絵文字を使いたい場合は<a href=\"https://join.misskey.page/ja-JP/instances\" style=\"color:#ff0033\" target=\"_blank\" rel=\"noopener\">他のサーバー</a>をご利用ください</span>",
    "langs": [],
    "ToSUrl": "https://misskey.dev/@cv_k/pages/tos",
    "repositoryUrl": "https://github.com/mei23/misskey-v11",
    "feedbackUrl": "https://github.com/mei23/misskey-v11/issues/new",
    "machine": "i-18100000501653",
    "os": "linux",
    "node": "v18.18.2",
    "psql": "15.4 (Ubuntu 15.4-2.pgdg22.04+1)",
    "redis": "7.2.1",
    "cpu": {
        "model": "Intel Xeon E312xx (Sandy Bridge)",
        "cores": 6
    },
    "announcements": [
        {
            "text": "✨ 最新のお知らせは ?[#misskeydevinfo](https://misskey.dev/tags/misskeydevinfo)をご確認ください :smiling_ai:\n<small>※高負荷になった際は随時再起動が行われます※</small>\n\n詳しい情報は ?[info](https://misskey.dev/@cv_k/pages/info) ページをご確認ください\n運営費の寄付・支援は https://fantia.jp/takimura で受付しています。\n\n?[📄 ページ機能を開く](https://misskey.dev/i/pages)\nアイコンの変更方法は https://misskey.dev/notes/8w71u4lo9w をご覧ください。",
            "image": null,
            "title": "Misskeyへようこそ"
        },
        {
            "text": "⭐Approved as a pinned account\n⭐More request to add custom icons<small>(free user:1icon per month)</small>\n⭐User name posted on ?[info](https://misskey.dev/@cv_k/pages/info)page\n<center>[***      Donate      ***](https://liberapay.com/misskey.dev)</center>\n⭐ピン留めアカウントとして公認\n⭐より多くのカスタム絵文字の追加リクエスト<small>(非会員は一ヶ月につき1個まで)</small>\n⭐?[info](https://misskey.dev/@cv_k/pages/info)ページにてユーザー名の掲載\n\n支払いにはクレジットカード及びコンビニ決済をご利用いただけます。\n**New** Premiumの特典がないお得な100円プラン始めました。✌✌✌\n\n<center>[***    詳細・登録はこちら    ***](https://fantia.jp/takimura)</center>\nFantia招待コード：9A848327\n\n以下からBraveを30日間ご利用いただくことでも支援していただけます！\nhttps://brave.com/mis911",
            "image": null,
            "title": "misskey.dev Premium"
        },
        {
            "text": "How to Use \nhttps://misskey.dev/notes/5c79e2a0fe0a36003970239f\nTerms of service\nhttps://misskey.dev/@cv_k/pages/tos\nInfo\nhttps://misskey.dev/@cv_k/pages/info\n<center>-----</center>使い方\nhttps://misskey.dev/notes/5c79e505c9c298003288f8c8\n利用規約\nhttps://misskey.dev/@cv_k/pages/tos\nInfoページ\nhttps://misskey.dev/@cv_k/pages/info",
            "image": null,
            "title": "Misskey Information"
        },
        {
            "text": "カスタム絵文字の依頼について：128x128px以上のpngもしくはsvg画像を添付し、 @cv_k までReplyまたはDMしてください。追加の検討を致します。\n\nRegarding local accounts and remote accounts : Accounts that repeat posts that violate the laws of Japan are freezed.\n<center>-----</center>アカウント/リモートアカウントに関して : 日本国の法律に抵触する投稿を繰り返し行うアカウントは凍結されます。",
            "image": null,
            "title": "Misskey Information 2"
        }
    ],
    "disableRegistration": false,
    "disableLocalTimeline": false,
    "disableGlobalTimeline": false,
    "enableEmojiReaction": true,
    "driveCapacityPerLocalUserMb": 20480,
    "driveCapacityPerRemoteUserMb": 10,
    "cacheRemoteFiles": false,
    "proxyRemoteFiles": true,
    "enableRecaptcha": true,
    "recaptchaSiteKey": "6Le3u5UUAAAAADtRvaX8rU9nh1WWYhJqym1f9M5k",
    "swPublickey": "BOaqdTf3jyuCFGQKYpkcmq8sKorMyBoKbv7JPsW-ByuklgTfyARytgnNmy82TERiZKaid21CkXWxjwc-ToBP4zg",
    "mascotImageUrl": "/assets/ai.png",
    "bannerUrl": "https://media.misskey.dev/dev/90c4dcb5-e806-4ee2-ad3d-b35e83a56a9f.png",
    "errorImageUrl": "https://media.misskey.dev/dev/89ea71c3-51b7-419d-9f43-e469a6f91693.png#https://xn--931a.moe/aiart/yubitun.png",
    "iconUrl": "https://media.misskey.dev/dev/d40110c1-34f1-4d3a-b315-c3feae4a24dc.ico",
    "maxNoteTextLength": 2048,
    "emojis": [
        {
            "id": "7zjl9qnx8l",
            "aliases": [
                "藍"
            ],
            "name": "ai",
            "category": "01.Ai-chan / 藍ちゃん",
            "url": "https://raw.githubusercontent.com/tkmrgit/misskey-emoji/main/emoji/49e595ae-d8ef-4587-b216-d35ef281a214.svg"
        }
    ],
    "enableEmail": false,
    "enableTwitterIntegration": true,
    "enableGithubIntegration": true,
    "enableDiscordIntegration": true,
    "enableServiceWorker": true,
    "features": {
        "registration": true,
        "localTimeLine": true,
        "globalTimeLine": true,
        "elasticsearch": false,
        "recaptcha": true,
        "objectStorage": true,
        "twitter": true,
        "github": true,
        "discord": true,
        "serviceWorker": true
    }
}
''';
}
