import 'package:flutter/widgets.dart';
import 'package:miria/model/account.dart';
import 'package:miria/repository/account_repository.dart';
import 'package:miria/repository/emoji_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';

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

  Future<void> confirmNotification() async {
    await accountRepository.updateI(account);

    notifyListeners();
  }

  Future<void> connect() async {
    socketController = misskey.mainStream(
      onReadAllNotifications: () {
        accountRepository.readAllNotification(account);
      },
      onUnreadNotification: (_) {
        accountRepository.addUnreadNotification(account);
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
      // 排他制御11
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
