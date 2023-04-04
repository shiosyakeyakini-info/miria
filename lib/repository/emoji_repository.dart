import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class EmojiRepository {
  List<Emoji>? emoji;
}

class EmojiRepositoryImpl extends EmojiRepository {
  final Misskey misskey;
  EmojiRepositoryImpl({required this.misskey});

  Future<void> loadFromSource() async {
    emoji = (await misskey.emojis()).emojis;
  }

  Future<File> requestEmoji(Emoji emoji) async {
    final directory = Directory(
        "${(await getApplicationDocumentsDirectory()).path}${Platform.pathSeparator}emoji_caches");
    if (!await directory.exists()) {
      await directory.create();
    }

    final files = directory.listSync().whereType<File>();

    final found = files
        .firstWhereOrNull((file) => file.path.endsWith("${emoji.name}.png"));
    if (found != null) {
      return found;
    }

    final dio = Dio();
    final response = await dio.getUri<List<int>>(emoji.url,
        options: Options(responseType: ResponseType.bytes));

    final data = response.data;
    if (data == null) {
      throw Exception("data is null");
    }

    final filePath = p.join(directory.path, "${emoji.name}.png");
    await File(filePath).create();
    await File(filePath).writeAsBytes(data);

    return File(filePath);
  }

  Future<void> downloadAllEmojis() async {}
}
