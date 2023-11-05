import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:miria/providers.dart';
import 'package:misskey_dart/misskey_dart.dart' hide Permission;
import 'package:permission_handler/permission_handler.dart';

class DownloadFileNotifier extends Notifier<void> {
  @override
  void build() {
    return;
  }

  Future<void> downloadFile(DriveFile driveFile) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        final permissionStatus = await Permission.storage.status;
        if (permissionStatus.isDenied) {
          await Permission.storage.request();
        }
      } else {
        final permissionStatus = await Permission.photos.status;
        if (permissionStatus.isDenied) {
          await Permission.photos.request();
        }
      }
    }

    final tempDir = ref.read(fileSystemProvider).systemTempDirectory;
    final savePath = "${tempDir.path}/${driveFile.name}";

    await ref.read(dioProvider).download(
          driveFile.url,
          savePath,
          options: Options(
            responseType: ResponseType.bytes,
          ),
        );

    await ImageGallerySaver.saveFile(
      savePath,
      name: driveFile.name,
    );
  }
}
