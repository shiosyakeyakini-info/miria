import 'dart:typed_data';

sealed class MisskeyPostFile {
  final String fileName;
  final bool isNsfw;
  final String caption;

  const MisskeyPostFile(
      {required this.fileName, required this.isNsfw, required this.caption});
}

class ImageFile extends MisskeyPostFile {
  final Uint8List data;
  const ImageFile({
    required this.data,
    required super.fileName,
    required super.isNsfw,
    required super.caption,
  });
}

class ImageFileAlreadyPostedFile extends MisskeyPostFile {
  final Uint8List data;
  final String id;
  final bool isEdited;
  const ImageFileAlreadyPostedFile({
    required this.data,
    required this.id,
    required this.isEdited,
    required super.fileName,
    required super.isNsfw,
    required super.caption,
  });
}

class UnknownFile extends MisskeyPostFile {
  final Uint8List data;
  const UnknownFile({
    required this.data,
    required super.fileName,
    required super.isNsfw,
    required super.caption,
  });
}

class UnknownAlreadyPostedFile extends MisskeyPostFile {
  final String url;
  final String id;
  final bool isEdited;
  const UnknownAlreadyPostedFile({
    required this.url,
    required this.id,
    required this.isEdited,
    required super.fileName,
    required super.isNsfw,
    required super.caption,
  });
}
