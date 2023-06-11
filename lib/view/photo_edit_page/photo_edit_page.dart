import 'dart:ui';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/image_file.dart';
import 'package:miria/providers.dart';
import 'package:miria/state_notifier/photo_edit_state_notifier/photo_edit_view_model.dart';
import 'package:miria/view/photo_edit_page/clip_mode.dart';
import 'package:miria/view/photo_edit_page/color_filter_image_preview.dart';

@RoutePage()
class PhotoEditPage extends ConsumerStatefulWidget {
  final Account account;
  final MisskeyPostFile file;

  const PhotoEditPage({
    required this.account,
    required this.file,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => PhotoEditPageState();
}

class PhotoEditPageState extends ConsumerState<PhotoEditPage> {
  PhotoEditStateNotifier get photoEdit => ref.read(photoEditProvider.notifier);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    photoEdit.initialize(widget.file);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("写真編集"),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  photoEdit.decideDrawArea(
                      Size(constraints.maxWidth, constraints.maxHeight));
                });
                return SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: const FittedBox(
                        fit: BoxFit.contain, child: ClipMode()));
              }),
            ),
            const ColorFilterImagePreview(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () => photoEdit.crop(),
                  icon: const Icon(Icons.crop)),
              IconButton(
                  onPressed: () => photoEdit.rotate(),
                  icon: const Icon(Icons.refresh)),
              IconButton(
                  onPressed: () => photoEdit.colorFilter(),
                  icon: const Icon(Icons.palette_outlined)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add_reaction_outlined)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.info_outline))
            ],
          ),
        ),
      ),
    );
  }
}
