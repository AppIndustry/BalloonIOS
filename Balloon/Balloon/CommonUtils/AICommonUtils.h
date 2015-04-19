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


@end
