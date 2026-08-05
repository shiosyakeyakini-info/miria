import "dart:async";

import "package:flutter/material.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/image_file.dart";

class ChatFilePreview extends StatelessWidget {
  final MisskeyPostFile file;
  final VoidCallback onFileDeleted;
  final Future<void> Function(MisskeyPostFile) onFileSettingChanged;

  const ChatFilePreview({
    required this.file,
    required this.onFileDeleted,
    required this.onFileSettingChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 以前は onFileSettingChanged を受け取っていながら、どこからも
        // 呼んでいなかったため、ファイルの情報を変更する手段がなかった (#854)。
        GestureDetector(
          key: ValueKey("chatFile:${file.fileName}"),
          // サムネイルは中身が透けている箇所があるので、枠全体で受ける
          behavior: HitTestBehavior.opaque,
          onTap: () => unawaited(onFileSettingChanged(file)),
          child: _Thumbnail(file: file),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withAlpha(200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.close, size: 16),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              // 既定のタップ領域は48x48あり、80x80のサムネイルの中心まで
              // 覆ってしまう。見た目どおりの24x24に狭める。
              style: IconButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: onFileDeleted,
            ),
          ),
        ),
        if (file.isNsfw)
          Positioned(
            bottom: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                S.of(context).chatNsfw,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final MisskeyPostFile file;

  const _Thumbnail({required this.file});

  @override
  Widget build(BuildContext context) {
    final border = BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Theme.of(context).dividerColor),
    );

    return switch (file) {
      ImageFile(:final data) ||
      ImageFileAlreadyPostedFile(:final data) => Container(
        decoration: border,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(data, width: 80, height: 80, fit: BoxFit.cover),
        ),
      ),
      UnknownFile() => Container(
        width: 80,
        height: 80,
        decoration: border.copyWith(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.insert_drive_file, size: 32),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                file.fileName,
                style: const TextStyle(fontSize: 10),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      UnknownAlreadyPostedFile() => Container(
        decoration: border,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: const SizedBox(
            width: 80,
            height: 80,
            child: Center(
              child: Icon(
                Icons.insert_drive_file,
                size: 40,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    };
  }
}
