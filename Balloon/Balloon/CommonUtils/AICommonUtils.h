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

#pragma mark - GET CARD IMAGE

/**
    returns the UIImage of a specific Card Type
 */

+ (UIImage *)getGameCardImageForGameCard:(AIGameCardName)cardName;


/**
    returns the back cover UIImage of Game card
*/

+ (UIImage *)getGameCardBackCoverImage;


#pragma mark - CREATE CUSTOM STRING WITH LETTING SPACING

/**
    returns a NSMutableAttributedString, with spacing and underline
    @optional spacing value, underline
 */

+ (NSMutableAttributedString *)createStringWithSpacing:(NSString *)string spacingValue:(float)spacing withUnderLine:(BOOL)isUnderLine;


/**
    returns a NSMutableAttributedString with underline
 */

+ (NSMutableAttributedString *)addUnderLineToMutableAttributedString:(NSMutableAttributedString *)attributeString;


#pragma mark - SETTING OF UIFONT FROM UIFONT FAMILY

/**
    returns a custom Typeface with Font Size
 */

+ (UIFont *)getCustomTypeface:(AIFontFamily)typeface ofSize:(CGFloat)size;


/**
    NSLog all available Font Family with their Names
 */

+ (void)getAllFontFamilyWithNames;


#pragma mark - CREATE ONE SIDED BORDER VIEW

/**
    returns a border view in form of CALayer
    @params BorderSide
 */

+ (CALayer *)createOneSidedBorderForUIView:(UIView *)myView Side:(BorderSide)Side;


/**
    returns a standard BorderWidth according to Resolution of Screen
 */

+ (float)getBorderWidthAccordingToDisplay;


#pragma mark - GET UICOLOR

/**
    returns a white like UIColor
 */

+ (UIColor *)getAIColorWithRGB228:(CGFloat)alpha;


/**
    returns a Silver like UIColor
 */

+ (UIColor *)getAIColorWithRGB192;

/**
    returns a Flat UIColor
 */

+ (UIColor *)getFlatUIColorForColor:(FlatUIColor)color forAlpha:(CGFloat)userAlpha;

@end
