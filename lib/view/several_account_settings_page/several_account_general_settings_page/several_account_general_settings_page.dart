import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mfm_renderer/mfm_renderer.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/account_settings.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:misskey_dart/misskey_dart.dart';

@RoutePage()
class SeveralAccountGeneralSettingsPage extends ConsumerStatefulWidget {
  final Account account;

  const SeveralAccountGeneralSettingsPage({
    super.key,
    required this.account,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      SeveralAccountGeneralSettingsPageState();
}

class SeveralAccountGeneralSettingsPageState
    extends ConsumerState<SeveralAccountGeneralSettingsPage> {
  var defaultIsLocalOnly = false;
  var defaultNoteVisibility = NoteVisibility.public;
  ReactionAcceptance? defaultReactionAppearance;
  AccountSettings? accountSettings;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future(() async {
      final loadedSettings = ref
          .read(accountSettingsRepositoryProvider)
          .accountSettings
          .firstWhereOrNull((element) =>
              element.userId == widget.account.userId &&
              element.host == widget.account.host);
      if (loadedSettings != null) {
        accountSettings = loadedSettings;
        if (!mounted) return;
        setState(() {
          defaultIsLocalOnly = loadedSettings.defaultIsLocalOnly;
          defaultNoteVisibility = loadedSettings.defaultNoteVisibility;
          defaultReactionAppearance = loadedSettings.defaultReactionAcceptance;
        });
      }
    });
  }

  Future<void> save() async {
    await ref.read(accountSettingsRepositoryProvider).save(AccountSettings(
          userId: widget.account.userId,
          host: widget.account.host,
          reactions: accountSettings?.reactions ?? [],
          defaultNoteVisibility: defaultNoteVisibility,
          defaultIsLocalOnly: defaultIsLocalOnly,
          defaultReactionAcceptance: defaultReactionAppearance,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return AccountScope(
      account: widget.account,
      child: Scaffold(
        appBar: AppBar(
            title: SimpleMfm(
                "${widget.account.i.name ?? widget.account.i.username} 全般設定")),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text("プライバシー",
                            style: Theme.of(context).textTheme.titleLarge),
                        const Text("デフォルトの公開範囲を設定します。"),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        const Text("ノート公開範囲"),
                        DropdownButton<NoteVisibility>(
                            items: [
                              for (final noteVisibility
                                  in NoteVisibility.values)
                                DropdownMenuItem(
                                    value: noteVisibility,
                                    child: Text(noteVisibility.displayName))
                            ],
                            value: defaultNoteVisibility,
                            onChanged: (value) {
                              setState(() {
                                defaultNoteVisibility =
                                    value ?? NoteVisibility.public;
                                save();
                              });
                            }),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        CheckboxListTile(
                            value: defaultIsLocalOnly,
                            title: const Text("連合をなしにします"),
                            subtitle: const Text(
                                "連合をなしにしても、非公開になりません。ほとんどの場合、連合なしにする必要はありません。"),
                            onChanged: (value) {
                              setState(() {
                                defaultIsLocalOnly = !defaultIsLocalOnly;
                                save();
                              });
                            }),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        const Text("リアクションの受け入れ"),
                        DropdownButton<ReactionAcceptance?>(
                            items: [
                              const DropdownMenuItem(
                                  value: null, child: Text("全部")),
                              for (final acceptance
                                  in ReactionAcceptance.values)
                                DropdownMenuItem(
                                    value: acceptance,
                                    child: Text(acceptance.displayName))
                            ],
                            value: defaultReactionAppearance,
                            onChanged: (value) {
                              setState(() {
                                defaultReactionAppearance = value;
                                save();
                              });
                            }),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
