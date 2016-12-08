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
#define kLocale_Tagline         @"kLocale_Tagline"

#define kLocale_Single_Player   @"kLocale_SinglePlayer"
#define kLocale_Multi_Player    @"kLocale_MultiPlayer"

#define kLocale_GameMode_Full               @"kLocale_GameMode_Full"
#define kLocale_GameMode_Short              @"kLocale_GameMode_Short"
#define kLocale_GameMode_Full_Description   @"kLocale_GameMode_Full_Description"
#define kLocale_GameMode_Short_Description  @"kLocale_GameMode_Short_Description"

#define kLocale_Player          @"kLocale_Player"
#define kLocale_Computer        @"kLocale_Computer"

#define kLocale_You     @"kLocale_You"
#define kLocale_Your    @"kLocale_Your"

#define kLocale_OK              @"kLocale_OK"
#define kLocale_Cancel          @"kLocale_Cancel"

#define kLocale_Login                   @"kLocale_Login"
#define kLocale_Authenticated           @"kLocale_Authenticated"
#define kLocale_Unauthenticated         @"kLocale_Unauthenticated"
#define kLocale_GameCenter_LoginError   @"KLocale_GameCenter_LoginError"
