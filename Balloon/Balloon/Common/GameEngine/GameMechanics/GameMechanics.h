//
//  GameMechanics.h
//  Balloon
//
//  Created by MUNFAI-IT on 27/07/2016.
//  Copyright © 2016 myAppIndustry. All rights reserved.
//

/**
 
    GameMechanics, mainly about the logic proccessing of the Game,
    which shall include the AI Engine and Mechanisms,
 
    including, but not limited to,
 
    *** Preparing starting Deck of Cards
 
 **/

#import <Foundation/Foundation.h>

@interface GameMechanics : NSObject

+ (NSMutableArray *)createFullDeck;

+ (NSMutableArray *)shuffleDeck:(NSMutableArray *)tempFullDeck;

@end
