//
//  PBAdminBingoViewController.h
//  PushBingo
//
//  Created by Takumi Yamamoto on 2013/10/26.
//  Copyright (c) 2013年 Takumi Yamamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBIndicatorView.h"

@interface PBAdminBingoViewController : UIViewController
{
    NSInteger indexNum;
    PBIndicatorView* pbIndicator;
}

- (id)initWithBingoID:(NSString *)bingoId;

@end
