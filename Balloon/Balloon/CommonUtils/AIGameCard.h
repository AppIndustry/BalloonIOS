//
//  AIGameCard.h
//  BalloonPopper
//
//  Created by Mun Fai Leong on 3/8/15.
//  Copyright (c) 2015 myAppIndustry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIEnumCollection.h"

@interface AIGameCard : NSObject

@property (nonatomic) AIGameCardName cardName;
@property (nonatomic) BOOL isNumberCard; // else is command card
@property (nonatomic) NSInteger cardId;
@property (nonatomic) NSInteger cardValue; //command card is one

//@property (nonatomic) NSInteger prioritySequence; //smallest number of 0, the smaller the number, the higher the priority


@end
