import "package:auto_route/auto_route.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/common/error_detail.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "instance_mute_page.g.dart";

@Riverpod(dependencies: [misskeyPostContext])
class InstanceMutePageNotifier extends _$InstanceMutePageNotifier {
  @override
  Future<(List<String>, AsyncValue<void>?)> build() async {
    return (
      (await ref.read(misskeyPostContextProvider).i.i()).mutedInstances,
      null
    );
  }

  Future<void> save(String text) async {
    final beforeState = await future;
    state = AsyncData((beforeState.$1, const AsyncLoading()));

    final mutedInstances =
        text.split("\n").whereNot((element) => element.trim().isEmpty).toList();
    state = AsyncData(
      (
        beforeState.$1,
        await ref.read(dialogStateNotifierProvider.notifier).guard(
              () async => await ref
                  .read(misskeyPostContextProvider)
                  .i
                  .update(IUpdateRequest(mutedInstances: mutedInstances)),
            )
      ),
    );
  }
}

@RoutePage()
class InstanceMutePage extends HookConsumerWidget implements AutoRouteWrapper {
  final Account account;

  const InstanceMutePage({required this.account, super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final state = ref.watch(instanceMutePageNotifierProvider);

    ref.listen(
        instanceMutePageNotifierProvider
            .select((value) => value.valueOrNull?.$1), (_, next) {
      if (next == null) return;
      controller.text = next.join("\n");
    });

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).instanceMute)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: switch (state) {
            AsyncLoading() => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            AsyncError(:final error, :final stackTrace) =>
              ErrorDetail(error: error, stackTrace: stackTrace),
            AsyncValue() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(S.of(context).instanceMuteDescription1),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  TextField(
                    maxLines: null,
                    minLines: 5,
                    controller: controller,
                    autofocus: true,
                    textCapitalization: TextCapitalization.none,
                  ),
                  Text(
                    S.of(context).instanceMuteDescription2,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  ElevatedButton.icon(
                    onPressed: () async => ref
                        .read(instanceMutePageNotifierProvider.notifier)
                        .save(controller.text),
                    icon: const Icon(Icons.save),
                    label: Text(S.of(context).save),
                  ),
                ],
              ),
          },
        ),
      ),
    );
  }
}
