//
//  GamePlay.h
//  Balloon
//
//  Created by MUNFAI-IT on 27/07/2016.
//  Copyright © 2016 myAppIndustry. All rights reserved.
//

/**
    GamePlay, mainly about the flow and process of a Single Game,
    which should work normally for both SinglePlayer and MultiPlayer Mode,
 
    including, but not limited to,
 
    *** Initializing and organizing the Initial Variables
    *** Process a player's Selection and Turn
 
 **/


#import <Foundation/Foundation.h>
#import "AIGameCard.h"
#import "GamePlayer.h"
#import "GameCardDeck.h"
#import "GameMechanics.h"
#import "GameInGameSettings.h"

@protocol GamePlayDelegate;

@interface GamePlay : NSObject

#pragma mark - Flag Property

///the current Play direction
@property (nonatomic) BOOL isForwardPlay;

///returns whether a balloon has popped
@property (nonatomic) BOOL isBalloonPop;

///returns a flag whether a DoublePlay is needed during next player's turn
@property (nonatomic) BOOL isDoublePlayNeeded;

///return yes if a game card enlarge view has been shown and displayed
@property (nonatomic) BOOL hasDisplayEnlargeView;

///return Completed flag for double play
@property (nonatomic) BOOL hasCompleteDoublePlay;

///Warning flag for double play
@property (nonatomic) BOOL hasGivenWarningForDoublePlay;


#pragma mark - Numbers Property

///Player UserID for the next turn
@property (nonatomic) int nextTurnPlayerID;

///Current Time Count in GamePlay
@property (nonatomic) int currentTimeCount;


#pragma mark - Game Card Deck Property

///DrawDeck of the Game
@property (nonatomic, strong) GameCardDeck * drawDeck;

///DiscardDeck of the Game
@property (nonatomic, strong) GameCardDeck * discardDeck;


#pragma mark - Game Settings

///Settings of the Game
@property (nonatomic, strong) GameInGameSettings * settings;


#pragma mark - Players Related

///Dictionary that store all Player Object
@property (nonatomic, strong) NSMutableDictionary * playersDictionary;


#pragma mark - Delegate

///Delegate for the GamePlay
@property (nonatomic, assign) id <GamePlayDelegate> delegate;

@end


#pragma mark - Protocol Delegate

@protocol GamePlayDelegate <NSObject>

@required

- (void)gamePlay:(GamePlay *)play playerUserID:(NSString *)userID;

@optional

@end
