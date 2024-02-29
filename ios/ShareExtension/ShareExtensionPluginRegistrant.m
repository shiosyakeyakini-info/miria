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

@implementation ShareExtensionPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
    
    [SharedPreferenceAppGroupPlugin registerWithRegistrar:[registry registrarForPlugin:@"SharedPreferenceAppGroupPlugin"]];
}
@end
