import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/model/account.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/repository/favorite_repository.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/common/misskey_note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class FavoritedNotePage extends ConsumerStatefulWidget {
  final Account account;

  const FavoritedNotePage({super.key, required this.account});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      FavoritedNotePageState();
}

class FavoritedNotePageState extends ConsumerState<FavoritedNotePage> {
  var isLoading = false;

  FavoriteRepository get favoriteRepository =>
      ref.read(favoriteProvider(widget.account));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    favoriteRepository.notes.clear();
    favoriteRepository.getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final notes = ref
        .watch(favoriteProvider(widget.account).select((value) => value.notes));

    return Scaffold(
      appBar: AppBar(
        title: const Text("お気に入り"),
      ),
      body: AccountScope(
        account: widget.account,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: ListView.builder(
              itemCount: notes.length + 1,
              itemBuilder: (context, index) {
                if (notes.length == index) {
                  return Center(
                    child: !isLoading
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                                Future(() async {
                                  await favoriteRepository.getFavorites();
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

                return MisskeyNote(note: notes[index]);
              }),
        ),
      ),
    );
  }
}
