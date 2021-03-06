//
//  PBGuestInputIDViewController.h
//  PushBingo
//
//  Created by Takumi Yamamoto on 2013/10/24.
//  Copyright (c) 2013年 Takumi Yamamoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBGuestInputIDViewController : UIViewController<UITextFieldDelegate>
{
    UITextField *tf;
    NSMutableArray* aryJoinGameId;
    NSString* bingoId;
    NSString* userId;
}

-(id)initWithUserId:(NSString *)userid;

@end
