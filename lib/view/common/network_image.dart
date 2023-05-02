import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

enum ImageType { avatarIcon, customEmoji, imageThumbnail, image, other }

class NetworkImageView extends StatelessWidget {
  final String url;
  final ImageType type;
  final ImageLoadingBuilder? loadingBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final double? height;

  const NetworkImageView({
    super.key,
    required this.url,
    required this.type,
    this.loadingBuilder,
    this.errorBuilder,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (type == ImageType.avatarIcon ||
        type == ImageType.customEmoji ||
        type == ImageType.imageThumbnail) {
      return CachedNetworkImage(
        imageUrl: url,
        errorWidget: (context, url, error) =>
            errorBuilder?.call(context, error, StackTrace.current) ??
            Container(),
        height: height,
        placeholder: (context, url) =>
            loadingBuilder?.call(context, Container(), null) ?? Container(),
        fadeInDuration: Duration.zero,
      );
    } else {
      return Image.network(
        url,
        loadingBuilder: loadingBuilder,
        errorBuilder: errorBuilder,
        height: height,
      );
    }
  }
}
