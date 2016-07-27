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

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self)
    {
        
    }
    
    return self;
}

- (void)createEnlargeView {
    CGFloat myWidth = self.frame.size.width;
    CGFloat myHeight = self.frame.size.height;
    
    enlargeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, myWidth, myHeight)];
    enlargeView.backgroundColor = [UIColor clearColor];
    enlargeView.alpha = 0;
    
    UIView *tempBackgroundView = [[UIView alloc]initWithFrame:enlargeView.frame];
    tempBackgroundView.backgroundColor = [UIColor colorWithRed:4.0/255.0 green:54.0/255.0 blue:66.0/255.0 alpha:1];
    tempBackgroundView.alpha = 0.7;
    
    cardImageView = [[UIImageView alloc]initWithFrame:CGRectMake(myWidth / 2 - ((myHeight - 100) / 1.5 / 2), 20, (myHeight - 100) / 1.5, myHeight - 100)];
    cardImageView.image = [AICommonUtils getGameCardImageForGameCard:self.cardName];
    cardImageView.userInteractionEnabled = YES;
    cardImageView.tag = 1;
    
    UILabel *instructionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, cardImageView.frame.size.height + cardImageView.frame.origin.y + 20, myWidth - 40, 30)];
    instructionLabel.textAlignment = NSTextAlignmentCenter;
    instructionLabel.textColor = [AICommonUtils getAIColorWithRGB228:1.0];
    instructionLabel.font = [AICommonUtils getCustomTypeface:fontAvenirNextItalic ofSize:12];
    instructionLabel.text = @"Swipe down to dismiss";
    instructionLabel.attributedText = [AICommonUtils createStringWithSpacing:instructionLabel.text spacingValue:4.0 withUnderLine:YES];
    
    [enlargeView addSubview:tempBackgroundView];
    [enlargeView addSubview:cardImageView];
    [enlargeView addSubview:instructionLabel];
    
    [self addSubview:enlargeView];
    
    [UIView animateWithDuration:0.5 animations:^{
        enlargeView.alpha = 1;
    }completion:^(BOOL finished){
        
    }];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    pan.maximumNumberOfTouches = 1;
    [cardImageView addGestureRecognizer:pan];
    
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint velocity = [recognizer velocityInView:recognizer.view];
    CGPoint translation = [recognizer translationInView:recognizer.view];
    
    // Down direction
    if (velocity.y > 0)
    {
        CGRect frame = recognizer.view.frame;
        
        if (frame.origin.y < 0)
            recognizer.view.frame = CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height);
        
        if (recognizer.state == UIGestureRecognizerStateEnded)
        {
            [UIView animateWithDuration:0.25 animations:^
             {
                 recognizer.view.frame = CGRectMake(frame.origin.x, self.superview.frame.size.height, frame.size.width, frame.size.height);
                 self.alpha = 0;
             } completion:^(BOOL finished) {
                 
                 [self removeFromSuperview];
                 
                 if ([self.delegate respondsToSelector:@selector(didDismissGameCardEnlargeView:)])
                 {
                     [self.delegate didDismissGameCardEnlargeView:self];
                 }
             }];
        }
        else
        {
            recognizer.view.center = CGPointMake(recognizer.view.center.x, recognizer.view.center.y + translation.y);
            [recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
        }
    }
    // Up direction
    else
    {
        CGRect frame = recognizer.view.frame;
        
        if (frame.origin.y != 0)
        {
            if (recognizer.state == UIGestureRecognizerStateEnded)
            {
                [UIView animateWithDuration:0.25 animations:^
                 {
                     recognizer.view.frame = CGRectMake(frame.origin.x, 100, frame.size.width, frame.size.height);
                 }];
            }
            else
            {
                if (frame.origin.y - translation.y < 0)
                {
                    recognizer.view.center = CGPointMake(recognizer.view.center.x, recognizer.view.center.y);
                    [recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
                }
                else
                {
                    recognizer.view.center = CGPointMake(recognizer.view.center.x, recognizer.view.center.y + translation.y);
                    [recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
                }
            }
        }
    }
}

@end
