import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:miria/main.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/error_dialog_listener.dart';
import 'package:miria/view/common/sharing_intent_listener.dart';
import 'package:miria/view/themes/app_theme_scope.dart';

class DefaultRootWidget extends StatefulWidget {
  final AppRouter? router;
  final PageRouteInfo<dynamic>? initialRoute;

  const DefaultRootWidget({super.key, this.router, this.initialRoute});

  @override
  State<StatefulWidget> createState() => DefaultRootWidgetState();
}

class DefaultRootWidgetState extends State<DefaultRootWidget> {
  late final AppRouter router;

  @override
  void initState() {
    super.initState();
    router = widget.router ?? AppRouter();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: const Locale("ja", "JP"),
      supportedLocales: const [
        Locale("ja", "JP"),
      ],
      scrollBehavior: AppScrollBehavior(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, widget) {
        return AppThemeScope(
          child: SharingIntentListener(
            router: router,
            child: ErrorDialogListener(
              child: widget ?? Container(),
            ),
          ),
        );
      },
      routerConfig: router.config(
          deepLinkBuilder: widget.initialRoute != null
              ? (_) => DeepLink([widget.initialRoute!])
              : null),
    );
  }
}

class DefaultRootNoRouterWidget extends StatelessWidget {
  final Widget child;

  const DefaultRootNoRouterWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale("ja", "JP"),
      supportedLocales: const [
        Locale("ja", "JP"),
      ],
      home: child,
      scrollBehavior: AppScrollBehavior(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, widget) {
        return AppThemeScope(
          child: ErrorDialogListener(
            child: widget ?? Container(),
          ),
        );
      },
    );
  }
}
