import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/aiscript_plugin.dart";
import "package:miria/providers.dart";
import "package:miria/state_notifier/aiscript_plugin_notifier.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/dialogs/simple_confirm_dialog.dart";
import "package:miria/view/dialogs/simple_message_dialog.dart";
import "package:miria/view/dialogs/text_input_dialog.dart";

/// 入れてあるクライアントプラグインの管理。
@RoutePage()
class PluginPage extends HookConsumerWidget implements AutoRouteWrapper {
  final AccountContext accountContext;

  const PluginPage({required this.accountContext, super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = accountContext.getAccount;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final notifier = ref.read(aiScriptPluginProvider(account).notifier);
    final plugins = ref.watch(
      aiScriptPluginProvider(account).select((state) => state.plugins),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).plugins),
        actions: [
          IconButton(
            onPressed: () async {
              final code = await TextInputDialog.show(
                context,
                title: S.of(context).installPlugin,
                hint: S.of(context).pluginCode,
                minLines: 5,
                maxLines: 10,
                isMonospace: true,
              );
              if (code == null || code.isEmpty) return;
              try {
                await notifier.install(code, locale: locale);
              } catch (e) {
                if (context.mounted) {
                  await SimpleMessageDialog.show(context, e.toString());
                }
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    S.of(context).pluginPermissionNotice,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                if (plugins.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Center(
                      child: Text(S.of(context).noPluginsInstalled),
                    ),
                  )
                else
                  for (final plugin in plugins)
                    _PluginTile(
                      plugin: plugin,
                      accountContext: accountContext,
                      locale: locale,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 1 つぶんの行。開くと説明・権限・設定・ログが出る。
class _PluginTile extends ConsumerWidget {
  final AiScriptPlugin plugin;
  final AccountContext accountContext;
  final String locale;

  const _PluginTile({
    required this.plugin,
    required this.accountContext,
    required this.locale,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = accountContext.getAccount;
    final notifier = ref.read(aiScriptPluginProvider(account).notifier);
    final logs = ref.watch(
      aiScriptPluginProvider(
        account,
      ).select((state) => state.logs[plugin.installId] ?? const <String>[]),
    );

    return Card(
      child: ExpansionTile(
        title: Text(plugin.name),
        subtitle: Text("v${plugin.version} / ${plugin.author}"),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        trailing: Switch(
          value: plugin.active,
          onChanged: (value) async =>
              notifier.setActive(plugin, value, locale: locale),
        ),
        children: [
          if (plugin.description case final description?
              when description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(description),
            ),
          if (plugin.permissions.isNotEmpty) ...[
            Text(
              S.of(context).pluginPermissions,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 12),
              child: Text(plugin.permissions.join(", ")),
            ),
          ],
          if (plugin.config.isNotEmpty) ...[
            Text(
              S.of(context).pluginSettings,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            _PluginConfigForm(
              plugin: plugin,
              onSubmit: (configData) async =>
                  notifier.updateConfig(plugin, configData, locale: locale),
            ),
          ],
          if (logs.isNotEmpty) ...[
            Text(
              S.of(context).pluginLogs,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 12),
              child: SelectableText(
                logs.join("\n"),
                style: const TextStyle(fontFamily: "monospace"),
              ),
            ),
          ],
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () async {
                final confirmed = await SimpleConfirmDialog.show(
                  context: context,
                  message: S.of(context).confirmUninstallPlugin(plugin.name),
                  primary: S.of(context).delete,
                  secondary: S.of(context).cancel,
                );
                if (confirmed ?? false) {
                  await notifier.uninstall(plugin);
                }
              },
              icon: const Icon(Icons.delete),
              label: Text(S.of(context).uninstallPlugin),
            ),
          ),
        ],
      ),
    );
  }
}

/// メタデータの `config` から作る設定欄。
///
/// 本家は type に string / number / boolean / enum / radio / range などを
/// 取るが、ここでは前の 3 つだけ扱う。それ以外は文字列として入力させる。
class _PluginConfigForm extends HookWidget {
  final AiScriptPlugin plugin;
  final Future<void> Function(Map<String, dynamic> configData) onSubmit;

  const _PluginConfigForm({required this.plugin, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final values = useState<Map<String, dynamic>>({...plugin.effectiveConfig});

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final MapEntry(:key, :value) in plugin.config.entries)
          _field(context, key, value, values),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 12),
            child: ElevatedButton(
              onPressed: () async => onSubmit(values.value),
              child: Text(S.of(context).save),
            ),
          ),
        ),
      ],
    );
  }

  Widget _field(
    BuildContext context,
    String key,
    Object? definition,
    ValueNotifier<Map<String, dynamic>> values,
  ) {
    final spec = definition is Map ? definition : const {};
    final label = (spec["label"] as String?) ?? key;
    final type = spec["type"] as String?;
    final current = values.value[key];

    void set(Object? value) => values.value = {...values.value, key: value};

    return switch (type) {
      "boolean" => SwitchListTile(
        value: current == true,
        title: Text(label),
        contentPadding: EdgeInsets.zero,
        onChanged: set,
      ),
      _ => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: TextFormField(
          initialValue: current?.toString() ?? "",
          keyboardType: type == "number" ? TextInputType.number : null,
          decoration: InputDecoration(
            labelText: label,
            helperText: spec["description"] as String?,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
          onChanged: (text) =>
              set(type == "number" ? num.tryParse(text) : text),
        ),
      ),
    };
  }
}
