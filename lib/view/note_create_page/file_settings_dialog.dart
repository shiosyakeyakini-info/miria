import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/image_file.dart";

class FileSettingsDialogResult {
  final String fileName;
  final bool isNsfw;
  final String caption;

  const FileSettingsDialogResult({
    required this.fileName,
    required this.isNsfw,
    required this.caption,
  });
}

class FileSettingsDialog extends HookConsumerWidget {
  final MisskeyPostFile file;

  const FileSettingsDialog({required this.file, super.key});

  String generateRandomText() {
    final str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        .split("")
      ..shuffle();
    return str.take(10).join("");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileNameController = useTextEditingController(text: file.fileName);
    final captionController = useTextEditingController(text: file.caption);
    final isNsfw = useState(file.isNsfw);

    return AlertDialog(
      contentPadding: const EdgeInsets.all(10),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.of(context).fileName),
              TextField(
                controller: fileNameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
              ),
              TextButton(
                onPressed: () {
                  final period = fileNameController.text.lastIndexOf(".");
                  if (period == -1) {
                    fileNameController.text = generateRandomText();
                  } else {
                    fileNameController.text = generateRandomText() +
                        fileNameController.text.substring(period);
                  }
                },
                child: Text(S.of(context).randomizeFileName),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              CheckboxListTile(
                value: isNsfw.value,
                title: Text(S.of(context).markAsSensitive),
                subtitle: Text(S.of(context).sensitiveSubTitle),
                onChanged: (value) => isNsfw.value = !isNsfw.value,
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Text(S.of(context).caption),
              TextField(
                controller: captionController,
                maxLines: null,
                minLines: 5,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.subtitles_outlined),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(
              FileSettingsDialogResult(
                fileName: fileNameController.text,
                isNsfw: isNsfw.value,
                caption: captionController.text,
              ),
            );
          },
          child: Text(S.of(context).done),
        ),
      ],
    );
  }
}
