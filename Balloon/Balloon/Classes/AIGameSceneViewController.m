//
//  AIGameSceneViewController.m
//  BalloonPopper
//
//  Game Scene
//  The game play area
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
    
    // reverse play direction
    BOOL isForwardPlay;
    
    //return yes if a player discard a pop the balloon command card
    BOOL isBalloonPop;
    
    //return yes if a game card enlarge view has been shown and displayed
    BOOL hasDisplayEnlargeView;
    
    //return yes when a player discard a double play command card
    BOOL isDoublePlayNeeded;
    
    //Completed flag for double play
    BOOL hasCompleteDoublePlay;
    
    //Warning flag for double play
    BOOL hasGivenWarningForDoublePlay;
    
    NSMutableDictionary *playerLifeCountDictionary;
    
    int nextPlayerIDTurn, timeCount;
    
    //Player user ID, for current Device
    int userID;
    NSInteger selectedCardIndex;
    NSInteger previousCardId;
    
    CGFloat cardWidth, cardHeight;
    
    AIGameCard *GameCardObject;
    AIGameCardImageView *GameCardImageView;
    AIGameCardEnlargeView *GameCardEnlargeView;
    
    UILabel *lifeCountPlayer0, *lifeCountPlayer1, *lifeCountPlayer2, *lifeCountPlayer3;
    UILabel *timeCountLabel;
    
    UIView *computerCardView1, *computerCardView2, *computerCardView3;
    
    UIView *computerLifeView1, *computerLifeView2, *computerLifeView3, *playerLifeView;
    
    NSString *gameOverMessage, *playerLifeLostMessage;
}

@end

@implementation AIGameSceneViewController

#pragma mark - ViewDidLoad and etc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationController.navigationBarHidden = NO;
    
    [self initializeStartingVariable];

    [self startGame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark - Initialize variables before start Game

- (void)initializeStartingVariable {
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
    
    //set enlarge view flag
    hasDisplayEnlargeView = NO;
    
    //set double play flag
    hasCompleteDoublePlay = YES;
    
    //set flag for giving warning to player when selecting double play
    hasGivenWarningForDoublePlay = NO;
    
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

}

//UIView
- (void)calculateCardSize {
    CGFloat viewHeight = self.view.frame.size.height - 64;
    
    cardHeight = (viewHeight - 20 - self.submitButton.frame.size.height) / 2;
    cardHeight -= 40;
    
    cardWidth = cardHeight / 1.5;
}

//Mechanics
- (NSMutableArray *)createFullDeck {
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    
    NSInteger cardId = 0;
    
    for (int i = 0; i < 10; i++) {
        
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardCut;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
        
    }
    
    for (int i = 0; i < 20; i++) {
        
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardAddFiveSecond;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 5;
        GameCardObject.isNumberCard = YES;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
        
    }
    
    for (int i = 0; i < 20; i++) {
        
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardAddTenSecond;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 10;
        GameCardObject.isNumberCard = YES;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
    }
    
    for (int i = 0; i < 6; i++) {
        
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardReverse;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
    }
    
    for (int i = 0; i < 6; i++) {
        
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardSkip;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
    }
    
    for (int i = 0; i < 4; i++) {
        
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardToSixtySecond;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
    }
    
    for (int i = 0; i < 4; i++) {
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardToThirtySecond;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
    }
    
    for (int i = 0; i < 3; i++) {
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardToZeroSecond;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
    }
    
    for (int i = 0; i < 2; i++) {
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardDrawOne;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
    }
    
    for (int i = 0; i < 2; i++) {
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardDrawTwo;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
    }
    
    for (int i = 0; i < 2; i++) {
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardTradeHand;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
    }
    
    for (int i = 0; i < 2; i++) {
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject.cardName = GameCardDoublePlay;
        GameCardObject.cardId = cardId;
        GameCardObject.cardValue = 1;
        GameCardObject.isNumberCard = NO;
        
        [tempArray addObject:GameCardObject];
        
        cardId += 1;
    }
    
    for (int i = 0; i < 3; i++) {
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

//Mechanics
- (NSMutableArray *)shuffleDrawDeck:(NSMutableArray *)tempFullDeck {
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];

    for (int i = 0; i < [tempFullDeck count]; i++) {
        
        int randomIndex = arc4random_uniform((int)[tempFullDeck count]);
        
        if (randomIndex < [tempFullDeck count]) {
            
            GameCardObject = [[AIGameCard alloc]init];
            GameCardObject = (AIGameCard *)[tempFullDeck objectAtIndex:randomIndex];
            [tempArray addObject:GameCardObject];
            
            [tempFullDeck removeObjectAtIndex:randomIndex];
            
            i -= 1;
        }
    }
    
    return tempArray;
}

//GamePlay
- (void)drawCardsToOtherThreePlayers:(NSInteger)numberOfDrawCard {
    NSMutableArray *tempA1 = [[NSMutableArray alloc]init];
    NSMutableArray *tempA2 = [[NSMutableArray alloc]init];
    NSMutableArray *tempA3 = [[NSMutableArray alloc]init];
    
    if ([drawDeckArray count] < (3 * numberOfDrawCard)) {
        [self reshuffleDiscardDeckIntoDrawDeck];
    }
    
    for (int i = 0; i < numberOfDrawCard; i++) {
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
    
    switch (nextPlayerIDTurn) {
        
        case 0: {
            [playerHandArray1 addObjectsFromArray:tempA1];
            [playerHandArray2 addObjectsFromArray:tempA2];
            [playerHandArray3 addObjectsFromArray:tempA3];
        }
            break;
            
        case 1: {
            [playerHandArray0 addObjectsFromArray:tempA1];
            [playerHandArray2 addObjectsFromArray:tempA2];
            [playerHandArray3 addObjectsFromArray:tempA3];
        }
            break;
            
        case 2: {
            [playerHandArray0 addObjectsFromArray:tempA1];
            [playerHandArray1 addObjectsFromArray:tempA2];
            [playerHandArray3 addObjectsFromArray:tempA3];
        }
            break;
            
        case 3: {
            [playerHandArray0 addObjectsFromArray:tempA1];
            [playerHandArray1 addObjectsFromArray:tempA2];
            [playerHandArray2 addObjectsFromArray:tempA3];
        }
            break;
    }
    
    for (int i = 0; i < 4; i++) {
        
        if ([self checkPlayerHasLostAllLifeForPlayerId:i]) {
            [self discardAllPlayerHandCardsIfPlayerHasLostAllLifeForPlayerId:i];
        }
    }
    
    [self rearrangePlayerCardView];
    
    [self rearrangeOpponentCardNumberAndViewForPlayerID:nextPlayerIDTurn isRearrangeAllPlayer:YES];
}

//GamePlay
- (void)reshuffleDiscardDeckIntoDrawDeck {
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

//UIView
- (void)rearrangePlayerCardView {
    [self clearAllCardsFromView];
    
    [self showCardsToScreen];
}

//GamePlay
- (void)distributeCardsToPlayers:(BOOL)isStartingDistribute {
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
        for (int i = 0; i < 4; i++)
        {
            NSMutableArray *tempArray = [self getCurrentPlayerHandArrayForPlayerId:i];
            
            if (![self checkPlayerHasLostAllLifeForPlayerId:i])
            {
                while ([tempArray count] < 7)
                {
                    AIGameCard *tempGameCard = [[AIGameCard alloc]init];
                    tempGameCard = (AIGameCard *)[drawDeckArray objectAtIndex:0];
                    
                    [tempArray addObject:tempGameCard];
                    
                    [drawDeckArray removeObjectAtIndex:0];
                }
            }
            
            [self assignCurrentPlayerHandArray:tempArray forPlayerId:i];
        }
        
        [self rearrangePlayerCardView];
        
        [self rearrangeOpponentCardNumberAndViewForPlayerID:nextPlayerIDTurn isRearrangeAllPlayer:YES];
    }
}


#pragma mark - display cards onto screen

//UIView
- (void)showCardsToScreen {
    CGFloat xCoordinate = 20;
    CGFloat cardDistance = (self.view.frame.size.width - 40 - cardWidth/2) / 7;
    
    for (int i = 0; i < [playerHandArray0 count]; i++)
    {
        GameCardImageView = [[AIGameCardImageView alloc]initWithFrame:CGRectMake(xCoordinate, self.view.frame.size.height - self.submitButton.frame.size.height - 20 - cardHeight, cardWidth, cardHeight)];
        
        GameCardObject = [[AIGameCard alloc]init];
        GameCardObject = (AIGameCard *)[playerHandArray0 objectAtIndex:i];
        
        GameCardImageView.cardName = GameCardObject.cardName;
        GameCardImageView.arrayIndex = i + 1;
        GameCardImageView.image = [AICommonUtils getGameCardImageForGameCard:GameCardObject.cardName];
        GameCardImageView.userInteractionEnabled = YES;
        GameCardImageView.cardId = GameCardObject.cardId;
        GameCardImageView.delegate = self;
        
        [self.view addSubview:GameCardImageView];
        
        xCoordinate += cardDistance;
    }
}

//UIView
- (void)showDiscardAndDrawDeck:(BOOL)isStartingDistribute {
    if (isStartingDistribute)
    {
        CGFloat xCoordinate = (self.view.frame.size.width - 40 - (cardWidth * 2)) / 3;
        xCoordinate += 20;
        
        for (int i = 0; i < 2; i++)
        {
            GameCardImageView = [[AIGameCardImageView alloc]initWithFrame:CGRectMake(xCoordinate, 104, cardWidth, cardHeight)];
            GameCardImageView.image = nil;
            
            
            if (i == 0)
            {
                GameCardImageView.cardId = DISCARD_DECK_ID;
            }
            else
            {
                GameCardImageView.cardId = DRAW_DECK_ID;
                GameCardImageView.image = [AICommonUtils getGameCardBackCoverImage];
            }
            
            [self.view addSubview:GameCardImageView];
            
            xCoordinate = ((self.view.frame.size.width - 40 - (cardWidth * 2)) / 3) + xCoordinate + cardWidth;
            
        }
    }
    else
    {
        if ([discardDeckArray count] > 0)
        {
            GameCardObject = [[AIGameCard alloc]init];
            GameCardObject = (AIGameCard *)[discardDeckArray objectAtIndex:[discardDeckArray count] - 1];
            
            for (AIGameCardImageView *imageView in self.view.subviews)
            {
                if ([imageView isMemberOfClass:[AIGameCardImageView class]] && imageView.cardId == DISCARD_DECK_ID)
                {
                    imageView.image = [AICommonUtils getGameCardImageForGameCard:GameCardObject.cardName];
                }
            }
        }
    }
}


#pragma mark - ACTIONS TO SHOW OPPONENTS CARDS VIEW AND NUMBER

//UIView
- (void)showOpponentsCardView {
    UIColor *bgColor = [UIColor clearColor];
    
    computerCardView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 104, 20, 200)];
    computerCardView1.backgroundColor = bgColor;
    
    computerCardView2 = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 100, 64, 200, 20)];
    computerCardView2.backgroundColor = bgColor;
    
    computerCardView3 = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 20, 104, 20, 200)];
    computerCardView3.backgroundColor = bgColor;
    
    [self.view addSubview:computerCardView1];
    [self.view addSubview:computerCardView2];
    [self.view addSubview:computerCardView3];
    
    CGFloat yPosition = 15;
    
    for (int i = 1; i <= 7; i++)
    {
        UIView *circleView = [[UIView alloc]initWithFrame:CGRectMake(6, yPosition, 8, 8)];
        circleView.backgroundColor = [AICommonUtils getAIColorWithRGB192];
        circleView.layer.cornerRadius = circleView.frame.size.height / 2;
        circleView.clipsToBounds = YES;
        circleView.tag = i;
        
        [computerCardView1 addSubview:circleView];
        
        yPosition += 15;
    }
    
    yPosition = 15;
    
    for (int i = 1; i <= 7; i++)
    {
        UIView *circleView = [[UIView alloc]initWithFrame:CGRectMake(6, yPosition, 8, 8)];
        circleView.backgroundColor = [AICommonUtils getAIColorWithRGB192];
        circleView.layer.cornerRadius = circleView.frame.size.height / 2;
        circleView.clipsToBounds = YES;
        circleView.tag = i;
        
        [computerCardView3 addSubview:circleView];
        
        yPosition += 15;
    }
    
    yPosition = 15;
    
    for (int i = 1; i <= 7; i++)
    {
        UIView *circleView = [[UIView alloc]initWithFrame:CGRectMake(yPosition, 6, 8, 8)];
        circleView.backgroundColor = [AICommonUtils getAIColorWithRGB192];
        circleView.layer.cornerRadius = circleView.frame.size.height / 2;
        circleView.clipsToBounds = YES;
        circleView.tag = i;
        
        [computerCardView2 addSubview:circleView];
        
        yPosition += 15;
    }
}

