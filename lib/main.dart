import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/model/tab_settings.dart';
import 'package:flutter_misskey_app/model/tab_type.dart';
import 'package:flutter_misskey_app/router/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  final themeData = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      fontFamily: "Hiragino Maru Gothic ProN");

  final darkThemeData = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue,
      fontFamily: "Hiragino Maru Gothic ProN");

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: themeData,
      darkTheme: darkThemeData,
      themeMode: ThemeMode.system,
      routerConfig: _appRouter.config(initialRoutes: [
        TimeLineRoute(
            currentTabSetting: const TabSettings(
                icon: Icons.home, tabType: TabType.localTimeline))
      ]),
    );
  }
}
