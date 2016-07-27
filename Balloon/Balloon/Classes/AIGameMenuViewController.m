//
//  AIGameMenuViewController.m
//  BalloonPopper
//
//  Created by Mun Fai Leong on 3/8/15.
//  Copyright (c) 2015 myAppIndustry. All rights reserved.
//

#import "AIGameMenuViewController.h"
#import "AIGameSceneViewController.h"
#import "AppDelegate.h"

@interface AIGameMenuViewController ()
{
    BOOL isGameModeFull, isLocalPlayerAuthenticated;
    int numberIndex;
}
@end

@implementation AIGameMenuViewController

#pragma mark - Override Functions

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    
    [self createView];
    
    [self setInitialDesign];
    
    [self runAnimation];
    
    [self autheticatePlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}


#pragma mark - Initializing View and Design

- (void)createView {
    
    singlePlayerButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 940, (self.view.frame.size.width / 2) - 40, 50)];
    [singlePlayerButton setTitle:@"SINGLE PLAYER" forState:UIControlStateNormal];
    [singlePlayerButton setTitleColor:[AICommonUtils getAIColorWithRGB228:1.0] forState:UIControlStateHighlighted];
    [singlePlayerButton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [singlePlayerButton addTarget:self action:@selector(SinglePlayerMode:) forControlEvents:UIControlEventTouchUpInside];
    singlePlayerButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    multiplayerButton = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width / 2) + 20, 940, (self.view.frame.size.width / 2) - 40, 50)];
    [multiplayerButton setTitle:@"MULTI PLAYER" forState:UIControlStateNormal];
    [multiplayerButton setTitleColor:[AICommonUtils getAIColorWithRGB228:1.0] forState:UIControlStateHighlighted];
    [multiplayerButton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [multiplayerButton addTarget:self action:@selector(MultiplayerMode:) forControlEvents:UIControlEventTouchUpInside];
    multiplayerButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.view addSubview:singlePlayerButton];
    [self.view addSubview:multiplayerButton];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, (self.view.frame.size.height / 2) - 100, self.view.frame.size.width - 40, 44)];
    titleLabel.text = @"Balloon";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [AICommonUtils getAIColorWithRGB228:1.0];
    
    descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, titleLabel.frame.origin.y + titleLabel.frame.size.height + 10, self.view.frame.size.width - 40, 44)];
    descriptionLabel.textColor = [AICommonUtils getAIColorWithRGB228:1.0];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.text = @"Pop the balloon whenever you are\nanytime, anywhere";
    descriptionLabel.numberOfLines = 2;
    
    [self.view addSubview:titleLabel];
    [self.view addSubview:descriptionLabel];
    
    CGFloat difference = (self.view.frame.size.height - 100) - (80 + 44 + 10 + 44);//(descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height);

    coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width / 2) - (((difference - 100) / 1.5) / 2), self.view.frame.size.height, (difference - 100) / 1.5, difference - 100)];
    coverImageView.image = [UIImage imageNamed:@"BalloonLife"];
    
    [self.view addSubview:coverImageView];
}

- (void)setInitialDesign {
    
    titleLabel.font = [AICommonUtils getCustomTypeface:fontZapfino ofSize:24];
    titleLabel.attributedText = [AICommonUtils createStringWithSpacing:titleLabel.text spacingValue:4.0 withUnderLine:NO];
    
    descriptionLabel.font = [AICommonUtils getCustomTypeface:fontAvenirNextUltraLight ofSize:12.0];
    descriptionLabel.attributedText = [AICommonUtils createStringWithSpacing:descriptionLabel.text spacingValue:4.0 withUnderLine:NO];
    
    singlePlayerButton.titleLabel.font = [AICommonUtils getCustomTypeface:fontCourier ofSize:12.0];
    singlePlayerButton.titleLabel.attributedText = [AICommonUtils createStringWithSpacing:singlePlayerButton.titleLabel.text spacingValue:4.0 withUnderLine:NO];
    [singlePlayerButton.layer addSublayer:[AICommonUtils createOneSidedBorderForUIView:singlePlayerButton Side:BorderBottom]];
    
    multiplayerButton.titleLabel.font = [AICommonUtils getCustomTypeface:fontCourier ofSize:12.0];
    multiplayerButton.titleLabel.attributedText = [AICommonUtils createStringWithSpacing:multiplayerButton.titleLabel.text spacingValue:4.0 withUnderLine:NO];
    [multiplayerButton.layer addSublayer:[AICommonUtils createOneSidedBorderForUIView:multiplayerButton Side:BorderBottom]];
}

