import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/image_file.dart';

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
  final fileNameController = TextEditingController();
  bool isNsfw = false;
  final captionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    fileNameController.text = widget.file.fileName;
    captionController.text = widget.file.caption;
    isNsfw = widget.file.isNsfw;
  }

  @override
  void dispose() {
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
      contentPadding: EdgeInsets.all(10),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("ファイル名"),
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
                  child: const Text("ファイル名をランダムにする")),
              const Padding(padding: EdgeInsets.only(top: 10)),
              CheckboxListTile(
                value: isNsfw,
                title: const Text("閲覧注意にする"),
                subtitle: const Text("閲覧注意の設定を外した場合でも、自動で閲覧注意にマークされることがあります。"),
                onChanged: (value) => setState(() => isNsfw = !isNsfw),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              const Text("キャプション"),
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
            child: const Text("これでええわ")),
      ],
    );
  }
}
