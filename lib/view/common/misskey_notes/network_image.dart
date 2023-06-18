import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ImageType {
  avatarIcon,
  customEmoji,
  imageThumbnail,
  image,
  serverIcon,
  role,
  ad,
  other
}

class NetworkImageView extends StatelessWidget {
  final String url;
  final ImageType type;
  final ImageLoadingBuilder? loadingBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final double? height;
  final BoxFit? fit;

  const NetworkImageView({
    super.key,
    required this.url,
    required this.type,
    this.loadingBuilder,
    this.errorBuilder,
    this.height,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    if (url.endsWith(".svg")) {
      return SvgPicture.network(
        url,
        height: height,
        fit: fit ?? BoxFit.contain,
        placeholderBuilder: (context) =>
            loadingBuilder?.call(context, Container(), null) ?? Container(),
      );
    }

    if (type == ImageType.avatarIcon ||
        type == ImageType.customEmoji ||
        type == ImageType.imageThumbnail ||
        type == ImageType.serverIcon ||
        type == ImageType.role) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: fit,
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
        fit: fit,
        loadingBuilder: loadingBuilder,
        errorBuilder: errorBuilder,
        height: height,
      );
    }
  }
}
