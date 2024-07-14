import "dart:async";

import "package:auto_route/auto_route.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/const.dart";
import "package:miria/model/general_settings.dart";
import "package:miria/providers.dart";
import "package:miria/view/themes/built_in_color_themes.dart";

@RoutePage()
class GeneralSettingsPage extends HookConsumerWidget {
  const GeneralSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(generalSettingsRepositoryProvider).settings;

    final lightModeTheme = useState(settings.lightColorThemeId);
    final darkModeTheme = useState(settings.darkColorThemeId);
    final colorSystem = useState(settings.themeColorSystem);
    final nsfwInherit = useState(settings.nsfwInherit);
    final automaticPush = useState(settings.automaticPush);
    final enableDirectReaction = useState(settings.enableDirectReaction);
    final enableAnimatedMFM = useState(settings.enableAnimatedMFM);
    final enableLongTextElipsed = useState(settings.enableLongTextElipsed);
    final enableFavoritedRenoteElipsed =
        useState(settings.enableFavoritedRenoteElipsed);
    final tabPosition = useState(settings.tabPosition);
    final textScaleFactor = useState(settings.textScaleFactor);
    final emojiType = useState(settings.emojiType);
    final defaultFontName = useState(settings.defaultFontName);
    final serifFontName = useState(settings.serifFontName);
    final monospaceFontName = useState(settings.monospaceFontName);
    final cursiveFontName = useState(settings.cursiveFontName);
    final fantasyFontName = useState(settings.fantasyFontName);
    final language = useState(settings.languages);
    final isDeckMode = useState(settings.isDeckMode);

    useMemoized(() {
      if (lightModeTheme.value.isEmpty) {
        lightModeTheme.value = builtInColorThemes
            .where((element) => !element.isDarkTheme)
            .first
            .id;
      }
      if (darkModeTheme.value.isEmpty ||
          builtInColorThemes.every(
            (element) =>
                !element.isDarkTheme || element.id != darkModeTheme.value,
          )) {
        darkModeTheme.value =
            builtInColorThemes.where((element) => element.isDarkTheme).first.id;
      }
    });
    final dependencies = [
      lightModeTheme.value,
      darkModeTheme.value,
      colorSystem.value,
      nsfwInherit.value,
      enableDirectReaction.value,
      automaticPush.value,
      enableAnimatedMFM.value,
      enableFavoritedRenoteElipsed.value,
      enableLongTextElipsed.value,
      tabPosition.value,
      emojiType.value,
      textScaleFactor.value,
      defaultFontName.value,
      serifFontName.value,
      monospaceFontName.value,
      cursiveFontName.value,
      fantasyFontName.value,
      language.value,
      isDeckMode.value,
    ];
    final save = useCallback(
      () async {
        await ref.read(generalSettingsRepositoryProvider).update(
              GeneralSettings(
                lightColorThemeId: lightModeTheme.value,
                darkColorThemeId: darkModeTheme.value,
                themeColorSystem: colorSystem.value,
                nsfwInherit: nsfwInherit.value,
                enableDirectReaction: enableDirectReaction.value,
                automaticPush: automaticPush.value,
                enableAnimatedMFM: enableAnimatedMFM.value,
                enableFavoritedRenoteElipsed:
                    enableFavoritedRenoteElipsed.value,
                enableLongTextElipsed: enableLongTextElipsed.value,
                tabPosition: tabPosition.value,
                emojiType: emojiType.value,
                textScaleFactor: textScaleFactor.value,
                defaultFontName: defaultFontName.value,
                serifFontName: serifFontName.value,
                monospaceFontName: monospaceFontName.value,
                cursiveFontName: cursiveFontName.value,
                fantasyFontName: fantasyFontName.value,
                languages: language.value,
                isDeckMode: isDeckMode.value,
              ),
            );
      },
      dependencies,
    );

