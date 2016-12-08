//
//  Localizable.m
//  Balloon
//
//  Created by MUNFAI-IT on 07/12/2016.
//  Copyright © 2016 myAppIndustry. All rights reserved.
//

#import "Localizable.h"

@implementation Localizable

+ (NSString *)getLocalizeStringForKey:(NSString *)key {
    return [self getLocalizeStringForKey:key comment:nil];
}

+ (NSString *)getLocalizeStringForKey:(NSString *)key comment:(NSString *)comment {
    return NSLocalizedString(key, comment);
}



@end