//UIView
- (void)rearrangeOpponentCardNumberAndViewForPlayerID:(int)playerID isRearrangeAllPlayer:(BOOL)isRearrangeAllPlayer {
    int tempCurrentPlayerID = nextPlayerIDTurn;
    
    if (isRearrangeAllPlayer)
    {
        for (int i = 1; i <= 3; i++)
        {
            [self processRearrangeOpponentsCardView:i];
        }
    }
    else
    {
        tempCurrentPlayerID = playerID;
        [self processRearrangeOpponentsCardView:playerID];
    }
    
    nextPlayerIDTurn = tempCurrentPlayerID;
}

//UIView
- (void)processRearrangeOpponentsCardView:(int)playerID {
    nextPlayerIDTurn = playerID;
    NSMutableArray *tempArray = [self getCurrentPlayerHandArray];
    
    int count = (int)[tempArray count];
    
    UIView *tempView;
    
    switch (nextPlayerIDTurn)
    {
        case 1:
            tempView = computerCardView1;
            break;
            
        case 2:
            tempView = computerCardView2;
            break;
            
        case 3:
            tempView = computerCardView3;
            break;
            
        default:
            break;
    }
    
    int numberOfCardsInView = (int)[tempView.subviews count];
    
    if (numberOfCardsInView > count)
    {
        int numberToRemove = numberOfCardsInView - count;
        
        for (int j = 0; j < numberToRemove; j++)
        {
            for (UIView *cardView in tempView.subviews)
            {
                if (cardView.tag == numberOfCardsInView - j)
                {
                    [cardView removeFromSuperview];
                }
            }
        }
    }
    else if (numberOfCardsInView < count)
    {
        int numberToAdd = count - numberOfCardsInView;
        
        CGRect lastFrame;
        
        if (count > 0)
        {
            if (numberOfCardsInView > 0)
            {
                for (UIView *cardView in tempView.subviews)
                {
                    if (cardView.tag == numberOfCardsInView)
                    {
                        lastFrame = cardView.frame;
                        break;
                    }
                }
            }
            else
            {
                if (nextPlayerIDTurn != 2)
                    lastFrame = CGRectMake(6, 0, 8, 8);
                else
                    lastFrame = CGRectMake(0, 6, 8, 8);
            }
        }
        else
        {
            if (nextPlayerIDTurn != 2)
                lastFrame = CGRectMake(6, 0, 8, 8);
            else
                lastFrame = CGRectMake(0, 6, 8, 8);
        }
        
        
        for (int j = 1; j <= numberToAdd; j++)
        {
            if (nextPlayerIDTurn != 2)
                lastFrame.origin.y += 15;
            else
                lastFrame.origin.x += 15;
            
            UIView *circleView = [[UIView alloc]initWithFrame:lastFrame];
            circleView.backgroundColor = [AICommonUtils getAIColorWithRGB192];;
            circleView.layer.cornerRadius = circleView.frame.size.height / 2;
            circleView.clipsToBounds = YES;
            circleView.tag = numberOfCardsInView + j;

            [tempView addSubview:circleView];
        }
    }

    
    switch (nextPlayerIDTurn)
    {
        case 1:
            computerCardView1 = tempView;
            break;
            
        case 2:
            computerCardView2 = tempView;
            break;
            
        case 3:
            computerCardView3 = tempView;
            break;
            
        default:
            break;
    }
}


