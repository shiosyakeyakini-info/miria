import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:miria/providers.dart';
import 'package:miria/repository/emoji_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainStreamRepository extends ChangeNotifier {
  var hasUnreadNotification = false;

  final Misskey misskey;
  final EmojiRepository emojiRepository;
  SocketController? socketController;

  MainStreamRepository(this.misskey, this.emojiRepository);

  Future<void> latestMarkAs(String id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("latestReadNotification", id);
    hasUnreadNotification = false;
    notifyListeners();
  }

  Future<void> confirmNotification() async {
    final notifications = await misskey.i.notifications(
        const INotificationsRequest(markAsRead: false, limit: 1));
    final prefs = await SharedPreferences.getInstance();

    if (notifications.isEmpty) return;

    // 最後に読んだものと違うものがプッシュ通知にあれば通知をオン
    if (prefs.getString("latestReadNotification") ==
        notifications.firstOrNull?.id) {
      hasUnreadNotification = false;
    } else {
      hasUnreadNotification = true;
    }

    notifyListeners();
  }

  void connect() {
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
      onEmojiAdded: (_) {
        emojiRepository.loadFromSource();
      },
      onEmojiUpdated: (_) {
        emojiRepository.loadFromSource();
      },
    );
    socketController?.startStreaming();
    Future(() async {
      await confirmNotification();
    });
  }

  void reconnect() {
    socketController?.reconnect();
    Future(() async {
      await confirmNotification();
    });
  }
}
