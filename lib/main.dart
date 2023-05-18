import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/app_theme.dart';
import 'package:miria/view/common/main_stream.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  String resolveFontFamilyName() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return "Hiragino Maru Gothic ProN";
    }
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      return "Hiragino Maru Gothic ProN";
    }

    return "KosugiMaru";
  }

  List<String> resolveFontFamilyCallback() {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      return ["Noto Sans CJK JP", "KosugiMaru", "BIZ UDPGothic"];
    }
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return ["SF Pro Text", "Apple Color Emoji"];
    }
    return [];
  }

  ThemeData buildTheme(BuildContext context) {
    const foregroundColor = Color.fromARGB(255, 103, 103, 103);
    final textTheme = Theme.of(context).textTheme.merge(ThemeData.light()
        .textTheme
        .apply(
            fontFamily: resolveFontFamilyName(),
            fontFamilyFallback: resolveFontFamilyCallback(),
            bodyColor: foregroundColor));

    final themeData = ThemeData(
        brightness: Brightness.light,
        primarySwatch: const MaterialColor(0xFF86b300, {
          50: Color(0xFFF0F6E0),
          100: Color(0xFFDBE8B3),
          200: Color(0xFFC3D980),
          300: Color(0xFFAACA4D),
          400: Color(0xFF98BE26),
          500: Color(0xFF86B300),
          600: Color(0xFF7EAC00),
          700: Color(0xFF73A300),
          800: Color(0xFF699A00),
          900: Color(0xFF568B00),
        }),
        appBarTheme: AppBarTheme(
            elevation: 0,
            titleSpacing: 0,
            titleTextStyle:
                textTheme.headlineSmall?.copyWith(color: Colors.white),
            iconTheme: const IconThemeData(color: Colors.white)),
        scaffoldBackgroundColor: const Color.fromARGB(255, 249, 249, 249),
        tabBarTheme: TabBarTheme(
            labelColor: foregroundColor,
            labelStyle: textTheme.titleSmall,
            unselectedLabelStyle: textTheme.titleSmall
                ?.copyWith(color: textTheme.bodySmall?.color),
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Theme.of(context).primaryColor))),
        textTheme: textTheme,
        iconTheme: const IconThemeData(color: foregroundColor),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                textStyle: const MaterialStatePropertyAll(
                    TextStyle(color: Colors.white70)),
                foregroundColor: const MaterialStatePropertyAll(Colors.white),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100))))),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100))))),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.all(5),
          hintStyle: textTheme.bodySmall
              ?.copyWith(fontSize: textTheme.titleMedium?.fontSize),
          isDense: true,
        )).copyWith(
        // textTheme: defaultTargetPlatform == TargetPlatform.iOS ||
        //         defaultTargetPlatform == TargetPlatform.macOS
        //     ? null
        //     : GoogleFonts.kosugiTextTheme().merge(const TextTheme(
        //         titleSmall: TextStyle(height: 1.5),
        //         bodyLarge: TextStyle(height: 1.5),
        //         bodyMedium: TextStyle(height: 1.5),
        //         bodySmall: TextStyle(height: 1.5),
        //       )),
        );

    return themeData;
  }

  ThemeData buildDarkTheme(BuildContext context) {
    const foregroundColor = Color.fromARGB(255, 255, 255, 255);
    final textTheme =
        Theme.of(context).textTheme.merge(ThemeData.dark().textTheme.apply(
              fontFamily: resolveFontFamilyName(),
              fontFamilyFallback: resolveFontFamilyCallback(),
            ));
    final themeData = ThemeData(
        brightness: Brightness.dark,
        primarySwatch: const MaterialColor(0xFF86b300, {
          50: Color(0xFFF0F6E0),
          100: Color(0xFFDBE8B3),
          200: Color(0xFFC3D980),
          300: Color(0xFFAACA4D),
          400: Color(0xFF98BE26),
          500: Color(0xFF86B300),
          600: Color(0xFF7EAC00),
          700: Color(0xFF73A300),
          800: Color(0xFF699A00),
          900: Color(0xFF568B00),
        }),
        appBarTheme: AppBarTheme(
            elevation: 0,
            titleSpacing: 0,
            titleTextStyle:
                textTheme.headlineSmall?.copyWith(color: Colors.white),
            iconTheme: const IconThemeData(color: Colors.white)),
        tabBarTheme: TabBarTheme(
            labelColor: foregroundColor,
            labelStyle: textTheme.titleSmall,
            unselectedLabelStyle: textTheme.titleSmall
                ?.copyWith(color: textTheme.bodySmall?.color),
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Theme.of(context).primaryColor))),
        textTheme: textTheme,
        iconTheme: const IconThemeData(color: foregroundColor),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                textStyle: const MaterialStatePropertyAll(
                    TextStyle(color: Colors.white70)),
                foregroundColor: const MaterialStatePropertyAll(Colors.white),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100))))),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100))))),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.all(5),
          hintStyle: textTheme.bodySmall
              ?.copyWith(fontSize: textTheme.titleMedium?.fontSize),
          isDense: true,
        )).copyWith(
        // textTheme: defaultTargetPlatform == TargetPlatform.iOS ||
        //         defaultTargetPlatform == TargetPlatform.macOS
        //     ? null
        //     : GoogleFonts.kosugiTextTheme().merge(const TextTheme(
        //         titleSmall: TextStyle(height: 1.5),
        //         bodyLarge: TextStyle(height: 1.5),
        //         bodyMedium: TextStyle(height: 1.5),
        //         bodySmall: TextStyle(height: 1.5),
        //       )),
        );

    return themeData;
  }

  AppThemeData buildAppThemeData(BuildContext context) {
    return AppThemeData(
      noteTextStyle: InputDecoration(
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black54),
            borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10)),
      ),
      reactionButtonStyle: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          padding: const EdgeInsets.all(5),
          elevation: 0,
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      linkStyle: const TextStyle(color: Color.fromARGB(255, 255, 145, 86)),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSigned = ref.read(accountRepository).account.isNotEmpty;
    final hasTabSetting =
        ref.read(tabSettingsRepositoryProvider).tabSettings.isNotEmpty;

    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: buildTheme(context),
      darkTheme: buildDarkTheme(context),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      locale: const Locale("ja", "JP"),
      supportedLocales: const [
        Locale("ja", "JP"),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, widget) {
        return AppTheme(
          themeData: buildAppThemeData(context),
          child: MainStream(
            child: widget ?? Container(),
          ),
        );
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
