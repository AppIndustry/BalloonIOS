//
//  AICommonUtils.m
//  BalloonPopper
//
//  Created by Mun Fai Leong on 3/8/15.
//  Copyright (c) 2015 myAppIndustry. All rights reserved.
//

#import "AICommonUtils.h"

@implementation AICommonUtils

#pragma mark - GET CARD IMAGE

+ (UIImage *)getGameCardImageForGameCard:(AIGameCardName)cardName {
    UIImage *returnImage;
    
    switch (cardName)
    {
        case GameCardAddFiveSecond:
            returnImage = [UIImage imageNamed:@"FiveSecond"];
            break;
            
        case GameCardAddTenSecond:
            returnImage = [UIImage imageNamed:@"TenSecond"];
            break;
            
        case GameCardDoublePlay:
            returnImage = [UIImage imageNamed:@"DoublePlay"];
            break;
            
        case GameCardDrawOne:
            returnImage = [UIImage imageNamed:@"PlusOne"];
            break;
            
        case GameCardDrawTwo:
            returnImage = [UIImage imageNamed:@"PlusTwo"];
            break;
            
        case GameCardPop:
            returnImage = [UIImage imageNamed:@"Popped"];
            break;
            
        case GameCardReverse:
            returnImage = [UIImage imageNamed:@"Reverse"];
            break;
            
        case GameCardCut:
            returnImage = [UIImage imageNamed:@"Hold"];
            break;
            
        case GameCardSkip:
            returnImage = [UIImage imageNamed:@"Skip"];
            break;
            
        case GameCardToSixtySecond:
            returnImage = [UIImage imageNamed:@"UpToSixtySecond"];
            break;
            
        case GameCardToThirtySecond:
            returnImage = [UIImage imageNamed:@"ToThirtySecond"];
            break;
            
        case GameCardToZeroSecond:
            returnImage = [UIImage imageNamed:@"DownToZeroSecond"];
            break;
            
        case GameCardTradeHand:
            returnImage = [UIImage imageNamed:@"TradeHand"];
            break;
            
        default:
            break;
    }
    
    return  returnImage;
}

+ (UIImage *)getGameCardBackCoverImage {
    return [UIImage imageNamed:@"BackCover"];
}


#pragma mark - CREATE CUSTOM STRING WITH LETTING SPACING

+ (NSMutableAttributedString *)createStringWithSpacing:(NSString *)string spacingValue:(float)spacing withUnderLine:(BOOL)isUnderLine {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:string];
    
    [attributeString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, string.length)];
    
    if (isUnderLine)
        attributeString = [self addUnderLineToMutableAttributedString:attributeString];
    
    return attributeString;
}

+ (NSMutableAttributedString *)addUnderLineToMutableAttributedString:(NSMutableAttributedString *)attributeString {
    [attributeString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, attributeString.length)];
    
    return attributeString;
}


#pragma mark - SETTING OF UIFONT FROM UIFONT FAMILY

+ (UIFont *)getCustomTypeface:(AIFontFamily)typeface ofSize:(CGFloat)size {
    return [UIFont fontWithName:[self getTypefaceName:typeface] size:size];
}

+ (void)getAllFontFamilyWithNames {
    NSArray *fontFamilies = [UIFont familyNames];
    
    for (int i = 0; i < [fontFamilies count]; i++)
    {
        NSString *fontFamily = [fontFamilies objectAtIndex:i];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
        NSLog (@"%@: %@", fontFamily, fontNames);
    }
}

+ (NSString *)getTypefaceName:(AIFontFamily)typeface {
    NSString *fontName = @"Courier";
    
    switch (typeface) {
        case fontAvenirBook:
            fontName = @"Avenir-Book";
            break;
            
        case fontAvenirLight:
            fontName = @"Avenir-Light";
            break;
            
        case fontAvenirNextItalic:
            fontName = @"AvenirNext-Italic";
            break;
            
        case fontAvenirNextUltraLight:
            fontName = @"AvenirNext-UltraLight";
            break;
            
        case fontAvenirNextUltraLightItalic:
            fontName = @"AvenirNext-UltraLightItalic";
            break;
            
        case fontCourier:
            fontName = @"Courier";
            break;
            
        case fontZapfino:
            fontName = @"Zapfino";
            break;
            
        case fontTrebuchetMS:
            fontName = @"TrebuchetMS";
            break;
            
        case fontTrebuchetMSBold:
            fontName = @"TrebuchetMS-Bold";
            break;
            
        case fontTrebuchetMSBoldItalic:
            fontName = @"Trebuchet-BoldItalic";
            break;
            
        case fontTrebuchetMSItalic:
            fontName = @"TrebuchetMS-Italic";
            break;
            
        case fontHelveticaNeue:
            fontName = @"HelveticaNeue";
            break;
            
        case fontHelveticaNeueItalic:
            fontName = @"HelveticaNeue-Italic";
            break;
            
        case fontHelveticaNeueLight:
            fontName = @"HelveticaNeue-Light";
            break;
            
        case fontHelveticaNeueThin:
            fontName = @"HelveticaNeue-Thin";
            break;
            
        default:
            break;
    }
    
    return fontName;
}


