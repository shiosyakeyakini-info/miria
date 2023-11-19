import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miria/extensions/color_extension.dart';
import 'package:miria/model/color_theme.dart';
import 'package:miria/model/general_settings.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/themes/app_theme.dart';
import 'package:miria/view/themes/built_in_color_themes.dart';

class AppThemeScope extends ConsumerStatefulWidget {
  final Widget child;

  const AppThemeScope({super.key, required this.child});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AppThemeScopeState();
}

class AppThemeScopeState extends ConsumerState<AppThemeScope> {
  AppThemeData buildDarkAppThemeData({
    required BuildContext context,
    required ColorTheme theme,
    required String serifFontName,
    required String monospaceFontName,
    required String cursiveFontName,
    required String fantasyFontName,
  }) {
    return AppThemeData(
      isDarkMode: theme.isDarkTheme,
      noteTextStyle: const InputDecoration(),
      reactionButtonStyle: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(5),
          elevation: 0,
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      linkStyle: TextStyle(color: theme.link),
      hashtagStyle: TextStyle(color: theme.hashtag),
      mentionStyle: TextStyle(color: theme.mention),
      serifStyle: resolveFontFamilySerif(serifFontName),
      monospaceStyle: resolveFontFamilyMonospace(monospaceFontName),
      cursiveStyle: cursiveFontName.isNotEmpty
          ? (fromGoogleFont(cursiveFontName) ?? const TextStyle())
          : const TextStyle(),
      fantasyStyle: fantasyFontName.isNotEmpty
          ? (fromGoogleFont(fantasyFontName) ?? const TextStyle())
          : const TextStyle(),
      reactionButtonBackgroundColor: theme.buttonBackground,
      reactionButtonMeReactedColor: theme.primary,
      renoteBorderColor: theme.renote,
      renoteBorderRadius: const Radius.circular(20),
      renoteStrokeWidth: 1.5,
      renoteStrokePadding: 0.0,
      renoteDashPattern: [10.0, 6.0],
      buttonBackground: theme.buttonBackground,
      currentDisplayTabColor:
          theme.isDarkTheme ? theme.primaryDarken : theme.primaryLighten,
      voteColor1: theme.isDarkTheme
          ? theme.primaryLighten.lighten()
          : theme.primaryDarken.darken(),
      voteColor2: theme.isDarkTheme
          ? theme.primaryDarken.darken()
          : theme.primaryLighten.lighten(),
      unicodeEmojiStyle: resolveUnicodeEmojiStyle(),
    );
  }

  String resolveFontFamilyName(String defaultFontName) {
    if (defaultFontName.isNotEmpty) {
      return defaultFontName;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return "SF Pro Text";
    }
    if (defaultTargetPlatform == TargetPlatform.linux) {
      return "Noto Sans CJK JP";
    }

    return "KosugiMaru";
  }

