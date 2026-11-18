import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/error_detail.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "translate_note_modal_sheet.g.dart";

@Riverpod(dependencies: [misskeyPostContext])
FutureOr<NotesTranslateResponse> _notesTranslate(
  Ref ref, {
  required String noteId,
  required String targetLang,
}) {
  return ref
      .read(misskeyPostContextProvider)
      .notes
      .translate(NotesTranslateRequest(noteId: noteId, targetLang: targetLang));
}

@RoutePage()
class TranslateNoteModalSheet extends ConsumerWidget
    implements AutoRouteWrapper {
  const TranslateNoteModalSheet({
    required this.accountContext,
    required this.note,
    super.key,
  });

  final AccountContext accountContext;
  final Note note;

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translatedNote = ref.watch(
      _notesTranslateProvider(
        noteId: note.id,
        targetLang: Localizations.localeOf(context).toLanguageTag(),
      ),
    );

    return Scaffold(
      body: ListView(
        children: [
          ...switch (translatedNote) {
            AsyncValue(value: final translatedNote?) => [
              ListTile(
                title: Text(
                  S.of(context).translatedFrom(translatedNote.sourceLang),
                ),
                trailing: IconButton(
                  tooltip: S.of(context).copyContents,
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: translatedNote.text),
                    );
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(S.of(context).doneCopy),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy),
                ),
              ),
              const Divider(height: 0.0),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
            ],
            AsyncValue(:final error?, :final stackTrace) => [
              ErrorDetail(error: error, stackTrace: stackTrace),
            ],
            _ => [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
            ],
          },
        ],
      ),
    );
  }
}
