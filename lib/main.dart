import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/router/app_router.dart';
import 'package:flutter_misskey_app/view/common/main_stream.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };

  runApp(const ProviderScope(child: InitializeWidget()));
}

class InitializeWidget extends ConsumerStatefulWidget {
  const InitializeWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      InitializeWidgetState();
}

class InitializeWidgetState extends ConsumerState<InitializeWidget> {
  Widget? cacheWidget;

  Future<void> initialize() async {
    await ref.read(accountRepository).load();
    await ref.read(tabSettingsRepositoryProvider).load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (cacheWidget != null) return cacheWidget!;
    return FutureBuilder(
      future: initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          cacheWidget = MyApp();
          return cacheWidget!;
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

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  final themeData = ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            titleSpacing: 0,
          ),
          tabBarTheme: const TabBarTheme(
              labelColor: const Color.fromARGB(255, 103, 103, 103),
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.blue))),
          textTheme: ThemeData.light().textTheme.apply(
              fontFamily: "Hiragino Maru Gothic ProN",
              bodyColor: const Color.fromARGB(255, 103, 103, 103)))
      .copyWith(
    textTheme: defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS
        ? null
        : GoogleFonts.kosugiTextTheme().merge(const TextTheme(
            titleSmall: TextStyle(height: 1.5),
            bodyLarge: TextStyle(height: 1.5),
            bodyMedium: TextStyle(height: 1.5),
            bodySmall: TextStyle(height: 1.5),
          )),
  );

  final darkThemeData = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    primaryColor: Colors.blue,
    appBarTheme: const AppBarTheme(elevation: 0),
    fontFamily: "Hiragino Maru Gothic ProN",
  ).copyWith(
    textTheme: defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS
        ? null
        : GoogleFonts.kosugiTextTheme().copyWith(
            bodySmall: TextStyle(height: 1.5),
            bodyMedium: TextStyle(height: 1.5),
          ),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSigned = ref.read(accountRepository).account.isNotEmpty;
    final hasTabSetting =
        ref.read(tabSettingsRepositoryProvider).tabSettings.isNotEmpty;

    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: themeData,
      darkTheme: darkThemeData,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      builder: (context, widget) {
        return MainStream(child: widget ?? Container());
      },
      routerConfig: _appRouter.config(initialRoutes: [
        if (isSigned && hasTabSetting)
          TimeLineRoute(
              currentTabSetting:
                  ref.read(tabSettingsRepositoryProvider).tabSettings.first)
        else if (isSigned && !hasTabSetting)
          const TabSettingsListRoute()
        else
          const LoginRoute(),
      ]),
    );
  }
}
