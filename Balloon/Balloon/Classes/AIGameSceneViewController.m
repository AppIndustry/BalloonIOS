//
//  AIGameSceneViewController.m
//  BalloonPopper
//
//  Created by Mun Fai Leong on 3/8/15.
//  Copyright (c) 2015 myAppIndustry. All rights reserved.
//

#import "AIGameSceneViewController.h"


#define DISCARD_DECK_ID -1
#define DRAW_DECK_ID -2

@interface AIGameSceneViewController ()
{
    NSMutableArray *drawDeckArray, *discardDeckArray;
    NSMutableArray *playerHandArray0, *playerHandArray1, *playerHandArray2, *playerHandArray3;
    
    BOOL isForwardPlay; // reverse play direction
    BOOL isDoublePlayNeeded; //return yes when a player discard a double play command card
    BOOL isBalloonPop; //return yes if a player discard a pop the balloon command card
    
    NSMutableDictionary *playerLifeCountDictionary;
    
    int nextPlayerIDTurn, timeCount, userID;
    NSInteger selectedCardIndex;
    
    AIGameCard *GameCardObject;
    AIGameCardImageView *GameCardImageView;
}

@end

@implementation AIGameSceneViewController

#pragma mark - ViewDidLoad and etc

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeStartingVariable];
    
    
    
    [self startGame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Initialize variables before start Game

-(void)initializeStartingVariable
{
    //create first draw deck and shuffle them
    drawDeckArray = [[self shuffleDrawDeck:[self createFullDeck]] mutableCopy];
    
    //initialize discard deck
    discardDeckArray = [[NSMutableArray alloc]init];
    
    //set play direction
    isForwardPlay = YES;
    
    //set default number of cards to play
    isDoublePlayNeeded = NO;
    
    //set balloon pop
    isBalloonPop = NO;
    
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

    //distribute card to players
    [self distributeCardsToPlayers:YES];
    
    //show draw deck and discard deck
    [self showDiscardAndDrawDeck:YES];
    
    //display cards on the screen
    [self showCardsToScreen];

}

-(NSMutableArray *)createFullDeck
{
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    
    NSInteger cardId = 0;
    
    for (int i = 0; i < 10; i++)
    {
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardCut;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
        
    }
    
    for (int i = 0; i < 20; i++)
    {
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardAddFiveSecond;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 5;
        GameCardObject.isNumberCard = YES;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
        
    }
    
    for (int i = 0; i < 20; i++)
    {
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardAddTenSecond;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 10;
        GameCardObject.isNumberCard = YES;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
        
    }
    
    for (int i = 0; i < 6; i++)
    {
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardReverse;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
        
    }
    
    for (int i = 0; i < 6; i++)
    {
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardSkip;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
        
    }
    
    for (int i = 0; i < 4; i++)
    {
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardToSixtySecond;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
        
    }
    
    for (int i = 0; i < 4; i++)
    {
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardToThirtySecond;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
        
    }
    
    for (int i = 0; i < 3; i++)
    {
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardToZeroSecond;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
        
    }
    
    for (int i = 0; i < 2; i++)
    {
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardDrawOne;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
        
    }
    
    for (int i = 0; i < 2; i++)
    {
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardDrawTwo;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
        
    }
    
    for (int i = 0; i < 2; i++)
    {
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardTradeHand;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
        
    }
    
    for (int i = 0; i < 2; i++)
    {
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardDoublePlay;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
        
    }
    
    for (int i = 0; i < 3; i++)
    {
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardPop;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
        
    }
    
    return tempArray;
}

-(NSMutableArray *)shuffleDrawDeck:(NSMutableArray *)tempFullDeck
{
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];

    
    for (int i = 0; i < [tempFullDeck count]; i++)
    {
        int randomIndex = arc4random_uniform((int)[tempFullDeck count]);
        
        if (randomIndex < [tempFullDeck count])
        {
            GameCardObject = [[AIGameCard alloc]init];
            GameCardObject = (AIGameCard *)[tempFullDeck objectAtIndex:randomIndex];
            [tempArray addObject:GameCardObject];
            
            [tempFullDeck removeObjectAtIndex:randomIndex];
            
            i -= 1;
        }
    }
    
    return tempArray;
}

