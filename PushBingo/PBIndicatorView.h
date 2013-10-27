//
//  PBIndicatorView.h
//  PushBingo
//
//  Created by Takumi Yamamoto on 2013/10/26.
//  Copyright (c) 2013年 Takumi Yamamoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBIndicatorView : UIView
{
    UIActivityIndicatorView* indicator;
}

- (void)startIndicator;
- (void)stopIndicator;

@end
