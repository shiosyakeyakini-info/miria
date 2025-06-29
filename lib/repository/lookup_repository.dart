import "package:miria/model/account.dart";
import "package:misskey_dart/misskey_dart.dart";

class LookupRepository {
  final Misskey misskey;
  final Account account;

  LookupRepository(this.misskey, this.account);

  Future<Map<String, dynamic>?> lookup(String uri) async {
    try {
      final result = await misskey.ap.show(ApShowRequest(uri: Uri.parse(uri)));
      return {"type": result.type, "object": result.object};
    } catch (e) {
      try {
        if (uri.startsWith("@")) {
          final usernameParts = uri.substring(1).split("@");
          if (usernameParts.length == 2) {
            final user = await misskey.users.showByName(
              UsersShowByUserNameRequest(
                userName: usernameParts[0],
                host: usernameParts[1],
              ),
            );
            return {"type": "User", "object": user};
          }
        }

        if (uri.startsWith("https://") || uri.startsWith("http://")) {
          final noteIdMatch = RegExp("/notes/([a-zA-Z0-9]+)").firstMatch(uri);
          if (noteIdMatch != null) {
            final note = await misskey.notes.show(
              NotesShowRequest(noteId: noteIdMatch.group(1)!),
            );
            return {"type": "Note", "object": note};
          }

          final userMatch = RegExp("/@([^/]+)(?:@([^/]+))?").firstMatch(uri);
          if (userMatch != null) {
            final username = userMatch.group(1)!;
            final host = userMatch.group(2);
            final user = await misskey.users.showByName(
              UsersShowByUserNameRequest(userName: username, host: host),
            );
            return {"type": "User", "object": user};
          }
        }

        final noteIdPattern = RegExp(r"^[a-zA-Z0-9]{10,}$");
        if (noteIdPattern.hasMatch(uri)) {
          final note = await misskey.notes.show(NotesShowRequest(noteId: uri));
          return {"type": "Note", "object": note};
        }

        return null;
      } catch (fallbackError) {
        return null;
      }
    }
  }
}
