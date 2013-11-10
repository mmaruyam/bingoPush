//
//  PBTopViewController.h
//  PushBingo
//
//  Created by Takumi Yamamoto on 2013/10/16.
//  Copyright (c) 2013年 Takumi Yamamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

@interface PBTopViewController : UIViewController <GADBannerViewDelegate>
{
    UIButton* buttonLoginLogout;
    UILabel* welcome;
    
    NSString* facebookId;
    NSString* facebookName;
    
    GADBannerView *bannerView_;
    
}



@end
