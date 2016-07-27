//
//  AIGameCardEnlargeView.h
//  Balloon
//
//  Created by Mun Fai Leong on 4/19/15.
//  Copyright (c) 2015 myAppIndustry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AICommonUtils.h"

@protocol AIGameCardEnlargeViewDelegate;


@interface AIGameCardEnlargeView : UIView

@property (nonatomic) AIGameCardName cardName;

@property (nonatomic, assign) IBOutlet id <AIGameCardEnlargeViewDelegate> delegate;


@end


@protocol AIGameCardEnlargeViewDelegate <NSObject>

@required

- (void)didDismissGameCardEnlargeView:(AIGameCardEnlargeView *)myEnlargeView;

@end