    useMemoized(() => unawaited(save()), dependencies);

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
                        value: language.value,
                        onChanged: (value) async {
                          language.value = value ?? Languages.jaJP;
                          await save();
                        },
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
                        value: nsfwInherit.value,
                        onChanged: (value) async =>
                            nsfwInherit.value = value ?? NSFWInherit.inherit,
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
                        value: automaticPush.value,
                        onChanged: (value) async =>
                            automaticPush.value = value ?? AutomaticPush.none,
                      ),
                      const Text("デッキモード"), //TODO: localize
                      CheckboxListTile(
                        title: const Text("デッキモードにします。"),
                        value: isDeckMode.value,
                        onChanged: (value) => isDeckMode.value = value ?? false,
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Text(S.of(context).enableAnimatedMfm),
                      CheckboxListTile(
                        value: enableAnimatedMFM.value,
                        onChanged: (value) =>
                            enableAnimatedMFM.value = value ?? true,
                        title: Text(S.of(context).enableAnimatedMfmDescription),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Text(S.of(context).collapseNotes),
                      CheckboxListTile(
                        value: enableFavoritedRenoteElipsed.value,
                        onChanged: (value) =>
                            enableFavoritedRenoteElipsed.value = value ?? true,
                        title: Text(S.of(context).collapseReactionedRenotes),
                      ),
                      CheckboxListTile(
                        value: enableLongTextElipsed.value,
                        onChanged: (value) async =>
                            enableLongTextElipsed.value = value ?? true,
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
                        value: tabPosition.value,
                        onChanged: (value) async =>
                            tabPosition.value = value ?? TabPosition.top,
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
                        items: [
                          for (final element in builtInColorThemes
                              .where((element) => !element.isDarkTheme))
                            DropdownMenuItem(
                              value: element.id,
                              child: Text(S.of(context).themeIsh(element.name)),
                            ),
                        ],
                        value: lightModeTheme.value,
                        onChanged: (value) async =>
                            lightModeTheme.value = value ?? "",
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Text(S.of(context).themeForDarkMode),
                      DropdownButton<String>(
                        items: [
                          for (final element in builtInColorThemes
                              .where((element) => element.isDarkTheme))
                            DropdownMenuItem(
                              value: element.id,
                              child: Text(S.of(context).themeIsh(element.name)),
                            ),
                        ],
                        value: darkModeTheme.value,
                        onChanged: (value) => darkModeTheme.value = value ?? "",
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Text(S.of(context).selectLightOrDarkMode),
                      DropdownButton<ThemeColorSystem>(
                        items: [
                          for (final colorSystem in ThemeColorSystem.values)
                            DropdownMenuItem(
                              value: colorSystem,
                              child: Text(colorSystem.displayName(context)),
                            ),
                        ],
                        value: colorSystem.value,
                        onChanged: (value) => colorSystem.value =
                            value ?? ThemeColorSystem.system,
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
                        value: enableDirectReaction.value,
                        title: Text(S.of(context).emojiTapReaction),
                        subtitle:
                            Text(S.of(context).emojiTapReactionDescription),
                        onChanged: (value) =>
                            enableDirectReaction.value = value ?? false,
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
                        value: emojiType.value,
                        isExpanded: true,
                        onChanged: (value) =>
                            emojiType.value = value ?? EmojiType.twemoji,
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
                        value: textScaleFactor.value,
                        min: 0.5,
                        max: 1.5,
                        divisions: 10,
                        label: "${(textScaleFactor.value * 100).toInt()}%",
                        onChanged: (value) {
                          textScaleFactor.value = value;
                        },
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: (settings.textScaleFactor ==
                                  textScaleFactor.value)
                              ? null
                              : save,
                          child: const Text("変更"),
                        ),
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
                              ),
                            ),
                        ],
                        value: choosableFonts.firstWhereOrNull(
                              (e) => e.actualName == defaultFontName.value,
                            ) ??
                            choosableFonts.first,
                        isExpanded: true,
                        onChanged: (item) =>
                            defaultFontName.value = item?.actualName ?? "",
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
                              ),
                            ),
                        ],
                        value: choosableFonts.firstWhereOrNull(
                              (e) => e.actualName == serifFontName.value,
                            ) ??
                            choosableFonts.first,
                        isExpanded: true,
                        onChanged: (item) =>
                            serifFontName.value = item?.actualName ?? "",
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
                              ),
                            ),
                        ],
                        value: choosableFonts.firstWhereOrNull(
                              (e) => e.actualName == monospaceFontName.value,
                            ) ??
                            choosableFonts.first,
                        isExpanded: true,
                        onChanged: (item) =>
                            monospaceFontName.value = item?.actualName ?? "",
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
                              ),
                            ),
                        ],
                        value: choosableFonts.firstWhereOrNull(
                              (e) => e.actualName == cursiveFontName.value,
                            ) ??
                            choosableFonts.first,
                        isExpanded: true,
                        onChanged: (item) =>
                            cursiveFontName.value = item?.actualName ?? "",
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
                              ),
                            ),
                        ],
                        value: choosableFonts.firstWhereOrNull(
                              (e) => e.actualName == fantasyFontName.value,
                            ) ??
                            choosableFonts.first,
                        isExpanded: true,
                        onChanged: (item) =>
                            fantasyFontName.value = item?.actualName ?? "",
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
