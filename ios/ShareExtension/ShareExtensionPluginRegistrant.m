//
//  ShareExtensionPluginRegistrant.m
//  ShareExtension
//
//  Created by Sorairo on 2024/02/04.
//

#import <Foundation/Foundation.h>
#import "ShareExtensionPluginRegistrant.h"

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

@implementation ShareExtensionPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
    
    [SharedPreferenceAppGroupPlugin registerWithRegistrar:[registry registrarForPlugin:@"SharedPreferenceAppGroupPlugin"]];
    [SqflitePlugin registerWithRegistrar:[registry registrarForPlugin:@"SqflitePlugin"]];
}
@end
