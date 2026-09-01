import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/several_account_settings_page/reaction_mute_page/add_muted_reactions_dialog.dart";

@RoutePage()
class ReactionMutePage extends HookConsumerWidget implements AutoRouteWrapper {
  final Account account;

  const ReactionMutePage({required this.account, super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final repo = ref.watch(accountSettingsRepositoryProvider);
    useEffect(() {
      final settings = repo.fromAccount(account);
      controller.text = settings.mutedReactions.join("\n");
      return null;
    }, [repo]);

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).reactionMute)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: controller,
                  maxLines: null,
                  minLines: 5,
                  autofocus: true,
                  textCapitalization: TextCapitalization.none,
                ),
                Text(
                  S.of(context).reactionMuteDescription,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final mutedReactions = await showDialog<List<String>>(
                            context: context,
                            builder: (context) =>
                                AddMutedReactionsDialog(account: account),
                          );
                          if (mutedReactions != null) {
                            // 既存の内容と新しい内容をマージ
                            final currentValues = controller.text
                                .split("\n")
                                .where((e) => e.trim().isNotEmpty)
                                .toSet();
                            currentValues.addAll(mutedReactions);
                            controller.text = currentValues.join("\n");
                          }
                        },
                        icon: const Icon(Icons.download),
                        label: Text(S.of(context).importMutedReactions),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final values = controller.text
                              .split("\n")
                              .where((e) => e.trim().isNotEmpty)
                              .toList();
                          final current = repo.fromAccount(account);
                          repo.save(current.copyWith(mutedReactions: values));
                          context.maybePop();
                        },
                        icon: const Icon(Icons.save),
                        label: Text(S.of(context).save),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
