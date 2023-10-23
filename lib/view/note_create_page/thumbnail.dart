import 'package:flutter/material.dart';
import 'package:miria/view/common/misskey_notes/network_image.dart';
import 'package:misskey_dart/misskey_dart.dart';

class Thumbnail extends StatelessWidget {
  const Thumbnail({
    super.key,
    this.url,
    this.type,
    this.width,
    this.height,
    this.fit,
    this.iconSize = 50,
  });

  Thumbnail.driveFile(
    DriveFile file, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.iconSize = 50,
  })  : url = file.thumbnailUrl,
        type = file.type;

  final String? url;
  final String? type;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double? iconSize;

  IconData fallbackIcon() {
    final type = this.type;
    if (type != null) {
      if (type.startsWith("image")) {
        return Icons.image;
      }
      if (type.startsWith("video")) {
        return Icons.movie;
      }
      if (type.startsWith("audio")) {
        return Icons.music_note;
      }
    }
    return Icons.insert_drive_file;
  }

  @override
  Widget build(BuildContext context) {
    final url = this.url;
    if (url != null) {
      return NetworkImageView(
        url: url,
        type: ImageType.imageThumbnail,
        width: width,
        height: height,
        fit: fit,
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: Icon(
        fallbackIcon(),
        size: iconSize,
      ),
    );
  }
}
