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


#pragma mark - Setting up

- (void)setupPlayerVariables {
    
    self.playersDictionary = [[NSMutableDictionary alloc]init];
    
    for (int i = 0; i < self.settings.numberOfPlayers; i++) {
        
        NSString * userId = [self getUserID:i];
        
        GamePlayer * player = [[GamePlayer alloc]init];
        player.index = i;
        player.userID = userId;
        player.playerHand = [[NSMutableArray alloc] init];
        player.lifeCount = self.settings.lifePerPlayer;
        
        [self.playersDictionary setObject:player forKey:userId];
    }
}

- (void)resetDoublePlayFlag {
    self.hasCompleteDoublePlay = YES;
    self.isDoublePlayNeeded = NO;
}

- (NSString *)getUserID:(int)userID {
    return [NSString stringWithFormat:@"%@%i", kPLAYER, userID];
}


#pragma mark - Deck

- (void)shuffleDeck {
    [self.drawDeck addObjectsFromArray:self.discardDeck];
    [self.drawDeck reshuffle];
    [self.discardDeck reset];
}


#pragma mark - Distribute Cards

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

- (void)distributeCardsToOtherPlayers:(NSInteger)numberOfCards {
    
    if (self.drawDeck.count < (self.settings.numberOfPlayers * numberOfCards)) {
        [self shuffleDeck];
    }
    
    for (int i = 0; i < numberOfCards; i++) {
        
        for (NSString * userId in self.playersDictionary.allKeys) {
            
            GamePlayer * player = (GamePlayer *)self.playersDictionary[userId];
            
            if (player.index != self.nextTurnPlayerID) {
                
                if (player.lifeCount > 0) {
                    AIGameCard * card = (AIGameCard *)self.drawDeck[0];
                    [player.playerHand addObject:card];
                    [self.drawDeck removeObjectAtIndex:0];
                }
            }
        }
    }
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
    
    if (player.lifeCount > 0) {
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


#pragma mark - Processing

- (void)processGamePlayForUserId:(int)userId selectedCard:(AIGameCard *)card {
    
    BOOL isBalloonPopped = [self validateGameCard:card];
    
    [self validateDoublePlay];
    
    [self processPostOperationForGameCard:card hasPopped:isBalloonPopped userId:userId];
}

- (BOOL)validateGameCard:(AIGameCard *)card {
    BOOL hasPopped = NO;
    
    if (self.isBalloonPop) {
        
        switch (card.cardName) {
            case GameCardPop:
            case GameCardCut:
                break;
                
            default:
                hasPopped = YES;
                break;
        }
    }
    else if (self.isDoublePlayNeeded && !self.hasCompleteDoublePlay) {
        
        switch (card.cardName) {
            case GameCardToZeroSecond:
            case GameCardToThirtySecond:
            case GameCardToSixtySecond:
            case GameCardAddFiveSecond:
            case GameCardAddTenSecond:
                break;
                
            default:
                hasPopped = YES;
                break;
        }
    }
    
    return hasPopped;
    
}

- (void)validateDoublePlay {
    
    if (!self.hasCompleteDoublePlay) {
        self.hasCompleteDoublePlay = YES;
    }
    else {
        [self resetDoublePlayFlag];
    }
}

- (void)processPostOperationForGameCard:(AIGameCard *)card hasPopped:(BOOL)hasPopped userId:(int)userId {
    BOOL isPlayerSkip = NO;
    BOOL hasDonePostOperation = YES;
    
    if (card.isNumberCard) {
        self.currentTimeCount += (int)card.cardValue;
    }
    else {
        
        switch (card.cardName) {
                
            case GameCardDoublePlay: {
                self.isDoublePlayNeeded = YES;
                self.hasCompleteDoublePlay = NO;
                self.hasGivenWarningForDoublePlay = NO;
            }
                break;
                
            case GameCardDrawOne: {
                if (!hasPopped) {
                    [self distributeCardsToOtherPlayers:1];
                }
            }
                break;
                
            case GameCardDrawTwo: {
                if (!hasPopped) {
                    [self distributeCardsToOtherPlayers:2];
                }
            }
                break;
                
            case GameCardPop: {
                self.isBalloonPop = YES;
            }
                break;
                
            case GameCardCut: {
                self.currentTimeCount = 0;
                self.isBalloonPop = NO;
            }
                break;
                
            case GameCardSkip: {
                isPlayerSkip = YES;
            }
                break;
                
            case GameCardToSixtySecond: {
                self.currentTimeCount = 60;
            }
                break;
                
            case GameCardToThirtySecond: {
                self.currentTimeCount = 30;
            }
                break;
                
            case GameCardToZeroSecond: {
                self.currentTimeCount = 0;
            }
                break;
                
            case GameCardReverse: {
                self.isForwardPlay = !self.isForwardPlay;
            }
                break;
                
            case GameCardTradeHand: {
                
                if (!hasPopped) {
                    GamePlayer * player = [self getPlayerForUserId:userId];
                    
                    if (player.playerHand.count > 0) {
                        
                        if (player.isComputer) {
                            
                        }
                        else {
                            
                        }
                    }
                    else {
                        //player hand finish cards, end the game round.
                    }
                }
            }
                break;
                
            default:
                break;
        }
    }
}


#pragma mark - Get Player Hand

- (GamePlayer *)getPlayerForUserId:(int)userId {
    
    NSString * user = [self getUserID:userId];
    
    GamePlayer * player = (GamePlayer *)self.playersDictionary[user];
    
    return player;
}

- (NSMutableArray *)getPlayerHandForUserId:(int)userId {
    
    GamePlayer * player = [self getPlayerForUserId:userId];
    
    return player.playerHand;
}

- (void)setPlayerHand:(NSMutableArray *)playerHand forUserId:(int)userId {
    
    GamePlayer * player = [self getPlayerForUserId:userId];
    
    player.playerHand = [playerHand mutableCopy];
    
    [self updatePlayerDictionaryForGamePlayer:player];
}

- (void)updatePlayerDictionaryForGamePlayer:(GamePlayer *)player {
    [self.playersDictionary setObject:player forKey:[self getUserID:player.index]];
}

@end
