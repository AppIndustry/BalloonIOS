//
//  AIGameMenuViewController.h
//  BalloonPopper
//
//  Created by Mun Fai Leong on 3/8/15.
//  Copyright (c) 2015 myAppIndustry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AIGameMenuViewController : UIViewController <UIActionSheetDelegate>
{
    UIButton *singlePlayerButton, *multiplayerButton;
    
    UILabel *titleLabel, *descriptionLabel;
    
    UIImageView *coverImageView;
}

- (IBAction)SinglePlayerMode:(id)sender;
- (IBAction)MultiplayerMode:(id)sender;

@end
