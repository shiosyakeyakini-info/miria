import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/general_settings.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/themes/built_in_color_themes.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = ref.read(generalSettingsRepositoryProvider).settings;
    setState(() {
      lightModeTheme = settings.lightColorThemeId;
      if (lightModeTheme.isEmpty) {
        lightModeTheme = builtInColorThemes
            .where((element) => !element.isDarkTheme)
            .first
            .id;
      }
      darkModeTheme = settings.darkColorThemeId;
      if (darkModeTheme.isEmpty) {
        darkModeTheme =
            builtInColorThemes.where((element) => element.isDarkTheme).first.id;
      }
      colorSystem = settings.themeColorSystem;
      nsfwInherit = settings.nsfwInherit;
      enableDirectReaction = settings.enableDirectReaction;
      automaticPush = settings.automaticPush;
      enableAnimatedMFM = settings.enableAnimatedMFM;
      enableLongTextElipsed = settings.enableLongTextElipsed;
      enableFavoritedRenoteElipsed = settings.enableFavoritedRenoteElipsed;
      tabPosition = settings.tabPosition;
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
              tabPosition: tabPosition),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("全般設定")),
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
                      Text("全般", style: Theme.of(context).textTheme.titleLarge),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      const Text("閲覧注意のついたノートの表示"),
                      DropdownButton<NSFWInherit>(
                        isExpanded: true,
                        items: [
                          for (final element in NSFWInherit.values)
                            DropdownMenuItem(
                              value: element,
                              child: Text(element.displayName),
                            )
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
                      const Text("一覧の自動更新"),
                      DropdownButton<AutomaticPush>(
                        isExpanded: true,
                        items: [
                          for (final element in AutomaticPush.values)
                            DropdownMenuItem(
                              value: element,
                              child: Text(element.displayName),
                            )
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
                      const Text("動きのあるMFM"),
                      CheckboxListTile(
                        value: enableAnimatedMFM,
                        onChanged: (value) => setState(() {
                          enableAnimatedMFM = value ?? true;
                          save();
                        }),
                        title: const Text("動きのあるMFMを有効にします。"),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      const Text("ノートの省略"),
                      CheckboxListTile(
                        value: enableFavoritedRenoteElipsed,
                        onChanged: (value) => setState(() {
                          enableFavoritedRenoteElipsed = value ?? true;
                          save();
                        }),
                        title: const Text("リアクション済みノートのRenoteを省略します。"),
                      ),
                      CheckboxListTile(
                        value: enableLongTextElipsed,
                        onChanged: (value) => setState(() {
                          enableLongTextElipsed = value ?? true;
                          save();
                        }),
                        title: const Text("長いノートを省略します。"),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      const Text("タブの位置"),
                      DropdownButton<TabPosition>(
                        isExpanded: true,
                        items: [
                          for (final element in TabPosition.values)
                            DropdownMenuItem(
                              value: element,
                              child: Text("${element.displayName}に表示する"),
                            )
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
                      Text("テーマ",
                          style: Theme.of(context).textTheme.titleLarge),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      const Text("ライトモードで使うテーマ"),
                      DropdownButton<String>(
                        items: [
                          for (final element in builtInColorThemes
                              .where((element) => !element.isDarkTheme))
                            DropdownMenuItem(
                              value: element.id,
                              child: Text("${element.name}っぽいの"),
                            )
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
                      const Text("ダークモードで使うテーマ"),
                      DropdownButton<String>(
                          items: [
                            for (final element in builtInColorThemes
                                .where((element) => element.isDarkTheme))
                              DropdownMenuItem(
                                value: element.id,
                                child: Text("${element.name}っぽいの"),
                              )
                          ],
                          value: darkModeTheme,
                          onChanged: (value) => setState(() {
                                darkModeTheme = value ?? "";
                                save();
                              })),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      const Text("ライトモード・ダークモードのつかいわけ"),
                      DropdownButton<ThemeColorSystem>(
                          items: [
                            for (final colorSystem in ThemeColorSystem.values)
                              DropdownMenuItem(
                                value: colorSystem,
                                child: Text(colorSystem.displayName),
                              )
                          ],
                          value: colorSystem,
                          onChanged: (value) => setState(() {
                                colorSystem = value ?? ThemeColorSystem.system;
                                save();
                              }))
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
                      Text("リアクション",
                          style: Theme.of(context).textTheme.titleLarge),
                      CheckboxListTile(
                          value: enableDirectReaction,
                          title: const Text("ノート内の絵文字タップでリアクションする"),
                          subtitle: const Text(
                              "ノート内の絵文字をタップしてリアクションします。MFMや外部サーバーの絵文字の場合うまく機能しないことがあります。"),
                          onChanged: (value) {
                            setState(() {
                              enableDirectReaction = !enableDirectReaction;
                              save();
                            });
                          })
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
