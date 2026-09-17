import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/util/animated_image.dart";

enum ImageType {
  avatarIcon,
  avatarDecoration,
  customEmoji,
  imageThumbnail,
  image,
  serverIcon,
  role,
  ad,
  other,
}

class NetworkImageView extends ConsumerWidget {
  final String url;
  final ImageType type;
  final ImageLoadingBuilder? loadingBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const NetworkImageView({
    required this.url,
    required this.type,
    super.key,
    this.loadingBuilder,
    this.errorBuilder,
    this.width,
    this.height,
    this.fit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (url.endsWith(".svg")) {
      return SvgPicture.network(
        url,
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
        placeholderBuilder: (context) =>
            loadingBuilder?.call(context, Container(), null) ??
            const SizedBox.shrink(),
      );
    }

    if (type == ImageType.avatarIcon ||
        type == ImageType.avatarDecoration ||
        type == ImageType.customEmoji ||
        type == ImageType.imageThumbnail ||
        type == ImageType.serverIcon ||
        type == ImageType.role) {
      return Image(
        // フレーム遅延が指定されていないアニメーション画像（カスタム絵文字の
        // APNG / WebP に多い）がブラウザと同じ速さで動くように包む。
        image: FrameDelayFallbackImage(
          CachedNetworkImageProvider(
            url,
            cacheManager: ref.read(cacheManagerProvider),
          ),
        ),
        fit: fit,
        width: width,
        height: height,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (frame != null || wasSynchronouslyLoaded) return child;
          return loadingBuilder?.call(context, child, null) ??
              const SizedBox.shrink();
        },
        errorBuilder: (context, error, stackTrace) =>
            errorBuilder?.call(context, error, stackTrace) ??
            Container(
              alignment: Alignment.center,
              decoration: type == ImageType.avatarDecoration
                  ? null
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color.fromARGB(255, 224, 224, 224),
                    ),
              child: type == ImageType.avatarDecoration
                  ? null
                  : SvgPicture.asset(
                      "assets/images/miria_error.svg",
                      colorFilter: const ColorFilter.mode(
                        Color.fromARGB(255, 117, 117, 117),
                        BlendMode.srcIn,
                      ),
                      width: 48,
                      height: 48,
                    ),
            ),
      );
    } else {
      return Image(
        image: FrameDelayFallbackImage(NetworkImage(url)),
        fit: fit,
        loadingBuilder: loadingBuilder,
        errorBuilder: errorBuilder,
        width: width,
        height: height,
      );
    }
  }
}
