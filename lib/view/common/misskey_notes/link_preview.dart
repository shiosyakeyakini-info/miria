import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/summaly_result.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/common/misskey_notes/link_navigator.dart';
import 'package:miria/view/common/misskey_notes/player_embed.dart';
import 'package:miria/view/common/misskey_notes/twitter_embed.dart';
import 'package:miria/view/themes/app_theme.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final _summalyProvider =
    AsyncNotifierProvider.family<_Summaly, SummalyResult, (String, String)>(
  _Summaly.new,
);

class _Summaly extends FamilyAsyncNotifier<SummalyResult, (String, String)> {
  @override
  Future<SummalyResult> build((String, String) arg) async {
    final (host, link) = arg;
    final dio = ref.watch(dioProvider);
    final url = Uri.parse(link);
    // https://github.com/misskey-dev/misskey/blob/2023.9.3/packages/frontend/src/components/MkUrlPreview.vue#L141-L145
    final replacedUrl = url
        .replace(
          host: url.host == "music.youtube.com" &&
                  ["watch", "channel"].contains(url.pathSegments.firstOrNull)
              ? "www.youtube.com"
              : null,
        )
        .removeFragment();
    final response = await dio.getUri<Map<String, dynamic>>(
      Uri.https(
        host,
        "url",
        {
          "url": replacedUrl.toString(),
          // TODO: l10n
          "lang": "ja-JP",
        },
      ),
    );
    return SummalyResult.fromJson(response.data!);
  }
}

class LinkPreview extends ConsumerWidget {
  const LinkPreview({
    super.key,
    required this.account,
    required this.link,
    required this.host,
  });

  final Account account;
  final String link;
  final String? host;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summalyResult = ref.watch(_summalyProvider((account.host, link)));
    return summalyResult.maybeWhen(
      data: (summalyResult) => LinkPreviewItem(
        link: link,
        host: host,
        summalyResult: summalyResult,
      ),
      orElse: () => LinkPreviewTile(link: link, host: host),
    );
  }
}

class LinkPreviewItem extends StatefulWidget {
  const LinkPreviewItem({
    super.key,
    required this.link,
    required this.summalyResult,
    required this.host,
  });

  final String link;
  final SummalyResult summalyResult;
  final String? host;

  @override
  State<LinkPreviewItem> createState() => _LinkPreviewItemState();
}

class _LinkPreviewItemState extends State<LinkPreviewItem> {
  bool isPlayerOpen = false;

  String? extractTweetId(String link) {
    final url = Uri.parse(link);
    if (!["twitter.com", "mobile.twitter.com", "x.com", "mobile.x.com"]
        .contains(url.host)) {
      return null;
    }
    final index = url.pathSegments.indexWhere(
      (segment) => ["status", "statuses"].contains(segment),
    );
    if (index < 0 || url.pathSegments.length - 1 <= index) {
      return null;
    }
    final tweetId = url.pathSegments[index + 1];
    return int.tryParse(tweetId)?.toString();
  }

  @override
  Widget build(BuildContext context) {
    final playerUrl = widget.summalyResult.player.url;
    final tweetId = extractTweetId(widget.link);
    return Column(
      children: [
        if (!isPlayerOpen)
          Row(
            children: [
              Expanded(
                child: LinkPreviewTile(
                  link: widget.link,
                  host: widget.host,
                  summalyResult: widget.summalyResult,
                ),
              ),
              // TODO: WebViewの仕様がAndroidとiOSで違うのでハマったためいったんコメントアウト
              // if (WebViewPlatform.instance != null &&
              //     (playerUrl != null || tweetId != null))
              //   IconButton(
              //     onPressed: () => setState(() {
              //       isPlayerOpen = true;
              //     }),
              //     icon: const Icon(Icons.play_arrow),
              //   )
            ],
          ),
        if (WebViewPlatform.instance != null &&
            (playerUrl != null || tweetId != null))
          if (isPlayerOpen) ...[
            if (playerUrl != null)
              PlayerEmbed(player: widget.summalyResult.player),
            if (tweetId != null)
              TwitterEmbed(
                tweetId: tweetId,
                isDark: AppTheme.of(context).isDarkMode,
                // TODO: l10n
                lang: "ja",
              ),
            OutlinedButton.icon(
              onPressed: () => setState(() {
                isPlayerOpen = false;
              }),
              icon: const Icon(Icons.close),
              label: Text(playerUrl != null
                  ? S.of(context).closePlayer
                  : S.of(context).closeTweet),
            ),
          ]
      ],
    );
  }
}

class LinkPreviewTile extends ConsumerWidget {
  const LinkPreviewTile({
    super.key,
    required this.link,
    required this.host,
    this.summalyResult = const SummalyResult(player: Player()),
  });

  final String link;
  final SummalyResult summalyResult;
  final String? host;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final unscaledSize = (textTheme.titleSmall?.fontSize ?? 15) * 5;
    final imageSize =
        min(unscaledSize, MediaQuery.textScalerOf(context).scale(unscaledSize));
    final thumbnail = summalyResult.thumbnail;
    final icon = summalyResult.icon;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () async => await const LinkNavigator()
            .onTapLink(context, ref, link, host)
            .expectFailure(context),
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: link));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).doneCopy),duration: const Duration(seconds: 1)),
          );
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).dividerColor,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  if (thumbnail == null || (summalyResult.sensitive ?? false))
                    SizedBox(height: imageSize)
                  else
                    CachedNetworkImage(
                      imageUrl: thumbnail,
                      height: imageSize,
                      width: imageSize,
                      fit: BoxFit.cover,
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            summalyResult.title ?? link,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: textTheme.titleSmall,
                          ),
                          Text(
                            summalyResult.description ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: textTheme.bodySmall,
                          ),
                          Row(
                            children: [
                              if (icon != null)
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: CachedNetworkImage(
                                    imageUrl: icon,
                                    height: textTheme.labelMedium?.fontSize,
                                    width: textTheme.labelMedium?.fontSize,
                                  ),
                                ),
                              Expanded(
                                child: Text(
                                  summalyResult.sitename ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: textTheme.labelMedium,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
