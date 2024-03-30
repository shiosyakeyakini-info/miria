import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:miria/model/desktop_settings.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/error_dialog_listener.dart';
import 'package:miria/view/common/sharing_intent_listener.dart';
import 'package:miria/view/themes/app_theme_scope.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    windowManager.ensureInitialized();
  }
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WindowListener {
  final _appRouter = AppRouter();
  final isDesktop = Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  @override
  void initState() {
    if (isDesktop) {
      windowManager.addListener(this);
      ref
          .read(desktopSettingsRepositoryProvider)
          .load()
          .then((_) => _initWindow());
    }
    super.initState();
  }

  @override
  void dispose() {
    if (isDesktop) {
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  @override
  void onWindowClose() async {
    if (!isDesktop) return;

    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      final size = await windowManager.getSize();
      final position = await windowManager.getPosition();
      try {
        final settings = ref.read(desktopSettingsRepositoryProvider).settings;
        await ref.read(desktopSettingsRepositoryProvider).update(
            settings.copyWith(
                window: DesktopWindowSettings(
                    w: size.width,
                    h: size.height,
                    x: position.dx,
                    y: position.dy)));
      } catch (e) {
        if (kDebugMode) print(e);
      } finally {
        await windowManager.destroy();
      }
    }
  }

  Future<void> _initWindow() async {
    await windowManager.setPreventClose(true);
    DesktopSettings config =
        ref.read(desktopSettingsRepositoryProvider).settings;

    Size size = (config.window.w > 0 && config.window.h > 0)
        ? Size(config.window.w, config.window.h)
        : const Size(400, 700);

    Offset? position = (config.window.x != null && config.window.y != null)
        ? Offset(config.window.x!, config.window.y!)
        : null;

    WindowOptions opt = WindowOptions(
      size: size,
      center: (position == null),
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );

    if (position != null) {
      windowManager.setPosition(position);
    }

    windowManager.waitUntilReadyToShow(opt, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final language = ref.watch(generalSettingsRepositoryProvider
        .select((value) => value.settings.languages));

    return MaterialApp.router(
      title: 'Miria',
      debugShowCheckedModeBanner: false,
      locale: Locale(language.countryCode, language.languageCode),
      supportedLocales: const [Locale("ja", "JP"), Locale("ja", "OJ"), Locale("zh", "CN")],
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
            router: _appRouter,
            child: ErrorDialogListener(
              child: widget ?? Container(),
            ),
          ),
        );
      },
      routerConfig: _appRouter.config(),
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
