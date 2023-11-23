import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/error_dialog_listener.dart';
import 'package:miria/view/common/main_stream.dart';
import 'package:miria/view/common/sharing_intent_listener.dart';
import 'package:miria/view/themes/app_theme_scope.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainStream(
      child: MaterialApp.router(
        title: 'Miria',
        debugShowCheckedModeBanner: false,
        locale: const Locale("ja", "JP"),
        supportedLocales: const [
          Locale("ja", "JP"),
        ],
        scrollBehavior: AppScrollBehavior(),
        localizationsDelegates: const [
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
      ),
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
