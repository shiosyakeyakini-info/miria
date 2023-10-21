import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TwitterEmbed extends StatefulWidget {
  const TwitterEmbed({
    super.key,
    required this.tweetId,
    this.isDark = false,

    // https://developer.twitter.com/en/docs/twitter-for-websites/supported-languages
    this.lang,
  });

  final String tweetId;
  final bool isDark;
  final String? lang;

  @override
  State<TwitterEmbed> createState() => _TwitterEmbedState();
}

class _TwitterEmbedState extends State<TwitterEmbed> {
  WebViewController? controller;
  double? height;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
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
      ..addJavaScriptChannel(
        "Twitter",
        onMessageReceived: (message) {
          setState(() {
            // そのままだと下が見切れる
            height = double.parse(message.message) + 10;
          });
        },
      )
      // https://developer.twitter.com/en/docs/twitter-for-websites/embedded-tweets/guides/embedded-tweet-javascript-factory-function
      ..loadHtmlString(
        """
<html>

  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
  </head>

  <body>
    <div id="container"></div>
  </body>

  <script>
    window.twttr = (function (d, s, id) {
      var js, fjs = d.getElementsByTagName(s)[0],
        t = window.twttr || {};
      if (d.getElementById(id)) return t;
      js = d.createElement(s);
      js.id = id;
      js.src = "https://platform.twitter.com/widgets.js";
      fjs.parentNode.insertBefore(js, fjs);

      t._e = [];
      t.ready = function (f) {
        t._e.push(f);
      };

      return t;
    }(document, "script", "twitter-wjs"));
    window.twttr.ready(
      (twttr) => twttr.widgets.createTweet(
        "${widget.tweetId}",
        document.getElementById("container"),
        {
          ${widget.isDark ? "theme: 'dark'," : ""}
          ${widget.lang != null ? "lang: '${widget.lang}'," : ""}
        }
      ).then((el) => Twitter.postMessage(el.clientHeight))
    );
  </script>

</html>""",
      );
  }

  @override
  Widget build(BuildContext context) {
    final controller = this.controller;
    if (controller == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: height ?? 200,
      child: WebViewWidget(controller: controller),
    );
  }
}
