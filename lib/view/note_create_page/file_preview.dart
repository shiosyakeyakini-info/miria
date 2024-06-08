import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/note_create_page/create_file_view.dart";

class FilePreview extends ConsumerWidget {
  const FilePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final files = ref.watch(
      noteCreateProvider(AccountScope.of(context))
          .select((value) => value.files),
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final file in files.mapIndexed((index, e) => (index, e)))
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CreateFileView(file: file.$2, index: file.$1),
            ),
        ],
      ),
    );
  }
}
