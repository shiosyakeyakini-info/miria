import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/router/app_router.dart';
import 'package:flutter_misskey_app/view/login_page/centraing_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MiAuthLogin extends ConsumerStatefulWidget {
  const MiAuthLogin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MiAuthLoginState();
}

class MiAuthLoginState extends ConsumerState<MiAuthLogin> {
  final serverController = TextEditingController();
  bool isAuthed = false;

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
              const Text("サーバー"),
              TextField(
                controller: serverController,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.dns)),
              ),
            ]),
            TableRow(children: [
              Padding(padding: EdgeInsets.only(bottom: 10)),
              Container()
            ]),
            TableRow(children: [
              Container(),
              ElevatedButton(
                onPressed: () {
                  ref.read(accountRepository).openMiAuth(serverController.text);
                  setState(() {
                    isAuthed = true;
                  });
                },
                child: Text(isAuthed ? "再度認証をする" : "認証をする"),
              ),
            ]),
            TableRow(children: [
              Padding(padding: EdgeInsets.only(bottom: 10)),
              Container()
            ]),
            if (isAuthed)
              TableRow(children: [
                Container(),
                ElevatedButton(
                  onPressed: () async {
                    await ref
                        .read(accountRepository)
                        .validateMiAuth(serverController.text);
                    if (!mounted) return;
                    context.pushRoute(TimeLineRoute(
                        currentTabSetting: ref
                            .read(tabSettingsRepositoryProvider)
                            .tabSettings
                            .first));
                  },
                  child: Text("認証してきた"),
                ),
              ]),
          ],
        ),
      ],
    ));
  }
}
