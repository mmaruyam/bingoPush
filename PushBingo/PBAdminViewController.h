//
//  PBAdminViewController.h
//  PushBingo
//
//  Created by Takumi Yamamoto on 2013/10/16.
//  Copyright (c) 2013年 Takumi Yamamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBIndicatorView.h"

@interface PBAdminViewController : UIViewController
{
    UILabel* labelID;
    UIButton *startBtn;
    UIActivityIndicatorView  *indicator;
    UIView* indicatorView;
    PBIndicatorView* hoge;
}
@end
