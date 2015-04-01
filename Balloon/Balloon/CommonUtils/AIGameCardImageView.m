//
//  AIGameCardImageView.m
//  BalloonPopper
//
//  Created by Mun Fai Leong on 3/12/15.
//  Copyright (c) 2015 myAppIndustry. All rights reserved.
//

#import "AIGameCardImageView.h"

@implementation AIGameCardImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleCardTap)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

-(void)handleCardTap
{
    if ([self.delegate respondsToSelector:@selector(tapAtGameCardForId:arrayIndex:cardName:)])
    {
        [self.delegate tapAtGameCardForId:self.cardId arrayIndex:self.arrayIndex cardName:self.cardName];
    }
}

@end