#pragma mark - CREATE ONE SIDED BORDER VIEW

+ (CALayer *)createOneSidedBorderForUIView:(UIView *)myView Side:(BorderSide)Side {
    CGRect myFrame = myView.frame;
    CGFloat x, y, width, height;
    
    switch (Side)
    {
        case BorderLeft:
        {
            x = 0;
            y = 0;
            height = myView.frame.size.height;
            width = [self getBorderWidthAccordingToDisplay];
        }
            break;
            
        case BorderTop:
        {
            x = 0;
            y = 0;
            height = [self getBorderWidthAccordingToDisplay];
            width = myView.frame.size.width;
        }
            break;
            
        case BorderRight:
        {
            x = myView.frame.size.width - [self getBorderWidthAccordingToDisplay];
            y = 0;
            height = myView.frame.size.height;
            width = [self getBorderWidthAccordingToDisplay];
        }
            break;
            
        case BorderBottom:
        {
            x = 0;
            y = myView.frame.size.height - [self getBorderWidthAccordingToDisplay];
            height = [self getBorderWidthAccordingToDisplay];
            width = myView.frame.size.width;
        }
            break;
    }
    
    myFrame.origin.x = x;
    myFrame.origin.y = y;
    myFrame.size.height = height;
    myFrame.size.width = width;
    
    CALayer *newLayer = [CALayer layer];
    newLayer.frame = myFrame;
    newLayer.backgroundColor = [UIColor colorWithRed:228.0/255/0 green:228.0/255/0 blue:228.0/255.0 alpha:1.0].CGColor;
    
    return newLayer;
}

+ (float)getBorderWidthAccordingToDisplay {
    float width = 0;
    
    if ([UIScreen mainScreen].scale >= 2)
        width = 1.0;
    else
        width = 2.0;
    
    return width;
}


#pragma mark - GET UICOLOR

+ (UIColor *)getAIColorWithRGB228:(CGFloat)alpha {
    return [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:alpha];
}

+ (UIColor *)getAIColorWithRGB192 {
    return [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1.0];
}

+ (UIColor *)getFlatUIColorForColor:(FlatUIColor)color forAlpha:(CGFloat)userAlpha {
    UIColor *selectedColorRGB;
    
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    CGFloat alpha = userAlpha;
    
    switch (color)
    {
        case flatUIColorTurqoise:
        {
            red = 26.0;
            green = 188.0;
            blue = 156.0;
        }
            break;
            
        case flatUIColorGreenSea:
        {
            red = 22.0;
            green = 160.0;
            blue = 133.0;
        }
            break;
            
        case flatUIColorSunFlower:
        {
            red = 241.0;
            green = 196.0;
            blue = 15.0;
        }
            break;
            
        case flatUIColorOrange:
        {
            red = 243.0;
            green = 156.0;
            blue = 18.0;
        }
            break;
            
        case flatUIColorEmerald:
        {
            red = 46.0;
            green = 204.0;
            blue = 113.0;
        }
            break;
            
        case flatUIColorNephritis:
        {
            red = 39.0;
            green = 174.0;
            blue = 96.0;
        }
            break;
            
        case flatUIColorCarrot:
        {
            red = 230.0;
            green = 126.0;
            blue = 34.0;
        }
            break;
            
        case flatUIColorPumpkin:
        {
            red = 211.0;
            green = 84.0;
            blue = 0.0;
        }
            break;
            
        case flatUIColorPeterRiver:
        {
            red = 52.0;
            green = 152.0;
            blue = 219.0;
        }
            break;
            
        case flatUIColorBelizeHole:
        {
            red = 41.0;
            green = 128.0;
            blue = 185.0;
        }
            break;
            
        case flatUIColorAlizarin:
        {
            red = 231.0;
            green = 76.0;
            blue = 60.0;
        }
            break;
            
        case flatUIColorPomegranate:
        {
            red = 192.0;
            green = 57.0;
            blue = 43.0;
        }
            break;
            
        case flatUIColorAmethyst:
        {
            red = 155.0;
            green = 89.0;
            blue = 182.0;
        }
            break;
            
        case flatUIColorWisteria:
        {
            red = 142.0;
            green = 68.0;
            blue = 173.0;
        }
            break;
            
        case flatUIColorClouds:
        {
            red = 236.0;
            green = 240.0;
            blue = 241.0;
        }
            break;
            
        case flatUIColorSilver:
        {
            red = 189.0;
            green = 195.0;
            blue = 199.0;
        }
            break;
            
        case flatUIColorWetAsphalt:
        {
            red = 52.0;
            green = 73.0;
            blue = 94.0;
        }
            break;
            
        case flatUIColorMidnightBlue:
        {
            red = 44.0;
            green = 62.0;
            blue = 80.0;
        }
            break;
            
        case flatUIColorConcrete:
        {
            red = 149.0;
            green = 165.0;
            blue = 166.0;
        }
            break;
            
        case flatUIColorAsbestos:
        {
            red = 127.0;
            green = 140.0;
            blue = 141.0;
        }
            break;
    }
    
    selectedColorRGB = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
    
    return selectedColorRGB;
}

@end