#pragma mark - ACTIONS TO SHOW LIFE VIEW FOR ALL PLAYERS

//UIView
- (void)showPlayerLifeView {
    
    UIColor *bgColor = [UIColor clearColor];
    
    computerLifeView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 220, 20, 200)];
    computerLifeView1.backgroundColor = bgColor;
    
    computerLifeView2 = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 + 20 , 64, 200, 20)];
    computerLifeView2.backgroundColor = bgColor;
    
    computerLifeView3 = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 20, 220, 20, 200)];
    computerLifeView3.backgroundColor = bgColor;
    
    playerLifeView = [[UIView alloc]initWithFrame:CGRectMake(50, self.view.frame.size.height - self.submitButton.frame.size.height - 20 - cardHeight - 30, 100, 20)];
    playerLifeView.backgroundColor = bgColor;
    
    [self.view addSubview:computerLifeView1];
    [self.view addSubview:computerLifeView2];
    [self.view addSubview:computerLifeView3];
    [self.view addSubview:playerLifeView];
    
    CGFloat yPosition = 15;
    
    for (int i = 1; i <= 3; i++) {
        UIView *circleView = [[UIView alloc]initWithFrame:CGRectMake(6, yPosition, 8, 8)];
        circleView.backgroundColor = [UIColor redColor];
        circleView.layer.cornerRadius = circleView.frame.size.height / 2;
        circleView.clipsToBounds = YES;
        circleView.tag = i;
        
        [computerLifeView1 addSubview:circleView];
        
        yPosition += 15;
    }
    
    yPosition = 15;
    
    for (int i = 1; i <= 3; i++) {
        
        UIView *circleView = [[UIView alloc]initWithFrame:CGRectMake(6, yPosition, 8, 8)];
        circleView.backgroundColor = [UIColor redColor];
        circleView.layer.cornerRadius = circleView.frame.size.height / 2;
        circleView.clipsToBounds = YES;
        circleView.tag = i;
        
        [computerLifeView3 addSubview:circleView];
        
        yPosition += 15;
    }
    
    yPosition = 15;
    
    for (int i = 1; i <= 3; i++) {
        
        UIView *circleView = [[UIView alloc]initWithFrame:CGRectMake(yPosition, 6, 8, 8)];
        circleView.backgroundColor = [UIColor redColor];
        circleView.layer.cornerRadius = circleView.frame.size.height / 2;
        circleView.clipsToBounds = YES;
        circleView.tag = i;
        
        [computerLifeView2 addSubview:circleView];
        
        yPosition += 15;
    }
    
    yPosition = 15;
    
    for (int i = 1; i <= 3; i++) {
        
        UIView *circleView = [[UIView alloc]initWithFrame:CGRectMake(yPosition, 6, 8, 8)];
        circleView.backgroundColor = [UIColor redColor];
        circleView.layer.cornerRadius = circleView.frame.size.height / 2;
        circleView.clipsToBounds = YES;
        circleView.tag = i;
        
        [playerLifeView addSubview:circleView];
        
        yPosition += 15;
    }
}

//UIView
- (void)deductPlayerLifeViewForPlayerID:(int)playerID {
    if (playerID == 0)
    {
        int life = [[playerLifeCountDictionary objectForKey:@"player0"] intValue];
        
        for (UIView *view in playerLifeView.subviews)
        {
            if (view.tag == life + 1)
            {
                [view removeFromSuperview];
                break;
            }
        }
    }
    else if (playerID == 1)
    {
        int life = [[playerLifeCountDictionary objectForKey:@"player1"] intValue];
        
        for (UIView *view in computerLifeView1.subviews)
        {
            if (view.tag == life + 1)
            {
                [view removeFromSuperview];
                break;
            }
        }
    }
    else if (playerID == 2)
    {
        int life = [[playerLifeCountDictionary objectForKey:@"player2"] intValue];
        
        for (UIView *view in computerLifeView2.subviews)
        {
            if (view.tag == life + 1)
            {
                [view removeFromSuperview];
                break;
            }
        }
    }
    else if (playerID == 3)
    {
        int life = [[playerLifeCountDictionary objectForKey:@"player3"] intValue];
        
        for (UIView *view in computerLifeView3.subviews)
        {
            if (view.tag == life + 1)
            {
                [view removeFromSuperview];
                break;
            }
        }
    }
}


#pragma mark - clear all player cards from view

//UIView
- (void)clearAllCardsFromView {
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


#pragma mark - update labels

//UIView
- (void)addLifeCountAndTimeCountLabel {
    CGFloat height = 17;
    CGFloat width = 150;
    CGFloat frameHeight = self.view.frame.size.height;
    
    lifeCountPlayer3 = [[UILabel alloc]initWithFrame:CGRectMake(20, frameHeight - height, width, height)];
    lifeCountPlayer2 = [[UILabel alloc]initWithFrame:CGRectMake(20, frameHeight - (height * 2), width, height)];
    lifeCountPlayer1 = [[UILabel alloc]initWithFrame:CGRectMake(20, frameHeight - (height * 3), width, height)];
    lifeCountPlayer0 = [[UILabel alloc]initWithFrame:CGRectMake(20, frameHeight - (height * 4), width, height)];
    
    timeCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 100, 150, height)];
    
    [self updateTimeCountAndLifeCount:YES];
}

//UIView
- (void)updateTimeCountAndLifeCount:(BOOL)updateLifeCount {
    timeCountLabel.text = [NSString stringWithFormat:@"Time: %i", timeCount];
    
    self.navigationItem.title = [NSString stringWithFormat:@"Time: %i", timeCount];

}


#pragma mark - IBAction by UIButton

