import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/login_page/centraing_widget.dart';
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

  @override
  void dispose() {
    serverController.dispose();
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    await ref.read(accountRepositoryProvider.notifier).loginAsPassword(
        serverController.text, userController.text, passwordController.text);

    if (!mounted) return;
    context.pushRoute(TimeLineRoute(
        initialTabSetting:
            ref.read(tabSettingsRepositoryProvider).tabSettings.first));
  }

  @override
  Widget build(BuildContext context) {
    return CenteringWidget(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
          const Text("この機能はめいどるふぃんなどを想定していますが、現状機能しません。"),
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
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
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
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
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
                    padding: const EdgeInsets.only(top: 10),
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
