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

class ApiKeyLogin extends ConsumerStatefulWidget {
  const ApiKeyLogin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => APiKeyLoginState();
}

class APiKeyLoginState extends ConsumerState<ApiKeyLogin> {
  final serverController = TextEditingController();
  final apiKeyController = TextEditingController();

  @override
  void dispose() {
    serverController.dispose();
    apiKeyController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    try {
      IndicatorView.showIndicator(context);
      await ref
          .read(accountRepositoryProvider.notifier)
          .loginAsToken(serverController.text, apiKeyController.text);

      if (!mounted) return;
      context.pushRoute(TimeLineRoute(
          initialTabSetting:
              ref.read(tabSettingsRepositoryProvider).tabSettings.first));
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
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(S.of(context).apiKey),
                ),
                TextField(
                  controller: apiKeyController,
                  decoration:
                      const InputDecoration(prefixIcon: Icon(Icons.key)),
                )
              ]),
              // ],
              TableRow(children: [
                Container(),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                      onPressed: () {
                        login().expectFailure(context);
                      },
                      child: Text(S.of(context).login)),
                )
              ])
            ],
          ),
        ],
      ),
    );
  }
}