//UIView + Action
- (IBAction)SubmitCardSelection:(id)sender {
    if (nextPlayerIDTurn == userID && selectedCardIndex > 0)
    {
        [self setSubmitButtonEnabled:NO];
        
        for (AIGameCardImageView *imageview in self.view.subviews)
        {
            if ([imageview isMemberOfClass:[AIGameCardImageView class]])
            {
                if (imageview.arrayIndex == selectedCardIndex)
                {
                    BOOL isPassed = NO;
                    
                    AIGameCard *tempGameCardObject = [[AIGameCard alloc]init];
                    tempGameCardObject = (AIGameCard *)[playerHandArray0 objectAtIndex:selectedCardIndex - 1];
                    
                    if (isDoublePlayNeeded)
                    {
                        if (hasCompleteDoublePlay)
                        {
                            isPassed = YES;
                        }
                        else
                        {
                            if (hasGivenWarningForDoublePlay)
                            {
                                isPassed = YES;
                            }
                            else
                            {
                                if (tempGameCardObject.cardName != GameCardAddFiveSecond && tempGameCardObject.cardName != GameCardAddTenSecond && tempGameCardObject.cardName != GameCardToSixtySecond && tempGameCardObject.cardName != GameCardToThirtySecond && tempGameCardObject.cardName != GameCardToZeroSecond)
                                {
                                    isPassed = NO;
                                    
                                    hasGivenWarningForDoublePlay = YES;
                                    
                                    NSLog(@"First card of double play should affect the time count");
                                    
                                    [self setSubmitButtonEnabled:YES];
                                }
                                else
                                    isPassed = YES;
                            }
                        }
                    }
                    else
                        isPassed = YES;
                    
                    if (isPassed)
                    {
                        [UIView animateWithDuration:0.5 animations:^{
                            imageview.alpha = 0;
                        }completion:^(BOOL finished)
                         {
                             [imageview removeFromSuperview];
                             
                             [self addGameCardIntoDiscardDeck:tempGameCardObject];
                             
                             [playerHandArray0 removeObjectAtIndex:selectedCardIndex - 1];
                             
                             selectedCardIndex = 0;
                             
                             [self cardSelectionValidation:tempGameCardObject];
                         }];
                    }
                    
                    break;
                }
            }
        }
    }
}


#pragma mark - Game Play

//GamePlay
- (void)startGame {
    int randomNumber = arc4random_uniform(4);

    nextPlayerIDTurn = randomNumber;
    
    NSString *playerName;
    
    switch (nextPlayerIDTurn)
    {
        case 0:
            playerName = @"You";
            break;
            
        case 1:
            playerName = @"Computer 1";
            break;
            
        case 2:
            playerName = @"Computer 2";
            break;
            
        case 3:
            playerName = @"Computer 3";
            break;
            
        default:
            break;
    }
    
    nextPlayerIDTurn -= 1;
    
    if (nextPlayerIDTurn == -1)
        nextPlayerIDTurn = 3;
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%@ will start the game", playerName] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.tag = 5;
    
    [alert show];
}


#pragma mark - Helper Methods

//GamePlay
- (void)addGameCardIntoDiscardDeck:(AIGameCard *)cardObject {
    if (discardDeckArray)
        [discardDeckArray addObject:cardObject];
    
//    for (AIGameCardImageView *imageView in self.view.subviews)
//    {
//        if ([imageView isMemberOfClass:[AIGameCardImageView class]] && imageView.cardId == DISCARD_DECK_ID)
//        {
//            imageView.image = [AICommonUtils getGameCardImageForGameCard:cardObject.cardName];
//        }
//    }
}

//GamePlay
- (void)nextPlayerTurn:(BOOL)isPlayerSkip {
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
            
            if ([self checkPlayerHasLostAllLifeForPlayerId:nextPlayerIDTurn])
            {
                nextPlayerIDTurn += 1;
                
                if (nextPlayerIDTurn == 4)
                    nextPlayerIDTurn = 0;
            }
        }
        else
        {
            nextPlayerIDTurn -= 1;
            
            if (nextPlayerIDTurn == -1)
                nextPlayerIDTurn = 3;
            
            if ([self checkPlayerHasLostAllLifeForPlayerId:nextPlayerIDTurn])
            {
                nextPlayerIDTurn -= 1;
                
                if (nextPlayerIDTurn == -1)
                    nextPlayerIDTurn = 3;
            }
        }
    }
    
    if (isDoublePlayNeeded && hasCompleteDoublePlay)
    {
        if (!isForwardPlay)
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
    
    
    
    if (![self checkPlayerHasLostAllLifeForPlayerId:nextPlayerIDTurn])
    {
        if (nextPlayerIDTurn == userID)
        {
            //UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Player's turn" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //alert.tag = 4;
            //[alert show];

            [self setSubmitButtonEnabled:YES];
            [GKNotificationBanner showBannerWithTitle:@"Player's turn" message:@"Select a card and tap the confirm selection button" duration:1 completionHandler:^{
                
            }];
            
            
        }
        else
        {
            [self automateAIPlayer];
        }
    }
    else
    {
        [self nextPlayerTurn:NO];
    }
    
    
}

//Utils
- (NSString *)getCardNameInString:(AIGameCardName)cardName {
    NSString *tempString;
    
    switch (cardName) {
        case GameCardAddFiveSecond:
            tempString = @"AddFiveSecond";
            break;
            
        case GameCardAddTenSecond:
            tempString = @"AddTenSecond";
            break;
            
        case GameCardCut:
            tempString = @"Cut";
            break;
            
        case GameCardDoublePlay:
            tempString = @"DoublePlay";
            break;
            
        case GameCardDrawOne:
            tempString = @"DrawOne";
            break;
            
        case GameCardDrawTwo:
            tempString = @"DrawTwo";
            break;
            
        case GameCardPop:
            tempString = @"Pop";
            break;
            
        case GameCardReverse:
            tempString = @"Reverse";
            break;
            
        case GameCardTradeHand:
            tempString = @"TradeHand";
            break;
            
        case GameCardSkip:
            tempString = @"Skip";
            break;
            
        case GameCardToSixtySecond:
            tempString = @"ToSixtySecond";
            break;
            
        case GameCardToThirtySecond:
            tempString = @"ToThirtySecond";
            break;
            
        case GameCardToZeroSecond:
            tempString = @"ToZeroSecond";
            break;
    }
    
    return tempString;
}


#pragma mark - ACTIONS FOR SETTING BUTTON ATTRIBUTES

//UIView
- (void)setSubmitButtonAttritbute {
    [self.submitButton setTitle:@"Your turn (Tap here to confirm selection)" forState:UIControlStateNormal];
    [self.submitButton setTitle:@"Waiting" forState:UIControlStateDisabled];
    
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor cyanColor] forState:UIControlStateDisabled];
    
    self.submitButton.titleLabel.font = [AICommonUtils getCustomTypeface:fontCourier ofSize:12];
    
    [self setSubmitButtonEnabled:NO];
}

//UIView
- (void)setSubmitButtonEnabled:(BOOL)enabled {
    [self.submitButton setEnabled:enabled];
}


#pragma mark - ACTIONS FOR AUTOMATING AI PLAYERS