-(void)distributeCardsToPlayers:(BOOL)isStartingDistribute
{
    if (isStartingDistribute)
    {
        for (int i = 0; i < 7; i++)
        {
            for (int j = 0; j < 4; j++)
            {
                GameCardObject = [[AIGameCard alloc]init];
                GameCardObject = (AIGameCard *)[drawDeckArray objectAtIndex:0];
                
                switch (j)
                {
                    case 0:
                        [playerHandArray0 addObject:GameCardObject];
                        break;
                        
                    case 1:
                        [playerHandArray1 addObject:GameCardObject];
                        break;
                        
                    case 2:
                        [playerHandArray2 addObject:GameCardObject];
                        break;
                        
                    case 3:
                        [playerHandArray3 addObject:GameCardObject];
                        break;
                        
                }
                
                [drawDeckArray removeObjectAtIndex:0];
            }
        }
    }
    else
    {
        
    }
}

-(void)showCardsToScreen
{
    CGFloat xCoordinate = 0;
    
    for (int i = 0; i < [playerHandArray0 count]; i++)
    {
        GameCardImageView = [[AIGameCardImageView alloc]initWithFrame:CGRectMake(xCoordinate, self.view.frame.size.height - 300, 100, 200)];
        
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject = (AIGameCard *)[playerHandArray0 objectAtIndex:i];
        
        GameCardImageView.cardName = GameCardObject.cardName;
        GameCardImageView.arrayIndex = i + 1;
        GameCardImageView.image = [self getGameCardImageForGameCard:GameCardObject.cardName];
        GameCardImageView.userInteractionEnabled = YES;
        GameCardImageView.cardId = GameCardObject.cardId;
        GameCardImageView.delegate = self;
        
        [self.view addSubview:GameCardImageView];
        
        xCoordinate += 40;
    }
}

-(void)showDiscardAndDrawDeck:(BOOL)isStartingDistribute
{
    if (isStartingDistribute)
    {
        CGFloat xCoordinate = 0;
        
        for (int i = 0; i < 2; i++)
        {
            GameCardImageView = [[AIGameCardImageView alloc]initWithFrame:CGRectMake(xCoordinate, 100, 100, 200)];
            GameCardImageView.image = nil;
            
            
            if (i == 0)
            {
                GameCardImageView.cardId = DISCARD_DECK_ID;
            }
            else
            {
                GameCardImageView.cardId = DRAW_DECK_ID;
                GameCardImageView.image = [self getGameCardBackCoverImage];
            }
            
            [self.view addSubview:GameCardImageView];
            
            xCoordinate += 150;
            
        }
    }
    else
    {
        if ([discardDeckArray count] > 0)
        {
            GameCardObject = [[AIGameCard alloc]init];
            GameCardObject = (AIGameCard *)[discardDeckArray objectAtIndex:[discardDeckArray count] - 1];
            
            GameCardImageView.cardId = DISCARD_DECK_ID;
            GameCardImageView.cardName = GameCardObject.cardName;
            GameCardImageView.image = [self getGameCardImageForGameCard:GameCardObject.cardName];
        }
    }
}

