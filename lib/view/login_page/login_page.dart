import 'dart:ffi';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/repository/tab_settings_repository.dart';
import 'package:flutter_misskey_app/router/app_router.dart';
import 'package:flutter_misskey_app/view/time_line_page/time_line_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  final serverController = TextEditingController();
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final apiKeyController = TextEditingController();

  bool isPasswordAccess = false;

  Future<void> login() async {
    if (isPasswordAccess) {
      await ref.read(accountRepository).loginAsPassword(
          serverController.text, userController.text, passwordController.text);
    } else {
      await ref
          .read(accountRepository)
          .loginAsToken(serverController.text, apiKeyController.text);
    }

    if (!mounted) return;
    context.pushRoute(TimeLineRoute(
        currentTabSetting:
            ref.read(tabSettingsRepositoryProvider).tabSettings.first));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ログイン")),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                    title: Text("パスワードでログインする（可能なサーバーのみ）"),
                    value: isPasswordAccess,
                    onChanged: (value) {
                      setState(() {
                        isPasswordAccess = !isPasswordAccess;
                      });
                    }),
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  children: [
                    TableRow(children: [
                      const Text("サーバー"),
                      TextField(controller: serverController)
                    ]),
                    if (isPasswordAccess) ...[
                      TableRow(children: [
                        const Text("ユーザー名"),
                        TextField(controller: userController)
                      ]),
                      TableRow(children: [
                        const Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Text("パスワード")),
                        TextField(controller: passwordController)
                      ]),
                    ] else ...[
                      TableRow(children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Text("APIキー"),
                        ),
                        TextField(controller: apiKeyController)
                      ]),
                    ],
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
