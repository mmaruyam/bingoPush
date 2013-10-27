//
//  PBGuestInputIDViewController.m
//  PushBingo
//
//  Created by Takumi Yamamoto on 2013/10/24.
//  Copyright (c) 2013年 Takumi Yamamoto. All rights reserved.
//

#import "PBGuestInputIDViewController.h"
#import "PBGuestTopViewController.h"

@interface PBGuestInputIDViewController ()

@end

@implementation PBGuestInputIDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250)/2, 160, 250, 30)];
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.textColor = [UIColor blueColor];
    tf.placeholder = @"ビンゴIDを入力してください";
    tf.clearButtonMode = UITextFieldViewModeAlways;
    // 編集終了後フォーカスが外れた時にhogeメソッドを呼び出す
//    [tf addTarget:self action:@selector(hoge:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:tf];
    
    UIButton *adminBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    adminBtn.frame = CGRectMake((self.view.frame.size.width - 100)/2, 210, 100, 40);
    [adminBtn setTitle:@"完了" forState:UIControlStateNormal];
    adminBtn.tag = 1;
    [adminBtn addTarget:self action:@selector(tapDoneButton:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:adminBtn];
    
}

-(void)tapDoneButton:(id)sender
{
    PBGuestTopViewController* pbGtopCon = [[PBGuestTopViewController alloc] init];
    [pbGtopCon setTitle:@"ビンゴページ"];
    [self.navigationController pushViewController:pbGtopCon animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
