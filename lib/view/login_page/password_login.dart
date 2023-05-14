import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/router/app_router.dart';
import 'package:flutter_misskey_app/view/login_page/centraing_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordLogin extends ConsumerStatefulWidget {
  const PasswordLogin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => PasswordLoginState();
}

class PasswordLoginState extends ConsumerState<PasswordLogin> {
  final serverController = TextEditingController();
  final userController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    await ref.read(accountRepository).loginAsPassword(
        serverController.text, userController.text, passwordController.text);

    if (!mounted) return;
    context.pushRoute(TimeLineRoute(
        currentTabSetting:
            ref.read(tabSettingsRepositoryProvider).tabSettings.first));
  }

  @override
  Widget build(BuildContext context) {
    return CenteringWidget(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
          Text("この機能はめいどるふぃんなどを想定していますが、現状機能しません。"),
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
                    enabled: false,
                    controller: serverController,
                    decoration:
                        const InputDecoration(prefixIcon: Icon(Icons.dns)),
                  ),
                ]),
                TableRow(children: [
                  Padding(padding: EdgeInsets.only(bottom: 10)),
                  Container()
                ]),
                TableRow(children: [
                  const Text("ユーザー名"),
                  TextField(
                      enabled: false,
                      controller: userController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.account_circle)))
                ]),
                TableRow(children: [
                  Padding(padding: EdgeInsets.only(bottom: 10)),
                  Container()
                ]),
                TableRow(children: [
                  const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text("パスワード")),
                  TextField(
                    enabled: false,
                    controller: passwordController,
                    decoration:
                        const InputDecoration(prefixIcon: Icon(Icons.key)),
                    obscureText: true,
                  )
                ]),
                TableRow(children: [
                  Container(),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                        onPressed: () {
                          login();
                        },
                        child: const Text("ログイン")),
                  )
                ])
              ])
        ]));
  }
}
