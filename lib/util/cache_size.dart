import "dart:io";
import "dart:math";
import "package:path_provider/path_provider.dart";

/// 単位付きのキャッシュサイズを取得する
Future<String> getCacheSizeWithUnit() async {
  const unitArr = ["Byte", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];

  // キャッシュサイズ
  final cacheSizeByte = await _getCacheSizeByte();
    
  // 単位
  final unitIndex = (cacheSizeByte.toString().length / 3).ceil() - 1;
  final unit = unitArr[unitIndex];

  // "00.0 GB"の形にする
  final cacheSizeStr = (cacheSizeByte / pow(1000, unitIndex)).toStringAsFixed(1);

  return "$cacheSizeStr $unit";
}

/// キャッシュをクリアする
Future<String> clearCache() async {
  // 画像キャッシュ格納ディレクトリを削除
  final cacheDir = await _getLibCachedImageDataDir();
  if (await cacheDir.exists()){
    // ディレクトリが存在する場合のみ実行(ボタン連打対策)
    await cacheDir.delete(recursive: true);
  }
  final cacheSizeStr = await getCacheSizeWithUnit();
  
  // キャッシュクリア後のキャッシュサイズを返す("0.0 Byte"のはず)
  return cacheSizeStr;
}

/// キャッシュサイズを取得する
Future<int> _getCacheSizeByte() async {
  // キャッシュ格納ディレクトリを取得して
  // 中身のファイルサイズを全て合計
  final cacheDir = await _getLibCachedImageDataDir();
  final cacheSize = await _getDirSize(cacheDir);
  
  return cacheSize;
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

/// libCachedImageDataのパスを取得する
Future<Directory> _getLibCachedImageDataDir() async {
  const libCachedImageDataPath = "libCachedImageData";
  final tempDir = await getTemporaryDirectory();
  final libCachedImageDataDir = Directory("${tempDir.path}/$libCachedImageDataPath");

 return libCachedImageDataDir;
}
