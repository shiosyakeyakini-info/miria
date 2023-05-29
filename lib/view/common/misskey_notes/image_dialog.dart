import 'package:flutter/material.dart';
import 'package:miria/view/common/misskey_notes/network_image.dart';

class ImageDialog extends StatefulWidget {
  final List<String> imageUrlList;
  final int initialPage;

  const ImageDialog({
    super.key,
    required this.imageUrlList,
    required this.initialPage,
  });

  @override
  State<StatefulWidget> createState() => ImageDialogState();
}

class ImageDialogState extends State<ImageDialog> {
  var scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.transparent,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned.fill(
                child: PageView(
                  controller: PageController(initialPage: widget.initialPage),
                  children: [
                    for (final url in widget.imageUrlList)
                      ScaleNotifierInteractiveViewer(
                        imageUrl: url,
                        onScaleChanged: (updatedScale) {
                          setState(() {
                            print(scale);
                            scale = updatedScale;
                          });
                        },
                      ),
                  ],
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: RawMaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    constraints:
                        const BoxConstraints(minWidth: 0, minHeight: 0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                    fillColor: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withAlpha(200),
                    shape: const CircleBorder(),
                    child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Icon(Icons.close,
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withAlpha(200)))),
              ),
            ],
          ),
        ));
  }
}

class ScaleNotifierInteractiveViewer extends StatefulWidget {
  final String imageUrl;

  final void Function(double) onScaleChanged;

  const ScaleNotifierInteractiveViewer({
    super.key,
    required this.imageUrl,
    required this.onScaleChanged,
  });

  @override
  State<StatefulWidget> createState() => ScaleNotifierInteractiveViewerState();
}

class ScaleNotifierInteractiveViewerState
    extends State<ScaleNotifierInteractiveViewer> {
  var scale = 1.0;
  final TransformationController _transformationController =
      TransformationController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onVerticalDragEnd:
            scale != 1.0 ? null : (details) => Navigator.of(context).pop(),
        onDoubleTap: () {
          if (scale != 1.0) {
            _transformationController.value = Matrix4.identity();
          }
        },
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.95,
            child: InteractiveViewer(
              // ピンチイン・ピンチアウト終了後の処理
              transformationController: _transformationController,
              onInteractionEnd: (details) {
                scale = _transformationController.value.getMaxScaleOnAxis();
              },
              child: NetworkImageView(
                url: widget.imageUrl,
                type: ImageType.image,
              ),
            )));
  }
}
