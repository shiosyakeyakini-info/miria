import 'dart:typed_data';
import 'dart:ui';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlighting/languages/ini.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/image_file.dart';
import 'package:image_editor/image_editor.dart';

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

final clipModeProvider = StateProvider.autoDispose((ref) => false);
final editedImageProvider =
    StateProvider.autoDispose<Uint8List?>((ref) => null);

final cropOffsetProvider =
    StateProvider.autoDispose<Offset>((ref) => const Offset(0, 0));
final cropSizeProvider = StateProvider.autoDispose<Size?>((ref) => null);
final defaultSizeProvider = StateProvider.autoDispose<Size?>((ref) => null);

class PhotoEditPageState extends ConsumerState<PhotoEditPage> {
  late Uint8List initialImage;

  int angle = 0;

  @override
  void initState() {
    super.initState();
    final file = widget.file;
    switch (file) {
      case ImageFile():
        initialImage = file.data;
        break;
      case ImageFileAlreadyPostedFile():
        initialImage = file.data;
        break;
      default:
        throw UnsupportedError("$file is unsupported.");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future(() async {
      ref.read(editedImageProvider.notifier).state = initialImage;
      final imageData = await ImageDescriptor.encoded(
          await ImmutableBuffer.fromUint8List(initialImage));
      ref.read(defaultSizeProvider.notifier).state =
          Size(imageData.width.toDouble(), imageData.height.toDouble());
      ref.read(cropSizeProvider.notifier).state = ref.read(defaultSizeProvider);
    });
  }

  void draw() async {
    final editorOption = ImageEditorOption();
    if (angle != 0) {
      editorOption.addOption(RotateOption(angle));
    }
    final offset = ref.read(cropOffsetProvider);
    final size = ref.read(cropSizeProvider);
    if (size != null) {
      editorOption.addOption(ClipOption(
          x: offset.dx, y: offset.dy, width: size.width, height: size.height));
    }
    ref.read(editedImageProvider.notifier).state = await ImageEditor.editImage(
        image: initialImage, imageEditorOption: editorOption);
    setState(() {});
  }

  void crop() {
    ref.read(clipModeProvider.notifier).state = true;
  }

  void rotate() {
    angle = ((angle - 90) % 360);
    draw();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("写真編集")),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: LayoutBuilder(builder: (context, constraints) {
                return FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: ClipMode()));
              }),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(onPressed: () => crop(), icon: const Icon(Icons.crop)),
            IconButton(
                onPressed: () => rotate(), icon: const Icon(Icons.refresh)),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.palette_outlined)),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add_reaction_outlined)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.info_outline))
          ],
        ),
      ),
    );
  }
}

class ClipMode extends ConsumerWidget {
  const ClipMode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clipMode = ref.watch(clipModeProvider);
    final image = ref.watch(editedImageProvider);
    final defaultSize = ref.watch(defaultSizeProvider);
    final cropOffset = ref.watch(cropOffsetProvider);
    if (defaultSize == null) return const SizedBox(width: 100, height: 100);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (image != null)
          Positioned(
              left: 0,
              top: 0,
              width: defaultSize.width,
              height: defaultSize.height,
              child: Image.memory(image)),
        if (clipMode) ...[
          Positioned(
            left: cropOffset.dx,
            top: cropOffset.dy,
            child: Transform.translate(
              offset: const Offset(-10, -10),
              child: const Icon(Icons.circle_outlined, size: 20),
            ),
          ),
          Positioned(
            left: cropOffset.dx + defaultSize.width,
            top: cropOffset.dy,
            child: Transform.translate(
              offset: const Offset(10, -10),
              child: const Icon(Icons.circle_outlined, size: 20),
            ),
          ),
          Positioned(
            left: cropOffset.dx,
            top: cropOffset.dy + defaultSize.height,
            child: Transform.translate(
              offset: const Offset(-10, 10),
              child: const Icon(Icons.circle_outlined, size: 20),
            ),
          ),
          Positioned(
            left: cropOffset.dx + defaultSize.width,
            top: cropOffset.dy + defaultSize.height,
            child: Transform.translate(
              offset: const Offset(10, 10),
              child: const Icon(Icons.circle_outlined, size: 20),
            ),
          ),
        ]
      ],
      fit: StackFit.expand,
    );
  }
}
