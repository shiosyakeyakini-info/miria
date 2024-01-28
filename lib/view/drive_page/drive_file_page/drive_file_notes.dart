import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/general_settings.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/error_detail.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';
import 'package:miria/view/common/pagination_bottom_item.dart';
import 'package:misskey_dart/misskey_dart.dart';

class DriveFileNotes extends ConsumerWidget {
  const DriveFileNotes({
    super.key,
    required this.account,
    required this.file,
  });

  final Account account;
  final DriveFile file;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final misskey = ref.watch(misskeyProvider(account));
    final notes =
        ref.watch(driveFilesAttachedNotesProvider((misskey, file.id)));
    final loadAutomatically = ref.watch(
      generalSettingsRepositoryProvider.select(
        (repository) =>
            repository.settings.automaticPush == AutomaticPush.automatic,
      ),
    );

    return RefreshIndicator(
      onRefresh: () => ref.refresh(
        driveFilesAttachedNotesProvider((misskey, file.id)).future,
      ),
      child: notes.when(
        data: (notes) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView.builder(
            itemCount: notes.length + 1,
            itemBuilder: (context, index) {
              if (index < notes.length) {
                return AccountScope(
                  account: account,
                  child: MisskeyNote(note: notes[index]),
                );
              }
              if (loadAutomatically &&
                  !notes.isLoading &&
                  !notes.isLastLoaded) {
                Future(() {
                  ref
                      .read(
                        driveFilesAttachedNotesProvider((misskey, file.id))
                            .notifier,
                      )
                      .loadMore()
                      .expectFailure(context);
                });
              }
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: PaginationBottomItem(
                    paginationState: notes,
                    noItemsLabel: Text(S.of(context).noAttachedNotes),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.keyboard_arrow_down),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        error: (e, st) => Center(child: ErrorDetail(error: e, stackTrace: st)),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
