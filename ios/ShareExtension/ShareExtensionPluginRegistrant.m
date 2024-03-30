//
//  ShareExtensionPluginRegistrant.m
//  ShareExtension
//
//  Created by Sorairo on 2024/02/04.
//

#import <Foundation/Foundation.h>
#import "ShareExtensionPluginRegistrant.h"

//#if __has_include(<shared_preference_app_group/SharedPreferenceAppGroupPlugin.h>)
//#import <shared_preference_app_group/SharedPreferenceAppGroupPlugin.h>
//#else
//@import shared_preference_app_group;
//#endif
//
//#if __has_include(<sqflite/SqflitePlugin.h>)
//#import <sqflite/SqflitePlugin.h>
//#else
//@import sqflite;
//#endif


#if __has_include(<device_info_plus/FPPDeviceInfoPlusPlugin.h>)
#import <device_info_plus/FPPDeviceInfoPlusPlugin.h>
#else
@import device_info_plus;
#endif

#if __has_include(<flutter_image_compress_common/ImageCompressPlugin.h>)
#import <flutter_image_compress_common/ImageCompressPlugin.h>
#else
@import flutter_image_compress_common;
#endif

#if __has_include(<flutter_secure_storage/FlutterSecureStoragePlugin.h>)
#import <flutter_secure_storage/FlutterSecureStoragePlugin.h>
#else
@import flutter_secure_storage;
#endif

#if __has_include(<media_kit_libs_ios_video/MediaKitLibsIosVideoPlugin.h>)
#import <media_kit_libs_ios_video/MediaKitLibsIosVideoPlugin.h>
#else
@import media_kit_libs_ios_video;
#endif

#if __has_include(<media_kit_video/MediaKitVideoPlugin.h>)
#import <media_kit_video/MediaKitVideoPlugin.h>
#else
@import media_kit_video;
#endif

#if __has_include(<package_info_plus/FPPPackageInfoPlusPlugin.h>)
#import <package_info_plus/FPPPackageInfoPlusPlugin.h>
#else
@import package_info_plus;
#endif

#if __has_include(<path_provider_foundation/PathProviderPlugin.h>)
#import <path_provider_foundation/PathProviderPlugin.h>
#else
@import path_provider_foundation;
#endif

#if __has_include(<receive_sharing_intent/ReceiveSharingIntentPlugin.h>)
#import <receive_sharing_intent/ReceiveSharingIntentPlugin.h>
#else
@import receive_sharing_intent;
#endif

#if __has_include(<share_plus/FPPSharePlusPlugin.h>)
#import <share_plus/FPPSharePlusPlugin.h>
#else
@import share_plus;
#endif

#if __has_include(<shared_preference_app_group/SharedPreferenceAppGroupPlugin.h>)
#import <shared_preference_app_group/SharedPreferenceAppGroupPlugin.h>
#else
@import shared_preference_app_group;
#endif

#if __has_include(<sqflite/SqflitePlugin.h>)
#import <sqflite/SqflitePlugin.h>
#else
@import sqflite;
#endif

#if __has_include(<wakelock_plus/WakelockPlusPlugin.h>)
#import <wakelock_plus/WakelockPlusPlugin.h>
#else
@import wakelock_plus;
#endif

//#if __has_include(<shared_preferences_foundation/SharedPreferencesPlugin.h>)
//#import <shared_preferences_foundation/SharedPreferencesPlugin.h>
//#else
//@import shared_preferences_foundation;
//#endif

@implementation ShareExtensionPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
    
//    [SharedPreferenceAppGroupPlugin registerWithRegistrar:[registry registrarForPlugin:@"SharedPreferenceAppGroupPlugin"]];
//    [SqflitePlugin registerWithRegistrar:[registry registrarForPlugin:@"SqflitePlugin"]];
    
    
    [FPPDeviceInfoPlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"FPPDeviceInfoPlusPlugin"]];
//    [FilePickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FilePickerPlugin"]];
    [ImageCompressPlugin registerWithRegistrar:[registry registrarForPlugin:@"ImageCompressPlugin"]];
    [FlutterSecureStoragePlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterSecureStoragePlugin"]];
//    [ImageEditorPlugin registerWithRegistrar:[registry registrarForPlugin:@"ImageEditorPlugin"]];
//    [ImageGallerySaverPlugin registerWithRegistrar:[registry registrarForPlugin:@"ImageGallerySaverPlugin"]];
    [MediaKitLibsIosVideoPlugin registerWithRegistrar:[registry registrarForPlugin:@"MediaKitLibsIosVideoPlugin"]];
    [MediaKitVideoPlugin registerWithRegistrar:[registry registrarForPlugin:@"MediaKitVideoPlugin"]];
//    [FPPPackageInfoPlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"FPPPackageInfoPlusPlugin"]];
    [PathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"PathProviderPlugin"]];
//    [PermissionHandlerPlugin registerWithRegistrar:[registry registrarForPlugin:@"PermissionHandlerPlugin"]];
    [ReceiveSharingIntentPlugin registerWithRegistrar:[registry registrarForPlugin:@"ReceiveSharingIntentPlugin"]];
//    [ScreenBrightnessIosPlugin registerWithRegistrar:[registry registrarForPlugin:@"ScreenBrightnessIosPlugin"]];
    [FPPSharePlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"FPPSharePlusPlugin"]];
    [SharedPreferenceAppGroupPlugin registerWithRegistrar:[registry registrarForPlugin:@"SharedPreferenceAppGroupPlugin"]];
//    [SharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"SharedPreferencesPlugin"]];
    [SqflitePlugin registerWithRegistrar:[registry registrarForPlugin:@"SqflitePlugin"]];
//    [URLLauncherPlugin registerWithRegistrar:[registry registrarForPlugin:@"URLLauncherPlugin"]];
//    [VolumeControllerPlugin registerWithRegistrar:[registry registrarForPlugin:@"VolumeControllerPlugin"]];
    [WakelockPlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"WakelockPlusPlugin"]];
//    [FLTWebViewFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTWebViewFlutterPlugin"]];
    
}
@end
