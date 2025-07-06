import "dart:io";

import "package:file/file.dart" hide FileSystem;
import "package:file/local.dart";
import "package:flutter_cache_manager/flutter_cache_manager.dart";
import "package:path/path.dart" as p;
import "package:path_provider/path_provider.dart";

class IOFileSystem implements FileSystem {
  final Future<Directory> _fileDir;
  final String _cacheKey;

  IOFileSystem(this._cacheKey) : _fileDir = createDirectory(_cacheKey);

  static Future<Directory> createDirectory(String key) async {
    final baseDir = (Platform.isLinux)
        ? await getApplicationCacheDirectory()
        : await getTemporaryDirectory();

    final path = p.join(baseDir.path, key);

    const fs = LocalFileSystem();
    final directory = fs.directory(path);
    await directory.create(recursive: true);
    return directory;
  }

  @override
  Future<File> createFile(String name) async {
    final directory = await _fileDir;
    if (!(await directory.exists())) {
      await createDirectory(_cacheKey);
    }
    return directory.childFile(name);
  }
}
