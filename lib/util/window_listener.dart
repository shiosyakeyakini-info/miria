import "dart:io";
import "dart:ui";

import "package:flutter/foundation.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/const.dart";
import "package:miria/model/desktop_settings.dart";
import "package:miria/providers.dart";
import "package:window_manager/window_manager.dart";

class MiriaWindowListener with WindowListener {
  final Ref ref;
  Size? size;
  Offset? position;

  MiriaWindowListener(this.ref);

  @override
  Future<void> onWindowMoved() async {
    size = await windowManager.getSize();
    position = await windowManager.getPosition();
  }

  @override
  Future<void> onWindowResized() async {
    size = await windowManager.getSize();
    position = await windowManager.getPosition();
  }

  @override
  Future<void> onWindowClose() async {
    if (!isDesktop) return;

    final isPreventClose = await windowManager.isPreventClose();
    if (!isPreventClose) return;

    // Linuxの場合のみ終了時にウィンドウ位置を取得する
    if (Platform.isLinux) {
      size = await windowManager.getSize();
      position = await windowManager.getPosition();
    }

    try {
      if (size != null && position != null) {
        final settings = ref.read(desktopSettingsRepositoryProvider).settings;
        await ref
            .read(desktopSettingsRepositoryProvider)
            .update(
              settings.copyWith(
                window: DesktopWindowSettings(
                  w: size!.width,
                  h: size!.height,
                  x: position!.dx,
                  y: position!.dy,
                ),
              ),
            );
      }
    } catch (e) {
      if (kDebugMode) print(e);
    } finally {
      await windowManager.setPreventClose(false);
      await windowManager.close();
    }
  }
}
