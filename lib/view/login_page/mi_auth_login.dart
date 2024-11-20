import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/repository/account_repository.dart";
import "package:miria/router/app_router.dart";
import "package:miria/util/punycode.dart";
import "package:miria/view/common/error_dialog_handler.dart";
import "package:miria/view/common/modal_indicator.dart";
import "package:miria/view/login_page/centraing_widget.dart";
import "package:miria/view/login_page/misskey_server_list_dialog.dart";

class MiAuthLogin extends HookConsumerWidget {
  const MiAuthLogin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverController = useTextEditingController();
    final isAuthed = useState(false);

    useEffect(
      () {
        return () {
          serverController.dispose();
        };
      },
      const [],
    );

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
              TableRow(
                children: [
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
                                const MisskeyServerListDialog(),
                          );
                          if (url != null && url.isNotEmpty) {
                            serverController.text = url;
                          }
                        },
                        icon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  Container(),
                ],
              ),
              TableRow(
                children: [
                  Container(),
                  ElevatedButton(
                    onPressed: () async {
                      await ref
                          .read(accountRepositoryProvider.notifier)
                          .openMiAuth(toAscii(serverController.text))
                          .expectFailure(context);
                        isAuthed.value = true;
                      
                    },
                    child: Text(
                      isAuthed.value
                          ? S.of(context).reauthorizate
                          : S.of(context).authorizate,
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  Container(),
                ],
              ),
              if (isAuthed.value)
                TableRow(
                  children: [
                    Container(),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          IndicatorView.showIndicator(context);
                          await ref
                              .read(accountRepositoryProvider.notifier)
                              .validateMiAuth(toAscii(serverController.text));
                          if (!context.mounted) return;
                          await context.pushRoute(
                            TimeLineRoute(
                              initialTabSetting: ref
                                  .read(tabSettingsRepositoryProvider)
                                  .tabSettings
                                  .first,
                            ),
                          );
                        } catch (e) {
                          rethrow;
                        } finally {
                          IndicatorView.hideIndicator(context);
                        }
                      }.expectFailure(context),
                      child: Text(S.of(context).didAuthorize),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
