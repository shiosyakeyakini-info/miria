import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_meta_dialog.freezed.dart';

@freezed
class ImageMeta with _$ImageMeta {
  const factory ImageMeta({
    required String fileName,
    required bool isNsfw,
    required String caption,
  }) = _ImageMeta;
}

class ImageMetaDialog extends ConsumerStatefulWidget {
  const ImageMetaDialog({super.key, required this.initialMeta});

  final ImageMeta initialMeta;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ImageMetaDialogState();
}

class ImageMetaDialogState extends ConsumerState<ImageMetaDialog> {
  late final TextEditingController fileNameController = TextEditingController()
    ..text = widget.initialMeta.fileName;
  late bool isNsfw = widget.initialMeta.isNsfw;
  late final TextEditingController captionController = TextEditingController()
    ..text = widget.initialMeta.caption;

  @override
  void dispose() {
    fileNameController.dispose();
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              const Text("ファイル名"),
              TextField(
                controller: fileNameController,
                decoration:
                    const InputDecoration(prefixIcon: Icon(Icons.file_present)),
              ),
              CheckboxListTile(
                value: isNsfw,
                onChanged: (value) => setState(() {
                  isNsfw = !isNsfw;
                }),
                title: const Text("閲覧注意としてマークする"),
              ),
              const Text("キャプション"),
              TextField(
                controller: fileNameController,
                decoration:
                    const InputDecoration(prefixIcon: Icon(Icons.file_present)),
                minLines: 5,
                maxLines: null,
              ),
            ],
          )),
    );
  }
}
