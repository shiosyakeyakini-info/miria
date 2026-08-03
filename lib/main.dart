import "dart:async";
import "dart:io";

import "package:flutter/foundation.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:media_kit/media_kit.dart";
import "package:miria/const.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/marionette_debug.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/dialog/dialog_scope.dart";
import "package:miria/view/common/error_dialog_listener.dart";
import "package:miria/view/common/sharing_intent_listener.dart";
import "package:miria/view/themes/app_theme_scope.dart";
import "package:stack_trace/stack_trace.dart" as stack_trace;
import "package:window_manager/window_manager.dart";

Future<void> main() async {
  // debug ビルドでは marionette の binding が立ち上がる。
  // release では通常の WidgetsFlutterBinding と同じ。
  initializeMarionetteBinding();
  MediaKit.ensureInitialized();
  if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
    await windowManager.ensureInitialized();
  }
  FlutterError.demangleStackTrace = (stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };

  runApp(ProviderScope(observers: marionetteObservers, child: const Miria()));
}

class Miria extends HookConsumerWidget with WidgetsBindingObserver {
  const Miria({super.key});

  @override
  Future<void> didChangePlatformBrightness() async {
    super.didChangePlatformBrightness();
    if (!isDesktop) return;

    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;

    /// Set up window brightness follow system theme mode.
    await WindowManager.instance.setBrightness(brightness);
    await WindowManager.instance.setTitleBarStyle(TitleBarStyle.normal);
  }

  Future<void> _initWindow(WidgetRef ref) async {
    if (!isDesktop) return;
    await windowManager.setPreventClose(true);
    final config = ref.read(desktopSettingsRepositoryProvider).settings;

    final size = (config.window.w > 0 && config.window.h > 0)
        ? Size(config.window.w, config.window.h)
        : const Size(400, 700);

    final position = (config.window.x != null && config.window.y != null)
        ? Offset(config.window.x!, config.window.y!)
        : null;

    final opt = WindowOptions(
      size: size,
      center: position == null,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );

    if (position != null) {
      await windowManager.setPosition(position);
    }

    await windowManager.waitUntilReadyToShow(opt, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      if (!isDesktop) return null;
      final windowListener = ref.read(miriaWindowListenerProvider);
      WidgetsBinding.instance.addObserver(this);
      windowManager.addListener(windowListener);
      return () {
        WidgetsBinding.instance.removeObserver(this);
        windowManager.removeListener(windowListener);
      };
    }, const []);
    useMemoized(() {
      unawaited(() async {
        await ref.read(desktopSettingsRepositoryProvider).load();
        await _initWindow(ref);
      }());
    });

    final language = ref.watch(
      generalSettingsRepositoryProvider.select(
        (value) => value.settings.languages,
      ),
    );
    final appRouter = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: "Miria",
      debugShowCheckedModeBanner: false,
      locale: Locale(language.countryCode, language.languageCode),
      supportedLocales: const [
        Locale("ja", "JP"),
        Locale("ja", "OJ"),
        Locale("zh", "CN"),
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
          child: DialogScope(
            child: SharingIntentListener(
              router: appRouter,
              child: ErrorDialogListener(child: widget ?? Container()),
            ),
          ),
        );
      },
      routerConfig: appRouter.config(),
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
