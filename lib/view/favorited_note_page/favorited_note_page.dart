import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/view/common/misskey_note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

@RoutePage()
class FavoritedNotePage extends ConsumerStatefulWidget {
  const FavoritedNotePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      FavoritedNotePageState();
}

class FavoritedNotePageState extends ConsumerState<FavoritedNotePage> {
  final favoriteNotes = <Note>[];
  var isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    favoriteNotes.clear();
    Future(() async {
      final responses = await ref
          .read(misskeyProvider)
          .i
          .favorites(const INotificationsRequest());
      favoriteNotes.addAll(responses.map((e) => e.note));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("お気に入り"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: ListView.builder(
            itemCount: favoriteNotes.length + 1,
            itemBuilder: (context, index) {
              if (favoriteNotes.length == index) {
                return Center(
                  child: !isLoading
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                              Future(() async {
                                final responses = await ref
                                    .read(misskeyProvider)
                                    .i
                                    .favorites(INotificationsRequest(
                                      untilId: favoriteNotes.last.id,
                                      limit: 50,
                                    ));
                                favoriteNotes
                                    .addAll(responses.map((e) => e.note));
                                setState(() {
                                  isLoading = false;
                                });
                              });
                            });
                          },
                          icon: const Icon(Icons.keyboard_arrow_down),
                        )
                      : const Padding(
                          padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator()),
                );
              }

              return MisskeyNote(note: favoriteNotes[index]);
            }),
      ),
    );
  }
}
