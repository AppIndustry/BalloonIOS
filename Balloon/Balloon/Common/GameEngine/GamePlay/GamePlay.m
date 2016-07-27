//
//  GamePlay.m
//  Balloon
//
//  Created by MUNFAI-IT on 27/07/2016.
//  Copyright © 2016 myAppIndustry. All rights reserved.
//

#import "GamePlay.h"

@implementation GamePlay

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)initializeStartingVariable {
    //create first draw deck and shuffle them
    _drawDeck = [[GameCardDeck alloc]initWithDeck];
    
    //initialize discard deck
    _discardDeck = [[GameCardDeck alloc]init];
    
    //set play direction
    _isForwardPlay = YES;
    
    //set default number of cards to play
    _isDoublePlayNeeded = NO;
    
    //set balloon pop
    _isBalloonPop = NO;
    
    //set enlarge view flag
    _hasDisplayEnlargeView = NO;
    
    //set double play flag
    _hasCompleteDoublePlay = YES;
    
    //set flag for giving warning to player when selecting double play
    _hasGivenWarningForDoublePlay = NO;
    
    /*
    //set previous card id for selection color to default 0
    previousCardId = 0;
    
    //initialize player hand array
    playerHandArray0 = [[NSMutableArray alloc]init];
    playerHandArray1 = [[NSMutableArray alloc]init];
    playerHandArray2 = [[NSMutableArray alloc]init];
    playerHandArray3 = [[NSMutableArray alloc]init];
    
    //set initial player life in NSMutableDictionary
    playerLifeCountDictionary = [[NSMutableDictionary alloc]init];
    NSString *tempNum = @"3";
    [playerLifeCountDictionary setObject:tempNum forKey:@"player0"];
    [playerLifeCountDictionary setObject:tempNum forKey:@"player1"];
    [playerLifeCountDictionary setObject:tempNum forKey:@"player2"];
    [playerLifeCountDictionary setObject:tempNum forKey:@"player3"];
    
    //set initial count
    nextPlayerIDTurn = 0;
    timeCount = 0;
    userID = 0;
    
    //calculate card frame size before drawing any cards to screen
    [self calculateCardSize];
    
    //set button attribute
    [self setSubmitButtonAttritbute];
    
    //add lifeCount and timeCount labels to screen
    [self addLifeCountAndTimeCountLabel];
    
    //show life count view
    [self showPlayerLifeView];
    
    //distribute card to players
    [self distributeCardsToPlayers:YES];
    
    //show draw deck and discard deck
    [self showDiscardAndDrawDeck:YES];
    
    //display cards on the screen
    [self showCardsToScreen];
    
    //display opponent number card view and their number of cards indicator
    [self showOpponentsCardView];
    */
}

@end
