//
//  AISinglePlayerSelectionViewController.m
//  Balloon
//
//  Single Player Mode
//  Allows user to choose between short or long game mode
//
//  Created by Mun Fai Leong on 5/17/15.
//  Copyright (c) 2015 myAppIndustry. All rights reserved.
//

#import "AISinglePlayerSelectionViewController.h"
#import "AICommonUtils.h"
#import "AIGameSceneViewController.h"

@interface AISinglePlayerSelectionViewController ()
{
    UIButton *fullGameButton, *shortGameButton;
    
    UILabel *fullGameDescriptionLabel, *shortGameDescriptionLabel;
    
    BOOL isGameModeFull;
}
@end

@implementation AISinglePlayerSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Single Player";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [self createView];
    
    [self setInitialDesign];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"NextToSinglePlayerGame"])
    {
        AIGameSceneViewController *gamescene = [segue destinationViewController];
        gamescene.isGameModeFull = isGameModeFull;
    }
}


#pragma mark - Initialize View

- (void)createView {
    fullGameButton = [[UIButton alloc]initWithFrame:CGRectMake(60, self.view.frame.size.height / 4, self.view.frame.size.width - 120, 44)];
    [fullGameButton setTintColor:[UIColor clearColor]];
    [fullGameButton setTitle:@"FULL GAME MODE" forState:UIControlStateNormal];
    [fullGameButton setTitleColor:[AICommonUtils getAIColorWithRGB228:1.0] forState:UIControlStateHighlighted];
    [fullGameButton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [fullGameButton.layer addSublayer:[AICommonUtils createOneSidedBorderForUIView:fullGameButton Side:BorderBottom]];
    [fullGameButton addTarget:self action:@selector(fullGameMode:) forControlEvents:UIControlEventTouchUpInside];
    fullGameButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    shortGameButton = [[UIButton alloc]initWithFrame:CGRectMake(60, (self.view.frame.size.height / 4) * 2, self.view.frame.size.width - 120, 44)];
    [shortGameButton setTintColor:[UIColor clearColor]];
    [shortGameButton setTitle:@"SHORT GAME MODE" forState:UIControlStateNormal];
    [shortGameButton setTitleColor:[AICommonUtils getAIColorWithRGB228:1.0] forState:UIControlStateHighlighted];
    [shortGameButton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [shortGameButton.layer addSublayer:[AICommonUtils createOneSidedBorderForUIView:shortGameButton Side:BorderBottom]];
    [shortGameButton addTarget:self action:@selector(shortGameMode:) forControlEvents:UIControlEventTouchUpInside];
    shortGameButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.view addSubview:fullGameButton];
    [self.view addSubview:shortGameButton];
    
    fullGameDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, fullGameButton.frame.origin.y + fullGameButton.frame.size.height + 20, self.view.frame.size.width - 80, 100)];
    fullGameDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    fullGameDescriptionLabel.textColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1.0];
    fullGameDescriptionLabel.numberOfLines = 0;
    
    
    shortGameDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, shortGameButton.frame.origin.y + shortGameButton.frame.size.height + 20, self.view.frame.size.width - 80, 100)];
    shortGameDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    shortGameDescriptionLabel.textColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1.0];
    shortGameDescriptionLabel.numberOfLines = 0;
    
    [self.view addSubview:shortGameDescriptionLabel];
    [self.view addSubview:fullGameDescriptionLabel];
}

- (void)setInitialDesign {
    fullGameButton.titleLabel.font = [AICommonUtils getCustomTypeface:fontCourier ofSize:12];
    fullGameButton.titleLabel.attributedText = [AICommonUtils createStringWithSpacing:fullGameButton.titleLabel.text spacingValue:4.0 withUnderLine:NO];
    
    shortGameButton.titleLabel.font = [AICommonUtils getCustomTypeface:fontCourier ofSize:12];
    shortGameButton.titleLabel.attributedText = [AICommonUtils createStringWithSpacing:shortGameButton.titleLabel.text spacingValue:4.0 withUnderLine:NO];
    
    fullGameDescriptionLabel.font = [AICommonUtils getCustomTypeface:fontAvenirLight ofSize:12.0];
    fullGameDescriptionLabel.text = @"Player wins when all other players have lost all remaining life balloon.";
    fullGameDescriptionLabel.attributedText = [AICommonUtils createStringWithSpacing:fullGameDescriptionLabel.text spacingValue:2.0 withUnderLine:NO];
    
    shortGameDescriptionLabel.font = [AICommonUtils getCustomTypeface:fontAvenirLight ofSize:12.0];
    shortGameDescriptionLabel.text = @"When a player losses all his remaining life balloon, other player with the most number of remaining life balloon win.\n\nIf in any situation two (2) players have the same amount of remaining life balloon, player with the least cumulative card value in his hand wins.";
    shortGameDescriptionLabel.attributedText = [AICommonUtils createStringWithSpacing:shortGameDescriptionLabel.text spacingValue:2.0 withUnderLine:NO];
    
    [fullGameDescriptionLabel sizeToFit];
    [shortGameDescriptionLabel sizeToFit];
    
    fullGameDescriptionLabel.frame = CGRectMake((self.view.frame.size.width - fullGameDescriptionLabel.frame.size.width) /2, fullGameDescriptionLabel.frame.origin.y, fullGameDescriptionLabel.frame.size.width, fullGameDescriptionLabel.frame.size.height);
}


- (void)fullGameMode:(UIButton *)button {
    isGameModeFull = YES;
    
    [self performSegueWithIdentifier:@"NextToSinglePlayerGame" sender:self];
}

- (void)shortGameMode:(UIButton *)button {
    isGameModeFull = NO;
    
    [self performSegueWithIdentifier:@"NextToSinglePlayerGame" sender:self];
}

@end