  List<String> resolveFontFamilyFallback(String defaultFontName) {
    if (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux) {
      return [
        if (defaultFontName.isNotEmpty) resolveFontFamilyName(""),
        "Noto Sans CJK JP",
        "KosugiMaru",
        "BIZ UDPGothic"
      ];
    }
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return [
        if (defaultFontName.isNotEmpty) resolveFontFamilyName(""),
        "Hiragino Maru Gothic ProN",
        "Apple Color Emoji",
      ];
    }
    return [];
  }

  TextStyle resolveFontFamilySerif(String defaultFontName) {
    final fallback = <String>[];

    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      fallback.addAll(["Hiragino Mincho ProN", "Apple Color Emoji"]);
    } else {
      fallback.addAll(["Noto Serif CJK JP", "Noto Serif", "Droid Serif"]);
    }
    return (defaultFontName.isEmpty
            ? const TextStyle()
            : (fromGoogleFont(defaultFontName) ?? const TextStyle()))
        .copyWith(fontFamilyFallback: fallback);
  }

  TextStyle resolveFontFamilyMonospace(String monospaceFontName) {
    final String? fontName;
    final fallback = <String>[];

    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      fontName = "Monaco";
      fallback.addAll(const ["Apple Color Emoji", "Hiragino Maru Gothic ProN"]);
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      fontName = "Consolas";
      fallback.addAll(const ["Segoe UI Emoji", "Noto Color Emoji", "Meiryo"]);
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      fontName = "Droid Sans Mono";
      fallback.addAll(const ["Noto Color Emoji", "Noto Sans JP"]);
    } else {
      fontName = null;
    }
    return (monospaceFontName.isNotEmpty
            ? (fromGoogleFont(monospaceFontName) ??
                TextStyle(fontFamily: fontName))
            : TextStyle(fontFamily: fontName))
        .copyWith(fontFamilyFallback: fallback);
  }

  TextStyle resolveUnicodeEmojiStyle() {
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return const TextStyle(
          fontFamily: "Apple Color Emoji",
          fontFamilyFallback: [
            "Apple Color Emoji",
            "Hiragino Maru Gothic ProN"
          ]);
    }
    if (defaultTargetPlatform == TargetPlatform.windows) {
      return const TextStyle(
          fontFamily: "Segoe UI Emoji",
          fontFamilyFallback: ["Segoe UI Emoji", "Noto Color Emoji", "Meiryo"]);
    }
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.linux) {
      return const TextStyle(
          fontFamily: "Noto Color Emoji",
          fontFamilyFallback: ["Noto Color Emoji", "Noto Sans JP"]);
    }
    return const TextStyle();
  }

  TextTheme applyGoogleFont(TextTheme textTheme, String? fontName) {
    return fontName != null && GoogleFonts.asMap().containsKey(fontName)
        ? GoogleFonts.getTextTheme(fontName, textTheme)
        : textTheme;
  }

  TextStyle? fromGoogleFont(String? fontName) {
    return fontName != null &&
            fontName.isNotEmpty == true &&
            GoogleFonts.asMap().containsKey(fontName)
        ? GoogleFonts.getFont(fontName)
        : null;
  }

  ThemeData buildTheme({
    required BuildContext context,
    required ColorTheme theme,
    required String defaultFontName,
  }) {
    final textThemePre = applyGoogleFont(
        Theme.of(context).textTheme.merge((theme.isDarkTheme
                ? ThemeData.dark()
                : ThemeData.light())
            .textTheme
            .apply(
                fontFamily: resolveFontFamilyName(defaultFontName),
                fontFamilyFallback: resolveFontFamilyFallback(defaultFontName),
                bodyColor: theme.foreground)),
        defaultFontName);
    final textTheme = textThemePre.copyWith(
        bodySmall: textThemePre.bodySmall?.copyWith(
            color: theme.isDarkTheme
                ? theme.foreground.darken(0.1)
                : theme.foreground.lighten(0.1)));

    final themeData = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: theme.primary,
        brightness: theme.isDarkTheme ? Brightness.dark : Brightness.light,
        primary: theme.primary,
      ),
      brightness: theme.isDarkTheme ? Brightness.dark : Brightness.light,
      useMaterial3: false,
      primaryColor: theme.primary,
      primaryColorDark: theme.primaryDarken,
      primaryColorLight: theme.primaryLighten,
      appBarTheme: AppBarTheme(
        elevation: 0,
        titleSpacing: 0,
        titleTextStyle: textTheme.headlineSmall?.copyWith(color: Colors.white),
        backgroundColor:
            theme.isDarkTheme ? theme.panelBackground : theme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      bottomAppBarTheme: BottomAppBarTheme(color: theme.primary),
      drawerTheme: DrawerThemeData(backgroundColor: theme.panel),
      listTileTheme: ListTileThemeData(iconColor: theme.foreground),
      scaffoldBackgroundColor: theme.panel,
      tabBarTheme: TabBarTheme(
        overlayColor: MaterialStatePropertyAll(theme.primary),
        labelColor: Colors.white,
        labelStyle: textTheme.titleSmall,
        unselectedLabelStyle:
            textTheme.titleSmall?.copyWith(color: Colors.white60),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: theme.primary),
        ),
      ),
      textTheme: textTheme,
      iconTheme: IconThemeData(color: theme.foreground),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStatePropertyAll(
            textTheme.bodyMedium?.copyWith(
              inherit: false,
              color: Colors.white,
            ),
          ),
          backgroundColor: MaterialStatePropertyAll(theme.primary),
          foregroundColor: const MaterialStatePropertyAll(Colors.white),
          elevation: const MaterialStatePropertyAll(0),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          ),
          visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
          tapTargetSize: MaterialTapTargetSize.padded,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStatePropertyAll(theme.primary),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          ),
          visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
          tapTargetSize: MaterialTapTargetSize.padded,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          iconColor: MaterialStatePropertyAll(theme.primary),
          foregroundColor: MaterialStatePropertyAll(theme.primary),
        ),
      ),
      dividerTheme: DividerThemeData(color: theme.divider),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: theme.primary),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: theme.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: theme.panelBackground,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color:
                theme.isDarkTheme ? theme.primaryDarken : theme.primaryLighten,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.primary),
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.all(5),
        hintStyle: textTheme.bodySmall?.copyWith(
          fontSize: textTheme.titleMedium?.fontSize,
          color: theme.isDarkTheme
              ? theme.foreground.darken(0.2)
              : theme.foreground.lighten(0.2),
        ),
        prefixIconColor: theme.primary,
        suffixIconColor: theme.primary,
        isDense: true,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.disabled)) {
              return null;
            }
            if (states.contains(MaterialState.selected)) {
              return theme.primary;
            }
            return null;
          },
        ),
      ),
      expansionTileTheme: ExpansionTileThemeData(iconColor: theme.primary),
      toggleButtonsTheme: ToggleButtonsThemeData(
        color: theme.primary,
        selectedColor: Colors.white,
        borderColor: theme.divider,
        borderWidth: 1.0,
        highlightColor:
            theme.isDarkTheme ? theme.primaryDarken : theme.primaryLighten,
        fillColor:
            theme.isDarkTheme ? theme.primaryDarken : theme.primaryLighten,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: theme.primary,
        unselectedItemColor: Colors.white,
      ),
      sliderTheme: SliderThemeData.fromPrimaryColors(
        primaryColor: theme.primary,
        primaryColorDark: theme.primaryDarken,
        primaryColorLight: theme.primaryLighten,
        valueIndicatorTextStyle: textTheme.bodySmall ?? const TextStyle(),
      ).copyWith(
        valueIndicatorColor: theme.panel,
        valueIndicatorShape: const RectangularSliderValueIndicatorShape(),
      ),
    );

    return themeData;
  }

  @override
  Widget build(BuildContext context) {
    final colorSystem = ref.watch(generalSettingsRepositoryProvider
        .select((value) => value.settings.themeColorSystem));
    final lightTheme = ref.watch(generalSettingsRepositoryProvider
        .select((value) => value.settings.lightColorThemeId));
    final darkTheme = ref.watch(generalSettingsRepositoryProvider
        .select((value) => value.settings.darkColorThemeId));
    final textScaleFactor = ref.watch(
      generalSettingsRepositoryProvider
          .select((value) => value.settings.textScaleFactor),
    );
    final defaultFontName = ref.watch(generalSettingsRepositoryProvider
        .select((value) => value.settings.defaultFontName));
    final serifFontName = ref.watch(generalSettingsRepositoryProvider
        .select((value) => value.settings.serifFontName));
    final monospaceFontName = ref.watch(generalSettingsRepositoryProvider
        .select((value) => value.settings.monospaceFontName));
    final cursiveFontName = ref.watch(generalSettingsRepositoryProvider
        .select((value) => value.settings.cursiveFontName));
    final fantasyFontName = ref.watch(generalSettingsRepositoryProvider
        .select((value) => value.settings.fantasyFontName));

    final bool isDark;
    if (colorSystem == ThemeColorSystem.system) {
      isDark = WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    } else if (colorSystem == ThemeColorSystem.forceDark) {
      isDark = true;
    } else {
      isDark = false;
    }

    final foundColorTheme = builtInColorThemes.firstWhereOrNull((e) =>
            e.isDarkTheme == isDark &&
            e.id == (isDark ? darkTheme : lightTheme)) ??
        builtInColorThemes
            .firstWhere((element) => element.isDarkTheme == isDark);

    return Theme(
      data: buildTheme(
        context: context,
        theme: foundColorTheme,
        defaultFontName: defaultFontName,
      ),
      child: AppTheme(
        themeData: buildDarkAppThemeData(
            context: context,
            theme: foundColorTheme,
            serifFontName: serifFontName,
            monospaceFontName: monospaceFontName,
            cursiveFontName: cursiveFontName,
            fantasyFontName: fantasyFontName),
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: true,
            textScaler: textScaleFactor != 1
                ? TextScaler.linear(
                    MediaQuery.textScalerOf(context).scale(textScaleFactor),
                  )
                : null,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
