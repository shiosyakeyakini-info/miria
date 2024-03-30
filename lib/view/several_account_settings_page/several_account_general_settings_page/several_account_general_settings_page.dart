import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mfm/mfm.dart';
import 'package:miria/extensions/note_visibility_extension.dart';
import 'package:miria/extensions/reaction_acceptance_extension.dart';
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
  var forceShowAd = false;

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
          forceShowAd = loadedSettings.forceShowAd;
        });
      }
    });
  }

  Future<void> save() async {
    await ref.read(accountSettingsRepositoryProvider).save(
          AccountSettings(
            userId: widget.account.userId,
            host: widget.account.host,
            reactions: accountSettings?.reactions ?? [],
            defaultNoteVisibility: defaultNoteVisibility,
            defaultIsLocalOnly: defaultIsLocalOnly,
            defaultReactionAcceptance: defaultReactionAppearance,
            forceShowAd: forceShowAd,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return AccountScope(
      account: widget.account,
      child: Scaffold(
        appBar: AppBar(
          title: SimpleMfm(
            S.of(context).accountGeneralSettings(
                  widget.account.i.name ?? widget.account.i.username,
                ),
          ),
        ),
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
                        Text(
                          S.of(context).privacy,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(S.of(context).setDefaultNoteVisibility),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        Text(S.of(context).noteVisibility),
                        DropdownButton<NoteVisibility>(
                            items: [
                              for (final noteVisibility
                                  in NoteVisibility.values)
                                DropdownMenuItem(
                                  value: noteVisibility,
                                  child:
                                      Text(noteVisibility.displayName(context)),
                                ),
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
                          title: Text(S.of(context).disableFederation),
                          subtitle:
                              Text(S.of(context).disableFederationDescription),
                          onChanged: (value) {
                            setState(() {
                              defaultIsLocalOnly = !defaultIsLocalOnly;
                              save();
                            });
                          },
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        Text(S.of(context).reactionAcceptance),
                        DropdownButton<ReactionAcceptance?>(
                            items: [
                              DropdownMenuItem(
                                child:
                                    Text(S.of(context).reactionAcceptanceAll),
                              ),
                              for (final acceptance
                                  in ReactionAcceptance.values)
                                DropdownMenuItem(
                                  value: acceptance,
                                  child: Text(acceptance.displayName(context)),
                                ),
                            ],
                            value: defaultReactionAppearance,
                            onChanged: (value) {
                              setState(() {
                                defaultReactionAppearance = value;
                                save();
                              });
                            }),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        Text(S.of(context).ad),
                        CheckboxListTile(
                          value: forceShowAd,
                          title: Text(S.of(context).forceShowAds),
                          enabled: widget.account.i.policies.canHideAds,
                          onChanged: (value) => setState(
                            () {
                              forceShowAd = value ?? false;
                              save();
                            },
                          ),
                        ),
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
