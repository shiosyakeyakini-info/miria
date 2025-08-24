import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/repository/note_draft_repository.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/error_detail.dart";
import "package:miria/view/drafts_page/note_draft_item.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class DraftsModalDialog extends ConsumerWidget implements AutoRouteWrapper {
  final Account account;

  const DraftsModalDialog({required this.account, super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftRepository = ref.watch(noteDraftRepositoryProvider.notifier);

    return Dialog(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    S.of(context).drafts,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => context.maybePop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Content
            Expanded(
              child: FutureBuilder<List<NoteDraft>>(
                future: draftRepository.list(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: ErrorDetail(
                        error: snapshot.error,
                        stackTrace: snapshot.stackTrace,
                      ),
                    );
                  }

                  final drafts = snapshot.data ?? [];

                  if (drafts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.drafts_outlined,
                            size: 64,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "下書きがありません",
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await draftRepository.list();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: drafts.length,
                      itemBuilder: (context, index) {
                        final draft = drafts[index];
                        return NoteDraftItem(
                          draft: draft,
                          onTap: () async {
                            // Return the selected draft and close dialog
                            context.maybePop(draft);
                          },
                          onDelete: () async {
                            await draftRepository.delete(draft.id);
                            // Refresh the dialog by rebuilding
                            if (context.mounted) {
                              context.maybePop();
                              context.pushRoute(
                                DraftsModalRoute(account: account),
                              );
                            }
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper function to show the drafts dialog
Future<NoteDraft?> showDraftsDialog(BuildContext context, WidgetRef ref) async {
  final account = ref.read(accountContextProvider).postAccount;
  return await context.pushRoute(DraftsModalRoute(account: account));
}