-(void)clearAllCardsFromView
{
    for (AIGameCardImageView *cardView in self.view.subviews)
    {
        if ([cardView isMemberOfClass:[AIGameCardImageView class]])
        {
            if (cardView.cardId != DISCARD_DECK_ID && cardView.cardId != DRAW_DECK_ID && cardView.image != [UIImage imageNamed:@"BackCover"])
            {
                [cardView removeFromSuperview];
            }
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBAction by UIButton

- (IBAction)SubmitCardSelection:(id)sender
{
    if (nextPlayerIDTurn == userID && selectedCardIndex > 0)
    {
        for (AIGameCardImageView *imageview in self.view.subviews)
        {
            if ([imageview isMemberOfClass:[AIGameCardImageView class]])
            {
                if (imageview.arrayIndex == selectedCardIndex)
                {
                    [UIView animateWithDuration:0.5 animations:^{
                        imageview.alpha = 0;
                    }completion:^(BOOL finished)
                    {
                        [imageview removeFromSuperview];
                        
                        AIGameCard *tempGameCardObject = [[AIGameCard alloc]init];
                        tempGameCardObject = (AIGameCard *)[playerHandArray0 objectAtIndex:selectedCardIndex - 1];;
                        
                        [self addGameCardIntoDiscardDeck:tempGameCardObject];
                        
                        [playerHandArray0 removeObjectAtIndex:selectedCardIndex - 1];
                        
                        if (tempGameCardObject.cardName == GameCardTradeHand)
                        {
                            //action to trade hand and play another card
                            
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Trade Hand" message:@"Select a player to trade hand with the player" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Player 1", @"Player 2", @"Player 3", nil];
                            alert.tag = 2;
                            [alert show];
                        }
                        else
                            [self cardSelectionValidation:GameCardObject];
                    }];
                    
                    [self nextPlayerTurn:NO];
                }
            }
        }
    }
}




#pragma mark - Game Play

-(void)startGame
{
    if (nextPlayerIDTurn == userID)
    {
        
    }
}




#pragma mark - Helper Methods

-(UIImage *)getGameCardImageForGameCard:(AIGameCardName)cardName
{
    UIImage *returnImage;
    
    switch (cardName)
    {
        case GameCardAddFiveSecond:
            returnImage = [UIImage imageNamed:@"FiveSecond"];
            break;
            
        case GameCardAddTenSecond:
            returnImage = [UIImage imageNamed:@"TenSecond"];
            break;
            
        case GameCardDoublePlay:
            returnImage = [UIImage imageNamed:@"DoublePlay"];
            break;
            
        case GameCardDrawOne:
            returnImage = [UIImage imageNamed:@"PlusOne"];
            break;
            
        case GameCardDrawTwo:
            returnImage = [UIImage imageNamed:@"PlusTwo"];
            break;
            
        case GameCardPop:
            returnImage = [UIImage imageNamed:@"Popped"];
            break;
            
        case GameCardReverse:
            returnImage = [UIImage imageNamed:@"Reverse"];
            break;
            
        case GameCardCut:
            returnImage = [UIImage imageNamed:@"Hold"];
            break;
            
        case GameCardSkip:
            returnImage = [UIImage imageNamed:@"Skip"];
            break;
            
        case GameCardToSixtySecond:
            returnImage = [UIImage imageNamed:@"UpToSixtySecond"];
            break;
            
        case GameCardToThirtySecond:
            returnImage = [UIImage imageNamed:@"ToThirtySecond"];
            break;
            
        case GameCardToZeroSecond:
            returnImage = [UIImage imageNamed:@"DownToZeroSecond"];
            break;
            
        case GameCardTradeHand:
            returnImage = [UIImage imageNamed:@"TradeHand"];
            break;
            
        default:
            break;
    }
    
    return  returnImage;
}

-(UIImage *)getGameCardBackCoverImage
{
    return [UIImage imageNamed:@"BackCover"];
}


-(void)addGameCardIntoDiscardDeck:(AIGameCard *)cardObject
{
    if (discardDeckArray)
        [discardDeckArray addObject:cardObject];
    
    for (AIGameCardImageView *imageView in self.view.subviews)
    {
        if ([imageView isMemberOfClass:[AIGameCardImageView class]] && imageView.cardId == DISCARD_DECK_ID)
        {
            imageView.image = [self getGameCardImageForGameCard:cardObject.cardName];
        }
    }
}


-(void)nextPlayerTurn:(BOOL)isPlayerSkip
{
    int numberAdd = 1;
    
    if (isPlayerSkip)
        numberAdd = 2;
    
    for (int i = 0; i < numberAdd; i++)
    {
        if (isForwardPlay)
        {
            nextPlayerIDTurn  += 1;
            
            if (nextPlayerIDTurn == 4)
                nextPlayerIDTurn = 0;
        }
        else
        {
            nextPlayerIDTurn -= 1;
            
            if (nextPlayerIDTurn == -1)
                nextPlayerIDTurn = 3;
        }
    }
}

-(void)automateAIPlayer
{
    if (nextPlayerIDTurn != userID)
    {
        NSMutableArray *tempUserArray = [[NSMutableArray alloc]init];
        
        tempUserArray = [self getCurrentPlayerHandArray];
        
        NSInteger tempSelectedCardIndex = 0;
        AIGameCardName tempSelectedGameCardName = GameCardDoublePlay; //simply assign a non-related value
        
        if (isBalloonPop)
        {
            for (int i = 0; i < [tempUserArray count]; i++)
            {
                AIGameCard *tempGameCard = [[AIGameCard alloc]init];
                tempGameCard = (AIGameCard *)[tempUserArray objectAtIndex:i];
                
                if (tempGameCard.cardName == GameCardPop)
                {
                    tempSelectedCardIndex = i;
                    tempSelectedGameCardName = GameCardPop;
                    break;
                }
                else if (tempGameCard.cardName == GameCardCut)
                {
                    tempSelectedCardIndex = i;
                    tempSelectedGameCardName = GameCardCut;
                }
                else if (tempGameCard.cardName == GameCardTradeHand)
                {
                    if (tempSelectedGameCardName != GameCardCut)
                    {
                        tempSelectedCardIndex = i;
                        tempSelectedGameCardName = GameCardTradeHand;
                    }
                }
                else
                {
                    if (tempSelectedGameCardName != GameCardTradeHand && tempSelectedGameCardName != GameCardCut)
                    {
                        if (tempGameCard.isNumberCard)
                        {
                            tempSelectedCardIndex = i;
                            tempSelectedGameCardName = tempGameCard.cardName;
                        }
                        else
                        {
                            if (tempGameCard.cardName == GameCardDoublePlay)
                            {
                                
                            }
                            else if (tempGameCard.cardName == GameCardDrawOne)
                            {
                                
                            }
                            else if (tempGameCard.cardName == GameCardDrawTwo)
                            {
                                
                            }
                            else if (tempGameCard.cardName == GameCardReverse)
                            {
                                
                            }
                            else if (tempGameCard.cardName == GameCardSkip)
                            {
                                
                            }
                            else if (tempGameCard.cardName == GameCardToSixtySecond)
                            {
                                
                            }
                            else if (tempGameCard.cardName == GameCardToThirtySecond)
                            {
                                
                            }
                            else if (tempGameCard.cardName == GameCardToZeroSecond)
                            {
                                
                            }
                        }
                    }
                }
            }
            
            AIGameCard *tempGameCardObject = [[AIGameCard alloc]init];
            tempGameCardObject = (AIGameCard *)[tempUserArray objectAtIndex:tempSelectedCardIndex];
            
            [self addGameCardIntoDiscardDeck:tempGameCardObject];
            
            [tempUserArray removeObjectAtIndex:tempSelectedCardIndex];
            
            [self assignCurrentPlayerHandArray:tempUserArray];
            
            
            if (tempGameCardObject.cardName == GameCardTradeHand)
            {
                int randomNumber = arc4random_uniform(2);
                
                //work till here
                NSMutableArray *tempHandArray = [[NSMutableArray alloc]init];
                
                if (randomNumber == 0)
                {
                    tempHandArray = [playerHandArray0 mutableCopy];
                    
                }
                else if (randomNumber == 1)
                {
                    if (randomNumber == nextPlayerIDTurn)
                        tempHandArray = [playerHandArray2 mutableCopy];
                    else
                        tempHandArray = [playerHandArray1 mutableCopy];
                }
                else if (randomNumber == 2)
                {
                    if (randomNumber == nextPlayerIDTurn)
                        tempHandArray = [playerHandArray3 mutableCopy];
                    else
                        tempHandArray = [playerHandArray2 mutableCopy];
                }
                
                NSMutableArray *tempTradeArray = [[NSMutableArray alloc]init];
                tempTradeArray = [tempUserArray mutableCopy];
                
                tempUserArray = [tempHandArray mutableCopy];
                tempHandArray = [tempTradeArray mutableCopy];
                
                if (randomNumber == 0)
                {
                    playerHandArray0 = [tempHandArray mutableCopy];
                    
                }
                else if (randomNumber == 1)
                {
                    if (randomNumber == nextPlayerIDTurn)
                        playerHandArray2 = [tempHandArray mutableCopy];
                    else
                        playerHandArray1 = [tempHandArray mutableCopy];
                }
                else if (randomNumber == 2)
                {
                    if (randomNumber == nextPlayerIDTurn)
                        playerHandArray3 = [tempHandArray mutableCopy];
                    else
                        playerHandArray2 = [tempHandArray mutableCopy];
                }
                
                [self assignCurrentPlayerHandArray:tempUserArray];
            }
            else
                [self cardSelectionValidation:tempGameCardObject];
            
            
        }
        else if (timeCount == 60)
        {
            for (int i = 0; i < [tempUserArray count]; i++)
            {
                AIGameCard *tempGameCard = [[AIGameCard alloc]init];
                tempGameCard = (AIGameCard *)[tempUserArray objectAtIndex:i];
                
                if (!tempGameCard.isNumberCard)
                {
                    if (tempGameCard.cardName == GameCardToThirtySecond)
                    {
                        tempSelectedCardIndex = i;
                        tempSelectedGameCardName = GameCardToThirtySecond;
                        break;
                    }
                    else if (tempGameCard.cardName == GameCardToZeroSecond)
                    {
                        tempSelectedCardIndex = i;
                        tempSelectedGameCardName = GameCardToZeroSecond;
                    }
                    else if (tempGameCard.cardName == GameCardSkip || tempGameCard.cardName == GameCardReverse)
                    {
                        tempSelectedCardIndex = i;
                        tempSelectedGameCardName = tempGameCard.cardName;
                    }
                    else if (tempGameCard.cardName == GameCardDrawOne || tempGameCard.cardName == GameCardDrawTwo)
                    {
                        tempSelectedCardIndex = i;
                        tempSelectedGameCardName = tempGameCard.cardName;
                    }
                    else if (tempGameCard.cardName == GameCardDoublePlay)
                    {
                        tempSelectedCardIndex = i;
                        tempSelectedGameCardName = tempGameCard.cardName;
                    }
                    else if (tempGameCard.cardName == GameCardTradeHand)
                    {
                        if (tempSelectedGameCardName != GameCardCut)
                        {
                            tempSelectedCardIndex = i;
                            tempSelectedGameCardName = GameCardTradeHand;
                        }
                    }
                }
                else
                {
                    
                    
                }
            }
        }
        else
        {
            
        }
    }
}

-(void)drawCardsToOtherThreePlayers:(NSInteger)numberOfDrawCard
{
    NSMutableArray *tempA1 = [[NSMutableArray alloc]init];
    NSMutableArray *tempA2 = [[NSMutableArray alloc]init];
    NSMutableArray *tempA3 = [[NSMutableArray alloc]init];
    
    if ([drawDeckArray count] < (3 * numberOfDrawCard))
    {
        [self reshuffleDiscardDeckIntoDrawDeck];
    }
    
    for (int i = 0; i < numberOfDrawCard; i++)
    {
        GameCardObject = [[AIGameCard alloc]init];
        
        GameCardObject = (AIGameCard *)[drawDeckArray objectAtIndex:0];
        [tempA1 addObject:GameCardObject];
        
        GameCardObject = (AIGameCard *)[drawDeckArray objectAtIndex:1];
        [tempA2 addObject:GameCardObject];
        
        GameCardObject = (AIGameCard *)[drawDeckArray objectAtIndex:2];
        [tempA3 addObject:GameCardObject];
        
        [drawDeckArray removeObjectAtIndex:2];
        [drawDeckArray removeObjectAtIndex:1];
        [drawDeckArray removeObjectAtIndex:0];
    }
    
    switch (nextPlayerIDTurn)
    {
        case 0:
        {
            [playerHandArray1 addObjectsFromArray:tempA1];
            [playerHandArray2 addObjectsFromArray:tempA2];
            [playerHandArray3 addObjectsFromArray:tempA3];
        }
            break;
            
        case 1:
        {
            [playerHandArray0 addObjectsFromArray:tempA1];
            [playerHandArray2 addObjectsFromArray:tempA2];
            [playerHandArray3 addObjectsFromArray:tempA3];
        }
            break;
            
        case 2:
        {
            [playerHandArray0 addObjectsFromArray:tempA1];
            [playerHandArray1 addObjectsFromArray:tempA2];
            [playerHandArray3 addObjectsFromArray:tempA3];
        }
            break;
            
        case 3:
        {
            [playerHandArray0 addObjectsFromArray:tempA1];
            [playerHandArray1 addObjectsFromArray:tempA2];
            [playerHandArray2 addObjectsFromArray:tempA3];
        }
            break;
    }
    
    if (nextPlayerIDTurn != 0)
        [self rearrangePlayerCardView];
}

-(void)reshuffleDiscardDeckIntoDrawDeck
{
    [drawDeckArray addObjectsFromArray:discardDeckArray];
    
    discardDeckArray = [[NSMutableArray alloc]init];
    
    for (AIGameCardImageView *cardView in self.view.subviews)
    {
        if ([cardView isMemberOfClass:[AIGameCardImageView class]] && cardView.cardId == DISCARD_DECK_ID)
        {
            cardView.image = nil;
        }
    }
    
    drawDeckArray = [self shuffleDrawDeck:drawDeckArray];
}


-(void)rearrangePlayerCardView
{
    
}



-(NSMutableArray *)getCurrentPlayerHandArray
{
    NSMutableArray *tempUserArray = [[NSMutableArray alloc]init];
    
    switch (nextPlayerIDTurn)
    {
        case 0:
            tempUserArray = [playerHandArray0 mutableCopy];
            break;
            
        case 1:
            tempUserArray = [playerHandArray1 mutableCopy];
            break;
            
        case 2:
            tempUserArray = [playerHandArray2 mutableCopy];
            break;
            
        case 3:
            tempUserArray = [playerHandArray3 mutableCopy];
            break;
    }
    
    return tempUserArray;
}

-(void)assignCurrentPlayerHandArray:(NSMutableArray *)tempUserArray
{
    switch (nextPlayerIDTurn)
    {
        case 0:
            playerHandArray0 = [tempUserArray mutableCopy];
            
        case 1:
            playerHandArray1 = [tempUserArray mutableCopy];
            break;
            
        case 2:
            playerHandArray2 = [tempUserArray mutableCopy];
            break;
            
        case 3:
            playerHandArray3 = [tempUserArray mutableCopy];
            break;
    }
}




#pragma mark - Operations calculation

-(void)performPreOperation
{
    
}

-(void)performSpecialOperation
{
    
}

-(void)performPostOperation:(AIGameCard *)cardObject
{
    BOOL isPlayerSkip = NO;
    
    //check is number card
    if (cardObject.isNumberCard)
    {
        timeCount += cardObject.cardValue;
        
        [self checkIfTimeCountExceedLimit];
    }
    else
    {
        if (cardObject.cardName == GameCardDoublePlay)
        {
            isDoublePlayNeeded = YES;
        }
        else if (cardObject.cardName == GameCardDrawOne)
        {
            [self drawCardsToOtherThreePlayers:1];
        }
        else if (cardObject.cardName == GameCardDrawTwo)
        {
            [self drawCardsToOtherThreePlayers:2];
        }
        else if (cardObject.cardName == GameCardPop)
        {
            isBalloonPop = YES;
        }
        else if (cardObject.cardName == GameCardReverse)
        {
            isForwardPlay = NO;
        }
        else if (cardObject.cardName == GameCardCut)
        {
            timeCount = 0;
        }
        else if (cardObject.cardName == GameCardSkip)
        {
            isPlayerSkip = YES;
        }
        else if (cardObject.cardName == GameCardToSixtySecond)
        {
            timeCount = 60;
        }
        else if (cardObject.cardName == GameCardToThirtySecond)
        {
            timeCount = 30;
        }
        else if (cardObject.cardName == GameCardToZeroSecond)
        {
            timeCount = 0;
        }

    }
    
    [self nextPlayerTurn:isPlayerSkip];
}

-(void)checkIfTimeCountExceedLimit
{
    if (timeCount > 60)
    {
        [self deductPlayerLifeCountByOne];

    }
}

-(void)checkIfGameIsOver
{
    UIAlertView *alert;
    
    if (self.isGameModeFull)
    {
        alert = [[UIAlertView alloc]initWithTitle:@"Game Over" message:@"The game has ended" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Leave", nil];
    }
    else
    {
        alert = [[UIAlertView alloc]initWithTitle:@"Game Over" message:@"The game has ended" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Leave", @"Continue playing", nil];
    }
    
    alert.tag = 1;
    [alert show];
}

-(void)deductPlayerLifeCountByOne
{
    NSString *tempCount = [playerLifeCountDictionary objectForKey:[NSString stringWithFormat:@"player%i", nextPlayerIDTurn]];
    int lifeCount = [tempCount intValue] - 1;
    
    [playerLifeCountDictionary setObject:[NSString stringWithFormat:@"%i", lifeCount] forKey:[NSString stringWithFormat:@"player%i", nextPlayerIDTurn]];
    
    if (lifeCount == 0)
        [self checkIfGameIsOver];
}



#pragma mark - Card selection Validation

-(void)cardSelectionValidation:(AIGameCard *)selectedCardObject
{
    //validation first before post operation
    if (isBalloonPop)
    {
        if (selectedCardObject.cardName != GameCardPop && selectedCardObject.cardName != GameCardCut)
        {
            [self deductPlayerLifeCountByOne];
            isBalloonPop = NO;
        }
    }
    else if (isDoublePlayNeeded)
    {
        
    }
    else
    {
        [self performPostOperation:selectedCardObject];
    }
}


#pragma mark - AIGameCardImageViewDelegate

-(void)tapAtGameCardForId:(NSInteger)cardId arrayIndex:(NSInteger)arrayIndex cardName:(AIGameCardName)cardName
{
    NSLog(@"index: %lu", arrayIndex);
    
    selectedCardIndex = arrayIndex;
}



#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //game over alert view
    if (alertView.tag == 1)
    {
        if (buttonIndex == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (buttonIndex == 1)
        {
            
        }
    }
    else if (alertView.tag == 2)
    {
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        tempArray = [playerHandArray0 mutableCopy];
        
        if (buttonIndex == 0)
        {
            playerHandArray0 = [playerHandArray1 mutableCopy];
            playerHandArray1 = [tempArray mutableCopy];
        }
        else if (buttonIndex == 1)
        {
            playerHandArray0 = [playerHandArray2 mutableCopy];
            playerHandArray2 = [tempArray mutableCopy];
        }
        else if (buttonIndex == 2)
        {
            playerHandArray0 = [playerHandArray3 mutableCopy];
            playerHandArray3 = [tempArray mutableCopy];
        }
        
        [self clearAllCardsFromView];
        [self showCardsToScreen];
    }
}

@end
