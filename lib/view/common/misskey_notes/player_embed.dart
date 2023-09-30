import 'package:flutter/material.dart';
import 'package:miria/model/summaly_result.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class PlayerEmbed extends StatefulWidget {
  const PlayerEmbed({super.key, required this.player});

  final Player player;

  @override
  State<PlayerEmbed> createState() => _PlayerEmbedState();
}

class _PlayerEmbedState extends State<PlayerEmbed> {
  WebViewController? controller;

  @override
  void initState() {
    super.initState();
    final playerUrl = widget.player.url;
    if (playerUrl == null) {
      return;
    }
    final url = Uri.tryParse(playerUrl);
    if (url == null || WebViewPlatform.instance == null) {
      return;
    }
    // https://github.com/misskey-dev/misskey/blob/2023.9.3/packages/frontend/src/components/MkUrlPreview.vue#L18
    final replacedUrl = url.replace(
      queryParameters: {
        ...url.queryParameters,
        "autoplay": "1",
        "auto_play": "1",
      },
    );
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      controller = WebViewController.fromPlatformCreationParams(
        WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        ),
      );
    } else {
      controller = WebViewController();
    }
    controller
      ?..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            final url = Uri.tryParse(request.url);
            if (url != null && await canLaunchUrl(url)) {
              launchUrl(url, mode: LaunchMode.externalApplication);
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(replacedUrl);
    if (controller?.platform is AndroidWebViewController) {
      (controller!.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = this.controller;
    if (controller == null) {
      return const SizedBox.shrink();
    }
    final width = widget.player.width;
    final height = widget.player.height;
    if (width != null && height != null) {
      final aspectRatio = width / height;
      return AspectRatio(
        aspectRatio: aspectRatio,
        child: WebViewWidget(controller: controller),
      );
    }
    return SizedBox(
      height: height?.toDouble() ?? 200,
      child: WebViewWidget(controller: controller),
    );
  }
}
