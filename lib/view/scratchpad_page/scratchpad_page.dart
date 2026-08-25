import "dart:async";

import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/providers.dart";
import "package:miria/repository/aiscript_storage_repository.dart";
import "package:miria/repository/scratchpad_repository.dart";
import "package:miria/rust/api/aiscript.dart";
import "package:miria/rust/api/aiscript/ui.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/dialogs/text_input_dialog.dart";
import "package:miria/view/play_page/as_ui_widget.dart";
import "package:miria/view/play_page/create_aiscript.dart";

/// AiScript を書いて動かす場所。本家 Misskey のスクラッチパッド相当。
///
/// Play と同じ実行環境 ([createAiScript]) を使う。違うのは、スクリプトが
/// サーバーから来るのではなく手で書ける点と、`<:` の出力を画面に並べる点。
@RoutePage()
class ScratchpadPage extends HookConsumerWidget implements AutoRouteWrapper {
  final AccountContext accountContext;

  const ScratchpadPage({required this.accountContext, super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // useEffect の中からは InheritedWidget を引けないので、ここで取っておく
    final locale = Localizations.localeOf(context).toLanguageTag();
    final repository = ref.read(scratchpadRepositoryProvider);

    final controller = useTextEditingController();
    final components = useState(const <String, AsUiComponent>{});
    final logs = useState(const <_ScratchpadLog>[]);
    final isRunning = useState(false);
    // 実行中のスクリプト。次の実行や離脱で止める
    final running = useRef<AiScript?>(null);

    useEffect(() {
      unawaited(
        repository.load().then((code) {
          if (code != null) controller.text = code;
        }),
      );
      return () => unawaited(running.value?.abort());
    }, const []);

    Future<void> run() async {
      await running.value?.abort();
      running.value = null;
      components.value = const {};
      logs.value = const [];
      isRunning.value = true;
      final code = controller.text;
      unawaited(repository.save(code));

      try {
        final account = accountContext.getAccount;
        final aiscript = await createAiScript(
          misskey: ref.read(misskeyProvider(account)),
          account: account,
          // 本家のスクラッチパッドは Mk:save の置き場にウィジェットと同じ
          // 名前空間を使う。書いたスクリプトの挙動を揃えるため合わせる
          storage: ref.read(
            aiScriptStorageRepositoryProvider((
              account: account,
              namespace: "widget",
            )),
          ),
          dialogs: ref.read(dialogStateProvider.notifier),
          locale: locale,
          read: (prompt) async => context.mounted
              ? await TextInputDialog.show(context, hint: prompt) ?? ""
              : "",
          write: (value) =>
              logs.value = [...logs.value, _ScratchpadLog(text: value)],
          onComponentUpdate: (id, component) =>
              components.value = {...components.value, id: component},
        );
        running.value = aiscript;
        final result = await aiscript.exec(input: code);
        if (result.isNotEmpty) {
          logs.value = [
            ...logs.value,
            _ScratchpadLog(text: result, isResult: true),
          ];
        }
      } catch (e) {
        logs.value = [
          ...logs.value,
          _ScratchpadLog(text: e.toString(), isError: true),
        ];
      } finally {
        isRunning.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).scratchpad)),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 12,
                children: [
                  TextField(
                    controller: controller,
                    maxLines: null,
                    minLines: 8,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(fontFamily: "monospace"),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      onPressed: isRunning.value
                          ? null
                          : () => unawaited(run()),
                      icon: const Icon(Icons.play_arrow),
                      label: Text(S.of(context).runScript),
                    ),
                  ),
                  if (components.value.isNotEmpty)
                    _Section(
                      title: "UI",
                      child: AsUiWidget(
                        components: components.value,
                        account: accountContext.getAccount,
                      ),
                    ),
                  if (logs.value.isNotEmpty)
                    _Section(
                      title: S.of(context).scriptOutput,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final log in logs.value) _LogLine(log: log),
                        ],
                      ),
                    ),
                  Text(
                    S.of(context).scratchpadDescription,
                    style: Theme.of(context).textTheme.bodySmall,
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

/// 出力欄の 1 行。
class _ScratchpadLog {
  final String text;

  /// `<:` ではなく、スクリプト全体の評価結果。
  final bool isResult;

  final bool isError;

  const _ScratchpadLog({
    required this.text,
    this.isResult = false,
    this.isError = false,
  });
}

class _LogLine extends StatelessWidget {
  final _ScratchpadLog log;

  const _LogLine({required this.log});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: SelectableText(
        log.text,
        style: TextStyle(
          fontFamily: "monospace",
          color: log.isError
              ? theme.colorScheme.error
              : log.isResult
              ? theme.colorScheme.onSurface.withValues(alpha: 0.6)
              : null,
        ),
      ),
    );
  }
}

/// 折りたためる見出しつきの枠。
class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text(title, style: theme.textTheme.titleSmall),
        initiallyExpanded: true,
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        children: [child],
      ),
    );
  }
}
