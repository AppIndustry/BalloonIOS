//
//  AICommonUtils.h
//  BalloonPopper
//
//  Created by Mun Fai Leong on 3/8/15.
//  Copyright (c) 2015 myAppIndustry. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AIEnumCollection.h"
#import "AIGameCard.h"
#import "AIGameCardImageView.h"
#import "AIGameCardEnlargeView.h"

@interface AICommonUtils : NSObject

/// GET CARD IMAGE ///

+(UIImage *)getGameCardImageForGameCard:(AIGameCardName)cardName;
+(UIImage *)getGameCardBackCoverImage;


/// CREATE CUSTOM STRING WITH LETTING SPACING ///

+(NSMutableAttributedString *)createStringWithSpacing:(NSString *)string spacngValue:(float)spacing withUnderLine:(BOOL)isUnderLine;

+(NSMutableAttributedString *)addUnderLineToMutableAttributedString:(NSMutableAttributedString *)attributeString;


/// SETTING OF UIFONT FROM UIFONT FAMILY ///

+ (UIFont *)getCustomTypeface:(AIFontFamily)typeface ofSize:(CGFloat)size;
+(void)getAllFontFamilyWithNames;


/// CREATE ONE SIDED BORDER VIEW ///

+(CALayer *)createOneSidedBorderForUIView:(UIView *)myView Side:(BorderSide)Side;

+(float)getBorderWidthAccordingToDisplay;


/// GET UICOLOR ///

+(UIColor *)getAIColorWithRGB228:(CGFloat)alpha;
+(UIColor *)getAIColorWithRGB192;
@end
