import 'dart:typed_data';

sealed class MisskeyPostFile {
  const MisskeyPostFile._();
}

class ImageFile implements MisskeyPostFile {
  final Uint8List data;
  final String fileName;
  const ImageFile({
    required this.data,
    required this.fileName,
  });
}

class ImageFileAlreadyPostedFile implements MisskeyPostFile {
  final Uint8List data;
  final String fileName;
  final String id;
  const ImageFileAlreadyPostedFile({
    required this.data,
    required this.fileName,
    required this.id,
  });
}

class UnknownFile implements MisskeyPostFile {
  final Uint8List data;
  final String fileName;
  const UnknownFile({
    required this.data,
    required this.fileName,
  });
}

class UnknownAlreadyPostedFile implements MisskeyPostFile {
  final String url;
  final String id;
  final String fileName;
  const UnknownAlreadyPostedFile({
    required this.url,
    required this.id,
    required this.fileName,
  });
}
