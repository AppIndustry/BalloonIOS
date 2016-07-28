//
//  GameInGameSettings.m
//  Balloon
//
//  Created by MUNFAI-IT on 28/07/2016.
//  Copyright © 2016 myAppIndustry. All rights reserved.
//

#import "GameInGameSettings.h"

#define DEFAULT_PLAYER_COUNT 4
#define DEFAULT_LIFE_COUNT 3
#define DEFAULT_CARD_COUNT 7

@implementation GameInGameSettings

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.numberOfPlayers = DEFAULT_PLAYER_COUNT;
        self.lifePerPlayer = DEFAULT_LIFE_COUNT;
        self.cardPerPlayer = DEFAULT_CARD_COUNT;
    }
    
    return self;
}

@end