- (void)runAnimation {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, 80, titleLabel.frame.size.width, titleLabel.frame.size.height);
        
        descriptionLabel.frame = CGRectMake(descriptionLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height + 10, descriptionLabel.frame.size.width, descriptionLabel.frame.size.height);
        
    }completion:^(BOOL finished){
        
        [UIView animateWithDuration:0.5 animations:^{
            
            multiplayerButton.frame = CGRectMake(multiplayerButton.frame.origin.x, self.view.frame.size.height - 100, multiplayerButton.frame.size.width, multiplayerButton.frame.size.height);
            
            singlePlayerButton.frame = CGRectMake(singlePlayerButton.frame.origin.x, self.view.frame.size.height - 100, singlePlayerButton.frame.size.width, singlePlayerButton.frame.size.height);
            
            coverImageView.frame = CGRectMake(coverImageView.frame.origin.x, descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + 50, coverImageView.frame.size.width, coverImageView.frame.size.height);
            
        }completion:^(BOOL finished){

            numberIndex = 0;
            [self runCardSwitchingAnimation];
        }];
    }];
}

- (void)runCardSwitchingAnimation {
    
    UIImage *tempImage = [UIImage imageNamed:@"BalloonLife"];
    
    if (numberIndex < 13) {
        
        AIGameCardName name = numberIndex;
        tempImage = [AICommonUtils getGameCardImageForGameCard:name];
    }
        
    [UIView animateWithDuration:0.5 animations:^{
        coverImageView.alpha = 0;
        
    }completion:^(BOOL finished){
        [UIView animateWithDuration:0.5 animations:^{
            coverImageView.image = tempImage;
            coverImageView.alpha = 1;
        }completion:^(BOOL finished){
            
        }];
    }];
    
    numberIndex++;
    
    if (numberIndex == 13) {
        numberIndex = 0;
    }
    
    [self performSelector:@selector(runCardSwitchingAnimation) withObject:nil afterDelay:1];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"NextToGame"]) {
        
        AIGameSceneViewController * gamescene = [segue destinationViewController];
        gamescene.isGameModeFull = isGameModeFull;
    }
}


#pragma mark - IBActions

- (IBAction)SinglePlayerMode:(id)sender {
    
    if (isLocalPlayerAuthenticated) {
        [self performSegueWithIdentifier:@"singlePlayerSelection" sender:self];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Unauthenticated" message:@"You are not login to the Game Center" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *login = [UIAlertAction actionWithTitle:@"Login" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self autheticatePlayer];
        }];
        
        [alert addAction:login];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)MultiplayerMode:(id)sender {
    
}


#pragma mark - Game Center Authentication

- (void)autheticatePlayer {
    
    __weak typeof(self) weakSelf = self; // removes retain cycle error
    
    localPlayer = [GKLocalPlayer localPlayer]; // localPlayer is the public GKLocalPlayer
    __weak GKLocalPlayer *weakPlayer = localPlayer; // removes retain cycle error
    
    weakPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        
        if (viewController != nil) {
            [weakSelf showAuthenticationDialogWhenReasonable:viewController];
        }
        else if (weakPlayer.isAuthenticated) {
            [weakSelf authenticatedPlayer:weakPlayer];
        }
        else {
            NSLog(@"error: %@", error);
            
            [weakSelf disableGameCenter];
        }
    };
}

- (void)showAuthenticationDialogWhenReasonable:(UIViewController *)controller {
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:controller animated:YES completion:nil];
}

- (void)authenticatedPlayer:(GKLocalPlayer *)player {
    NSLog(@"authenticated");
    isLocalPlayerAuthenticated = YES;
    localPlayer = player;
}

- (void)disableGameCenter {
    
}


@end
