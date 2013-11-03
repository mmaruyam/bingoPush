//
//  PBGuestBingoViewController.h
//  PushBingo
//
//  Created by Takumi Yamamoto on 2013/10/16.
//  Copyright (c) 2013年 Takumi Yamamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBIndicatorView.h"

@interface PBGuestBingoViewController : UIViewController
{
    NSMutableArray* maryBingoMasu;
    NSInteger iBingo;
    NSInteger iReach;
    UILabel* label;
    NSDictionary* dicMasuData;
    NSTimer *timerBingoChecker;
    NSString* strBingoId;
    NSArray* aryPullNumber;
    BOOL isReachAlert;
    PBIndicatorView* pbIndicator;
}

@property (nonatomic) BOOL isLoad;

- (id)initWithBingoId:(NSString *)bingoId;

@end
