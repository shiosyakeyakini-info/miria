import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/antenna_settings.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/antenna_page/antenna_list.dart';
import 'package:miria/view/antenna_page/antenna_settings_dialog.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:misskey_dart/misskey_dart.dart';

final antennasListNotifierProvider = AutoDisposeAsyncNotifierProviderFamily<
    AntennasListNotifier, List<Antenna>, Misskey>(AntennasListNotifier.new);

class AntennasListNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<Antenna>, Misskey> {
  @override
  Future<List<Antenna>> build(Misskey arg) async {
    final response = await _misskey.antennas.list();
    return response.toList();
  }

  Misskey get _misskey => arg;

  Future<void> create(AntennaSettings settings) async {
    final antenna = await _misskey.antennas.create(
      AntennasCreateRequest(
        name: settings.name,
        src: settings.src,
        keywords: settings.keywords,
        excludeKeywords: settings.excludeKeywords,
        users: settings.users,
        caseSensitive: settings.caseSensitive,
        withReplies: settings.withReplies,
        withFile: settings.withFile,
        notify: settings.notify,
        localOnly: settings.localOnly,
      ),
    );
    state = AsyncValue.data([...?state.valueOrNull, antenna]);
  }

  Future<void> delete(String antennaId) async {
    await _misskey.antennas.delete(AntennasDeleteRequest(antennaId: antennaId));
    state = AsyncValue.data(
      state.valueOrNull?.where((e) => e.id != antennaId).toList() ?? [],
    );
  }

  Future<void> updateAntenna(
    String antennaId,
    AntennaSettings settings,
  ) async {
    await _misskey.antennas.update(
      AntennasUpdateRequest(
        antennaId: antennaId,
        name: settings.name,
        src: settings.src,
        keywords: settings.keywords,
        excludeKeywords: settings.excludeKeywords,
        users: settings.users,
        caseSensitive: settings.caseSensitive,
        withReplies: settings.withReplies,
        withFile: settings.withFile,
        notify: settings.notify,
        localOnly: settings.localOnly,
      ),
    );
    state = AsyncValue.data(
      state.valueOrNull
              ?.map(
                (antenna) => (antenna.id == antennaId)
                    ? antenna.copyWith(
                        name: settings.name,
                        src: settings.src,
                        keywords: settings.keywords,
                        excludeKeywords: settings.excludeKeywords,
                        users: settings.users,
                        caseSensitive: settings.caseSensitive,
                        withReplies: settings.withReplies,
                        withFile: settings.withFile,
                        notify: settings.notify,
                      )
                    : antenna,
              )
              .toList() ??
          [],
    );
  }
}

@RoutePage()
class AntennaPage extends ConsumerWidget {
  final Account account;

  const AntennaPage({required this.account, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final misskey = ref.watch(misskeyProvider(account));

    return AccountScope(
      account: account,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("アンテナ"),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final settings = await showDialog<AntennaSettings>(
                  context: context,
                  builder: (context) => AntennaSettingsDialog(
                    title: const Text("作成"),
                    account: account,
                  ),
                );
                if (!context.mounted) return;
                if (settings != null) {
                  await ref
                      .read(antennasListNotifierProvider(misskey).notifier)
                      .create(settings)
                      .expectFailure(context);
                }
              },
            ),
          ],
        ),
        body: const Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: AntennaList(),
        ),
      ),
    );
  }
}
