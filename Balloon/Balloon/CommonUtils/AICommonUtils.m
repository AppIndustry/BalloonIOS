//
//  AICommonUtils.m
//  BalloonPopper
//
//  Created by Mun Fai Leong on 3/8/15.
//  Copyright (c) 2015 myAppIndustry. All rights reserved.
//

#import "AICommonUtils.h"

@implementation AICommonUtils

+(UIImage *)getGameCardImageForGameCard:(AIGameCardName)cardName
{
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

+(UIImage *)getGameCardBackCoverImage
{
    return [UIImage imageNamed:@"BackCover"];
}


+ (UIFont *)getCustomTypeface:(AIFontFamily)typeface ofSize:(CGFloat)size
{
    return [UIFont fontWithName:[self getTypefaceName:typeface] size:size];
}

+ (NSString *)getTypefaceName:(AIFontFamily)typeface
{
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
            
            
        default:
            break;
    }
    
    return fontName;
}



+(NSMutableAttributedString *)createStringWithSpacing:(NSString *)string spacngValue:(float)spacing withUnderLine:(BOOL)isUnderLine
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:string];
    
    [attributeString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, string.length)];
    
    if (isUnderLine)
        attributeString = [self addUnderLineToMutableAttributedString:attributeString];
    
    return attributeString;
}

+(void)getAllFontFamilyWithNames
{
    NSArray *fontFamilies = [UIFont familyNames];
    
    for (int i = 0; i < [fontFamilies count]; i++)
    {
        NSString *fontFamily = [fontFamilies objectAtIndex:i];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
        NSLog (@"%@: %@", fontFamily, fontNames);
    }
}

+(NSMutableAttributedString *)addUnderLineToMutableAttributedString:(NSMutableAttributedString *)attributeString
{
    [attributeString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, attributeString.length)];
    
    return attributeString;
}



+(CALayer *)createOneSidedBorderForUIView:(UIView *)myView Side:(BorderSide)Side
{
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

+(float)getBorderWidthAccordingToDisplay
{
    float width = 0;
    
    if ([UIScreen mainScreen].scale >= 2)
        width = 1.0;
    else
        width = 2.0;
    
    return width;
}



+(UIColor *)getAIColorWithRGB228:(CGFloat)alpha
{
    return [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:alpha];
}
@end
