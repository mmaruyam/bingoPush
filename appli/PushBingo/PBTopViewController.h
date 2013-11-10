//
//  PBTopViewController.h
//  PushBingo
//
//  Created by Takumi Yamamoto on 2013/10/16.
//  Copyright (c) 2013年 Takumi Yamamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import <iAd/iAd.h>

@interface PBTopViewController : UIViewController <GADBannerViewDelegate , ADBannerViewDelegate>
{
    UIButton* buttonLoginLogout;
    UILabel* welcome;
    
    NSString* facebookId;
    NSString* facebookName;
    
    UIButton *adminBtn;
    UIButton *guestBtn;
    
    /* AD 関連 */
    GADBannerView *bannerView_;
    ADBannerView *iAdBannerView;
    
    BOOL isLogin;
    
}



@end
