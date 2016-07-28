//
//  GamePlayer.h
//  Balloon
//
//  Created by MUNFAI-IT on 27/07/2016.
//  Copyright © 2016 myAppIndustry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GamePlayer : NSObject

@property (nonatomic) int index;
@property (nonatomic, strong) NSString * userID;
@property (nonatomic) NSInteger lifeCount;
@property (nonatomic, strong) NSMutableArray * playerHand;

@end
