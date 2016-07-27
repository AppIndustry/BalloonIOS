//
//  GameCardDeck.m
//  Balloon
//
//  Created by MUNFAI-IT on 27/07/2016.
//  Copyright © 2016 myAppIndustry. All rights reserved.
//

#import "GameCardDeck.h"
#import "GameMechanics.h"

@implementation GameCardDeck

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (instancetype)initWithDeck {
    self = [super init];
    
    if (self) {
        [self createFullDeck];
        [self reshuffle];
    }
    
    return self;
}

#pragma mark - Actions

- (void)reshuffle {
    NSMutableArray * tempDeck = [GameMechanics shuffleDeck:self];
    [self addObjectsFromArray:tempDeck];
}

- (void)reset {
    [self removeAllObjects];
}

- (void)createFullDeck {
    [self addObjectsFromArray:[GameMechanics createFullDeck]];
}

@end
