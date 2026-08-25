import "dart:async";

import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/providers.dart";
import "package:miria/repository/aiscript_storage_repository.dart";
import "package:miria/rust/api/aiscript.dart";
import "package:miria/rust/api/aiscript/ui.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:miria/view/dialogs/aiscript_prompt_dialog.dart";
import "package:miria/view/play_page/as_ui_widget.dart";
import "package:miria/view/play_page/create_aiscript.dart";
import "package:misskey_dart/misskey_dart.dart";

/// Play (Misskey の flash) を実行して表示する。
///
/// AiScript の処理系は Rust 側にあり、`Ui:render` で組まれたコンポーネントが
/// [AsUiWidget] に流れてくる。
@RoutePage()
class PlayPage extends HookConsumerWidget implements AutoRouteWrapper {
  final AccountContext accountContext;
  final Flash flash;

  const PlayPage({
    required this.accountContext,
    required this.flash,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // useEffect の中からは InheritedWidget を引けないので、ここで取っておく
    final locale = Localizations.localeOf(context).toLanguageTag();
    final components = useState(const <String, AsUiComponent>{});
    final error = useState<String?>(null);
    final isRunning = useState(true);
    // 作り直すと再実行になる。再読み込みボタンが増やす
    final generation = useState(0);

    useEffect(() {
      var disposed = false;
      AiScript? aiscript;

      Future<void> run() async {
        error.value = null;
        isRunning.value = true;
        try {
          final account = accountContext.getAccount;
          final created = await createAiScript(
            misskey: ref.read(misskeyProvider(account)),
            account: account,
            storage: ref.read(
              aiScriptStorageRepositoryProvider((
                account: account,
                namespace: "flash:${flash.id}",
              )),
            ),
            dialogs: ref.read(dialogStateProvider.notifier),
            locale: locale,
            read: (prompt) async => context.mounted
                ? await showAiScriptPrompt(context, prompt) ?? ""
                : "",
            playId: flash.id,
            onComponentUpdate: (id, component) {
              // abort が効くまでスクリプトは動き続けるので、破棄後に
              // 届いたぶんは捨てる
              if (disposed) return;
              components.value = {...components.value, id: component};
            },
          );
          if (disposed) {
            await created.abort();
            return;
          }
          aiscript = created;
          await created.exec(input: flash.script);
        } catch (e) {
          if (!disposed) error.value = e.toString();
        } finally {
          if (!disposed) isRunning.value = false;
        }
      }

      unawaited(run());

      return () {
        disposed = true;
        unawaited(aiscript?.abort());
      };
    }, [generation.value]);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).flash),
        actions: [
          IconButton(
            onPressed: () {
              components.value = const {};
              generation.value++;
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MfmText(
                    mfmText: flash.title,
                    host: accountContext.getAccount.host,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  if (flash.summary.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: MfmText(
                        mfmText: flash.summary,
                        host: accountContext.getAccount.host,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(),
                  ),
                  if (error.value case final message?)
                    _PlayError(message: message)
                  else if (isRunning.value && components.value.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    AsUiWidget(
                      components: components.value,
                      account: accountContext.getAccount,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayError extends StatelessWidget {
  final String message;

  const _PlayError({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: TextStyle(color: theme.colorScheme.onErrorContainer),
      ),
    );
  }
}
