//
//  GameMechanics.m
//  Balloon
//
//  Created by MUNFAI-IT on 27/07/2016.
//  Copyright © 2016 myAppIndustry. All rights reserved.
//


#import "GameMechanics.h"
#import "AIGameCard.h"

@implementation GameMechanics

+ (NSMutableArray *)createFullDeck {
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    
    NSInteger cardId = 0;
    
    for (int i = 0; i < 10; i++) {
        
        AIGameCard * GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardCut;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
        
    }
    
    for (int i = 0; i < 20; i++) {
        
        AIGameCard * GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardAddFiveSecond;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 5;
        GameCardObject.isNumberCard = YES;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
        
    }
    
    for (int i = 0; i < 20; i++) {
        
        AIGameCard * GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardAddTenSecond;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 10;
        GameCardObject.isNumberCard = YES;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
    }
    
    for (int i = 0; i < 6; i++) {
        
        AIGameCard * GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardReverse;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
    }
    
    for (int i = 0; i < 6; i++) {
        
        AIGameCard * GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardSkip;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
    }
    
    for (int i = 0; i < 4; i++) {
        
        AIGameCard * GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardToSixtySecond;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
    }
    
    for (int i = 0; i < 4; i++) {
        AIGameCard * GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardToThirtySecond;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
    }
    
    for (int i = 0; i < 3; i++) {
        AIGameCard * GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardToZeroSecond;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
    }
    
    for (int i = 0; i < 2; i++) {
        AIGameCard * GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardDrawOne;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
    }
    
    for (int i = 0; i < 2; i++) {
        AIGameCard * GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardDrawTwo;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
    }
    
    for (int i = 0; i < 2; i++) {
        AIGameCard * GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardTradeHand;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
    }
    
    for (int i = 0; i < 2; i++) {
        AIGameCard * GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardDoublePlay;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
    }
    
    for (int i = 0; i < 3; i++) {
        AIGameCard * GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardPop;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
    }
    
    return tempArray;
}

+ (NSMutableArray *)shuffleDeck:(NSMutableArray *)tempFullDeck {
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [tempFullDeck count]; i++) {
        
        int randomIndex = arc4random_uniform((int)[tempFullDeck count]);
        
        if (randomIndex < [tempFullDeck count]) {
            
            AIGameCard * GameCardObject = (AIGameCard *)[tempFullDeck objectAtIndex:randomIndex];
            [tempArray addObject:GameCardObject];
            
            [tempFullDeck removeObjectAtIndex:randomIndex];
            
            i -= 1;
        }
    }
    
    return tempArray;
}

@end
