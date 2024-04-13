import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/error_detail.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:misskey_dart/misskey_dart.dart';

final _notesTranslateProvider = FutureProvider.family<NotesTranslateResponse,
    ({Account account, String noteId, String targetLang})>((ref, arg) async {
  return ref.read(misskeyProvider(arg.account)).notes.translate(
        NotesTranslateRequest(
          noteId: arg.noteId,
          targetLang: arg.targetLang,
        ),
      );
});

class TranslateNoteModalSheet extends ConsumerWidget {
  const TranslateNoteModalSheet({
    super.key,
    required this.account,
    required this.note,
  });

  final Account account;
  final Note note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translatedNote = ref.watch(
      _notesTranslateProvider(
        (
          account: account,
          noteId: note.id,
          targetLang: Localizations.localeOf(context).toLanguageTag(),
        ),
      ),
    );

    return Scaffold(
      body: translatedNote.when(
        data: (translatedNote) => Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              ListTile(
                title: Text(
                  S.of(context).translatedFrom(translatedNote.sourceLang),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: translatedNote.text),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(S.of(context).doneCopy),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  tooltip: S.of(context).copyContents,
                  icon: const Icon(Icons.copy),
                ),
              ),
              Center(
                child: Card(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: AccountScope(
                        account: account,
                        child: MfmText(
                          mfmText: translatedNote.text,
                          host: note.user.host,
                          emoji: note.emojis,
                          isEnableAnimatedMFM: ref
                              .watch(generalSettingsRepositoryProvider)
                              .settings
                              .enableAnimatedMFM,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        error: (e, st) => Center(child: ErrorDetail(error: e, stackTrace: st)),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