//Mechanics
- (void)automateAIPlayer {
    if (nextPlayerIDTurn != userID)
    {
        NSMutableArray *tempUserArray = [[NSMutableArray alloc]init];
        
        tempUserArray = [self getCurrentPlayerHandArray];
        
        NSInteger tempSelectedCardIndex = 0;
        AIGameCardName tempSelectedGameCardName = GameCardDoublePlay; //simply assign a non-related value
        
        NSMutableArray *tempInsertArray = [[NSMutableArray alloc]init];
        
        /////// STILL NEED SOME POLISHING HERE DUE TO COMPLICATED AI FLOW ///////
        
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
                        [tempInsertArray addObject:[NSString stringWithFormat:@"%i", i]];
                    }
                }
            }
            
            if (tempSelectedGameCardName != GameCardTradeHand && tempSelectedGameCardName != GameCardCut && tempSelectedGameCardName != GameCardPop)
            {
                if ([tempInsertArray count] > 0)
                {
                    int randomNumber = arc4random_uniform((int)[tempInsertArray count]);
                    
                    AIGameCard *tempGameCard = [[AIGameCard alloc]init];
                    tempGameCard = (AIGameCard *)[tempUserArray objectAtIndex:randomNumber];
                    
                    tempSelectedCardIndex = randomNumber;
                    tempSelectedGameCardName = tempGameCard.cardName;
                }
            }
    
        }
        else if (isDoublePlayNeeded && !hasCompleteDoublePlay)
        {
            for (int i = 0; i < [tempUserArray count]; i++)
            {
                AIGameCard *tempGameCard = [[AIGameCard alloc]init];
                tempGameCard = (AIGameCard *)[tempUserArray objectAtIndex:i];
                
                if (tempGameCard.cardName == GameCardAddTenSecond && timeCount <= 50)
                {
                    tempSelectedCardIndex = i;
                    tempSelectedGameCardName = tempGameCard.cardName;
                    break;
                }
                else if (tempGameCard.cardName == GameCardAddFiveSecond && timeCount <= 55)
                {
                    tempSelectedCardIndex = i;
                    tempSelectedGameCardName = tempGameCard.cardName;
                    break;
                }
                else if (tempGameCard.cardName == GameCardToZeroSecond)
                {
                    tempSelectedCardIndex = i;
                    tempSelectedGameCardName = tempGameCard.cardName;
                }
                else if (tempGameCard.cardName == GameCardToThirtySecond && tempSelectedGameCardName != GameCardToZeroSecond)
                {
                    tempSelectedCardIndex = i;
                    tempSelectedGameCardName = tempGameCard.cardName;
                }
                else if (tempGameCard.cardName == GameCardToSixtySecond && tempSelectedGameCardName != GameCardToZeroSecond && tempSelectedGameCardName != GameCardToThirtySecond)
                {
                    tempSelectedCardIndex = i;
                    tempSelectedGameCardName = tempGameCard.cardName;
                }
                else
                {
                    if (tempSelectedGameCardName != GameCardToZeroSecond && tempSelectedGameCardName != GameCardToThirtySecond && tempSelectedGameCardName != GameCardToSixtySecond && tempSelectedGameCardName != GameCardAddFiveSecond && tempSelectedGameCardName != GameCardAddTenSecond)
                    {
                        [tempInsertArray addObject:[NSString stringWithFormat:@"%i", i]];
                    }
                }
            }
            
            if (tempSelectedGameCardName != GameCardToZeroSecond && tempSelectedGameCardName != GameCardToThirtySecond && tempSelectedGameCardName != GameCardToSixtySecond && tempSelectedGameCardName != GameCardAddFiveSecond && tempSelectedGameCardName != GameCardAddTenSecond)
            {
                if ([tempInsertArray count] > 0)
                {
                    int randomNumber = arc4random_uniform((int)[tempInsertArray count]);
                    
                    AIGameCard *tempGameCard = [[AIGameCard alloc]init];
                    tempGameCard = (AIGameCard *)[tempUserArray objectAtIndex:randomNumber];
                    
                    tempSelectedCardIndex = randomNumber;
                    tempSelectedGameCardName = tempGameCard.cardName;
                }
            }
        }
        else if (timeCount == 60)
        {
            for (int i = 0; i < [tempUserArray count]; i++)
            {
                AIGameCard *tempGameCard = [[AIGameCard alloc]init];
                tempGameCard = (AIGameCard *)[tempUserArray objectAtIndex:i];
                
                if (!tempGameCard.isNumberCard)
                {
                    if (tempGameCard.cardName != GameCardCut)
                        [tempInsertArray addObject:[NSString stringWithFormat:@"%i", i]];
                }
            }
            
            if ([tempInsertArray count] > 0)
            {
                int randomNumber = arc4random_uniform((int)[tempInsertArray count]);
                
                AIGameCard *tempGameCard = [[AIGameCard alloc]init];
                tempGameCard = (AIGameCard *)[tempUserArray objectAtIndex:randomNumber];
                
                tempSelectedCardIndex = randomNumber;
                tempSelectedGameCardName = tempGameCard.cardName;
            }
            else
            {
                int randomNumber = arc4random_uniform((int)[tempUserArray count]);
                
                AIGameCard *tempGameCard = [[AIGameCard alloc]init];
                tempGameCard = (AIGameCard *)[tempUserArray objectAtIndex:randomNumber];
                
                tempSelectedCardIndex = randomNumber;
                tempSelectedGameCardName = tempGameCard.cardName;
            }
        }
        else
        {
            for (int i = 0; i < [tempUserArray count]; i++)
            {
                AIGameCard *tempGameCard = [[AIGameCard alloc]init];
                tempGameCard = (AIGameCard *)[tempUserArray objectAtIndex:i];
                
                if (tempGameCard.isNumberCard)
                {
                    if (timeCount == 55 && tempGameCard.cardName == GameCardAddFiveSecond)
                    {
                        tempSelectedCardIndex = i;
                        tempSelectedGameCardName = tempGameCard.cardName;
                        break;
                    }
                    else if (timeCount == 50 && tempGameCard.cardName == GameCardAddTenSecond)
                    {
                        tempSelectedCardIndex = i;
                        tempSelectedGameCardName = tempGameCard.cardName;
                        break;
                    }
                    else
                    {
                        tempSelectedCardIndex = i;
                        tempSelectedGameCardName = tempGameCard.cardName;
                    }
                }
                else
                {
                    if (tempSelectedGameCardName != GameCardAddFiveSecond && tempSelectedGameCardName != GameCardAddTenSecond)
                    {
                        if (tempGameCard.cardName != GameCardCut)
                            [tempInsertArray addObject:[NSString stringWithFormat:@"%i", i]];
                    }
                }
            }
            
            if (tempSelectedGameCardName != GameCardAddFiveSecond && tempSelectedGameCardName != GameCardAddTenSecond)
            {
                if ([tempInsertArray count] > 0)
                {
                    int randomNumber = arc4random_uniform((int)[tempInsertArray count]);
                    
                    AIGameCard *tempGameCard = [[AIGameCard alloc]init];
                    tempGameCard = (AIGameCard *)[tempUserArray objectAtIndex:randomNumber];
                    
                    tempSelectedCardIndex = randomNumber;
                    tempSelectedGameCardName = tempGameCard.cardName;
                }
            }
        }
        
        //perform operation to discard card and continue process
        [self automateAIPlayerDiscardCard:tempUserArray selectedCardIndex:tempSelectedCardIndex];
    }
}

//Mechanics
- (void)automateAIPlayerDiscardCard:(NSMutableArray *)tempUserArray selectedCardIndex:(NSInteger)tempSelectedCardIndex {
    AIGameCard *tempGameCardObject = [[AIGameCard alloc]init];
    tempGameCardObject = (AIGameCard *)[tempUserArray objectAtIndex:tempSelectedCardIndex];
    
    [self addGameCardIntoDiscardDeck:tempGameCardObject];
    
    [tempUserArray removeObjectAtIndex:tempSelectedCardIndex];
    
    [self assignCurrentPlayerHandArray:tempUserArray];
    
    [self rearrangeOpponentCardNumberAndViewForPlayerID:nextPlayerIDTurn isRearrangeAllPlayer:NO];

    [self cardSelectionValidation:tempGameCardObject];
    
    
}


