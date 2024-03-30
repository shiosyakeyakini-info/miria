import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/image_file.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FileSettingsDialogResult {
  final String fileName;
  final bool isNsfw;
  final String caption;

  const FileSettingsDialogResult(
      {required this.fileName, required this.isNsfw, required this.caption});
}

class FileSettingsDialog extends ConsumerStatefulWidget {
  final MisskeyPostFile file;

  const FileSettingsDialog({super.key, required this.file});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      FileSettingsDialogState();
}

class FileSettingsDialogState extends ConsumerState<FileSettingsDialog> {
  late final TextEditingController fileNameController;
  late final TextEditingController captionController;
  bool isNsfw = false;

  @override
  void initState() {
    super.initState();

    fileNameController = TextEditingController(text: widget.file.fileName);
    captionController = TextEditingController(text: widget.file.caption);
    isNsfw = widget.file.isNsfw;
  }

  @override
  void dispose() {
    fileNameController.dispose();
    captionController.dispose();
    super.dispose();
  }

  String generateRandomText() {
    var str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        .split("");
    str.shuffle();
    return str.take(10).join("");
  }

  @override
  Widget build(BuildContext context) {
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
                    prefixIcon: Icon(Icons.badge_outlined)),
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
                  child: Text(S.of(context).randomizeFileName)),
              const Padding(padding: EdgeInsets.only(top: 10)),
              CheckboxListTile(
                value: isNsfw,
                title: Text(S.of(context).markAsSensitive),
                subtitle: Text(S.of(context).sensitiveSubTitle),
                onChanged: (value) => setState(() => isNsfw = !isNsfw),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Text(S.of(context).caption),
              TextField(
                controller: captionController,
                maxLines: null,
                minLines: 5,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.subtitles_outlined)),
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(FileSettingsDialogResult(
                fileName: fileNameController.text,
                isNsfw: isNsfw,
                caption: captionController.text,
              ));
            },
            child: Text(S.of(context).done)),
      ],
    );
  }
}
