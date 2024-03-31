import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:miria/view/share_extension_page/share_extension_page.dart';
import 'package:shared_preference_app_group/shared_preference_app_group.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceController {
  final bool isShareExtensionContext;

  static const prefs = FlutterSecureStorage();

  const SharedPreferenceController({required this.isShareExtensionContext});

  Future<String?> getString(String key) async {
    if (isShareExtensionContext) {
      return await SharedPreferenceAppGroup.get(key) as String?;
    }
    final storage = await SharedPreferences.getInstance();
    final result = storage.getString(key);
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await SharedPreferenceAppGroup.setString(key, result);
    }
    return result;
  }

  Future<void> setString(String key, String value) async {
    if (isShareExtensionContext) {
      // 共有エクステンションのコンテクストでは書かない
      return;
    }
    final storage = await SharedPreferences.getInstance();
    await storage.setString(key, value);
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await SharedPreferenceAppGroup.setString(key, value);
    }
  }

  Future<String?> getStringSecure(String key) async {
    if (isShareExtensionContext) {
      return await SharedPreferenceAppGroup.get(key) as String?;
    }
    final result = await prefs.read(key: key);
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await SharedPreferenceAppGroup.setString(key, result);
    }
    return result;
  }

  Future<void> setStringSecure(String key, String value) async {
    if (isShareExtensionContext) {
      // 共有エクステンションのコンテクストでは書かない
      return;
    }
    prefs.write(key: key, value: value);
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await SharedPreferenceAppGroup.setString(key, value);
    }
  }
}

final sharedPrefenceControllerProvider = Provider(
  (ref) => SharedPreferenceController(
    isShareExtensionContext: ref.read(isShareExtensionProvider),
  ),
);
