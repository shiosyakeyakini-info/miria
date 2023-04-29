import 'package:flutter/widgets.dart';
import 'package:misskey_dart/misskey_dart.dart';

class MisskeyFileView extends StatelessWidget {
  final List<MisskeyFile> files;

  const MisskeyFileView({super.key, required this.files});

  @override
  Widget build(BuildContext context) {
    final targetFiles =
        files.where((e) => e.thumbnailUrl != null && !e.isSensitive);

    if (targetFiles.isEmpty) {
      return Container();
    } else if (targetFiles.length == 1) {
      final targetFile = targetFiles.first;
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: Image.network(
              (targetFile.thumbnailUrl ?? targetFile.url).toString()),
        ),
      );
    } else {
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (final targetFile in targetFiles)
            SizedBox(
              height: 200,
              child: Image.network(
                (targetFile.thumbnailUrl ?? targetFile.url).toString(),
              ),
            ),
        ],
      );
    }
  }
}
