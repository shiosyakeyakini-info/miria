import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

part "image_meta_dialog.freezed.dart";

@freezed
class ImageMeta with _$ImageMeta {
  const factory ImageMeta({
    required String fileName,
    required bool isNsfw,
    required String caption,
  }) = _ImageMeta;
}

class ImageMetaDialog extends HookConsumerWidget {
  const ImageMetaDialog({required this.initialMeta, super.key});

  final ImageMeta initialMeta;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileNameController =
        useTextEditingController(text: initialMeta.fileName);
    final isNsfw = useState(initialMeta.isNsfw);
    final captionController =
        useTextEditingController(text: initialMeta.caption);

    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            Text(S.of(context).fileName),
            TextField(
              controller: fileNameController,
              decoration:
                  const InputDecoration(prefixIcon: Icon(Icons.file_present)),
            ),
            CheckboxListTile(
              value: isNsfw.value,
              onChanged: (value) => isNsfw.value = !isNsfw.value,
              title: Text(S.of(context).markAsSensitive),
            ),
            Text(S.of(context).caption),
            TextField(
              controller: captionController,
              decoration:
                  const InputDecoration(prefixIcon: Icon(Icons.file_present)),
              minLines: 5,
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}
