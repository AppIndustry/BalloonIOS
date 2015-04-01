//
//  AIGameSceneViewController.h
//  BalloonPopper
//
//  Created by Mun Fai Leong on 3/8/15.
//  Copyright (c) 2015 myAppIndustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AICommonUtils.h"

@interface AIGameSceneViewController : UIViewController <AIGameCardImageViewDelegate, UIAlertViewDelegate>

@property (nonatomic) BOOL isGameModeFull;

- (IBAction)SubmitCardSelection:(id)sender;

@end
