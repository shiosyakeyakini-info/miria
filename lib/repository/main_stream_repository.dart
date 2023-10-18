import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:miria/model/account.dart';
import 'package:miria/repository/account_repository.dart';
import 'package:miria/repository/emoji_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainStreamRepository extends ChangeNotifier {
  var hasUnreadNotification = false;

  final Misskey misskey;
  final EmojiRepository emojiRepository;
  final Account account;
  final AccountRepository accountRepository;
  SocketController? socketController;
  bool isReconnecting = false;

  MainStreamRepository(
    this.misskey,
    this.emojiRepository,
    this.account,
    this.accountRepository,
  );

  Future<void> latestMarkAs(String id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        "latestReadNotification@${account.userId}@${account.host}", id);
    hasUnreadNotification = false;
    notifyListeners();
  }

  Future<void> confirmNotification() async {
    final notifications = await misskey.i.notifications(
        const INotificationsRequest(markAsRead: false, limit: 1));
    final prefs = await SharedPreferences.getInstance();

    if (notifications.isEmpty) return;

    // 最後に読んだものと違うものがプッシュ通知にあれば通知をオン
    if (prefs.getString(
            "latestReadNotification@${account.userId}@${account.host}") ==
        notifications.firstOrNull?.id) {
      hasUnreadNotification = false;
    } else {
      hasUnreadNotification = true;
    }

    notifyListeners();
  }

  Future<void> connect() async {
    socketController = misskey.mainStream(
      onReadAllNotifications: () {
        hasUnreadNotification = false;
        Future(() async {
          final notifications = await misskey.i.notifications(
              const INotificationsRequest(markAsRead: false, limit: 1));

          // 最後に読んだものとして記憶しておく
          latestMarkAs(notifications.firstOrNull?.id ?? "");
        });

        notifyListeners();
      },
      onUnreadNotification: (_) {
        hasUnreadNotification = true;
        notifyListeners();
      },
      onReadAllAnnouncements: () {
        accountRepository.removeUnreadAnnouncement(account);
      },
      onEmojiAdded: (_) {
        emojiRepository.loadFromSource();
      },
      onEmojiUpdated: (_) {
        emojiRepository.loadFromSource();
      },
      onAnnouncementCreated: (announcement) {
        accountRepository.createUnreadAnnouncement(account, announcement);
      },
    );
    await misskey.startStreaming();
    confirmNotification();
  }

  Future<void> reconnect() async {
    if (isReconnecting) {
      // 排他制御
      while (isReconnecting) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return;
    }
    isReconnecting = true;
    try {
      print("main stream repository's socket controller will be disconnect");
      socketController?.disconnect();
      socketController = null;
      await misskey.streamingService.restart();
      await connect();
    } finally {
      isReconnecting = false;
    }
  }
}
