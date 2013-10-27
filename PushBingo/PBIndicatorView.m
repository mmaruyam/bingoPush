//
//  PBIndicatorView.m
//  PushBingo
//
//  Created by Takumi Yamamoto on 2013/10/26.
//  Copyright (c) 2013年 Takumi Yamamoto. All rights reserved.
//

#import "PBIndicatorView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PBIndicatorView

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        
        UIView* indicatorView = [[UIView alloc] initWithFrame:CGRectMake(120,210,60,60)];
        indicatorView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
        
        indicatorView.layer.cornerRadius = 6;
        indicatorView.clipsToBounds = true;
        
        [self addSubview:indicatorView];
        
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.frame = CGRectMake(10,10,40,40);
        [indicatorView addSubview:indicator];
        
    }
    return self;
}

- (void)startIndicator
{
    [indicator startAnimating];
}

- (void)stopIndicator
{
    [indicator stopAnimating];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
