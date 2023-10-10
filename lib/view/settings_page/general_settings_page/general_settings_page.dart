import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miria/const.dart';
import 'package:miria/model/general_settings.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/themes/app_theme.dart';

@RoutePage()
class GeneralSettingsPage extends ConsumerStatefulWidget {
  const GeneralSettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      GeneralSettingsPageState();
}

class GeneralSettingsPageState extends ConsumerState<GeneralSettingsPage> {
  String lightModeTheme = "";
  String darkModeTheme = "";
  ThemeColorSystem colorSystem = ThemeColorSystem.system;
  NSFWInherit nsfwInherit = NSFWInherit.inherit;
  AutomaticPush automaticPush = AutomaticPush.none;
  bool enableDirectReaction = false;
  bool enableAnimatedMFM = true;
  bool enableLongTextElipsed = false;
  bool enableFavoritedRenoteElipsed = true;
  TabPosition tabPosition = TabPosition.top;
  double textScaleFactor = 1.0;
  EmojiType emojiType = EmojiType.twemoji;
  String defaultFontName = "";
  String serifFontName = "";
  String monospaceFontName = "";
  String cursiveFontName = "";
  String fantasyFontName = "";
  Languages language = Languages.jaJP;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = ref.read(generalSettingsRepositoryProvider).settings;
    final colorThemes = ref.read(colorThemeRepositoryProvider);
    setState(() {
      lightModeTheme = settings.lightColorThemeId;
      if (lightModeTheme.isEmpty ||
          colorThemes.every(
            (element) => element.isDarkTheme || element.id != lightModeTheme,
          )) {
        lightModeTheme =
            colorThemes.firstWhere((element) => !element.isDarkTheme).id;
      }
      darkModeTheme = settings.darkColorThemeId;
      if (darkModeTheme.isEmpty ||
          colorThemes.every(
            (element) => !element.isDarkTheme || element.id != darkModeTheme,
          )) {
        darkModeTheme =
            colorThemes.firstWhere((element) => element.isDarkTheme).id;
      }
      colorSystem = settings.themeColorSystem;
      nsfwInherit = settings.nsfwInherit;
      enableDirectReaction = settings.enableDirectReaction;
      automaticPush = settings.automaticPush;
      enableAnimatedMFM = settings.enableAnimatedMFM;
      enableLongTextElipsed = settings.enableLongTextElipsed;
      enableFavoritedRenoteElipsed = settings.enableFavoritedRenoteElipsed;
      tabPosition = settings.tabPosition;
      textScaleFactor = settings.textScaleFactor;
      emojiType = settings.emojiType;
      defaultFontName = settings.defaultFontName;
      serifFontName = settings.serifFontName;
      monospaceFontName = settings.monospaceFontName;
      cursiveFontName = settings.cursiveFontName;
      fantasyFontName = settings.fantasyFontName;
      language = settings.languages;
    });
  }

  Future<void> save() async {
    ref.read(generalSettingsRepositoryProvider).update(
          GeneralSettings(
              lightColorThemeId: lightModeTheme,
              darkColorThemeId: darkModeTheme,
              themeColorSystem: colorSystem,
              nsfwInherit: nsfwInherit,
              enableDirectReaction: enableDirectReaction,
              automaticPush: automaticPush,
              enableAnimatedMFM: enableAnimatedMFM,
              enableFavoritedRenoteElipsed: enableFavoritedRenoteElipsed,
              enableLongTextElipsed: enableLongTextElipsed,
              tabPosition: tabPosition,
              emojiType: emojiType,
              textScaleFactor: textScaleFactor,
              defaultFontName: defaultFontName,
              serifFontName: serifFontName,
              monospaceFontName: monospaceFontName,
              cursiveFontName: cursiveFontName,
              fantasyFontName: fantasyFontName,
              languages: language),
        );
  }

  @override
  Widget build(BuildContext context) {
    final colorThemes = ref.watch(colorThemeRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).generalSettings)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).general,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Text(S.of(context).language),
                      DropdownButton<Languages>(
                        isExpanded: true,
                        items: [
                          for (final element in Languages.values)
                            DropdownMenuItem(
                              value: element,
                              child: Text(element.displayName),
                            ),
                        ],
                        value: language,
                        onChanged: (value) => setState(
                          () {
                            language = value ?? Languages.jaJP;
                            save();
                          },
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Text(S.of(context).displayOfSensitiveNotes),
                      DropdownButton<NSFWInherit>(
                        isExpanded: true,
                        items: [
                          for (final element in NSFWInherit.values)
                            DropdownMenuItem(
                              value: element,
                              child: Text(element.displayName(context)),
                            ),
                        ],
                        value: nsfwInherit,
                        onChanged: (value) => setState(
                          () {
                            nsfwInherit = value ?? NSFWInherit.inherit;
                            save();
                          },
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Text(S.of(context).infiniteScroll),
                      DropdownButton<AutomaticPush>(
                        isExpanded: true,
                        items: [
                          for (final element in AutomaticPush.values)
                            DropdownMenuItem(
                              value: element,
                              child: Text(element.displayName(context)),
                            ),
                        ],
                        value: automaticPush,
                        onChanged: (value) => setState(
                          () {
                            automaticPush = value ?? AutomaticPush.none;
                            save();
                          },
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Text(S.of(context).enableAnimatedMfm),
                      CheckboxListTile(
                        value: enableAnimatedMFM,
                        onChanged: (value) => setState(() {
                          enableAnimatedMFM = value ?? true;
                          save();
                        }),
                        title: Text(S.of(context).enableAnimatedMfmDescription),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Text(S.of(context).collapseNotes),
                      CheckboxListTile(
                        value: enableFavoritedRenoteElipsed,
                        onChanged: (value) => setState(() {
                          enableFavoritedRenoteElipsed = value ?? true;
                          save();
                        }),
                        title: Text(S.of(context).collapseReactionedRenotes),
                      ),
                      CheckboxListTile(
                        value: enableLongTextElipsed,
                        onChanged: (value) => setState(() {
                          enableLongTextElipsed = value ?? true;
                          save();
                        }),
                        title: Text(S.of(context).collapseLongNotes),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Text(S.of(context).tabPosition),
                      DropdownButton<TabPosition>(
                        isExpanded: true,
                        items: [
                          for (final element in TabPosition.values)
                            DropdownMenuItem(
                              value: element,
                              child: Text(
                                S.of(context).tabPositionDescription(
                                      element.displayName(context),
                                    ),
                              ),
                            ),
                        ],
                        value: tabPosition,
                        onChanged: (value) => setState(
                          () {
                            tabPosition = value ?? TabPosition.top;
                            save();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).theme,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Text(S.of(context).themeForLightMode),
                      DropdownButton<String>(
                        isExpanded: true,
                        items: [
                          for (final element in colorThemes
                              .where((element) => !element.isDarkTheme))
                            DropdownMenuItem(
                              value: element.id,
                              child: Text(S.of(context).themeIsh(element.name)),
                            ),
                        ],
                        value: lightModeTheme,
                        onChanged: (value) => setState(
                          () {
                            lightModeTheme = value ?? "";
                            save();
                          },
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Text(S.of(context).themeForDarkMode),
                      DropdownButton<String>(
                        isExpanded: true,
                        items: [
                          for (final element in colorThemes
                              .where((element) => element.isDarkTheme))
                            DropdownMenuItem(
                              value: element.id,
                              child: Text(S.of(context).themeIsh(element.name)),
                            ),
                        ],
                        value: darkModeTheme,
                        onChanged: (value) => setState(() {
                          darkModeTheme = value ?? "";
                          save();
                        }),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Text(S.of(context).selectLightOrDarkMode),
                      DropdownButton<ThemeColorSystem>(
                        isExpanded: true,
                        items: [
                          for (final colorSystem in ThemeColorSystem.values)
                            DropdownMenuItem(
                              value: colorSystem,
                              child: Text(colorSystem.displayName(context)),
                            ),
                        ],
                        value: colorSystem,
                        onChanged: (value) => setState(() {
                          colorSystem = value ?? ThemeColorSystem.system;
                          save();
                        }),
                      ),
                      ListTile(
                        title: Text(S.of(context).manageThemes),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          context.pushRoute(const InstalledThemesRoute());
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).reaction,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      CheckboxListTile(
                        value: enableDirectReaction,
                        title: Text(S.of(context).emojiTapReaction),
                        subtitle:
                            Text(S.of(context).emojiTapReactionDescription),
                        onChanged: (value) {
                          setState(() {
                            enableDirectReaction = !enableDirectReaction;
                            save();
                          });
                        },
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Text(S.of(context).emojiStyle),
                      DropdownButton(
                        items: [
                          for (final type in EmojiType.values)
                            DropdownMenuItem(
                              value: type,
                              child: Text(type.displayName(context)),
                            ),
                        ],
                        value: emojiType,
                        isExpanded: true,
                        onChanged: (value) {
                          setState(() {
                            emojiType = value ?? EmojiType.twemoji;
                            save();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).fontSize,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Slider(
                        value: textScaleFactor,
                        min: 0.5,
                        max: 1.5,
                        divisions: 10,
                        label: "${(textScaleFactor * 100).toInt()}%",
                        onChanged: (value) {
                          setState(() {
                            textScaleFactor = value;
                            save();
                          });
                        },
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Text(
                        S.of(context).fontStandard,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      DropdownButton<Font>(
                        items: [
                          for (final font in choosableFonts)
                            DropdownMenuItem(
                              value: font,
                              child: Text(
                                font.actualName.isEmpty
                                    ? S.of(context).systemFont
                                    : font.displayName,
                                style: GoogleFonts.asMap()[font.actualName]
                                    ?.call(),
                              ),
                            )
                        ],
                        value: choosableFonts.firstWhereOrNull(
                                (e) => e.actualName == defaultFontName) ??
                            choosableFonts.first,
                        isExpanded: true,
                        onChanged: (item) => setState(() {
                          defaultFontName = item?.actualName ?? "";
                          save();
                        }),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Text(
                        S.of(context).fontSerif,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      DropdownButton<Font>(
                        items: [
                          for (final font in choosableFonts)
                            DropdownMenuItem(
                              value: font,
                              child: Text(
                                font.actualName.isEmpty
                                    ? S.of(context).systemFont
                                    : font.displayName,
                                style: GoogleFonts.asMap()[font.actualName]
                                        ?.call() ??
                                    AppTheme.of(context).serifStyle,
                              ),
                            ),
                        ],
                        value: choosableFonts.firstWhereOrNull(
                                (e) => e.actualName == serifFontName) ??
                            choosableFonts.first,
                        isExpanded: true,
                        onChanged: (item) => setState(() {
                          serifFontName = item?.actualName ?? "";
                          save();
                        }),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Text(
                        S.of(context).fontMonospace,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      DropdownButton<Font>(
                        items: [
                          for (final font in choosableFonts)
                            DropdownMenuItem(
                              value: font,
                              child: Text(
                                font.actualName.isEmpty
                                    ? S.of(context).systemFont
                                    : font.displayName,
                                style: GoogleFonts.asMap()[font.actualName]
                                        ?.call() ??
                                    AppTheme.of(context).monospaceStyle,
                              ),
                            ),
                        ],
                        value: choosableFonts.firstWhereOrNull(
                                (e) => e.actualName == monospaceFontName) ??
                            choosableFonts.first,
                        isExpanded: true,
                        onChanged: (item) => setState(
                            () => monospaceFontName = item?.actualName ?? ""),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Text(
                        S.of(context).fontCursive,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      DropdownButton<Font>(
                        items: [
                          for (final font in choosableFonts)
                            DropdownMenuItem(
                              value: font,
                              child: Text(
                                font.actualName.isEmpty
                                    ? S.of(context).systemFont
                                    : font.displayName,
                                style: GoogleFonts.asMap()[font.actualName]
                                        ?.call() ??
                                    AppTheme.of(context).cursiveStyle,
                              ),
                            )
                        ],
                        value: choosableFonts.firstWhereOrNull(
                                (e) => e.actualName == cursiveFontName) ??
                            choosableFonts.first,
                        isExpanded: true,
                        onChanged: (item) => setState(() {
                          cursiveFontName = item?.actualName ?? "";
                          save();
                        }),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Text(
                        S.of(context).fontFantasy,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      DropdownButton<Font>(
                        items: [
                          for (final font in choosableFonts)
                            DropdownMenuItem(
                              value: font,
                              child: Text(
                                font.actualName.isEmpty
                                    ? S.of(context).systemFont
                                    : font.displayName,
                                style: GoogleFonts.asMap()[font.actualName]
                                        ?.call() ??
                                    AppTheme.of(context).fantasyStyle,
                              ),
                            )
                        ],
                        value: choosableFonts.firstWhereOrNull(
                                (e) => e.actualName == fantasyFontName) ??
                            choosableFonts.first,
                        isExpanded: true,
                        onChanged: (item) => setState(() {
                          fantasyFontName = item?.actualName ?? "";
                          save();
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
