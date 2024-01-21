import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/common/modal_indicator.dart';
import 'package:miria/view/login_page/centraing_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/login_page/misskey_server_list_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MiAuthLogin extends ConsumerStatefulWidget {
  const MiAuthLogin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MiAuthLoginState();
}

class MiAuthLoginState extends ConsumerState<MiAuthLogin> {
  final serverController = TextEditingController();
  bool isAuthed = false;

  @override
  void dispose() {
    serverController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    try {
      IndicatorView.showIndicator(context);
      await ref
          .read(accountRepositoryProvider.notifier)
          .validateMiAuth(serverController.text);
      if (!mounted) return;
      context.pushRoute(
        TimeLineRoute(
          initialTabSetting:
              ref.read(tabSettingsRepositoryProvider).tabSettings.first,
        ),
      );
    } catch (e) {
      rethrow;
    } finally {
      IndicatorView.hideIndicator(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CenteringWidget(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: IntrinsicColumnWidth(),
            1: FlexColumnWidth(),
          },
          children: [
            TableRow(children: [
              Text(S.of(context).server),
              TextField(
                controller: serverController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.dns),
                    suffixIcon: IconButton(
                        onPressed: () async {
                          final url = await showDialog<String?>(
                              context: context,
                              builder: (context) =>
                                  const MisskeyServerListDialog());
                          if (url != null && url.isNotEmpty) {
                            serverController.text = url;
                          }
                        },
                        icon: const Icon(Icons.search))),
              ),
            ]),
            TableRow(children: [
              const Padding(padding: EdgeInsets.only(bottom: 10)),
              Container()
            ]),
            TableRow(children: [
              Container(),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(accountRepositoryProvider.notifier)
                      .openMiAuth(serverController.text)
                      .expectFailure(context);
                  setState(() {
                    isAuthed = true;
                  });
                },
                child: Text(isAuthed
                    ? S.of(context).reauthorizate
                    : S.of(context).authorizate),
              ),
            ]),
            TableRow(children: [
              const Padding(padding: EdgeInsets.only(bottom: 10)),
              Container()
            ]),
            if (isAuthed)
              TableRow(children: [
                Container(),
                ElevatedButton(
                  onPressed: () => login().expectFailure(context),
                  child: Text(S.of(context).didAuthorize),
                ),
              ]),
          ],
        ),
      ],
    ));
  }
}
