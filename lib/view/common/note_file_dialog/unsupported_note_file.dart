import "package:flutter/material.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/view/common/misskey_notes/network_image.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:url_launcher/url_launcher_string.dart";

class UnsupportedNoteFile extends StatelessWidget {
  final DriveFile file;
  final bool showThumbnail;
  final String? noteUrl;

  const UnsupportedNoteFile({
    required this.file,
    required this.showThumbnail,
    this.noteUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      alignment: Alignment.center,
      children: [
        if (showThumbnail)
          NetworkImageView(
            url: file.thumbnailUrl.toString(),
            type: ImageType.imageThumbnail,
            fit: BoxFit.contain,
          ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.of(context).unsupportedFile,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.file_present,
                ),
                const Padding(padding: EdgeInsets.only(left: 5)),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      file.name,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 24,
              runSpacing: 16,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await launchUrlString(
                      file.url,
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  icon: const Icon(Icons.open_in_browser),
                  label: Text(S.of(context).openBrowsers),
                ),
                if (noteUrl != null)
                  ElevatedButton.icon(
                    onPressed: () async {
                      await launchUrlString(
                        noteUrl!,
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    icon: const Icon(Icons.open_in_browser),
                    label: Text(S.of(context).openNoteInBrowsers),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
