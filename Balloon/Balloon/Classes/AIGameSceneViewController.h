//
//  AIGameSceneViewController.h
//  BalloonPopper
//
//  Created by Mun Fai Leong on 3/8/15.
//  Copyright (c) 2015 myAppIndustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AICommonUtils.h"
#import <GameKit/GameKit.h>

@interface AIGameSceneViewController : UIViewController <AIGameCardImageViewDelegate, UIAlertViewDelegate, AIGameCardEnlargeViewDelegate>

@property (nonatomic) BOOL isGameModeFull;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;


- (IBAction)SubmitCardSelection:(id)sender;

@end
