import "dart:convert";

import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/state_notifier/aiscript_plugin_notifier.dart";
import "package:misskey_dart/misskey_dart.dart";

/// プラグインがノートのメニューに生やした項目。
///
/// 本家 Misskey の `Plugin:register:note_action` に対応する。
class PluginNoteActionTiles extends ConsumerWidget {
  final Account account;
  final Note note;

  const PluginNoteActionTiles({
    required this.account,
    required this.note,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.watch(
      aiScriptPluginProvider(account).select((state) => state.noteActions),
    );
    return _PluginActionTiles(
      actions: actions,
      payload: () => jsonEncode(note.toJson()),
    );
  }
}

/// プラグインがユーザーのメニューに生やした項目。
class PluginUserActionTiles extends ConsumerWidget {
  final Account account;
  final UserDetailed user;

  const PluginUserActionTiles({
    required this.account,
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.watch(
      aiScriptPluginProvider(account).select((state) => state.userActions),
    );
    return _PluginActionTiles(
      actions: actions,
      payload: () => jsonEncode(user.toJson()),
    );
  }
}

class _PluginActionTiles extends StatelessWidget {
  final List<PluginAction> actions;

  /// AiScript に渡す対象。押されたときにだけ作る。
  final String Function() payload;

  const _PluginActionTiles({required this.actions, required this.payload});

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final action in actions)
          ListTile(
            leading: const Icon(Icons.extension),
            title: Text(action.title),
            onTap: () async {
              final navigator = Navigator.of(context);
              // ハンドラの中で待たされることがあるので、先に閉じる
              if (navigator.canPop()) navigator.pop();
              await action.callback.call(value: payload());
            },
          ),
      ],
    );
  }
}
