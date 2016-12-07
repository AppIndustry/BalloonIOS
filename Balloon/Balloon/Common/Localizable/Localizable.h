//
//  Localizable.h
//  Balloon
//
//  Created by MUNFAI-IT on 07/12/2016.
//  Copyright © 2016 myAppIndustry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Localizable : NSObject

+ (NSString *)getLocalizeStringForKey:(NSString *)key;
+ (NSString *)getLocalizeStringForKey:(NSString *)key comment:(NSString *)comment;

@end
#define kLocale_ @""

#define kLocale_Balloon         @"kLocale_Balloon"
#define kLocale_Tagline         @"kLocale)Tagline"

#define kLocale_Single_Player   @"kLocale_SinglePlayer"
#define kLocale_Multi_Player    @"kLocale_MultiPlayer"

#define kLocale_OK              @"kLocale_OK"
#define kLocale_Cancel          @"kLocale_Cancel"
