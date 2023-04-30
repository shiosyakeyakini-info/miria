import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/model/tab_settings.dart';
import 'package:flutter_misskey_app/model/tab_type.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/repository/tab_settings_repository.dart';
import 'package:flutter_misskey_app/router/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class InitializeWidget extends ConsumerStatefulWidget {
  const InitializeWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      InitializeWidgetState();
}

class InitializeWidgetState extends ConsumerState<InitializeWidget> {
  Future<void> initialize() async {}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        } else {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
      },
    );
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  final themeData = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        titleSpacing: 0,
      ),
      textTheme: ThemeData.light().textTheme.apply(
          fontFamily: "Hiragino Maru Gothic ProN",
          bodyColor: const Color.fromARGB(255, 103, 103, 103)));

  final darkThemeData = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue,
      appBarTheme: const AppBarTheme(elevation: 0),
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
                icon: Icons.house,
                tabType: TabType.localTimeline,
                name: "パブリックタイムライン"))
      ]),
    );
  }
}
