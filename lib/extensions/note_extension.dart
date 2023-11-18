import 'package:misskey_dart/misskey_dart.dart';

extension NoteExtension on Note {
  bool get isEmptyRenote =>
      renoteId != null &&
      text == null &&
      cw == null &&
      files.isEmpty &&
      poll == null;
}