#pragma mark - ACTIONS FOR GETTING AND ASSIGNING PLAYER HAND ARRAY

//GamePlay
- (NSMutableArray *)getCurrentPlayerHandArray {
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

//GamePlay
- (NSMutableArray *)getCurrentPlayerHandArrayForPlayerId:(int)playerId {
    NSMutableArray *tempUserArray = [[NSMutableArray alloc]init];
    
    switch (playerId)
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

//GamePlay
- (void)assignCurrentPlayerHandArray:(NSMutableArray *)tempUserArray {
    switch (nextPlayerIDTurn)
    {
        case 0:
            playerHandArray0 = [tempUserArray mutableCopy];
            break;
            
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

//GamePlay
- (void)assignCurrentPlayerHandArray:(NSMutableArray *)tempUserArray forPlayerId:(int)playerId {
    switch (playerId)
    {
        case 0:
            playerHandArray0 = [tempUserArray mutableCopy];
            break;
            
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


#pragma mark - ACTIONS FOR OPERATIONS CALCULATION

//GamePlay
- (void)cardSelectionValidation:(AIGameCard *)selectedCardObject {
    BOOL hasPopped = NO;
    
    //validation first before post operation
    if (isBalloonPop)
    {
        if (selectedCardObject.cardName != GameCardPop && selectedCardObject.cardName != GameCardCut)
        {
            hasPopped = YES;
        }
    }
    else if (isDoublePlayNeeded && !hasCompleteDoublePlay)
    {
        if (selectedCardObject.cardName != GameCardToZeroSecond && selectedCardObject.cardName != GameCardToThirtySecond && selectedCardObject.cardName != GameCardToSixtySecond && selectedCardObject.cardName != GameCardAddFiveSecond && selectedCardObject.cardName != GameCardAddTenSecond)
        {
            hasPopped = YES;
        }
    }
    
    if (isDoublePlayNeeded)
    {
        if (!hasCompleteDoublePlay)
        {
            hasCompleteDoublePlay = YES;
        }
        else
        {
            [self resetDoublePlayFlag];
        }
    }
    
    [self performPostOperation:selectedCardObject hasPopped:hasPopped];
    
}

//GamePlay
- (void)performPostOperation:(AIGameCard *)cardObject hasPopped:(BOOL)hasPopped {
    BOOL isPlayerSkip = NO;
    BOOL hasDonePostOperation = YES;
    
    //check is number card
    if (cardObject.isNumberCard)
    {
        timeCount += cardObject.cardValue;
    }
    else
    {
        if (cardObject.cardName == GameCardDoublePlay)
        {
            isDoublePlayNeeded = YES;
            hasCompleteDoublePlay = NO;
            
            hasGivenWarningForDoublePlay = NO;
        }
        else if (cardObject.cardName == GameCardDrawOne)
        {
            if (!hasPopped)
                [self drawCardsToOtherThreePlayers:1];
        }
        else if (cardObject.cardName == GameCardDrawTwo)
        {
            if (!hasPopped)
                [self drawCardsToOtherThreePlayers:2];
        }
        else if (cardObject.cardName == GameCardPop)
        {
            isBalloonPop = YES;
        }
        else if (cardObject.cardName == GameCardReverse)
        {
            if (isForwardPlay)
                isForwardPlay = NO;
            else
                isForwardPlay = YES;
        }
        else if (cardObject.cardName == GameCardCut)
        {
            timeCount = 0;
            isBalloonPop = NO;
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
        else if (cardObject.cardName == GameCardTradeHand)
        {
            if (!hasPopped)
            {
                if (nextPlayerIDTurn == userID)
                {
                    if ([playerHandArray0 count] > 0)
                    {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Trade Hand" message:@"Select a player to trade hand with the player" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                        alert.tag = 2;
                        
                        for (int i = 1; i <= 3; i++)
                        {
                            if (![self checkPlayerHasLostAllLifeForPlayerId:i])
                            {
                                NSString *tempString = [NSString stringWithFormat:@"Player %i", i];
                                
                                [alert addButtonWithTitle:tempString];
                            }
                        }
                        
                        [alert show];
                        hasDonePostOperation = NO;
                    }
                    else
                    {
                        hasDonePostOperation = YES;
                    }
                }
                else
                {
                    NSMutableArray *tempUserArray = [[NSMutableArray alloc]init];
                    
                    tempUserArray = [self getCurrentPlayerHandArray];
                    
                    if ([tempUserArray count] > 0)
                    {
                        int randomNumber = arc4random_uniform(4);
                        
                        while (randomNumber == nextPlayerIDTurn || [self checkPlayerHasLostAllLifeForPlayerId:randomNumber])
                        {
                            randomNumber = arc4random_uniform(4);
                        }
                        
                        NSMutableArray *tempHandArray = [[NSMutableArray alloc]init];
                        
                        tempHandArray = [self getCurrentPlayerHandArrayForPlayerId:randomNumber];
                        
                        /*
                        if (randomNumber == 0)
                        {
                            tempHandArray = [playerHandArray0 mutableCopy];
                            
                        }
                        else if (randomNumber == 1)
                        {
//                            if (randomNumber == nextPlayerIDTurn)
//                                tempHandArray = [playerHandArray2 mutableCopy];
//                            else
                                tempHandArray = [playerHandArray1 mutableCopy];
                        }
                        else if (randomNumber == 2)
                        {
//                            if (randomNumber == nextPlayerIDTurn)
//                                tempHandArray = [playerHandArray3 mutableCopy];
//                            else
                                tempHandArray = [playerHandArray2 mutableCopy];
                        }
                        else if (randomNumber == 3)
                        {
                            tempHandArray = [playerHandArray3 mutableCopy];
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
                        */
                        
                        NSMutableArray *tempMediumArray  = [[NSMutableArray alloc]init];
                        tempMediumArray = [tempUserArray mutableCopy];
                        
                        tempUserArray = [tempHandArray mutableCopy];
                        
                        tempHandArray = [tempMediumArray mutableCopy];
                        
                        [self assignCurrentPlayerHandArray:tempUserArray forPlayerId:nextPlayerIDTurn];
                        [self assignCurrentPlayerHandArray:tempHandArray forPlayerId:randomNumber];
                        
                        [self assignCurrentPlayerHandArray:tempUserArray];
                    }
                }
                
                [self rearrangeOpponentCardNumberAndViewForPlayerID:nextPlayerIDTurn isRearrangeAllPlayer:YES];
            }
        }

    }
    
    NSLog(@"Player %i discard %@, timecount at %i", nextPlayerIDTurn, [self getCardNameInString:cardObject.cardName], timeCount);
    
    if (hasDonePostOperation)
    {
        [self processPostOperation:isPlayerSkip cardName:cardObject.cardName hasPopped:hasPopped];
    }
}

//GamePlay
- (void)processPostOperation:(BOOL)isPlayerSkip cardName:(AIGameCardName)cardName hasPopped:(BOOL)hasPopped {
    [self animateDiscardGameCardAnimation:isPlayerSkip cardName:cardName hasPopped:hasPopped];
}

//UIView
- (void)animateDiscardGameCardAnimation:(BOOL)isPlayerSkip cardName:(AIGameCardName)cardName hasPopped:(BOOL)hasPopped {
    CGFloat x = (self.view.frame.size.width - 40 - (cardWidth * 2)) / 3;
    x += 20;
    
    CGRect discardDeckFrame = CGRectMake(x, 104, cardWidth, cardHeight);
    
    CGRect playerHandFrame = CGRectZero;
    
    switch (nextPlayerIDTurn)
    {
        case 0:
            playerHandFrame = CGRectMake(30, self.view.frame.size.height - 300, cardWidth, cardHeight);
            break;
            
        case 1:
            playerHandFrame = CGRectMake(-100, self.view.frame.size.height/2 - 100, cardWidth, cardHeight);
            break;
            
        case 2:
            playerHandFrame = CGRectMake(self.view.frame.size.width/2 - 50, -200, cardWidth, cardHeight);
            break;
            
        case 3:
            playerHandFrame = CGRectMake(self.view.frame.size.width, self.view.frame.size.height/2 - 100, cardWidth, cardHeight);
            break;
    }
    
    UIImageView *tempImageView = [[UIImageView alloc]initWithFrame:playerHandFrame];
    tempImageView.image = [AICommonUtils getGameCardImageForGameCard:cardName];
    
    [self.view addSubview:tempImageView];
    
    BOOL timeCountExceedLimit = [self checkIfTimeCountExceedLimit];
    
    if ([self checkIfPlayerIsOutOfCards:NO])
    {
        hasPopped = NO;
        timeCountExceedLimit = NO;
    }
    
    [UIView animateWithDuration:1 animations:^{
        tempImageView.frame = discardDeckFrame;
    }completion:^(BOOL finished)
    {
        [tempImageView removeFromSuperview];
        
        [self showDiscardAndDrawDeck:NO];
        
        [self updateTimeCountAndLifeCount:NO];
        
        if (hasPopped || timeCountExceedLimit)
        {
            [self deductPlayerLifeCountByOne];
            
            [self deductPlayerLifeViewForPlayerID:nextPlayerIDTurn];
            
            if ([self checkPlayerHasLostAllLifeForPlayerId:nextPlayerIDTurn])
            {
                [self discardAllPlayerHandCardsIfPlayerHasLostAllLifeForPlayerId:nextPlayerIDTurn];
            }
        }
        
        if ([self checkIfPlayerIsOutOfCards:YES])
        {
            [self deductOtherPlayersLifeCountByOne];
            
            for (int i = 0; i < 4; i++)
            {
                if (i != nextPlayerIDTurn)
                    [self deductPlayerLifeViewForPlayerID:i];
            }
            
            for (int i = 0; i < 4; i++)
            {
                if ([self checkPlayerHasLostAllLifeForPlayerId:i])
                {
                    [self discardAllPlayerHandCardsIfPlayerHasLostAllLifeForPlayerId:i];
                }
            }
        }
        
        if (hasPopped || timeCountExceedLimit || [self checkIfPlayerIsOutOfCards:NO])
        {
            [self updateTimeCountAndLifeCount:YES];
        }
        
        if (![self checkIfGameIsOver])
        {
            if (hasPopped || timeCountExceedLimit || [self checkIfPlayerIsOutOfCards:NO])
            {
                [self resetDoublePlayFlag];
                
                [self resetTimeCountAndIsBalloonPopFlag];
                
                [self updateTimeCountAndLifeCount:YES];
                
                [self reshuffleDiscardDeckIntoDrawDeck];
                
                [self distributeCardsToPlayers:NO];
                
                [self showPlayerLifeLostPopupMessage];
            }
            else
            {
                [self completeOneProcessOperation:isPlayerSkip];
            }
        }
        else
        {
            [self showGameOverPopupMessage];
        }
    }];
}

//GamePlay
- (void)completeOneProcessOperation:(BOOL)isPlayerSkip {
    [self rearrangePlayerCardView];
    
    [self nextPlayerTurn:isPlayerSkip];
}


#pragma mark - ACTIONS FOR DOUBLE PLAY CONTROLS

//GamePlay
- (void)resetDoublePlayFlag {
    hasCompleteDoublePlay = YES;
    isDoublePlayNeeded = NO;
}


#pragma mark - ACTIONS FOR DEDUCTING LIFE COUNT

//Mechanics
- (BOOL)checkIfTimeCountExceedLimit {
    if (timeCount > 60)
        return YES;
    else
        return NO;
}

//Mechanics
- (BOOL)checkIfPlayerIsOutOfCards:(BOOL)showLogMessage {
    BOOL playerIsOutOfCards = NO;
    
    NSMutableArray *tempArray = [self getCurrentPlayerHandArray];
    
    if (showLogMessage)
        NSLog(@"Player %i has %lu card left", nextPlayerIDTurn, (unsigned long)[tempArray count]);
    
    if ([tempArray count] == 0)
    {
        playerIsOutOfCards = YES;
    }
    
    return playerIsOutOfCards;
}

//GamePlay
- (void)deductPlayerLifeCountByOne {
    NSString *tempCount = [playerLifeCountDictionary objectForKey:[NSString stringWithFormat:@"player%i", nextPlayerIDTurn]];
    int lifeCount = [tempCount intValue] - 1;
    
    if (lifeCount < 0)
        lifeCount = 0;
    
    [playerLifeCountDictionary setObject:[NSString stringWithFormat:@"%i", lifeCount] forKey:[NSString stringWithFormat:@"player%i", nextPlayerIDTurn]];
    
    NSLog(@"player %i LifeCount deducted: %@", nextPlayerIDTurn, playerLifeCountDictionary);
    
    playerLifeLostMessage = [NSString stringWithFormat:@"Player %i has lost this round with a popped balloon!", nextPlayerIDTurn];
    NSLog(@"%@", playerLifeLostMessage);
}

//GamePlay
- (void)deductOtherPlayersLifeCountByOne {
    for (int i = 0; i < 4; i++)
    {
        NSString *tempCount = [playerLifeCountDictionary objectForKey:[NSString stringWithFormat:@"player%i", i]];
        int lifeCount = [tempCount intValue] - 1;
        
        if (lifeCount < 0)
            lifeCount = 0;
        
        [playerLifeCountDictionary setObject:[NSString stringWithFormat:@"%i", lifeCount] forKey:[NSString stringWithFormat:@"player%i", i]];
    }
    
    NSString *tempCount = [playerLifeCountDictionary objectForKey:[NSString stringWithFormat:@"player%i", nextPlayerIDTurn]];
    int lifeCount = [tempCount intValue] + 1;
    
    [playerLifeCountDictionary setObject:[NSString stringWithFormat:@"%i", lifeCount] forKey:[NSString stringWithFormat:@"player%i", nextPlayerIDTurn]];
    
    NSLog(@"other than player %i LifeCount deducted: %@", nextPlayerIDTurn, playerLifeCountDictionary);
    
    playerLifeLostMessage =[NSString stringWithFormat:@"Player %i has won this round by finishing all his cards first!", nextPlayerIDTurn];
    NSLog(@"%@", playerLifeLostMessage);
}

//GamePlay
- (void)resetTimeCountAndIsBalloonPopFlag {
    timeCount = 0;
    isBalloonPop = NO;
}

//UIView
- (void)showPlayerLifeLostPopupMessage {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Popped!" message:playerLifeLostMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.tag = 3;
    [alert show];
}


#pragma mark - ACTIONS FOR PLAYER LOSING ALL LIFE

//GamePlay
- (BOOL)checkPlayerHasLostAllLifeForPlayerId:(int)playerId {
    BOOL hasLostAllLife = NO;
    
    NSString *tempCount = [playerLifeCountDictionary objectForKey:[NSString stringWithFormat:@"player%i", playerId]];
    
    int lifeCount = [tempCount intValue];
    
    if (lifeCount <= 0)
        hasLostAllLife = YES;
    
    return hasLostAllLife;
}

//GamePlay
- (void)discardAllPlayerHandCardsIfPlayerHasLostAllLifeForPlayerId:(int)playerId {
    NSMutableArray *tempArray = [self getCurrentPlayerHandArrayForPlayerId:playerId];
    
    [discardDeckArray addObjectsFromArray:tempArray];
    
    tempArray = [[NSMutableArray alloc]init];
    
    [self assignCurrentPlayerHandArray:tempArray forPlayerId:playerId];
}


#pragma mark - ACTIONS FOR GAME OVER

//GamePlay
- (BOOL)checkIfGameIsOver {
    
    BOOL gameOver = NO;
    
    int tempA, tempB, tempC, tempD;
    tempA = tempB = tempC = tempD = 0;
    
    for (int i = 0; i < 4; i++)
    {
        NSString *tempCount = [playerLifeCountDictionary objectForKey:[NSString stringWithFormat:@"player%i", i]];
        
        switch (i)
        {
            case 0:
                tempA = [tempCount intValue];
                break;
                
            case 1:
                tempB = [tempCount intValue];
                break;
                
            case 2:
                tempC = [tempCount intValue];
                break;
                
            case 3:
                tempD = [tempCount intValue];
                break;
        }
    }
    
    if (self.isGameModeFull)
    {
        if ((tempA == 0 && tempB == 0 && tempC == 0) || (tempA == 0 && tempB == 0 && tempD == 0) || (tempA == 0 && tempC == 0 && tempD == 0) || (tempB == 0 && tempC == 0 && tempD == 0))
        {
            NSString *userName;
            
            if (tempA > 0)
            {
                userName = @"You have ";
            }
            else if (tempB > 0)
            {
                userName = @"Computer 1 has ";
            }
            else if (tempC > 0)
            {
                userName = @"Computer 2 has ";
            }
            else if (tempD > 0)
            {
                userName = @"Computer 3 has ";
            }
            
            gameOverMessage = [NSString stringWithFormat:@"%@won. The game has ended", userName];
            
            gameOver = YES;
        }
    }
    else
    {
        if (tempA == 0 || tempB == 0 || tempC == 0 || tempD == 0)
        {
            NSString *userName;
            
            NSMutableArray *tempArray = [[NSMutableArray alloc]init];
            [tempArray addObject:[NSString stringWithFormat:@"%i", tempA]];
            [tempArray addObject:[NSString stringWithFormat:@"%i", tempB]];
            [tempArray addObject:[NSString stringWithFormat:@"%i", tempC]];
            [tempArray addObject:[NSString stringWithFormat:@"%i", tempD]];
            
            int tempLargest = tempA;
            int index = 0;
            for (int i = 1; i < [tempArray count]; i++)
            {
                if ([[tempArray objectAtIndex:i] intValue] > tempLargest)
                {
                    tempLargest = [[tempArray objectAtIndex:i] intValue];
                    index = i;
                }
            }
            
            if (tempA == 0)
            {
                userName = @"You ";
            }
            else if (tempB == 0)
            {
                userName = @"Computer 1 ";
            }
            else if (tempC == 0)
            {
                userName = @"Computer 2 ";
            }
            else if (tempD == 0)
            {
                userName = @"Computer 3 ";
            }
            
            if (index == 0)
                userName = [NSString stringWithFormat:@"Player 0"];
            else
                userName = [NSString stringWithFormat:@"Computer %i", index];
            
            gameOverMessage = [NSString stringWithFormat:@"%@ has won. The game has ended", userName];
            
            gameOver = YES;
        }
    }
    
    return gameOver;
}

//GamePlay
- (void)showGameOverPopupMessage {
    UIAlertView *alert;
    
    if (self.isGameModeFull)
    {
        alert = [[UIAlertView alloc]initWithTitle:@"Game Over" message:gameOverMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"Leave", nil];
    }
    else
    {
        alert = [[UIAlertView alloc]initWithTitle:@"Game Over" message:gameOverMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"Leave", nil];
    }
    
    alert.tag = 1;
    [alert show];
}


#pragma mark - AIGameCardImageViewDelegate

- (void)tapAtGameCardForId:(NSInteger)cardId arrayIndex:(NSInteger)arrayIndex cardName:(AIGameCardName)cardName {
    NSLog(@"index: %lu, selected %@", (long)arrayIndex, [self getCardNameInString:cardName]);
    
    for (AIGameCardImageView *card in self.view.subviews)
    {
        if ([card isMemberOfClass:[AIGameCardImageView class]] && card.cardId == previousCardId)
        {
            card.frame = CGRectMake(card.frame.origin.x, card.frame.origin.y + 10, card.frame.size.width, card.frame.size.height);
        }
    }
    
    for (AIGameCardImageView *card in self.view.subviews)
    {
        if ([card isMemberOfClass:[AIGameCardImageView class]] && card.cardId == cardId)
        {
            previousCardId = cardId;
            card.frame = CGRectMake(card.frame.origin.x, card.frame.origin.y - 10, card.frame.size.width, card.frame.size.height);
        }
    }
    
    selectedCardIndex = arrayIndex;
}

- (void)didLongPressAtGameCardImageViewForZoom:(UIImageView *)imageView cardId:(NSInteger)cardId cardName:(AIGameCardName)cardName {
    if (!hasDisplayEnlargeView)
    {
        hasDisplayEnlargeView = YES;
        
        CGRect myFrame = self.view.frame;
        myFrame.size.height -= 64;
        GameCardEnlargeView = [[AIGameCardEnlargeView alloc]initWithFrame:CGRectMake(0, 64, myFrame.size.width, myFrame.size.height)];
        GameCardEnlargeView.cardName = cardName;
        GameCardEnlargeView.delegate = self;
        GameCardEnlargeView.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:GameCardEnlargeView];
    }
}


#pragma mark - AIGameCardEnlargeViewDelegate

- (void)didDismissGameCardEnlargeView:(AIGameCardEnlargeView *)myEnlargeView {
    GameCardEnlargeView = nil;
    hasDisplayEnlargeView = NO;
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
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
    else if (alertView.tag == 2)  //player trade hand
    {
        NSString *tempString = [alertView buttonTitleAtIndex:buttonIndex];
        
        tempString = [tempString substringFromIndex:tempString.length - 1];
        
        int tempPlayerId = [tempString intValue];
        
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        tempArray = [playerHandArray0 mutableCopy];
        
        if (tempPlayerId == 1)
        {
            playerHandArray0 = [playerHandArray1 mutableCopy];
            playerHandArray1 = [tempArray mutableCopy];
        }
        else if (tempPlayerId == 2)
        {
            playerHandArray0 = [playerHandArray2 mutableCopy];
            playerHandArray2 = [tempArray mutableCopy];
        }
        else if (tempPlayerId == 3)
        {
            playerHandArray0 = [playerHandArray3 mutableCopy];
            playerHandArray3 = [tempArray mutableCopy];
        }
        
        [self clearAllCardsFromView];
        [self showCardsToScreen];
        
        [self processPostOperation:NO cardName:GameCardTradeHand hasPopped:NO];
    }
    else if (alertView.tag == 3) //player life lost message
    {
        [self completeOneProcessOperation:NO];
    }
    else if (alertView.tag == 5) //set start game flow
    {
        [self nextPlayerTurn:NO];
    }
}

@end
