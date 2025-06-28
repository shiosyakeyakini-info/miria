import "package:flutter/material.dart";
import "package:miria/view/common/interactive_viewer.dart" as iv;
import "package:miria/view/common/misskey_notes/network_image.dart";

class ScaleNotifierInteractiveViewer extends StatefulWidget {
  final String imageUrl;
  final TransformationController controller;
  final void Function(double) onScaleChanged;
  final double maxScale;
  final bool canChangeScale;

  const ScaleNotifierInteractiveViewer({
    required this.imageUrl,
    required this.controller,
    required this.onScaleChanged,
    required this.maxScale,
    required this.canChangeScale,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => ScaleNotifierInteractiveViewerState();
}

class ScaleNotifierInteractiveViewerState
    extends State<ScaleNotifierInteractiveViewer> {
  var scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.95,
      child: iv.InteractiveViewer(
        maxScale: widget.maxScale,
        canChangeScale: widget.canChangeScale,
        // ピンチイン・ピンチアウト終了後の処理
        transformationController: widget.controller,
        onInteractionEnd: (details) {
          scale = widget.controller.value.getMaxScaleOnAxis();
          widget.onScaleChanged(scale);
        },
        child: NetworkImageView(
          url: widget.imageUrl,
          type: ImageType.image,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const SizedBox(
              height: 48.0,
              width: 48.0,
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
          },
        ),
      ),
    );
  }
}
