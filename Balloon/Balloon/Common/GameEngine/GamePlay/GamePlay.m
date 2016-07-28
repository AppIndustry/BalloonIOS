//
//  GamePlay.m
//  Balloon
//
//  Created by MUNFAI-IT on 27/07/2016.
//  Copyright © 2016 myAppIndustry. All rights reserved.
//

#import "GamePlay.h"

#define kMAXIMUM_TIME_COUNT 60
#define kMINIMUM_TIME_COUNT 0
#define kPLAYER @"player"

@implementation GamePlay

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

#pragma mark - Setting up Variables

- (void)initializeStartingVariable {
    
    //initialize Default Game Settings
    self.settings = [[GameInGameSettings alloc]init];
    
    //create first draw deck and shuffle them
    self.drawDeck = [[GameCardDeck alloc]initWithDeck];
    
    //initialize discard deck
    self.discardDeck = [[GameCardDeck alloc]init];
    
    //set play direction
    self.isForwardPlay = YES;
    
    //set default number of cards to play
    self.isDoublePlayNeeded = NO;
    
    //set balloon pop
    self.isBalloonPop = NO;
    
    //set enlarge view flag
    self.hasDisplayEnlargeView = NO;
    
    //set double play flag
    self.hasCompleteDoublePlay = YES;
    
    //set flag for giving warning to player when selecting double play
    self.hasGivenWarningForDoublePlay = NO;
    
    //set starting time count
    self.currentTimeCount = kMINIMUM_TIME_COUNT;
    
    //set initial player turn ID
    self.nextTurnPlayerID = 0;
}

- (void)setupPlayerVariables {
    
    self.playersDictionary = [[NSMutableDictionary alloc]init];
    
    for (int i = 0; i < self.settings.numberOfPlayers; i++) {
        
        NSString * userId = [NSString stringWithFormat:@"%@%i", kPLAYER, i];
        
        GamePlayer * player = [[GamePlayer alloc]init];
        player.index = i;
        player.userID = userId;
        player.playerHand = [[NSMutableArray alloc] init];
        player.lifeCount = self.settings.lifePerPlayer;
        
        [self.playersDictionary setObject:player forKey:userId];
    }
}

- (void)distributeCardsToPlayers:(BOOL)isStartingDistribute {
    
    //Distribute cards during start of the game where everyone's playerHand is empty
    if (isStartingDistribute) {
        
        for (int i = 0; i < self.settings.cardPerPlayer; i++) {
            
            for (int j = 0; j < self.settings.numberOfPlayers; j++) {
                
                AIGameCard * card = (AIGameCard *)[self.drawDeck objectAtIndex:0];
                
                NSString * userId = [self getUserID:j];
                
                GamePlayer * player = (GamePlayer *)[self.playersDictionary objectForKey:userId];
                
                if (player != nil && player.playerHand != nil) {
                    [player.playerHand addObject:card];
                }
            
                [self.drawDeck removeObjectAtIndex:0];
                
                [self.playersDictionary setObject:player forKey:userId];
            }
        }
    }
    
    //Distribute cards to player during each round to refill up their play hand
    else {
        
        for (int i = 0; i < self.settings.numberOfPlayers; i++) {
            
            NSString * userId = [self getUserID:i];
            
            GamePlayer * player = (GamePlayer *)[self.playersDictionary objectForKey:userId];
            
            if (player.lifeCount > 0) {
                
                while (player.playerHand.count < self.settings.cardPerPlayer) {
                    
                    AIGameCard * card = (AIGameCard *)[self.drawDeck objectAtIndex:0];
                    
                    [player.playerHand addObject:card];
                    
                    [self.drawDeck removeObjectAtIndex:0];
                }
            }
            
            [self.playersDictionary setObject:player forKey:userId];
        }
    }
}

- (NSString *)getUserID:(int)userID {
    return [NSString stringWithFormat:@"%@%i", kPLAYER, userID];
}

#pragma mark - Game Flow

- (void)startGame {
    
    int randomNumber = arc4random_uniform(4);
    
    self.nextTurnPlayerID = randomNumber;
    
    self.nextTurnPlayerID -= 1;
    
    if (self.nextTurnPlayerID == -1) {
        self.nextTurnPlayerID = self.settings.numberOfPlayers - 1;
    }
    
    //inform user to start game
}

- (void)discardGameCard:(AIGameCard *)card {
    
    if (self.discardDeck) {
         [self.discardDeck addObject:card];
    }
}

- (void)nextPlayerTurn:(BOOL)isPlayerSkip {
    
    int numberAdd = 1;
    
    if (isPlayerSkip) {
        numberAdd = 2;
    }
    
    for (int i = 0; i < numberAdd; i++) {
        
        if (self.isForwardPlay) {
            
            self.nextTurnPlayerID  += 1;
            
            if (self.nextTurnPlayerID == self.settings.numberOfPlayers) {
                self.nextTurnPlayerID = 0;
            }
            
            NSString * userID = [self getUserID:self.nextTurnPlayerID];
            
            GamePlayer * player = [self.playersDictionary objectForKey:userID];
            
            if (player.lifeCount <= 0) {
                
                self.nextTurnPlayerID += 1;
                
                if (self.nextTurnPlayerID == self.settings.numberOfPlayers) {
                    self.nextTurnPlayerID = 0;
                }
            }
        }
        
        else {
        
            self.nextTurnPlayerID -= 1;
            
            if (self.nextTurnPlayerID == -1) {
                self.nextTurnPlayerID = self.settings.numberOfPlayers - 1;
            }
            
            NSString * userID = [self getUserID:self.nextTurnPlayerID];
            
            GamePlayer * player = [self.playersDictionary objectForKey:userID];
            
            if (player.lifeCount <= 0) {
                self.nextTurnPlayerID -= 1;
                
                if (self.nextTurnPlayerID == -1) {
                    self.nextTurnPlayerID = self.settings.numberOfPlayers - 1;
                }
            }
        }
    }
    
    if (self.isDoublePlayNeeded && self.hasCompleteDoublePlay) {
        
        if (!self.isForwardPlay) {
            
            self.nextTurnPlayerID  += 1;
            
            if (self.nextTurnPlayerID == self.settings.numberOfPlayers) {
                self.nextTurnPlayerID = 0;
            }
        }
        else {
            
            self.nextTurnPlayerID -= 1;
            
            if (self.nextTurnPlayerID == -1) {
                self.nextTurnPlayerID = self.settings.numberOfPlayers - 1;
            }
        }
    }
    
    NSString * userId = [self getUserID:self.nextTurnPlayerID];
    
    GamePlayer * player = (GamePlayer *)[self.playersDictionary objectForKey:userId];
    
    if (player.lifeCount > 0)
    {
        /*
        if (nextPlayerIDTurn == userID) {
            
        }
        else {
            //[self automateAIPlayer];
        }*/
    }
    else {
        [self nextPlayerTurn:NO];
    }
    
    
}

@end
