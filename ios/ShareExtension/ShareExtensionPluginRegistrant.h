//
//  ShareExtensionPluginRegistrant.h
//  ShareExtension
//
//  Created by Sorairo on 2024/02/04.
//

#ifndef ShareExtensionPluginRegistrant_h
#define ShareExtensionPluginRegistrant_h

#import <Flutter/Flutter.h>

@interface ShareExtensionPluginRegistrant : NSObject
+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry;
@end

#endif /* ShareExtensionPluginRegistrant_h */
