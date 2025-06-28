import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";

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
      body: Padding(
        padding: const EdgeInsets.all(10),
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
            ElevatedButton.icon(
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
          ],
        ),
      ),
    );
  }
}
