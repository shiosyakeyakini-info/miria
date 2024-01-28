import 'package:file/file.dart';
import 'package:mime/mime.dart';
import 'package:misskey_dart/misskey_dart.dart';

sealed class MisskeyPostFile {
  final String fileName;
  final bool isNsfw;
  final String? caption;

  const MisskeyPostFile({
    required this.fileName,
    this.isNsfw = false,
    this.caption,
  });

  MisskeyPostFile copyWith({
    String? fileName,
    bool? isNsfw,
    String? caption,
  });

  String? get type;
}

class PostFile extends MisskeyPostFile {
  final File file;

  const PostFile({
    required this.file,
    required super.fileName,
    super.isNsfw,
    super.caption,
  });

  factory PostFile.file(File file) {
    return PostFile(
      file: file,
      fileName: file.basename,
    );
  }

  @override
  PostFile copyWith({
    File? file,
    String? fileName,
    bool? isNsfw,
    String? caption,
  }) {
    return PostFile(
      file: file ?? this.file,
      fileName: fileName ?? this.fileName,
      isNsfw: isNsfw ?? this.isNsfw,
      caption: caption ?? this.caption,
    );
  }

  @override
  String? get type => lookupMimeType(file.path);
}

class AlreadyPostedFile extends MisskeyPostFile {
  final DriveFile file;
  final bool isEdited;

  const AlreadyPostedFile({
    required this.file,
    this.isEdited = false,
    required super.fileName,
    super.isNsfw,
    super.caption,
  });

  factory AlreadyPostedFile.file(DriveFile file) {
    return AlreadyPostedFile(
      file: file,
      fileName: file.name,
      isNsfw: file.isSensitive,
      caption: file.comment,
    );
  }

  @override
  AlreadyPostedFile copyWith({
    DriveFile? file,
    bool? isEdited,
    String? fileName,
    bool? isNsfw,
    String? caption,
  }) {
    return AlreadyPostedFile(
      file: file ?? this.file,
      isEdited: isEdited ?? this.isEdited,
      fileName: fileName ?? this.fileName,
      isNsfw: isNsfw ?? this.isNsfw,
      caption: caption ?? this.caption,
    );
  }

  @override
  String get type => file.type;
}
