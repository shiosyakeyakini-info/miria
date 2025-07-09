import "dart:io";
import "dart:math";

import "package:miria/providers.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:uuid/uuid.dart";

part "cache_size_notifier.g.dart";

@Riverpod()
class CacheSizeNotifier extends _$CacheSizeNotifier {
  @override
  Future<String> build() async {
    return "";
  }

  Future<void> updateCacheSize() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await getCacheSizeWithUnit());
  }

  Future<void> clear() async {
    state = const AsyncValue.loading();

    final cacheDir = await _getCacheDirectory();
    if (await cacheDir.exists()) {
      // ディレクトリが存在する場合のみ実行
      await cacheDir.delete(recursive: true);
    }
    // CacheManagerのDBもクリアする
    await ref.read(cacheManagerProvider).emptyCache();
    state = await AsyncValue.guard(() async => await getCacheSizeWithUnit());
  }

  /// 単位付きのキャッシュサイズを取得する
  Future<String> getCacheSizeWithUnit() async {
    const unitArr = ["Byte", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];

    // キャッシュサイズ
    final cacheDir = await _getCacheDirectory();
    final cacheSizeByte = await _getDirSize(cacheDir);

    // 単位
    final unitIndex = (cacheSizeByte.toString().length / 3).ceil() - 1;
    final unit = unitArr[unitIndex];

    // "00.0 GB"の形にする
    final cacheSizeStr = (cacheSizeByte / pow(1000, unitIndex)).toStringAsFixed(
      1,
    );

    return "$cacheSizeStr $unit";
  }

  /// ディレクトリ配下のファイルサイズ合計を取得する
  Future<int> _getDirSize(Directory dir) async {
    // ディレクトリが存在しない場合は0を返却
    if (!(await dir.exists())) {
      return 0;
    }

    // dir配下のファイル・ディレクトリをすべて取得してファイルサイズの合計を取得
    final dirSize = dir
        .list(recursive: true)
        .fold<int>(0, (prev, element) => prev + element.statSync().size);

    return dirSize;
  }

  Future<Directory> _getCacheDirectory() async {
    final filePath = await ref
        .read(cacheManagerProvider)
        .store
        .fileSystem
        .createFile(const Uuid().v4());
    return Directory(filePath.dirname);
  }
}
