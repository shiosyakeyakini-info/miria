import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:miria/view/login_page/api_key_login.dart";
import "package:miria/view/login_page/mi_auth_login.dart";

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).login),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: S.of(context).loginAsMiAuth),
              Tab(text: S.of(context).loginAsAPIKey),
            ],
            tabAlignment: TabAlignment.center,
          ),
        ),
        body: const TabBarView(
          children: [MiAuthLogin(), ApiKeyLogin()],
        ),
      ),
    );
  }
}
