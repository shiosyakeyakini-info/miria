import 'dart:async';
import 'dart:convert';

import 'package:miria/repository/time_line_repository.dart';
import 'package:miria/model/tab_setting.dart';
import 'package:miria/repository/note_repository.dart';
import 'package:miria/model/account.dart';
import 'package:miria/repository/general_settings_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Timeline repository for custom endpoints.
class CustomTimelineRepository extends TimelineRepository {
  final Misskey misskey;
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;

  CustomTimelineRepository(
    this.misskey,
    Account account,
    super.noteRepository,
    super.generalSettingsRepository,
    super.tabSetting,
  );

  Future<Iterable<Note>> _request({String? untilId}) async {
    final path = tabSetting.customApiPath;
    if (path == null) return [];
    final params = Map<String, dynamic>.from(tabSetting.customParameters ?? {});
    if (untilId != null) params['untilId'] = untilId;
    final res = await misskey.apiService.post<List>(path, params);
    return res.map((e) => Note.fromJson(e));
  }

  @override
  Future<int> previousLoad() async {
    if (newerNotes.isEmpty && olderNotes.isEmpty) return -1;
    final result = await _request(
        untilId: olderNotes.lastOrNull?.id ?? newerNotes.first.id);
    olderNotes.addAll(result);
    notifyListeners();
    return result.length;
  }

  @override
  void startTimeLine() {
    unawaited(() async {
      final res = await _request();
      olderNotes
        ..clear()
        ..addAll(res);
      notifyListeners();
    }());

    final path = tabSetting.customWebSocketPath;
    if (path == null) return;
    final url = Uri(
      scheme: 'wss',
      host: misskey.host,
      path: path.startsWith('/') ? path.substring(1) : path,
      queryParameters: misskey.token != null ? {'i': misskey.token} : null,
    ).toString();

    _channel = IOWebSocketChannel.connect(
      url,
      pingInterval: const Duration(minutes: 1),
      connectTimeout: misskey.socketConnectionTimeout,
    );
    _subscription = _channel!.stream.listen((event) {
      try {
        final data = jsonDecode(event);
        if (data is Map<String, dynamic>) {
          final note = Note.fromJson(data);
          newerNotes.add(note);
          notifyListeners();
        }
      } catch (_) {}
    });
  }

  @override
  void disconnect() {
    unawaited(_subscription?.cancel());
    _subscription = null;
    unawaited(_channel?.sink.close());
    _channel = null;
  }

  @override
  void subscribe(SubscribeItem item) {}

  @override
  void describe(String id) {}

  @override
  Future<void> reconnect() async {
    disconnect();
    startTimeLine();
  }
}
