//
//  AIGameCardEnlargeView.m
//  Balloon
//
//  Created by Mun Fai Leong on 4/19/15.
//  Copyright (c) 2015 myAppIndustry. All rights reserved.
//

#import "AIGameCardEnlargeView.h"

UIView *enlargeView;
UIImageView *cardImageView;

@implementation AIGameCardEnlargeView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self createEnlargeView];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        
    }
    
    return self;
}

-(void)createEnlargeView
{
    CGFloat myWidth = self.frame.size.width;
    CGFloat myHeight = self.frame.size.height;
    
    enlargeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, myWidth, myHeight)];
    enlargeView.backgroundColor = [UIColor clearColor];
    enlargeView.alpha = 0;
    
    UIView *tempBackgroundView = [[UIView alloc]initWithFrame:enlargeView.frame];
    tempBackgroundView.backgroundColor = [UIColor colorWithRed:4.0/255.0 green:54.0/255.0 blue:66.0/255.0 alpha:1];
    tempBackgroundView.alpha = 0.7;
    
    cardImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 100, myWidth - 60, (myWidth - 60) * 1.5)];
    cardImageView.image = [AICommonUtils getGameCardImageForGameCard:self.cardName];
    cardImageView.userInteractionEnabled = YES;
    cardImageView.tag = 1;
    
    [enlargeView addSubview:tempBackgroundView];
    [enlargeView addSubview:cardImageView];
    
    [self addSubview:enlargeView];
    
    [UIView animateWithDuration:0.5 animations:^{
        enlargeView.alpha = 1;
    }completion:^(BOOL finished){
        
    }];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [cardImageView addGestureRecognizer:swipe];
    
}

-(void)handleSwipe:(UISwipeGestureRecognizer *)swipeGesture
{
    if (swipeGesture.direction == UISwipeGestureRecognizerDirectionDown)
    {
        if ([self.delegate respondsToSelector:@selector(didDismissGameCardEnlargeView:)])
        {
            [self.delegate didDismissGameCardEnlargeView:self];
        }
    }
}

@end
