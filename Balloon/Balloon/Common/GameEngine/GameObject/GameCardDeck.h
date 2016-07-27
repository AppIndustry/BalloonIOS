//
//  GameCardDeck.h
//  Balloon
//
//  Created by MUNFAI-IT on 27/07/2016.
//  Copyright © 2016 myAppIndustry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameCardDeck : NSMutableArray

- (instancetype)init;
- (instancetype)initWithDeck;

- (void)createFullDeck;
- (void)reshuffle;
- (void)reset;
@end
