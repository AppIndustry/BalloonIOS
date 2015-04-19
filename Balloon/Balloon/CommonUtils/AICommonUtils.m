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

@end
